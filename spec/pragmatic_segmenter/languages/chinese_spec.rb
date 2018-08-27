require 'spec_helper'

RSpec.describe PragmaticSegmenter::Languages::Chinese, '(zh)' do

  describe '#segment' do
    it 'correctly segments text #001' do
      ps = PragmaticSegmenter::Segmenter.new(text: "安永已聯繫周怡安親屬，協助辦理簽證相關事宜，周怡安家屬1月1日晚間搭乘東方航空班機抵達上海，他們步入入境大廳時神情落寞、不發一語。周怡安來自台中，去年剛從元智大學畢業，同年9月加入安永。", language: 'zh')
      expect(ps.segment).to eq(["安永已聯繫周怡安親屬，協助辦理簽證相關事宜，周怡安家屬1月1日晚間搭乘東方航空班機抵達上海，他們步入入境大廳時神情落寞、不發一語。", "周怡安來自台中，去年剛從元智大學畢業，同年9月加入安永。"])
    end

    it 'correctly segments text #002' do
      ps = PragmaticSegmenter::Segmenter.new(text: "我们明天一起去看《摔跤吧！爸爸》好吗？好！", language: 'zh')
      expect(ps.segment).to eq(["我们明天一起去看《摔跤吧！爸爸》好吗？", "好！"])
    end
  end
end
