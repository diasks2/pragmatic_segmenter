module PragmaticSegmenter
  module Languages
    class Amharic
      class SentenceBoundaryPunctuation < PragmaticSegmenter::SentenceBoundaryPunctuation
        SENTENCE_BOUNDARY = /.*?[፧።!\?]|.*?$/

        def split
          text.scan(SENTENCE_BOUNDARY)
        end
      end
<<<<<<< HEAD

      class Punctuation < PragmaticSegmenter::Punctuation
        PUNCT = ['።', '፧', '?', '!']

        def punct
          PUNCT
        end
      end
=======
>>>>>>> cf4b5c2f4f6950f770a2ec6777c79ff18c54a577
    end
  end
end
