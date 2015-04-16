module PragmaticSegmenter
  module Languages
    class Hindi
      class Process < PragmaticSegmenter::Process
        private

        def sentence_boundary_punctuation(txt)
          Hindi::SentenceBoundaryPunctuation.new(text: txt).split
        end

        def punctuation_array
          Hindi::Punctuations
        end
      end

      Cleaner = PragmaticSegmenter::Cleaner

      class SentenceBoundaryPunctuation < PragmaticSegmenter::SentenceBoundaryPunctuation
        SENTENCE_BOUNDARY = /.*?[।\|!\?]|.*?$/

        def split
          text.scan(SENTENCE_BOUNDARY)
        end
      end

      Punctuations = ['।', '|', '.', '!', '?']
    end
  end
end
