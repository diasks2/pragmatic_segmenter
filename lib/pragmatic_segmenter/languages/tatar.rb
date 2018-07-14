# frozen_string_literal: true

module PragmaticSegmenter
  module Languages
    module Tatar
      include Languages::Common

      module Abbreviation
        ABBREVIATIONS = Set.new(["биекл", "биол", "б.э", "б.э.к", "геогр", "геол", "е", "елл", "к", "кг", "км", "км²", "км³", "лат", "м", "м²", "м³", "мәс", "млн", "млрд", "мм", "обл", "окр", "пед", "см", "т", "тех", "тирәнл", "трлн", "һ.б", "хим", "экон", "эл"]).freeze
        PREPOSITIVE_ABBREVIATIONS = [].freeze
        NUMBER_ABBREVIATIONS = [].freeze
      end

      class AbbreviationReplacer < AbbreviationReplacer
        SENTENCE_STARTERS = [].freeze

        private

        def replace_period_of_abbr(txt, abbr)
          txt.gsub!(/(?<=\s#{abbr.strip})\./, '∯')
          txt.gsub!(/(?<=\A#{abbr.strip})\./, '∯')
          txt.gsub!(/(?<=^#{abbr.strip})\./, '∯')
          txt
        end
      end
    end
  end
end
