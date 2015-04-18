module PragmaticSegmenter
  module Languages
    module Hindi
      include Languages::Common

      SENTENCE_BOUNDARY_REGEX = /.*?[।\|!\?]|.*?$/
      Punctuations = ['।', '|', '.', '!', '?']
    end
  end
end
