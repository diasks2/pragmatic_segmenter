# -*- encoding : utf-8 -*-

module PragmaticSegmenter
  # This class searches for periods related to geolocation
  # within a string and replaces the periods.
  class Geolocation
    # Rubular: http://rubular.com/r/G2opjedIm9
    GEO_LOCATION_REGEX = /(?<=[a-zA-z]°)\.(?=\s*\d+)/

    attr_reader :text
    def initialize(text:)
      @text = text
    end

    def replace
      replace_geo_location_periods(text)
    end

    private

    def replace_geo_location_periods(txt)
      txt.gsub(GEO_LOCATION_REGEX, '∯')
    end
  end
end
