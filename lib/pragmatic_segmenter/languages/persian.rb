module PragmaticSegmenter
  module Languages
    module Persian
      include Languages::Common

      SENTENCE_BOUNDARY = /.*?[:\.!\?؟]|.*?\z|.*?$/
      Punctuations = ['?', '!', ':', '.', '؟']

      ReplaceColonBetweenNumbersRule = Rule.new(/(?<=\d):(?=\d)/, '♭')
      ReplaceNonSentenceBoundaryCommaRule = Rule.new(/،(?=\s\S+،)/, '♬')

      class Process < PragmaticSegmenter::Process
        private

        def sentence_boundary_punctuation(txt)
          txt = txt.apply ReplaceColonBetweenNumbersRule,
            ReplaceNonSentenceBoundaryCommaRule
          txt.scan(SENTENCE_BOUNDARY)
        end

        def replace_abbreviations(txt)
          AbbreviationReplacer.new(text: txt).replace
        end
      end

      class AbbreviationReplacer  < PragmaticSegmenter::AbbreviationReplacer
        private

        def scan_for_replacements(txt, am, index, character_array)
          txt.gsub(/(?<=#{am})\./, '∯')
        end
      end
    end
  end
end
