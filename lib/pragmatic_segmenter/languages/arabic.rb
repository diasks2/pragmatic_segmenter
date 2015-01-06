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
    end
  end
end
