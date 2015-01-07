module PragmaticSegmenter
  module Languages
    class Armenian
      class Process < PragmaticSegmenter::Process
        private

        def punctuation_array
          PragmaticSegmenter::Languages::Armenian::Punctuation.new.punct
        end
      end

      class SentenceBoundaryPunctuation < PragmaticSegmenter::SentenceBoundaryPunctuation
        SENTENCE_BOUNDARY = /.*?[։՜:]|.*?$/

        def split
          text.scan(SENTENCE_BOUNDARY)
        end
      end

      class Punctuation < PragmaticSegmenter::Punctuation
        PUNCT = ['։', '՜', ':']

        def punct
          PUNCT
        end
      end
    end
  end
end
