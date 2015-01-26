# -*- encoding : utf-8 -*-
require 'pragmatic_segmenter/types'
require 'pragmatic_segmenter/process'
require 'pragmatic_segmenter/cleaner'
require 'pragmatic_segmenter/languages/english'
require 'pragmatic_segmenter/languages/deutsch'
require 'pragmatic_segmenter/languages/hindi'
require 'pragmatic_segmenter/languages/persian'
require 'pragmatic_segmenter/languages/amharic'
require 'pragmatic_segmenter/languages/arabic'
require 'pragmatic_segmenter/languages/greek'
require 'pragmatic_segmenter/languages/armenian'
require 'pragmatic_segmenter/languages/burmese'
require 'pragmatic_segmenter/languages/urdu'
require 'pragmatic_segmenter/languages/french'
require 'pragmatic_segmenter/languages/italian'
require 'pragmatic_segmenter/languages/spanish'
require 'pragmatic_segmenter/languages/russian'
require 'pragmatic_segmenter/languages/japanese'
require 'pragmatic_segmenter/languages/dutch'
require 'pragmatic_segmenter/languages/polish'
require 'pragmatic_segmenter/languages/common'
require 'pragmatic_segmenter/language_support'
require 'pragmatic_segmenter/rules'

module PragmaticSegmenter
  # This class segments a text into an array of sentences.
  class Segmenter
    include LanguageSupport
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
