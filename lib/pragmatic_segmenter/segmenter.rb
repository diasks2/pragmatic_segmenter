# -*- encoding : utf-8 -*-
require 'pragmatic_segmenter/languages'

module PragmaticSegmenter
  # This class segments a text into an array of sentences.
  class Segmenter
    include Languages
    attr_reader :text, :language, :doc_type

    def initialize(text:, language: nil, doc_type: nil, clean: true)
      return unless text
      @language = language || 'en'
      @doc_type = doc_type

      if clean
        @text = cleaner_class.new(text: text, doc_type: @doc_type).clean
      else
        @text = text
      end
    end

    def segment
      return [] unless @text
      process_class.new(text: @text).process
    end
  end
end
