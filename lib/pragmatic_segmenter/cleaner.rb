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
    NEWLINE_IN_MIDDLE_OF_SENTENCE_PDF_REGEX = /(?<=[^\n]\s)\n(?=\S)/

    # Rubular: http://rubular.com/r/eaNwGavmdo
    NEWLINE_IN_MIDDLE_OF_SENTENCE_PDF_NO_SPACES_REGEX = /\n(?=[a-z])/

    # Rubular: http://rubular.com/r/bAJrhyLNeZ
    InlineFormattingRule = Rule.new(/\{b\^&gt;\d*&lt;b\^\}|\{b\^>\d*<b\^\}/, '')

    # Rubular: http://rubular.com/r/dMxp5MixFS
    DOUBLE_NEWLINE_WITH_SPACE_REGEX = /\n \n/

    # Rubular: http://rubular.com/r/H6HOJeA8bq
    DOUBLE_NEWLINE_REGEX = /\n\n/

    # Rubular: http://rubular.com/r/Gn18aAnLdZ
    NEWLINE_FOLLOWED_BY_BULLET_REGEX = /\n(?=•)/

    # Rubular: http://rubular.com/r/FseyMiiYFT
    NEWLINE_FOLLOWED_BY_PERIOD_REGEX = /\n(?=\.(\s|\n))/

    # Rubular: http://rubular.com/r/8mc1ArOIGy
    TableOfContentsRule = Rule.new(/\.{5,}\s*\d+-*\d*/, "\r")

    # Rubular: http://rubular.com/r/DwNSuZrNtk
    ConsecutivePeriodsRule = Rule.new(/\.{5,}/, ' ')

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
      @clean_text = replace_double_newlines(@clean_text)
      @clean_text = replace_newlines(@clean_text)
      @clean_text = @clean_text.apply(HtmlRules::All)
      @clean_text = @clean_text.apply(InlineFormattingRule)
      @clean_text = clean_quotations(@clean_text)
      @clean_text = clean_table_of_contents(@clean_text)
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

    def replace_double_newlines(txt)
      txt.gsub(DOUBLE_NEWLINE_WITH_SPACE_REGEX, "\r")
        .gsub(DOUBLE_NEWLINE_REGEX, "\r")
    end

    def replace_newlines(txt)
      if doc_type.eql?('pdf')
        txt = remove_pdf_line_breaks(txt)
      else
        txt =
          txt.gsub(NEWLINE_FOLLOWED_BY_PERIOD_REGEX, '').gsub(/\n/, "\r")
      end
      txt
    end

    def remove_pdf_line_breaks(txt)
      txt.gsub(NEWLINE_FOLLOWED_BY_BULLET_REGEX, "\r")
        .gsub(NEWLINE_IN_MIDDLE_OF_SENTENCE_PDF_REGEX, '')
        .gsub(NEWLINE_IN_MIDDLE_OF_SENTENCE_PDF_NO_SPACES_REGEX, ' ')
    end

    def clean_quotations(txt)
      txt.gsub(/''/, '"').gsub(/``/, '"')
    end

    def clean_table_of_contents(txt)
      txt.apply(TableOfContentsRule).apply(ConsecutivePeriodsRule)
    end
  end
end
