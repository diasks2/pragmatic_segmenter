module PragmaticSegmenter
  module Languages
    class Deutsch
      class Number < PragmaticSegmenter::Number
        # Rubular: http://rubular.com/r/hZxoyQwKT1
        NUMBER_PERIOD_SPACE_REGEX = /(?<=\s[0-9]|\s([1-9][0-9]))\.(?=\s)/

        # Rubular: http://rubular.com/r/ityNMwdghj
        NEGATIVE_NUMBER_PERIOD_SPACE_REGEX = /(?<=-[0-9]|-([1-9][0-9]))\.(?=\s)/

        def replace
          super
          replace_period_related_to_numbers(@formatted_text)
        end

        private

        def replace_period_related_to_numbers(txt)
          new_text = replace_period_in_number_1(txt)
          replace_period_in_number_2(new_text)
        end

        def replace_period_in_number_1(txt)
          txt.gsub(NUMBER_PERIOD_SPACE_REGEX, '∯')
        end

        def replace_period_in_number_2(txt)
          txt.gsub(NEGATIVE_NUMBER_PERIOD_SPACE_REGEX, '∯')
        end
      end

      class SingleLetterAbbreviation < PragmaticSegmenter::SingleLetterAbbreviation
        # Rubular: http://rubular.com/r/B4X33QKIL8
        SINGLE_LOWERCASE_LETTER_REGEX = /(?<=\s[a-z])\.(?=\s)/

        # Rubular: http://rubular.com/r/iUNSkCuso0
        SINGLE_LOWERCASE_LETTER_AT_START_OF_LINE_REGEX = /(?<=^[a-z])\.(?=\s)/

        def replace
          super
          @formatted_text = replace_single_lowercase_letter(@formatted_text)
          replace_single_lowercase_letter_sol(@formatted_text)
        end

        private

        def replace_single_lowercase_letter_sol(txt)
          txt.gsub(SINGLE_LOWERCASE_LETTER_AT_START_OF_LINE_REGEX, '∯')
        end

        def replace_single_lowercase_letter(txt)
          txt.gsub(SINGLE_LOWERCASE_LETTER_REGEX, '∯')
        end
      end

      class Abbreviation < PragmaticSegmenter::Abbreviation
        ABBREVIATIONS = ['Ä', 'ä', 'adj', 'adm', 'adv', 'art', 'asst', 'b.a', 'b.s', 'bart', 'bldg', 'brig', 'bros', 'bse', 'buchst', 'bzgl', 'bzw', 'c.-à-d', 'ca', 'capt', 'chr', 'cmdr', 'co', 'col', 'comdr', 'con', 'corp', 'cpl', 'd.h', 'd.j', 'dergl', 'dgl', 'dkr', 'dr ', 'ens', 'etc', 'ev ', 'evtl', 'ff', 'g.g.a', 'g.u', 'gen', 'ggf', 'gov', 'hon', 'hosp', 'i.f', 'i.h.v', 'ii', 'iii', 'insp', 'iv', 'ix', 'jun', 'k.o', 'kath ', 'lfd', 'lt', 'ltd', 'm.e', 'maj', 'med', 'messrs', 'mio', 'mlle', 'mm', 'mme', 'mr', 'mrd', 'mrs', 'ms', 'msgr', 'mwst', 'no', 'nos', 'nr', 'o.ä', 'op', 'ord', 'pfc', 'ph', 'pp', 'prof', 'pvt', 'rep', 'reps', 'res', 'rev', 'rt', 's.p.a', 'sa', 'sen', 'sens', 'sfc', 'sgt', 'sog', 'sogen', 'spp', 'sr', 'st', 'std', 'str  ', 'supt', 'surg', 'u.a  ', 'u.e', 'u.s.w', 'u.u', 'u.ä', 'usf', 'usw', 'v', 'vgl', 'vi', 'vii', 'viii', 'vs', 'x', 'xi', 'xii', 'xiii', 'xiv', 'xix', 'xv', 'xvi', 'xvii', 'xviii', 'xx', 'z.b ', 'z.t ', 'z.z', 'z.zt', 'zt', 'zzt']
        NUMBER_ABBREVIATIONS = ['art', 'ca', 'no', 'nos', 'nr', 'pp']

        def all
          ABBREVIATIONS
        end

        def prepositive
          []
        end

        def number
          NUMBER_ABBREVIATIONS
        end
      end
    end
  end
end
