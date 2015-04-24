# -*- encoding : utf-8 -*-
require 'pragmatic_segmenter/punctuation_replacer'
require 'pragmatic_segmenter/between_punctuation'


require 'pragmatic_segmenter/list'
require 'pragmatic_segmenter/abbreviation_replacer'
require 'pragmatic_segmenter/exclamation_words'

module PragmaticSegmenter
  # This class processing segmenting the text.
  class Process

    attr_reader :text
    def initialize(text:, language: )
      @text = text
      @language = language
    end

    def process
      @text = List.new(text: @text).add_line_break
      replace_abbreviations
      @text = replace_numbers(@text)
      @text = replace_continuous_punctuation(@text)
      @text.apply(@language::Abbreviations::WithMultiplePeriodsAndEmailRule)
      @text.apply(@language::GeoLocationRule)
      split_into_segments(@text)
    end

    private

    def split_into_segments(txt)
      check_for_parens_between_quotes(txt).split("\r")
         .map! { |segment| segment.apply(@language::SingleNewLineRule, @language::EllipsisRules::All) }
         .map { |segment| check_for_punctuation(segment) }.flatten
         .map! { |segment| segment.apply(@language::SubSymbolsRules::All) }
         .map { |segment| post_process_segments(segment) }
         .flatten.compact.delete_if(&:empty?)
         .map! { |segment| segment.apply(@language::SubSingleQuoteRule) }
    end

    def post_process_segments(txt)
      return if consecutive_underscore?(txt) || txt.length < 2
      txt.apply(
        @language::ReinsertEllipsisRules::All,
        @language::ExtraWhiteSpaceRule
      )

      if txt =~ @language::QUOTATION_AT_END_OF_SENTENCE_REGEX
        txt.split(@language::SPLIT_SPACE_QUOTATION_AT_END_OF_SENTENCE_REGEX)
      else
        txt.tr("\n", '').strip
      end
    end

    def check_for_parens_between_quotes(txt)
      return txt unless txt =~ @language::PARENS_BETWEEN_DOUBLE_QUOTES_REGEX
      txt.gsub!(@language::PARENS_BETWEEN_DOUBLE_QUOTES_REGEX) do |match|
        match.gsub(/\s(?=\()/, "\r").gsub(/(?<=\))\s/, "\r")
      end
    end

    def replace_continuous_punctuation(txt)
      return txt unless txt =~ @language::CONTINUOUS_PUNCTUATION_REGEX
      txt.gsub!(@language::CONTINUOUS_PUNCTUATION_REGEX) do |match|
        match.gsub(/!/, '&ᓴ&').gsub(/\?/, '&ᓷ&')
      end
    end

    def consecutive_underscore?(txt)
      # Rubular: http://rubular.com/r/fTF2Ff3WBL
      txt.gsub(/_{3,}/, '').length.eql?(0)
    end

    def check_for_punctuation(txt)
      if @language::Punctuations.any? { |p| txt.include?(p) }
        process_text(txt)
      else
        txt
      end
    end

    def process_text(txt)
      txt << 'ȸ' unless @language::Punctuations.any? { |p| txt[-1].include?(p) }
      ExclamationWords.apply_rules(txt)
      between_punctuation(txt)
      txt = txt.apply(
        @language::DoublePunctuationRules::All,
        @language::QuestionMarkInQuotationRule,
        @language::ExclamationPointRules::All
      )
      txt = List.new(text: txt).replace_parens
      sentence_boundary_punctuation(txt)
    end

    def replace_numbers(txt)
      txt.apply @language::Numbers::All
    end

    def replace_abbreviations
      @text = AbbreviationReplacer.new(text: @text, language: @language).replace
    end

    def between_punctuation(txt)
      BetweenPunctuation.new(text: txt).replace
    end

    def sentence_boundary_punctuation(txt)
      txt.scan(@language::SENTENCE_BOUNDARY_REGEX)
    end
  end
end
