# -*- encoding : utf-8 -*-

module PragmaticSegmenter
  class Cleaner
    # Rubular: http://rubular.com/r/ENrVFMdJ8v
    HTML_TAG_CATCHER = /<\/?[^>]*>/
    # Rubular: http://rubular.com/r/XZVqMPJhea
    ESCAPED_HTML_TAG_CATCHER = /&lt;\/?[^gt;]*gt;/

    attr_reader :language, :doc_type
    def initialize(text:, **args)
      @text = text.dup
      @language = args[:language]
      @doc_type = args[:doc_type]
    end

    def clean
      return unless @text
      remove_errant_newlines
      replace_newlines
      strip_html
      strip_other_inline_formatting
      clean_quotations
      clean_table_of_contents
      @text
    end

    private

    def remove_errant_newlines
      newline_check(/^(?:[^\.])*/)
      newline_check(/\.(?:[^\.])*/)
      # Rubular: http://rubular.com/r/V57WnM9Zut
      @text.gsub!(/\n(?=[a-zA-Z]{1,2}\n)/, '')
      # Rubular: http://rubular.com/r/N4kPuJgle7
      @text.gsub!(/(?<=の)\n(?=\S)/, '') if language.eql?('ja')
    end

    def newline_check(regex)
      @text.dup.gsub!(regex) do |match|
        next unless match.include?("\n")
        orig = match.dup
        # Rubular: http://rubular.com/r/3GiRiP2IbD
        match.gsub!(/(?<=\s)\n(?=([a-z]|\())/, '')
        @text.gsub!(/#{Regexp.escape(orig)}/, "#{match}")
      end
    end

    def strip_html
      @text.gsub!(HTML_TAG_CATCHER, '')
      @text.gsub!(ESCAPED_HTML_TAG_CATCHER, '')
    end

    def strip_other_inline_formatting
      # Rubular: http://rubular.com/r/bAJrhyLNeZ
      @text.gsub!(/\{b\^&gt;\d*&lt;b\^\}|\{b\^>\d*<b\^\}/, '')
    end

    def replace_newlines
      # Rubular: http://rubular.com/r/dMxp5MixFS
      @text.gsub!(/\n \n/, "\r")
      if doc_type.eql?('pdf')
        # Rubular: http://rubular.com/r/H6HOJeA8bq
        @text.gsub!(/\n\n/, "\r")
        remove_pdf_line_breaks
      else
        # Rubular: http://rubular.com/r/FseyMiiYFT
        @text.gsub!(/\n(?=\.(\s|\n))/, '')
        @text.gsub!(/\n/, "\r")
      end
    end

    def remove_pdf_line_breaks
      # Rubular: http://rubular.com/r/Gn18aAnLdZ
      @text.gsub!(/\n(?=•)/, "\r")
      # Rubular: http://rubular.com/r/UZAVcwqck8
      @text.gsub!(/(?<=[^\n]\s)\n(?=\S)/, '')
      # Rubular: http://rubular.com/r/eaNwGavmdo
      @text.gsub!(/\n(?=[a-z])/, ' ')
    end

    def clean_quotations
      @text.gsub!(/''/, '"')
      @text.gsub!(/``/, '"')
      @text.gsub!(/`/, "'") if language.eql?('en')
    end

    def clean_table_of_contents
      # Rubular: http://rubular.com/r/8mc1ArOIGy
      @text.gsub!(/\.{5,}\s*\d+-*\d*/, "\r")
      # Rubular: http://rubular.com/r/DwNSuZrNtk
      @text.gsub!(/\.{5,}/, ' ')
    end
  end
end
