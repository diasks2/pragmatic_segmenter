# -*- encoding : utf-8 -*-

module PragmaticSegmenter
  # This class searches for a list within a string and adds
  # newlines before each list item.
  class List
    # Rubular: http://rubular.com/r/XcpaJKH0sz
    ALPHABETICAL_LIST_WITH_PERIODS =
      /(?<=^)[a-z](?=\.)|(?<=\A)[a-z](?=\.)|(?<=\s)[a-z](?=\.)/

    # Rubular: http://rubular.com/r/Gu5rQapywf
    ALPHABETICAL_LIST_WITH_PARENS =
      /(?<=\()[a-z]+(?=\))|(?<=^)[a-z]+(?=\))|(?<=\A)[a-z]+(?=\))|(?<=\s)[a-z]+(?=\))/i

    SubstituteListPeriodRule = Rule.new(/♨/, '∯')
    ListMarkerRule = Rule.new(/☝/, '')

    # Rubular: http://rubular.com/r/Wv4qLdoPx7
    SpaceBetweenListItemsFirstRule = Rule.new(/(?<=\S\S|^)\s(?=\S\s*\d+♨)/, "\r")

    # Rubular: http://rubular.com/r/AizHXC6HxK
    SpaceBetweenListItemsSecondRule = Rule.new(/(?<=\S\S|^)\s(?=\d+♨)/, "\r")

    # Rubular: http://rubular.com/r/GE5q6yID2j
    SpaceBetweenListItemsThirdRule = Rule.new(/(?<=\S\S|^)\s(?=\d+☝)/, "\r")

    NUMBERED_LIST_REGEX_1 =
      /\s\d+(?=\.\s)|^\d+(?=\.\s)|\s\d+(?=\.\))|^\d+(?=\.\))|(?<=\s\-)\d+(?=\.\s)|(?<=^\-)\d+(?=\.\s)|(?<=\s\⁃)\d+(?=\.\s)|(?<=^\⁃)\d+(?=\.\s)|(?<=s\-)\d+(?=\.\))|(?<=^\-)\d+(?=\.\))|(?<=\s\⁃)\d+(?=\.\))|(?<=^\⁃)\d+(?=\.\))/
    NUMBERED_LIST_REGEX_2 =
      /(?<=\s)\d+\.(?=\s)|^\d+\.(?=\s)|(?<=\s)\d+\.(?=\))|^\d+\.(?=\))|(?<=\s\-)\d+\.(?=\s)|(?<=^\-)\d+\.(?=\s)|(?<=\s\⁃)\d+\.(?=\s)|(?<=^\⁃)\d+\.(?=\s)|(?<=\s\-)\d+\.(?=\))|(?<=^\-)\d+\.(?=\))|(?<=\s\⁃)\d+\.(?=\))|(?<=^\⁃)\d+\.(?=\))/
    NUMBERED_LIST_PARENS_REGEX = /\d+(?=\)\s)/

    # Rubular: http://rubular.com/r/NsNFSqrNvJ
    EXTRACT_ALPHABETICAL_LIST_LETTERS_REGEX =
      /\([a-z]+(?=\))|(?<=^)[a-z]+(?=\))|(?<=\A)[a-z]+(?=\))|(?<=\s)[a-z]+(?=\))/i

    # Rubular: http://rubular.com/r/wMpnVedEIb
    ALPHABETICAL_LIST_LETTERS_AND_PERIODS_REGEX =
      /(?<=^)[a-z]\.|(?<=\A)[a-z]\.|(?<=\s)[a-z]\./i

    attr_reader :text
    def initialize(text:)
      @text = Text.new(text)
    end

    def add_line_break
      formatted_text = format_alphabetical_lists(text)
      formatted_text = format_roman_numeral_lists(formatted_text)
      formatted_text = format_numbered_list_with_periods(formatted_text)
      format_numbered_list_with_parens(formatted_text)
    end

    private

    def format_numbered_list_with_parens(txt)
      new_txt = replace_parens_in_numbered_list(txt)
      new_txt = add_line_breaks_for_numbered_list_with_parens(new_txt)
      new_txt.apply(ListMarkerRule)
    end

    def format_numbered_list_with_periods(txt)
      new_txt = replace_periods_in_numbered_list(txt)
      new_txt = add_line_breaks_for_numbered_list_with_periods(new_txt)
      new_txt.apply(SubstituteListPeriodRule)
    end

    def format_alphabetical_lists(txt)
      new_txt = add_line_breaks_for_alphabetical_list_with_periods(txt, false)
      add_line_breaks_for_alphabetical_list_with_parens(new_txt, false)
    end

    def format_roman_numeral_lists(txt)
      new_txt = add_line_breaks_for_alphabetical_list_with_periods(txt, true)
      add_line_breaks_for_alphabetical_list_with_parens(new_txt, true)
    end

    def replace_periods_in_numbered_list(txt)
      scan_lists(NUMBERED_LIST_REGEX_1, NUMBERED_LIST_REGEX_2, '♨', true, txt)
    end

    def add_line_breaks_for_numbered_list_with_periods(txt)
      return txt unless txt.include?('♨') &&
                        txt !~ /♨.+\n.+♨|♨.+\r.+♨/ &&
                        txt !~ /for\s\d+♨\s[a-z]/
      txt.apply(SpaceBetweenListItemsFirstRule).
          apply(SpaceBetweenListItemsSecondRule)
    end

    def replace_parens_in_numbered_list(txt)
      scan_lists(
        NUMBERED_LIST_PARENS_REGEX, NUMBERED_LIST_PARENS_REGEX, '☝', false, txt)
    end

    def add_line_breaks_for_numbered_list_with_parens(txt)
      return txt unless txt.include?('☝') && txt !~ /☝.+\n.+☝|☝.+\r.+☝/
      txt.apply(SpaceBetweenListItemsThirdRule)
    end

    def scan_lists(regex1, regex2, replacement, strip, txt)
      list_array = txt.scan(regex1).map(&:to_i)
      list_array.each_with_index do |a, i|
        next unless (a + 1).eql?(list_array[i + 1]) ||
                    (a - 1).eql?(list_array[i - 1]) ||
                    (a.eql?(0) && list_array[i - 1].eql?(9)) ||
                    (a.eql?(9) && list_array[i + 1].eql?(0))
        substitute_found_list_items(txt, regex2, a, strip, replacement)
      end
      txt
    end

    def substitute_found_list_items(txt, regex, a, strip, replacement)
      txt.gsub!(regex).with_index do |m|
        if a.to_s.eql?(strip ? m.strip.chop : m)
          "#{Regexp.escape(a.to_s)}" + replacement
        else
          "#{m}"
        end
      end
    end

    def add_line_breaks_for_alphabetical_list_with_periods(txt, roman_numeral)
      iterate_alphabet_array(ALPHABETICAL_LIST_WITH_PERIODS, false, txt, roman_numeral)
    end

    def add_line_breaks_for_alphabetical_list_with_parens(txt, roman_numeral)
      iterate_alphabet_array(ALPHABETICAL_LIST_WITH_PARENS, true, txt, roman_numeral)
    end

    def replace_alphabet_list(a, txt)
      txt.gsub!(ALPHABETICAL_LIST_LETTERS_AND_PERIODS_REGEX).with_index do |m|
        a.eql?(m.chomp('.')) ? "\r#{Regexp.escape(a.to_s)}∯" : "#{m}"
      end
    end

    def replace_alphabet_list_parens(a, txt)
      txt.gsub!(EXTRACT_ALPHABETICAL_LIST_LETTERS_REGEX).with_index do |m|
        if m.include?('(')
          a.eql?(m.dup.downcase.gsub!(/\(/, '')) ? "\r&✂&#{Regexp.escape(m.gsub!(/\(/, ''))}" : "#{m}"
        else
          a.eql?(m.dup.downcase) ? "\r#{Regexp.escape(m)}" : "#{m}"
        end
      end
    end

    def replace_correct_alphabet_list(a, txt, parens)
      if parens
        replace_alphabet_list_parens(a, txt)
      else
        replace_alphabet_list(a, txt)
      end
    end

    def last_array_item_replacement(a, i, alphabet, list_array, txt, parens)
      return if alphabet & list_array == [] ||
        !alphabet.include?(list_array[i - 1]) ||
        !alphabet.include?(a)
      return if (alphabet.index(list_array[i - 1]) - alphabet.index(a)).abs != 1
      replace_correct_alphabet_list(a, txt, parens)
    end

    def other_items_replacement(a, i, alphabet, list_array, txt, parens)
      return if alphabet & list_array == [] ||
        !alphabet.include?(list_array[i - 1]) ||
        !alphabet.include?(a) ||
        !alphabet.include?(list_array[i + 1])
      return if alphabet.index(list_array[i + 1]) - alphabet.index(a) != 1 &&
                (alphabet.index(list_array[i - 1]) - alphabet.index(a)).abs != 1
      replace_correct_alphabet_list(a, txt, parens)
    end

    def iterate_alphabet_array(regex, parens, txt, roman_numeral)
      list_array = txt.scan(regex).map(&:downcase)
      if roman_numeral
        alphabet = %w(i ii iii iv v vi vii viii ix x xi xii xiii xiv x xi xii xiii xv xvi xvii xviii xix xx)
      else
        alphabet = ('a'..'z').to_a
      end
      list_array.delete_if { |item| !alphabet.any? { |a| a.include?(item) } }
      list_array.each_with_index do |a, i|
        if i.eql?(list_array.length - 1)
          last_array_item_replacement(a, i, alphabet, list_array, txt, parens)
        else
          other_items_replacement(a, i, alphabet, list_array, txt, parens)
        end
      end
      txt
    end
  end
end
