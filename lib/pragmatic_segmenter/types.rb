module PragmaticSegmenter
  Rule = Struct.new(:pattern, :replacement)

  class Text < String
    def apply(rule)
      gsub(rule.pattern, rule.replacement)
    end
  end
end
