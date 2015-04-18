# -*- encoding : utf-8 -*-
require 'pragmatic_segmenter/list'
require 'pragmatic_segmenter/abbreviation_replacer'
require 'pragmatic_segmenter/number'
require 'pragmatic_segmenter/rules/ellipsis'
require 'pragmatic_segmenter/exclamation_words'
require 'pragmatic_segmenter/punctuation_replacer'
require 'pragmatic_segmenter/between_punctuation'

module PragmaticSegmenter
  # This class processing segmenting the text.
  class Process

    attr_reader :text
    def initialize(text:, language: Languages::Common)
      @text = text
      @language = language
    end

    def process
      reformatted_text = PragmaticSegmenter::List.new(text: text).add_line_break
      reformatted_text = replace_abbreviations(reformatted_text)
      reformatted_text = replace_numbers(reformatted_text)
      reformatted_text = replace_continuous_punctuation(reformatted_text)
      reformatted_text.apply(Languages::Common::AbbreviationsWithMultiplePeriodsAndEmailRule)
      reformatted_text.apply(Languages::Common::GeoLocationRule)
      split_into_segments(reformatted_text)
    end

    private

    def split_into_segments(txt)
      check_for_parens_between_quotes(txt).split("\r")
         .map! { |segment| segment.apply(Languages::Common::SingleNewLineRule, Languages::Common::EllipsisRules::All) }
         .map { |segment| check_for_punctuation(segment) }.flatten
         .map! { |segment| segment.apply(Languages::Common::SubSymbolsRules::All) }
         .map { |segment| post_process_segments(segment) }
         .flatten.compact.delete_if(&:empty?)
         .map! { |segment| segment.apply(Languages::Common::SubSingleQuoteRule) }
    end

    def post_process_segments(txt)
      return if consecutive_underscore?(txt) || txt.length < 2
      txt.apply(Languages::Common::ReinsertEllipsisRules::All).apply(Languages::Common::ExtraWhiteSpaceRule)
      if txt =~ Languages::Common::QUOTATION_AT_END_OF_SENTENCE_REGEX
        txt.split(Languages::Common::SPLIT_SPACE_QUOTATION_AT_END_OF_SENTENCE_REGEX)
      else
        txt.tr("\n", '').strip
      end
    end

    def check_for_parens_between_quotes(txt)
      return txt unless txt =~ Languages::Common::PARENS_BETWEEN_DOUBLE_QUOTES_REGEX
      txt.gsub!(Languages::Common::PARENS_BETWEEN_DOUBLE_QUOTES_REGEX) do |match|
        match.gsub(/\s(?=\()/, "\r").gsub(/(?<=\))\s/, "\r")
      end
    end

    def replace_continuous_punctuation(txt)
      return txt unless txt =~ Languages::Common::CONTINUOUS_PUNCTUATION_REGEX
      txt.gsub!(Languages::Common::CONTINUOUS_PUNCTUATION_REGEX) do |match|
        match.gsub(/!/, '&ᓴ&').gsub(/\?/, '&ᓷ&')
      end
    end

    def consecutive_underscore?(txt)
      # Rubular: http://rubular.com/r/fTF2Ff3WBL
      txt.gsub(/_{3,}/, '').length.eql?(0)
    end

    def check_for_punctuation(txt)
      if punctuation_array.any? { |p| txt.include?(p) }
        process_text(txt)
      else
        txt
      end
    end

    def process_text(txt)
      txt << 'ȸ' unless punctuation_array.any? { |p| txt[-1].include?(p) }
      PragmaticSegmenter::ExclamationWords.apply_rules(txt)
      between_punctuation(txt)
      txt = txt.apply(
        Languages::Common::DoublePunctuationRules::All,
        Languages::Common::QuestionMarkInQuotationRule,
        Languages::Common::ExclamationPointRules::All
      )
      txt = PragmaticSegmenter::List.new(text: txt).replace_parens
      sentence_boundary_punctuation(txt)
    end

    def replace_numbers(txt)
      PragmaticSegmenter::Number.new(text: txt).replace
    end

    def replace_abbreviations(txt)
      PragmaticSegmenter::AbbreviationReplacer.new(text: txt).replace
    end

    def punctuation_array
      Languages::Common::Punctuations
    end

    def between_punctuation(txt)
      PragmaticSegmenter::BetweenPunctuation.new(text: txt).replace
    end

    def sentence_boundary_punctuation(txt)
      txt.scan(Languages::Common::SENTENCE_BOUNDARY_REGEX)
    end
  end
end
