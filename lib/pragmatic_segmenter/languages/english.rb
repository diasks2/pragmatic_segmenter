module PragmaticSegmenter
  module Languages
    class English < Common
      class Cleaner < PragmaticSegmenter::Cleaner
        def clean
          super
          clean_quotations(@clean_text)
        end

        private

        def clean_quotations(txt)
          txt.gsub(/`/, "'")
        end

        def abbreviations
          []
        end
      end

      class AbbreviationReplacer  < PragmaticSegmenter::AbbreviationReplacer
        private

        def abbreviations
          PragmaticSegmenter::Abbreviation.new
        end
      end
    end
  end
end
