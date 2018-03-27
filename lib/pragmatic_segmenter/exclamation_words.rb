# -*- encoding : utf-8 -*-
# frozen_string_literal: true

require 'pragmatic_segmenter/punctuation_replacer'

module PragmaticSegmenter
  # This class searches for exclamation points that
  # are part of words and not ending punctuation and replaces them.
  module ExclamationWords
    WORDS_WITH_EXCLAMATIONS = ['!Xũ', '!Kung', 'ǃʼOǃKung', '!Xuun', '!Kung-Ekoka', 'ǃHu', 'ǃKhung', 'ǃKu', 'ǃung', 'ǃXo', 'ǃXû', 'ǃXung', 'ǃXũ', '!Xun', 'Yahoo!', 'Y!J', 'Yum!']

    def self.apply_rules(text)
      WORDS_WITH_EXCLAMATIONS.each do |exclamation|
        PragmaticSegmenter::PunctuationReplacer.new(
          matches_array: text.scan(/#{Regexp.escape(exclamation)}/),
          text: text
        ).replace
      end
    end
  end
end
