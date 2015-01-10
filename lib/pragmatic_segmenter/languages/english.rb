module PragmaticSegmenter
  module Languages
    class English
      class Process < PragmaticSegmenter::Process
      end

      class Cleaner < PragmaticSegmenter::Cleaner
        def clean
          super
          clean_quotations(@clean_text)
        end

        private

        def clean_quotations(txt)
          txt.gsub(/`/, "'")
        end
      end

      class AbbreviationReplacer  < PragmaticSegmenter::AbbreviationReplacer
        private

        def abbreviations
          PragmaticSegmenter::Languages::English::Abbreviation.new
        end
      end
    end
  end
end
