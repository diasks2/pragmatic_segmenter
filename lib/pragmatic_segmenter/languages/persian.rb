module PragmaticSegmenter
  module Languages
    module Persian
      include Languages::Common

      SENTENCE_BOUNDARY_REGEX = /.*?[:\.!\?؟]|.*?\z|.*?$/
      Punctuations = ['?', '!', ':', '.', '؟']

      ReplaceColonBetweenNumbersRule = Rule.new(/(?<=\d):(?=\d)/, '♭')
      ReplaceNonSentenceBoundaryCommaRule = Rule.new(/،(?=\s\S+،)/, '♬')

      class AbbreviationReplacer  < AbbreviationReplacer
        private

        def scan_for_replacements(txt, am, index, character_array)
          txt.gsub!(/(?<=#{am})\./, '∯')
          txt
        end
      end
    end
  end
end
