module PragmaticSegmenter
  module Languages
    module Common
      # This class holds the punctuation marks.
      Punctuations = ['。', '．', '.', '！', '!', '?', '？']

      ABBREVIATIONS = ['adj', 'adm', 'adv', 'al', 'ala', 'alta', 'apr', 'arc', 'ariz', 'ark', 'art', 'assn', 'asst', 'attys', 'aug', 'ave', 'bart', 'bld', 'bldg', 'blvd', 'brig', 'bros', 'btw', 'cal', 'calif', 'capt', 'cl', 'cmdr', 'co', 'col', 'colo', 'comdr', 'con', 'conn', 'corp', 'cpl', 'cres', 'ct', 'd.phil', 'dak', 'dec', 'del', 'dept', 'det', 'dist', 'dr', 'dr.phil', 'dr.philos', 'drs', 'e.g', 'ens', 'esp', 'esq', 'etc', 'exp', 'expy', 'ext', 'feb', 'fed', 'fla', 'ft', 'fwy', 'fy', 'ga', 'gen', 'gov', 'hon', 'hosp', 'hr', 'hway', 'hwy', 'i.e', 'ia', 'id', 'ida', 'ill', 'inc', 'ind', 'ing', 'insp', 'is', 'jan', 'jr', 'jul', 'jun', 'kan', 'kans', 'ken', 'ky', 'la', 'lt', 'ltd', 'maj', 'man', 'mar', 'mass', 'may', 'md', 'me', 'med', 'messrs', 'mex', 'mfg', 'mich', 'min', 'minn', 'miss', 'mlle', 'mm', 'mme', 'mo', 'mont', 'mr', 'mrs', 'ms', 'msgr', 'mssrs', 'mt', 'mtn', 'neb', 'nebr', 'nev', 'no', 'nos', 'nov', 'nr', 'oct', 'ok', 'okla', 'ont', 'op', 'ord', 'ore', 'p', 'pa', 'pd', 'pde', 'penn', 'penna', 'pfc', 'ph', 'ph.d', 'pl', 'plz', 'pp', 'prof', 'pvt', 'que', 'rd', 'ref', 'rep', 'reps', 'res', 'rev', 'rt', 'sask', 'sen', 'sens', 'sep', 'sept', 'sfc', 'sgt', 'sr', 'st', 'supt', 'surg', 'tce', 'tenn', 'tex', 'univ', 'usafa', 'u.s', 'ut', 'va', 'v', 'ver', 'vs', 'vt', 'wash', 'wis', 'wisc', 'wy', 'wyo', 'yuk']
      PREPOSITIVE_ABBREVIATIONS = ['adm', 'attys', 'brig', 'capt', 'cmdr', 'col', 'cpl', 'det', 'dr', 'gen', 'gov', 'ing', 'lt', 'maj', 'mr', 'mrs', 'ms', 'mt', 'messrs', 'mssrs', 'prof', 'ph', 'rep', 'reps', 'rev', 'sen', 'sens', 'sgt', 'st', 'supt', 'v', 'vs']
      NUMBER_ABBREVIATIONS = ['art', 'ext', 'no', 'nos', 'p', 'pp']

      SENTENCE_BOUNDARY_REGEX = /\u{ff08}(?:[^\u{ff09}])*\u{ff09}(?=\s?[A-Z])|\u{300c}(?:[^\u{300d}])*\u{300d}(?=\s[A-Z])|\((?:[^\)]){2,}\)(?=\s[A-Z])|'(?:[^'])*[^,]'(?=\s[A-Z])|"(?:[^"])*[^,]"(?=\s[A-Z])|“(?:[^”])*[^,]”(?=\s[A-Z])|\S.*?[。．.！!?？ȸȹ☉☈☇☄]/

      include Rules
      # Rubular: http://rubular.com/r/NqCqv372Ix
      QUOTATION_AT_END_OF_SENTENCE_REGEX = /[!?\.-][\"\'\u{201d}\u{201c}]\s{1}[A-Z]/

      # Rubular: http://rubular.com/r/6flGnUMEVl
      PARENS_BETWEEN_DOUBLE_QUOTES_REGEX = /["”]\s\(.*\)\s["“]/

      # Rubular: http://rubular.com/r/TYzr4qOW1Q
      BETWEEN_DOUBLE_QUOTES_REGEX = /"(?:[^"])*[^,]"|“(?:[^”])*[^,]”/

      # Rubular: http://rubular.com/r/JMjlZHAT4g
      SPLIT_SPACE_QUOTATION_AT_END_OF_SENTENCE_REGEX = /(?<=[!?\.-][\"\'\u{201d}\u{201c}])\s{1}(?=[A-Z])/

      # Rubular: http://rubular.com/r/mQ8Es9bxtk
      CONTINUOUS_PUNCTUATION_REGEX = /(?<=\S)(!|\?){3,}(?=(\s|\z|$))/

      # Rubular: http://rubular.com/r/yqa4Rit8EY
      PossessiveAbbreviationRule = Rule.new(/\.(?='s\s)|\.(?='s$)|\.(?='s\z)/, '∯')

      # Rubular: http://rubular.com/r/NEv265G2X2
      KommanditgesellschaftRule = Rule.new(/(?<=Co)\.(?=\sKG)/, '∯')

      # Rubular: http://rubular.com/r/xDkpFZ0EgH
      MULTI_PERIOD_ABBREVIATION_REGEX = /\b[a-z](?:\.[a-z])+[.]/i

      module AmPmRules
        # Rubular: http://rubular.com/r/Vnx3m4Spc8
        UpperCasePmRule = Rule.new(/(?<=P∯M)∯(?=\s[A-Z])/, '.')

        # Rubular: http://rubular.com/r/AJMCotJVbW
        UpperCaseAmRule = Rule.new(/(?<=A∯M)∯(?=\s[A-Z])/, '.')

        # Rubular: http://rubular.com/r/13q7SnOhgA
        LowerCasePmRule = Rule.new(/(?<=p∯m)∯(?=\s[A-Z])/, '.')

        # Rubular: http://rubular.com/r/DgUDq4mLz5
        LowerCaseAmRule = Rule.new(/(?<=a∯m)∯(?=\s[A-Z])/, '.')

        All = [UpperCasePmRule, UpperCaseAmRule, LowerCasePmRule, LowerCaseAmRule]
      end

      # Defines the abbreviations for each language (if available)
      module Abbreviation
        def self.all
          ABBREVIATIONS
        end

        def self.prepositive
          PREPOSITIVE_ABBREVIATIONS
        end

        def self.number
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


      class Process < PragmaticSegmenter::Process
      end
      class Cleaner < PragmaticSegmenter::Cleaner
      end
    end
  end
end
