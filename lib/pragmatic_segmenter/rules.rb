require 'pragmatic_segmenter/rules/html'

module PragmaticSegmenter
  module Rules

    URL_EMAIL_KEYWORDS = ['@', 'http', '.com', 'net', 'www', '//']

    # Rubular: http://rubular.com/r/6dt98uI76u
    NO_SPACE_BETWEEN_SENTENCES_REGEX = /(?<=[a-z])\.(?=[A-Z])/

    # Rubular: http://rubular.com/r/l6KN6rH5XE
    NO_SPACE_BETWEEN_SENTENCES_DIGIT_REGEX = /(?<=\d)\.(?=[A-Z])/

    # Rubular: http://rubular.com/r/V57WnM9Zut
    NewLineInMiddleOfWordRule = Rule.new(/\n(?=[a-zA-Z]{1,2}\n)/, '')

    # Rubular: http://rubular.com/r/3GiRiP2IbD
    NEWLINE_IN_MIDDLE_OF_SENTENCE_REGEX = /(?<=\s)\n(?=([a-z]|\())/

    # Rubular: http://rubular.com/r/UZAVcwqck8
    PDF_NewLineInMiddleOfSentenceRule = Rule.new(/(?<=[^\n]\s)\n(?=\S)/, '')

    # Rubular: http://rubular.com/r/eaNwGavmdo
    PDF_NewLineInMiddleOfSentenceNoSpacesRule = Rule.new(/\n(?=[a-z])/, ' ')

    # Rubular: http://rubular.com/r/bAJrhyLNeZ
    InlineFormattingRule = Rule.new(/\{b\^&gt;\d*&lt;b\^\}|\{b\^>\d*<b\^\}/, '')

    # Rubular: http://rubular.com/r/dMxp5MixFS
    DoubleNewLineWithSpaceRule = Rule.new(/\n \n/, "\r")

    # Rubular: http://rubular.com/r/H6HOJeA8bq
    DoubleNewLineRule = Rule.new(/\n\n/, "\r")

    # Rubular: http://rubular.com/r/Gn18aAnLdZ
    NewLineFollowedByBulletRule = Rule.new(/\n(?=•)/, "\r")

    # Rubular: http://rubular.com/r/FseyMiiYFT
    NewLineFollowedByPeriodRule = Rule.new(/\n(?=\.(\s|\n))/, '')

    # Rubular: http://rubular.com/r/8mc1ArOIGy
    TableOfContentsRule = Rule.new(/\.{5,}\s*\d+-*\d*/, "\r")

    # Rubular: http://rubular.com/r/DwNSuZrNtk
    ConsecutivePeriodsRule = Rule.new(/\.{5,}/, ' ')

    # Rubular: http://rubular.com/r/IQ4TPfsbd8
    ConsecutiveForwardSlashRule = Rule.new(/\/{3}/, '')

    # Rubular: http://rubular.com/r/6dt98uI76u
    NoSpaceBetweenSentencesRule = Rule.new(NO_SPACE_BETWEEN_SENTENCES_REGEX, '. ')

    # Rubular: http://rubular.com/r/l6KN6rH5XE
    NoSpaceBetweenSentencesDigitRule = Rule.new(NO_SPACE_BETWEEN_SENTENCES_DIGIT_REGEX, '. ')

    EscapedCarriageReturnRule = Rule.new(/\\r/, "\r")
    TypoEscapedCarriageReturnRule = Rule.new(/\\\ r/, "\r")

    EscapedNewLineRule = Rule.new(/\\n/, "\n")
    TypoEscapedNewLineRule = Rule.new(/\\\ n/, "\n")

    ReplaceNewlineWithCarriageReturnRule = Rule.new(/\n/, "\r")

    QuotationsFirstRule = Rule.new(/''/, '"')
    QuotationsSecondRule = Rule.new(/``/, '"')

    # Rubular: http://rubular.com/r/EUbZCNfgei
    AbbreviationsWithMultiplePeriodsAndEmailRule = Rule.new(/(\w)(\.)(\w)/, '\1∮\3')

    # Rubular: http://rubular.com/r/G2opjedIm9
    GeoLocationRule = Rule.new(/(?<=[a-zA-z]°)\.(?=\s*\d+)/, '∯')

    SingleNewLineRule = Rule.new(/\n/, 'ȹ')

    SubSingleQuoteRule = Rule.new(/&⎋&/, "'")

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

    module DoublePunctuationRules
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
