require 'pragmatic_segmenter/cleaner'
require 'pragmatic_segmenter/list'
require 'pragmatic_segmenter/abbreviation_replacer'
require 'pragmatic_segmenter/number'
require 'pragmatic_segmenter/ellipsis'
require 'pragmatic_segmenter/geo_location'
require 'pragmatic_segmenter/email'
require 'pragmatic_segmenter/exclamation_words'
require 'pragmatic_segmenter/punctuation_replacer'
require 'pragmatic_segmenter/between_punctuation'
require 'pragmatic_segmenter/sentence_boundary_punctuation'
require 'pragmatic_segmenter/languages/english'
require 'pragmatic_segmenter/languages/deutsch'
require 'pragmatic_segmenter/languages/hindi'
require 'pragmatic_segmenter/languages/persian'
require 'pragmatic_segmenter/languages/amharic'
require 'pragmatic_segmenter/languages/arabic'
require 'pragmatic_segmenter/languages/greek'
require 'pragmatic_segmenter/languages/armenian'
require 'pragmatic_segmenter/languages/burmese'
require 'pragmatic_segmenter/languages/urdu'
require 'pragmatic_segmenter/languages/french'
require 'pragmatic_segmenter/languages/italian'
require 'pragmatic_segmenter/languages/spanish'
require 'pragmatic_segmenter/languages/russian'
require 'pragmatic_segmenter/languages/japanese'

