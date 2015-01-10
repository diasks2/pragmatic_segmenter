# -*- encoding : utf-8 -*-

module PragmaticSegmenter
  # This class replaces punctuation that is typically a sentence boundary
  # but in this case is not a sentence boundary.
  class PunctuationReplacer
    include Rules
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
      txt.apply(EscapeRegexReservedCharacters::All)
      array.each do |a|
        a.apply(EscapeRegexReservedCharacters::All)
        sub = sub_characters(txt, a, '.', '∯')
        sub_1 = sub_characters(txt, sub, '。', '&ᓰ&')
        sub_2 = sub_characters(txt, sub_1, '．', '&ᓱ&')
        sub_3 = sub_characters(txt, sub_2, '！', '&ᓳ&')
        sub_4 = sub_characters(txt, sub_3, '!', '&ᓴ&')
        sub_5 = sub_characters(txt, sub_4, '?', '&ᓷ&')
        sub_6 = sub_characters(txt, sub_5, '？', '&ᓸ&')
      end
      txt.apply(SubEscapedRegexReservedCharacters::All)
    end

    def sub_characters(txt, string, char_a, char_b)
      sub = string.gsub(char_a, char_b)
      txt.gsub!(/#{Regexp.escape(string)}/, "#{sub}")
      sub
    end
  end
end
