require 'pragmatic_segmenter/cleaner'
require 'pragmatic_segmenter/list'
require 'pragmatic_segmenter/abbreviation_replacer'
require 'pragmatic_segmenter/number'
require 'pragmatic_segmenter/ellipsis'
require 'pragmatic_segmenter/exclamation_words'
require 'pragmatic_segmenter/punctuation_replacer'
require 'pragmatic_segmenter/between_punctuation'
require 'pragmatic_segmenter/sentence_boundary_punctuation'
require 'pragmatic_segmenter/languages/english'
require 'pragmatic_segmenter/languages/deutsch'
require 'pragmatic_segmenter/rules'

module PragmaticSegmenter
  module Languages
    module Common
      include Rules

      PUNCT = ['。', '．', '.', '！', '!', '?', '？']
      PUNCT_AM = ['።', '፧', '?', '!']
      PUNCT_AR = ['?', '!', ':', '.', '؟', '،']
      PUNCT_EL = ['.', '!', ';', '?']
      PUNCT_FA = ['?', '!', ':', '.', '؟']
      PUNCT_HI = ['।', '|', '.', '!', '?']
      PUNCT_HY = ['։', '՜', ':']
      PUNCT_MY = ['။', '၏', '?', '!']
      PUNCT_UR = ['?', '!', '۔', '؟']

      # Rubular: http://rubular.com/r/NqCqv372Ix
      QUOTATION_AT_END_OF_SENTENCE_REGEX = /[!?\.][\"\'\u{201d}\u{201c}]\s{1}[A-Z]/

      # Rubular: http://rubular.com/r/JMjlZHAT4g
      SPLIT_SPACE_QUOTATION_AT_END_OF_SENTENCE_REGEX = /(?<=[!?\.][\"\'\u{201d}\u{201c}])\s{1}(?=[A-Z])/

      attr_reader :text, :language, :doc_type
      def initialize(text:, **args)
        return [] unless text
        if args[:clean].eql?(false)
          @text = text.dup
        else
          @text = PragmaticSegmenter::Cleaner.new(text: text.dup, language: args[:language], doc_type: args[:doc_type]).clean
        end
        @language = args[:language] || 'en'
        @doc_type = args[:doc_type]
      end

      def segment
        return [] unless text
        reformatted_text = PragmaticSegmenter::List.new(text: text).add_line_break
        reformatted_text = PragmaticSegmenter::AbbreviationReplacer.new(text: reformatted_text, language: language).replace
        if language.eql?('de')
          reformatted_text = PragmaticSegmenter::Languages::Deutsch::Number.new(text: reformatted_text).replace
        else
          reformatted_text = PragmaticSegmenter::Number.new(text: reformatted_text).replace
        end
        reformatted_text = reformatted_text.apply(GeoLocationRule)
        split_lines(reformatted_text)
      end

      private

      def split_lines(txt)
        segments = []
        lines = txt.split("\r")
        lines.each do |l|
          next if l.eql?('')
          analyze_lines(line: l, segments: segments)
        end
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

      def analyze_lines(line:, segments:)

        line = line.apply(SingleNewLineRule, EllipsisRules::All, EmailRule)

        clause_1 = false
        end_punc_check = false
        if language
          punctuation =
            Segmenter.const_defined?("PUNCT_#{language.upcase}") ? Segmenter.const_get("PUNCT_#{language.upcase}") : PUNCT
        else
          punctuation = PUNCT
        end
        punctuation.each do |p|
          end_punc_check = true if line[-1].include?(p)
          clause_1 = true if line.include?(p)
        end
        if clause_1
          segments = process_text(line, end_punc_check, segments)
        else
          line.gsub!(/ȹ/, "\n")
          line.gsub!(/∯/, '.')
          segments << line
        end
      end

      def process_text(line, end_punc_check, segments)
        line << 'ȸ' unless end_punc_check || language.eql?('ar') || language.eql?('fa')
          PragmaticSegmenter::ExclamationWords.apply_rules(line)
          PragmaticSegmenter::BetweenPunctuation.new(text: line, language: language).replace
          line = line.apply(
            DoublePuctationRules::All,
            QuestionMarkInQuotationRule,
            ExclamationPointRules::All
          )

          subline = PragmaticSegmenter::SentenceBoundaryPunctuation.new(text: line, language: language).split
          subline.each_with_index do |s_l|
            segments << sub_symbols(s_l)
          end
      end

      def sub_symbols(txt)
        # FIXME: Make named rules for these
        txt.gsub(/∯/, '.').gsub(/♬/, '،').gsub(/♭/, ':').gsub(/ᓰ/, '。').gsub(/ᓱ/, '．')
          .gsub(/ᓳ/, '！').gsub(/ᓴ/, '!').gsub(/ᓷ/, '?').gsub(/ᓸ/, '？').gsub(/☉/, '?!')
          .gsub(/☈/, '!?').gsub(/☇/, '??').gsub(/☄/, '!!').delete('ȸ').gsub(/ȹ/, "\n")
      end

      def reinsert_ellipsis(line)
        # FIXME: Make named rules for these
        line.gsub(/ƪ/, '...').gsub(/♟/, ' . . . ')
          .gsub(/♝/, '. . . .').gsub(/☏/, '..')
          .gsub(/∮/, '.')
      end
    end
  end
end
