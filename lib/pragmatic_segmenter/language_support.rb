module PragmaticSegmenter
  module LanguageSupport
    LANGUAGE_CODES = {
      'en' => 'English',
      'de' => 'Deutsch',
      'es' => 'Spanish',
      'fr' => 'French',
      'it' => 'Italian',
      'ja' => 'Japanese',
      'el' => 'Greek',
      'ru' => 'Russian',
      'ar' => 'Arabic',
      'am' => 'Amharic',
      'hi' => 'Hindi',
      'hy' => 'Armenian',
      'fa' => 'Persian',
      'my' => 'Burmese',
      'ur' => 'Urdu',
    }

    def process_class
      Object.const_get("PragmaticSegmenter::Languages::#{LANGUAGE_CODES[language] || 'Common'}::Process")
    end

    def cleaner_class
      Object.const_get("PragmaticSegmenter::Languages::#{LANGUAGE_CODES[language] || 'Common'}::Cleaner")
    end
  end
end
