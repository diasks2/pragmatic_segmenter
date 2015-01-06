# -*- encoding : utf-8 -*-
require 'pragmatic_segmenter/abbreviation'

module PragmaticSegmenter
  # This class searches for periods within an abbreviation and
  # replaces the periods.
  class AbbreviationReplacer
    # Rubular: http://rubular.com/r/yqa4Rit8EY
    PossessiveAbbreviationRule = Rule.new(/\.(?='s\s)|\.(?='s$)|\.(?='s\z)/, '∯')

    # Rubular: http://rubular.com/r/e3H6kwnr6H
    SingleUpperCaseLetterAtStartOfLineRule = Rule.new(/(?<=^[A-Z])\.(?=\s)/, '∯')

    # Rubular: http://rubular.com/r/gitvf0YWH4
    SingleUpperCaseLetterRule = Rule.new(/(?<=\s[A-Z])\.(?=\s)/, '∯')

    # Rubular: http://rubular.com/r/B4X33QKIL8
    DE_SingleLowerCaseLetterRule = Rule.new(/(?<=\s[a-z])\.(?=\s)/, '∯')

    # Rubular: http://rubular.com/r/iUNSkCuso0
    DE_SingleLowerCaseLetterAtStartOfLineRule = Rule.new(/(?<=^[a-z])\.(?=\s)/, '∯')

    # Rubular: http://rubular.com/r/xDkpFZ0EgH
    MULTI_PERIOD_ABBREVIATION_REGEX = /\b[a-z](?:\.[a-z])+[.]/i

    module AmPmRules
      # Rubular: http://rubular.com/r/Vnx3m4Spc8
      UpperCasePmRule = Rule.new(/(?<=P∯M)∯(?=\s[A-Z])/, '.')

      # Rubular: http://rubular.com/r/AJMCotJVbW
      UpperCaseAmRule = Rule.new(/(?<=A∯M)∯(?=\s[A-Z])/, '.')

      # Rubular: http://rubular.com/r/13q7SnOhgA
      LowerCasePmRule = Rule.new(/(?<=p∯m)∯(?=\s[A-Z])/, '.')

      # Rubular: http://rubular.com/r/DgUDq4mLz5
      LowerCaseAmRule = Rule.new(/(?<=a∯m)∯(?=\s[A-Z])/, '.')

      All = [UpperCasePmRule, UpperCaseAmRule, LowerCasePmRule, LowerCaseAmRule]
    end

    SENTENCE_STARTERS = %w(A Being Did For He How However I In Millions More She That The There They We What When Where Who Why)

    attr_reader :text, :language
    def initialize(text:, **args)
      @text = Text.new(text)
      @language = args[:language]
    end

    def replace
      reformatted_text = @text.apply(PossessiveAbbreviationRule)
      reformatted_text = replace_single_letter_abbreviations(reformatted_text)
      reformatted_text = search_for_abbreviations_in_string(reformatted_text)
      reformatted_text = replace_multi_period_abbreviations(reformatted_text)
      reformatted_text = reformatted_text.apply(AmPmRules::All)

      replace_abbreviation_as_sentence_boundary(reformatted_text)
    end

    private

    def replace_single_letter_abbreviations(txt)
      new_text = txt.apply(SingleUpperCaseLetterAtStartOfLineRule)
      if language.eql?('de')
        new_text = new_text.apply(DE_SingleLowerCaseLetterRule)
        new_text = new_text.apply(DE_SingleLowerCaseLetterAtStartOfLineRule)
      end
      new_text.apply(SingleUpperCaseLetterRule)
    end

    def search_for_abbreviations_in_string(txt)
      original = txt.dup
      downcased = txt.downcase
      abbr = PragmaticSegmenter::Abbreviation.new(language: language)
      abbr.all.each do |a|
        next unless downcased.include?(a.strip)
        abbrev_match = original.scan(/(?:^|\s|\r|\n)#{Regexp.escape(a.strip)}/i)
        next if abbrev_match.empty?
        next_word_start = /(?<=#{Regexp.escape(a.strip)} ).{1}/
        character_array = @text.scan(next_word_start)
        abbrev_match.each_with_index do |am, index|
          if language.eql?('de')
            txt = replace_abbr_de(txt, am)
          elsif language.eql?('ar') || language.eql?('fa')
            txt = replace_abbr_ar_fa(txt, am)
          else
            character = character_array[index]
            prefix = abbr.prefix
            number_abbr = abbr.number
            upper = /[[:upper:]]/.match(character.to_s)
            if upper.nil? || prefix.include?(am.downcase.strip)
              if prefix.include?(am.downcase.strip)
                txt = replace_prepositive_abbr(txt, am)
              elsif number_abbr.include?(am.downcase.strip)
                txt = replace_pre_number_abbr(txt, am)
              else
                if language.eql?('ru')
                  txt = replace_period_of_abbr_ru(txt, am)
                else
                  txt = replace_period_of_abbr(txt, am)
                end
              end
            end
          end
        end
      end
      txt
    end

    def replace_abbreviation_as_sentence_boundary(txt)
      # As we are being conservative and keeping ambiguous
      # sentence boundaries as one sentence instead of
      # splitting into two, we can split at words that
      # we know for certain never follow these abbreviations.
      # Some might say that the set of words that follow an
      # abbreviation such as U.S. (i.e. U.S. Government) is smaller than
      # the set of words that could start a sentence and
      # never follow U.S. However, we  are being conservative
      # and not splitting by default, so we need to look for places
      # where we definitely can split. Obviously SENTENCE_STARTERS
      # will never cover all cases, but as the gem is named
      # 'Pragmatic Segmenter' we need to be pragmatic
      # and try to cover the words that most often start a
      # sentence but could never follow one of the abbreviations below.

      SENTENCE_STARTERS.each do |word|
        txt = txt.gsub(/U∯S∯\s#{Regexp.escape(word)}\s/, "U∯S\.\s#{Regexp.escape(word)}\s")
              .gsub(/U\.S∯\s#{Regexp.escape(word)}\s/, "U\.S\.\s#{Regexp.escape(word)}\s")
              .gsub(/U∯K∯\s#{Regexp.escape(word)}\s/, "U∯K\.\s#{Regexp.escape(word)}\s")
              .gsub(/U\.K∯\s#{Regexp.escape(word)}\s/, "U\.K\.\s#{Regexp.escape(word)}\s")
              .gsub(/E∯U∯\s#{Regexp.escape(word)}\s/, "E∯U\.\s#{Regexp.escape(word)}\s")
              .gsub(/E\.U∯\s#{Regexp.escape(word)}\s/, "E\.U\.\s#{Regexp.escape(word)}\s")
              .gsub(/U∯S∯A∯\s#{Regexp.escape(word)}\s/, "U∯S∯A\.\s#{Regexp.escape(word)}\s")
              .gsub(/U\.S\.A∯\s#{Regexp.escape(word)}\s/, "U\.S\.A\.\s#{Regexp.escape(word)}\s")
              .gsub(/I∯\s#{Regexp.escape(word)}\s/, "I\.\s#{Regexp.escape(word)}\s")
      end
      txt
    end

    def replace_multi_period_abbreviations(txt)
      mpa = txt.scan(MULTI_PERIOD_ABBREVIATION_REGEX)
      return txt if mpa.empty?
      mpa.each do |r|
        txt = txt.gsub(/#{Regexp.escape(r)}/, "#{r.gsub!('.', '∯')}")
      end
      txt
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
  end
end
