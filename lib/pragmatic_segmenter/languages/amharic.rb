module PragmaticSegmenter
  module Languages
    module Amharic
      include Languages::Common

      SENTENCE_BOUNDARY_REGEX = /.*?[፧።!\?]|.*?$/
      Punctuations = ['።', '፧', '?', '!']
    end
  end
end
