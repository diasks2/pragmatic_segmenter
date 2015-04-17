# -*- encoding : utf-8 -*-

module PragmaticSegmenter
  # This class searches for numbers with periods within a string and
  # replaces the periods.
  class Number
    # Rubular: http://rubular.com/r/oNyxBOqbyy
    PeriodBeforeNumberRule = Rule.new(/\.(?=\d)/, '∯')

    # Rubular: http://rubular.com/r/EMk5MpiUzt
    NumberAfterPeriodBeforeLetterRule = Rule.new(/(?<=\d)\.(?=\S)/, '∯')

    # Rubular: http://rubular.com/r/rf4l1HjtjG
    NewLineNumberPeriodSpaceLetterRule = Rule.new(/(?<=\r\d)\.(?=(\s\S)|\))/, '∯')

    # Rubular: http://rubular.com/r/HPa4sdc6b9
    StartLineNumberPeriodRule = Rule.new(/(?<=^\d)\.(?=(\s\S)|\))/, '∯')

    # Rubular: http://rubular.com/r/NuvWnKleFl
    StartLineTwoDigitNumberPeriodRule = Rule.new(/(?<=^\d\d)\.(?=(\s\S)|\))/, '∯')

    def rules
      [
        PeriodBeforeNumberRule,
        NumberAfterPeriodBeforeLetterRule,
        NewLineNumberPeriodSpaceLetterRule,
        StartLineNumberPeriodRule,
        StartLineTwoDigitNumberPeriodRule
      ]
    end

    attr_reader :text
    def initialize(text:)
      @text = Text.new(text)
    end

    def replace
      @text.apply rules
    end
  end
end
