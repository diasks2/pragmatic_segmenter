module PragmaticSegmenter
  module Languages
    class Burmese
      class Process < PragmaticSegmenter::Process
        private

        def sentence_boundary_punctuation(txt)
          Burmese::SentenceBoundaryPunctuation.new(text: txt).split
        end

        def punctuation_array
          Burmese::Punctuations
        end
      end

      Cleaner = PragmaticSegmenter::Cleaner

      class SentenceBoundaryPunctuation < PragmaticSegmenter::SentenceBoundaryPunctuation
        SENTENCE_BOUNDARY = /.*?[။၏!\?]|.*?$/

        def split
          text.scan(SENTENCE_BOUNDARY)
        end
      end

      Punctuations = ['။', '၏', '?', '!']
    end
  end
end
