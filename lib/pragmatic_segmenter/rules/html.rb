module PragmaticSegmenter
  module Rules
    module HTMLRules
      # Rubular: http://rubular.com/r/ENrVFMdJ8v
      HTMLTagRule = Rule.new(/<\/?[^>]*>/, '')

      # Rubular: http://rubular.com/r/XZVqMPJhea
      EscapedHTMLTagRule = Rule.new(/&lt;\/?[^gt;]*gt;/, '')

      All = [HTMLTagRule, EscapedHTMLTagRule]
    end
  end
end
