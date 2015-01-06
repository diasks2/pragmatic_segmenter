# -*- encoding : utf-8 -*-
require 'pragmatic_segmenter/punctuation_replacer'

module PragmaticSegmenter
  # This class searches for exclamation points that
  # are part of words and not ending punctuation and replaces them.
  class ExclamationWords
    WORDS_WITH_EXCLAMATIONS = ['!Xũ', '!Kung', 'ǃʼOǃKung', '!Xuun', '!Kung-Ekoka', 'ǃHu', 'ǃKhung', 'ǃKu', 'ǃung', 'ǃXo', 'ǃXû', 'ǃXung', 'ǃXũ', '!Xun', 'Yahoo!', 'Y!J', 'Yum!']

    attr_reader :text
    def initialize(text:)
      @text = text
    end

    def replace
      sub_part_of_word_exclamation_points(text)
    end

    private

    def sub_part_of_word_exclamation_points(txt)
      WORDS_WITH_EXCLAMATIONS.each do |exclamation|
        PragmaticSegmenter::PunctuationReplacer.new(
          matches_array: txt.scan(/#{Regexp.escape(exclamation)}/),
          text: txt
        ).replace
      end
    end
  end
end
