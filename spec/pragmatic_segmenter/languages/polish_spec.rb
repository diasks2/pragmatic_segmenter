require 'spec_helper'

RSpec.describe PragmaticSegmenter::Languages::Polish, '(pl)' do

  describe '#segment' do
    it 'correctly segments text #001' do
      ps = PragmaticSegmenter::Segmenter.new(text: "To słowo bałt. jestskrótem.", language: 'pl')
      expect(ps.segment).to eq(["To słowo bałt. jestskrótem."])
    end
  end
end
