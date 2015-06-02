require 'spec_helper'

RSpec.describe PragmaticSegmenter::Languages::Persian, '(fa)' do

  context "Golden Rules" do
    it "Sentence ending punctuation #001" do
      ps = PragmaticSegmenter::Segmenter.new(text: "خوشبختم، آقای رضا. شما کجایی هستید؟ من از تهران هستم.", language: 'fa')
      expect(ps.segment).to eq(["خوشبختم، آقای رضا.", "شما کجایی هستید؟", "من از تهران هستم."])
    end
  end

  describe '#segment' do
    it 'correctly segments text #001' do
      ps = PragmaticSegmenter::Segmenter.new(text: "خوشبختم، آقای رضا. شما کجایی هستید؟ من از تهران هستم.", language: 'fa')
      expect(ps.segment).to eq(["خوشبختم، آقای رضا.", "شما کجایی هستید؟", "من از تهران هستم."])
    end
  end
end
