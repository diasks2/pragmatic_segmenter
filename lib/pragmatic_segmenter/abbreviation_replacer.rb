# -*- encoding : utf-8 -*-

module PragmaticSegmenter
  # This class searches for periods within an abbreviation and
  # replaces the periods.
  class AbbreviationReplacer

    SENTENCE_STARTERS = %w(A Being Did For He How However I In It Millions More She That The There They We What When Where Who Why)

    attr_reader :text
    def initialize(text:, language: )
      @text = Text.new(text)
      @language = language
    end

    def replace
      @text.apply(@language::PossessiveAbbreviationRule,
        @language::KommanditgesellschaftRule,
        @language::SingleLetterAbbreviationRules::All)

      @text = search_for_abbreviations_in_string(@text)
      @text = replace_multi_period_abbreviations(@text)
      @text.apply(@language::AmPmRules::All)
      replace_abbreviation_as_sentence_boundary(@text)
    end

    private

    def search_for_abbreviations_in_string(txt)
      original = txt.dup
      downcased = txt.downcase
      @language::Abbreviation::ABBREVIATIONS.each do |a|
        next unless downcased.include?(a.strip)
        abbrev_match = original.scan(/(?:^|\s|\r|\n)#{Regexp.escape(a.strip)}/i)
        next if abbrev_match.empty?
        next_word_start = /(?<=#{Regexp.escape(a.strip)} ).{1}/
        character_array = @text.scan(next_word_start)
        abbrev_match.each_with_index do |am, index|
          txt = scan_for_replacements(txt, am, index, character_array)
        end
      end
      txt
    end

    def scan_for_replacements(txt, am, index, character_array)
      character = character_array[index]
      prepositive = @language::Abbreviation::PREPOSITIVE_ABBREVIATIONS
      number_abbr = @language::Abbreviation::NUMBER_ABBREVIATIONS
      upper = /[[:upper:]]/.match(character.to_s)
      if upper.nil? || prepositive.include?(am.downcase.strip)
        if prepositive.include?(am.downcase.strip)
          txt = replace_prepositive_abbr(txt, am)
        elsif number_abbr.include?(am.downcase.strip)
          txt = replace_pre_number_abbr(txt, am)
        else
          txt = replace_period_of_abbr(txt, am)
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
      # never follow U.S. However, we are being conservative
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
              .gsub(/i.v∯\s#{Regexp.escape(word)}\s/, "i\.v\.\s#{Regexp.escape(word)}\s")
              .gsub(/I.V∯\s#{Regexp.escape(word)}\s/, "I\.V\.\s#{Regexp.escape(word)}\s")
      end
      txt
    end

    def replace_multi_period_abbreviations(txt)
      mpa = txt.scan(@language::MULTI_PERIOD_ABBREVIATION_REGEX)
      return txt if mpa.empty?
      mpa.each do |r|
        txt = txt.gsub(/#{Regexp.escape(r)}/, "#{r.gsub!('.', '∯')}")
      end
      txt
    end

    def replace_pre_number_abbr(txt, abbr)
      txt.gsub(/(?<=\s#{abbr.strip})\.(?=\s\d)|(?<=^#{abbr.strip})\.(?=\s\d)/, '∯')
         .gsub(/(?<=\s#{abbr.strip})\.(?=\s+\()|(?<=^#{abbr.strip})\.(?=\s+\()/, '∯')

    end

    def replace_prepositive_abbr(txt, abbr)
      txt.gsub(/(?<=\s#{abbr.strip})\.(?=\s)|(?<=^#{abbr.strip})\.(?=\s)/, '∯')
         .gsub(/(?<=\s#{abbr.strip})\.(?=:\d+)|(?<=^#{abbr.strip})\.(?=:\d+)/, '∯')
    end

    def replace_period_of_abbr(txt, abbr)
      txt.gsub(/(?<=\s#{abbr.strip})\.(?=((\.|\:|\?)|(\s([a-z]|I\s|I'm|I'll|\d))))|(?<=^#{abbr.strip})\.(?=((\.|\:|\?)|(\s([a-z]|I\s|I'm|I'll|\d))))/, '∯')
         .gsub(/(?<=\s#{abbr.strip})\.(?=,)|(?<=^#{abbr.strip})\.(?=,)/, '∯')
    end

    def replace_possessive_abbreviations(txt)
      txt.gsub(@language::POSSESSIVE_ABBREVIATION_REGEX, '∯')
    end
  end
end
