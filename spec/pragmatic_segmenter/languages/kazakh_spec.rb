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

    it "Two letter abbreviation to end sentence #004" do
      ps = PragmaticSegmenter::Segmenter.new(text: "Мысалы: обкомға (облыстық комитетке) барды, ауаткомда (аудандық атқару комитетінде) болды, педучилищеге (педагогтік училищеге) түсті, медпункттің (медициналық пункттің) алдында т. б.", language: "kk")
      expect(ps.segment).to eq(["Мысалы: обкомға (облыстық комитетке) барды, ауаткомда (аудандық атқару комитетінде) болды, педучилищеге (педагогтік училищеге) түсті, медпункттің (медициналық пункттің) алдында т. б."])
    end

    it "Number as non sentence boundary #005" do
      ps = PragmaticSegmenter::Segmenter.new(text: "Елдің жалпы ішкі өнімі ЖІӨ (номинал) = $225.619 млрд (2014)", language: "kk")
      expect(ps.segment).to eq(["Елдің жалпы ішкі өнімі ЖІӨ (номинал) = $225.619 млрд (2014)"])
    end

    it "No whitespace between sentence boundary #006" do
      ps = PragmaticSegmenter::Segmenter.new(text: "Ресейдiң әлеуметтiк-экономикалық жағдайы.XVIII ғасырдың бiрiншi ширегiнде Ресейге тән нәрсе.", language: "kk")
      expect(ps.segment).to eq(["Ресейдiң әлеуметтiк-экономикалық жағдайы.", "XVIII ғасырдың бiрiншi ширегiнде Ресейге тән нәрсе."])
    end

    it "Dates within sentence #007" do
      ps = PragmaticSegmenter::Segmenter.new(text: "(«Егемен Қазақстан», 7 қыркүйек 2012 жыл. №590-591); Бұл туралы кеше санпедқадағалау комитетінің облыыстық департаменті хабарлады. («Айқын», 23 сəуір 2010 жыл. № 70).", language: "kk")
      expect(ps.segment).to eq(["(«Егемен Қазақстан», 7 қыркүйек 2012 жыл. №590-591); Бұл туралы кеше санпедқадағалау комитетінің облыыстық департаменті хабарлады.", "(«Айқын», 23 сəуір 2010 жыл. № 70)."])
    end

    it "Multi period abbreviation within sentence #008" do
      ps = PragmaticSegmenter::Segmenter.new(text: "Иран революциясы (1905 — 11) және азаматтық қозғалыс (1918 — 21) кезінде А. Фарахани, М. Кермани, М. Т. Бехар, т.б. ақындар демократиялық идеяның жыршысы болды.", language: "kk")
      expect(ps.segment).to eq(["Иран революциясы (1905 — 11) және азаматтық қозғалыс (1918 — 21) кезінде А. Фарахани, М. Кермани, М. Т. Бехар, т.б. ақындар демократиялық идеяның жыршысы болды."])
    end

    it "Web addresses #009" do
      ps = PragmaticSegmenter::Segmenter.new(text: "Владимир Федосеев: Аттар магиясы енді жоқ http://www.vremya.ru/2003/179/10/80980.html", language: "kk")
      expect(ps.segment).to eq(["Владимир Федосеев: Аттар магиясы енді жоқ http://www.vremya.ru/2003/179/10/80980.html"])
    end

    it "Question mark not at end of sentence #010" do
      ps = PragmaticSegmenter::Segmenter.new(text: "Бірақ оның енді не керегі бар? — деді.", language: "kk")
      expect(ps.segment).to eq(["Бірақ оның енді не керегі бар? — деді."])
    end

    it "Exclamation mark not at end of sentence #011" do
      ps = PragmaticSegmenter::Segmenter.new(text: "Сондықтан шапаныма жегізіп отырғаным! - деп, жауап береді.", language: "kk")
      expect(ps.segment).to eq(["Сондықтан шапаныма жегізіп отырғаным! - деп, жауап береді."])
    end
  end

  describe '#segment' do
    it 'correctly segments text #001' do
      ps = PragmaticSegmenter::Segmenter.new(text: "Б.з.б. 6 – 3 ғасырларда конфуцийшілдік, моизм, легизм мектептерінің қалыптасуы нәтижесінде Қытай философиясы пайда болды.", language: 'kk')
      expect(ps.segment).to eq(["Б.з.б. 6 – 3 ғасырларда конфуцийшілдік, моизм, легизм мектептерінің қалыптасуы нәтижесінде Қытай философиясы пайда болды."])
    end

    it 'correctly segments text #002' do
      ps = PragmaticSegmenter::Segmenter.new(text: "'Та марбута' тек сөз соңында екі түрде жазылады:", language: "kk")
      expect(ps.segment).to eq(["'Та марбута' тек сөз соңында екі түрде жазылады:"])
    end
  end
end
