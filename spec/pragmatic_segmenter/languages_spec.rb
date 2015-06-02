require 'spec_helper'

describe PragmaticSegmenter::Languages do
  describe '.get_language_by_code' do
    context "when language code defined" do
      PragmaticSegmenter::Languages::LANGUAGE_CODES.each do |code, lang|
        it "returns '#{lang}' for '#{code}'" do
          expect(described_class.get_language_by_code(code)).to eql(lang)
        end
      end
    end

    context "when language code not defined" do
      it "returns 'PragmaticSegmenter::Languages::Common'" do
        expect(described_class.get_language_by_code('xxyyzz')).to eql(PragmaticSegmenter::Languages::Common)
      end
    end

    context "when language code empty string" do
      it "returns 'PragmaticSegmenter::Languages::Common'" do
        expect(described_class.get_language_by_code('')).to eql(PragmaticSegmenter::Languages::Common)
      end
    end

    context "when language code nil" do
      it "returns 'PragmaticSegmenter::Languages::Common'" do
        expect(described_class.get_language_by_code(nil)).to eql(PragmaticSegmenter::Languages::Common)
      end
    end
  end
end
