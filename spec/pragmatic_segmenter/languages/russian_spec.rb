require 'spec_helper'

RSpec.describe PragmaticSegmenter::Languages::Russian, "(ru)" do

  context "Golden Rules" do
    it "Abbreviations #001" do
      ps = PragmaticSegmenter::Segmenter.new(text: "Объем составляет 5 куб.м.", language: "ru")
      expect(ps.segment).to eq(["Объем составляет 5 куб.м."])
    end

    it "Quotations #002" do
      ps = PragmaticSegmenter::Segmenter.new(text: "Маленькая девочка бежала и кричала: «Не видали маму?».", language: "ru")
      expect(ps.segment).to eq(["Маленькая девочка бежала и кричала: «Не видали маму?»."])
    end

    it "Numbers #003" do
      ps = PragmaticSegmenter::Segmenter.new(text: "Сегодня 27.10.14", language: "ru")
      expect(ps.segment).to eq(["Сегодня 27.10.14"])
    end
  end

  # Thanks to Anastasiia Tsvitailo for the Russian test examples.
  describe '#segment' do
    it 'correctly segments text #001' do
      ps = PragmaticSegmenter::Segmenter.new(text: "Маленькая девочка бежала и кричала: «Не видали маму?».", language: 'ru')
      expect(ps.segment).to eq(["Маленькая девочка бежала и кричала: «Не видали маму?»."])
    end

    it 'correctly segments text #002' do
      ps = PragmaticSegmenter::Segmenter.new(text: "«Я приду поздно»,  — сказал Андрей.", language: 'ru')
      expect(ps.segment).to eq(["«Я приду поздно»,  — сказал Андрей."])
    end

    it 'correctly segments text #003' do
      ps = PragmaticSegmenter::Segmenter.new(text: "«К чему ты готовишься? – спросила мама. – Завтра ведь выходной».", language: 'ru')
      expect(ps.segment).to eq(["«К чему ты готовишься? – спросила мама. – Завтра ведь выходной»."])
    end

    it 'correctly segments text #004' do
      ps = PragmaticSegmenter::Segmenter.new(text: "По словам Пушкина, «Привычка свыше дана, замена счастью она».", language: 'ru')
      expect(ps.segment).to eq(["По словам Пушкина, «Привычка свыше дана, замена счастью она»."])
    end

    it 'correctly segments text #005' do
      ps = PragmaticSegmenter::Segmenter.new(text: "Он сказал: «Я очень устал», и сразу же замолчал.", language: 'ru')
      expect(ps.segment).to eq(["Он сказал: «Я очень устал», и сразу же замолчал."])
    end

    it 'correctly segments text #006' do
      ps = PragmaticSegmenter::Segmenter.new(text: "Мне стало как-то ужасно грустно в это мгновение; однако что-то похожее на смех зашевелилось в душе моей.", language: 'ru')
      expect(ps.segment).to eq(["Мне стало как-то ужасно грустно в это мгновение; однако что-то похожее на смех зашевелилось в душе моей."])
    end

    it 'correctly segments text #007' do
      ps = PragmaticSegmenter::Segmenter.new(text: "Шухов как был в ватных брюках, не снятых на ночь (повыше левого колена их тоже был пришит затасканный, погрязневший лоскут, и на нем выведен черной, уже поблекшей краской номер Щ-854), надел телогрейку…", language: 'ru')
      expect(ps.segment).to eq(["Шухов как был в ватных брюках, не снятых на ночь (повыше левого колена их тоже был пришит затасканный, погрязневший лоскут, и на нем выведен черной, уже поблекшей краской номер Щ-854), надел телогрейку…"])
    end

    it 'correctly segments text #008' do
      ps = PragmaticSegmenter::Segmenter.new(text: "Слово «дом» является синонимом жилища", language: 'ru')
      expect(ps.segment).to eq(["Слово «дом» является синонимом жилища"])
    end

    it 'correctly segments text #009' do
      ps = PragmaticSegmenter::Segmenter.new(text: "В Санкт-Петербург на гастроли приехал театр «Современник»", language: 'ru')
      expect(ps.segment).to eq(["В Санкт-Петербург на гастроли приехал театр «Современник»"])
    end

    it 'correctly segments text #010' do
      ps = PragmaticSegmenter::Segmenter.new(text: "Машина едет со скоростью 100 км/ч.", language: 'ru')
      expect(ps.segment).to eq(["Машина едет со скоростью 100 км/ч."])
    end

    it 'correctly segments text #011' do
      ps = PragmaticSegmenter::Segmenter.new(text: "Я поем и/или лягу спать.", language: 'ru')
      expect(ps.segment).to eq(["Я поем и/или лягу спать."])
    end

    it 'correctly segments text #012' do
      ps = PragmaticSegmenter::Segmenter.new(text: "Он не мог справиться с примером \"3 + (14:7) = 5\"", language: 'ru')
      expect(ps.segment).to eq(["Он не мог справиться с примером \"3 + (14:7) = 5\""])
    end

    it 'correctly segments text #013' do
      ps = PragmaticSegmenter::Segmenter.new(text: "Вот список: 1.мороженое, 2.мясо, 3.рис.", language: 'ru')
      expect(ps.segment).to eq(["Вот список: 1.мороженое, 2.мясо, 3.рис."])
    end

    it 'correctly segments text #014' do
      ps = PragmaticSegmenter::Segmenter.new(text: "Квартира 234 находится на 4-ом этаже.", language: 'ru')
      expect(ps.segment).to eq(["Квартира 234 находится на 4-ом этаже."])
    end

    it 'correctly segments text #015' do
      ps = PragmaticSegmenter::Segmenter.new(text: "В это время года температура может подниматься до 40°C.", language: 'ru')
      expect(ps.segment).to eq(["В это время года температура может подниматься до 40°C."])
    end

    it 'correctly segments text #016' do
      ps = PragmaticSegmenter::Segmenter.new(text: "Объем составляет 5м³.", language: 'ru')
      expect(ps.segment).to eq(["Объем составляет 5м³."])
    end

    it 'correctly segments text #017' do
      ps = PragmaticSegmenter::Segmenter.new(text: "Объем составляет 5 куб.м.", language: 'ru')
      expect(ps.segment).to eq(["Объем составляет 5 куб.м."])
    end

    it 'correctly segments text #018' do
      ps = PragmaticSegmenter::Segmenter.new(text: "Площадь комнаты 14м².", language: 'ru')
      expect(ps.segment).to eq(["Площадь комнаты 14м²."])
    end

    it 'correctly segments text #019' do
      ps = PragmaticSegmenter::Segmenter.new(text: "Площадь комнаты 14 кв.м.", language: 'ru')
      expect(ps.segment).to eq(["Площадь комнаты 14 кв.м."])
    end

    it 'correctly segments text #020' do
      ps = PragmaticSegmenter::Segmenter.new(text: "1°C соответствует 33.8°F.", language: 'ru')
      expect(ps.segment).to eq(["1°C соответствует 33.8°F."])
    end

    it 'correctly segments text #021' do
      ps = PragmaticSegmenter::Segmenter.new(text: "Сегодня 27.10.14", language: 'ru')
      expect(ps.segment).to eq(["Сегодня 27.10.14"])
    end

    it 'correctly segments text #022' do
      ps = PragmaticSegmenter::Segmenter.new(text: "Сегодня 27 октября 2014 года.", language: 'ru')
      expect(ps.segment).to eq(["Сегодня 27 октября 2014 года."])
    end

    it 'correctly segments text #023' do
      ps = PragmaticSegmenter::Segmenter.new(text: "Эта машина стоит 150 000 дол.!", language: 'ru')
      expect(ps.segment).to eq(["Эта машина стоит 150 000 дол.!"])
    end

    it 'correctly segments text #024' do
      ps = PragmaticSegmenter::Segmenter.new(text: "Эта машина стоит $150 000!", language: 'ru')
      expect(ps.segment).to eq(["Эта машина стоит $150 000!"])
    end

    it 'correctly segments text #025' do
      ps = PragmaticSegmenter::Segmenter.new(text: "Вот номер моего телефона: +39045969798. Передавайте привет г-ну Шапочкину. До свидания.", language: 'ru')
      expect(ps.segment).to eq(["Вот номер моего телефона: +39045969798.", "Передавайте привет г-ну Шапочкину.", "До свидания."])
    end

    it 'correctly segments text #026' do
      ps = PragmaticSegmenter::Segmenter.new(text: "Постойте, разве можно указывать цены в у.е.!", language: 'ru')
      expect(ps.segment).to eq(["Постойте, разве можно указывать цены в у.е.!"])
    end

    it 'correctly segments text #027' do
      ps = PragmaticSegmenter::Segmenter.new(text: "Едем на скорости 90 км/ч в сторону пгт. Брагиновка, о котором мы так много слышали по ТВ!", language: 'ru')
      expect(ps.segment).to eq(["Едем на скорости 90 км/ч в сторону пгт. Брагиновка, о котором мы так много слышали по ТВ!"])
    end

    it 'correctly segments text #028' do
      ps = PragmaticSegmenter::Segmenter.new(text: "Д-р ветеринарных наук А. И. Семенов и пр. выступали на этом семинаре.", language: 'ru')
      expect(ps.segment).to eq(["Д-р ветеринарных наук А. И. Семенов и пр. выступали на этом семинаре."])
    end

    it 'correctly segments text #029' do
      ps = PragmaticSegmenter::Segmenter.new(text: "Уважаемый проф. Семенов! Просьба до 20.10 сдать отчет на кафедру.", language: 'ru')
      expect(ps.segment).to eq(["Уважаемый проф. Семенов!", "Просьба до 20.10 сдать отчет на кафедру."])
    end

    it 'correctly segments text #030' do
      ps = PragmaticSegmenter::Segmenter.new(text: "Первоначальная стоимость этого комплекта 30 долл., но сейчас действует скидка. Предъявите дисконтную карту, пожалуйста!", language: 'ru')
      expect(ps.segment).to eq(["Первоначальная стоимость этого комплекта 30 долл., но сейчас действует скидка.", "Предъявите дисконтную карту, пожалуйста!"])
    end

    it 'correctly segments text #031' do
      ps = PragmaticSegmenter::Segmenter.new(text: "Виктор съел пол-лимона и ушел по-английски из дома на ул. 1 Мая.", language: 'ru')
      expect(ps.segment).to eq(["Виктор съел пол-лимона и ушел по-английски из дома на ул. 1 Мая."])
    end

    it 'correctly segments text #032' do
      ps = PragmaticSegmenter::Segmenter.new(text: "Напоминаю Вам, что 25.10 день рождения у Маши К., нужно будет купить ей подарок.", language: 'ru')
      expect(ps.segment).to eq(["Напоминаю Вам, что 25.10 день рождения у Маши К., нужно будет купить ей подарок."])
    end

    it 'correctly segments text #033' do
      ps = PragmaticSegmenter::Segmenter.new(text: "В 2010-2012 гг. Виктор посещал г. Волгоград неоднократно.", language: 'ru')
      expect(ps.segment).to eq(["В 2010-2012 гг. Виктор посещал г. Волгоград неоднократно."])
    end

    it 'correctly segments text #034' do
      ps = PragmaticSegmenter::Segmenter.new(text: "Маленькая девочка бежала и кричала: «Не видали маму?»", language: 'ru')
      expect(ps.segment).to eq(["Маленькая девочка бежала и кричала: «Не видали маму?»"])
    end

    it 'correctly segments text #035' do
      ps = PragmaticSegmenter::Segmenter.new(text: "Кв. 234 находится на 4 этаже.", language: 'ru')
      expect(ps.segment).to eq(["Кв. 234 находится на 4 этаже."])
    end

    it 'correctly segments text #036' do
      ps = PragmaticSegmenter::Segmenter.new(text: "В это время года температура может подниматься до 40°C.", language: 'ru')
      expect(ps.segment).to eq(["В это время года температура может подниматься до 40°C."])
    end

    it 'correctly segments text #037' do
      ps = PragmaticSegmenter::Segmenter.new(text: "Нужно купить 1)рыбу 2)соль.", language: 'ru')
      expect(ps.segment).to eq(["Нужно купить 1)рыбу 2)соль."])
    end

    it 'correctly segments text #038' do
      ps = PragmaticSegmenter::Segmenter.new(text: "Машина едет со скоростью 100 км/ч.", language: 'ru')
      expect(ps.segment).to eq(["Машина едет со скоростью 100 км/ч."])
    end

    it 'correctly segments text #039' do
      ps = PragmaticSegmenter::Segmenter.new(text: "Л.Н. Толстой написал \"Войну и мир\". Кроме Волконских, Л. Н. Толстой состоял в близком родстве с некоторыми другими аристократическими родами. Дом, где родился Л.Н.Толстой, 1898 г. В 1854 году дом продан по распоряжению писателя на вывоз в село Долгое.", language: 'ru')
      expect(ps.segment).to eq(["Л.Н. Толстой написал \"Войну и мир\".", "Кроме Волконских, Л. Н. Толстой состоял в близком родстве с некоторыми другими аристократическими родами.", "Дом, где родился Л.Н.Толстой, 1898 г. В 1854 году дом продан по распоряжению писателя на вывоз в село Долгое."])
    end
  end
end
