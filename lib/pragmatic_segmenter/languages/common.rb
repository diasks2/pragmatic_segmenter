module PragmaticSegmenter
  module Languages
    class Common
      # This class holds the punctuation marks.
      Punctuations = ['。', '．', '.', '！', '!', '?', '？']

      ABBREVIATIONS = ['adj', 'adm', 'adv', 'al', 'ala', 'alta', 'apr', 'arc', 'ariz', 'ark', 'art', 'assn', 'asst', 'attys', 'aug', 'ave', 'bart', 'bld', 'bldg', 'blvd', 'brig', 'bros', 'btw', 'cal', 'calif', 'capt', 'cl', 'cmdr', 'co', 'col', 'colo', 'comdr', 'con', 'conn', 'corp', 'cpl', 'cres', 'ct', 'd.phil', 'dak', 'dec', 'del', 'dept', 'det', 'dist', 'dr', 'dr.phil', 'dr.philos', 'drs', 'e.g', 'ens', 'esp', 'esq', 'etc', 'exp', 'expy', 'ext', 'feb', 'fed', 'fla', 'ft', 'fwy', 'fy', 'ga', 'gen', 'gov', 'hon', 'hosp', 'hr', 'hway', 'hwy', 'i.e', 'ia', 'id', 'ida', 'ill', 'inc', 'ind', 'ing', 'insp', 'is', 'jan', 'jr', 'jul', 'jun', 'kan', 'kans', 'ken', 'ky', 'la', 'lt', 'ltd', 'maj', 'man', 'mar', 'mass', 'may', 'md', 'me', 'med', 'messrs', 'mex', 'mfg', 'mich', 'min', 'minn', 'miss', 'mlle', 'mm', 'mme', 'mo', 'mont', 'mr', 'mrs', 'ms', 'msgr', 'mssrs', 'mt', 'mtn', 'neb', 'nebr', 'nev', 'no', 'nos', 'nov', 'nr', 'oct', 'ok', 'okla', 'ont', 'op', 'ord', 'ore', 'p', 'pa', 'pd', 'pde', 'penn', 'penna', 'pfc', 'ph', 'ph.d', 'pl', 'plz', 'pp', 'prof', 'pvt', 'que', 'rd', 'ref', 'rep', 'reps', 'res', 'rev', 'rt', 'sask', 'sen', 'sens', 'sep', 'sept', 'sfc', 'sgt', 'sr', 'st', 'supt', 'surg', 'tce', 'tenn', 'tex', 'univ', 'usafa', 'u.s', 'ut', 'va', 'v', 'ver', 'vs', 'vt', 'wash', 'wis', 'wisc', 'wy', 'wyo', 'yuk']
      PREPOSITIVE_ABBREVIATIONS = ['adm', 'attys', 'brig', 'capt', 'cmdr', 'col', 'cpl', 'det', 'dr', 'gen', 'gov', 'ing', 'lt', 'maj', 'mr', 'mrs', 'ms', 'mt', 'messrs', 'mssrs', 'prof', 'ph', 'rep', 'reps', 'rev', 'sen', 'sens', 'sgt', 'st', 'supt', 'v', 'vs']
      NUMBER_ABBREVIATIONS = ['art', 'ext', 'no', 'nos', 'p', 'pp']

      # Defines the abbreviations for each language (if available)
      class Abbreviation
        def all
          ABBREVIATIONS
        end

        def prepositive
          PREPOSITIVE_ABBREVIATIONS
        end

        def number
          NUMBER_ABBREVIATIONS
        end
      end

      # This class searches for periods within an abbreviation and
      # replaces the periods.
      module SingleLetterAbbreviationRules
        # Rubular: http://rubular.com/r/e3H6kwnr6H
        SingleUpperCaseLetterAtStartOfLineRule = Rule.new(/(?<=^[A-Z])\.(?=\s)/, '∯')

        # Rubular: http://rubular.com/r/gitvf0YWH4
        SingleUpperCaseLetterRule = Rule.new(/(?<=\s[A-Z])\.(?=\s)/, '∯')

        All = [
          SingleUpperCaseLetterAtStartOfLineRule,
          SingleUpperCaseLetterRule
        ]
      end

      class SingleLetterAbbreviation
        attr_reader :text
        def initialize(text:)
          @text = text
        end

        def replace
          @formatted_text = text.apply SingleLetterAbbreviationRules::All
        end
      end


      class Process < PragmaticSegmenter::Process
      end
      class Cleaner < PragmaticSegmenter::Cleaner
      end
    end
  end
end
