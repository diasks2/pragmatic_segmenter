# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pragmatic_segmenter/version'

Gem::Specification.new do |spec|
  spec.name          = "pragmatic_segmenter"
  spec.version       = PragmaticSegmenter::VERSION
  spec.authors       = ["Kevin S. Dias"]
  spec.email         = ["diasks2@gmail.com"]
  spec.summary       = %q{A rule-based sentence boundary detection gem that works out-of-the-box across many languages}
  spec.description   = %q{Pragmatic Segmenter is a sentence segmentation tool for Ruby. It allows you to split a text into an array of sentences. This gem provides 2 main benefits over other segmentation gems - 1) It works well even with ill-formatted text 2) It works for multiple languages }
  spec.homepage      = "https://github.com/diasks2/pragmatic_segmenter"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", ">= 1.7"
  spec.add_development_dependency "rake", ">= 12.3.3"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "stackprof"
end
