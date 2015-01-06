# -*- encoding : utf-8 -*-

module PragmaticSegmenter
  # This class searches for periods related to geolocation
  # within a string and replaces the periods.
  class GeoLocation
    # Rubular: http://rubular.com/r/G2opjedIm9
    GeoLocationRule = Rule.new(/(?<=[a-zA-z]°)\.(?=\s*\d+)/, '∯')

    attr_reader :text
    def initialize(text:)
      @text = Text.new(text)
    end

    def replace
      @text.apply(GeoLocationRule)
    end
  end
end
