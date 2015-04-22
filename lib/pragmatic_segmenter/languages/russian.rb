module PragmaticSegmenter
  module Languages
    module Russian
      include Languages::Common

      module Abbreviation
        ABBREVIATIONS = ['а', 'авт', 'адм.-терр', 'акад', 'в', 'вв', 'вкз', 'вост.-европ', 'г', 'гг', 'гос', 'гр', 'д', 'деп', 'дисс', 'дол', 'долл', 'ежедн', 'ж', 'жен', 'з', 'зап', 'зап.-европ', 'заруб', 'и', 'И', 'и', 'ин', 'иностр', 'инст', 'к', 'кв', 'К', 'Кв', 'куб', 'канд', 'кг', 'л', 'м', 'мин', 'моск', 'муж', 'нед', 'о', 'о', 'О', 'о', 'п', 'пер', 'пп', 'пр', 'просп', 'р', 'руб', 'с', 'сек', 'см', 'СПб', 'стр', 'т', 'т', 'тел', 'тов', 'тт', 'тыс', 'ул', 'у.е', 'y.e', 'у', 'y', 'Ф', 'ф', 'ч', 'пгт', 'проф', 'л.h', 'Л.Н', 'Н']
        PREPOSITIVE_ABBREVIATIONS = []
        NUMBER_ABBREVIATIONS = []
      end

      class Process < Process
        private

        def replace_abbreviations(txt)
          AbbreviationReplacer.new(text: txt, language: Russian).replace
        end
      end

      class AbbreviationReplacer  < AbbreviationReplacer
        private

        def replace_period_of_abbr(txt, abbr)
          txt.gsub(/(?<=\s#{abbr.strip})\./, '∯')
            .gsub(/(?<=\A#{abbr.strip})\./, '∯')
            .gsub(/(?<=^#{abbr.strip})\./, '∯')
        end
      end
    end
  end
end
