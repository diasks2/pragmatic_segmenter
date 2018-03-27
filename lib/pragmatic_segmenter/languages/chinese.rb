# frozen_string_literal: true

module PragmaticSegmenter
  module Languages
    module Chinese
      include Languages::Common

      class AbbreviationReplacer < AbbreviationReplacer
        SENTENCE_STARTERS = [].freeze
      end
    end
  end
end
