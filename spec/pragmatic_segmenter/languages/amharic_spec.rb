require 'spec_helper'

RSpec.describe PragmaticSegmenter::Languages::Amharic, '(am)' do

  context "Golden Rules" do
    it "Sentence ending punctuation #001" do
      ps = PragmaticSegmenter::Segmenter.new(text: "እንደምን አለህ፧መልካም ቀን ይሁንልህ።እባክሽ ያልሽዉን ድገሚልኝ።", language: 'am')
      expect(ps.segment).to eq(["እንደምን አለህ፧", "መልካም ቀን ይሁንልህ።", "እባክሽ ያልሽዉን ድገሚልኝ።"])
    end
  end

  describe '#segment' do
    it 'correctly segments text #001' do
      ps = PragmaticSegmenter::Segmenter.new(text: "እንደምን አለህ፧መልካም ቀን ይሁንልህ።እባክሽ ያልሽዉን ድገሚልኝ።", language: 'am')
      expect(ps.segment).to eq(["እንደምን አለህ፧", "መልካም ቀን ይሁንልህ።", "እባክሽ ያልሽዉን ድገሚልኝ።"])
    end
  end
end
