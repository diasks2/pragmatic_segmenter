# -*- encoding : utf-8 -*-
require 'pragmatic_segmenter/list'
require 'pragmatic_segmenter/abbreviation_replacer'
require 'pragmatic_segmenter/number'
require 'pragmatic_segmenter/ellipsis'
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
    QUOTATION_AT_END_OF_SENTENCE_REGEX = /[!?\.][\"\'\u{201d}\u{201c}]\s{1}[A-Z]/

    # Rubular: http://rubular.com/r/JMjlZHAT4g
    SPLIT_SPACE_QUOTATION_AT_END_OF_SENTENCE_REGEX = /(?<=[!?\.][\"\'\u{201d}\u{201c}])\s{1}(?=[A-Z])/

    attr_reader :text, :doc_type
    def initialize(text:, doc_type:)
      @text = text
      @doc_type = doc_type
    end

    def process
      reformatted_text = PragmaticSegmenter::List.new(text: text).add_line_break
      reformatted_text = replace_abbreviations(reformatted_text)
      reformatted_text = replace_numbers(reformatted_text)
      reformatted_text = reformatted_text.apply(GeoLocationRule)
      split_lines(reformatted_text)
    end

    private

    def split_lines(txt)
      txt.split("\r")
         .map! { |line| line.apply(SingleNewLineRule, EllipsisRules::All, EmailRule) }
         .map { |line| analyze_lines(line) }.flatten
         .map! { |segment| segment.apply(SubSymbolsRules::All) }
         .map { |segment| post_process_segments(segment) }
         .flatten.compact.delete_if(&:empty?)
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

    def consecutive_underscore?(txt)
      # Rubular: http://rubular.com/r/fTF2Ff3WBL
      txt.gsub(/_{3,}/, '').length.eql?(0)
    end

    def analyze_lines(line)
      if punctuation_array.any? { |p| line.include?(p) }
        process_text(line)
      else
        line
      end
    end

    def process_text(line)
      line << 'ȸ' unless punctuation_array.any? { |p| line[-1].include?(p) }
      PragmaticSegmenter::ExclamationWords.apply_rules(line)
      between_punctutation(line)
      line = line.apply(
        DoublePuctationRules::All,
        QuestionMarkInQuotationRule,
        ExclamationPointRules::All
      )
      sentence_boundary_punctuation(line)
    end

    def replace_numbers(txt)
      PragmaticSegmenter::Number.new(text: txt).replace
    end

    def replace_abbreviations(txt)
      PragmaticSegmenter::AbbreviationReplacer.new(text: txt).replace
    end

    def punctuation_array
      @punct_arr ||= PragmaticSegmenter::Punctuation.new.punct
    end

    def between_punctutation(txt)
      PragmaticSegmenter::BetweenPunctuation.new(text: txt).replace
    end

    def sentence_boundary_punctuation(txt)
      PragmaticSegmenter::SentenceBoundaryPunctuation.new(text: txt).split
    end
  end
end
