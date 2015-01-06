# -*- encoding : utf-8 -*-

module PragmaticSegmenter
  # This class replaces punctuation that is typically a sentence boundary
  # but in this case is not a sentence boundary.
  class PunctuationReplacer
    attr_reader :matches_array, :text
    def initialize(text:, matches_array:)
      @text = text
      @matches_array = matches_array
    end

    def replace
      replace_punctuation(matches_array, text)
    end

    private

    def replace_punctuation(array, txt)
      return if !array || array.empty?
      txt.gsub!('(', '\\(')
      txt.gsub!(')', '\\)')
      txt.gsub!(']', '\\]')
      txt.gsub!('[', '\\[')
      txt.gsub!('-', '\\-')
      array.each do |a|
        a.gsub!('(', '\\(')
        a.gsub!(')', '\\)')
        a.gsub!(']', '\\]')
        a.gsub!('[', '\\[')
        a.gsub!('-', '\\-')

        sub = a.gsub('.', '∯')
        txt.gsub!(/#{Regexp.escape(a)}/, "#{sub}")

        sub_1 = sub.gsub('。', 'ᓰ')
        txt.gsub!(/#{Regexp.escape(sub)}/, "#{sub_1}")

        sub_2 = sub_1.gsub('．', 'ᓱ')
        txt.gsub!(/#{Regexp.escape(sub_1)}/, "#{sub_2}")

        sub_3 = sub_2.gsub('！', 'ᓳ')
        txt.gsub!(/#{Regexp.escape(sub_2)}/, "#{sub_3}")

        sub_4 = sub_3.gsub('!', 'ᓴ')
        txt.gsub!(/#{Regexp.escape(sub_3)}/, "#{sub_4}")

        sub_5 = sub_4.gsub('?', 'ᓷ')
        txt.gsub!(/#{Regexp.escape(sub_4)}/, "#{sub_5}")

        sub_6 = sub_5.gsub('？', 'ᓸ')
        txt.gsub!(/#{Regexp.escape(sub_5)}/, "#{sub_6}")
      end
      txt.gsub!('\\(', '(')
      txt.gsub!('\\)', ')')
      txt.gsub!('\\[', '[')
      txt.gsub!('\\]', ']')
      txt.gsub!('\\-', '-')
      txt
    end
  end
end
