# -*- encoding : utf-8 -*-

module PragmaticSegmenter
  module Rules
    module HtmlRules
      # Rubular: http://rubular.com/r/ENrVFMdJ8v
      HTMLTagRule = Rule.new(/<\/?[^>]*>/, '')

      # Rubular: http://rubular.com/r/XZVqMPJhea
      EscapedHTMLTagRule = Rule.new(/&lt;\/?[^gt;]*gt;/, '')

      All = [HTMLTagRule, EscapedHTMLTagRule]
    end
  end

  # This is an opinionated class that removes errant newlines,
  # xhtml, inline formatting, etc.
  class Cleaner
    include Rules
    # Rubular: http://rubular.com/r/V57WnM9Zut
    NewLineInMiddleOfWordRule = Rule.new(/\n(?=[a-zA-Z]{1,2}\n)/, '')

    # Rubular: http://rubular.com/r/3GiRiP2IbD
    NEWLINE_IN_MIDDLE_OF_SENTENCE_REGEX = /(?<=\s)\n(?=([a-z]|\())/

    # Rubular: http://rubular.com/r/UZAVcwqck8
    PDF_NewLineInMiddleOfSentenceRule = Rule.new(/(?<=[^\n]\s)\n(?=\S)/, '')

    # Rubular: http://rubular.com/r/eaNwGavmdo
    PDF_NewLineInMiddleOfSentenceNoSpacesRule = Rule.new(/\n(?=[a-z])/, ' ')

    # Rubular: http://rubular.com/r/bAJrhyLNeZ
    InlineFormattingRule = Rule.new(/\{b\^&gt;\d*&lt;b\^\}|\{b\^>\d*<b\^\}/, '')

    # Rubular: http://rubular.com/r/dMxp5MixFS
    DoubleNewLineWithSpaceRule = Rule.new(/\n \n/, "\r")

    # Rubular: http://rubular.com/r/H6HOJeA8bq
    DoubleNewLineRule = Rule.new(/\n\n/, "\r")

    # Rubular: http://rubular.com/r/Gn18aAnLdZ
    NewLineFollowedByBulletRule = Rule.new(/\n(?=•)/, "\r")

    # Rubular: http://rubular.com/r/FseyMiiYFT
    NewLineFollowedByPeriodRule = Rule.new(/\n(?=\.(\s|\n))/, '')

    # Rubular: http://rubular.com/r/8mc1ArOIGy
    TableOfContentsRule = Rule.new(/\.{5,}\s*\d+-*\d*/, "\r")

    # Rubular: http://rubular.com/r/DwNSuZrNtk
    ConsecutivePeriodsRule = Rule.new(/\.{5,}/, ' ')

    # Rubular: http://rubular.com/r/IQ4TPfsbd8
    ConsecutiveForwardSlashRule = Rule.new(/\/{3}/, '')

    EscapedCarriageReturnRule = Rule.new(/\\r/, "\r")
    TypoEscapedCarriageReturnRule = Rule.new(/\\\ r/, "\r")

    EscapedNewLineRule = Rule.new(/\\n/, "\n")
    TypoEscapedNewLineRule = Rule.new(/\\\ n/, "\n")

    ReplaceNewlineWithCarriageReturnRule = Rule.new(/\n/, "\r")

    QuotationsFirstRule = Rule.new(/''/, '"')
    QuotationsSecondRule = Rule.new(/``/, '"')

    attr_reader :text, :doc_type
    def initialize(text:, **args)
      @text = Text.new(text.dup)
      @doc_type = args[:doc_type]
    end

    # Clean text of unwanted formatting
    #
    # Example:
    #   >> text = "This is a sentence\ncut off in the middle because pdf."
    #   >> PragmaticSegmenter::Cleaner(text: text).clean
    #   => "This is a sentence cut off in the middle because pdf."
    #
    # Arguments:
    #    text:       (String)  *required
    #    language:   (String)  *optional
    #                (two-digit ISO 639-1 code e.g. 'en')
    #    doc_type:   (String)  *optional
    #                (e.g. 'pdf')

    def clean
      return unless text
      @clean_text = remove_all_newlines(text)
      replace_double_newlines(@clean_text)
      replace_newlines(@clean_text)
      replace_escaped_newlines(@clean_text)
      @clean_text.apply(HtmlRules::All)
      @clean_text.apply(InlineFormattingRule)
      clean_quotations(@clean_text)
      clean_table_of_contents(@clean_text)
      clean_consecutive_characters(@clean_text)
    end

    private

    def remove_all_newlines(txt)
      clean_text = remove_newline_in_middle_of_sentence(txt)
      remove_newline_in_middle_of_word(clean_text)
    end

    def remove_newline_in_middle_of_sentence(txt)
      txt.dup.gsub!(/(?:[^\.])*/) do |match|
        next unless match.include?("\n")
        orig = match.dup
        match.gsub!(NEWLINE_IN_MIDDLE_OF_SENTENCE_REGEX, '')
        txt.gsub!(/#{Regexp.escape(orig)}/, "#{match}")
      end
      txt
    end

    def remove_newline_in_middle_of_word(txt)
      txt.apply(NewLineInMiddleOfWordRule)
    end

    def replace_escaped_newlines(txt)
      txt.apply(EscapedNewLineRule).
          apply(EscapedCarriageReturnRule).
          apply(TypoEscapedNewLineRule).
          apply(TypoEscapedCarriageReturnRule)
    end

    def replace_double_newlines(txt)
      txt.apply(DoubleNewLineWithSpaceRule).
          apply(DoubleNewLineRule)
    end

    def replace_newlines(txt)
      if doc_type.eql?('pdf')
        remove_pdf_line_breaks(txt)
      else
        txt.apply(NewLineFollowedByPeriodRule).
            apply(ReplaceNewlineWithCarriageReturnRule)
      end
    end

    def remove_pdf_line_breaks(txt)
      txt.apply(NewLineFollowedByBulletRule).
          apply(PDF_NewLineInMiddleOfSentenceRule).
          apply(PDF_NewLineInMiddleOfSentenceNoSpacesRule)
    end

    def clean_quotations(txt)
      txt.apply(QuotationsFirstRule).
          apply(QuotationsSecondRule)
    end

    def clean_table_of_contents(txt)
      txt.apply(TableOfContentsRule).
          apply(ConsecutivePeriodsRule).
          apply(ConsecutiveForwardSlashRule)
    end

    def clean_consecutive_characters(txt)
      txt.apply(ConsecutivePeriodsRule).
          apply(ConsecutiveForwardSlashRule)
    end
  end
end
