# -*- encoding : utf-8 -*-

module PragmaticSegmenter
  # Rubular: http://rubular.com/r/G2opjedIm9
  GeoLocationRule = Rule.new(/(?<=[a-zA-z]°)\.(?=\s*\d+)/, '∯')
end
