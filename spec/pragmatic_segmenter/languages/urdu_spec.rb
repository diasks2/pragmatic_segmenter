require 'spec_helper'

RSpec.describe PragmaticSegmenter::Languages::Urdu, '(ur)' do

  context "Golden Rules" do
    it "Sentence ending punctuation #001" do
      ps = PragmaticSegmenter::Segmenter.new(text: "کیا حال ہے؟ ميرا نام ___ ەے۔ میں حالا تاوان دےدوں؟", language: 'ur')
      expect(ps.segment).to eq(["کیا حال ہے؟", "ميرا نام ___ ەے۔", "میں حالا تاوان دےدوں؟"])
    end
  end

  describe '#segment' do
    it 'correctly segments text #001' do
      ps = PragmaticSegmenter::Segmenter.new(text: "کیا حال ہے؟ ميرا نام ___ ەے۔ میں حالا تاوان دےدوں؟", language: 'ur')
      expect(ps.segment).to eq(["کیا حال ہے؟", "ميرا نام ___ ەے۔", "میں حالا تاوان دےدوں؟"])
    end
  end
end
