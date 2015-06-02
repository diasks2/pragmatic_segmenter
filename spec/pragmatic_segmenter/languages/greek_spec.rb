require 'spec_helper'

RSpec.describe PragmaticSegmenter::Languages::Greek, '(el)' do

  context "Golden Rules" do
    it "Question mark to end sentence #001" do
      ps = PragmaticSegmenter::Segmenter.new(text: "Με συγχωρείτε· πού είναι οι τουαλέτες; Τις Κυριακές δε δούλευε κανένας. το κόστος του σπιτιού ήταν £260.950,00.", language: "el")
      expect(ps.segment).to eq(["Με συγχωρείτε· πού είναι οι τουαλέτες;", "Τις Κυριακές δε δούλευε κανένας.", "το κόστος του σπιτιού ήταν £260.950,00."])
    end
  end

  describe '#segment' do
    it 'correctly segments text #001' do
      ps = PragmaticSegmenter::Segmenter.new(text: "Με συγχωρείτε· πού είναι οι τουαλέτες; Τις Κυριακές δε δούλευε κανένας. το κόστος του σπιτιού ήταν £260.950,00.", language: 'el')
      expect(ps.segment).to eq(["Με συγχωρείτε· πού είναι οι τουαλέτες;", "Τις Κυριακές δε δούλευε κανένας.", "το κόστος του σπιτιού ήταν £260.950,00."])
    end
  end
end
