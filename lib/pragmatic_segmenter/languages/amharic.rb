module PragmaticSegmenter
  module Languages
    class Amharic < Common
      class Process < PragmaticSegmenter::Process
        private

        def sentence_boundary_punctuation(txt)
          Amharic::SentenceBoundaryPunctuation.new(text: txt).split
        end

        def punctuation_array
          Amharic::Punctuations
        end
      end

      class SentenceBoundaryPunctuation < PragmaticSegmenter::SentenceBoundaryPunctuation
        SENTENCE_BOUNDARY = /.*?[፧።!\?]|.*?$/

        def split
          text.scan(SENTENCE_BOUNDARY)
        end
      end

      Punctuations = ['።', '፧', '?', '!']
    end
  end
end
