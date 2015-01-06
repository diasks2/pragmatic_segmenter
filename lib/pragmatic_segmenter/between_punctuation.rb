# -*- encoding : utf-8 -*-
require 'pragmatic_segmenter/punctuation_replacer'

module PragmaticSegmenter
  # This class searches for punctuation between quotes or parenthesis
  # and replaces it
  class BetweenPunctuation
    # Rubular: http://rubular.com/r/2YFrKWQUYi
    BETWEEN_SINGLE_QUOTES_REGEX = /(?<=\s)'(?:[^']|'[a-zA-Z])*'/

    # Rubular: http://rubular.com/r/TkZomF9tTM
    BETWEEN_DOUBLE_QUOTES_DE_REGEX = /„(?>[^“\\]+|\\{2}|\\.)*“/

    # Rubular: http://rubular.com/r/3Pw1QlXOjd
    BETWEEN_DOUBLE_QUOTES_REGEX = /"(?>[^"\\]+|\\{2}|\\.)*"/

    # Rubular: http://rubular.com/r/GnjOmry5Z2
    BETWEEN_QUOTE_JA_REGEX = /\u{300c}(?>[^\u{300c}\u{300d}\\]+|\\{2}|\\.)*\u{300d}/

    # Rubular: http://rubular.com/r/x6s4PZK8jc
    BETWEEN_QUOTE_ARROW_REGEX = /«(?>[^»\\]+|\\{2}|\\.)*»/

    # Rubular: http://rubular.com/r/JbAIpKdlSq
    BETWEEN_QUOTE_SLANTED_REGEX = /“(?>[^”\\]+|\\{2}|\\.)*”/

    # Rubular: http://rubular.com/r/6tTityPflI
    BETWEEN_PARENS_REGEX = /\((?>[^\(\)\\]+|\\{2}|\\.)*\)/

    # Rubular: http://rubular.com/r/EjHcZn5ZSG
    BETWEEN_PARENS_JA_REGEX = /\u{ff08}(?>[^\u{ff08}\u{ff09}\\]+|\\{2}|\\.)*\u{ff09}/

    # Rubular: http://rubular.com/r/OdcXBsub0w
    BETWEEN_UNCONVENTIONAL_DOUBLE_QUOTE_DE_REGEX = /,,(?>[^“\\]+|\\{2}|\\.)*“/

    # Rubular: http://rubular.com/r/2UskIupGgP
    SPLIT_DOUBLE_QUOTES_DE_REGEX = /\A„(?>[^“\\]+|\\{2}|\\.)*“/

    attr_reader :text, :language
    def initialize(text:, **args)
      @text = text
      @language = args[:language]
    end

    def replace
      sub_punctuation_between_quotes_and_parens(text)
    end

    private

    def sub_punctuation_between_quotes_and_parens(txt)
      sub_punctuation_between_single_quotes(txt)
      sub_punctuation_between_double_quotes(txt)
      sub_punctuation_between_quotes_ja(txt)
      sub_punctuation_between_parens(txt)
      sub_punctuation_between_parens_ja(txt)
      sub_punctuation_between_quotes_arrow(txt)
      sub_punctuation_between_quotes_slanted(txt)
    end

    def sub_punctuation_between_parens(txt)
      PragmaticSegmenter::PunctuationReplacer.new(
        matches_array: txt.scan(BETWEEN_PARENS_REGEX),
        text: txt
      ).replace
    end

    def sub_punctuation_between_parens_ja(txt)
      PragmaticSegmenter::PunctuationReplacer.new(
        matches_array: txt.scan(BETWEEN_PARENS_JA_REGEX),
        text: txt
      ).replace
    end

    def sub_punctuation_between_single_quotes(txt)
      PragmaticSegmenter::PunctuationReplacer.new(
        matches_array: txt.scan(BETWEEN_SINGLE_QUOTES_REGEX),
        text: txt
      ).replace
    end

    def sub_punctuation_between_double_quotes(txt)
      if language.eql?('de')
        btwn_dbl_quote = sub_punctuation_between_double_quotes_de(txt)
      else
        btwn_dbl_quote = txt.scan(BETWEEN_DOUBLE_QUOTES_REGEX)
      end
      PragmaticSegmenter::PunctuationReplacer.new(
        matches_array: btwn_dbl_quote,
        text: txt
      ).replace
    end

    def sub_punctuation_between_quotes_ja(txt)
      PragmaticSegmenter::PunctuationReplacer.new(
        matches_array: txt.scan(BETWEEN_QUOTE_JA_REGEX),
        text: txt
      ).replace
    end

    def sub_punctuation_between_quotes_arrow(txt)
      PragmaticSegmenter::PunctuationReplacer.new(
        matches_array: txt.scan(BETWEEN_QUOTE_ARROW_REGEX),
        text: txt
      ).replace
    end

    def sub_punctuation_between_quotes_slanted(txt)
      PragmaticSegmenter::PunctuationReplacer.new(
        matches_array: txt.scan(BETWEEN_QUOTE_SLANTED_REGEX),
        text: txt
      ).replace
    end

    def sub_punctuation_between_double_quotes_de(txt)
      if txt.include?('„')
        btwn_dbl_quote = txt.scan(BETWEEN_DOUBLE_QUOTES_DE_REGEX)
        txt.scan(SPLIT_DOUBLE_QUOTES_DE_REGEX).each do |q|
          btwn_dbl_quote << q
        end
      elsif txt.include?(',,')
        btwn_dbl_quote = txt.scan(BETWEEN_UNCONVENTIONAL_DOUBLE_QUOTE_DE_REGEX)
      end
      btwn_dbl_quote
    end
  end
end