module PragmaticSegmenter
  module Languages
    class Greek < Common
      class Process < PragmaticSegmenter::Process
        private

        def sentence_boundary_punctuation(txt)
          Greek::SentenceBoundaryPunctuation.new(text: txt).split
        end
      end

      class SentenceBoundaryPunctuation < PragmaticSegmenter::SentenceBoundaryPunctuation
        SENTENCE_BOUNDARY = /.*?[\.;!\?]|.*?$/

        def split
          text.scan(SENTENCE_BOUNDARY)
        end
      end

      Punctuations = ['.', '!', ';', '?']
    end
  end
end
