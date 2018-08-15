require 'spec_helper'

RSpec.describe PragmaticSegmenter::Languages::Kazakh, "(kk)" do

  context "Golden Rules" do
    it "Simple period to end sentence #001" do
      ps = PragmaticSegmenter::Segmenter.new(text: "Мұхитқа тікелей шыға алмайтын мемлекеттердің ішінде Қазақстан - ең үлкені.", language: "kk")
      expect(ps.segment).to eq(["Мұхитқа тікелей шыға алмайтын мемлекеттердің ішінде Қазақстан - ең үлкені."])
    end

    it "Question mark to end sentence #002" do
      ps = PragmaticSegmenter::Segmenter.new(text: "Оқушылар үйі, Достық даңғылы, Абай даналығы, ауыл шаруашылығы – кім? не?", language: "kk")
      expect(ps.segment).to eq(["Оқушылар үйі, Достық даңғылы, Абай даналығы, ауыл шаруашылығы – кім?", "не?"])
    end

    it "Parenthetical inside sentence #003" do
      ps = PragmaticSegmenter::Segmenter.new(text: "Әр түрлі өлшемнің атауы болып табылатын м (метр), см (сантиметр), кг (киллограмм), т (тонна), га (гектар), ц (центнер), т. б. (тағы басқа), тәрізді белгілер де қысқарған сөздер болып табылады.", language: "kk")
      expect(ps.segment).to eq(["Әр түрлі өлшемнің атауы болып табылатын м (метр), см (сантиметр), кг (киллограмм), т (тонна), га (гектар), ц (центнер), т. б. (тағы басқа), тәрізді белгілер де қысқарған сөздер болып табылады."])
    end


  end
end
