# -*- encoding : utf-8 -*-

module PragmaticSegmenter
  # This class processing segmenting the text.
  class Process
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
    def initialize(text:, language:, doc_type:)
      @text = text
      @language = language
      @doc_type = doc_type
    end

    def process
      reformatted_text = PragmaticSegmenter::List.new(text: text).add_line_break
      reformatted_text = replace_abbreviations(reformatted_text)
      reformatted_text = replace_numbers(reformatted_text)
      reformatted_text = PragmaticSegmenter::GeoLocation.new(text: reformatted_text).replace
      split_lines(reformatted_text)
    end

    private

    def replace_numbers(txt)
      PragmaticSegmenter::Number.new(text: txt).replace
    end

    def replace_abbreviations(txt)
      PragmaticSegmenter::AbbreviationReplacer.new(text: txt).replace
    end

    def split_lines(txt)
      segments = []
      lines = txt.split("\r")
      lines.each do |l|
        next if l.eql?('')
        analyze_lines(l, segments, punctuation_array)
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

    def punctuation_array
      PragmaticSegmenter::Punctuation.new.punct
    end

    def analyze_lines(line, segments, punctuation)
      line = replace_single_newline(line)
      line = PragmaticSegmenter::Ellipsis.new(text: line).replace
      line = PragmaticSegmenter::Email.new(text: line).replace

      clause_1 = false
      end_punc_check = false
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
        case language
        when 'de'
          PragmaticSegmenter::Languages::Deutsch::BetweenPunctuation.new(text: line).replace
        when 'ja'
          PragmaticSegmenter::Languages::Japanese::BetweenPunctuation.new(text: line).replace
        else
          PragmaticSegmenter::BetweenPunctuation.new(text: line).replace
        end
        line = replace_double_punctuation(line)
        line = replace_question_mark_in_quotation(line)
        line = replace_exclamation_point_in_quotation(line)
        line = replace_exclamation_point_before_comma_mid_sentence(line)
        line = replace_exclamation_point_mid_sentence(line)
        case language
        when 'hi'
          subline = PragmaticSegmenter::Languages::Hindi::SentenceBoundaryPunctuation.new(text: line).split
        when 'fa'
          subline = PragmaticSegmenter::Languages::Persian::SentenceBoundaryPunctuation.new(text: line).split
        when 'el'
          subline = PragmaticSegmenter::Languages::Greek::SentenceBoundaryPunctuation.new(text: line).split
        when 'am'
          subline = PragmaticSegmenter::Languages::Amharic::SentenceBoundaryPunctuation.new(text: line).split
        when 'ar'
          subline = PragmaticSegmenter::Languages::Arabic::SentenceBoundaryPunctuation.new(text: line).split
        when 'hy'
          subline = PragmaticSegmenter::Languages::Armenian::SentenceBoundaryPunctuation.new(text: line).split
        when 'ur'
          subline = PragmaticSegmenter::Languages::Urdu::SentenceBoundaryPunctuation.new(text: line).split
        when 'my'
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
