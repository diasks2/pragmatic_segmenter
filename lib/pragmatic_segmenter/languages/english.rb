module PragmaticSegmenter
  module Languages
    module English
      include Languages::Common

      class Cleaner < Cleaner
        def clean
          super
          clean_quotations
        end

        private

        def clean_quotations
          @text.gsub(/`/, "'")
        end

        def abbreviations
          []
        end
      end
    end
  end
end
