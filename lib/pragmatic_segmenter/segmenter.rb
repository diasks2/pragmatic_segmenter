# -*- encoding : utf-8 -*-
require 'pragmatic_segmenter/cleaner'
require 'pragmatic_segmenter/list'
require 'pragmatic_segmenter/abbreviation_replacer'
require 'pragmatic_segmenter/number'
require 'pragmatic_segmenter/ellipsis'
require 'pragmatic_segmenter/geolocation'
require 'pragmatic_segmenter/email'
require 'pragmatic_segmenter/exclamation_words'
require 'pragmatic_segmenter/punctuation_replacer'

module PragmaticSegmenter
  # This class segments a text into an array of sentences.
  class Segmenter
    PUNCT = ['。', '．', '.', '！', '!', '?', '？']
    PUNCT_AM = ['።', '፧', '?', '!']
    PUNCT_AR = ['?', '!', ':', '.', '؟', '،']
    PUNCT_EL = ['.', '!', ';', '?']
    PUNCT_FA = ['?', '!', ':', '.', '؟']
    PUNCT_HI = ['।', '|', '.', '!', '?']
    PUNCT_HY = ['։', '՜', ':']
    PUNCT_MY = ['။', '၏', '?', '!']
    PUNCT_UR = ['?', '!', '۔', '؟']

    SENTENCE_BOUNDARY_AM = /.*?[፧።!\?]|.*?$/
    SENTENCE_BOUNDARY_AR = /.*?[:\.!\?؟،]|.*?\z|.*?$/
    SENTENCE_BOUNDARY_EL = /.*?[\.;!\?]|.*?$/
    SENTENCE_BOUNDARY_FA = /.*?[:\.!\?؟]|.*?\z|.*?$/
    SENTENCE_BOUNDARY_HI = /.*?[।\|!\?]|.*?$/
    SENTENCE_BOUNDARY_HY = /.*?[։՜:]|.*?$/
    SENTENCE_BOUNDARY_MY = /.*?[။၏!\?]|.*?$/
    SENTENCE_BOUNDARY_UR = /.*?[۔؟!\?]|.*?$/

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

    SENTENCE_BOUNDARY_REGEX = /\u{ff08}(?:[^\u{ff09}])*\u{ff09}(?=\s?[A-Z])|\u{300c}(?:[^\u{300d}])*\u{300d}(?=\s[A-Z])|\((?:[^\)])*\)(?=\s[A-Z])|'(?:[^'])*'(?=\s[A-Z])|"(?:[^"])*"(?=\s[A-Z])|“(?:[^”])*”(?=\s[A-Z])|\S.*?[。．.！!?？ȸȹ☉☈☇☄]/

    attr_reader :text, :language, :doc_type
    def initialize(text:, **args)
      return [] unless text
      if args[:clean].nil? || args[:clean].eql?(true)
        @text = PragmaticSegmenter::Cleaner.new(text: text.dup, language: args[:language], doc_type: args[:doc_type]).clean
      else
        @text = text.dup
      end
      @language = args[:language] || 'en'
      @doc_type = args[:doc_type]
    end

    # Segment a text into an array of sentences
    #
    # Example:
    #   >> PragmaticSegmenter::Segment(text: "Hello world. My name is Kevin.").segment
    #   => ["Hello world.", "My name is Kevin."]
    #
    # Arguments:
    #    text:       (String)  *required
    #    language:   (String)  *optional
    #                (two-digit ISO 639-1 code e.g. 'en')
    #    doc_type:   (String)  *optional
    #                (e.g. 'pdf')
    #    clean:      (Boolean) *true unless specified

    def segment
      return [] unless text
      reformatted_text = PragmaticSegmenter::List.new(text: text).add_line_break
      reformatted_text = PragmaticSegmenter::AbbreviationReplacer.new(text: reformatted_text, language: language).replace
      reformatted_text = PragmaticSegmenter::Number.new(text: reformatted_text, language: language).replace
      reformatted_text = PragmaticSegmenter::Geolocation.new(text: reformatted_text).replace
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
        line << 'ȸ' unless end_punc_check || language.eql?('ar') || language.eql?('fa')
        PragmaticSegmenter::ExclamationWords.new(text: line).replace
        sub_punctuation_between_quotes_and_parens(line)
        line = replace_double_punctuation(line)
        case
        when language.eql?('ar')
          line = replace_non_sentence_boundary_punctuation_ar(line)
          subline = ar_split_at_sentence_boundary(line)
        when language.eql?('fa')
          line = replace_non_sentence_boundary_punctuation_fa(line)
          subline = fa_split_at_sentence_boundary(line)
        when language.eql?('hi')
          subline = hi_split_at_sentence_boundary(line)
        when language.eql?('hy')
          subline = hy_split_at_sentence_boundary(line)
        when language.eql?('el')
          subline = el_split_at_sentence_boundary(line)
        when language.eql?('my')
          subline = my_split_at_sentence_boundary(line)
        when language.eql?('am')
          subline = am_split_at_sentence_boundary(line)
        when language.eql?('ur')
          subline = ur_split_at_sentence_boundary(line)
        else
          line = replace_question_mark_in_quotation(line)
          line = replace_exclamation_point_in_quotation(line)
          line = replace_exclamation_point_before_comma_mid_sentence(line)
          line = replace_exclamation_point_mid_sentence(line)
          subline = line.scan(SENTENCE_BOUNDARY_REGEX)
        end
        subline.each_with_index do |s_l|
          segments << sub_symbols(s_l)
        end
      else
        line.gsub!(/ȹ/, "\n")
        line.gsub!(/∯/, '.')
        segments << line
      end
    end

    def replace_non_sentence_boundary_punctuation_fa(txt)
      txt.gsub(/(?<=\d):(?=\d)/, '♭').gsub(/،(?=\s\S+،)/, '♬')
    end

    def replace_non_sentence_boundary_punctuation_ar(txt)
      txt.gsub(/(?<=\d):(?=\d)/, '♭').gsub(/،(?=\s\S+،)/, '♬')
    end

    def replace_single_newline(txt)
      txt.gsub(/\n/, 'ȹ')
    end

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
      if language == 'de'
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

    def replace_double_punctuation(txt)
      txt.gsub(/\?!/, '☉')
        .gsub(/!\?/, '☈').gsub(/\?\?/, '☇')
        .gsub(/!!/, '☄')
    end

    def ar_split_at_sentence_boundary(txt)
      txt.scan(SENTENCE_BOUNDARY_AR)
    end

    def fa_split_at_sentence_boundary(txt)
      txt.scan(SENTENCE_BOUNDARY_FA)
    end

    def hi_split_at_sentence_boundary(txt)
      txt.scan(SENTENCE_BOUNDARY_HI)
    end

    def hy_split_at_sentence_boundary(txt)
      txt.scan(SENTENCE_BOUNDARY_HY)
    end

    def el_split_at_sentence_boundary(txt)
      txt.scan(SENTENCE_BOUNDARY_EL)
    end

    def my_split_at_sentence_boundary(txt)
      txt.scan(SENTENCE_BOUNDARY_MY)
    end

    def am_split_at_sentence_boundary(txt)
      txt.scan(SENTENCE_BOUNDARY_AM)
    end

    def ur_split_at_sentence_boundary(txt)
      txt.scan(SENTENCE_BOUNDARY_UR)
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
