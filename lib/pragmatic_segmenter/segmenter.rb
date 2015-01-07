# -*- encoding : utf-8 -*-
require 'pragmatic_segmenter/process'
require 'pragmatic_segmenter/cleaner'
require 'pragmatic_segmenter/list'
require 'pragmatic_segmenter/abbreviation_replacer'
require 'pragmatic_segmenter/number'
require 'pragmatic_segmenter/ellipsis'
require 'pragmatic_segmenter/geo_location'
require 'pragmatic_segmenter/email'
require 'pragmatic_segmenter/exclamation_words'
require 'pragmatic_segmenter/punctuation_replacer'
require 'pragmatic_segmenter/between_punctuation'
require 'pragmatic_segmenter/sentence_boundary_punctuation'
require 'pragmatic_segmenter/punctuation'
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

module PragmaticSegmenter
  # This class segments a text into an array of sentences.
  class Segmenter

    attr_reader :text, :language, :doc_type
    def initialize(text:, **args)
      return [] unless text
      @language = args[:language] || 'en'
      @doc_type = args[:doc_type]
      if args[:clean].eql?(false)
        @text = text.dup
      else
        case @language
        when 'en'
          @text = PragmaticSegmenter::Languages::English::Cleaner.new(text: text.dup, doc_type: args[:doc_type]).clean
        when 'ja'
          @text = PragmaticSegmenter::Languages::Japanese::Cleaner.new(text: text.dup, doc_type: args[:doc_type]).clean
        else
          @text = PragmaticSegmenter::Cleaner.new(text: text.dup, doc_type: args[:doc_type]).clean
        end
      end
    end

    def segment
      return [] unless text
      case language
      when 'en'
        PragmaticSegmenter::Process.new(text: text, language: language, doc_type: doc_type).process
      when 'de'
        PragmaticSegmenter::Languages::Deutsch::Process.new(text: text, language: language, doc_type: doc_type).process
      when 'es'
        PragmaticSegmenter::Languages::Spanish::Process.new(text: text, language: language, doc_type: doc_type).process
      when 'it'
        PragmaticSegmenter::Languages::Italian::Process.new(text: text, language: language, doc_type: doc_type).process
      when 'ar'
        PragmaticSegmenter::Languages::Arabic::Process.new(text: text, language: language, doc_type: doc_type).process
      when 'ru'
        PragmaticSegmenter::Languages::Russian::Process.new(text: text, language: language, doc_type: doc_type).process
      when 'am'
        PragmaticSegmenter::Languages::Amharic::Process.new(text: text, language: language, doc_type: doc_type).process
      when 'hi'
        PragmaticSegmenter::Languages::Hindi::Process.new(text: text, language: language, doc_type: doc_type).process
      when 'hy'
        PragmaticSegmenter::Languages::Armenian::Process.new(text: text, language: language, doc_type: doc_type).process
      when 'my'
        PragmaticSegmenter::Languages::Burmese::Process.new(text: text, language: language, doc_type: doc_type).process
      when 'ur'
        PragmaticSegmenter::Languages::Urdu::Process.new(text: text, language: language, doc_type: doc_type).process
      else
        PragmaticSegmenter::Process.new(text: text, language: language, doc_type: doc_type).process
      end
    end
  end
end
