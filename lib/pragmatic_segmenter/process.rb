# -*- encoding : utf-8 -*-
require 'pragmatic_segmenter/list'
require 'pragmatic_segmenter/abbreviation_replacer'
require 'pragmatic_segmenter/number'
require 'pragmatic_segmenter/rules/ellipsis'
require 'pragmatic_segmenter/exclamation_words'
require 'pragmatic_segmenter/punctuation_replacer'
require 'pragmatic_segmenter/between_punctuation'
require 'pragmatic_segmenter/sentence_boundary_punctuation'
require 'pragmatic_segmenter/punctuation'

module PragmaticSegmenter
  # This class processing segmenting the text.
  class Process
    include Rules
    # Rubular: http://rubular.com/r/NqCqv372Ix
    QUOTATION_AT_END_OF_SENTENCE_REGEX = /[!?\.-][\"\'\u{201d}\u{201c}]\s{1}[A-Z]/

    # Rubular: http://rubular.com/r/6flGnUMEVl
    PARENS_BETWEEN_DOUBLE_QUOTES_REGEX = /["”]\s\(.*\)\s["“]/

    # Rubular: http://rubular.com/r/TYzr4qOW1Q
    BETWEEN_DOUBLE_QUOTES_REGEX = /"(?:[^"])*[^,]"|“(?:[^”])*[^,]”/

    # Rubular: http://rubular.com/r/JMjlZHAT4g
    SPLIT_SPACE_QUOTATION_AT_END_OF_SENTENCE_REGEX = /(?<=[!?\.-][\"\'\u{201d}\u{201c}])\s{1}(?=[A-Z])/

    # Rubular: http://rubular.com/r/mQ8Es9bxtk
    CONTINUOUS_PUNCTUATION_REGEX = /(?<=\S)(!|\?){3,}(?=(\s|\z|$))/

    attr_reader :text, :doc_type
    def initialize(text:, doc_type:)
      @text = text
      @doc_type = doc_type
    end

    def process
      reformatted_text = PragmaticSegmenter::List.new(text: text).add_line_break
      reformatted_text = replace_abbreviations(reformatted_text)
      reformatted_text = replace_numbers(reformatted_text)
      reformatted_text = replace_continuous_punctuation(reformatted_text)
      reformatted_text.apply(AbbreviationsWithMultiplePeriodsAndEmailRule)
      reformatted_text.apply(GeoLocationRule)
      split_into_segments(reformatted_text)
    end

    private

    def split_into_segments(txt)
      check_for_parens_between_quotes(txt).split("\r")
         .map! { |segment| segment.apply(SingleNewLineRule, EllipsisRules::All) }
         .map { |segment| check_for_punctuation(segment) }.flatten
         .map! { |segment| segment.apply(SubSymbolsRules::All) }
         .map { |segment| post_process_segments(segment) }
         .flatten.compact.delete_if(&:empty?)
         .map! { |segment| segment.apply(SubSingleQuoteRule) }
    end

    def post_process_segments(txt)
      return if consecutive_underscore?(txt) || txt.length < 2
      txt.apply(ReinsertEllipsisRules::All).apply(ExtraWhiteSpaceRule)
      if txt =~ QUOTATION_AT_END_OF_SENTENCE_REGEX
        txt.split(SPLIT_SPACE_QUOTATION_AT_END_OF_SENTENCE_REGEX)
      else
        txt.tr("\n", '').strip
      end
    end

    def check_for_parens_between_quotes(txt)
      return txt unless txt =~ PARENS_BETWEEN_DOUBLE_QUOTES_REGEX
      txt.gsub!(PARENS_BETWEEN_DOUBLE_QUOTES_REGEX) do |match|
        match.gsub(/\s(?=\()/, "\r").gsub(/(?<=\))\s/, "\r")
      end
    end

    def replace_continuous_punctuation(txt)
      return txt unless txt =~ CONTINUOUS_PUNCTUATION_REGEX
      txt.gsub!(CONTINUOUS_PUNCTUATION_REGEX) do |match|
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
        DoublePunctuationRules::All,
        QuestionMarkInQuotationRule,
        ExclamationPointRules::All
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
      @punct_arr ||= PragmaticSegmenter::Punctuations
    end

    def between_punctuation(txt)
      PragmaticSegmenter::BetweenPunctuation.new(text: txt).replace
    end

    def sentence_boundary_punctuation(txt)
      PragmaticSegmenter::SentenceBoundaryPunctuation.new(text: txt).split
    end
  end
end
