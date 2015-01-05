require 'spec_helper'

RSpec.describe PragmaticSegmenter::Segmenter do
  context "Golden Rules (English)" do
    it "Simple period to end sentence #001" do
      ps = PragmaticSegmenter::Segmenter.new(text: "Hello World. My name is Jonas.", language: "en")
      expect(ps.segment).to eq(["Hello World.", "My name is Jonas."])
    end

    it "Question mark to end sentence #002" do
      ps = PragmaticSegmenter::Segmenter.new(text: "What is your name? My name is Jonas.", language: "en")
      expect(ps.segment).to eq(["What is your name?", "My name is Jonas."])
    end

    it "Exclamation point to end sentence #003" do
      ps = PragmaticSegmenter::Segmenter.new(text: "There it is! I found it.", language: "en")
      expect(ps.segment).to eq(["There it is!", "I found it."])
    end

    it "One letter upper case abbreviations #004" do
      ps = PragmaticSegmenter::Segmenter.new(text: "My name is Jonas E. Smith.", language: "en")
      expect(ps.segment).to eq(["My name is Jonas E. Smith."])
    end

    it "One letter lower case abbreviations #005" do
      ps = PragmaticSegmenter::Segmenter.new(text: "Please turn to p. 55.", language: "en")
      expect(ps.segment).to eq(["Please turn to p. 55."])
    end

    it "Two letter lower case abbreviations in the middle of a sentence #006" do
      ps = PragmaticSegmenter::Segmenter.new(text: "Were Jane and co. at the party?", language: "en")
      expect(ps.segment).to eq(["Were Jane and co. at the party?"])
    end

    it "Two letter upper case abbreviations in the middle of a sentence #007" do
      ps = PragmaticSegmenter::Segmenter.new(text: "They closed the deal with Pitt, Briggs & Co. at noon.", language: "en")
      expect(ps.segment).to eq(["They closed the deal with Pitt, Briggs & Co. at noon."])
    end

    it "Two letter lower case abbreviations at the end of a sentence #008" do
      ps = PragmaticSegmenter::Segmenter.new(text: "Let's ask Jane and co. They should know.", language: "en")
      expect(ps.segment).to eq(["Let's ask Jane and co.", "They should know."])
    end

    it "Two letter upper case abbreviations at the end of a sentence #009" do
      ps = PragmaticSegmenter::Segmenter.new(text: "They closed the deal with Pitt, Briggs & Co. It closed yesterday.", language: "en")
      expect(ps.segment).to eq(["They closed the deal with Pitt, Briggs & Co.", "It closed yesterday."])
    end

    it "Two letter (prepositive) abbreviations #010" do
      ps = PragmaticSegmenter::Segmenter.new(text: "I can see Mt. Fuji from here.", language: "en")
      expect(ps.segment).to eq(["I can see Mt. Fuji from here."])
    end

    it "Two letter (prepositive & postpositive) abbreviations #011" do
      ps = PragmaticSegmenter::Segmenter.new(text: "St. Michael's Church is on 5th st. near the light.", language: "en")
      expect(ps.segment).to eq(["St. Michael's Church is on 5th st. near the light."])
    end

    it "Possesive two letter abbreviations #012" do
      ps = PragmaticSegmenter::Segmenter.new(text: "That is JFK Jr.'s book.", language: "en")
      expect(ps.segment).to eq(["That is JFK Jr.'s book."])
    end

    it "Multi-period abbreviations in the middle of a sentence #013" do
      ps = PragmaticSegmenter::Segmenter.new(text: "I visited the U.S.A. last year.", language: "en")
      expect(ps.segment).to eq(["I visited the U.S.A. last year."])
    end

    it "Multi-period abbreviations at the end of a sentence #014" do
      ps = PragmaticSegmenter::Segmenter.new(text: "I live in the E.U. How about you?", language: "en")
      expect(ps.segment).to eq(["I live in the E.U.", "How about you?"])
    end

    it "U.S. as sentence boundary #015" do
      ps = PragmaticSegmenter::Segmenter.new(text: "I live in the U.S. How about you?", language: "en")
      expect(ps.segment).to eq(["I live in the U.S.", "How about you?"])
    end

    it "U.S. as non sentence boundary with next word capitalized #016" do
      ps = PragmaticSegmenter::Segmenter.new(text: "I work for the U.S. Government in Virginia.", language: "en")
      expect(ps.segment).to eq(["I work for the U.S. Government in Virginia."])
    end

    it "U.S. as non sentence boundary #017" do
      ps = PragmaticSegmenter::Segmenter.new(text: "I have lived in the U.S. for 20 years.", language: "en")
      expect(ps.segment).to eq(["I have lived in the U.S. for 20 years."])
    end

    xdescribe "not yet implemented" do
      it "A.M. / P.M. as non sentence boundary and sentence boundary #018" do
        ps = PragmaticSegmenter::Segmenter.new(text: "At 5 a.m. Mr. Smith went to the bank. He left the bank at 6 P.M. Mr. Smith then went to the store.", language: "en")
        expect(ps.segment).to eq(["At 5 a.m. Mr. Smith went to the bank.", "He left the bank at 6 P.M.", "Mr. Smith then went to the store."])
      end
    end

    it "Number as non sentence boundary #019" do
      ps = PragmaticSegmenter::Segmenter.new(text: "She has $100.00 in her bag.", language: "en")
      expect(ps.segment).to eq(["She has $100.00 in her bag."])
    end

    it "Number as sentence boundary #020" do
      ps = PragmaticSegmenter::Segmenter.new(text: "She has $100.00. It is in her bag.", language: "en")
      expect(ps.segment).to eq(["She has $100.00.", "It is in her bag."])
    end

    it "Parenthetical inside sentence #021" do
      ps = PragmaticSegmenter::Segmenter.new(text: "He teaches science (He previously worked for 5 years as an engineer.) at the local University.", language: "en")
      expect(ps.segment).to eq(["He teaches science (He previously worked for 5 years as an engineer.) at the local University."])
    end

    it "Email addresses #022" do
      ps = PragmaticSegmenter::Segmenter.new(text: "Her email is Jane.Doe@example.com. I sent her an email.", language: "en")
      expect(ps.segment).to eq(["Her email is Jane.Doe@example.com.", "I sent her an email."])
    end

    it "Web addresses #023" do
      ps = PragmaticSegmenter::Segmenter.new(text: "The site is: https://www.example.50.com/new-site/awesome_content.html. Please check it out.", language: "en")
      expect(ps.segment).to eq(["The site is: https://www.example.50.com/new-site/awesome_content.html.", "Please check it out."])
    end

    it "Single quotations inside sentence #024" do
      ps = PragmaticSegmenter::Segmenter.new(text: "She turned to him, 'This is great.' she said.", language: "en")
      expect(ps.segment).to eq(["She turned to him, 'This is great.' she said."])
    end

    it "Double quotations inside sentence #025" do
      ps = PragmaticSegmenter::Segmenter.new(text: "She turned to him, \"This is great.\" she said.", language: "en")
      expect(ps.segment).to eq(["She turned to him, \"This is great.\" she said."])
    end

    it "Double quotations at the end of a sentence #026" do
      ps = PragmaticSegmenter::Segmenter.new(text: "She turned to him, \"This is great.\" She held the book out to show him.", language: "en")
      expect(ps.segment).to eq(["She turned to him, \"This is great.\"", "She held the book out to show him."])
    end

    it "Double punctuation (exclamation point) #027" do
      ps = PragmaticSegmenter::Segmenter.new(text: "Hello!! Long time no see.", language: "en")
      expect(ps.segment).to eq(["Hello!!", "Long time no see."])
    end

    it "Double punctuation (question mark) #028" do
      ps = PragmaticSegmenter::Segmenter.new(text: "Hello?? Who is there?", language: "en")
      expect(ps.segment).to eq(["Hello??", "Who is there?"])
    end

    it "Double punctuation (exclamation point / question mark) #029" do
      ps = PragmaticSegmenter::Segmenter.new(text: "Hello!? Is that you?", language: "en")
      expect(ps.segment).to eq(["Hello!?", "Is that you?"])
    end

    it "Double punctuation (question mark / exclamation point) #030" do
      ps = PragmaticSegmenter::Segmenter.new(text: "Hello?! Is that you?", language: "en")
      expect(ps.segment).to eq(["Hello?!", "Is that you?"])
    end

    it "List (period followed by parens and no period to end item) #031" do
      ps = PragmaticSegmenter::Segmenter.new(text: "1.) The first item 2.) The second item", language: "en")
      expect(ps.segment).to eq(["1.) The first item", "2.) The second item"])
    end

    it "List (period followed by parens and period to end item) #032" do
      ps = PragmaticSegmenter::Segmenter.new(text: "1.) The first item. 2.) The second item.", language: "en")
      expect(ps.segment).to eq(["1.) The first item.", "2.) The second item."])
    end

    it "List (parens and no period to end item) #033" do
      ps = PragmaticSegmenter::Segmenter.new(text: "1) The first item 2) The second item", language: "en")
      expect(ps.segment).to eq(["1) The first item", "2) The second item"])
    end

    it "List (parens and period to end item) #034" do
      ps = PragmaticSegmenter::Segmenter.new(text: "1) The first item. 2) The second item.", language: "en")
      expect(ps.segment).to eq(["1) The first item.", "2) The second item."])
    end

    it "List (period to mark list and no period to end item) #035" do
      ps = PragmaticSegmenter::Segmenter.new(text: "1. The first item 2. The second item", language: "en")
      expect(ps.segment).to eq(["1. The first item", "2. The second item"])
    end

    it "List (period to mark list and period to end item) #036" do
      ps = PragmaticSegmenter::Segmenter.new(text: "1. The first item. 2. The second item.", language: "en")
      expect(ps.segment).to eq(["1. The first item.", "2. The second item."])
    end

    it "List with bullet #037" do
      ps = PragmaticSegmenter::Segmenter.new(text: "• 9. The first item • 10. The second item", language: "en")
      expect(ps.segment).to eq(["• 9. The first item", "• 10. The second item"])
    end

    it "List with hypthen #038" do
      ps = PragmaticSegmenter::Segmenter.new(text: "⁃9. The first item ⁃10. The second item", language: "en")
      expect(ps.segment).to eq(["⁃9. The first item", "⁃10. The second item"])
    end

    it "Alphabetical list #039" do
      ps = PragmaticSegmenter::Segmenter.new(text: "a. The first item b. The second item c. The third list item", language: "en")
      expect(ps.segment).to eq(["a. The first item", "b. The second item", "c. The third list item"])
    end

    it "Errant newlines in the middle of sentences (PDF) #040" do
      ps = PragmaticSegmenter::Segmenter.new(text: "This is a sentence\ncut off in the middle because pdf.", language: "en", doc_type: "pdf")
      expect(ps.segment).to eq(["This is a sentence cut off in the middle because pdf."])
    end

    it "Errant newlines in the middle of sentences #041" do
      ps = PragmaticSegmenter::Segmenter.new(text: "It was a cold \nnight in the city.", language: "en")
      expect(ps.segment).to eq(["It was a cold night in the city."])
    end

    it "Lower case list separated by newline #042" do
      ps = PragmaticSegmenter::Segmenter.new(text: "features\ncontact manager\nevents, activities\n", language: "en")
      expect(ps.segment).to eq(["features", "contact manager", "events, activities"])
    end

    it "Geo Coordinates #043" do
      ps = PragmaticSegmenter::Segmenter.new(text: "You can find it at N°. 1026.253.553. That is where the treasure is.", language: "en")
      expect(ps.segment).to eq(["You can find it at N°. 1026.253.553.", "That is where the treasure is."])
    end

    it "Named entities with an exclamation point #044" do
      ps = PragmaticSegmenter::Segmenter.new(text: "She works at Yahoo! in the accounting department.", language: "en")
      expect(ps.segment).to eq(["She works at Yahoo! in the accounting department."])
    end

    it "I as a sentence boundary and I as an abbreviation #045" do
      ps = PragmaticSegmenter::Segmenter.new(text: "We make a good team, you and I. Did you see Albert I. Jones yesterday?", language: "en")
      expect(ps.segment).to eq(["We make a good team, you and I.", "Did you see Albert I. Jones yesterday?"])
    end

    it "Ellipsis at end of quotation #046" do
      ps = PragmaticSegmenter::Segmenter.new(text: "Thoreau argues that by simplifying one’s life, “the laws of the universe will appear less complex. . . .”", language: "en")
      expect(ps.segment).to eq(["Thoreau argues that by simplifying one’s life, “the laws of the universe will appear less complex. . . .”"])
    end

    it "Ellipsis with square brackets #047" do
      ps = PragmaticSegmenter::Segmenter.new(text: "\"Bohr [...] used the analogy of parallel stairways [...]\" (Smith 55).", language: "en")
      expect(ps.segment).to eq(["\"Bohr [...] used the analogy of parallel stairways [...]\" (Smith 55)."])
    end

    it "Ellipsis as sentence boundary (standard ellipsis rules) #048" do
      ps = PragmaticSegmenter::Segmenter.new(text: "If words are left off at the end of a sentence, and that is all that is omitted, indicate the omission with ellipsis marks (preceded and followed by a space) and then indicate the end of the sentence with a period . . . . Next sentence.", language: "en")
      expect(ps.segment).to eq(["If words are left off at the end of a sentence, and that is all that is omitted, indicate the omission with ellipsis marks (preceded and followed by a space) and then indicate the end of the sentence with a period . . . .", "Next sentence."])
    end

    it "Ellipsis as sentence boundary (non-standard ellipsis rules) #049" do
      ps = PragmaticSegmenter::Segmenter.new(text: "I never meant that.... She left the store.", language: "en")
      expect(ps.segment).to eq(["I never meant that....", "She left the store."])
    end

    it "Ellipsis as non sentence boundary #050" do
      ps = PragmaticSegmenter::Segmenter.new(text: "I wasn’t really ... well, what I mean...see . . . what I'm saying, the thing is . . . I didn’t mean it.", language: "en")
      expect(ps.segment).to eq(["I wasn’t really ... well, what I mean...see . . . what I'm saying, the thing is . . . I didn’t mean it."])
    end

    it "4-dot ellipsis #051" do
      ps = PragmaticSegmenter::Segmenter.new(text: "One further habit which was somewhat weakened . . . was that of combining words into self-interpreting compounds. . . . The practice was not abandoned. . . .", language: "en")
      expect(ps.segment).to eq(["One further habit which was somewhat weakened . . . was that of combining words into self-interpreting compounds.", ". . . The practice was not abandoned. . . ."])
    end
  end

  context "Golden Rules (languages other than English)" do
    context "Golden Rules (German)" do
      it "Quotation at end of sentence #001" do
        ps = PragmaticSegmenter::Segmenter.new(text: "„Ich habe heute keine Zeit“, sagte die Frau und flüsterte leise: „Und auch keine Lust.“ Wir haben 1.000.000 Euro.", language: "de")
        expect(ps.segment).to eq(["„Ich habe heute keine Zeit“, sagte die Frau und flüsterte leise: „Und auch keine Lust.“", "Wir haben 1.000.000 Euro."])
      end

      it "Abbreviations #002" do
        ps = PragmaticSegmenter::Segmenter.new(text: "Es gibt jedoch einige Vorsichtsmaßnahmen, die Du ergreifen kannst, z. B. ist es sehr empfehlenswert, dass Du Dein Zuhause von allem Junkfood befreist.", language: "de")
        expect(ps.segment).to eq(["Es gibt jedoch einige Vorsichtsmaßnahmen, die Du ergreifen kannst, z. B. ist es sehr empfehlenswert, dass Du Dein Zuhause von allem Junkfood befreist."])
      end

      it "Numbers #003" do
        ps = PragmaticSegmenter::Segmenter.new(text: "Was sind die Konsequenzen der Abstimmung vom 12. Juni?", language: "de")
        expect(ps.segment).to eq(["Was sind die Konsequenzen der Abstimmung vom 12. Juni?"])
      end
    end

    context "Golden Rules (Japanese)" do
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

    context "Golden Rules (Arabic)" do
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

    context "Golden Rules (Italian)" do
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

    context "Golden Rules (Russian)" do
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

    context "Golden Rules (Spanish)" do
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

    context "Golden Rules (Greek)" do
      it "Question mark to end sentence #001" do
        ps = PragmaticSegmenter::Segmenter.new(text: "Με συγχωρείτε· πού είναι οι τουαλέτες; Τις Κυριακές δε δούλευε κανένας. το κόστος του σπιτιού ήταν £260.950,00.", language: "el")
        expect(ps.segment).to eq(["Με συγχωρείτε· πού είναι οι τουαλέτες;", "Τις Κυριακές δε δούλευε κανένας.", "το κόστος του σπιτιού ήταν £260.950,00."])
      end
    end

    context "Golden Rules (Hindi)" do
      it "Full stop #001" do
        ps = PragmaticSegmenter::Segmenter.new(text: "सच्चाई यह है कि इसे कोई नहीं जानता। हो सकता है यह फ़्रेन्को के खिलाफ़ कोई विद्रोह रहा हो, या फिर बेकाबू हो गया कोई आनंदोत्सव।", language: "hi")
        expect(ps.segment).to eq(["सच्चाई यह है कि इसे कोई नहीं जानता।", "हो सकता है यह फ़्रेन्को के खिलाफ़ कोई विद्रोह रहा हो, या फिर बेकाबू हो गया कोई आनंदोत्सव।"])
      end
    end

    context "Golden Rules (Armenian)" do
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

    context "Golden Rules (Burmese)" do
      it "Sentence ending punctuation #001" do
        ps = PragmaticSegmenter::Segmenter.new(text: "ခင္ဗ်ားနာမည္ဘယ္လိုေခၚလဲ။၇ွင္ေနေကာင္းလား။", language: 'my')
        expect(ps.segment).to eq(["ခင္ဗ်ားနာမည္ဘယ္လိုေခၚလဲ။", "၇ွင္ေနေကာင္းလား။"])
      end
    end

    context "Golden Rules (Amharic)" do
      it "Sentence ending punctuation #001" do
        ps = PragmaticSegmenter::Segmenter.new(text: "እንደምን አለህ፧መልካም ቀን ይሁንልህ።እባክሽ ያልሽዉን ድገሚልኝ።", language: 'am')
        expect(ps.segment).to eq(["እንደምን አለህ፧", "መልካም ቀን ይሁንልህ።", "እባክሽ ያልሽዉን ድገሚልኝ።"])
      end
    end

    context "Golden Rules (Persian)" do
      it "Sentence ending punctuation #001" do
        ps = PragmaticSegmenter::Segmenter.new(text: "خوشبختم، آقای رضا. شما کجایی هستید؟ من از تهران هستم.", language: 'fa')
        expect(ps.segment).to eq(["خوشبختم، آقای رضا.", "شما کجایی هستید؟", "من از تهران هستم."])
      end
    end

    context "Golden Rules (Urdu)" do
      it "Sentence ending punctuation #001" do
        ps = PragmaticSegmenter::Segmenter.new(text: "کیا حال ہے؟ ميرا نام ___ ەے۔ میں حالا تاوان دےدوں؟", language: 'ur')
        expect(ps.segment).to eq(["کیا حال ہے؟", "ميرا نام ___ ەے۔", "میں حالا تاوان دےدوں؟"])
      end
    end
  end

  context 'Language: English (en)' do
    describe '#segment' do
      it 'correctly segments text #001' do
        ps = PragmaticSegmenter::Segmenter.new(text: "Alice was beginning to get very tired of sitting by her sister on the bank, and of having nothing to do: once or twice she had peeped into the book her sister was reading, but it had no pictures or conversations in it, 'and what is the use of a book,' thought Alice 'without pictures or conversations?'\nSo she was considering in her own mind (as well as she could, for the hot day made her feel very sleepy and stupid), whether the pleasure of making a daisy-chain would be worth the trouble of getting up and picking the daisies, when suddenly a White Rabbit with pink eyes ran close by her.", language: 'en')
        expect(ps.segment).to eq(["Alice was beginning to get very tired of sitting by her sister on the bank, and of having nothing to do: once or twice she had peeped into the book her sister was reading, but it had no pictures or conversations in it, 'and what is the use of a book,' thought Alice 'without pictures or conversations?'", "So she was considering in her own mind (as well as she could, for the hot day made her feel very sleepy and stupid), whether the pleasure of making a daisy-chain would be worth the trouble of getting up and picking the daisies, when suddenly a White Rabbit with pink eyes ran close by her."])
      end

      it 'correctly segments text #002' do
        ps = PragmaticSegmenter::Segmenter.new(text: "Either the well was very deep, or she fell very slowly, for she had plenty of time as she went down to look about her and to wonder what was going to happen next. First, she tried to look down and make out what she was coming to, but it was too dark to see anything; then she looked at the sides of the well, and noticed that they were filled with cupboards and book-shelves; here and there she saw maps and pictures hung upon pegs. She took down a jar from one of the shelves as she passed; it was labelled 'ORANGE MARMALADE', but to her great disappointment it was empty: she did not like to drop the jar for fear of killing somebody, so managed to put it into one of the cupboards as she fell past it.\n'Well!' thought Alice to herself, 'after such a fall as this, I shall think nothing of tumbling down stairs! How brave they'll all think me at home! Why, I wouldn't say anything about it, even if I fell off the top of the house!' (Which was very likely true.)", language: 'en', doc_type: 'pdf')
        expect(ps.segment).to eq(["Either the well was very deep, or she fell very slowly, for she had plenty of time as she went down to look about her and to wonder what was going to happen next.", "First, she tried to look down and make out what she was coming to, but it was too dark to see anything; then she looked at the sides of the well, and noticed that they were filled with cupboards and book-shelves; here and there she saw maps and pictures hung upon pegs.", "She took down a jar from one of the shelves as she passed; it was labelled 'ORANGE MARMALADE', but to her great disappointment it was empty: she did not like to drop the jar for fear of killing somebody, so managed to put it into one of the cupboards as she fell past it.", "'Well!' thought Alice to herself, 'after such a fall as this, I shall think nothing of tumbling down stairs! How brave they'll all think me at home! Why, I wouldn't say anything about it, even if I fell off the top of the house!' (Which was very likely true.)"])
      end

      it 'correctly segments text #003' do
        ps = PragmaticSegmenter::Segmenter.new(text: "Either the well was very deep, or she fell very slowly, for she had plenty of time as she went down to look about her and to wonder what was going to happen next. First, she tried to look down and make out what she was coming to, but it was too dark to see anything; then she looked at the sides of the well, and noticed that they were filled with cupboards and book-shelves; here and there she saw maps and pictures hung upon pegs. She took down a jar from one of the shelves as she passed; it was labelled 'ORANGE MARMALADE', but to her great disappointment it was empty: she did not like to drop the jar for fear of killing somebody, so managed to put it into one of the cupboards as she fell past it.\r'Well!' thought Alice to herself, 'after such a fall as this, I shall think nothing of tumbling down stairs! How brave they'll all think me at home! Why, I wouldn't say anything about it, even if I fell off the top of the house!' (Which was very likely true.)", language: 'en', doc_type: 'pdf')
        expect(ps.segment).to eq(["Either the well was very deep, or she fell very slowly, for she had plenty of time as she went down to look about her and to wonder what was going to happen next.", "First, she tried to look down and make out what she was coming to, but it was too dark to see anything; then she looked at the sides of the well, and noticed that they were filled with cupboards and book-shelves; here and there she saw maps and pictures hung upon pegs.", "She took down a jar from one of the shelves as she passed; it was labelled 'ORANGE MARMALADE', but to her great disappointment it was empty: she did not like to drop the jar for fear of killing somebody, so managed to put it into one of the cupboards as she fell past it.", "'Well!' thought Alice to herself, 'after such a fall as this, I shall think nothing of tumbling down stairs! How brave they'll all think me at home! Why, I wouldn't say anything about it, even if I fell off the top of the house!' (Which was very likely true.)"])
      end

      it 'correctly segments text #004' do
        ps = PragmaticSegmenter::Segmenter.new(text: "'Well!' thought Alice to herself, 'after such a fall as this, I shall think nothing of tumbling down stairs! How brave they'll all think me at home! Why, I wouldn't say anything about it, even if I fell off the top of the house!' (Which was very likely true.)", language: 'en')
        expect(ps.segment).to eq(["'Well!' thought Alice to herself, 'after such a fall as this, I shall think nothing of tumbling down stairs! How brave they'll all think me at home! Why, I wouldn't say anything about it, even if I fell off the top of the house!' (Which was very likely true.)"])
      end

      it 'correctly segments text #005' do
        ps = PragmaticSegmenter::Segmenter.new(text: "Down, down, down. Would the fall NEVER come to an end! 'I wonder how many miles I've fallen by this time?' she said aloud.", language: 'en')
        expect(ps.segment).to eq(["Down, down, down.", "Would the fall NEVER come to an end!", "'I wonder how many miles I've fallen by this time?' she said aloud."])
      end

      it 'correctly segments text #006' do
        ps = PragmaticSegmenter::Segmenter.new(text: "Either the well was very deep, or she fell very slowly, for she had plenty of time as she went down to look about her and to wonder what was going to happen next. First, she tried to look down and make out what she was coming to, but it was too dark to see anything; then she looked at the sides of the well, and noticed that they were filled with cupboards and book-shelves; here and there she saw maps and pictures hung upon pegs. She took down a jar from one of the shelves as she passed; it was labelled 'ORANGE MARMALADE', but to her great disappointment it was empty: she did not like to drop the jar for fear of killing somebody, so managed to put it into one of the cupboards as she fell past it. 'Well!' thought Alice to herself, 'after such a fall as this, I shall think nothing of tumbling down stairs! How brave they'll all think me at home! Why, I wouldn't say anything about it, even if I fell off the top of the house!' (Which was very likely true.)", language: 'en')
        expect(ps.segment).to eq(["Either the well was very deep, or she fell very slowly, for she had plenty of time as she went down to look about her and to wonder what was going to happen next.", "First, she tried to look down and make out what she was coming to, but it was too dark to see anything; then she looked at the sides of the well, and noticed that they were filled with cupboards and book-shelves; here and there she saw maps and pictures hung upon pegs.", "She took down a jar from one of the shelves as she passed; it was labelled 'ORANGE MARMALADE', but to her great disappointment it was empty: she did not like to drop the jar for fear of killing somebody, so managed to put it into one of the cupboards as she fell past it.", "'Well!' thought Alice to herself, 'after such a fall as this, I shall think nothing of tumbling down stairs! How brave they'll all think me at home! Why, I wouldn't say anything about it, even if I fell off the top of the house!' (Which was very likely true.)"])
      end

      it 'correctly segments text #007' do
        ps = PragmaticSegmenter::Segmenter.new(text: 'A minute is a unit of measurement of time or of angle. The minute is a unit of time equal to 1/60th of an hour or 60 seconds by 1. In the UTC time scale, a minute occasionally has 59 or 61 seconds; see leap second. The minute is not an SI unit; however, it is accepted for use with SI units. The symbol for minute or minutes is min. The fact that an hour contains 60 minutes is probably due to influences from the Babylonians, who used a base-60 or sexagesimal counting system. Colloquially, a min. may also refer to an indefinite amount of time substantially longer than the standardized length.', language: 'en')
        expect(ps.segment).to eq(["A minute is a unit of measurement of time or of angle.", "The minute is a unit of time equal to 1/60th of an hour or 60 seconds by 1.", "In the UTC time scale, a minute occasionally has 59 or 61 seconds; see leap second.", "The minute is not an SI unit; however, it is accepted for use with SI units.", "The symbol for minute or minutes is min.", "The fact that an hour contains 60 minutes is probably due to influences from the Babylonians, who used a base-60 or sexagesimal counting system.", "Colloquially, a min. may also refer to an indefinite amount of time substantially longer than the standardized length."])
      end

      it 'correctly segments text #008' do
        text = <<-EOF
          About Me...............................................................................................5
          Chapter 2 ...................................................................... 6
          Three Weeks Later............................................................................ 7
          Better Eating........................................................................................ 8
          What's the Score?.............................................................. 9
          How To Calculate the Score................... 16-17
        EOF

        ps = PragmaticSegmenter::Segmenter.new(text: text, language: 'en')
        expect(ps.segment).to eq(["About Me", "Chapter 2", "Three Weeks Later", "Better Eating", "What's the Score?", "How To Calculate the Score"])
      end

      it 'correctly segments text #009' do
        ps = PragmaticSegmenter::Segmenter.new(text: 'I think Jun. is a great month, said Mr. Suzuki.', language: 'en')
        expect(ps.segment).to eq(["I think Jun. is a great month, said Mr. Suzuki."])
      end

      it 'correctly segments text #010' do
        ps = PragmaticSegmenter::Segmenter.new(text: 'Jun. is a great month, said Mr. Suzuki.', language: 'en')
        expect(ps.segment).to eq(["Jun. is a great month, said Mr. Suzuki."])
      end

      it 'correctly segments text #011' do
        ps = PragmaticSegmenter::Segmenter.new(text: "I have 1.000.00. Yay $.50 and .50! That's 600.", language: 'en')
        expect(ps.segment).to eq(["I have 1.000.00.", "Yay $.50 and .50!", "That's 600."])
      end

      it 'correctly segments text #012' do
        ps = PragmaticSegmenter::Segmenter.new(text: '1.) This is a list item with a parens.', language: 'en')
        expect(ps.segment).to eq(["1.) This is a list item with a parens."])
      end

      it 'correctly segments text #013' do
        ps = PragmaticSegmenter::Segmenter.new(text: '1. This is a list item.', language: 'en')
        expect(ps.segment).to eq(['1. This is a list item.'])
      end

      it 'correctly segments text #014' do
        ps = PragmaticSegmenter::Segmenter.new(text: 'I live in the U.S.A. I went to J.C. Penney.', language: 'en')
        expect(ps.segment).to eq(["I live in the U.S.A.", "I went to J.C. Penney."])
      end

      it 'correctly segments text #015' do
        ps = PragmaticSegmenter::Segmenter.new(text: 'His name is Alfred E. Sloan.', language: 'en')
        expect(ps.segment).to eq(['His name is Alfred E. Sloan.'])
      end

      it 'correctly segments text #016' do
        ps = PragmaticSegmenter::Segmenter.new(text: 'Q. What is his name? A. His name is Alfred E. Sloan.', language: 'en')
        expect(ps.segment).to eq(['Q. What is his name?', 'A. His name is Alfred E. Sloan.'])
      end

      it 'correctly segments text #017' do
        ps = PragmaticSegmenter::Segmenter.new(text: 'Today is 11.18.2014.', language: 'en')
        expect(ps.segment).to eq(['Today is 11.18.2014.'])
      end

      it 'correctly segments text #018' do
        ps = PragmaticSegmenter::Segmenter.new(text: 'I need you to find 3 items, e.g. a hat, a coat, and a bag.', language: 'en')
        expect(ps.segment).to eq(['I need you to find 3 items, e.g. a hat, a coat, and a bag.'])
      end

      it 'correctly segments text #019' do
        ps = PragmaticSegmenter::Segmenter.new(text: "The game is the Giants vs. the Tigers at 10 p.m. I'm going are you?", language: 'en')
        expect(ps.segment).to eq(["The game is the Giants vs. the Tigers at 10 p.m.", "I'm going are you?"])
      end

      it 'correctly segments text #020' do
        ps = PragmaticSegmenter::Segmenter.new(text: 'He is no. 5, the shortstop.', language: 'en')
        expect(ps.segment).to eq(['He is no. 5, the shortstop.'])
      end

      it 'correctly segments text #021' do
        ps = PragmaticSegmenter::Segmenter.new(text: "Remove long strings of dots........please.", language: 'en')
        expect(ps.segment).to eq(["Remove long strings of dots please."])
      end

      it 'correctly segments text #022' do
        ps = PragmaticSegmenter::Segmenter.new(text: "See our additional services section or contact us for pricing\n.\n\n\nPricing Additionl Info\n", language: 'en')
        expect(ps.segment).to eq(["See our additional services section or contact us for pricing.", "Pricing Additionl Info"])
      end

      it 'correctly segments text #023' do
        ps = PragmaticSegmenter::Segmenter.new(text: "As payment for 1. above, pay us a commission fee of 0 yen and for 2. above, no fee will be paid.", language: 'en')
        expect(ps.segment).to eq(["As payment for 1. above, pay us a commission fee of 0 yen and for 2. above, no fee will be paid."])
      end

      it 'correctly segments text #024' do
        ps = PragmaticSegmenter::Segmenter.new(text: "features\ncontact manager\nevents, activities\n", language: 'en')
        expect(ps.segment).to eq(['features', 'contact manager', 'events, activities'])
      end

      it 'correctly segments text #025' do
        ps = PragmaticSegmenter::Segmenter.new(text: "Git rid of   unnecessary white space.", language: 'en')
        expect(ps.segment).to eq(["Git rid of unnecessary white space."])
      end

      it 'correctly segments text #026' do
        ps = PragmaticSegmenter::Segmenter.new(text: "See our additional services section or contact us for pricing\n. Pricing Additionl Info", language: 'en')
        expect(ps.segment).to eq(["See our additional services section or contact us for pricing.", "Pricing Additionl Info"])
      end

      it 'correctly segments text #027' do
        ps = PragmaticSegmenter::Segmenter.new(text: "Organising your care early \nmeans you'll have months to build a good relationship with your midwife or doctor, ready for \nthe birth.", language: 'en', doc_type: 'pdf')
        expect(ps.segment).to eq(["Organising your care early means you'll have months to build a good relationship with your midwife or doctor, ready for the birth."])
      end

      it 'correctly segments text #028' do
        ps = PragmaticSegmenter::Segmenter.new(text: "10. Get some rest \n \nYou have the best chance of having a problem-free pregnancy and a healthy baby if you follow \na few simple guidelines:", language: 'en', doc_type: 'pdf')
        expect(ps.segment).to eq(["10. Get some rest", "You have the best chance of having a problem-free pregnancy and a healthy baby if you follow a few simple guidelines:"])
      end

      it 'correctly segments text #029' do
        ps = PragmaticSegmenter::Segmenter.new(text: "• 9. Stop smoking \n• 10. Get some rest \n \nYou have the best chance of having a problem-free pregnancy and a healthy baby if you follow \na few simple guidelines:  \n\n1. Organise your pregnancy care early", language: 'en', doc_type: 'pdf')
        expect(ps.segment).to eq(["• 9. Stop smoking", "• 10. Get some rest", "You have the best chance of having a problem-free pregnancy and a healthy baby if you follow a few simple guidelines:", "1. Organise your pregnancy care early"])
      end

      it 'correctly segments text #030' do
        ps = PragmaticSegmenter::Segmenter.new(text: "I have 600. How many do you have?", language: 'en')
        expect(ps.segment).to eq(["I have 600.", "How many do you have?"])
      end

      it 'correctly segments text #031' do
        ps = PragmaticSegmenter::Segmenter.new(text: "\n3\n\nIntroduction\n\n", language: 'en')
        expect(ps.segment).to eq(["Introduction"])
      end

      it 'correctly segments text #032' do
        ps = PragmaticSegmenter::Segmenter.new(text: "\nW\nA\nRN\nI\nNG\n", language: 'en')
        expect(ps.segment).to eq(["WARNING"])
      end

      it 'correctly segments text #033' do
        ps = PragmaticSegmenter::Segmenter.new(text: "\n\n\nW\nA\nRN\nI\nNG\n \n/\n \nA\nV\nE\nR\nT\nI\nS\nE\nM\nE\nNT\n", language: 'en')
        expect(ps.segment).to eq(["WARNING", "AVERTISEMENT"])
      end

      it 'correctly segments text #034' do
        ps = PragmaticSegmenter::Segmenter.new(text: '"Help yourself, sweetie," shouted Candy and gave her the cookie.', language: 'en')
        expect(ps.segment).to eq(["\"Help yourself, sweetie,\" shouted Candy and gave her the cookie."])
      end

      it 'correctly segments text #035' do
        ps = PragmaticSegmenter::Segmenter.new(text: "Until its release, a generic mechanism was known, where the sear keeps the hammer in back position, and when one pulls the trigger, the sear slips out of hammer’s notches, the hammer falls initiating \na shot.", language: 'en')
        expect(ps.segment).to eq(["Until its release, a generic mechanism was known, where the sear keeps the hammer in back position, and when one pulls the trigger, the sear slips out of hammer’s notches, the hammer falls initiating a shot."])
      end

      it 'correctly segments text #036' do
        ps = PragmaticSegmenter::Segmenter.new(text: "This is a test. Until its release, a generic mechanism was known, where the sear keeps the hammer in back position, and when one pulls the trigger, the sear slips out of hammer’s notches, the hammer falls initiating \na shot.", language: 'en')
        expect(ps.segment).to eq(["This is a test.", "Until its release, a generic mechanism was known, where the sear keeps the hammer in back position, and when one pulls the trigger, the sear slips out of hammer’s notches, the hammer falls initiating a shot."])
      end

      it 'correctly segments text #037' do
        ps = PragmaticSegmenter::Segmenter.new(text: "This was because it was an offensive weapon, designed to fight at a distance up to 400 yd \n( 365.8 m ).", language: 'en')
        expect(ps.segment).to eq(["This was because it was an offensive weapon, designed to fight at a distance up to 400 yd ( 365.8 m )."])
      end

      it 'correctly segments text #038' do
        ps = PragmaticSegmenter::Segmenter.new(text: "“Are demonstrations are evidence of the public anger and frustration at opaque environmental management and decision-making?” Others yet say: \"Should we be scared about these 'protests'?\"", language: 'en')
        expect(ps.segment).to eq(["“Are demonstrations are evidence of the public anger and frustration at opaque environmental management and decision-making?”", "Others yet say: \"Should we be scared about these 'protests'?\""])
      end

      it 'correctly segments text #039' do
        ps = PragmaticSegmenter::Segmenter.new(text: "www.testurl.Awesome.com", language: 'en')
        expect(ps.segment).to eq(["www.testurl.Awesome.com"])
      end

      it 'correctly segments text #040' do
        ps = PragmaticSegmenter::Segmenter.new(text: "http://testurl.Awesome.com", language: 'en')
        expect(ps.segment).to eq(["http://testurl.Awesome.com"])
      end

      it 'correctly segments text #041' do
        ps = PragmaticSegmenter::Segmenter.new(text: "St. Michael's Church in is a church.", language: 'en')
        expect(ps.segment).to eq(["St. Michael's Church in is a church."])
      end

      it 'correctly segments text #042' do
        ps = PragmaticSegmenter::Segmenter.new(text: "JFK Jr.'s book is on sale.", language: 'en')
        expect(ps.segment).to eq(["JFK Jr.'s book is on sale."])
      end

      it 'correctly segments text #043' do
        ps = PragmaticSegmenter::Segmenter.new(text: "This is e.g. Mr. Smith, who talks slowly... And this is another sentence.", language: 'en')
        expect(ps.segment).to eq(["This is e.g. Mr. Smith, who talks slowly...", "And this is another sentence."])
      end

      it 'correctly segments text #044' do
        ps = PragmaticSegmenter::Segmenter.new(text: "Leave me alone!, he yelled. I am in the U.S. Army. Charles (Ind.) said he.", language: 'en')
        expect(ps.segment).to eq(["Leave me alone!, he yelled.", "I am in the U.S. Army.", "Charles (Ind.) said he."])
      end

      it 'correctly segments text #045' do
        ps = PragmaticSegmenter::Segmenter.new(text: "This is the U.S. Senate my friends. <em>Yes.</em> <em>It is</em>!", language: 'en')
        expect(ps.segment).to eq(["This is the U.S. Senate my friends.", "Yes.", "It is!"])
      end

      it 'correctly segments text #046' do
        ps = PragmaticSegmenter::Segmenter.new(text: "Send it to P.O. box 6554", language: 'en')
        expect(ps.segment).to eq(["Send it to P.O. box 6554"])
      end

      it 'correctly segments text #047' do
        ps = PragmaticSegmenter::Segmenter.new(text: "There were 500 cases in the U.S. The U.S. Commission asked the U.S. Government to give their opinion on the issue.", language: 'en')
        expect(ps.segment).to eq(["There were 500 cases in the U.S.", "The U.S. Commission asked the U.S. Government to give their opinion on the issue."])
      end

      it 'correctly segments text #048' do
        ps = PragmaticSegmenter::Segmenter.new(text: "CELLULAR COMMUNICATIONS INC. sold 1,550,000 common shares at $21.75 each yesterday, according to lead underwriter L.F. Rothschild & Co. (cited from WSJ 05/29/1987)", language: 'en')
        expect(ps.segment).to eq(["CELLULAR COMMUNICATIONS INC. sold 1,550,000 common shares at $21.75 each yesterday, according to lead underwriter L.F. Rothschild & Co.", "(cited from WSJ 05/29/1987)"])
      end

      it 'correctly segments text #049' do
        ps = PragmaticSegmenter::Segmenter.new(text: "Rolls-Royce Motor Cars Inc. said it expects its U.S. sales to remain steady at about 1,200 cars in 1990. `So what if you miss 50 tanks somewhere?' asks Rep. Norman Dicks (D., Wash.), a member of the House group that visited the talks in Vienna. Later, he recalls the words of his Marxist mentor: `The people! Theft! The holy fire!'", language: 'en')
        expect(ps.segment).to eq(["Rolls-Royce Motor Cars Inc. said it expects its U.S. sales to remain steady at about 1,200 cars in 1990.", "'So what if you miss 50 tanks somewhere?' asks Rep. Norman Dicks (D., Wash.), a member of the House group that visited the talks in Vienna.", "Later, he recalls the words of his Marxist mentor: 'The people! Theft! The holy fire!'"])
      end

      it 'correctly segments text #050' do
        ps = PragmaticSegmenter::Segmenter.new(text: "He climbed Mt. Fuji.", language: 'en')
        expect(ps.segment).to eq(["He climbed Mt. Fuji."])
      end

      it 'correctly segments text #051' do
        ps = PragmaticSegmenter::Segmenter.new(text: "He speaks !Xũ, !Kung, ǃʼOǃKung, !Xuun, !Kung-Ekoka, ǃHu, ǃKhung, ǃKu, ǃung, ǃXo, ǃXû, ǃXung, ǃXũ, and !Xun.", language: 'en')
        expect(ps.segment).to eq(["He speaks !Xũ, !Kung, ǃʼOǃKung, !Xuun, !Kung-Ekoka, ǃHu, ǃKhung, ǃKu, ǃung, ǃXo, ǃXû, ǃXung, ǃXũ, and !Xun."])
      end

      it 'correctly segments text #052' do
        ps = PragmaticSegmenter::Segmenter.new(text: "Test strange period．Does it segment correctly．", language: 'en')
        expect(ps.segment).to eq(["Test strange period．", "Does it segment correctly．"])
      end

      it 'correctly segments text #053' do
        ps = PragmaticSegmenter::Segmenter.new(text: "<h2 class=\"lined\">Hello</h2>\n<p>This is a test. Another test.</p>\n<div class=\"center\"><p>\n<img src=\"/images/content/example.jpg\">\n</p></div>", language: 'en')
        expect(ps.segment).to eq(["Hello", "This is a test.", "Another test."])
      end

      it 'correctly segments text #054' do
        ps = PragmaticSegmenter::Segmenter.new(text: "This sentence ends with the psuedo-number x10. This one with the psuedo-number %3.00. One last sentence.", language: 'en')
        expect(ps.segment).to eq(["This sentence ends with the psuedo-number x10.", "This one with the psuedo-number %3.00.", "One last sentence."])
      end

      it 'correctly segments text #055' do
        ps = PragmaticSegmenter::Segmenter.new(text: "Testing mixed numbers Jahr10. And another 0.3 %11. That's weird.", language: 'en')
        expect(ps.segment).to eq(["Testing mixed numbers Jahr10.", "And another 0.3 %11.", "That's weird."])
      end

      it 'correctly segments text #056' do
        ps = PragmaticSegmenter::Segmenter.new(text: "Were Jane and co. at the party?", language: 'en')
        expect(ps.segment).to eq(["Were Jane and co. at the party?"])
      end

      it 'correctly segments text #057' do
        ps = PragmaticSegmenter::Segmenter.new(text: "St. Michael's Church is on 5th st. near the light.", language: 'en')
        expect(ps.segment).to eq(["St. Michael's Church is on 5th st. near the light."])
      end

      it 'correctly segments text #058' do
        ps = PragmaticSegmenter::Segmenter.new(text: "Let's ask Jane and co. They should know.", language: 'en')
        expect(ps.segment).to eq(["Let's ask Jane and co.", "They should know."])
      end

      it 'correctly segments text #059' do
        ps = PragmaticSegmenter::Segmenter.new(text: "He works at Yahoo! and Y!J.", language: 'en')
        expect(ps.segment).to eq(["He works at Yahoo! and Y!J."])
      end

      it 'correctly segments text #060' do
        ps = PragmaticSegmenter::Segmenter.new(text: 'The Scavenger Hunt ends on Dec. 31st, 2011.', language: 'en')
        expect(ps.segment).to eq(['The Scavenger Hunt ends on Dec. 31st, 2011.'])
      end

      it 'correctly segments text #061' do
        ps = PragmaticSegmenter::Segmenter.new(text: "Putter King Scavenger Hunt Trophy\n(6 3/4\" Engraved Crystal Trophy - Picture Coming Soon)\nThe Putter King team will judge the scavenger hunt and all decisions will be final.  The scavenger hunt is open to anyone and everyone.  The scavenger hunt ends on Dec. 31st, 2011.", language: 'en')
        expect(ps.segment).to eq(["Putter King Scavenger Hunt Trophy", "(6 3/4\" Engraved Crystal Trophy - Picture Coming Soon)", "The Putter King team will judge the scavenger hunt and all decisions will be final.", "The scavenger hunt is open to anyone and everyone.", "The scavenger hunt ends on Dec. 31st, 2011."])
      end

      it 'correctly segments text #062' do
        ps = PragmaticSegmenter::Segmenter.new(text: "Unauthorized modifications, alterations or installations of or to this equipment are prohibited and are in violation of AR 750-10. Any such unauthorized modifications, alterations or installations could result in death, injury or damage to the equipment.", language: 'en')
        expect(ps.segment).to eq(["Unauthorized modifications, alterations or installations of or to this equipment are prohibited and are in violation of AR 750-10.", "Any such unauthorized modifications, alterations or installations could result in death, injury or damage to the equipment."])
      end

      it 'correctly segments text #063' do
        ps = PragmaticSegmenter::Segmenter.new(text: "Header 1.2; Attachment Z\n\n\td. Compliance Log – Volume 12 \n\tAttachment A\n\n\te. Additional Logistics Data\n\tSection 10", language: 'en')
        expect(ps.segment).to eq(["Header 1.2; Attachment Z", "d. Compliance Log – Volume 12", "Attachment A", "e. Additional Logistics Data", "Section 10"])
      end

      it 'correctly segments text #064' do
        ps = PragmaticSegmenter::Segmenter.new(text: "a.) The first item b.) The second item c.) The third list item", language: 'en')
        expect(ps.segment).to eq(["a.) The first item", "b.) The second item", "c.) The third list item"])
      end

      it 'correctly segments text #065' do
        ps = PragmaticSegmenter::Segmenter.new(text: "a) The first item b) The second item c) The third list item", language: 'en')
        expect(ps.segment).to eq(["a) The first item", "b) The second item", "c) The third list item"])
      end

      it 'correctly segments text #066' do
        ps = PragmaticSegmenter::Segmenter.new(text: "Hello Wolrd. Here is a secret code AS750-10. Another sentence. Finally, this. 1. The first item 2. The second item 3. The third list item 4. Hello 5. Hello 6. Hello 7. Hello 8. Hello 9. Hello 10. Hello 11. Hello", language: 'en')
        expect(ps.segment).to eq(["Hello Wolrd.", "Here is a secret code AS750-10.", "Another sentence.", "Finally, this.", "1. The first item", "2. The second item", "3. The third list item", "4. Hello", "5. Hello", "6. Hello", "7. Hello", "8. Hello", "9. Hello", "10. Hello", "11. Hello"])
      end

      it 'correctly segments text #067' do
        ps = PragmaticSegmenter::Segmenter.new(text: "He works for ABC Ltd. and sometimes for BCD Ltd. She works for ABC Co. and BCD Co. They work for ABC Corp. and BCD Corp.", language: 'en')
        expect(ps.segment).to eq(["He works for ABC Ltd. and sometimes for BCD Ltd.", "She works for ABC Co. and BCD Co.", "They work for ABC Corp. and BCD Corp."])
      end

      it 'correctly segments text #068' do
        ps = PragmaticSegmenter::Segmenter.new(text: "<bpt i=\"0\" type=\"bold\">&lt;b&gt;</bpt>J1.txt<ept i=\"1\">&lt;/b&gt;</ept>", language: 'en')
        expect(ps.segment).to eq(["J1.txt"])
      end

      it 'correctly segments text #069' do
        ps = PragmaticSegmenter::Segmenter.new(text: "On Jan. 20, former Sen. Barack Obama became the 44th President of the U.S. Millions attended the Inauguration.", language: 'en')
        expect(ps.segment).to eq(["On Jan. 20, former Sen. Barack Obama became the 44th President of the U.S.", "Millions attended the Inauguration."])
      end

      it 'correctly segments text #070' do
        ps = PragmaticSegmenter::Segmenter.new(text: "The U.K. Panel on enivronmental issues said it was true. Finally he left the U.K. He went to a new location.", language: 'en')
        expect(ps.segment).to eq(["The U.K. Panel on enivronmental issues said it was true.", "Finally he left the U.K.", "He went to a new location."])
      end

      it 'correctly segments text #071' do
        ps = PragmaticSegmenter::Segmenter.new(text: "He left at 6 P.M. Travelers who didn't get the warning at 5 P.M. left later.", language: 'en')
        expect(ps.segment).to eq(["He left at 6 P.M.", "Travelers who didn't get the warning at 5 P.M. left later."])
      end

      it 'correctly segments text #072' do
        ps = PragmaticSegmenter::Segmenter.new(text: "He left at 6 a.m. Travelers who didn't get the warning at 5 a.m. left later.", language: 'en')
        expect(ps.segment).to eq(["He left at 6 a.m.", "Travelers who didn't get the warning at 5 a.m. left later."])
      end

      it 'correctly segments text #073' do
        ps = PragmaticSegmenter::Segmenter.new(text: "He left at 6 A.M. Travelers who didn't get the warning at 5 A.M. left later.", language: 'en')
        expect(ps.segment).to eq(["He left at 6 A.M.", "Travelers who didn't get the warning at 5 A.M. left later."])
      end

      it 'correctly segments text #074' do
        ps = PragmaticSegmenter::Segmenter.new(text: "Hello World. My name is Jonas. What is your name? My name is Jonas. There it is! I found it. My name is Jonas E. Smith. Please turn to p. 55. Were Jane and co. at the party? They closed the deal with Pitt, Briggs & Co. at noon. Let's ask Jane and co. They should know. They closed the deal with Pitt, Briggs & Co. It closed yesterday. I can see Mt. Fuji from here. St. Michael's Church is on 5th st. near the light. That is JFK Jr.'s book. I visited the U.S.A. last year. I live in the E.U. How about you? I live in the U.S. How about you? I work for the U.S. Government in Virginia. I have lived in the U.S. for 20 years. She has $100.00 in her bag. She has $100.00. It is in her bag. He teaches science (He previously worked for 5 years as an engineer.) at the local University. Her email is Jane.Doe@example.com. I sent her an email. The site is: https://www.example.50.com/new-site/awesome_content.html. Please check it out. She turned to him, 'This is great.' she said. She turned to him, \"This is great.\" she said. She turned to him, \"This is great.\" She held the book out to show him. Hello!! Long time no see. Hello?? Who is there? Hello!? Is that you? Hello?! Is that you? 1.) The first item 2.) The second item 1.) The first item. 2.) The second item. 1) The first item 2) The second item 1) The first item. 2) The second item. 1. The first item 2. The second item 1. The first item. 2. The second item. • 9. The first item • 10. The second item ⁃9. The first item ⁃10. The second item a. The first item b. The second item c. The third list item \rIt was a cold \nnight in the city. features\ncontact manager\nevents, activities\n You can find it at N°. 1026.253.553. That is where the treasure is. She works at Yahoo! in the accounting department. We make a good team, you and I. Did you see Albert I. Jones yesterday? Thoreau argues that by simplifying one’s life, “the laws of the universe will appear less complex. . . .”. \"Bohr [...] used the analogy of parallel stairways [...]\" (Smith 55). If words are left off at the end of a sentence, and that is all that is omitted, indicate the omission with ellipsis marks (preceded and followed by a space) and then indicate the end of the sentence with a period . . . . Next sentence. I never meant that.... She left the store. I wasn’t really ... well, what I mean...see . . . what I'm saying, the thing is . . . I didn’t mean it. One further habit which was somewhat weakened . . . was that of combining words into self-interpreting compounds. . . . The practice was not abandoned. . . .", language: nil)
        expect(ps.segment).to eq(["Hello World.", "My name is Jonas.", "What is your name?", "My name is Jonas.", "There it is!", "I found it.", "My name is Jonas E. Smith.", "Please turn to p. 55.", "Were Jane and co. at the party?", "They closed the deal with Pitt, Briggs & Co. at noon.", "Let's ask Jane and co.", "They should know.", "They closed the deal with Pitt, Briggs & Co.", "It closed yesterday.", "I can see Mt. Fuji from here.", "St. Michael's Church is on 5th st. near the light.", "That is JFK Jr.'s book.", "I visited the U.S.A. last year.", "I live in the E.U.", "How about you?", "I live in the U.S.", "How about you?", "I work for the U.S. Government in Virginia.", "I have lived in the U.S. for 20 years.", "She has $100.00 in her bag.", "She has $100.00.", "It is in her bag.", "He teaches science (He previously worked for 5 years as an engineer.) at the local University.", "Her email is Jane.Doe@example.com.", "I sent her an email.", "The site is: https://www.example.50.com/new-site/awesome_content.html.", "Please check it out.", "She turned to him, 'This is great.' she said.", "She turned to him, \"This is great.\" she said.", "She turned to him, \"This is great.\"", "She held the book out to show him.", "Hello!!", "Long time no see.", "Hello??", "Who is there?", "Hello!?", "Is that you?", "Hello?!", "Is that you?", "1.) The first item", "2.) The second item", "1.) The first item.", "2.) The second item.", "1) The first item", "2) The second item", "1) The first item.", "2) The second item.", "1. The first item", "2. The second item", "1. The first item.", "2. The second item.", "• 9. The first item", "• 10. The second item", "⁃9. The first item", "⁃10. The second item", "a. The first item", "b. The second item", "c. The third list item", "It was a cold night in the city.", "features", "contact manager", "events, activities", "You can find it at N°. 1026.253.553.", "That is where the treasure is.", "She works at Yahoo! in the accounting department.", "We make a good team, you and I.", "Did you see Albert I. Jones yesterday?", "Thoreau argues that by simplifying one’s life, “the laws of the universe will appear less complex. . . .”.", "\"Bohr [...] used the analogy of parallel stairways [...]\" (Smith 55).", "If words are left off at the end of a sentence, and that is all that is omitted, indicate the omission with ellipsis marks (preceded and followed by a space) and then indicate the end of the sentence with a period . . . .", "Next sentence.", "I never meant that....", "She left the store.", "I wasn’t really ... well, what I mean...see . . . what I'm saying, the thing is . . . I didn’t mean it.", "One further habit which was somewhat weakened . . . was that of combining words into self-interpreting compounds.", ". . . The practice was not abandoned. . . ."])
      end

      it 'correctly segments text #075' do
        ps = PragmaticSegmenter::Segmenter.new(text: "His name is Mark E. Smith. a. here it is b. another c. one more\n They went to the store. It was John A. Smith. She was Jane B. Smith.", language: "en")
        expect(ps.segment).to eq(["His name is Mark E. Smith.", "a. here it is", "b. another", "c. one more", "They went to the store.", "It was John A. Smith.", "She was Jane B. Smith."])
      end

      it 'correctly segments text #076' do
        ps = PragmaticSegmenter::Segmenter.new(text: "a) here it is b) another c) one more\n They went to the store. w) hello x) hello y) hello", language: "en")
        expect(ps.segment).to eq(["a) here it is", "b) another", "c) one more", "They went to the store.", "w) hello",  "x) hello",  "y) hello"])
      end

      it 'correctly segments text #077' do
        ps = PragmaticSegmenter::Segmenter.new(text: "Hello{b^&gt;1&lt;b^} hello{b^>1<b^}.", language: "en")
        expect(ps.segment).to eq(["Hello hello."])
      end

      it 'correctly segments text #078' do
        ps = PragmaticSegmenter::Segmenter.new(text: "'Well?' thought Alice to herself, 'after such a fall as this, I shall think nothing of tumbling down stairs? How brave they'll all think me at home! Why, I wouldn't say anything about it, even if I fell off the top of the house!' (Which was very likely true.)", language: 'en')
        expect(ps.segment).to eq(["'Well?' thought Alice to herself, 'after such a fall as this, I shall think nothing of tumbling down stairs? How brave they'll all think me at home! Why, I wouldn't say anything about it, even if I fell off the top of the house!' (Which was very likely true.)"])
      end

      it 'correctly segments text #079' do
        ps = PragmaticSegmenter::Segmenter.new(text: "Leave me alone! he yelled. I am in the U.S. Army. Charles (Ind.) said he.", language: 'en')
        expect(ps.segment).to eq(["Leave me alone! he yelled.", "I am in the U.S. Army.", "Charles (Ind.) said he."])
      end

      it 'correctly segments text #080' do
        ps = PragmaticSegmenter::Segmenter.new(text: "She turned to him, “This is great.” She held the book out to show him.", language: 'en')
        expect(ps.segment).to eq(["She turned to him, “This is great.”", "She held the book out to show him."])
      end
    end
  end

  context 'Language: Japanese (ja)' do
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

  context 'Language: Arabic (ar)' do
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

  context 'Language: Italian (it)' do
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

  context 'Language: Russian (ru)' do
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

  context 'Language: German (de)' do
    # Thanks to Silvia Busse for the German test examples.
    describe '#segment' do
      it 'correctly segments text #001' do
        ps = PragmaticSegmenter::Segmenter.new(text: "\n   \n\n   http:www.babycentre.co.uk/midwives \n\n \n\n \n\n10 steps to a healthy pregnancy (German) \n\n10 Schritte zu einer gesunden Schwangerschaft \n \n• 1. Planen und organisieren Sie die Zeit der Schwangerschaft frühzeitig! \n• 2. Essen Sie gesund! \n• 3. Seien Sie achtsam bei der Auswahl der Nahrungsmittel! \n• 4. Nehmen Sie zusätzlich Folsäurepräparate und essen Sie Fisch! \n• 5. Treiben Sie regelmäßig Sport! \n• 6. Beginnen Sie mit Übungen für die Beckenbodenmuskulatur! \n• 7. Reduzieren Sie Ihren Alkoholgenuss! \n• 8. Reduzieren Sie Ihren Koffeingenuß! \n• 9. Hören Sie mit dem Rauchen auf! \n• 10. Gönnen Sie sich Erholung! \n \n \nZehn einfach zu befolgende Tipps sollen Ihnen helfen, eine möglichst problemlose \nSchwangerschaft zu erleben und ein gesundes Baby auf die Welt zu bringen:  \n\n1. Planen und organisieren Sie die Zeit der Schwangerschaft frühzeitig!", language: 'de', doc_type: 'pdf')
        expect(ps.segment).to eq(["http:www.babycentre.co.uk/midwives", "10 steps to a healthy pregnancy (German)", "10 Schritte zu einer gesunden Schwangerschaft", "• 1. Planen und organisieren Sie die Zeit der Schwangerschaft frühzeitig!", "• 2. Essen Sie gesund!", "• 3. Seien Sie achtsam bei der Auswahl der Nahrungsmittel!", "• 4. Nehmen Sie zusätzlich Folsäurepräparate und essen Sie Fisch!", "• 5. Treiben Sie regelmäßig Sport!", "• 6. Beginnen Sie mit Übungen für die Beckenbodenmuskulatur!", "• 7. Reduzieren Sie Ihren Alkoholgenuss!", "• 8. Reduzieren Sie Ihren Koffeingenuß!", "• 9. Hören Sie mit dem Rauchen auf!", "• 10. Gönnen Sie sich Erholung!", "Zehn einfach zu befolgende Tipps sollen Ihnen helfen, eine möglichst problemlose Schwangerschaft zu erleben und ein gesundes Baby auf die Welt zu bringen:", "1. Planen und organisieren Sie die Zeit der Schwangerschaft frühzeitig!"])
      end

      it 'correctly segments text #002' do
        ps = PragmaticSegmenter::Segmenter.new(text: '„Ich habe heute keine Zeit“, sagte die Frau und flüsterte leise: „Und auch keine Lust.“ Wir haben 1.000.000 Euro.', language: 'de')
        expect(ps.segment).to eq(["„Ich habe heute keine Zeit“, sagte die Frau und flüsterte leise: „Und auch keine Lust.“", "Wir haben 1.000.000 Euro."])
      end

      it 'correctly segments text #003' do
        ps = PragmaticSegmenter::Segmenter.new(text: 'Thomas sagte: ,,Wann kommst zu mir?” ,,Das weiß ich noch nicht“, antwortete Susi, ,,wahrscheinlich am Sonntag.“ Wir haben 1.000.000 Euro.', language: 'de')
        expect(ps.segment).to eq(["Thomas sagte: ,,Wann kommst zu mir?” ,,Das weiß ich noch nicht“, antwortete Susi, ,,wahrscheinlich am Sonntag.“", "Wir haben 1.000.000 Euro."])
      end

      it 'correctly segments text #004' do
        ps = PragmaticSegmenter::Segmenter.new(text: '„Lass uns jetzt essen gehen!“, sagte die Mutter zu ihrer Freundin, „am besten zum Italiener.“', language: 'de')
        expect(ps.segment).to eq(['„Lass uns jetzt essen gehen!“, sagte die Mutter zu ihrer Freundin, „am besten zum Italiener.“'])
      end

      it 'correctly segments text #005' do
        ps = PragmaticSegmenter::Segmenter.new(text: 'Wir haben 1.000.000 Euro.', language: 'de')
        expect(ps.segment).to eq(['Wir haben 1.000.000 Euro.'])
      end

      it 'correctly segments text #006' do
        ps = PragmaticSegmenter::Segmenter.new(text: 'Sie bekommen 3,50 Euro zurück.', language: 'de')
        expect(ps.segment).to eq(['Sie bekommen 3,50 Euro zurück.'])
      end

      it 'correctly segments text #007' do
        ps = PragmaticSegmenter::Segmenter.new(text: 'Dafür brauchen wir 5,5 Stunden.', language: 'de')
        expect(ps.segment).to eq(['Dafür brauchen wir 5,5 Stunden.'])
      end

      it 'correctly segments text #008' do
        ps = PragmaticSegmenter::Segmenter.new(text: 'Bitte überweisen Sie 5.300,25 Euro.', language: 'de')
        expect(ps.segment).to eq(['Bitte überweisen Sie 5.300,25 Euro.'])
      end

      it 'correctly segments text #009' do
        ps = PragmaticSegmenter::Segmenter.new(text: '1. Dies ist eine Punkteliste.', language: 'de')
        expect(ps.segment).to eq(['1. Dies ist eine Punkteliste.'])
      end

      it 'correctly segments text #010' do
        ps = PragmaticSegmenter::Segmenter.new(text: 'Wir trafen Dr. med. Meyer in der Stadt.', language: 'de')
        expect(ps.segment).to eq(['Wir trafen Dr. med. Meyer in der Stadt.'])
      end

      it 'correctly segments text #011' do
        ps = PragmaticSegmenter::Segmenter.new(text: 'Wir brauchen Getränke, z. B. Wasser, Saft, Bier usw.', language: 'de')
        expect(ps.segment).to eq(['Wir brauchen Getränke, z. B. Wasser, Saft, Bier usw.'])
      end

      it 'correctly segments text #012' do
        ps = PragmaticSegmenter::Segmenter.new(text: 'Ich kann u.a. Spanisch sprechen.', language: 'de')
        expect(ps.segment).to eq(['Ich kann u.a. Spanisch sprechen.'])
      end

      it 'correctly segments text #013' do
        ps = PragmaticSegmenter::Segmenter.new(text: 'Frau Prof. Schulze ist z. Z. nicht da.', language: 'de')
        expect(ps.segment).to eq(['Frau Prof. Schulze ist z. Z. nicht da.'])
      end

      it 'correctly segments text #014' do
        ps = PragmaticSegmenter::Segmenter.new(text: 'Sie erhalten ein neues Bank-Statement bzw. ein neues Schreiben.', language: 'de')
        expect(ps.segment).to eq(['Sie erhalten ein neues Bank-Statement bzw. ein neues Schreiben.'])
      end

      it 'correctly segments text #015' do
        ps = PragmaticSegmenter::Segmenter.new(text: 'Z. T. ist die Lieferung unvollständig.', language: 'de')
        expect(ps.segment).to eq(['Z. T. ist die Lieferung unvollständig.'])
      end

      it 'correctly segments text #016' do
        ps = PragmaticSegmenter::Segmenter.new(text: 'Das finden Sie auf S. 225.', language: 'de')
        expect(ps.segment).to eq(['Das finden Sie auf S. 225.'])
      end

      it 'correctly segments text #017' do
        ps = PragmaticSegmenter::Segmenter.new(text: 'Sie besucht eine kath. Schule.', language: 'de')
        expect(ps.segment).to eq(['Sie besucht eine kath. Schule.'])
      end

      it 'correctly segments text #018' do
        ps = PragmaticSegmenter::Segmenter.new(text: 'Wir benötigen Zeitungen, Zeitschriften u. Ä. für unser Projekt.', language: 'de')
        expect(ps.segment).to eq(['Wir benötigen Zeitungen, Zeitschriften u. Ä. für unser Projekt.'])
      end

      it 'correctly segments text #019' do
        ps = PragmaticSegmenter::Segmenter.new(text: 'Das steht auf S. 23, s. vorherige Anmerkung.', language: 'de')
        expect(ps.segment).to eq(['Das steht auf S. 23, s. vorherige Anmerkung.'])
      end

      it 'correctly segments text #020' do
        ps = PragmaticSegmenter::Segmenter.new(text: 'Dies ist meine Adresse: Dr. Meier, Berliner Str. 5, 21234 Bremen.', language: 'de')
        expect(ps.segment).to eq(['Dies ist meine Adresse: Dr. Meier, Berliner Str. 5, 21234 Bremen.'])
      end

      it 'correctly segments text #021' do
        ps = PragmaticSegmenter::Segmenter.new(text: 'Er sagte: „Hallo, wie geht´s Ihnen, Frau Prof. Müller?“', language: 'de')
        expect(ps.segment).to eq(['Er sagte: „Hallo, wie geht´s Ihnen, Frau Prof. Müller?“'])
      end

      it 'correctly segments text #022' do
        ps = PragmaticSegmenter::Segmenter.new(text: "Fit in vier Wochen\n\nDeine Anleitung für eine reine Ernährung und ein gesünderes und glücklicheres Leben\n\nRECHTLICHE HINWEISE\n\nOhne die ausdrückliche schriftliche Genehmigung der Eigentümerin von instafemmefitness, Anna Anderson, darf dieses E-Book weder teilweise noch in vollem Umfang reproduziert, gespeichert, kopiert oder auf irgendeine Weise übertragen werden. Wenn Du das E-Book auf einem öffentlich zugänglichen Computer ausdruckst, musst Du es nach dem Ausdrucken von dem Computer löschen. Jedes E-Book wird mit einem Benutzernamen und Transaktionsinformationen versehen.\n\nVerstöße gegen dieses Urheberrecht werden im vollen gesetzlichen Umfang geltend gemacht. Obgleich die Autorin und Herausgeberin alle Anstrengungen unternommen hat, sicherzustellen, dass die Informationen in diesem Buch zum Zeitpunkt der Drucklegung korrekt sind, übernimmt die Autorin und Herausgeberin keine Haftung für etwaige Verluste, Schäden oder Störungen, die durch Fehler oder Auslassungen in Folge von Fahrlässigkeit, zufälligen Umständen oder sonstigen Ursachen entstehen, und lehnt hiermit jedwede solche Haftung ab.\n\nDieses Buch ist kein Ersatz für die medizinische Beratung durch Ärzte. Der Leser/die Leserin sollte regelmäßig einen Arzt/eine Ärztin hinsichtlich Fragen zu seiner/ihrer Gesundheit und vor allem in Bezug auf Symptome, die eventuell einer ärztlichen Diagnose oder Behandlung bedürfen, konsultieren.\n\nDie Informationen in diesem Buch sind dazu gedacht, ein ordnungsgemäßes Training zu ergänzen, nicht aber zu ersetzen. Wie jeder andere Sport, der Geschwindigkeit, Ausrüstung, Gleichgewicht und Umweltfaktoren einbezieht, stellt dieser Sport ein gewisses Risiko dar. Die Autorin und Herausgeberin rät den Lesern dazu, die volle Verantwortung für die eigene Sicherheit zu übernehmen und die eigenen Grenzen zu beachten. Vor dem Ausüben der in diesem Buch beschriebenen Übungen solltest Du sicherstellen, dass Deine Ausrüstung in gutem Zustand ist, und Du solltest keine Risiken außerhalb Deines Erfahrungs- oder Trainingsniveaus, Deiner Fähigkeiten oder Deines Komfortbereichs eingehen.\nHintergrundillustrationen Urheberrecht © 2013 bei Shuttershock, Buchgestaltung und -produktion durch Anna Anderson Verfasst von Anna Anderson\nUrheberrecht © 2014 Instafemmefitness. Alle Rechte vorbehalten\n\nÜber mich", language: 'de')
        expect(ps.segment).to eq(["Fit in vier Wochen", "Deine Anleitung für eine reine Ernährung und ein gesünderes und glücklicheres Leben", "RECHTLICHE HINWEISE", "Ohne die ausdrückliche schriftliche Genehmigung der Eigentümerin von instafemmefitness, Anna Anderson, darf dieses E-Book weder teilweise noch in vollem Umfang reproduziert, gespeichert, kopiert oder auf irgendeine Weise übertragen werden.", "Wenn Du das E-Book auf einem öffentlich zugänglichen Computer ausdruckst, musst Du es nach dem Ausdrucken von dem Computer löschen.", "Jedes E-Book wird mit einem Benutzernamen und Transaktionsinformationen versehen.", "Verstöße gegen dieses Urheberrecht werden im vollen gesetzlichen Umfang geltend gemacht.", "Obgleich die Autorin und Herausgeberin alle Anstrengungen unternommen hat, sicherzustellen, dass die Informationen in diesem Buch zum Zeitpunkt der Drucklegung korrekt sind, übernimmt die Autorin und Herausgeberin keine Haftung für etwaige Verluste, Schäden oder Störungen, die durch Fehler oder Auslassungen in Folge von Fahrlässigkeit, zufälligen Umständen oder sonstigen Ursachen entstehen, und lehnt hiermit jedwede solche Haftung ab.", "Dieses Buch ist kein Ersatz für die medizinische Beratung durch Ärzte.", "Der Leser/die Leserin sollte regelmäßig einen Arzt/eine Ärztin hinsichtlich Fragen zu seiner/ihrer Gesundheit und vor allem in Bezug auf Symptome, die eventuell einer ärztlichen Diagnose oder Behandlung bedürfen, konsultieren.", "Die Informationen in diesem Buch sind dazu gedacht, ein ordnungsgemäßes Training zu ergänzen, nicht aber zu ersetzen.", "Wie jeder andere Sport, der Geschwindigkeit, Ausrüstung, Gleichgewicht und Umweltfaktoren einbezieht, stellt dieser Sport ein gewisses Risiko dar.", "Die Autorin und Herausgeberin rät den Lesern dazu, die volle Verantwortung für die eigene Sicherheit zu übernehmen und die eigenen Grenzen zu beachten.", "Vor dem Ausüben der in diesem Buch beschriebenen Übungen solltest Du sicherstellen, dass Deine Ausrüstung in gutem Zustand ist, und Du solltest keine Risiken außerhalb Deines Erfahrungs- oder Trainingsniveaus, Deiner Fähigkeiten oder Deines Komfortbereichs eingehen.", "Hintergrundillustrationen Urheberrecht © 2013 bei Shuttershock, Buchgestaltung und -produktion durch Anna Anderson Verfasst von Anna Anderson", "Urheberrecht © 2014 Instafemmefitness.", "Alle Rechte vorbehalten", "Über mich"])
      end

      it 'correctly segments text #023' do
        ps = PragmaticSegmenter::Segmenter.new(text: "Es gibt jedoch einige Vorsichtsmaßnahmen, die Du ergreifen kannst, z. B. ist es sehr empfehlenswert, dass Du Dein Zuhause von allem Junkfood befreist. Ich persönlich kaufe kein Junkfood oder etwas, das nicht rein ist (ich traue mir da selbst nicht!). Ich finde jeden Vorwand, um das Junkfood zu essen, vor allem die Vorstellung, dass ich nicht mehr in Versuchung kommen werde, wenn ich es jetzt aufesse und es weg ist. Es ist schon komisch, was unser Verstand mitunter anstellt!", language: 'de')
        expect(ps.segment).to eq(["Es gibt jedoch einige Vorsichtsmaßnahmen, die Du ergreifen kannst, z. B. ist es sehr empfehlenswert, dass Du Dein Zuhause von allem Junkfood befreist.", "Ich persönlich kaufe kein Junkfood oder etwas, das nicht rein ist (ich traue mir da selbst nicht!).", "Ich finde jeden Vorwand, um das Junkfood zu essen, vor allem die Vorstellung, dass ich nicht mehr in Versuchung kommen werde, wenn ich es jetzt aufesse und es weg ist.", "Es ist schon komisch, was unser Verstand mitunter anstellt!"])
      end

      it 'correctly segments text #024' do
        ps = PragmaticSegmenter::Segmenter.new(text: "Ob Sie in Hannover nur auf der Durchreise, für einen längeren Aufenthalt oder zum Besuch einer der zahlreichen Messen sind: Die Hauptstadt des Landes Niedersachsens hat viele Sehenswürdigkeiten und ist zu jeder Jahreszeit eine Reise Wert. \nHannovers Ursprünge können bis zur römischen Kaiserzeit zurückverfolgt werden, und zwar durch Ausgrabungen von Tongefäßen aus dem 1. -3. Jahrhundert nach Christus, die an mehreren Stellen im Untergrund des Stadtzentrums durchgeführt wurden.", language: 'de')
        expect(ps.segment).to eq(["Ob Sie in Hannover nur auf der Durchreise, für einen längeren Aufenthalt oder zum Besuch einer der zahlreichen Messen sind: Die Hauptstadt des Landes Niedersachsens hat viele Sehenswürdigkeiten und ist zu jeder Jahreszeit eine Reise Wert.", "Hannovers Ursprünge können bis zur römischen Kaiserzeit zurückverfolgt werden, und zwar durch Ausgrabungen von Tongefäßen aus dem 1. -3. Jahrhundert nach Christus, die an mehreren Stellen im Untergrund des Stadtzentrums durchgeführt wurden."])
      end

      it 'correctly segments text #025' do
        ps = PragmaticSegmenter::Segmenter.new(text: "• 3. Seien Sie achtsam bei der Auswahl der Nahrungsmittel! \n• 4. Nehmen Sie zusätzlich Folsäurepräparate und essen Sie Fisch! \n• 5. Treiben Sie regelmäßig Sport! \n• 6. Beginnen Sie mit Übungen für die Beckenbodenmuskulatur! \n• 7. Reduzieren Sie Ihren Alkoholgenuss! \n", language: 'de')
        expect(ps.segment).to eq(["• 3. Seien Sie achtsam bei der Auswahl der Nahrungsmittel!", "• 4. Nehmen Sie zusätzlich Folsäurepräparate und essen Sie Fisch!", "• 5. Treiben Sie regelmäßig Sport!", "• 6. Beginnen Sie mit Übungen für die Beckenbodenmuskulatur!", "• 7. Reduzieren Sie Ihren Alkoholgenuss!"])
      end

      it 'correctly segments text #026' do
        ps = PragmaticSegmenter::Segmenter.new(text: "Schwangere Frauen sollten während der \nersten drei Monate eine tägliche Dosis von 400 Mikrogramm Folsäure zusätzlich nehmen. \nFolsäure befindet sich auch in einigen Gemüse- und Müslisorten.", language: 'de', doc_type: 'pdf')
        expect(ps.segment).to eq(["Schwangere Frauen sollten während der ersten drei Monate eine tägliche Dosis von 400 Mikrogramm Folsäure zusätzlich nehmen.", "Folsäure befindet sich auch in einigen Gemüse- und Müslisorten."])
      end

      it 'correctly segments text #027' do
        ps = PragmaticSegmenter::Segmenter.new(text: "Andere \nFischsorten (z.B. Hai, Thunfisch, Aal und Seeteufel) weisen einen erhöhten Quecksilbergehalt \nauf und sollten deshalb in der Schwangerschaft nur selten verzehrt werden.", language: 'de', doc_type: 'pdf')
        expect(ps.segment).to eq(["Andere Fischsorten (z.B. Hai, Thunfisch, Aal und Seeteufel) weisen einen erhöhten Quecksilbergehalt auf und sollten deshalb in der Schwangerschaft nur selten verzehrt werden."])
      end

      it 'correctly segments text #028' do
        ps = PragmaticSegmenter::Segmenter.new(text: "Übung Präsens\n1. Ich ___ gern Tennis.\nspielen\nspielt\nspiele\n2. Karl __ mir den Ball.\ngebt\ngibt\ngeben\n3. Ihr ___ fast jeden Tag.\narbeitet\narbeite\narbeiten\n4. ___ Susi Deutsch?\nSprichst\nSprecht\nSpricht\n5. Wann ___ Karl und Julia? Heute?\nkommen\nkommt\nkomme\n\n\n\n\n", language: 'de', doc_type: 'docx')
        expect(ps.segment).to eq(["Übung Präsens", "1. Ich ___ gern Tennis.", "spielen", "spielt", "spiele", "2. Karl __ mir den Ball.", "gebt", "gibt", "geben", "3. Ihr ___ fast jeden Tag.", "arbeitet", "arbeite", "arbeiten", "4. ___ Susi Deutsch?", "Sprichst", "Sprecht", "Spricht", "5. Wann ___ Karl und Julia?", "Heute?", "kommen", "kommt", "komme"])
      end

      it 'correctly segments text #029' do
        ps = PragmaticSegmenter::Segmenter.new(text: "\n• einige Sorten Weichkäse  \n• rohes oder nicht ganz durchgebratenes Fleisch  \n• ungeputztes Gemüse und ungewaschener Salat  \n• nicht ganz durchgebratenes Hühnerfleisch, rohe oder nur weich gekochte Eier", language: 'de', doc_type: 'pdf')
        expect(ps.segment).to eq(["• einige Sorten Weichkäse", "• rohes oder nicht ganz durchgebratenes Fleisch", "• ungeputztes Gemüse und ungewaschener Salat", "• nicht ganz durchgebratenes Hühnerfleisch, rohe oder nur weich gekochte Eier"])
      end

      it 'correctly segments text #030' do
        ps = PragmaticSegmenter::Segmenter.new(text: "Was sind die Konsequenzen der Abstimmung vom 12. Juni?", language: 'de')
        expect(ps.segment).to eq(["Was sind die Konsequenzen der Abstimmung vom 12. Juni?"])
      end

      it 'correctly segments text #031' do
        ps = PragmaticSegmenter::Segmenter.new(text: "Was pro Jahr10. Zudem pro Jahr um 0.3 %11. Der gängigen Theorie nach erfolgt der Anstieg.", language: 'de')
        expect(ps.segment).to eq(["Was pro Jahr10.", "Zudem pro Jahr um 0.3 %11.", "Der gängigen Theorie nach erfolgt der Anstieg."])
      end

      it 'correctly segments text #032' do
        ps = PragmaticSegmenter::Segmenter.new(text: "s. vorherige Anmerkung.", language: 'de')
        expect(ps.segment).to eq(["s. vorherige Anmerkung."])
      end
    end
  end

  context 'Language: Spanish (es)' do
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

  context 'Language: Hindi (hi)' do
    describe '#segment' do
      it 'correctly segments text #001' do
        ps = PragmaticSegmenter::Segmenter.new(text: "सच्चाई यह है कि इसे कोई नहीं जानता। हो सकता है यह फ़्रेन्को के खिलाफ़ कोई विद्रोह रहा हो, या फिर बेकाबू हो गया कोई आनंदोत्सव।", language: 'hi')
        expect(ps.segment).to eq(["सच्चाई यह है कि इसे कोई नहीं जानता।", "हो सकता है यह फ़्रेन्को के खिलाफ़ कोई विद्रोह रहा हो, या फिर बेकाबू हो गया कोई आनंदोत्सव।"])
      end
    end
  end

  context 'Language: Greek (el)' do
    describe '#segment' do
      it 'correctly segments text #001' do
        ps = PragmaticSegmenter::Segmenter.new(text: "Με συγχωρείτε· πού είναι οι τουαλέτες; Τις Κυριακές δε δούλευε κανένας. το κόστος του σπιτιού ήταν £260.950,00.", language: 'el')
        expect(ps.segment).to eq(["Με συγχωρείτε· πού είναι οι τουαλέτες;", "Τις Κυριακές δε δούλευε κανένας.", "το κόστος του σπιτιού ήταν £260.950,00."])
      end
    end
  end

  context 'Language: French (fr)' do
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

  context 'Language: Armenian (hy)' do
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

  context 'Language: Burmese (my)' do
    describe '#segment' do
      it 'correctly segments text #001' do
        ps = PragmaticSegmenter::Segmenter.new(text: "ခင္ဗ်ားနာမည္ဘယ္လိုေခၚလဲ။၇ွင္ေနေကာင္းလား။", language: 'my')
        expect(ps.segment).to eq(["ခင္ဗ်ားနာမည္ဘယ္လိုေခၚလဲ။", "၇ွင္ေနေကာင္းလား။"])
      end
    end
  end

  context 'Language: Amharic (am)' do
    describe '#segment' do
      it 'correctly segments text #001' do
        ps = PragmaticSegmenter::Segmenter.new(text: "እንደምን አለህ፧መልካም ቀን ይሁንልህ።እባክሽ ያልሽዉን ድገሚልኝ።", language: 'am')
        expect(ps.segment).to eq(["እንደምን አለህ፧", "መልካም ቀን ይሁንልህ።", "እባክሽ ያልሽዉን ድገሚልኝ።"])
      end
    end
  end

  context 'Language: Persian (fa)' do
    describe '#segment' do
      it 'correctly segments text #001' do
        ps = PragmaticSegmenter::Segmenter.new(text: "خوشبختم، آقای رضا. شما کجایی هستید؟ من از تهران هستم.", language: 'fa')
        expect(ps.segment).to eq(["خوشبختم، آقای رضا.", "شما کجایی هستید؟", "من از تهران هستم."])
      end
    end
  end

  context 'Language: Urdu (ur)' do
    describe '#segment' do
      it 'correctly segments text #001' do
        ps = PragmaticSegmenter::Segmenter.new(text: "کیا حال ہے؟ ميرا نام ___ ەے۔ میں حالا تاوان دےدوں؟", language: 'ur')
        expect(ps.segment).to eq(["کیا حال ہے؟", "ميرا نام ___ ەے۔", "میں حالا تاوان دےدوں؟"])
      end
    end
  end

  context 'Language: Chinese (zh)' do
    describe '#segment' do
      it 'correctly segments text #001' do
        ps = PragmaticSegmenter::Segmenter.new(text: "安永已聯繫周怡安親屬，協助辦理簽證相關事宜，周怡安家屬1月1日晚間搭乘東方航空班機抵達上海，他們步入入境大廳時神情落寞、不發一語。周怡安來自台中，去年剛從元智大學畢業，同年9月加入安永。", language: 'zh')
        expect(ps.segment).to eq(["安永已聯繫周怡安親屬，協助辦理簽證相關事宜，周怡安家屬1月1日晚間搭乘東方航空班機抵達上海，他們步入入境大廳時神情落寞、不發一語。", "周怡安來自台中，去年剛從元智大學畢業，同年9月加入安永。"])
      end
    end
  end

  context 'miscellaneous tests' do
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


    end

    describe '#clean' do
      it 'cleans the text' do
        ps = PragmaticSegmenter::Cleaner.new(text: "It was a cold \nnight in the city.", language: "en")
        expect(ps.clean).to eq("It was a cold night in the city.")
      end

      it 'does not mutate the input string (cleaner)' do
        text = "It was a cold \nnight in the city."
        PragmaticSegmenter::Cleaner.new(text: text, language: "en").clean
        expect(text).to eq("It was a cold \nnight in the city.")
      end
    end
  end
end
