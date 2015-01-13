# -*- encoding : utf-8 -*-

module PragmaticSegmenter
  # This class splits text at sentence boundary punctuation marks
  class SentenceBoundaryPunctuation
    SENTENCE_BOUNDARY_REGEX = /\u{ff08}(?:[^\u{ff09}])*\u{ff09}(?=\s?[A-Z])|\u{300c}(?:[^\u{300d}])*\u{300d}(?=\s[A-Z])|\((?:[^\)]){2,}\)(?=\s[A-Z])|'(?:[^'])*[^,]'(?=\s[A-Z])|"(?:[^"])*[^,]"(?=\s[A-Z])|“(?:[^”])*[^,]”(?=\s[A-Z])|\S.*?[。．.！!?？ȸȹ☉☈☇☄]/

    attr_reader :text
    def initialize(text:)
      @text = text
    end

    def split
      text.scan(SENTENCE_BOUNDARY_REGEX)
    end
  end
end
