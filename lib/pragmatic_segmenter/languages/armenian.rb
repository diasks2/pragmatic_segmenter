module PragmaticSegmenter
  module Languages
    module Armenian
      include Languages::Common

      SENTENCE_BOUNDARY_REGEX = /.*?[։՜:]|.*?$/
      Punctuations = ['։', '՜', ':']
    end
  end
end
