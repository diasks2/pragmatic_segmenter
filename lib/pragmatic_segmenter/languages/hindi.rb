module PragmaticSegmenter
  module Languages
    module Hindi
      include Languages::Common

      SENTENCE_BOUNDARY = /.*?[।\|!\?]|.*?$/
      Punctuations = ['।', '|', '.', '!', '?']

      class Process < Process
        private

        def sentence_boundary_punctuation(txt)
          txt.scan(SENTENCE_BOUNDARY)
        end
      end
    end
  end
end
