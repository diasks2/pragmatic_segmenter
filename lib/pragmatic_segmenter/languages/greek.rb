module PragmaticSegmenter
  module Languages
    module Greek
      include Languages::Common

      SENTENCE_BOUNDARY_REGEX = /.*?[\.;!\?]|.*?$/
      Punctuations = ['.', '!', ';', '?']
    end
  end
end
