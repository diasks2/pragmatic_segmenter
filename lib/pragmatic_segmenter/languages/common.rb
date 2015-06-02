require_relative 'common/numbers'
require_relative 'common/ellipsis'

module PragmaticSegmenter
  module Languages
    module Common
      # This class holds the punctuation marks.
      Punctuations = ['。', '．', '.', '！', '!', '?', '？']

      # Defines the abbreviations for each language (if available)
      module Abbreviation
        ABBREVIATIONS = ['adj', 'adm', 'adv', 'al', 'ala', 'alta', 'apr', 'arc', 'ariz', 'ark', 'art', 'assn', 'asst', 'attys', 'aug', 'ave', 'bart', 'bld', 'bldg', 'blvd', 'brig', 'bros', 'btw', 'cal', 'calif', 'capt', 'cl', 'cmdr', 'co', 'col', 'colo', 'comdr', 'con', 'conn', 'corp', 'cpl', 'cres', 'ct', 'd.phil', 'dak', 'dec', 'del', 'dept', 'det', 'dist', 'dr', 'dr.phil', 'dr.philos', 'drs', 'e.g', 'ens', 'esp', 'esq', 'etc', 'exp', 'expy', 'ext', 'feb', 'fed', 'fla', 'ft', 'fwy', 'fy', 'ga', 'gen', 'gov', 'hon', 'hosp', 'hr', 'hway', 'hwy', 'i.e', 'ia', 'id', 'ida', 'ill', 'inc', 'ind', 'ing', 'insp', 'is', 'jan', 'jr', 'jul', 'jun', 'kan', 'kans', 'ken', 'ky', 'la', 'lt', 'ltd', 'maj', 'man', 'mar', 'mass', 'may', 'md', 'me', 'med', 'messrs', 'mex', 'mfg', 'mich', 'min', 'minn', 'miss', 'mlle', 'mm', 'mme', 'mo', 'mont', 'mr', 'mrs', 'ms', 'msgr', 'mssrs', 'mt', 'mtn', 'neb', 'nebr', 'nev', 'no', 'nos', 'nov', 'nr', 'oct', 'ok', 'okla', 'ont', 'op', 'ord', 'ore', 'p', 'pa', 'pd', 'pde', 'penn', 'penna', 'pfc', 'ph', 'ph.d', 'pl', 'plz', 'pp', 'prof', 'pvt', 'que', 'rd', 'ref', 'rep', 'reps', 'res', 'rev', 'rt', 'sask', 'sec', 'sen', 'sens', 'sep', 'sept', 'sfc', 'sgt', 'sr', 'st', 'supt', 'surg', 'tce', 'tenn', 'tex', 'univ', 'usafa', 'u.s', 'ut', 'va', 'v', 'ver', 'vs', 'vt', 'wash', 'wis', 'wisc', 'wy', 'wyo', 'yuk']
        PREPOSITIVE_ABBREVIATIONS = ['adm', 'attys', 'brig', 'capt', 'cmdr', 'col', 'cpl', 'det', 'dr', 'gen', 'gov', 'ing', 'lt', 'maj', 'mr', 'mrs', 'ms', 'mt', 'messrs', 'mssrs', 'prof', 'ph', 'rep', 'reps', 'rev', 'sen', 'sens', 'sgt', 'st', 'supt', 'v', 'vs']
        NUMBER_ABBREVIATIONS = ['art', 'ext', 'no', 'nos', 'p', 'pp']
      end

      module Abbreviations
        # Rubular: http://rubular.com/r/EUbZCNfgei
        WithMultiplePeriodsAndEmailRule = Rule.new(/(\w)(\.)(\w)/, '\1∮\3')
      end

      # Rubular: http://rubular.com/r/G2opjedIm9
      GeoLocationRule = Rule.new(/(?<=[a-zA-z]°)\.(?=\s*\d+)/, '∯')

      SingleNewLineRule = Rule.new(/\n/, 'ȹ')

      module DoublePunctuationRules
        FirstRule = Rule.new(/\?!/, '☉')
        SecondRule = Rule.new(/!\?/, '☈')
        ThirdRule = Rule.new(/\?\?/, '☇')
        ForthRule = Rule.new(/!!/, '☄')

        All = [ FirstRule, SecondRule, ThirdRule, ForthRule ]
      end


      # Rubular: http://rubular.com/r/aXPUGm6fQh
      QuestionMarkInQuotationRule = Rule.new(/\?(?=(\'|\"))/, '&ᓷ&')


      module ExclamationPointRules
        # Rubular: http://rubular.com/r/XS1XXFRfM2
        InQuotationRule = Rule.new(/\!(?=(\'|\"))/, '&ᓴ&')

        # Rubular: http://rubular.com/r/sl57YI8LkA
        BeforeCommaMidSentenceRule = Rule.new(/\!(?=\,\s[a-z])/, '&ᓴ&')

        # Rubular: http://rubular.com/r/f9zTjmkIPb
        MidSentenceRule = Rule.new(/\!(?=\s[a-z])/, '&ᓴ&')

        All = [ InQuotationRule, BeforeCommaMidSentenceRule, MidSentenceRule ]
      end

      module SubSymbolsRules
        Period = Rule.new(/∯/, '.')
        ArabicComma = Rule.new(/♬/, '،')
        SemiColon = Rule.new(/♭/, ':')
        FullWidthPeriod = Rule.new(/&ᓰ&/, '。')
        SpecialPeriod = Rule.new(/&ᓱ&/, '．')
        FullWidthExclamation = Rule.new(/&ᓳ&/, '！')
        ExclamationPoint = Rule.new(/&ᓴ&/, '!')
        QuestionMark = Rule.new(/&ᓷ&/, '?')
        FullWidthQuestionMark = Rule.new(/&ᓸ&/, '？')
        MixedDoubleQE = Rule.new(/☉/, '?!')
        MixedDoubleQQ = Rule.new(/☇/, '??')
        MixedDoubleEQ = Rule.new(/☈/, '!?')
        MixedDoubleEE = Rule.new(/☄/, '!!')
        LeftParens = Rule.new(/&✂&/, '(')
        RightParens = Rule.new(/&⌬&/, ')')
        TemporaryEndingPunctutation = Rule.new('ȸ', '')
        Newline = Rule.new(/ȹ/, "\n")

        All = [ Period, ArabicComma,
                SemiColon, FullWidthPeriod,
                SpecialPeriod, FullWidthExclamation,
                ExclamationPoint, QuestionMark,
                FullWidthQuestionMark, MixedDoubleQE,
                MixedDoubleQQ, MixedDoubleEQ,
                MixedDoubleEE, LeftParens,
                RightParens, TemporaryEndingPunctutation,
                Newline ]
      end


      module ReinsertEllipsisRules
        SubThreeConsecutivePeriod = Rule.new(/ƪ/, '...')
        SubThreeSpacePeriod = Rule.new(/♟/, ' . . . ')
        SubFourSpacePeriod = Rule.new(/♝/, '. . . .')
        SubTwoConsecutivePeriod = Rule.new(/☏/, '..')
        SubOnePeriod = Rule.new(/∮/, '.')

        All = [ SubThreeConsecutivePeriod, SubThreeSpacePeriod,
                SubFourSpacePeriod, SubTwoConsecutivePeriod,
                SubOnePeriod ]
      end

      ExtraWhiteSpaceRule = Rule.new(/\s{3,}/, ' ')

      SubSingleQuoteRule = Rule.new(/&⎋&/, "'")
    end
  end
end
