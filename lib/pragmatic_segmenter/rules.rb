module PragmaticSegmenter
  module Rules
    # Rubular: http://rubular.com/r/EUbZCNfgei
    AbbreviationsWithMultiplePeriodsAndEmailRule = Rule.new(/(\w)(\.)(\w)/, '\1∮\3')

    # Rubular: http://rubular.com/r/G2opjedIm9
    GeoLocationRule = Rule.new(/(?<=[a-zA-z]°)\.(?=\s*\d+)/, '∯')

    SingleNewLineRule = Rule.new(/\n/, 'ȹ')

    ExtraWhiteSpaceRule = Rule.new(/\s{3,}/, ' ')

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

    module DoublePuctationRules
      FirstRule = Rule.new(/\?!/, '☉')
      SecondRule = Rule.new(/!\?/, '☈')
      ThirdRule = Rule.new(/\?\?/, '☇')
      ForthRule = Rule.new(/!!/, '☄')

      All = [ FirstRule, SecondRule, ThirdRule, ForthRule ]
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
      TemporaryEndingPunctutation = Rule.new('ȸ', '')
      Newline = Rule.new(/ȹ/, "\n")

      All = [ Period, ArabicComma,
              SemiColon, FullWidthPeriod,
              SpecialPeriod, FullWidthExclamation,
              ExclamationPoint, QuestionMark,
              FullWidthQuestionMark, MixedDoubleQE,
              MixedDoubleQQ, MixedDoubleEQ,
              MixedDoubleEE, LeftParens,
              TemporaryEndingPunctutation,
              Newline ]
    end

    module EscapeRegexReservedCharacters
      LeftParen = Rule.new('(', '\\(')
      RightParen = Rule.new(')', '\\)')
      LeftBracket = Rule.new('[', '\\[')
      RightBracket = Rule.new(']', '\\]')
      Dash = Rule.new('-', '\\-')

      All = [ LeftParen, RightParen,
              LeftBracket, RightBracket, Dash ]
    end

    module SubEscapedRegexReservedCharacters
      SubLeftParen = Rule.new('\\(', '(')
      SubRightParen = Rule.new('\\)', ')')
      SubLeftBracket = Rule.new('\\[', '[')
      SubRightBracket = Rule.new('\\]', ']')
      SubDash = Rule.new('\\-', '-')

      All = [ SubLeftParen, SubRightParen,
              SubLeftBracket, SubRightBracket, SubDash ]
    end
  end
end