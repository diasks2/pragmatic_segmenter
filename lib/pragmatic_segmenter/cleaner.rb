# -*- encoding : utf-8 -*-

module PragmaticSegmenter
  # This is an opinionated class that removes errant newlines,
  # xhtml, inline formatting, etc.
  class Cleaner
    include Rules

    attr_reader :text, :doc_type
    def initialize(text:, doc_type: nil, language:)
      @text = Text.new(text)
      @doc_type = doc_type
      @language = language
    end

    # Clean text of unwanted formatting
    #
    # Example:
    #   >> text = "This is a sentence\ncut off in the middle because pdf."
    #   >> PragmaticSegmenter::Cleaner(text: text).clean
    #   => "This is a sentence cut off in the middle because pdf."
    #
    # Arguments:
    #    text:       (String)  *required
    #    language:   (String)  *optional
    #                (two character ISO 639-1 code e.g. 'en')
    #    doc_type:   (String)  *optional
    #                (e.g. 'pdf')

    def clean
      return unless text
      @text = remove_all_newlines(@text)
      replace_double_newlines(@text)
      replace_newlines(@text)
      replace_escaped_newlines(@text)
      @text.apply(HTMLRules::All)
      replace_punctuation_in_brackets(@text)
      @text.apply(InlineFormattingRule)
      clean_quotations(@text)
      clean_table_of_contents(@text)
      check_for_no_space_in_between_sentences(@text)
      clean_consecutive_characters(@text)
    end

    private

    def abbreviations
      @language::Abbreviation::ABBREVIATIONS
    end

    def check_for_no_space_in_between_sentences(txt)
      words = txt.split(' ')
      words.each do |word|
        search_for_connected_sentences(word, txt, NO_SPACE_BETWEEN_SENTENCES_REGEX, NoSpaceBetweenSentencesRule)
        search_for_connected_sentences(word, txt, NO_SPACE_BETWEEN_SENTENCES_DIGIT_REGEX, NoSpaceBetweenSentencesDigitRule)
      end
      txt
    end

    def replace_punctuation_in_brackets(txt)
      txt.dup.gsub!(/\[(?:[^\]])*\]/) do |match|
        txt.gsub!(/#{Regexp.escape(match)}/, "#{match.dup.gsub!(/\?/, '&ᓷ&')}") if match.include?('?')
      end
    end

    def search_for_connected_sentences(word, txt, regex, rule)
      if word =~ regex
        unless URL_EMAIL_KEYWORDS.any? { |web| word =~ /#{web}/ }
          unless abbreviations.any? { |abbr| word =~ /#{abbr}/i }
            new_word = word.dup.apply(rule)
            txt.gsub!(/#{Regexp.escape(word)}/, new_word)
          end
        end
      end
    end

    def remove_all_newlines(txt)
      clean_text = remove_newline_in_middle_of_sentence(txt)
      remove_newline_in_middle_of_word(clean_text)
    end

    def remove_newline_in_middle_of_sentence(txt)
      txt.dup.gsub!(/(?:[^\.])*/) do |match|
        next unless match.include?("\n")
        orig = match.dup
        match.gsub!(NEWLINE_IN_MIDDLE_OF_SENTENCE_REGEX, '')
        txt.gsub!(/#{Regexp.escape(orig)}/, "#{match}")
      end
      txt
    end

    def remove_newline_in_middle_of_word(txt)
      txt.apply NewLineInMiddleOfWordRule
    end

    def replace_escaped_newlines(txt)
      txt.apply EscapedNewLineRule, EscapedCarriageReturnRule,
        TypoEscapedNewLineRule, TypoEscapedCarriageReturnRule
    end

    def replace_double_newlines(txt)
      txt.apply DoubleNewLineWithSpaceRule, DoubleNewLineRule
    end

    def replace_newlines(txt)
      if doc_type.eql?('pdf')
        remove_pdf_line_breaks(txt)
      else
        txt.apply NewLineFollowedByPeriodRule,
          ReplaceNewlineWithCarriageReturnRule
      end
    end

    def remove_pdf_line_breaks(txt)
      txt.apply NewLineFollowedByBulletRule,
        PDF_NewLineInMiddleOfSentenceRule,
        PDF_NewLineInMiddleOfSentenceNoSpacesRule
    end

    def clean_quotations(txt)
      txt.apply QuotationsFirstRule, QuotationsSecondRule
    end

    def clean_table_of_contents(txt)
      txt.apply TableOfContentsRule, ConsecutivePeriodsRule,
        ConsecutiveForwardSlashRule
    end

    def clean_consecutive_characters(txt)
      txt.apply ConsecutivePeriodsRule, ConsecutiveForwardSlashRule
    end
  end
end
