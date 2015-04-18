module PragmaticSegmenter
  module Languages
    module Russian
      include Languages::Common

      ABBREVIATIONS = ['а', 'авт', 'адм.-терр', 'акад', 'в', 'вв', 'вкз', 'вост.-европ', 'г', 'гг', 'гос', 'гр', 'д', 'деп', 'дисс', 'дол', 'долл', 'ежедн', 'ж', 'жен', 'з', 'зап', 'зап.-европ', 'заруб', 'и', 'И', 'и', 'ин', 'иностр', 'инст', 'к', 'кв', 'К', 'Кв', 'куб', 'канд', 'кг', 'л', 'м', 'мин', 'моск', 'муж', 'нед', 'о', 'о', 'О', 'о', 'п', 'пер', 'пп', 'пр', 'просп', 'р', 'руб', 'с', 'сек', 'см', 'СПб', 'стр', 'т', 'т', 'тел', 'тов', 'тт', 'тыс', 'ул', 'у.е', 'y.e', 'у', 'y', 'Ф', 'ф', 'ч', 'пгт', 'проф', 'л.h', 'Л.Н', 'Н']

      class Process < PragmaticSegmenter::Process
        private

        def replace_abbreviations(txt)
          AbbreviationReplacer.new(text: txt, language: Russian).replace
        end
      end

      module Abbreviation
        def self.all
          ABBREVIATIONS
        end

        def self.prepositive
          []
        end

        def self.number
          []
        end
      end

      class AbbreviationReplacer  < PragmaticSegmenter::AbbreviationReplacer
        private

        def scan_for_replacements(txt, am, index, character_array)
          character = character_array[index]
          prepositive = @language::PREPOSITIVE_ABBREVIATIONS
          number_abbr = @language::NUMBER_ABBREVIATIONS
          upper = /[[:upper:]]/.match(character.to_s)
          if upper.nil? || prepositive.include?(am.downcase.strip)
            if prepositive.include?(am.downcase.strip)
              txt = replace_prepositive_abbr(txt, am)
            elsif number_abbr.include?(am.downcase.strip)
              txt = replace_pre_number_abbr(txt, am)
            else
              txt = replace_period_of_abbr(txt, am)
            end
          end
          txt
        end

        def replace_period_of_abbr(txt, abbr)
          txt.gsub(/(?<=\s#{abbr.strip})\./, '∯')
            .gsub(/(?<=\A#{abbr.strip})\./, '∯')
            .gsub(/(?<=^#{abbr.strip})\./, '∯')
        end
      end
    end
  end
end
