module PragmaticSegmenter
  module Languages
    class Persian
      class Process < PragmaticSegmenter::Process
        private

        def sentence_boundary_punctuation(txt)
          Persian::SentenceBoundaryPunctuation.new(text: txt).split
        end

        def replace_abbreviations(txt)
          Persian::AbbreviationReplacer.new(text: txt).replace
        end
      end

      Cleaner = PragmaticSegmenter::Cleaner

      class SentenceBoundaryPunctuation < PragmaticSegmenter::SentenceBoundaryPunctuation
        SENTENCE_BOUNDARY = /.*?[:\.!\?؟]|.*?\z|.*?$/

        ReplaceColonBetweenNumbersRule = Rule.new(/(?<=\d):(?=\d)/, '♭')
        ReplaceNonSentenceBoundaryCommaRule = Rule.new(/،(?=\s\S+،)/, '♬')

        def split
          txt = replace_non_sentence_boundary_punctuation(text)
          txt.scan(SENTENCE_BOUNDARY)
        end

        private

        def replace_non_sentence_boundary_punctuation(txt)
          txt.apply(ReplaceColonBetweenNumbersRule).
              apply(ReplaceNonSentenceBoundaryCommaRule)
        end
      end

      Punctuations = ['?', '!', ':', '.', '؟']

      class AbbreviationReplacer  < PragmaticSegmenter::AbbreviationReplacer
        private

        def scan_for_replacements(txt, am, index, character_array, abbr)
          replace_abbr(txt, am)
        end

        def replace_abbr(txt, abbr)
          txt.gsub(/(?<=#{abbr})\./, '∯')
        end
      end
    end
  end
end
