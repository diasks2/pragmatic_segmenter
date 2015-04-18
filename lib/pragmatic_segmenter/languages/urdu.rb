module PragmaticSegmenter
  module Languages
    module Urdu
      include Languages::Common

      SENTENCE_BOUNDARY_REGEX = /.*?[۔؟!\?]|.*?$/
      Punctuations = ['?', '!', '۔', '؟']
    end
  end
end
