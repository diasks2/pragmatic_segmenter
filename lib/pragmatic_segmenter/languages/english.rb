module PragmaticSegmenter
  module Languages
    module English
      include Languages::Common

      class Cleaner < Cleaner
        def clean
          super
          clean_quotations(@text)
        end

        private

        def clean_quotations(txt)
          txt.gsub(/`/, "'")
        end

        def abbreviations
          []
        end
      end
    end
  end
end
