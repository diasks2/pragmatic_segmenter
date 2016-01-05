module PragmaticSegmenter
  module Languages
    module Burmese
      include Languages::Common

      SENTENCE_BOUNDARY_REGEX = /.*?[။၏!\?]|.*?$/
      Punctuations = ['။', '၏', '?', '!']

      class AbbreviationReplacer < AbbreviationReplacer
        SENTENCE_STARTERS = [].freeze
      end
    end
  end
end
