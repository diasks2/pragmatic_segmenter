# -*- encoding : utf-8 -*-

module PragmaticSegmenter
  # This class searches for periods in email addresses
  # within a string and replaces the periods.
  class Email
    # Rubular: http://rubular.com/r/EUbZCNfgei
    EMAIL_REGEX = /(\w)(\.)(\w)/

    attr_reader :text
    def initialize(text:)
      @text = text
    end

    def replace
      replace_periods_in_email_addresses(text)
    end

    private

    def replace_periods_in_email_addresses(txt)
      txt.gsub(EMAIL_REGEX, '\1∮\3')
    end
  end
end
