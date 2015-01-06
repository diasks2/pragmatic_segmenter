# -*- encoding : utf-8 -*-

module PragmaticSegmenter
  # This is an opinionated class that removes errant newlines,
  # xhtml, inline formatting, etc.
  class Cleaner
    # Rubular: http://rubular.com/r/ENrVFMdJ8v
    HtmlTagRule = Rule.new(/<\/?[^>]*>/, '')

    # Rubular: http://rubular.com/r/XZVqMPJhea
    EscapedHtmlTagRule = Rule.new(/&lt;\/?[^gt;]*gt;/, '')

    # Rubular: http://rubular.com/r/V57WnM9Zut
    NewLineInMiddleOfWordRule = Rule.new(/\n(?=[a-zA-Z]{1,2}\n)/, '')

    # Rubular: http://rubular.com/r/N4kPuJgle7
    JA_NewLineInMiddleOfWord = Rule.new(/(?<=の)\n(?=\S)/, '')

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

    QuotationsFirstRule = Rule.new(/''/, '"')
    QuotationsSecondRule = Rule.new(/``/, '"')

    EN_QuotationsRule = Rule.new(/`/, "'")

    attr_reader :text, :language, :doc_type
    def initialize(text:, **args)
      @text = Text.new(text)
      @language = args[:language]
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
      clean_text = remove_all_newlines(text)
      clean_text = clean_text.apply(DoubleNewLineWithSpaceRule).
                              apply(DoubleNewLineRule)

      clean_text = replace_newlines(clean_text)
      clean_text = clean_text.apply(HtmlTagRule).
                              apply(EscapedHtmlTagRule).
                              apply(InlineFormattingRule).
                              apply(QuotationsFirstRule).
                              apply(QuotationsSecondRule)

      clean_text = clean_text.apply(EN_QuotationsRule) if language.eql?('en')
      clean_text.apply(TableOfContentsRule).apply(ConsecutivePeriodsRule)
    end

    private

    def remove_all_newlines(txt)
      clean_text = remove_newline_in_middle_of_sentence(txt)
      clean_text = clean_text.apply(NewLineInMiddleOfWordRule)
      clean_text = clean_text.apply(JA_NewLineInMiddleOfWord) if language.eql?('ja')
      clean_text
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

    def replace_newlines(txt)
      if doc_type.eql?('pdf')
        txt.apply(NewLineFollowedByBulletRule).
            apply(PDF_NewLineInMiddleOfSentenceRule).
            apply(PDF_NewLineInMiddleOfSentenceNoSpacesRule)
      else
        txt.apply(NewLineFollowedByPeriodRule).
                  gsub(/\n/, "\r") # FIXME: CONVERT TO RULE!
      end
    end
  end
end
