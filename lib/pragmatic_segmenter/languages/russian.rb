module PragmaticSegmenter
  module Languages
    class Russian
      class Abbreviation < PragmaticSegmenter::Abbreviation
        ABBREVIATIONS = ['а', 'авт', 'адм.-терр', 'акад', 'в', 'вв', 'вкз', 'вост.-европ', 'г', 'гг', 'гос', 'гр', 'д', 'деп', 'дисс', 'дол', 'долл', 'ежедн', 'ж', 'жен', 'з', 'зап', 'зап.-европ', 'заруб', 'и', 'И', 'и', 'ин', 'иностр', 'инст', 'к', 'кв', 'К', 'Кв', 'куб', 'канд', 'кг', 'л', 'м', 'мин', 'моск', 'муж', 'нед', 'о', 'о', 'О', 'о', 'п', 'пер', 'пп', 'пр', 'просп', 'р', 'руб', 'с', 'сек', 'см', 'СПб', 'стр', 'т', 'т', 'тел', 'тов', 'тт', 'тыс', 'ул', 'у.е', 'y.e', 'у', 'y', 'Ф', 'ф', 'ч', 'пгт', 'проф', 'л.h', 'Л.Н', 'Н']

        def all
          ABBREVIATIONS
        end

        def prepositive
          []
        end

        def number
          []
        end
      end

      class AbbreviationReplacer  < PragmaticSegmenter::AbbreviationReplacer
        private

        def scan_for_replacements(txt, am, index, character_array, abbr)
          character = character_array[index]
          prepositive = abbr.prepositive
          number_abbr = abbr.number
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

        def abbreviations
          PragmaticSegmenter::Languages::Russian::Abbreviation.new
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
