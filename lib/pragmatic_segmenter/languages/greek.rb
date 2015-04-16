module PragmaticSegmenter
  module Languages
    class Greek
      class Process < PragmaticSegmenter::Process
        private

        def sentence_boundary_punctuation(txt)
          Greek::SentenceBoundaryPunctuation.new(text: txt).split
        end
      end

      Cleaner = PragmaticSegmenter::Cleaner

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
