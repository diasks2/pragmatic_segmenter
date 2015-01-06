# -*- encoding : utf-8 -*-

module PragmaticSegmenter
  # This class searches for periods within an abbreviation and
  # replaces the periods.
  class SingleLetterAbbreviation
    # Rubular: http://rubular.com/r/e3H6kwnr6H
    SINGLE_UPPERCASE_LETTER_AT_START_OF_LINE_REGEX = /(?<=^[A-Z])\.(?=\s)/

    # Rubular: http://rubular.com/r/gitvf0YWH4
    SINGLE_UPPERCASE_LETTER_REGEX = /(?<=\s[A-Z])\.(?=\s)/

    attr_reader :text
    def initialize(text:)
      @text = text
    end

    def replace
      @formatted_text = replace_single_letter_abbreviations(text)
    end

    private

    def replace_single_letter_abbreviations(txt)
      new_text = replace_single_uppercase_letter_abbreviation_at_start_of_line(txt)
      replace_single_uppercase_letter_abbreviation(new_text)
    end

    def replace_single_uppercase_letter_abbreviation_at_start_of_line(txt)
      txt.gsub(SINGLE_UPPERCASE_LETTER_AT_START_OF_LINE_REGEX, '∯')
    end

    def replace_single_uppercase_letter_abbreviation(txt)
      txt.gsub(SINGLE_UPPERCASE_LETTER_REGEX, '∯')
    end
  end
end
