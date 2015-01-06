module PragmaticSegmenter
  module Languages
    class Arabic
      class SentenceBoundaryPunctuation < PragmaticSegmenter::SentenceBoundaryPunctuation
        SENTENCE_BOUNDARY = /.*?[:\.!\?؟،]|.*?\z|.*?$/

        def split
          txt = replace_non_sentence_boundary_punctuation(text)
          txt.scan(SENTENCE_BOUNDARY)
        end

        private

        def replace_non_sentence_boundary_punctuation(txt)
          txt.gsub(/(?<=\d):(?=\d)/, '♭').gsub(/،(?=\s\S+،)/, '♬')
        end
      end

      class Abbreviation < PragmaticSegmenter::Abbreviation
        ABBREVIATIONS = ['ا', 'ا. د', 'ا.د', 'ا.ش.ا', 'ا.ش.ا', 'إلخ', 'ت.ب', 'ت.ب', 'ج.ب', 'جم', 'ج.ب', 'ج.م.ع', 'ج.م.ع', 'س.ت', 'س.ت', 'سم', 'ص.ب.', 'ص.ب', 'كج.', 'كلم.', 'م', 'م.ب', 'م.ب', 'ه', 'د‪']

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
    end
  end
end
