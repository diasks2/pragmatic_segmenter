module PragmaticSegmenter
  module Languages
    class Hindi
      class Process < PragmaticSegmenter::Process
        private

        def sentence_boundary_punctuation(txt)
          PragmaticSegmenter::Languages::Hindi::SentenceBoundaryPunctuation.new(text: txt).split
        end

        def punctuation_array
          PragmaticSegmenter::Languages::Hindi::Punctuation.new.punct
        end
      end

      class Cleaner < PragmaticSegmenter::Cleaner
      end

      class SentenceBoundaryPunctuation < PragmaticSegmenter::SentenceBoundaryPunctuation
        SENTENCE_BOUNDARY = /.*?[।\|!\?]|.*?$/

        def split
          text.scan(SENTENCE_BOUNDARY)
        end
      end

      class Punctuation < PragmaticSegmenter::Punctuation
        PUNCT = ['।', '|', '.', '!', '?']

        def punct
          PUNCT
        end
      end
    end
  end
end
