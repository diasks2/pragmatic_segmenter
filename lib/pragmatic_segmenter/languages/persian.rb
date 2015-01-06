module PragmaticSegmenter
  module Languages
    class Persian
      class SentenceBoundaryPunctuation < PragmaticSegmenter::SentenceBoundaryPunctuation
        SENTENCE_BOUNDARY = /.*?[:\.!\?؟]|.*?\z|.*?$/

        def split
          txt = replace_non_sentence_boundary_punctuation(text)
          txt.scan(SENTENCE_BOUNDARY)
        end

        private

        def replace_non_sentence_boundary_punctuation(txt)
          txt.gsub(/(?<=\d):(?=\d)/, '♭').gsub(/،(?=\s\S+،)/, '♬')
        end
      end

      class Punctuation < PragmaticSegmenter::Punctuation
        PUNCT = ['?', '!', ':', '.', '؟']

        def punct
          PUNCT
        end
      end
    end
  end
end
