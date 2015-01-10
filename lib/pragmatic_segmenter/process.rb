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
      segments = txt.split("\r")

      segments.map! do |line|
        line.apply(SingleNewLineRule, EllipsisRules::All, EmailRule)
      end

      segments = segments.map { |line| analyze_lines(line) }.flatten

      segments.map! {|segment| sub_symbols(segment) }

      sentence_array = []
      segments.each_with_index do |line|
        next if line.gsub(/_{3,}/, '').length.eql?(0) || line.length < 2
        line = reinsert_ellipsis(line)
        line = line.apply(ExtraWhiteSpaceRule)
        if line =~ QUOTATION_AT_END_OF_SENTENCE_REGEX
          subline = line.split(SPLIT_SPACE_QUOTATION_AT_END_OF_SENTENCE_REGEX)
          subline.each do |s|
            sentence_array << s
          end
        else
          sentence_array << line.tr("\n", '').strip
        end
      end
      sentence_array.reject(&:empty?)
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

    def sub_symbols(txt)
      txt.gsub(/∯/, '.').gsub(/♬/, '،').gsub(/♭/, ':').gsub(/ᓰ/, '。').gsub(/ᓱ/, '．')
        .gsub(/ᓳ/, '！').gsub(/ᓴ/, '!').gsub(/ᓷ/, '?').gsub(/ᓸ/, '？').gsub(/☉/, '?!')
        .gsub(/☈/, '!?').gsub(/☇/, '??').gsub(/☄/, '!!').delete('ȸ').gsub(/ȹ/, "\n")
    end

    def reinsert_ellipsis(line)
      line.gsub(/ƪ/, '...').gsub(/♟/, ' . . . ')
        .gsub(/♝/, '. . . .').gsub(/☏/, '..')
        .gsub(/∮/, '.')
    end
  end
end
