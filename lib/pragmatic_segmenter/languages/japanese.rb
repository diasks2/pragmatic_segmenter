module PragmaticSegmenter
  module Languages
    class Japanese
      class Cleaner < PragmaticSegmenter::Cleaner
        # Rubular: http://rubular.com/r/N4kPuJgle7
        NEWLINE_IN_MIDDLE_OF_WORD_REGEX = /(?<=の)\n(?=\S)/

        def clean
          super
          @clean_text = remove_newline_in_middle_of_word(@clean_text)
        end

        private

        def remove_newline_in_middle_of_word(txt)
          txt.gsub(NEWLINE_IN_MIDDLE_OF_WORD_REGEX, '')
        end
      end
    end
  end
end