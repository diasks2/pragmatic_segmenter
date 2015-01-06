module PragmaticSegmenter
  module Languages
    class Deutsch
      class Number < PragmaticSegmenter::Number
        # Rubular: http://rubular.com/r/hZxoyQwKT1
        NumberPeriodSpaceRule = Rule.new(/(?<=\s[0-9]|\s([1-9][0-9]))\.(?=\s)/, '∯')

        # Rubular: http://rubular.com/r/ityNMwdghj
        NegativeNumberPeriodSpaceRule = Rule.new(/(?<=-[0-9]|-([1-9][0-9]))\.(?=\s)/, '∯')

        def replace
          super
          @formatted_text.apply(NumberPeriodSpaceRule).
                          apply(NegativeNumberPeriodSpaceRule)
        end
      end
    end
  end
end
