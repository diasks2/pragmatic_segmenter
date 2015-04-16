module PragmaticSegmenter
  module Languages
    class Arabic < Common
      Punctuations = ['?', '!', ':', '.', '؟', '،']
      SENTENCE_BOUNDARY = /.*?[:\.!\?؟،]|.*?\z|.*?$/
      ABBREVIATIONS = ['ا', 'ا. د', 'ا.د', 'ا.ش.ا', 'ا.ش.ا', 'إلخ', 'ت.ب', 'ت.ب', 'ج.ب', 'جم', 'ج.ب', 'ج.م.ع', 'ج.م.ع', 'س.ت', 'س.ت', 'سم', 'ص.ب.', 'ص.ب', 'كج.', 'كلم.', 'م', 'م.ب', 'م.ب', 'ه', 'د‪']

      # Rubular: http://rubular.com/r/RX5HpdDIyv
      ReplaceColonBetweenNumbersRule = Rule.new(/(?<=\d):(?=\d)/, '♭')

      # Rubular: http://rubular.com/r/kPRgApNHUg
      ReplaceNonSentenceBoundaryCommaRule = Rule.new(/،(?=\s\S+،)/, '♬')

      class Process < PragmaticSegmenter::Process
        private

        def sentence_boundary_punctuation(txt)
          Arabic::SentenceBoundaryPunctuation.new(text: txt).split
        end

        def replace_abbreviations(txt)
          Arabic::AbbreviationReplacer.new(text: txt).replace
        end

        def punctuation_array
          Arabic::Punctuations
        end
      end

      class SentenceBoundaryPunctuation < PragmaticSegmenter::SentenceBoundaryPunctuation

        def split
          txt = replace_non_sentence_boundary_punctuation(text)
          txt.scan(SENTENCE_BOUNDARY)
        end

        private

        def replace_non_sentence_boundary_punctuation(txt)
          txt.apply(ReplaceColonBetweenNumbersRule).
              apply(ReplaceNonSentenceBoundaryCommaRule)
        end
      end

      class Abbreviation
        def all
          ABBREVIATIONS
        end

        def prepositive
          []
        end

        def number
          []
        end
      end

      class AbbreviationReplacer  < PragmaticSegmenter::AbbreviationReplacer
        private

        def scan_for_replacements(txt, am, index, character_array, abbr)
          txt.gsub(/(?<=#{am})\./, '∯')
        end

        def abbreviations
          Arabic::Abbreviation.new
        end
      end
    end
  end
end
