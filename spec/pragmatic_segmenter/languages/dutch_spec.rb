require 'spec_helper'

RSpec.describe PragmaticSegmenter::Languages::Dutch, '(nl)' do

  context "Golden Rules" do
    it "Sentence starting with a number #001" do
      ps = PragmaticSegmenter::Segmenter.new(text: "Hij schoot op de JP8-brandstof toen de Surface-to-Air (sam)-missiles op hem af kwamen. 81 procent van de schoten was raak.", language: 'nl')
      expect(ps.segment).to eq(["Hij schoot op de JP8-brandstof toen de Surface-to-Air (sam)-missiles op hem af kwamen.", "81 procent van de schoten was raak."])
    end

    it "Sentence starting with an ellipsis #002" do
      ps = PragmaticSegmenter::Segmenter.new(text: "81 procent van de schoten was raak. ...en toen barste de hel los.", language: 'nl')
      expect(ps.segment).to eq(["81 procent van de schoten was raak.", "...en toen barste de hel los."])
    end
  end

  describe '#segment' do
    it 'correctly segments text #001' do
      ps = PragmaticSegmenter::Segmenter.new(text: "Afkorting aanw. vnw.", language: 'nl')
      expect(ps.segment).to eq(["Afkorting aanw. vnw."])
    end
  end
end
