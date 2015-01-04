# -*- encoding : utf-8 -*-

module PragmaticSegmenter
  class List
    def initialize(text:)
      @text = text.dup
    end

    def add_line_break
      search_for_lists
      @text
    end

    private

    def search_for_lists
      search_for_alphabetical_list
      regex1 = /\s\d+(?=\.\s)|^\d+(?=\.\s)|\s\d+(?=\.\))|^\d+(?=\.\))|(?<=\s\-)\d+(?=\.\s)|(?<=^\-)\d+(?=\.\s)|(?<=\s\⁃)\d+(?=\.\s)|(?<=^\⁃)\d+(?=\.\s)|(?<=s\-)\d+(?=\.\))|(?<=^\-)\d+(?=\.\))|(?<=\s\⁃)\d+(?=\.\))|(?<=^\⁃)\d+(?=\.\))/
      regex2 = /(?<=\s)\d+\.(?=\s)|^\d+\.(?=\s)|(?<=\s)\d+\.(?=\))|^\d+\.(?=\))|(?<=\s\-)\d+\.(?=\s)|(?<=^\-)\d+\.(?=\s)|(?<=\s\⁃)\d+\.(?=\s)|(?<=^\⁃)\d+\.(?=\s)|(?<=\s\-)\d+\.(?=\))|(?<=^\-)\d+\.(?=\))|(?<=\s\⁃)\d+\.(?=\))|(?<=^\⁃)\d+\.(?=\))/
      scan_lists(regex1, regex2, '♨', true)
      regex3 = /\d+(?=\)\s)/
      scan_lists(regex3, regex3, '☝', false)
      insert_line_break
    end

    def insert_line_break
      if @text.include?('♨')
        unless @text =~ /♨.+\n.+♨|♨.+\r.+♨/
          unless @text =~ /for\s\d+♨\s[a-z]/
            # Rubular: http://rubular.com/r/Wv4qLdoPx7
            @text.gsub!(/(?<=\S\S|^)\s(?=\S\s*\d+♨)/, "\r")
            # Rubular: http://rubular.com/r/AizHXC6HxK
            @text.gsub!(/(?<=\S\S|^)\s(?=\d+♨)/, "\r")
          end
        end
      end
      if @text.include?('☝')
        unless @text =~ /☝.+\n.+☝|☝.+\r.+☝/
          # Rubular: http://rubular.com/r/GE5q6yID2j
          @text.gsub!(/(?<=\S\S|^)\s(?=\d+☝)/, "\r")
        end
      end
      @text.gsub!(/☝/, '')
      @text.gsub!(/♨/, '∯')
    end

    def scan_lists(regex1, regex2, replacement, strip)
      list_array = @text.scan(regex1).map(&:to_i)
      list_array.each_with_index do |a, i|
        next unless (a + 1) == list_array[i + 1] || (a - 1) == list_array[i - 1] || (a.eql?(0) && list_array[i - 1].eql?(9)) || (a.eql?(9) && list_array[i + 1].eql?(0))
        @text.gsub!(regex2).with_index do |m|
          if a.to_s.eql?(strip ? m.strip.chop : m)
            "#{Regexp.escape(a.to_s)}" + replacement
          else
            "#{m}"
          end
        end
      end
    end

    def search_for_alphabetical_list
      # Rubular: http://rubular.com/r/XcpaJKH0sz
      regex = /(?<=^)[a-z](?=\.)|(?<=\A)[a-z](?=\.)|(?<=\s)[a-z](?=\.)/i
      iterate_alphabet_array(regex, false)

      # Rubular: http://rubular.com/r/0MIlImeBsC
      regex = /(?<=^)[a-z](?=\))|(?<=\A)[a-z](?=\))|(?<=\s)[a-z](?=\))/i
      iterate_alphabet_array(regex, true)
    end

    def replace_alphabet_list(a)
      # Rubular: http://rubular.com/r/wMpnVedEIb
      @text.gsub!(/(?<=^)[a-z]\.|(?<=\A)[a-z]\.|(?<=\s)[a-z]\./i).with_index do |m|
        a.eql?(m.chomp('.')) ? "\r#{Regexp.escape(a.to_s)}∯" : "#{m}"
      end
    end

    def replace_alphabet_list_parens(a)
      # Rubular: http://rubular.com/r/0MIlImeBsC
      @text.gsub!(/(?<=^)[a-z](?=\))|(?<=\A)[a-z](?=\))|(?<=\s)[a-z](?=\))/i).with_index do |m|
        a.eql?(m) ? "\r#{Regexp.escape(a.to_s)}" : "#{m}"
      end
    end

    def iterate_alphabet_array(regex, parens)
      list_array = @text.scan(regex).map(&:downcase)
      alphabet = ('a'..'z').to_a
      list_array.each_with_index do |a, i|
        if i.eql?(list_array.length - 1)
          if (alphabet.index(list_array[i - 1]) - alphabet.index(a)).abs == 1
            parens ? replace_alphabet_list_parens(a) : replace_alphabet_list(a)
          end
        else
          if alphabet.index(list_array[i + 1]) - alphabet.index(a) == 1 || (alphabet.index(list_array[i - 1]) - alphabet.index(a)).abs == 1
            parens ? replace_alphabet_list_parens(a) : replace_alphabet_list(a)
          end
        end
      end
    end
  end
end
