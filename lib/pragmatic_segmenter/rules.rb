module PragmaticSegmenter
  module Rules
    # Rubular: http://rubular.com/r/EUbZCNfgei
    EmailRule = Rule.new(/(\w)(\.)(\w)/, '\1∮\3')

    SingleNewLineRule = Rule.new(/\n/, 'ȹ')

    ExtraWhiteSpaceRule = Rule.new(/\s{3,}/, ' ')

    # Rubular: http://rubular.com/r/aXPUGm6fQh
    QuestionMarkInQuotationRule = Rule.new(/\?(?=(\'|\"))/, 'ᓷ')

    module ExclamationPointRules
      # Rubular: http://rubular.com/r/XS1XXFRfM2
      InQuotationRule = Rule.new(/\!(?=(\'|\"))/, 'ᓴ')

      # Rubular: http://rubular.com/r/sl57YI8LkA
      BeforeCommaMidSentenceRule = Rule.new(/\!(?=\,\s[a-z])/, 'ᓴ')

      # Rubular: http://rubular.com/r/f9zTjmkIPb
      MidSentenceRule = Rule.new(/\!(?=\s[a-z])/, 'ᓴ')

      All = [ InQuotationRule, BeforeCommaMidSentenceRule, MidSentenceRule ]
    end

    module DoublePuctationRules
      FirstRule = Rule.new(/\?!/, '☉')
      SecondRule = Rule.new(/!\?/, '☈')
      ThirdRule = Rule.new(/\?\?/, '☇')
      ForthRule = Rule.new(/!!/, '☄')

      All = [ FirstRule, SecondRule, ThirdRule, ForthRule ]
    end
  end
end
