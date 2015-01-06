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

    attr_reader :text
    def initialize(text:)
      @text = text
    end

    def replace
      @formatted_text = replace_period_before_number(text)
      @formatted_text = replace_period_after_number_before_letter(@formatted_text)
      @formatted_text = replace_period_after_number_after_newline(@formatted_text)
      @formatted_text = replace_period_after_start_line_number(@formatted_text)
      @formatted_text = replace_period_after_start_line_two_digit_number(@formatted_text)
    end

    private

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
  end
end
