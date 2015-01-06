module PragmaticSegmenter
  module Languages
    class Greek
      class SentenceBoundaryPunctuation < PragmaticSegmenter::SentenceBoundaryPunctuation
        SENTENCE_BOUNDARY = /.*?[\.;!\?]|.*?$/

        def split
          text.scan(SENTENCE_BOUNDARY)
        end
      end
    end
  end
end
