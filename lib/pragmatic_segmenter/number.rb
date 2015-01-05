# -*- encoding : utf-8 -*-

module PragmaticSegmenter
  # This class searches for numbers with periods within a string and
  # replaces the periods.
  class Number
    # Rubular: http://rubular.com/r/oNyxBOqbyy
    PERIOD_BEFORE_NUMBER_REGEX = /\.(?=\d)/

    # Rubular: http://rubular.com/r/EMk5MpiUzt
    NUMBER_PERIOD_LETTER_REGEX = /(?<=\d)\.(?=\S)/

    # Rubular: http://rubular.com/r/rf4l1HjtjG
    NEWLINE_NUMBER_PERIOD_SPACE_LETTER_REGEX = /(?<=\r\d)\.(?=(\s\S)|\))/

    # Rubular: http://rubular.com/r/HPa4sdc6b9
    START_LINE_NUMBER_PERIOD_REGEX = /(?<=^\d)\.(?=(\s\S)|\))/

    # Rubular: http://rubular.com/r/NuvWnKleFl
    START_LINE_TWO_DIGIT_NUMBER_PERIOD_REGEX = /(?<=^\d\d)\.(?=(\s\S)|\))/

    # Rubular: http://rubular.com/r/hZxoyQwKT1
    NUMBER_PERIOD_SPACE_DE_REGEX = /(?<=\s[0-9]|\s([1-9][0-9]))\.(?=\s)/

    # Rubular: http://rubular.com/r/ityNMwdghj
    NEGATIVE_NUMBER_PERIOD_SPACE_DE_REGEX = /(?<=-[0-9]|-([1-9][0-9]))\.(?=\s)/

    attr_reader :text, :language
    def initialize(text:, **args)
      @text = text.dup
      @language = args[:language]
    end

    def replace
      formatted_text = replace_period_before_number(text)
      formatted_text = replace_period_after_number_before_letter(formatted_text)
      formatted_text = replace_period_after_number_after_newline(formatted_text)
      formatted_text = replace_period_after_start_line_number(formatted_text)
      formatted_text =
        replace_period_after_start_line_two_digit_number(formatted_text)
      replace_period_related_to_numbers_de(formatted_text)
    end

    private

    def replace_period_related_to_numbers_de(txt)
      return txt unless language.eql?('de')
      new_text = de_replace_period_in_number_1(txt)
      de_replace_period_in_number_2(new_text)
    end

    def replace_period_before_number(txt)
      txt.gsub(PERIOD_BEFORE_NUMBER_REGEX, '∯')
    end

    def replace_period_after_number_before_letter(txt)
      txt.gsub(NUMBER_PERIOD_LETTER_REGEX, '∯')
    end

    def replace_period_after_number_after_newline(txt)
      txt.gsub(NEWLINE_NUMBER_PERIOD_SPACE_LETTER_REGEX, '∯')
    end

    def replace_period_after_start_line_number(txt)
      txt.gsub(START_LINE_NUMBER_PERIOD_REGEX, '∯')
    end

    def replace_period_after_start_line_two_digit_number(txt)
      txt.gsub(START_LINE_TWO_DIGIT_NUMBER_PERIOD_REGEX, '∯')
    end

    def de_replace_period_in_number_1(txt)
      txt.gsub(NUMBER_PERIOD_SPACE_DE_REGEX, '∯')
    end

    def de_replace_period_in_number_2(txt)
      txt.gsub(NEGATIVE_NUMBER_PERIOD_SPACE_DE_REGEX, '∯')
    end
  end
end
