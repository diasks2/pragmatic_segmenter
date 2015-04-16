module PragmaticSegmenter
  module Languages
    class Amharic < Common
      SENTENCE_BOUNDARY = /.*?[፧።!\?]|.*?$/

      class Process < PragmaticSegmenter::Process
        private

        def sentence_boundary_punctuation(txt)
          text.scan(SENTENCE_BOUNDARY)
        end

        def punctuation_array
          Amharic::Punctuations
        end
      end

      Punctuations = ['።', '፧', '?', '!']
    end
  end
end
