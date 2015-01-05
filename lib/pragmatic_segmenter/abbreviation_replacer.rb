# -*- encoding : utf-8 -*-
require 'pragmatic_segmenter/abbreviation'

module PragmaticSegmenter
  # This class searches for periods within an abbreviation and
  # replaces the periods.
  class AbbreviationReplacer
    # Rubular: http://rubular.com/r/yqa4Rit8EY
    POSSESSIVE_ABBREVIATION_REGEX = /\.(?='s\s)|\.(?='s$)|\.(?='s\z)/

    # Rubular: http://rubular.com/r/e3H6kwnr6H
    SINGLE_UPPERCASE_LETTER_AT_START_OF_LINE_REGEX =  /(?<=^[A-Z])\.(?=\s)/

    # Rubular: http://rubular.com/r/gitvf0YWH4
    SINGLE_UPPERCASE_LETTER_REGEX = /(?<=\s[A-Z])\.(?=\s)/

    # Rubular: http://rubular.com/r/B4X33QKIL8
    SINGLE_LOWERCASE_LETTER_DE_REGEX = /(?<=\s[a-z])\.(?=\s)/

    # Rubular: http://rubular.com/r/iUNSkCuso0
    SINGLE_LOWERCASE_LETTER_AT_START_OF_LINE_DE_REGEX = /(?<=^[a-z])\.(?=\s)/

    attr_reader :text, :language
    def initialize(text:, **args)
      @text = text.dup
      @language = args[:language]
    end

    def replace
      @text = replace_possessive_abbreviations(@text)
      @text = replace_single_letter_abbreviations(@text)
      search_for_abbreviations_in_string

      @text
    end

    private

    def replace_single_letter_abbreviations(txt)
      new_text = replace_single_uppercase_letter_abbrviation_at_start_of_line(txt)
      new_text = replace_single_lowercase_letter_de(new_text) if language.eql?('de')
      new_text = replace_single_lowercase_letter_at_start_of_line_de(new_text) if language.eql?('de')
      replace_single_uppercase_letter_abbreviation(new_text)
    end

    def search_for_abbreviations_in_string
      original = @text.dup
      downcased = @text.downcase
      abbr = PragmaticSegmenter::Abbreviation.new(language: language)
      abbr.all.each do |a|
        next unless downcased.include?(a.strip)
        abbrev_match = original.scan(/(?:^|\s|\r|\n)#{Regexp.escape(a.strip)}/i)
        next if abbrev_match.empty?
        next_word_start = /(?<=#{Regexp.escape(a.strip)} ).{1}/
        character_array = @text.scan(next_word_start)
        abbrev_match.each_with_index do |am, index|
          if language.eql?('de')
            @text = replace_abbr_de(@text, am)
          elsif language.eql?('ar') || language.eql?('fa')
            @text = replace_abbr_ar_fa(@text, am)
          else
            character = character_array[index]
            prefix = abbr.prefix
            number_abbr = abbr.number
            upper = /[[:upper:]]/.match(character.to_s)
            if upper.nil? || prefix.include?(am.downcase.strip)
              if prefix.include?(am.downcase.strip)
                @text = replace_prepositive_abbr(@text, am)
              elsif number_abbr.include?(am.downcase.strip)
                @text = replace_pre_number_abbr(@text, am)
              else
                if language.eql?('ru')
                  @text = replace_period_of_abbr_ru(@text, am)
                else
                  @text = replace_period_of_abbr(@text, am)
                end
              end
            end
          end
        end
      end
    end

    def replace_abbr_de(txt, abbr)
      txt.gsub(/(?<=#{abbr})\.(?=\s)/, '∯')
    end

    def replace_abbr_ar_fa(txt, abbr)
      txt.gsub(/(?<=#{abbr})\./, '∯')
    end

    def replace_pre_number_abbr(txt, abbr)
      txt.gsub(/(?<=#{abbr.strip})\.(?=\s\d)/, '∯').gsub(/(?<=#{abbr.strip})\.(?=\s+\()/, '∯')
    end

    def replace_prepositive_abbr(txt, abbr)
      txt.gsub(/(?<=#{abbr.strip})\.(?=\s)/, '∯')
    end

    def replace_period_of_abbr(txt, abbr)
      txt.gsub(/(?<=#{abbr.strip})\.(?=((\.|:|\?)|(\s([a-z]|I\s|I'm|I'll|\d))))/, '∯')
        .gsub(/(?<=#{abbr.strip})\.(?=,)/, '∯')
    end

    def replace_period_of_abbr_ru(txt, abbr)
      txt.gsub(/(?<=\s#{abbr.strip})\./, '∯')
        .gsub(/(?<=\A#{abbr.strip})\./, '∯')
        .gsub(/(?<=^#{abbr.strip})\./, '∯')
    end

    def replace_single_lowercase_letter_at_start_of_line_de(txt)
      txt.gsub(SINGLE_LOWERCASE_LETTER_AT_START_OF_LINE_DE_REGEX, '∯')
    end

    def replace_single_lowercase_letter_de(txt)
      txt.gsub(SINGLE_LOWERCASE_LETTER_DE_REGEX, '∯')
    end

    def replace_single_uppercase_letter_abbrviation_at_start_of_line(txt)
      txt.gsub(SINGLE_UPPERCASE_LETTER_AT_START_OF_LINE_REGEX, '∯')
    end

    def replace_single_uppercase_letter_abbreviation(txt)
      txt.gsub(SINGLE_UPPERCASE_LETTER_REGEX, '∯')
    end

    def replace_possessive_abbreviations(txt)
      txt.gsub(POSSESSIVE_ABBREVIATION_REGEX, '∯')
    end
  end
end
