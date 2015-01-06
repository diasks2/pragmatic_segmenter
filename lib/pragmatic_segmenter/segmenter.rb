# -*- encoding : utf-8 -*-
require 'pragmatic_segmenter/types'
require 'pragmatic_segmenter/languages'

module PragmaticSegmenter
  # This class segments a text into an array of sentences.
  class Segmenter
    include PragmaticSegmenter::Languages::Common
    # def initialize(text:, **args)
    #   return [] unless text
    #   if args[:clean].nil? || args[:clean].eql?(true)
    #     @text = PragmaticSegmenter::Cleaner.new(text: text.dup, language: args[:language], doc_type: args[:doc_type]).clean
    #   else
    #     @text = text.dup
    #   end

    #   case
    #   when args[:language] = 'en'
    #     adapter = Languages::English
    #   else
    #     adapter = Languages::English
    #   end
    #   @doc_type = args[:doc_type]
    # end
  end
end
