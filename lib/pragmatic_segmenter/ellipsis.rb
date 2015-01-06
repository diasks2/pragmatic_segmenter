# -*- encoding : utf-8 -*-

module PragmaticSegmenter
  # This class searches for ellipses within a string and
  # replaces the periods.
  class Ellipsis
    # Rubular: http://rubular.com/r/i60hCK81fz
    ELLIPSIS_3_CONSECUTIVE_REGEX = /\.\.\.(?=\s+[A-Z])/

    # Rubular: http://rubular.com/r/Hdqpd90owl
    ELLIPSIS_4_CONSECUTIVE_REGEX = /(?<=\S)\.{3}(?=\.\s[A-Z])/

    # Rubular: http://rubular.com/r/YBG1dIHTRu
    ELLIPSIS_3_SPACE_REGEX = /(\s\.){3}\s/

    # Rubular: http://rubular.com/r/2VvZ8wRbd8
    ELLIPSIS_4_SPACE_REGEX = /(?<=[a-z])(\.\s){3}\.(\z|$|\n)/

    attr_reader :text
    def initialize(text:)
      @text = text
    end

    def replace
      replace_ellipsis(text)
    end

    private

    def replace_ellipsis(txt)
      # http://www.dailywritingtips.com/in-search-of-a-4-dot-ellipsis/
      # http://www.thepunctuationguide.com/ellipses.html
      txt = replace_3_period_ellipsis_with_spaces(txt)
      txt = replace_4_period_ellipsis_with_spaces(txt)
      txt = replace_4_consecutive_period_ellipsis(txt)
      txt = replace_3_consecutive_period_ellipsis(txt)
      replace_other_3_period_ellipsis(txt)
    end

    def replace_3_period_ellipsis_with_spaces(txt)
      txt.gsub(ELLIPSIS_3_SPACE_REGEX, '♟')
    end

    def replace_4_period_ellipsis_with_spaces(txt)
      txt.gsub(ELLIPSIS_4_SPACE_REGEX, '♝')
    end

    def replace_4_consecutive_period_ellipsis(txt)
      txt.gsub(ELLIPSIS_4_CONSECUTIVE_REGEX, 'ƪ')
    end

    def replace_3_consecutive_period_ellipsis(txt)
      txt.gsub(ELLIPSIS_3_CONSECUTIVE_REGEX, '☏.')
    end

    def replace_other_3_period_ellipsis(txt)
      txt.gsub(/\.\.\./, 'ƪ')
    end
  end
end
