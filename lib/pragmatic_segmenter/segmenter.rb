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
require 'pragmatic_segmenter/rules'

module PragmaticSegmenter
  # This class segments a text into an array of sentences.
  class Segmenter
    include Rules
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
        PragmaticSegmenter::Process.new(text: text, doc_type: doc_type).process
      when 'de'
        PragmaticSegmenter::Languages::Deutsch::Process.new(text: text, doc_type: doc_type).process
      when 'es'
        PragmaticSegmenter::Languages::Spanish::Process.new(text: text, doc_type: doc_type).process
      when 'it'
        PragmaticSegmenter::Languages::Italian::Process.new(text: text, doc_type: doc_type).process
      when 'ja'
        PragmaticSegmenter::Languages::Japanese::Process.new(text: text, doc_type: doc_type).process
      when 'el'
        PragmaticSegmenter::Languages::Greek::Process.new(text: text, doc_type: doc_type).process
      when 'ru'
        PragmaticSegmenter::Languages::Russian::Process.new(text: text, doc_type: doc_type).process
      when 'ar'
        PragmaticSegmenter::Languages::Arabic::Process.new(text: text, doc_type: doc_type).process
      when 'am'
        PragmaticSegmenter::Languages::Amharic::Process.new(text: text, doc_type: doc_type).process
      when 'hi'
        PragmaticSegmenter::Languages::Hindi::Process.new(text: text, doc_type: doc_type).process
      when 'hy'
        PragmaticSegmenter::Languages::Armenian::Process.new(text: text, doc_type: doc_type).process
      when 'fa'
        PragmaticSegmenter::Languages::Persian::Process.new(text: text, doc_type: doc_type).process
      when 'my'
        PragmaticSegmenter::Languages::Burmese::Process.new(text: text, doc_type: doc_type).process
      when 'ur'
        PragmaticSegmenter::Languages::Urdu::Process.new(text: text, doc_type: doc_type).process
      else
        PragmaticSegmenter::Process.new(text: text, doc_type: doc_type).process
      end
    end
  end
end
