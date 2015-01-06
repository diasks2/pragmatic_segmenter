module PragmaticSegmenter
  module Languages
    class Deutsch
      class Number < PragmaticSegmenter::Number
        # Rubular: http://rubular.com/r/hZxoyQwKT1
        NUMBER_PERIOD_SPACE_REGEX = /(?<=\s[0-9]|\s([1-9][0-9]))\.(?=\s)/

        # Rubular: http://rubular.com/r/ityNMwdghj
        NEGATIVE_NUMBER_PERIOD_SPACE_REGEX = /(?<=-[0-9]|-([1-9][0-9]))\.(?=\s)/

        def replace
          super
          replace_period_related_to_numbers(@formatted_text)
        end

        private

        def replace_period_related_to_numbers(txt)
          new_text = replace_period_in_number_1(txt)
          replace_period_in_number_2(new_text)
        end

        def replace_period_in_number_1(txt)
          txt.gsub(NUMBER_PERIOD_SPACE_REGEX, '∯')
        end

        def replace_period_in_number_2(txt)
          txt.gsub(NEGATIVE_NUMBER_PERIOD_SPACE_REGEX, '∯')
        end
      end

      class SingleLetterAbbreviation < PragmaticSegmenter::SingleLetterAbbreviation
        # Rubular: http://rubular.com/r/B4X33QKIL8
        SINGLE_LOWERCASE_LETTER_REGEX = /(?<=\s[a-z])\.(?=\s)/

        # Rubular: http://rubular.com/r/iUNSkCuso0
        SINGLE_LOWERCASE_LETTER_AT_START_OF_LINE_REGEX = /(?<=^[a-z])\.(?=\s)/

        def replace
          super
          @formatted_text = replace_single_lowercase_letter(@formatted_text)
          replace_single_lowercase_letter_sol(@formatted_text)
        end

        private

        def replace_single_lowercase_letter_sol(txt)
          txt.gsub(SINGLE_LOWERCASE_LETTER_AT_START_OF_LINE_REGEX, '∯')
        end

        def replace_single_lowercase_letter(txt)
          txt.gsub(SINGLE_LOWERCASE_LETTER_REGEX, '∯')
        end
      end
    end
  end
end
