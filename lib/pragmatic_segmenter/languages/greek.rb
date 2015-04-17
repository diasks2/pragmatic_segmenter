module PragmaticSegmenter
  module Languages
    class Greek < Common
      SENTENCE_BOUNDARY = /.*?[\.;!\?]|.*?$/
      Punctuations = ['.', '!', ';', '?']

      class Process < PragmaticSegmenter::Process
        private

        def sentence_boundary_punctuation(txt)
          txt.scan(SENTENCE_BOUNDARY)
        end
      end
    end
  end
end
