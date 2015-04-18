module PragmaticSegmenter
  module Languages
    module Burmese
      include Languages::Common

      SENTENCE_BOUNDARY_REGEX = /.*?[။၏!\?]|.*?$/
      Punctuations = ['။', '၏', '?', '!']
    end
  end
end