module PragmaticSegmenter
  module Languages
    module Common
      PUNCT = ['。', '．', '.', '！', '!', '?', '？']
      PUNCT_AM = ['።', '፧', '?', '!']
      PUNCT_AR = ['?', '!', ':', '.', '؟', '،']
      PUNCT_EL = ['.', '!', ';', '?']
      PUNCT_FA = ['?', '!', ':', '.', '؟']
      PUNCT_HI = ['।', '|', '.', '!', '?']
      PUNCT_HY = ['։', '՜', ':']
      PUNCT_MY = ['။', '၏', '?', '!']
      PUNCT_UR = ['?', '!', '۔', '؟']

      # Rubular: http://rubular.com/r/aXPUGm6fQh
      QUESTION_MARK_IN_QUOTATION_REGEX = /\?(?=(\'|\"))/

      # Rubular: http://rubular.com/r/XS1XXFRfM2
      EXCLAMATION_POINT_IN_QUOTATION_REGEX = /\!(?=(\'|\"))/

      # Rubular: http://rubular.com/r/sl57YI8LkA
      EXCLAMATION_POINT_BEFORE_COMMA_MID_SENTENCE_REGEX = /\!(?=\,\s[a-z])/

      # Rubular: http://rubular.com/r/f9zTjmkIPb
      EXCLAMATION_POINT_MID_SENTENCE_REGEX = /\!(?=\s[a-z])/

      # Rubular: http://rubular.com/r/NqCqv372Ix
      QUOTATION_AT_END_OF_SENTENCE_REGEX = /[!?\.][\"\'\u{201d}\u{201c}]\s{1}[A-Z]/

      # Rubular: http://rubular.com/r/JMjlZHAT4g
      SPLIT_SPACE_QUOTATION_AT_END_OF_SENTENCE_REGEX = /(?<=[!?\.][\"\'\u{201d}\u{201c}])\s{1}(?=[A-Z])/

      attr_reader :text, :language, :doc_type
      def initialize(text:, **args)
        return [] unless text
        @language = args[:language] || 'en'
        @doc_type = args[:doc_type]
        if args[:clean].eql?(false)
          @text = text.dup
        else
          case @language
          when 'en'
            @text = PragmaticSegmenter::Languages::English::Cleaner.new(text: text.dup, language: @language, doc_type: args[:doc_type]).clean
          when 'ja'
            @text = PragmaticSegmenter::Languages::Japanese::Cleaner.new(text: text.dup, language: @language, doc_type: args[:doc_type]).clean
          else
            @text = PragmaticSegmenter::Cleaner.new(text: text.dup, language: @language, doc_type: args[:doc_type]).clean
          end
        end
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
        reformatted_text = PragmaticSegmenter::GeoLocation.new(text: reformatted_text).replace
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
          line = remove_extra_white_space(line)
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
        line = replace_single_newline(line)
        line = PragmaticSegmenter::Ellipsis.new(text: line).replace
        line = PragmaticSegmenter::Email.new(text: line).replace

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
          PragmaticSegmenter::ExclamationWords.new(text: line).replace
          PragmaticSegmenter::BetweenPunctuation.new(text: line, language: language).replace
          line = replace_double_punctuation(line)
          line = replace_question_mark_in_quotation(line)
          line = replace_exclamation_point_in_quotation(line)
          line = replace_exclamation_point_before_comma_mid_sentence(line)
          line = replace_exclamation_point_mid_sentence(line)
          case
          when language.eql?('hi')
            subline = PragmaticSegmenter::Languages::Hindi::SentenceBoundaryPunctuation.new(text: line).split
          when language.eql?('fa')
            subline = PragmaticSegmenter::Languages::Persian::SentenceBoundaryPunctuation.new(text: line).split
          when language.eql?('el')
            subline = PragmaticSegmenter::Languages::Greek::SentenceBoundaryPunctuation.new(text: line).split
          when language.eql?('am')
            subline = PragmaticSegmenter::Languages::Amharic::SentenceBoundaryPunctuation.new(text: line).split
          when language.eql?('ar')
            subline = PragmaticSegmenter::Languages::Arabic::SentenceBoundaryPunctuation.new(text: line).split
          when language.eql?('hy')
            subline = PragmaticSegmenter::Languages::Armenian::SentenceBoundaryPunctuation.new(text: line).split
          when language.eql?('ur')
            subline = PragmaticSegmenter::Languages::Urdu::SentenceBoundaryPunctuation.new(text: line).split
          when language.eql?('my')
            subline = PragmaticSegmenter::Languages::Burmese::SentenceBoundaryPunctuation.new(text: line).split
          else
            subline = PragmaticSegmenter::SentenceBoundaryPunctuation.new(text: line).split
          end
          subline.each_with_index do |s_l|
            segments << sub_symbols(s_l)
          end
      end

      def replace_single_newline(txt)
        txt.gsub(/\n/, 'ȹ')
      end

      def replace_double_punctuation(txt)
        txt.gsub(/\?!/, '☉')
          .gsub(/!\?/, '☈').gsub(/\?\?/, '☇')
          .gsub(/!!/, '☄')
      end

      def replace_exclamation_point_before_comma_mid_sentence(txt)
        txt.gsub(EXCLAMATION_POINT_BEFORE_COMMA_MID_SENTENCE_REGEX, 'ᓴ')
      end

      def replace_exclamation_point_mid_sentence(txt)
        txt.gsub(EXCLAMATION_POINT_MID_SENTENCE_REGEX, 'ᓴ')
      end

      def replace_exclamation_point_in_quotation(txt)
        txt.gsub(EXCLAMATION_POINT_IN_QUOTATION_REGEX, 'ᓴ')
      end

      def replace_question_mark_in_quotation(txt)
        txt.gsub(QUESTION_MARK_IN_QUOTATION_REGEX, 'ᓷ')
      end

      def sub_symbols(txt)
        txt.gsub(/∯/, '.').gsub(/♬/, '،').gsub(/♭/, ':').gsub(/ᓰ/, '。').gsub(/ᓱ/, '．')
          .gsub(/ᓳ/, '！').gsub(/ᓴ/, '!').gsub(/ᓷ/, '?').gsub(/ᓸ/, '？').gsub(/☉/, '?!')
          .gsub(/☈/, '!?').gsub(/☇/, '??').gsub(/☄/, '!!').delete('ȸ').gsub(/ȹ/, "\n")
      end

      def remove_extra_white_space(line)
        line.gsub(/\s{3,}/, ' ')
      end

      def reinsert_ellipsis(line)
        line.gsub(/ƪ/, '...').gsub(/♟/, ' . . . ')
          .gsub(/♝/, '. . . .').gsub(/☏/, '..')
          .gsub(/∮/, '.')
      end
    end
  end
end
