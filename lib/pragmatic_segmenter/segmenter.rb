# -*- encoding : utf-8 -*-
require 'pragmatic_segmenter/cleaner'
require 'pragmatic_segmenter/list'
require 'pragmatic_segmenter/abbreviation'
require 'pragmatic_segmenter/number'

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

    WORDS_WITH_EXCLAMATIONS = ['!Xũ', '!Kung', 'ǃʼOǃKung', '!Xuun', '!Kung-Ekoka', 'ǃHu', 'ǃKhung', 'ǃKu', 'ǃung', 'ǃXo', 'ǃXû', 'ǃXung', 'ǃXũ', '!Xun', 'Yahoo!', 'Y!J', 'Yum!']

    # Rubular: http://rubular.com/r/yqa4Rit8EY
    POSSESSIVE_ABBREVIATION_REGEX = /\.(?='s\s)|\.(?='s$)|\.(?='s\z)/

    # Rubular: http://rubular.com/r/G2opjedIm9
    GEO_LOCATION_REGEX = /(?<=[a-zA-z]°)\.(?=\s*\d+)/

    # Rubular: http://rubular.com/r/i60hCK81fz
    ELLIPSIS_3_CONSECUTIVE_REGEX = /\.\.\.(?=\s+[A-Z])/

    # Rubular: http://rubular.com/r/Hdqpd90owl
    ELLIPSIS_4_CONSECUTIVE_REGEX = /(?<=\S)\.{3}(?=\.\s[A-Z])/

    # Rubular: http://rubular.com/r/YBG1dIHTRu
    ELLIPSIS_3_SPACE_REGEX = /(\s\.){3}\s/

    # Rubular: http://rubular.com/r/2VvZ8wRbd8
    ELLIPSIS_4_SPACE_REGEX = /(?<=[a-z])(\.\s){3}\.(\z|$|\n)/

    # Rubular: http://rubular.com/r/e3H6kwnr6H
    SINGLE_UPPERCASE_LETTER_AT_START_OF_LINE_REGEX =  /(?<=^[A-Z])\.(?=\s)/

    # Rubular: http://rubular.com/r/gitvf0YWH4
    SINGLE_UPPERCASE_LETTER_REGEX = /(?<=\s[A-Z])\.(?=\s)/

    # Rubular: http://rubular.com/r/B4X33QKIL8
    SINGLE_LOWERCASE_LETTER_DE_REGEX = /(?<=\s[a-z])\.(?=\s)/

    # Rubular: http://rubular.com/r/iUNSkCuso0
    SINGLE_LOWERCASE_LETTER_AT_START_OF_LINE_DE_REGEX = /(?<=^[a-z])\.(?=\s)/

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

    attr_reader :language, :doc_type
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
      return [] unless @text
      @text = PragmaticSegmenter::List.new(text: @text).add_line_break
      process_abbr
      @text = PragmaticSegmenter::Number.new(text: @text, language: language).replace
      multi_period_abbr
      abbr_as_sentence_boundary
      replace_geo_location_periods
      split_lines
    end

    private

    def process_abbr
      original = @text.dup
      replace_possessive_abbreviations
      replace_single_uppercase_letter_abbrviation_at_start_of_line
      replace_single_uppercase_letter_abbreviation
      replace_single_lowercase_letter_de
      replace_single_lowercase_letter_at_start_of_line_de

      downcased = @text.downcase
      abbr = PragmaticSegmenter::Abbreviation.new(language: language)
      abbr.all.each do |a|
        next unless downcased.include?(a.strip)
        abbrev_match = original.scan(/(?:^|\s|\r|\n)#{Regexp.escape(a.strip)}/i)
        next if abbrev_match.empty?
        next_word_start = /(?<=#{Regexp.escape(a.strip)} ).{1}/
        character_array = @text.scan(next_word_start)
        abbrev_match.each_with_index do |am, index|
          if language.eql?('de')
            @text = replace_abbr_de(@text, am)
          elsif language.eql?('ar') || language.eql?('fa')
            @text = replace_abbr_ar_fa(@text, am)
          else
            character = character_array[index]
            prefix = abbr.prefix
            number_abbr = abbr.number
            upper = /[[:upper:]]/.match(character.to_s)
            if upper.nil? || prefix.include?(am.downcase.strip)
              if prefix.include?(am.downcase.strip)
                @text = replace_prepositive_abbr(@text, am)
              elsif number_abbr.include?(am.downcase.strip)
                @text = replace_pre_number_abbr(@text, am)
              else
                if language.eql?('ru')
                  @text = replace_period_of_abbr_ru(@text, am)
                else
                  @text = replace_period_of_abbr(@text, am)
                end
              end
            end
          end
        end
      end
    end

    def replace_abbr_de(txt, abbr)
      txt.gsub(/(?<=#{abbr})\.(?=\s)/, '∯')
    end

    def replace_abbr_ar_fa(txt, abbr)
      txt.gsub(/(?<=#{abbr})\./, '∯')
    end

    def replace_pre_number_abbr(txt, abbr)
      txt.gsub(/(?<=#{abbr.strip})\.(?=\s\d)/, '∯').gsub(/(?<=#{abbr.strip})\.(?=\s+\()/, '∯')
    end

    def replace_prepositive_abbr(txt, abbr)
      txt.gsub(/(?<=#{abbr.strip})\.(?=\s)/, '∯')
    end

    def replace_period_of_abbr(txt, abbr)
      txt.gsub(/(?<=#{abbr.strip})\.(?=((\.|:|\?)|(\s([a-z]|I\s|I'm|I'll|\d))))/, '∯')
        .gsub(/(?<=#{abbr.strip})\.(?=,)/, '∯')
    end

    def replace_period_of_abbr_ru(txt, abbr)
      txt.gsub(/(?<=\s#{abbr.strip})\./, '∯')
        .gsub(/(?<=\A#{abbr.strip})\./, '∯')
        .gsub(/(?<=^#{abbr.strip})\./, '∯')
    end

    def replace_single_lowercase_letter_at_start_of_line_de
      @text.gsub!(SINGLE_LOWERCASE_LETTER_AT_START_OF_LINE_DE_REGEX, '∯') if language.eql?('de')
    end

    def replace_single_lowercase_letter_de
      @text.gsub!(SINGLE_LOWERCASE_LETTER_DE_REGEX, '∯') if language.eql?('de')
    end

    def replace_single_uppercase_letter_abbrviation_at_start_of_line
      @text.gsub!(SINGLE_UPPERCASE_LETTER_AT_START_OF_LINE_REGEX, '∯')
    end

    def replace_single_uppercase_letter_abbreviation
      @text.gsub!(SINGLE_UPPERCASE_LETTER_REGEX, '∯')
    end

    def replace_possessive_abbreviations
      @text.gsub!(POSSESSIVE_ABBREVIATION_REGEX, '∯')
    end

    def abbr_as_sentence_boundary
      # Find the most common cases where abbreviations double as sentence boundaries.
      %w(A Being Did For He How However I In Millions More She That The There They We What When Where Who Why).each do |word|
        @text.gsub!(/U∯S∯\s#{Regexp.escape(word)}\s/, "U∯S\.\s#{Regexp.escape(word)}\s")
        @text.gsub!(/U\.S∯\s#{Regexp.escape(word)}\s/, "U\.S\.\s#{Regexp.escape(word)}\s")
        @text.gsub!(/U∯K∯\s#{Regexp.escape(word)}\s/, "U∯K\.\s#{Regexp.escape(word)}\s")
        @text.gsub!(/U\.K∯\s#{Regexp.escape(word)}\s/, "U\.K\.\s#{Regexp.escape(word)}\s")
        @text.gsub!(/E∯U∯\s#{Regexp.escape(word)}\s/, "E∯U\.\s#{Regexp.escape(word)}\s")
        @text.gsub!(/E\.U∯\s#{Regexp.escape(word)}\s/, "E\.U\.\s#{Regexp.escape(word)}\s")
        @text.gsub!(/U∯S∯A∯\s#{Regexp.escape(word)}\s/, "U∯S∯A\.\s#{Regexp.escape(word)}\s")
        @text.gsub!(/U\.S\.A∯\s#{Regexp.escape(word)}\s/, "U\.S\.A\.\s#{Regexp.escape(word)}\s")
        @text.gsub!(/I∯\s#{Regexp.escape(word)}\s/, "I\.\s#{Regexp.escape(word)}\s")
      end
    end

    def replace_geo_location_periods
      @text.gsub!(GEO_LOCATION_REGEX, '∯')
    end

    def replace_ellipsis(line)
      # http://www.dailywritingtips.com/in-search-of-a-4-dot-ellipsis/
      # http://www.thepunctuationguide.com/ellipses.html
      line = replace_3_period_ellipsis_with_spaces(line)
      line = replace_4_period_ellipsis_with_spaces(line)
      line = replace_4_consecutive_period_ellipsis(line)
      line = replace_3_consecutive_period_ellipsis(line)
      replace_other_3_period_ellipsis(line)
    end

    def replace_3_period_ellipsis_with_spaces(line)
      line.gsub(ELLIPSIS_3_SPACE_REGEX, '♟')
    end

    def replace_4_period_ellipsis_with_spaces(line)
      line.gsub(ELLIPSIS_4_SPACE_REGEX, '♝')
    end

    def replace_4_consecutive_period_ellipsis(line)
      line.gsub(ELLIPSIS_4_CONSECUTIVE_REGEX, 'ƪ')
    end

    def replace_3_consecutive_period_ellipsis(line)
      line.gsub(ELLIPSIS_3_CONSECUTIVE_REGEX, '☏.')
    end

    def replace_other_3_period_ellipsis(line)
      line.gsub(/\.\.\./, 'ƪ')
    end

    def replace_periods_in_email_addresses(line)
      line.gsub(/(\w)(\.)(\w)/, '\1∮\3')
    end

    def replace_single_newline(line)
      line.gsub(/\n/, 'ȹ')
    end

    def analyze_lines(line:, segments:)
      line = replace_single_newline(line)
      line = replace_ellipsis(line)
      line = replace_periods_in_email_addresses(line)

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

        sub_part_of_word_exclamation_points(line)
        sub_punctuation_between_quotes_and_parens(line)
        line = replace_double_punctuation(line)
        case
        when language.eql?('ar')
          line.gsub!(/(?<=\d):(?=\d)/, '♭')
          line.gsub!(/،(?=\s\S+،)/, '♬')
          subline = ar_split_at_sentence_boundary(line)
        when language.eql?('fa')
          line.gsub!(/(?<=\d):(?=\d)/, '♭')
          line.gsub!(/،(?=\s\S+،)/, '♬')
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

    def sub_punctuation_between_quotes_and_parens(line)
      sub_punctuation_between_single_quotes(line)
      sub_punctuation_between_double_quotes(line)
      sub_punctuation_between_quotes_ja(line)
      sub_punctuation_between_parens(line)
      sub_punctuation_between_parens_ja(line)
      sub_punctuation_between_quotes_arrow(line)
      sub_punctuation_between_quotes_slanted(line)
    end

    def sub_part_of_word_exclamation_points(line)
      WORDS_WITH_EXCLAMATIONS.each do |exclamation|
        sub_punct(line.scan(/#{Regexp.escape(exclamation)}/), line)
      end
    end

    def sub_punctuation_between_parens(line)
      sub_punct(line.scan(BETWEEN_PARENS_REGEX), line)
    end

    def sub_punctuation_between_parens_ja(line)
      sub_punct(line.scan(BETWEEN_PARENS_JA_REGEX), line)
    end

    def sub_punctuation_between_single_quotes(line)
      sub_punct(line.scan(BETWEEN_SINGLE_QUOTES_REGEX), line)
    end

    def sub_punctuation_between_double_quotes(line)
      if language == 'de'
        btwn_dbl_quote = sub_punctuation_between_double_quotes_de(line)
      else
        btwn_dbl_quote = line.scan(BETWEEN_DOUBLE_QUOTES_REGEX)
      end
      sub_punct(btwn_dbl_quote, line)
    end

    def sub_punctuation_between_quotes_ja(line)
      sub_punct(line.scan(BETWEEN_QUOTE_JA_REGEX), line)
    end

    def sub_punctuation_between_quotes_arrow(line)
      sub_punct(line.scan(BETWEEN_QUOTE_ARROW_REGEX), line)
    end

    def sub_punctuation_between_quotes_slanted(line)
      sub_punct(line.scan(BETWEEN_QUOTE_SLANTED_REGEX), line)
    end

    def sub_punctuation_between_double_quotes_de(line)
      if line.include?('„')
        btwn_dbl_quote = line.scan(BETWEEN_DOUBLE_QUOTES_DE_REGEX)
        line.scan(SPLIT_DOUBLE_QUOTES_DE_REGEX).each do |q|
          btwn_dbl_quote << q
        end
      elsif line.include?(',,')
        btwn_dbl_quote = line.scan(BETWEEN_UNCONVENTIONAL_DOUBLE_QUOTE_DE_REGEX)
      end
      btwn_dbl_quote
    end

    def replace_double_punctuation(line)
      line.gsub(/\?!/, '☉')
        .gsub(/!\?/, '☈').gsub(/\?\?/, '☇')
        .gsub(/!!/, '☄')
    end

    def ar_split_at_sentence_boundary(ar_line)
      ar_line.scan(SENTENCE_BOUNDARY_AR)
    end

    def fa_split_at_sentence_boundary(fa_line)
      fa_line.scan(SENTENCE_BOUNDARY_FA)
    end

    def hi_split_at_sentence_boundary(hi_line)
      hi_line.scan(SENTENCE_BOUNDARY_HI)
    end

    def hy_split_at_sentence_boundary(hy_line)
      hy_line.scan(SENTENCE_BOUNDARY_HY)
    end

    def el_split_at_sentence_boundary(el_line)
      el_line.scan(SENTENCE_BOUNDARY_EL)
    end

    def my_split_at_sentence_boundary(my_line)
      my_line.scan(SENTENCE_BOUNDARY_MY)
    end

    def am_split_at_sentence_boundary(am_line)
      am_line.scan(SENTENCE_BOUNDARY_AM)
    end

    def ur_split_at_sentence_boundary(ur_line)
      ur_line.scan(SENTENCE_BOUNDARY_UR)
    end

    def replace_exclamation_point_before_comma_mid_sentence(line)
      line.gsub(EXCLAMATION_POINT_BEFORE_COMMA_MID_SENTENCE_REGEX, 'ᓴ')
    end

    def replace_exclamation_point_mid_sentence(line)
      line.gsub(EXCLAMATION_POINT_MID_SENTENCE_REGEX, 'ᓴ')
    end

    def replace_exclamation_point_in_quotation(line)
      line.gsub(EXCLAMATION_POINT_IN_QUOTATION_REGEX, 'ᓴ')
    end

    def replace_question_mark_in_quotation(line)
      line.gsub(QUESTION_MARK_IN_QUOTATION_REGEX, 'ᓷ')
    end

    def sub_symbols(txt)
      txt.gsub(/∯/, '.').gsub(/♬/, '،').gsub(/♭/, ':').gsub(/ᓰ/, '。').gsub(/ᓱ/, '．')
        .gsub(/ᓳ/, '！').gsub(/ᓴ/, '!').gsub(/ᓷ/, '?').gsub(/ᓸ/, '？').gsub(/☉/, '?!')
        .gsub(/☈/, '!?').gsub(/☇/, '??').gsub(/☄/, '!!').delete('ȸ').gsub(/ȹ/, "\n")
    end

    def multi_period_abbr
      # Rubular: http://rubular.com/r/xDkpFZ0EgH
      mpa = @text.scan(/\b[a-z](?:\.[a-z])+[.]/i)
      unless mpa.empty?
        mpa.each do |r|
          @text.gsub!(/#{Regexp.escape(r)}/, "#{r.gsub!('.', '∯')}")
        end
      end
      replace_period_in_am_pm
    end

    def replace_period_in_am_pm
      # Rubular: http://rubular.com/r/Vnx3m4Spc8
      @text.gsub!(/(?<=a∯m)∯(?=\s[A-Z])/, '.')
      @text.gsub!(/(?<=A∯M)∯(?=\s[A-Z])/, '.')
      @text.gsub!(/(?<=p∯m)∯(?=\s[A-Z])/, '.')
      @text.gsub!(/(?<=P∯M)∯(?=\s[A-Z])/, '.')
    end

    def sub_punct(array, content)
      return if !array || array.empty?
      content.gsub!('(', '\\(')
      content.gsub!(')', '\\)')
      content.gsub!(']', '\\]')
      content.gsub!('[', '\\[')
      content.gsub!('-', '\\-')
      array.each do |a|
        a.gsub!('(', '\\(')
        a.gsub!(')', '\\)')
        a.gsub!(']', '\\]')
        a.gsub!('[', '\\[')
        a.gsub!('-', '\\-')

        sub = a.gsub('.', '∯')
        content.gsub!(/#{Regexp.escape(a)}/, "#{sub}")

        sub_1 = sub.gsub('。', 'ᓰ')
        content.gsub!(/#{Regexp.escape(sub)}/, "#{sub_1}")

        sub_2 = sub_1.gsub('．', 'ᓱ')
        content.gsub!(/#{Regexp.escape(sub_1)}/, "#{sub_2}")

        sub_3 = sub_2.gsub('！', 'ᓳ')
        content.gsub!(/#{Regexp.escape(sub_2)}/, "#{sub_3}")

        sub_4 = sub_3.gsub('!', 'ᓴ')
        content.gsub!(/#{Regexp.escape(sub_3)}/, "#{sub_4}")

        sub_5 = sub_4.gsub('?', 'ᓷ')
        content.gsub!(/#{Regexp.escape(sub_4)}/, "#{sub_5}")

        sub_6 = sub_5.gsub('？', 'ᓸ')
        content.gsub!(/#{Regexp.escape(sub_5)}/, "#{sub_6}")
      end
      content.gsub!('\\(', '(')
      content.gsub!('\\)', ')')
      content.gsub!('\\[', '[')
      content.gsub!('\\]', ']')
      content.gsub!('\\-', '-')
      content
    end

    def split_lines
      segments = []
      lines = @text.split("\r")
      lines.each do |l|
        next if l == ''
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
