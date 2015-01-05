# -*- encoding : utf-8 -*-

module PragmaticSegmenter
  # This class searches for a list within a string and adds
  # newlines before each list item.
  class List
    # Rubular: http://rubular.com/r/XcpaJKH0sz
    ALPHABETICAL_LIST_WITH_PERIODS = /(?<=^)[a-z](?=\.)|(?<=\A)[a-z](?=\.)|(?<=\s)[a-z](?=\.)/i

    # Rubular: http://rubular.com/r/0MIlImeBsC
    ALPHABETICAL_LIST_WITH_PARENS = /(?<=^)[a-z](?=\))|(?<=\A)[a-z](?=\))|(?<=\s)[a-z](?=\))/i

    # Rubular: http://rubular.com/r/Wv4qLdoPx7
    SPACE_BETWEEN_LIST_ITEMS_1 = /(?<=\S\S|^)\s(?=\S\s*\d+♨)/

    # Rubular: http://rubular.com/r/AizHXC6HxK
    SPACE_BETWEEN_LIST_ITEMS_2 = /(?<=\S\S|^)\s(?=\d+♨)/

    # Rubular: http://rubular.com/r/GE5q6yID2j
    SPACE_BETWEEN_LIST_ITEMS_3 = /(?<=\S\S|^)\s(?=\d+☝)/

    NUMBERED_LIST_REGEX_1 = /\s\d+(?=\.\s)|^\d+(?=\.\s)|\s\d+(?=\.\))|^\d+(?=\.\))|(?<=\s\-)\d+(?=\.\s)|(?<=^\-)\d+(?=\.\s)|(?<=\s\⁃)\d+(?=\.\s)|(?<=^\⁃)\d+(?=\.\s)|(?<=s\-)\d+(?=\.\))|(?<=^\-)\d+(?=\.\))|(?<=\s\⁃)\d+(?=\.\))|(?<=^\⁃)\d+(?=\.\))/
    NUMBERED_LIST_REGEX_2 = /(?<=\s)\d+\.(?=\s)|^\d+\.(?=\s)|(?<=\s)\d+\.(?=\))|^\d+\.(?=\))|(?<=\s\-)\d+\.(?=\s)|(?<=^\-)\d+\.(?=\s)|(?<=\s\⁃)\d+\.(?=\s)|(?<=^\⁃)\d+\.(?=\s)|(?<=\s\-)\d+\.(?=\))|(?<=^\-)\d+\.(?=\))|(?<=\s\⁃)\d+\.(?=\))|(?<=^\⁃)\d+\.(?=\))/
    NUMBERED_LIST_PARENS_REGEX = /\d+(?=\)\s)/

    # Rubular: http://rubular.com/r/0MIlImeBsC
    EXTRACT_ALPHABETICAL_LIST_LETTERS_REGEX = /(?<=^)[a-z](?=\))|(?<=\A)[a-z](?=\))|(?<=\s)[a-z](?=\))/i

    # Rubular: http://rubular.com/r/wMpnVedEIb
    ALPHABETICAL_LIST_LETTERS_AND_PERIODS_REGEX = /(?<=^)[a-z]\.|(?<=\A)[a-z]\.|(?<=\s)[a-z]\./i

    def initialize(text:)
      @text = text.dup
    end

    def add_line_break
      @text = add_line_breaks_for_alphabetical_list_with_periods(@text)
      @text = add_line_breaks_for_alphabetical_list_with_parens(@text)
      replace_periods_in_numbered_list
      @text = add_line_breaks_for_numbered_list_with_periods(@text)
      @text = substitute_list_period(@text)
      replace_parens_in_numbered_list
      @text = add_line_breaks_for_numbered_list_with_parens(@text)
      @text = replace_list_marker(@text)
      @text
    end

    private

    def replace_periods_in_numbered_list
      scan_lists(NUMBERED_LIST_REGEX_1, NUMBERED_LIST_REGEX_2, '♨', true)
    end

    def add_line_breaks_for_numbered_list_with_periods(txt)
      return txt unless txt.include?('♨') &&
                        txt !~ /♨.+\n.+♨|♨.+\r.+♨/ &&
                        txt !~ /for\s\d+♨\s[a-z]/
      txt.gsub(SPACE_BETWEEN_LIST_ITEMS_1, "\r").gsub(SPACE_BETWEEN_LIST_ITEMS_2, "\r")
    end

    def substitute_list_period(txt)
      txt.gsub(/♨/, '∯')
    end

    def replace_list_marker(txt)
      txt.gsub(/☝/, '')
    end

    def replace_parens_in_numbered_list
      scan_lists(NUMBERED_LIST_PARENS_REGEX, NUMBERED_LIST_PARENS_REGEX, '☝', false)
    end

    def add_line_breaks_for_numbered_list_with_parens(txt)
      return txt unless txt.include?('☝') && txt !~ /☝.+\n.+☝|☝.+\r.+☝/
      txt.gsub(SPACE_BETWEEN_LIST_ITEMS_3, "\r")
    end

    def scan_lists(regex1, regex2, replacement, strip)
      list_array = @text.scan(regex1).map(&:to_i)
      list_array.each_with_index do |a, i|
        next unless (a + 1).eql?(list_array[i + 1]) ||
                    (a - 1).eql?(list_array[i - 1]) ||
                    (a.eql?(0) && list_array[i - 1].eql?(9)) ||
                    (a.eql?(9) && list_array[i + 1].eql?(0))
        @text.gsub!(regex2).with_index do |m|
          if a.to_s.eql?(strip ? m.strip.chop : m)
            "#{Regexp.escape(a.to_s)}" + replacement
          else
            "#{m}"
          end
        end
      end
    end

    def add_line_breaks_for_alphabetical_list_with_periods(txt)
      iterate_alphabet_array(ALPHABETICAL_LIST_WITH_PERIODS, false, txt)
    end

    def add_line_breaks_for_alphabetical_list_with_parens(txt)
      iterate_alphabet_array(ALPHABETICAL_LIST_WITH_PARENS, true, txt)
    end

    def replace_alphabet_list(a, txt)
      txt.gsub!(ALPHABETICAL_LIST_LETTERS_AND_PERIODS_REGEX).with_index do |m|
        a.eql?(m.chomp('.')) ? "\r#{Regexp.escape(a.to_s)}∯" : "#{m}"
      end
      txt
    end

    def replace_alphabet_list_parens(a, txt)
      txt.gsub!(EXTRACT_ALPHABETICAL_LIST_LETTERS_REGEX).with_index do |m|
        a.eql?(m) ? "\r#{Regexp.escape(a.to_s)}" : "#{m}"
      end
      txt
    end

    def iterate_alphabet_array(regex, parens, txt)
      list_array = txt.scan(regex).map(&:downcase)
      alphabet = ('a'..'z').to_a
      new_txt = txt
      list_array.each_with_index do |a, i|
        if i.eql?(list_array.length - 1)
          if (alphabet.index(list_array[i - 1]) - alphabet.index(a)).abs == 1
            if parens
              new_txt = replace_alphabet_list_parens(a, txt)
            else
              new_txt = replace_alphabet_list(a, txt)
            end
          end
        else
          if alphabet.index(list_array[i + 1]) - alphabet.index(a) == 1 ||
             (alphabet.index(list_array[i - 1]) - alphabet.index(a)).abs == 1
            if parens
              new_txt = replace_alphabet_list_parens(a, txt)
            else
              new_txt = replace_alphabet_list(a, txt)
            end
          end
        end
      end
      new_txt
    end
  end
end
