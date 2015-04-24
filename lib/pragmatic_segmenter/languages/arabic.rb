module PragmaticSegmenter
  module Languages
    module Arabic
      include Languages::Common

      Punctuations = ['?', '!', ':', '.', '؟', '،']
      SENTENCE_BOUNDARY_REGEX = /.*?[:\.!\?؟،]|.*?\z|.*?$/

      module Abbreviation
        ABBREVIATIONS = ['ا', 'ا. د', 'ا.د', 'ا.ش.ا', 'ا.ش.ا', 'إلخ', 'ت.ب', 'ت.ب', 'ج.ب', 'جم', 'ج.ب', 'ج.م.ع', 'ج.م.ع', 'س.ت', 'س.ت', 'سم', 'ص.ب.', 'ص.ب', 'كج.', 'كلم.', 'م', 'م.ب', 'م.ب', 'ه', 'د‪']
        PREPOSITIVE_ABBREVIATIONS = []
        NUMBER_ABBREVIATIONS = []
      end

      # Rubular: http://rubular.com/r/RX5HpdDIyv
      ReplaceColonBetweenNumbersRule = Rule.new(/(?<=\d):(?=\d)/, '♭')

      # Rubular: http://rubular.com/r/kPRgApNHUg
      ReplaceNonSentenceBoundaryCommaRule = Rule.new(/،(?=\s\S+،)/, '♬')

      class Process < Process
        private

        def sentence_boundary_punctuation(txt)
          txt = txt.apply(ReplaceColonBetweenNumbersRule, ReplaceNonSentenceBoundaryCommaRule)
          txt.scan(SENTENCE_BOUNDARY_REGEX)
        end

        def replace_abbreviations
          @text = AbbreviationReplacer.new(text: @text, language: @language).replace
        end
      end

      class AbbreviationReplacer  < AbbreviationReplacer
        private

        def scan_for_replacements(txt, am, index, character_array)
          txt.gsub(/(?<=#{am})\./, '∯')
        end
      end
    end
  end
end
