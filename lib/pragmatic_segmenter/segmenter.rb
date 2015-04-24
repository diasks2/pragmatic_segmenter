# -*- encoding : utf-8 -*-
require 'pragmatic_segmenter/languages'

module PragmaticSegmenter
  # This class segments a text into an array of sentences.
  class Segmenter
    attr_reader :text, :language, :doc_type

    def initialize(text:, language: 'en', doc_type: nil, clean: true)
      return unless text
      @language = language
      @language_module = Languages.get_language_by_code(language)
      @doc_type = doc_type

      if clean
        @text = cleaner.new(text: text, doc_type: @doc_type, language: @language_module).clean
      else
        @text = text
      end
    end

    def segment
      return [] unless @text
      process.new(language: @language_module).process(text: @text)
    end

    private

    def process
      @language_module::Process
    rescue
      Process
    end

    def cleaner
      @language_module::Cleaner
    rescue
      Cleaner
    end
  end
end
