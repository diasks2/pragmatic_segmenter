require 'spec_helper'

RSpec.describe PragmaticSegmenter::Segmenter do

  describe '#segment' do
    it 'handles nil' do
      ps = PragmaticSegmenter::Segmenter.new(text: nil)
      expect(ps.segment).to eq([])
    end

    it 'handles no language' do
      ps = PragmaticSegmenter::Segmenter.new(text: 'Hello world. Hello.')
      expect(ps.segment).to eq(["Hello world.", "Hello."])
    end

    it 'handles empty strings' do
      ps = PragmaticSegmenter::Segmenter.new(text: "\n")
      expect(ps.segment).to eq([])
    end

    it 'handles empty strings' do
      ps = PragmaticSegmenter::Segmenter.new(text: "<b></b>")
      expect(ps.segment).to eq([])
    end

    it 'handles empty strings' do
      ps = PragmaticSegmenter::Segmenter.new(text: '')
      expect(ps.segment).to eq([])
    end

    it 'has an option to not use the cleaner' do
      ps = PragmaticSegmenter::Segmenter.new(text: "It was a cold \nnight in the city.", language: "en", clean: false)
      expect(ps.segment).to eq(["It was a cold", "night in the city."])
    end

    it 'does not mutate the input string' do
      text = "It was a cold \nnight in the city."
      PragmaticSegmenter::Segmenter.new(text: text, language: "en").segment
      expect(text).to eq("It was a cold \nnight in the city.")
    end

    describe '#clean' do
      it 'cleans the text #001' do
        ps = PragmaticSegmenter::Cleaner.new(text: "It was a cold \nnight in the city.", language: "en")
        expect(ps.clean).to eq("It was a cold night in the city.")
      end

      it 'cleans the text #002' do
        text = 'injections made by the Shareholder through the years. 7 (max.) 3. Specifications/4.Design and function The operating instructions are part of the product and must be kept in the immediate vicinity of the instrument and readily accessible to skilled "'
        ps = PragmaticSegmenter::Cleaner.new(text: text)
        expect(ps.clean).to eq("injections made by the Shareholder through the years. 7 (max.) 3. Specifications/4.Design and function The operating instructions are part of the product and must be kept in the immediate vicinity of the instrument and readily accessible to skilled \"")
      end

      it 'does not mutate the input string (cleaner)' do
        text = "It was a cold \nnight in the city."
        PragmaticSegmenter::Cleaner.new(text: text, language: "en").clean
        expect(text).to eq("It was a cold \nnight in the city.")
      end
    end
  end

  describe 'Chinese', '(zh)' do
    describe '#segment' do
      it 'correctly segments text #001' do
        ps = PragmaticSegmenter::Segmenter.new(text: "安永已聯繫周怡安親屬，協助辦理簽證相關事宜，周怡安家屬1月1日晚間搭乘東方航空班機抵達上海，他們步入入境大廳時神情落寞、不發一語。周怡安來自台中，去年剛從元智大學畢業，同年9月加入安永。", language: 'zh')
        expect(ps.segment).to eq(["安永已聯繫周怡安親屬，協助辦理簽證相關事宜，周怡安家屬1月1日晚間搭乘東方航空班機抵達上海，他們步入入境大廳時神情落寞、不發一語。", "周怡安來自台中，去年剛從元智大學畢業，同年9月加入安永。"])
      end
    end
  end

  describe 'Polish', '(pl)' do
    describe '#segment' do
      it 'correctly segments text #001' do
        ps = PragmaticSegmenter::Segmenter.new(text: "To słowo bałt. jestskrótem.", language: 'pl')
        expect(ps.segment).to eq(["To słowo bałt. jestskrótem."])
      end
    end
  end
end
