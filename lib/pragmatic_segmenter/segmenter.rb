# -*- encoding : utf-8 -*-
require 'pragmatic_segmenter/types'
require 'pragmatic_segmenter/process'
require 'pragmatic_segmenter/cleaner'
require 'pragmatic_segmenter/languages'
require 'pragmatic_segmenter/rules'

module PragmaticSegmenter
  # This class segments a text into an array of sentences.
  class Segmenter
    include Languages
    attr_reader :text, :language, :doc_type

    def initialize(text:, **args)
      return unless text
      @language = args[:language] || 'en'
      @doc_type = args[:doc_type]
      @text = text.dup
      unless args[:clean].eql?(false)
        @text = cleaner_class.new(text: @text, doc_type: args[:doc_type]).clean
      end
    end

    def segment
      return [] unless text
      process_class.new(text: text, doc_type: doc_type).process
    end
  end
end
