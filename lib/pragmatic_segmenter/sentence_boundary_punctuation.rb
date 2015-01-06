# -*- encoding : utf-8 -*-

module PragmaticSegmenter
  # This class splits text at sentence boundary punctuation marks
  class SentenceBoundaryPunctuation
    SENTENCE_BOUNDARY_AM = /.*?[፧።!\?]|.*?$/
    SENTENCE_BOUNDARY_AR = /.*?[:\.!\?؟،]|.*?\z|.*?$/
    SENTENCE_BOUNDARY_EL = /.*?[\.;!\?]|.*?$/
    SENTENCE_BOUNDARY_FA = /.*?[:\.!\?؟]|.*?\z|.*?$/
    SENTENCE_BOUNDARY_HI = /.*?[।\|!\?]|.*?$/
    SENTENCE_BOUNDARY_HY = /.*?[։՜:]|.*?$/
    SENTENCE_BOUNDARY_MY = /.*?[။၏!\?]|.*?$/
    SENTENCE_BOUNDARY_UR = /.*?[۔؟!\?]|.*?$/
    SENTENCE_BOUNDARY_REGEX = /\u{ff08}(?:[^\u{ff09}])*\u{ff09}(?=\s?[A-Z])|\u{300c}(?:[^\u{300d}])*\u{300d}(?=\s[A-Z])|\((?:[^\)])*\)(?=\s[A-Z])|'(?:[^'])*'(?=\s[A-Z])|"(?:[^"])*"(?=\s[A-Z])|“(?:[^”])*”(?=\s[A-Z])|\S.*?[。．.！!?？ȸȹ☉☈☇☄]/

    attr_reader :text, :language
    def initialize(text:, **args)
      @text = text
      @language = args[:language]
    end

    def split
      if language
        if self.respond_to?("#{language}_split_at_sentence_boundary")
          self.send("#{language}_split_at_sentence_boundary", text)
        else
          text.scan(SENTENCE_BOUNDARY_REGEX)
        end
      else
        text.scan(SENTENCE_BOUNDARY_REGEX)
      end
    end

    def replace_non_sentence_boundary_punctuation_fa(txt)
      # FIXME: Make named rules for these
      txt.gsub(/(?<=\d):(?=\d)/, '♭').
          gsub(/،(?=\s\S+،)/, '♬')
    end

    def replace_non_sentence_boundary_punctuation_ar(txt)
      # FIXME: Make named rules for these
      txt.gsub(/(?<=\d):(?=\d)/, '♭').
          gsub(/،(?=\s\S+،)/, '♬')
    end

    def ar_split_at_sentence_boundary(txt)
      txt = replace_non_sentence_boundary_punctuation_ar(txt)
      txt.scan(SENTENCE_BOUNDARY_AR)
    end

    def fa_split_at_sentence_boundary(txt)
      txt = replace_non_sentence_boundary_punctuation_fa(txt)
      txt.scan(SENTENCE_BOUNDARY_FA)
    end

    def hi_split_at_sentence_boundary(txt)
      txt.scan(SENTENCE_BOUNDARY_HI)
    end

    def hy_split_at_sentence_boundary(txt)
      txt.scan(SENTENCE_BOUNDARY_HY)
    end

    def el_split_at_sentence_boundary(txt)
      txt.scan(SENTENCE_BOUNDARY_EL)
    end

    def my_split_at_sentence_boundary(txt)
      txt.scan(SENTENCE_BOUNDARY_MY)
    end

    def am_split_at_sentence_boundary(txt)
      txt.scan(SENTENCE_BOUNDARY_AM)
    end

    def ur_split_at_sentence_boundary(txt)
      txt.scan(SENTENCE_BOUNDARY_UR)
    end
  end
end
