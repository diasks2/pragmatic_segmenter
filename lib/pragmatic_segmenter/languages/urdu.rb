module PragmaticSegmenter
  module Languages
    module Urdu
      include Languages::Common

      SENTENCE_BOUNDARY = /.*?[۔؟!\?]|.*?$/
      Punctuations = ['?', '!', '۔', '؟']

      class Process < PragmaticSegmenter::Process
        private

        def sentence_boundary_punctuation(txt)
          txt.scan(SENTENCE_BOUNDARY)
        end

        def punctuation_array
          Punctuations
        end
      end
    end
  end
end
