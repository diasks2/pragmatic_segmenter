# -*- encoding : utf-8 -*-

module PragmaticSegmenter
  # This class searches for periods in email addresses
  # within a string and replaces the periods.
  class Email
    # Rubular: http://rubular.com/r/EUbZCNfgei
    EmailRule = Rule.new(/(\w)(\.)(\w)/, '\1∮\3')

    def initialize(text:)
      @text = Text.new(text)
    end

    def replace
      @text.apply(EmailRule)
    end
  end
end
