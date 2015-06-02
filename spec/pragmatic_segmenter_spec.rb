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

  describe "Japanese", "(ja)" do
    context "Golden Rules" do
      it "Simple period to end sentence #001" do
        ps = PragmaticSegmenter::Segmenter.new(text: "これはペンです。それはマーカーです。", language: "ja")
        expect(ps.segment).to eq(["これはペンです。", "それはマーカーです。"])
      end

      it "Question mark to end sentence #002" do
        ps = PragmaticSegmenter::Segmenter.new(text: "それは何ですか？ペンですか？", language: "ja")
        expect(ps.segment).to eq(["それは何ですか？", "ペンですか？"])
      end

      it "Exclamation point to end sentence #003" do
        ps = PragmaticSegmenter::Segmenter.new(text: "良かったね！すごい！", language: "ja")
        expect(ps.segment).to eq(["良かったね！", "すごい！"])
      end

      it "Quotation #004" do
        ps = PragmaticSegmenter::Segmenter.new(text: "自民党税制調査会の幹部は、「引き下げ幅は３．２９％以上を目指すことになる」と指摘していて、今後、公明党と合意したうえで、３０日に決定する与党税制改正大綱に盛り込むことにしています。２％台後半を目指すとする方向で最終調整に入りました。", language: "ja")
        expect(ps.segment).to eq(["自民党税制調査会の幹部は、「引き下げ幅は３．２９％以上を目指すことになる」と指摘していて、今後、公明党と合意したうえで、３０日に決定する与党税制改正大綱に盛り込むことにしています。", "２％台後半を目指すとする方向で最終調整に入りました。"])
      end

      it "Errant newlines in the middle of sentences #005" do
        ps = PragmaticSegmenter::Segmenter.new(text: "これは父の\n家です。", language: "ja")
        expect(ps.segment).to eq(["これは父の家です。"])
      end
    end

    describe '#segment' do
      it 'correctly segments text #001' do
        ps = PragmaticSegmenter::Segmenter.new(text: "これは山です \nこれは山です \nこれは山です（「これは山です」） \nこれは山です（これは山です「これは山です」）これは山です・これは山です、これは山です。 \nこれは山です（これは山です。これは山です）。これは山です、これは山です、これは山です、これは山です（これは山です。これは山です）これは山です、これは山です、これは山です「これは山です」これは山です（これは山です：0円）これは山です。 \n1.）これは山です、これは山です（これは山です、これは山です6円（※1））これは山です。 \n※1　これは山です。 \n2.）これは山です、これは山です、これは山です、これは山です。 \n3.）これは山です、これは山です・これは山です、これは山です、これは山です、これは山です（これは山です「これは山です」）これは山です、これは山です、これは山です、これは山です。 \n4.）これは山です、これは山です（これは山です、これは山です、これは山です。これは山です）これは山です、これは山です（これは山です、これは山です）。 \nこれは山です、これは山です、これは山です、これは山です、これは山です（者）これは山です。 \n(1) 「これは山です」（これは山です：0円）　（※1） \n① これは山です", language: 'ja')
        expect(ps.segment).to eq(["これは山です", "これは山です", "これは山です（「これは山です」）", "これは山です（これは山です「これは山です」）これは山です・これは山です、これは山です。", "これは山です（これは山です。これは山です）。", "これは山です、これは山です、これは山です、これは山です（これは山です。これは山です）これは山です、これは山です、これは山です「これは山です」これは山です（これは山です：0円）これは山です。", "1.）これは山です、これは山です（これは山です、これは山です6円（※1））これは山です。", "※1　これは山です。", "2.）これは山です、これは山です、これは山です、これは山です。", "3.）これは山です、これは山です・これは山です、これは山です、これは山です、これは山です（これは山です「これは山です」）これは山です、これは山です、これは山です、これは山です。", "4.）これは山です、これは山です（これは山です、これは山です、これは山です。これは山です）これは山です、これは山です（これは山です、これは山です）。", "これは山です、これは山です、これは山です、これは山です、これは山です（者）これは山です。", "(1) 「これは山です」（これは山です：0円）　（※1）", "① これは山です"])
      end

      it 'correctly segments text #002' do
        ps = PragmaticSegmenter::Segmenter.new(text: "フフーの\n主たる債務", language: 'ja')
        expect(ps.segment).to eq(["フフーの主たる債務"])
      end

      it 'correctly segments text #003' do
        ps = PragmaticSegmenter::Segmenter.new(text: "これは山です \nこれは山です \nこれは山です（「これは山です」） \nこれは山です（これは山です「これは山です」）これは山です・これは山です、これは山です． \nこれは山です（これは山です．これは山です）．これは山です、これは山です、これは山です、これは山です（これは山です．これは山です）これは山です、これは山です、これは山です「これは山です」これは山です（これは山です：0円）これは山です． \n1.）これは山です、これは山です（これは山です、これは山です6円（※1））これは山です． \n※1　これは山です． \n2.）これは山です、これは山です、これは山です、これは山です． \n3.）これは山です、これは山です・これは山です、これは山です、これは山です、これは山です（これは山です「これは山です」）これは山です、これは山です、これは山です、これは山です． \n4.）これは山です、これは山です（これは山です、これは山です、これは山です．これは山です）これは山です、これは山です（これは山です、これは山です）． \nこれは山です、これは山です、これは山です、これは山です、これは山です（者）これは山です． \n(1) 「これは山です」（これは山です：0円）　（※1） \n① これは山です", language: 'ja')
        expect(ps.segment).to eq(["これは山です", "これは山です", "これは山です（「これは山です」）", "これは山です（これは山です「これは山です」）これは山です・これは山です、これは山です．", "これは山です（これは山です．これは山です）．", "これは山です、これは山です、これは山です、これは山です（これは山です．これは山です）これは山です、これは山です、これは山です「これは山です」これは山です（これは山です：0円）これは山です．", "1.）これは山です、これは山です（これは山です、これは山です6円（※1））これは山です．", "※1　これは山です．", "2.）これは山です、これは山です、これは山です、これは山です．", "3.）これは山です、これは山です・これは山です、これは山です、これは山です、これは山です（これは山です「これは山です」）これは山です、これは山です、これは山です、これは山です．", "4.）これは山です、これは山です（これは山です、これは山です、これは山です．これは山です）これは山です、これは山です（これは山です、これは山です）．", "これは山です、これは山です、これは山です、これは山です、これは山です（者）これは山です．", "(1) 「これは山です」（これは山です：0円）　（※1）", "① これは山です"])
      end

      it 'correctly segments text #004' do
        ps = PragmaticSegmenter::Segmenter.new(text: "これは山です \nこれは山です \nこれは山です（「これは山です」） \nこれは山です（これは山です「これは山です」）これは山です・これは山です、これは山です！ \nこれは山です（これは山です！これは山です）！これは山です、これは山です、これは山です、これは山です（これは山です！これは山です）これは山です、これは山です、これは山です「これは山です」これは山です（これは山です：0円）これは山です！ \n1.）これは山です、これは山です（これは山です、これは山です6円（※1））これは山です！ \n※1　これは山です！ \n2.）これは山です、これは山です、これは山です、これは山です！ \n3.）これは山です、これは山です・これは山です、これは山です、これは山です、これは山です（これは山です「これは山です」）これは山です、これは山です、これは山です、これは山です！ \n4.）これは山です、これは山です（これは山です、これは山です、これは山です！これは山です）これは山です、これは山です（これは山です、これは山です）！ \nこれは山です、これは山です、これは山です、これは山です、これは山です（者）これは山です！ \n(1) 「これは山です」（これは山です：0円）　（※1） \n① これは山です", language: 'ja')
        expect(ps.segment).to eq(["これは山です", "これは山です", "これは山です（「これは山です」）", "これは山です（これは山です「これは山です」）これは山です・これは山です、これは山です！", "これは山です（これは山です！これは山です）！", "これは山です、これは山です、これは山です、これは山です（これは山です！これは山です）これは山です、これは山です、これは山です「これは山です」これは山です（これは山です：0円）これは山です！", "1.）これは山です、これは山です（これは山です、これは山です6円（※1））これは山です！", "※1　これは山です！", "2.）これは山です、これは山です、これは山です、これは山です！", "3.）これは山です、これは山です・これは山です、これは山です、これは山です、これは山です（これは山です「これは山です」）これは山です、これは山です、これは山です、これは山です！", "4.）これは山です、これは山です（これは山です、これは山です、これは山です！これは山です）これは山です、これは山です（これは山です、これは山です）！", "これは山です、これは山です、これは山です、これは山です、これは山です（者）これは山です！", "(1) 「これは山です」（これは山です：0円）　（※1）", "① これは山です"])
      end
    end

  end

  describe "Arabic", '(ar)' do
    context "Golden Rules" do
      it "Regular punctuation #001" do
        ps = PragmaticSegmenter::Segmenter.new(text: "سؤال وجواب: ماذا حدث بعد الانتخابات الايرانية؟ طرح الكثير من التساؤلات غداة ظهور نتائج الانتخابات الرئاسية الايرانية التي أججت مظاهرات واسعة واعمال عنف بين المحتجين على النتائج ورجال الامن. يقول معارضو الرئيس الإيراني إن الطريقة التي اعلنت بها النتائج كانت مثيرة للاستغراب.", language: "ar")
        expect(ps.segment).to eq(["سؤال وجواب:", "ماذا حدث بعد الانتخابات الايرانية؟", "طرح الكثير من التساؤلات غداة ظهور نتائج الانتخابات الرئاسية الايرانية التي أججت مظاهرات واسعة واعمال عنف بين المحتجين على النتائج ورجال الامن.", "يقول معارضو الرئيس الإيراني إن الطريقة التي اعلنت بها النتائج كانت مثيرة للاستغراب."])
      end

      it "Abbreviations #002" do
        ps = PragmaticSegmenter::Segmenter.new(text: "وقال د‪.‬ ديفيد ريدي و الأطباء الذين كانوا يعالجونها في مستشفى برمنجهام إنها كانت تعاني من أمراض أخرى. وليس معروفا ما اذا كانت قد توفيت بسبب اصابتها بأنفلونزا الخنازير.", language: "ar")
        expect(ps.segment).to eq(["وقال د‪.‬ ديفيد ريدي و الأطباء الذين كانوا يعالجونها في مستشفى برمنجهام إنها كانت تعاني من أمراض أخرى.", "وليس معروفا ما اذا كانت قد توفيت بسبب اصابتها بأنفلونزا الخنازير."])
      end

      it "Numbers and Dates #003" do
        ps = PragmaticSegmenter::Segmenter.new(text: "ومن المنتظر أن يكتمل مشروع خط أنابيب نابوكو البالغ طوله 3300 كليومترا في 12‪/‬08‪/‬2014 بتكلفة تُقدر بـ 7.9 مليارات يورو أي نحو 10.9 مليارات دولار. ومن المقرر أن تصل طاقة ضخ الغاز في المشروع 31 مليار متر مكعب انطلاقا من بحر قزوين مرورا بالنمسا وتركيا ودول البلقان دون المرور على الأراضي الروسية.", language: "ar")
        expect(ps.segment).to eq(["ومن المنتظر أن يكتمل مشروع خط أنابيب نابوكو البالغ طوله 3300 كليومترا في 12‪/‬08‪/‬2014 بتكلفة تُقدر بـ 7.9 مليارات يورو أي نحو 10.9 مليارات دولار.", "ومن المقرر أن تصل طاقة ضخ الغاز في المشروع 31 مليار متر مكعب انطلاقا من بحر قزوين مرورا بالنمسا وتركيا ودول البلقان دون المرور على الأراضي الروسية."])
      end

      it "Time #004" do
        ps = PragmaticSegmenter::Segmenter.new(text: "الاحد, 21 فبراير/ شباط, 2010, 05:01 GMT الصنداي تايمز: رئيس الموساد قد يصبح ضحية الحرب السرية التي شتنها بنفسه. العقل المنظم هو مئير داجان رئيس الموساد الإسرائيلي الذي يشتبه بقيامه باغتيال القائد الفلسطيني في حركة حماس محمود المبحوح في دبي.", language: "ar")
        expect(ps.segment).to eq(["الاحد, 21 فبراير/ شباط, 2010, 05:01 GMT الصنداي تايمز:", "رئيس الموساد قد يصبح ضحية الحرب السرية التي شتنها بنفسه.", "العقل المنظم هو مئير داجان رئيس الموساد الإسرائيلي الذي يشتبه بقيامه باغتيال القائد الفلسطيني في حركة حماس محمود المبحوح في دبي."])
      end

      it "Comma #005" do
        ps = PragmaticSegmenter::Segmenter.new(text: "عثر في الغرفة على بعض أدوية علاج ارتفاع ضغط الدم، والقلب، زرعها عملاء الموساد كما تقول مصادر إسرائيلية، وقرر الطبيب أن الفلسطيني قد توفي وفاة طبيعية ربما إثر نوبة قلبية، وبدأت مراسم الحداد عليه", language: "ar")
        expect(ps.segment).to eq(["عثر في الغرفة على بعض أدوية علاج ارتفاع ضغط الدم، والقلب،", "زرعها عملاء الموساد كما تقول مصادر إسرائيلية،", "وقرر الطبيب أن الفلسطيني قد توفي وفاة طبيعية ربما إثر نوبة قلبية،", "وبدأت مراسم الحداد عليه"])
      end
    end

    # Thanks to Mahmoud Holmez for the Arabic test examples.
    describe '#segment' do
      it 'correctly segments text #001' do
        ps = PragmaticSegmenter::Segmenter.new(text: "سؤال وجواب: ماذا حدث بعد الانتخابات الايرانية؟ طرح الكثير من التساؤلات غداة ظهور نتائج الانتخابات الرئاسية الايرانية التي أججت مظاهرات واسعة واعمال عنف بين المحتجين على النتائج ورجال الامن. يقول معارضو الرئيس الإيراني إن الطريقة التي اعلنت بها النتائج كانت مثيرة للاستغراب.", language: 'ar')
        expect(ps.segment).to eq(["سؤال وجواب:", "ماذا حدث بعد الانتخابات الايرانية؟", "طرح الكثير من التساؤلات غداة ظهور نتائج الانتخابات الرئاسية الايرانية التي أججت مظاهرات واسعة واعمال عنف بين المحتجين على النتائج ورجال الامن.", "يقول معارضو الرئيس الإيراني إن الطريقة التي اعلنت بها النتائج كانت مثيرة للاستغراب."])
      end

      it 'correctly segments text #002' do
        ps = PragmaticSegmenter::Segmenter.new(text: "وقال د‪.‬ ديفيد ريدي و الأطباء الذين كانوا يعالجونها في مستشفى برمنجهام إنها كانت تعاني من أمراض أخرى. وليس معروفا ما اذا كانت قد توفيت بسبب اصابتها بأنفلونزا الخنازير.", language: 'ar')
        expect(ps.segment).to eq(["وقال د‪.‬ ديفيد ريدي و الأطباء الذين كانوا يعالجونها في مستشفى برمنجهام إنها كانت تعاني من أمراض أخرى.", "وليس معروفا ما اذا كانت قد توفيت بسبب اصابتها بأنفلونزا الخنازير."])
      end

      it 'correctly segments text #003' do
        ps = PragmaticSegmenter::Segmenter.new(text: "ومن المنتظر أن يكتمل مشروع خط أنابيب نابوكو البالغ طوله 3300 كليومترا في 12‪/‬08‪/‬2014 بتكلفة تُقدر بـ 7.9 مليارات يورو أي نحو 10.9 مليارات دولار. ومن المقرر أن تصل طاقة ضخ الغاز في المشروع 31 مليار متر مكعب انطلاقا من بحر قزوين مرورا بالنمسا وتركيا ودول البلقان دون المرور على الأراضي الروسية.", language: 'ar')
        expect(ps.segment).to eq(["ومن المنتظر أن يكتمل مشروع خط أنابيب نابوكو البالغ طوله 3300 كليومترا في 12‪/‬08‪/‬2014 بتكلفة تُقدر بـ 7.9 مليارات يورو أي نحو 10.9 مليارات دولار.", "ومن المقرر أن تصل طاقة ضخ الغاز في المشروع 31 مليار متر مكعب انطلاقا من بحر قزوين مرورا بالنمسا وتركيا ودول البلقان دون المرور على الأراضي الروسية."])
      end

      it 'correctly segments text #004' do
        ps = PragmaticSegmenter::Segmenter.new(text: "الاحد, 21 فبراير/ شباط, 2010, 05:01 GMT الصنداي تايمز: رئيس الموساد قد يصبح ضحية الحرب السرية التي شتنها بنفسه. العقل المنظم هو مئير داجان رئيس الموساد الإسرائيلي الذي يشتبه بقيامه باغتيال القائد الفلسطيني في حركة حماس محمود المبحوح في دبي.", language: 'ar')
        expect(ps.segment).to eq(["الاحد, 21 فبراير/ شباط, 2010, 05:01 GMT الصنداي تايمز:", "رئيس الموساد قد يصبح ضحية الحرب السرية التي شتنها بنفسه.", "العقل المنظم هو مئير داجان رئيس الموساد الإسرائيلي الذي يشتبه بقيامه باغتيال القائد الفلسطيني في حركة حماس محمود المبحوح في دبي."])
      end

      it 'correctly segments text #005' do
        ps = PragmaticSegmenter::Segmenter.new(text: "عثر في الغرفة على بعض أدوية علاج ارتفاع ضغط الدم، والقلب، زرعها عملاء الموساد كما تقول مصادر إسرائيلية، وقرر الطبيب أن الفلسطيني قد توفي وفاة طبيعية ربما إثر نوبة قلبية، وبدأت مراسم الحداد عليه", language: 'ar')
        expect(ps.segment).to eq(["عثر في الغرفة على بعض أدوية علاج ارتفاع ضغط الدم، والقلب،", "زرعها عملاء الموساد كما تقول مصادر إسرائيلية،", "وقرر الطبيب أن الفلسطيني قد توفي وفاة طبيعية ربما إثر نوبة قلبية،", "وبدأت مراسم الحداد عليه"])
      end
    end

  end

  describe "Italian", "(it)" do
    context "Golden Rules" do
      it "Abbreviations #001" do
        ps = PragmaticSegmenter::Segmenter.new(text: "Salve Sig.ra Mengoni! Come sta oggi?", language: "it")
        expect(ps.segment).to eq(["Salve Sig.ra Mengoni!", "Come sta oggi?"])
      end

      it "Quotations #002" do
        ps = PragmaticSegmenter::Segmenter.new(text: "Una lettera si può iniziare in questo modo «Il/la sottoscritto/a.».", language: "it")
        expect(ps.segment).to eq(["Una lettera si può iniziare in questo modo «Il/la sottoscritto/a.»."])
      end

      it "Numbers #003" do
        ps = PragmaticSegmenter::Segmenter.new(text: "La casa costa 170.500.000,00€!", language: "it")
        expect(ps.segment).to eq(["La casa costa 170.500.000,00€!"])
      end
    end

    # Thanks to Davide Fornelli for the Italian test examples.
    describe '#segment' do

      it 'correctly segments text #001' do
        ps = PragmaticSegmenter::Segmenter.new(text: "Salve Sig.ra Mengoni! Come sta oggi?", language: 'it')
        expect(ps.segment).to eq(["Salve Sig.ra Mengoni!", "Come sta oggi?"])
      end

      it 'correctly segments text #002' do
        ps = PragmaticSegmenter::Segmenter.new(text: "Buongiorno! Sono l'Ing. Mengozzi. È presente l'Avv. Cassioni?", language: 'it')
        expect(ps.segment).to eq(["Buongiorno!", "Sono l'Ing. Mengozzi.", "È presente l'Avv. Cassioni?"])
      end

      it 'correctly segments text #003' do
        ps = PragmaticSegmenter::Segmenter.new(text: "Mi fissi un appuntamento per mar. 23 Nov.. Grazie.", language: 'it')
        expect(ps.segment).to eq(["Mi fissi un appuntamento per mar. 23 Nov..", "Grazie."])
      end

      it 'correctly segments text #004' do
        ps = PragmaticSegmenter::Segmenter.new(text: "Ecco il mio tel.:01234567. Mi saluti la Sig.na Manelli. Arrivederci.", language: 'it')
        expect(ps.segment).to eq(["Ecco il mio tel.:01234567.", "Mi saluti la Sig.na Manelli.", "Arrivederci."])
      end

      it 'correctly segments text #005' do
        ps = PragmaticSegmenter::Segmenter.new(text: "La centrale meteor. si è guastata. Gli idraul. son dovuti andare a sistemarla.", language: 'it')
        expect(ps.segment).to eq(["La centrale meteor. si è guastata.", "Gli idraul. son dovuti andare a sistemarla."])
      end

      it 'correctly segments text #006' do
        ps = PragmaticSegmenter::Segmenter.new(text: "Hanno creato un algoritmo allo st. d. arte. Si ringrazia lo psicol. Serenti.", language: 'it')
        expect(ps.segment).to eq(["Hanno creato un algoritmo allo st. d. arte.", "Si ringrazia lo psicol. Serenti."])
      end

      it 'correctly segments text #007' do
        ps = PragmaticSegmenter::Segmenter.new(text: "Chiamate il V.Cte. delle F.P., adesso!", language: 'it')
        expect(ps.segment).to eq(["Chiamate il V.Cte. delle F.P., adesso!"])
      end

      it 'correctly segments text #008' do
        ps = PragmaticSegmenter::Segmenter.new(text: "Giancarlo ha sostenuto l'esame di econ. az..", language: 'it')
        expect(ps.segment).to eq(["Giancarlo ha sostenuto l'esame di econ. az.."])
      end

      it 'correctly segments text #009' do
        ps = PragmaticSegmenter::Segmenter.new(text: "Stava viaggiando a 90 km/h verso la provincia di TR quando il Dott. Mesini ha sentito un rumore e si fermò!", language: 'it')
        expect(ps.segment).to eq(["Stava viaggiando a 90 km/h verso la provincia di TR quando il Dott. Mesini ha sentito un rumore e si fermò!"])
      end

      it 'correctly segments text #010' do
        ps = PragmaticSegmenter::Segmenter.new(text: "Egregio Dir. Amm., le faccio sapere che l'ascensore non funziona.", language: 'it')
        expect(ps.segment).to eq(["Egregio Dir. Amm., le faccio sapere che l'ascensore non funziona."])
      end

      it 'correctly segments text #011' do
        ps = PragmaticSegmenter::Segmenter.new(text: "Stava mangiando e/o dormendo.", language: 'it')
        expect(ps.segment).to eq(["Stava mangiando e/o dormendo."])
      end

      it 'correctly segments text #012' do
        ps = PragmaticSegmenter::Segmenter.new(text: "Ricordatevi che dom 25 Set. sarà il compleanno di Maria; dovremo darle un regalo.", language: 'it')
        expect(ps.segment).to eq(["Ricordatevi che dom 25 Set. sarà il compleanno di Maria; dovremo darle un regalo."])
      end

      it 'correctly segments text #013' do
        ps = PragmaticSegmenter::Segmenter.new(text: "La politica è quella della austerità; quindi verranno fatti tagli agli sprechi.", language: 'it')
        expect(ps.segment).to eq(["La politica è quella della austerità; quindi verranno fatti tagli agli sprechi."])
      end

      it 'correctly segments text #014' do
        ps = PragmaticSegmenter::Segmenter.new(text: "Nel tribunale, l'Avv. Fabrizi ha urlato \"Io, l'illustrissimo Fabrizi, vi si oppone!\".", language: 'it')
        expect(ps.segment).to eq(["Nel tribunale, l'Avv. Fabrizi ha urlato \"Io, l'illustrissimo Fabrizi, vi si oppone!\"."])
      end

      it 'correctly segments text #015' do
        ps = PragmaticSegmenter::Segmenter.new(text: "Le parti fisiche di un computer (ad es. RAM, CPU, tastiera, mouse, etc.) sono definiti HW.", language: 'it')
        expect(ps.segment).to eq(["Le parti fisiche di un computer (ad es. RAM, CPU, tastiera, mouse, etc.) sono definiti HW."])
      end

      it 'correctly segments text #016' do
        ps = PragmaticSegmenter::Segmenter.new(text: "La parola 'casa' è sinonimo di abitazione.", language: 'it')
        expect(ps.segment).to eq(["La parola 'casa' è sinonimo di abitazione."])
      end

      it 'correctly segments text #017' do
        ps = PragmaticSegmenter::Segmenter.new(text: "La \"Mulino Bianco\" fa alimentari pre-confezionati.", language: 'it')
        expect(ps.segment).to eq(["La \"Mulino Bianco\" fa alimentari pre-confezionati."])
      end

      it 'correctly segments text #018' do
        ps = PragmaticSegmenter::Segmenter.new(text: "\"Ei fu. Siccome immobile / dato il mortal sospiro / stette la spoglia immemore / orba di tanto spiro / [...]\" (Manzoni).", language: 'it')
        expect(ps.segment).to eq(["\"Ei fu. Siccome immobile / dato il mortal sospiro / stette la spoglia immemore / orba di tanto spiro / [...]\" (Manzoni)."])
      end

      it 'correctly segments text #019' do
        ps = PragmaticSegmenter::Segmenter.new(text: "Una lettera si può iniziare in questo modo «Il/la sottoscritto/a ... nato/a a ...».", language: 'it')
        expect(ps.segment).to eq(["Una lettera si può iniziare in questo modo «Il/la sottoscritto/a ... nato/a a ...»."])
      end

      it 'correctly segments text #020' do
        ps = PragmaticSegmenter::Segmenter.new(text: "Per casa, in uno degli esercizi per i bambini c'era \"3 + (14/7) = 5\"", language: 'it')
        expect(ps.segment).to eq(["Per casa, in uno degli esercizi per i bambini c'era \"3 + (14/7) = 5\""])
      end

      it 'correctly segments text #021' do
        ps = PragmaticSegmenter::Segmenter.new(text: "Ai bambini è stato chiesto di fare \"4:2*2\"", language: 'it')
        expect(ps.segment).to eq(["Ai bambini è stato chiesto di fare \"4:2*2\""])
      end

      it 'correctly segments text #022' do
        ps = PragmaticSegmenter::Segmenter.new(text: "La maestra esclamò: \"Bambini, quanto fa '2/3 + 4/3?'\".", language: 'it')
        expect(ps.segment).to eq(["La maestra esclamò: \"Bambini, quanto fa \'2/3 + 4/3?\'\"."])
      end

      it 'correctly segments text #023' do
        ps = PragmaticSegmenter::Segmenter.new(text: "Il motore misurava 120°C.", language: 'it')
        expect(ps.segment).to eq(["Il motore misurava 120°C."])
      end

      it 'correctly segments text #024' do
        ps = PragmaticSegmenter::Segmenter.new(text: "Il volume era di 3m³.", language: 'it')
        expect(ps.segment).to eq(["Il volume era di 3m³."])
      end

      it 'correctly segments text #025' do
        ps = PragmaticSegmenter::Segmenter.new(text: "La stanza misurava 20m².", language: 'it')
        expect(ps.segment).to eq(["La stanza misurava 20m²."])
      end

      it 'correctly segments text #026' do
        ps = PragmaticSegmenter::Segmenter.new(text: "1°C corrisponde a 33.8°F.", language: 'it')
        expect(ps.segment).to eq(["1°C corrisponde a 33.8°F."])
      end

      it 'correctly segments text #027' do
        ps = PragmaticSegmenter::Segmenter.new(text: "Oggi è il 27-10-14.", language: 'it')
        expect(ps.segment).to eq(["Oggi è il 27-10-14."])
      end

      it 'correctly segments text #028' do
        ps = PragmaticSegmenter::Segmenter.new(text: "La casa costa 170.500.000,00€!", language: 'it')
        expect(ps.segment).to eq(["La casa costa 170.500.000,00€!"])
      end

      it 'correctly segments text #029' do
        ps = PragmaticSegmenter::Segmenter.new(text: "Il corridore 103 è arrivato 4°.", language: 'it')
        expect(ps.segment).to eq(["Il corridore 103 è arrivato 4°."])
      end

      it 'correctly segments text #030' do
        ps = PragmaticSegmenter::Segmenter.new(text: "Oggi è il 27/10/2014.", language: 'it')
        expect(ps.segment).to eq(["Oggi è il 27/10/2014."])
      end

      it 'correctly segments text #031' do
        ps = PragmaticSegmenter::Segmenter.new(text: "Ecco l'elenco: 1.gelato, 2.carne, 3.riso.", language: 'it')
        expect(ps.segment).to eq(["Ecco l'elenco: 1.gelato, 2.carne, 3.riso."])
      end

      it 'correctly segments text #032' do
        ps = PragmaticSegmenter::Segmenter.new(text: "Devi comprare : 1)pesce 2)sale.", language: 'it')
        expect(ps.segment).to eq(["Devi comprare : 1)pesce 2)sale."])
      end

      it 'correctly segments text #033' do
        ps = PragmaticSegmenter::Segmenter.new(text: "La macchina viaggiava a 100 km/h.", language: 'it')
        expect(ps.segment).to eq(["La macchina viaggiava a 100 km/h."])
      end
    end


  end

  describe "Russian", "(ru)" do
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

  describe "Spanish", '(es)' do
    context "Golden Rules" do
      it "Question mark to end sentence #001" do
        ps = PragmaticSegmenter::Segmenter.new(text: "¿Cómo está hoy? Espero que muy bien.", language: "es")
        expect(ps.segment).to eq(["¿Cómo está hoy?", "Espero que muy bien."])
      end

      it "Exclamation point to end sentence #002" do
        ps = PragmaticSegmenter::Segmenter.new(text: "¡Hola señorita! Espero que muy bien.", language: "es")
        expect(ps.segment).to eq(["¡Hola señorita!", "Espero que muy bien."])
      end

      it "Abbreviations #003" do
        ps = PragmaticSegmenter::Segmenter.new(text: "Hola Srta. Ledesma. Buenos días, soy el Lic. Naser Pastoriza, y él es mi padre, el Dr. Naser.", language: "es")
        expect(ps.segment).to eq(["Hola Srta. Ledesma.", "Buenos días, soy el Lic. Naser Pastoriza, y él es mi padre, el Dr. Naser."])
      end

      it "Numbers #004" do
        ps = PragmaticSegmenter::Segmenter.new(text: "¡La casa cuesta $170.500.000,00! ¡Muy costosa! Se prevé una disminución del 12.5% para el próximo año.", language: "es")
        expect(ps.segment).to eq(["¡La casa cuesta $170.500.000,00!", "¡Muy costosa!", "Se prevé una disminución del 12.5% para el próximo año."])
      end

      it "Quotations #005" do
        ps = PragmaticSegmenter::Segmenter.new(text: "«Ninguna mente extraordinaria está exenta de un toque de demencia.», dijo Aristóteles.", language: "es")
        expect(ps.segment).to eq(["«Ninguna mente extraordinaria está exenta de un toque de demencia.», dijo Aristóteles."])
      end
    end

    # Thanks to Alejandro Naser Pastoriza for the Spanish test examples.
    describe '#segment' do
      it 'correctly segments text #001' do
        ps = PragmaticSegmenter::Segmenter.new(text: '«Ninguna mente extraordinaria está exenta de un toque de demencia», dijo Aristóteles. Pablo, ¿adónde vas? ¡¿Qué viste?!', language: 'es')
        expect(ps.segment).to eq(['«Ninguna mente extraordinaria está exenta de un toque de demencia», dijo Aristóteles.', 'Pablo, ¿adónde vas?', '¡¿Qué viste?!'])
      end

      it 'correctly segments text #002' do
        ps = PragmaticSegmenter::Segmenter.new(text: 'Admón. es administración o me equivoco.', language: 'es')
        expect(ps.segment).to eq(['Admón. es administración o me equivoco.'])
      end

      it 'correctly segments text #003' do
        ps = PragmaticSegmenter::Segmenter.new(text: "• 1. Busca atención prenatal desde el principio \n• 2. Aliméntate bien \n• 3. Presta mucha atención a la higiene de los alimentos \n• 4. Toma suplementos de ácido fólico y come pescado \n• 5. Haz ejercicio regularmente \n• 6. Comienza a hacer ejercicios de Kegel \n• 7. Restringe el consumo de alcohol \n• 8. Disminuye el consumo de cafeína \n• 9. Deja de fumar \n• 10. Descansa", language: 'es')
        expect(ps.segment).to eq(["• 1. Busca atención prenatal desde el principio", "• 2. Aliméntate bien", "• 3. Presta mucha atención a la higiene de los alimentos", "• 4. Toma suplementos de ácido fólico y come pescado", "• 5. Haz ejercicio regularmente", "• 6. Comienza a hacer ejercicios de Kegel", "• 7. Restringe el consumo de alcohol", "• 8. Disminuye el consumo de cafeína", "• 9. Deja de fumar", "• 10. Descansa"])
      end

      it 'correctly segments text #004' do
        ps = PragmaticSegmenter::Segmenter.new(text: "• 1. Busca atención prenatal desde el principio \n• 2. Aliméntate bien \n• 3. Presta mucha atención a la higiene de los alimentos \n• 4. Toma suplementos de ácido fólico y come pescado \n• 5. Haz ejercicio regularmente \n• 6. Comienza a hacer ejercicios de Kegel \n• 7. Restringe el consumo de alcohol \n• 8. Disminuye el consumo de cafeína \n• 9. Deja de fumar \n• 10. Descansa \n• 11. Hola", language: 'es')
        expect(ps.segment).to eq(["• 1. Busca atención prenatal desde el principio", "• 2. Aliméntate bien", "• 3. Presta mucha atención a la higiene de los alimentos", "• 4. Toma suplementos de ácido fólico y come pescado", "• 5. Haz ejercicio regularmente", "• 6. Comienza a hacer ejercicios de Kegel", "• 7. Restringe el consumo de alcohol", "• 8. Disminuye el consumo de cafeína", "• 9. Deja de fumar", "• 10. Descansa", "• 11. Hola"])
      end

      it 'correctly segments text #005' do
        ps = PragmaticSegmenter::Segmenter.new(text: "¡Hola Srta. Ledesma! ¿Cómo está hoy? Espero que muy bien.", language: 'es')
        expect(ps.segment).to eq(["¡Hola Srta. Ledesma!",  "¿Cómo está hoy?", "Espero que muy bien."])
      end

      it 'correctly segments text #006' do
        ps = PragmaticSegmenter::Segmenter.new(text: "Buenos días, soy el Lic. Naser Pastoriza, y él es mi padre, el Dr. Naser.", language: 'es')
        expect(ps.segment).to eq(["Buenos días, soy el Lic. Naser Pastoriza, y él es mi padre, el Dr. Naser."])
      end

      it 'correctly segments text #007' do
        ps = PragmaticSegmenter::Segmenter.new(text: "He apuntado una cita para la siguiente fecha: Mar. 23 de Nov. de 2014. Gracias.", language: 'es')
        expect(ps.segment).to eq(["He apuntado una cita para la siguiente fecha: Mar. 23 de Nov. de 2014.", "Gracias."])
      end

      it 'correctly segments text #008' do
        ps = PragmaticSegmenter::Segmenter.new(text: "Núm. de tel: 351.123.465.4. Envíe mis saludos a la Sra. Rescia.", language: 'es')
        expect(ps.segment).to eq(["Núm. de tel: 351.123.465.4.", "Envíe mis saludos a la Sra. Rescia."])
      end

      it 'correctly segments text #009' do
        ps = PragmaticSegmenter::Segmenter.new(text: "Cero en la escala Celsius o de grados centígrados (0 °C) se define como el equivalente a 273.15 K, con una diferencia de temperatura de 1 °C equivalente a una diferencia de 1 Kelvin. Esto significa que 100 °C, definido como el punto de ebullición del agua, se define como el equivalente a 373.15 K.", language: 'es')
        expect(ps.segment).to eq(["Cero en la escala Celsius o de grados centígrados (0 °C) se define como el equivalente a 273.15 K, con una diferencia de temperatura de 1 °C equivalente a una diferencia de 1 Kelvin.", "Esto significa que 100 °C, definido como el punto de ebullición del agua, se define como el equivalente a 373.15 K."])
      end

      it 'correctly segments text #010' do
        ps = PragmaticSegmenter::Segmenter.new(text: "Durante la primera misión del Discovery (30 Ago. 1984 15:08.10) tuvo lugar el lanzamiento de dos satélites de comunicación, el nombre de esta misión fue STS-41-D.", language: 'es')
        expect(ps.segment).to eq(["Durante la primera misión del Discovery (30 Ago. 1984 15:08.10) tuvo lugar el lanzamiento de dos satélites de comunicación, el nombre de esta misión fue STS-41-D."])
      end

      it 'correctly segments text #011' do
        ps = PragmaticSegmenter::Segmenter.new(text: "Frase del gran José Hernández: \"Aquí me pongo a cantar / al compás de la vigüela, / que el hombre que lo desvela / una pena estrordinaria, / como la ave solitaria / con el cantar se consuela. / [...] \".", language: 'es')
        expect(ps.segment).to eq(["Frase del gran José Hernández: \"Aquí me pongo a cantar / al compás de la vigüela, / que el hombre que lo desvela / una pena estrordinaria, / como la ave solitaria / con el cantar se consuela. / [...] \"."])
      end

      it 'correctly segments text #012' do
        ps = PragmaticSegmenter::Segmenter.new(text: "Citando a Criss Jami «Prefiero ser un artista a ser un líder, irónicamente, un líder tiene que seguir las reglas.», lo cual parece muy acertado.", language: 'es')
        expect(ps.segment).to eq(["Citando a Criss Jami «Prefiero ser un artista a ser un líder, irónicamente, un líder tiene que seguir las reglas.», lo cual parece muy acertado."])
      end

      it 'correctly segments text #013' do
        ps = PragmaticSegmenter::Segmenter.new(text: "Cuando llegué, le estaba dando ejercicios a los niños, uno de los cuales era \"3 + (14/7).x = 5\". ¿Qué te parece?", language: 'es')
        expect(ps.segment).to eq(["Cuando llegué, le estaba dando ejercicios a los niños, uno de los cuales era \"3 + (14/7).x = 5\".", "¿Qué te parece?"])
      end

      it 'correctly segments text #014' do
        ps = PragmaticSegmenter::Segmenter.new(text: "Se le pidió a los niños que leyeran los párrf. 5 y 6 del art. 4 de la constitución de los EE. UU..", language: 'es')
        expect(ps.segment).to eq(["Se le pidió a los niños que leyeran los párrf. 5 y 6 del art. 4 de la constitución de los EE. UU.."])
      end

      it 'correctly segments text #015' do
        ps = PragmaticSegmenter::Segmenter.new(text: "Una de las preguntas realizadas en la evaluación del día Lun. 15 de Mar. fue la siguiente: \"Alumnos, ¿cuál es el resultado de la operación 1.1 + 4/5?\". Disponían de 1 min. para responder esa pregunta.", language: 'es')
        expect(ps.segment).to eq(["Una de las preguntas realizadas en la evaluación del día Lun. 15 de Mar. fue la siguiente: \"Alumnos, ¿cuál es el resultado de la operación 1.1 + 4/5?\".", "Disponían de 1 min. para responder esa pregunta."])
      end

      it 'correctly segments text #016' do
        ps = PragmaticSegmenter::Segmenter.new(text: "La temperatura del motor alcanzó los 120.5°C. Afortunadamente, pudo llegar al final de carrera.", language: 'es')
        expect(ps.segment).to eq(["La temperatura del motor alcanzó los 120.5°C.", "Afortunadamente, pudo llegar al final de carrera."])
      end

      it 'correctly segments text #017' do
        ps = PragmaticSegmenter::Segmenter.new(text: "El volumen del cuerpo es 3m³. ¿Cuál es la superficie de cada cara del prisma?", language: 'es')
        expect(ps.segment).to eq(["El volumen del cuerpo es 3m³.", "¿Cuál es la superficie de cada cara del prisma?"])
      end

      it 'correctly segments text #018' do
        ps = PragmaticSegmenter::Segmenter.new(text: "La habitación tiene 20.55m². El living tiene 50.0m².", language: 'es')
        expect(ps.segment).to eq(["La habitación tiene 20.55m².", "El living tiene 50.0m²."])
      end

      it 'correctly segments text #019' do
        ps = PragmaticSegmenter::Segmenter.new(text: "1°C corresponde a 33.8°F. ¿A cuánto corresponde 35°C?", language: 'es')
        expect(ps.segment).to eq(["1°C corresponde a 33.8°F.", "¿A cuánto corresponde 35°C?"])
      end

      it 'correctly segments text #020' do
        ps = PragmaticSegmenter::Segmenter.new(text: "Hamilton ganó el último gran premio de Fórmula 1, luego de 1:39:02.619 Hs. de carrera, segundo resultó Massa, a una diferencia de 2.5 segundos. De esta manera se consagró ¡Campeón mundial!", language: 'es')
        expect(ps.segment).to eq(["Hamilton ganó el último gran premio de Fórmula 1, luego de 1:39:02.619 Hs. de carrera, segundo resultó Massa, a una diferencia de 2.5 segundos.", "De esta manera se consagró ¡Campeón mundial!"])
      end

      it 'correctly segments text #021' do
        ps = PragmaticSegmenter::Segmenter.new(text: "¡La casa cuesta $170.500.000,00! ¡Muy costosa! Se prevé una disminución del 12.5% para el próximo año.", language: 'es')
        expect(ps.segment).to eq(["¡La casa cuesta $170.500.000,00!", "¡Muy costosa!", "Se prevé una disminución del 12.5% para el próximo año."])
      end

      it 'correctly segments text #022' do
        ps = PragmaticSegmenter::Segmenter.new(text: "El corredor No. 103 arrivó 4°.", language: 'es')
        expect(ps.segment).to eq(["El corredor No. 103 arrivó 4°."])
      end

      it 'correctly segments text #023' do
        ps = PragmaticSegmenter::Segmenter.new(text: "Hoy es 27/04/2014, y es mi cumpleaños. ¿Cuándo es el tuyo?", language: 'es')
        expect(ps.segment).to eq(["Hoy es 27/04/2014, y es mi cumpleaños.", "¿Cuándo es el tuyo?"])
      end

      it 'correctly segments text #024' do
        ps = PragmaticSegmenter::Segmenter.new(text: "Aquí está la lista de compras para el almuerzo: 1.Helado, 2.Carne, 3.Arroz. ¿Cuánto costará? Quizás $12.5.", language: 'es')
        expect(ps.segment).to eq(["Aquí está la lista de compras para el almuerzo: 1.Helado, 2.Carne, 3.Arroz.", "¿Cuánto costará?", "Quizás $12.5."])
      end

      it 'correctly segments text #025' do
        ps = PragmaticSegmenter::Segmenter.new(text: "1 + 1 es 2. 2 + 2 es 4. El auto es de color rojo.", language: 'es')
        expect(ps.segment).to eq(["1 + 1 es 2.", "2 + 2 es 4.", "El auto es de color rojo."])
      end

      it 'correctly segments text #026' do
        ps = PragmaticSegmenter::Segmenter.new(text: "La máquina viajaba a 100 km/h. ¿En cuánto tiempo recorrió los 153 Km.?", language: 'es')
        expect(ps.segment).to eq(["La máquina viajaba a 100 km/h.", "¿En cuánto tiempo recorrió los 153 Km.?"])
      end

      it 'correctly segments text #027' do
        ps = PragmaticSegmenter::Segmenter.new(text: "\n \nCentro de Relaciones Interinstitucionales -CERI \n\nCra. 7 No. 40-53 Piso 10 Tel.  (57-1) 3239300 Ext. 1010 Fax: (57-1) 3402973 Bogotá, D.C. - Colombia \n\nhttp://www.udistrital.edu.co - http://ceri.udistrital.edu.co - relinter@udistrital.edu.co \n\n \n\nCERI 0908 \n \nBogotá, D.C. 6 de noviembre de 2014.  \n \nSeñores: \nEMBAJADA DE UNITED KINGDOM \n \n", language: 'es')
        expect(ps.segment).to eq(["Centro de Relaciones Interinstitucionales -CERI", "Cra. 7 No. 40-53 Piso 10 Tel.  (57-1) 3239300 Ext. 1010 Fax: (57-1) 3402973 Bogotá, D.C. - Colombia", "http://www.udistrital.edu.co - http://ceri.udistrital.edu.co - relinter@udistrital.edu.co", "CERI 0908", "Bogotá, D.C. 6 de noviembre de 2014.", "Señores:", "EMBAJADA DE UNITED KINGDOM"])
      end

      it 'correctly segments text #028' do
        ps = PragmaticSegmenter::Segmenter.new(text: "N°. 1026.253.553", language: 'es')
        expect(ps.segment).to eq(["N°. 1026.253.553"])
      end

      it 'correctly segments text #029' do
        ps = PragmaticSegmenter::Segmenter.new(text: "\nA continuación me permito presentar a la Ingeniera LAURA MILENA LEÓN \nSANDOVAL, identificada con el documento N°. 1026.253.553 de Bogotá, \negresada del Programa Ingeniería Industrial en el año 2012, quien se desatacó por \nsu excelencia académica, actualmente cursa el programa de Maestría en \nIngeniería Industrial y se encuentra en un intercambio cultural en Bangalore – \nIndia.", language: 'es', doc_type: 'pdf')
        expect(ps.segment).to eq(["A continuación me permito presentar a la Ingeniera LAURA MILENA LEÓN SANDOVAL, identificada con el documento N°. 1026.253.553 de Bogotá, egresada del Programa Ingeniería Industrial en el año 2012, quien se desatacó por su excelencia académica, actualmente cursa el programa de Maestría en Ingeniería Industrial y se encuentra en un intercambio cultural en Bangalore – India."])
      end

      it 'correctly segments text #030' do
        ps = PragmaticSegmenter::Segmenter.new(text: "\n__________________________________________________________\nEl Board para Servicios Educativos de Putnam/Northern Westchester según el título IX, Sección 504 del “Rehabilitation Act” del 1973, del Título VII y del Acta “American with Disabilities” no discrimina para la admisión a programas educativos por sexo, creencia, nacionalidad, origen, edad o discapacidad.", language: 'es')
        expect(ps.segment).to eq(["El Board para Servicios Educativos de Putnam/Northern Westchester según el título IX, Sección 504 del “Rehabilitation Act” del 1973, del Título VII y del Acta “American with Disabilities” no discrimina para la admisión a programas educativos por sexo, creencia, nacionalidad, origen, edad o discapacidad."])
      end

      it 'correctly segments text #031' do
        ps = PragmaticSegmenter::Segmenter.new(text: "Explora oportunidades de carrera en el área de Salud en el Hospital de Northern en Mt. Kisco.", language: 'es')
        expect(ps.segment).to eq(["Explora oportunidades de carrera en el área de Salud en el Hospital de Northern en Mt. Kisco."])
      end
    end
  end

  describe "Greek", '(el)' do
    context "Golden Rules" do
      it "Question mark to end sentence #001" do
        ps = PragmaticSegmenter::Segmenter.new(text: "Με συγχωρείτε· πού είναι οι τουαλέτες; Τις Κυριακές δε δούλευε κανένας. το κόστος του σπιτιού ήταν £260.950,00.", language: "el")
        expect(ps.segment).to eq(["Με συγχωρείτε· πού είναι οι τουαλέτες;", "Τις Κυριακές δε δούλευε κανένας.", "το κόστος του σπιτιού ήταν £260.950,00."])
      end
    end

    describe '#segment' do
      it 'correctly segments text #001' do
        ps = PragmaticSegmenter::Segmenter.new(text: "Με συγχωρείτε· πού είναι οι τουαλέτες; Τις Κυριακές δε δούλευε κανένας. το κόστος του σπιτιού ήταν £260.950,00.", language: 'el')
        expect(ps.segment).to eq(["Με συγχωρείτε· πού είναι οι τουαλέτες;", "Τις Κυριακές δε δούλευε κανένας.", "το κόστος του σπιτιού ήταν £260.950,00."])
      end
    end
  end

  describe 'Hindi', '(hi)' do
    context "Golden Rules" do
      it "Full stop #001" do
        ps = PragmaticSegmenter::Segmenter.new(text: "सच्चाई यह है कि इसे कोई नहीं जानता। हो सकता है यह फ़्रेन्को के खिलाफ़ कोई विद्रोह रहा हो, या फिर बेकाबू हो गया कोई आनंदोत्सव।", language: "hi")
        expect(ps.segment).to eq(["सच्चाई यह है कि इसे कोई नहीं जानता।", "हो सकता है यह फ़्रेन्को के खिलाफ़ कोई विद्रोह रहा हो, या फिर बेकाबू हो गया कोई आनंदोत्सव।"])
      end
    end

    describe '#segment' do
      it 'correctly segments text #001' do
        ps = PragmaticSegmenter::Segmenter.new(text: "सच्चाई यह है कि इसे कोई नहीं जानता। हो सकता है यह फ़्रेन्को के खिलाफ़ कोई विद्रोह रहा हो, या फिर बेकाबू हो गया कोई आनंदोत्सव।", language: 'hi')
        expect(ps.segment).to eq(["सच्चाई यह है कि इसे कोई नहीं जानता।", "हो सकता है यह फ़्रेन्को के खिलाफ़ कोई विद्रोह रहा हो, या फिर बेकाबू हो गया कोई आनंदोत्सव।"])
      end
    end
  end

  describe 'Armenian', '(hy)' do
    context "Golden Rules" do
      it "Sentence ending punctuation #001" do
        ps = PragmaticSegmenter::Segmenter.new(text: "Ի՞նչ ես մտածում: Ոչինչ:", language: "hy")
        expect(ps.segment).to eq(["Ի՞նչ ես մտածում:", "Ոչինչ:"])
      end

      it "Ellipsis #002" do
        ps = PragmaticSegmenter::Segmenter.new(text: "Ապրիլի 24-ին սկսեց անձրևել...Այդպես էի գիտեի:", language: "hy")
        expect(ps.segment).to eq(["Ապրիլի 24-ին սկսեց անձրևել...Այդպես էի գիտեի:"])
      end

      it "Period is not a sentence boundary #003" do
        ps = PragmaticSegmenter::Segmenter.new(text: "Այսպիսով` մոտենում ենք ավարտին: Տրամաբանությյունը հետևյալն է. պարզություն և աշխատանք:", language: "hy")
        expect(ps.segment).to eq(["Այսպիսով` մոտենում ենք ավարտին:", "Տրամաբանությյունը հետևյալն է. պարզություն և աշխատանք:"])
      end
    end

    describe '#segment' do
      # Thanks to Armine Abelyan for the Armenian test examples.

      it 'correctly segments text #001' do
        ps = PragmaticSegmenter::Segmenter.new(text: "Սա այն փուլն է, երբ տեղի է ունենում Համակարգի մշակումը: Համաձայն Փուլ 2-ի, Մատակարարը մշակում և/կամ հարմարեցնում է համապատասխան ծրագիրը, տեղադրում ծրագրի բաղկացուցիչները, կատարում առանձին բլոկի և համակարգի թեստավորում և ներառում տարբեր մոդուլներ եզակի աշխատանքային համակարգում, որը  կազմում է այս Փուլի արդյունքը:", language: 'hy')
        expect(ps.segment).to eq(["Սա այն փուլն է, երբ տեղի է ունենում Համակարգի մշակումը:", "Համաձայն Փուլ 2-ի, Մատակարարը մշակում և/կամ հարմարեցնում է համապատասխան ծրագիրը, տեղադրում ծրագրի բաղկացուցիչները, կատարում առանձին բլոկի և համակարգի թեստավորում և ներառում տարբեր մոդուլներ եզակի աշխատանքային համակարգում, որը  կազմում է այս Փուլի արդյունքը:"])
      end

      it 'correctly segments text #002' do
        ps = PragmaticSegmenter::Segmenter.new(text: "Մատակարարի նախագծի անձնակազմի կողմից համակարգի թեստերը հաջող անցնելուց հետո, Համակարգը տրվում է Գնորդին թեստավորման համար: 2-րդ փուլում, հիմք ընդունելով թեստային սցենարիոները, թեստերը կատարվում են Կառավարության կողմից Մատակարարի աջակցությամբ: Այս թեստերի թիրախը հանդիսանում է  Համակարգի` որպես մեկ ամբողջության և համակարգի գործունեության ստուգումը համաձայն տեխնիկական բնութագրերի: Այս թեստերի հաջողակ ավարտից հետո, Համակարգը ժամանակավոր ընդունվում է  Կառավարության կողմից: Այս թեստերի արդյունքները փաստաթղթային ձևով կներակայացվեն Թեստային Արդյունքների Հաշվետվություններում: Մատակարարը պետք է տրամադրի հետևյալը`", language: 'hy')
        expect(ps.segment).to eq(["Մատակարարի նախագծի անձնակազմի կողմից համակարգի թեստերը հաջող անցնելուց հետո, Համակարգը տրվում է Գնորդին թեստավորման համար:", "2-րդ փուլում, հիմք ընդունելով թեստային սցենարիոները, թեստերը կատարվում են Կառավարության կողմից Մատակարարի աջակցությամբ:", "Այս թեստերի թիրախը հանդիսանում է  Համակարգի` որպես մեկ ամբողջության և համակարգի գործունեության ստուգումը համաձայն տեխնիկական բնութագրերի:", "Այս թեստերի հաջողակ ավարտից հետո, Համակարգը ժամանակավոր ընդունվում է  Կառավարության կողմից:", "Այս թեստերի արդյունքները փաստաթղթային ձևով կներակայացվեն Թեստային Արդյունքների Հաշվետվություններում:", "Մատակարարը պետք է տրամադրի հետևյալը`"])
      end

      it 'correctly segments text #003' do
        ps = PragmaticSegmenter::Segmenter.new(text: "Մատակարարի նախագծի անձնակազմի կողմից համակարգի թեստերը հաջող անցնելուց հետո, Համակարգը տրվում է Գնորդին թեստավորման համար: 2-րդ փուլում, հիմք ընդունելով թեստային սցենարիոները, թեստերը կատարվում են Կառավարության կողմից Մատակարարի աջակցությամբ: Այս թեստերի թիրախը հանդիսանում է  Համակարգի` որպես մեկ ամբողջության և համակարգի գործունեության ստուգումը համաձայն տեխնիկական բնութագրերի: Այս թեստերի հաջողակ ավարտից հետո, Համակարգը ժամանակավոր ընդունվում է  Կառավարության կողմից: Այս թեստերի արդյունքները փաստաթղթային ձևով կներակայացվեն Թեստային Արդյունքների Հաշվետվություններում: Մատակարարը պետք է տրամադրի հետևյալը`", language: 'hy')
        expect(ps.segment).to eq(["Մատակարարի նախագծի անձնակազմի կողմից համակարգի թեստերը հաջող անցնելուց հետո, Համակարգը տրվում է Գնորդին թեստավորման համար:", "2-րդ փուլում, հիմք ընդունելով թեստային սցենարիոները, թեստերը կատարվում են Կառավարության կողմից Մատակարարի աջակցությամբ:", "Այս թեստերի թիրախը հանդիսանում է  Համակարգի` որպես մեկ ամբողջության և համակարգի գործունեության ստուգումը համաձայն տեխնիկական բնութագրերի:", "Այս թեստերի հաջողակ ավարտից հետո, Համակարգը ժամանակավոր ընդունվում է  Կառավարության կողմից:", "Այս թեստերի արդյունքները փաստաթղթային ձևով կներակայացվեն Թեստային Արդյունքների Հաշվետվություններում:", "Մատակարարը պետք է տրամադրի հետևյալը`"])
      end

      it 'correctly segments text #004' do
        # "Hello world. My name is Armine." ==> ["Hello world.", "My name is Armine."]
        ps = PragmaticSegmenter::Segmenter.new(text: "Բարև Ձեզ: Իմ անունն էԱրմինե:", language: 'hy')
        expect(ps.segment).to eq(["Բարև Ձեզ:", "Իմ անունն էԱրմինե:"])
      end

      it 'correctly segments text #005' do
        # "Today is Monday. I am going to work." ==> ["Today is Monday.", "I am going to work."]
        ps = PragmaticSegmenter::Segmenter.new(text: "Այսօր երկուշաբթի է: Ես գնում եմ աշխատանքի:", language: 'hy')
        expect(ps.segment).to eq(["Այսօր երկուշաբթի է:", "Ես գնում եմ աշխատանքի:"])
      end

      it 'correctly segments text #006' do
        #  "Tomorrow is September 1st. We are going to school." ==> ["Tomorrow is September 1st.", "We are going to school."]
        ps = PragmaticSegmenter::Segmenter.new(text: "Վաղը սեպտեմբերի 1-ն է: Մենք գնում ենք դպրոց:", language: 'hy')
        expect(ps.segment).to eq(["Վաղը սեպտեմբերի 1-ն է:", "Մենք գնում ենք դպրոց:"])
      end

      it 'correctly segments text #007' do
        #  "Yes, I understood. I really love you." ==> ["Yes, I understood.", "I really love you."]
        ps = PragmaticSegmenter::Segmenter.new(text: "Այո, ես հասկացա: Ես իսկապես քեզ սիրում եմ:", language: 'hy')
        expect(ps.segment).to eq(["Այո, ես հասկացա:", "Ես իսկապես քեզ սիրում եմ:"])
      end

      it 'correctly segments text #008' do
        #  "Close the windows. It is raining in the evening." ==> ["Close the windows.", "It is raining in the evening."]
        ps = PragmaticSegmenter::Segmenter.new(text: "Փակիր պատուհանները: Երեկոյան անձրևում է:", language: 'hy')
        expect(ps.segment).to eq(["Փակիր պատուհանները:", "Երեկոյան անձրևում է:"])
      end

      it 'correctly segments text #009' do
        #  "It is dark. I should go home." ==> ["It is dark.", "I should go home."]
        ps = PragmaticSegmenter::Segmenter.new(text: "Մութ է: Ես պետք է տուն վերադառնամ:", language: 'hy')
        expect(ps.segment).to eq(["Մութ է:", "Ես պետք է տուն վերադառնամ:"])
      end

      it 'correctly segments text #010' do
        #  "You know, I am starting to believe. Everything is changing." ==> ["You know, I am starting to believe.", "Everything is changing."]
        ps = PragmaticSegmenter::Segmenter.new(text: "Գիտես, սկսել եմ հավատալ: Ամեն ինչ փոխվում է:", language: 'hy')
        expect(ps.segment).to eq(["Գիտես, սկսել եմ հավատալ:", "Ամեն ինչ փոխվում է:"])
      end

      it 'correctly segments text #011' do
        #  "It is a new Christmas tree. We should decorate it." ==> ["It is a new Christmas tree.", "We should decorate it."]
        ps = PragmaticSegmenter::Segmenter.new(text: "Տոնածառը նոր է: Պետք է այն զարդարել:", language: 'hy')
        expect(ps.segment).to eq(["Տոնածառը նոր է:", "Պետք է այն զարդարել:"])
      end

      it 'correctly segments text #012' do
        #  "I am in hurry. I could not wait you." ==> ["I am in hurry.", "I could not wait you."]
        ps = PragmaticSegmenter::Segmenter.new(text: "Ես շտապում եմ: Ես քեզ չեմ կարող սպասել:", language: 'hy')
        expect(ps.segment).to eq(["Ես շտապում եմ:", "Ես քեզ չեմ կարող սպասել:"])
      end

      it 'correctly segments text #013' do
        #  "Wait, we love each other. I want us to live together." ==> ["Wait, we love each other.", "I want us to live together."]
        ps = PragmaticSegmenter::Segmenter.new(text: "Սպասիր, մենք իրար սիրում ենք: Ցանկանում եմ միասին ապրենք:", language: 'hy')
        expect(ps.segment).to eq(["Սպասիր, մենք իրար սիրում ենք:", "Ցանկանում եմ միասին ապրենք:"])
      end

      it 'correctly segments text #014' do
        #  "No, I do not think so. It is not true." ==> ["No, I do not think so.", "It is not true."]
        ps = PragmaticSegmenter::Segmenter.new(text: "Ոչ, այդպես չեմ կարծում: Դա ճիշտ չէ:", language: 'hy')
        expect(ps.segment).to eq(["Ոչ, այդպես չեմ կարծում:", "Դա ճիշտ չէ:"])
      end

      it 'correctly segments text #015' do
        #  "April 24 it has started to rain... I was thinking about." ==> ["April 24 it has started to rain... I was thinking about."]
        ps = PragmaticSegmenter::Segmenter.new(text: "Ապրիլի 24-ին սկսեց անձրևել...Այդպես էի գիտեի:", language: 'hy')
        expect(ps.segment).to eq(["Ապրիլի 24-ին սկսեց անձրևել...Այդպես էի գիտեի:"])
      end

      it 'correctly segments text #016' do
        #  "It was 1960...it was winter...it was night. It was cold...emptiness." ==> ["It was 1960...it was winter...it was night.", "It was cold...emptiness."]
        ps = PragmaticSegmenter::Segmenter.new(text: "1960 թվական…ձմեռ…գիշեր: Սառն էր…դատարկություն:", language: 'hy')
        expect(ps.segment).to eq(["1960 թվական…ձմեռ…գիշեր:", "Սառն էր…դատարկություն:"])
      end

      it 'correctly segments text #017' do
        #  "Why a computer could not do what a man could do? Simply it doesn't have a human brain." ==> ["Why a computer could not do what a man could do?", "Simply it doesn't have a human brain."]
        ps = PragmaticSegmenter::Segmenter.new(text: "Ինչ՟ու այն, ինչ անում է մարդը, չի կարող անել համակարգիչը: Պարզապես չունի մարդկային ուղեղ:", language: 'hy')
        expect(ps.segment).to eq(["Ինչ՟ու այն, ինչ անում է մարդը, չի կարող անել համակարգիչը:", "Պարզապես չունի մարդկային ուղեղ:"])
      end

      it 'correctly segments text #018' do
        #  "Numerate for me 3 things that are important for you - I answer love, knowledge, sincerity." ==> ["Numerate for me 3 things that are important for you - I answer love, knowledge, sincerity."]
        ps = PragmaticSegmenter::Segmenter.new(text: "Թվարկիր ինձ համար 3 բան, որ կարևոր է քեզ համար - Պատասխանում եմ. սեր, գիտելիք, ազնվություն:", language: 'hy')
        expect(ps.segment).to eq(["Թվարկիր ինձ համար 3 բան, որ կարևոր է քեզ համար - Պատասխանում եմ. սեր, գիտելիք, ազնվություն:"])
      end

      it 'correctly segments text #019' do
        #  "So, we are coming to the end. The logic is...simplicity and work" ==> ["So, we are coming to the end.", "Simplicity and work."]
        ps = PragmaticSegmenter::Segmenter.new(text: "Այսպիսով` մոտենում ենք ավարտին: Տրամաբանությյունը հետևյալն է. պարզություն և աշխատանք:", language: 'hy')
        expect(ps.segment).to eq(["Այսպիսով` մոտենում ենք ավարտին:", "Տրամաբանությյունը հետևյալն է. պարզություն և աշխատանք:"])
      end

      it 'correctly segments text #020' do
        #  "What are you thinking? Nothing!" ==> ["What are you thinking?", "Nothing!"]
        ps = PragmaticSegmenter::Segmenter.new(text: "Ի՞նչ ես մտածում: Ոչինչ:", language: 'hy')
        expect(ps.segment).to eq(["Ի՞նչ ես մտածում:", "Ոչինչ:"])
      end

      it 'correctly segments text #021' do
        #  "Can we work together ?. May be what you are thinking, is possible." ==> ["Can we work together?.", "May be what you are thinking is possible."]
        ps = PragmaticSegmenter::Segmenter.new(text: "Կարող ե՞նք միասին աշխատել: Գուցե այն ինչ մտածում ես, իրականանալի է:", language: 'hy')
        expect(ps.segment).to eq(["Կարող ե՞նք միասին աշխատել:", "Գուցե այն ինչ մտածում ես, իրականանալի է:"])
      end

      it 'correctly segments text #022' do
        #  "Now what we have started, comes to the end. However the questions are numerous... ." ==> ["Now what we have started, comes to the end.", "However the questions are numerous... ."]
        ps = PragmaticSegmenter::Segmenter.new(text: "Հիմա, այն ինչ սկսել ենք, ավարտին է մոտենում: Հարցերը սակայն շատ են...:", language: 'hy')
        expect(ps.segment).to eq(["Հիմա, այն ինչ սկսել ենք, ավարտին է մոտենում:", "Հարցերը սակայն շատ են...:"])
      end

      it 'correctly segments text #023' do
        #  "Honey... I am waiting. Shall I go... or?" ==> ["Honey... I am waiting.", "Shall I go... or?"]
        ps = PragmaticSegmenter::Segmenter.new(text: "Սիրելիս...սպասում եմ: Գնամ թ՟ե …:", language: 'hy')
        expect(ps.segment).to eq(["Սիրելիս...սպասում եմ:", "Գնամ թ՟ե …:"])
      end
    end
  end

  describe "Burmese", '(my)' do
    context "Golden Rules" do
      it "Sentence ending punctuation #001" do
        ps = PragmaticSegmenter::Segmenter.new(text: "ခင္ဗ်ားနာမည္ဘယ္လိုေခၚလဲ။၇ွင္ေနေကာင္းလား။", language: 'my')
        expect(ps.segment).to eq(["ခင္ဗ်ားနာမည္ဘယ္လိုေခၚလဲ။", "၇ွင္ေနေကာင္းလား။"])
      end
    end

    describe '#segment' do
      it 'correctly segments text #001' do
        ps = PragmaticSegmenter::Segmenter.new(text: "ခင္ဗ်ားနာမည္ဘယ္လိုေခၚလဲ။၇ွင္ေနေကာင္းလား။", language: 'my')
        expect(ps.segment).to eq(["ခင္ဗ်ားနာမည္ဘယ္လိုေခၚလဲ။", "၇ွင္ေနေကာင္းလား။"])
      end
    end
  end

  describe "Amharic", '(am)' do
    context "Golden Rules" do
      it "Sentence ending punctuation #001" do
        ps = PragmaticSegmenter::Segmenter.new(text: "እንደምን አለህ፧መልካም ቀን ይሁንልህ።እባክሽ ያልሽዉን ድገሚልኝ።", language: 'am')
        expect(ps.segment).to eq(["እንደምን አለህ፧", "መልካም ቀን ይሁንልህ።", "እባክሽ ያልሽዉን ድገሚልኝ።"])
      end
    end

    describe '#segment' do
      it 'correctly segments text #001' do
        ps = PragmaticSegmenter::Segmenter.new(text: "እንደምን አለህ፧መልካም ቀን ይሁንልህ።እባክሽ ያልሽዉን ድገሚልኝ።", language: 'am')
        expect(ps.segment).to eq(["እንደምን አለህ፧", "መልካም ቀን ይሁንልህ።", "እባክሽ ያልሽዉን ድገሚልኝ።"])
      end
    end
  end

  describe "Persian", '(fa)' do
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

  describe "Urdu", '(ur)' do
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

  describe "Dutch", '(nl)' do
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


  describe 'French', '(fr)' do
    describe '#segment' do
      it 'correctly segments text #001' do
        ps = PragmaticSegmenter::Segmenter.new(text: "Après avoir été l'un des acteurs du projet génome humain, le Genoscope met aujourd'hui le cap vers la génomique environnementale. L'exploitation des données de séquences, prolongée par l'identification expérimentale des fonctions biologiques, notamment dans le domaine de la biocatalyse, ouvrent des perspectives de développements en biotechnologie industrielle.", language: 'fr')
        expect(ps.segment).to eq(["Après avoir été l'un des acteurs du projet génome humain, le Genoscope met aujourd'hui le cap vers la génomique environnementale.", "L'exploitation des données de séquences, prolongée par l'identification expérimentale des fonctions biologiques, notamment dans le domaine de la biocatalyse, ouvrent des perspectives de développements en biotechnologie industrielle."])
      end

      it 'correctly segments text #002' do
        ps = PragmaticSegmenter::Segmenter.new(text: "\"Airbus livrera comme prévu 30 appareils 380 cette année avec en ligne de mire l'objectif d'équilibre financier du programme en 2015\", a-t-il ajouté.", language: 'fr')
        expect(ps.segment).to eq(["\"Airbus livrera comme prévu 30 appareils 380 cette année avec en ligne de mire l'objectif d'équilibre financier du programme en 2015\", a-t-il ajouté."])
      end

      it 'correctly segments text #003' do
        ps = PragmaticSegmenter::Segmenter.new(text: "À 11 heures ce matin, la direction ne décomptait que douze grévistes en tout sur la France : ce sont ceux du site de Saran (Loiret), dont l’effectif est de 809 salariés, dont la moitié d’intérimaires. Elle assure que ce mouvement « n’aura aucun impact sur les livraisons ».", language: 'fr')
        expect(ps.segment).to eq(["À 11 heures ce matin, la direction ne décomptait que douze grévistes en tout sur la France : ce sont ceux du site de Saran (Loiret), dont l’effectif est de 809 salariés, dont la moitié d’intérimaires.", "Elle assure que ce mouvement « n’aura aucun impact sur les livraisons »."])
      end

      it 'correctly segments text #004' do
        ps = PragmaticSegmenter::Segmenter.new(text: "Ce modèle permet d’afficher le texte « LL.AA.II.RR. » pour l’abréviation de « Leurs Altesses impériales et royales » avec son infobulle.", language: 'fr')
        expect(ps.segment).to eq(["Ce modèle permet d’afficher le texte « LL.AA.II.RR. » pour l’abréviation de « Leurs Altesses impériales et royales » avec son infobulle."])
      end

      it 'correctly segments text #005' do
        ps = PragmaticSegmenter::Segmenter.new(text: "Les derniers ouvrages de Intercept Ltd. sont ici.", language: 'fr')
        expect(ps.segment).to eq(["Les derniers ouvrages de Intercept Ltd. sont ici."])
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
