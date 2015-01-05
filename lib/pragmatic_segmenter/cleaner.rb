# -*- encoding : utf-8 -*-

module PragmaticSegmenter
  class Cleaner
    # Rubular: http://rubular.com/r/ENrVFMdJ8v
    HTML_TAG_REGEX = /<\/?[^>]*>/

    # Rubular: http://rubular.com/r/XZVqMPJhea
    ESCAPED_HTML_TAG_REGEX = /&lt;\/?[^gt;]*gt;/

    # Rubular: http://rubular.com/r/V57WnM9Zut
    NEWLINE_IN_MIDDLE_OF_WORD_REGEX = /\n(?=[a-zA-Z]{1,2}\n)/

    # Rubular: http://rubular.com/r/N4kPuJgle7
    NEWLINE_IN_MIDDLE_OF_WORD_JA_REGEX = /(?<=の)\n(?=\S)/

    # Rubular: http://rubular.com/r/3GiRiP2IbD
    NEWLINE_IN_MIDDLE_OF_SENTENCE_REGEX = /(?<=\s)\n(?=([a-z]|\())/

    # Rubular: http://rubular.com/r/UZAVcwqck8
    NEWLINE_IN_MIDDLE_OF_SENTENCE_PDF_REGEX = /(?<=[^\n]\s)\n(?=\S)/

    # Rubular: http://rubular.com/r/eaNwGavmdo
    NEWLINE_IN_MIDDLE_OF_SENTENCE_PDF_NO_SPACES_REGEX = /\n(?=[a-z])/

    # Rubular: http://rubular.com/r/bAJrhyLNeZ
    INLINE_FORMATTING_REGEX = /\{b\^&gt;\d*&lt;b\^\}|\{b\^>\d*<b\^\}/

    # Rubular: http://rubular.com/r/dMxp5MixFS
    DOUBLE_NEWLINE_WITH_SPACE_REGEX = /\n \n/

    # Rubular: http://rubular.com/r/H6HOJeA8bq
    DOUBLE_NEWLINE_REGEX = /\n\n/

    # Rubular: http://rubular.com/r/Gn18aAnLdZ
    NEWLINE_FOLLOWED_BY_BULLET_REGEX = /\n(?=•)/

    # Rubular: http://rubular.com/r/FseyMiiYFT
    NEWLINE_FOLLOWED_BY_PERIOD_REGEX = /\n(?=\.(\s|\n))/

    attr_reader :language, :doc_type
    def initialize(text:, **args)
      @text = text.dup
      @language = args[:language]
      @doc_type = args[:doc_type]
    end

    def clean
      return unless @text
      remove_errant_newlines
      @text = replace_double_newlines(@text)
      @text = replace_newlines(@text)
      @text = strip_html(@text)
      @text = strip_other_inline_formatting(@text)
      @text = clean_quotations(@text)
      @text = clean_quotations_en(@text) if language.eql?('en')
      clean_table_of_contents
      @text
    end

    private

    def remove_errant_newlines
      newline_check(/^(?:[^\.])*/)
      newline_check(/\.(?:[^\.])*/)
      @text = remove_newline_in_middle_of_word(@text)
      @text = remove_newline_in_middle_of_word_ja(@text) if language.eql?('ja')
    end

    def remove_newline_in_middle_of_word(txt)
      txt.gsub(NEWLINE_IN_MIDDLE_OF_WORD_REGEX, '')
    end

    def remove_newline_in_middle_of_word_ja(txt)
      txt.gsub(NEWLINE_IN_MIDDLE_OF_WORD_JA_REGEX, '')
    end

    def newline_check(regex)
      @text.dup.gsub!(regex) do |match|
        next unless match.include?("\n")
        orig = match.dup
        match.gsub!(NEWLINE_IN_MIDDLE_OF_SENTENCE_REGEX, '')
        @text.gsub!(/#{Regexp.escape(orig)}/, "#{match}")
      end
    end

    def strip_html(txt)
      txt.gsub(HTML_TAG_REGEX, '').gsub(ESCAPED_HTML_TAG_REGEX, '')
    end

    def strip_other_inline_formatting(txt)
      txt.gsub(INLINE_FORMATTING_REGEX, '')
    end

    def replace_double_newlines(txt)
      txt.gsub(DOUBLE_NEWLINE_WITH_SPACE_REGEX, "\r")
        .gsub(DOUBLE_NEWLINE_REGEX, "\r")
    end

    def replace_newlines(txt)
      if doc_type.eql?('pdf')
        txt = remove_pdf_line_breaks(txt)
      else
        txt = txt.gsub(NEWLINE_FOLLOWED_BY_PERIOD_REGEX, '')
          .gsub(/\n/, "\r")
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

    def clean_quotations_en(txt)
      txt.gsub(/`/, "'")
    end

    def clean_table_of_contents
      # Rubular: http://rubular.com/r/8mc1ArOIGy
      @text.gsub!(/\.{5,}\s*\d+-*\d*/, "\r")
      # Rubular: http://rubular.com/r/DwNSuZrNtk
      @text.gsub!(/\.{5,}/, ' ')
    end
  end
end
