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

    it "A.M. / P.M. as non sentence boundary and sentence boundary #018" do
      skip "NOT IMPLEMENTED"
      ps = PragmaticSegmenter::Segmenter.new(text: "At 5 a.m. Mr. Smith went to the bank. He left the bank at 6 P.M. Mr. Smith then went to the store.", language: "en")
      expect(ps.segment).to eq(["At 5 a.m. Mr. Smith went to the bank.", "He left the bank at 6 P.M.", "Mr. Smith then went to the store."])
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

    it "No whitespace in between sentences #052" do
      ps = PragmaticSegmenter::Segmenter.new(text: "Hello world.Today is Tuesday.Mr. Smith went to the store and bought 1,000.That is a lot.", language: "en")
      expect(ps.segment).to eq(["Hello world.", "Today is Tuesday.", "Mr. Smith went to the store and bought 1,000.", "That is a lot."])
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

    context "Golden Rules (Dutch)" do
      it "Sentence starting with a number #001" do
        ps = PragmaticSegmenter::Segmenter.new(text: "Hij schoot op de JP8-brandstof toen de Surface-to-Air (sam)-missiles op hem af kwamen. 81 procent van de schoten was raak.", language: 'nl')
        expect(ps.segment).to eq(["Hij schoot op de JP8-brandstof toen de Surface-to-Air (sam)-missiles op hem af kwamen.", "81 procent van de schoten was raak."])
      end

      it "Sentence starting with an ellipsis #002" do
        ps = PragmaticSegmenter::Segmenter.new(text: "81 procent van de schoten was raak. ...en toen barste de hel los.", language: 'nl')
        expect(ps.segment).to eq(["81 procent van de schoten was raak.", "...en toen barste de hel los."])
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

      it 'correctly segments text #081' do
        ps = PragmaticSegmenter::Segmenter.new(text: "////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////Header starts here\r////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////", language: 'en')
        expect(ps.segment).to eq(["Header starts here"])
      end

      it 'correctly segments text #082' do
        ps = PragmaticSegmenter::Segmenter.new(text: 'Hello World. \r\n Hello.', language: 'en')
        expect(ps.segment).to eq(["Hello World.", "Hello."])
      end

      it 'correctly segments text #082' do
        ps = PragmaticSegmenter::Segmenter.new(text: 'Hello World. \ r \ nHello.', language: 'en')
        expect(ps.segment).to eq(["Hello World.", "Hello."])
      end

      it "correctly segments text #083" do
        ps = PragmaticSegmenter::Segmenter.new(text: "The nurse gave him the i.v. in his vein. She gave him the i.v. It was a great I.V. that she gave him. She gave him the I.V. It was night.", language: "en")
        expect(ps.segment).to eq(["The nurse gave him the i.v. in his vein.", "She gave him the i.v.", "It was a great I.V. that she gave him.", "She gave him the I.V.", "It was night."])
      end

      it "correctly segments text #084" do
        ps = PragmaticSegmenter::Segmenter.new(text: "(i) Hello world. \n(ii) Hello world.\n(iii) Hello world.\n(iv) Hello world.\n(v) Hello world.\n(vi) Hello world.", language: "en")
        expect(ps.segment).to eq(["(i) Hello world.", "(ii) Hello world.", "(iii) Hello world.", "(iv) Hello world.", "(v) Hello world.", "(vi) Hello world."])
      end

      it "correctly segments text #085" do
        ps = PragmaticSegmenter::Segmenter.new(text: "i) Hello world. \nii) Hello world.\niii) Hello world.\niv) Hello world.\nv) Hello world.\nvi) Hello world.", language: "en")
        expect(ps.segment).to eq(["i) Hello world.", "ii) Hello world.", "iii) Hello world.", "iv) Hello world.", "v) Hello world.", "vi) Hello world."])
      end

      it "correctly segments text #086" do
        ps = PragmaticSegmenter::Segmenter.new(text: "(a) Hello world. (b) Hello world. (c) Hello world. (d) Hello world. (e) Hello world.\n(f) Hello world.", language: "en")
        expect(ps.segment).to eq(["(a) Hello world.", "(b) Hello world.", "(c) Hello world.", "(d) Hello world.", "(e) Hello world.", "(f) Hello world."])
      end

      it "correctly segments text #087" do
        ps = PragmaticSegmenter::Segmenter.new(text: "(A) Hello world. \n(B) Hello world.\n(C) Hello world.\n(D) Hello world.\n(E) Hello world.\n(F) Hello world.", language: "en")
        expect(ps.segment).to eq(["(A) Hello world.", "(B) Hello world.", "(C) Hello world.", "(D) Hello world.", "(E) Hello world.", "(F) Hello world."])
      end

      it "correctly segments text #088" do
        ps = PragmaticSegmenter::Segmenter.new(text: "A) Hello world. \nB) Hello world.\nC) Hello world.\nD) Hello world.\nE) Hello world.\nF) Hello world.", language: "en")
        expect(ps.segment).to eq(["A) Hello world.", "B) Hello world.", "C) Hello world.", "D) Hello world.", "E) Hello world.", "F) Hello world."])
      end

      it "correctly segments text #089" do
        ps = PragmaticSegmenter::Segmenter.new(text: "The GmbH & Co. KG is a limited partnership with, typically, the sole general partner being a limited liability company.")
        expect(ps.segment).to eq(["The GmbH & Co. KG is a limited partnership with, typically, the sole general partner being a limited liability company."])
      end

      it "correctly segments text #090" do
        ps = PragmaticSegmenter::Segmenter.new(text: "[?][footnoteRef:6] This is a footnote.")
        expect(ps.segment).to eq(["[?][footnoteRef:6] This is a footnote."])
      end

      it "correctly segments text #091" do
        ps = PragmaticSegmenter::Segmenter.new(text: "[15:  12:32]  [16:  firma? 13:28]")
        expect(ps.segment).to eq(["[15:  12:32]  [16:  firma? 13:28]"])
      end

      it "correctly segments text #092" do
        ps = PragmaticSegmenter::Segmenter.new(text: "\"It's a good thing that the water is really calm,\" I answered ironically.")
        expect(ps.segment).to eq(["\"It's a good thing that the water is really calm,\" I answered ironically."])
      end

      it "correctly segments text #093" do
        ps = PragmaticSegmenter::Segmenter.new(text: "December 31, 1988. Hello world. It's great! \nBorn April 05, 1989.")
        expect(ps.segment).to eq(["December 31, 1988.", "Hello world.", "It's great!", "Born April 05, 1989."])
      end

      it 'correctly segments text #094' do
        text = <<-EOF
          DOWN THE RABBIT-HOLE

          Alice was beginning to get very tired of sitting by her sister on the bank, and of having nothing to do. Once or twice she had peeped into the book her sister was reading, but it had no pictures or conversations in it, "and what is the use of a book," thought Alice, "without pictures or conversations?"

          So she was considering in her own mind (as well as she could, for the day made her feel very sleepy and stupid), whether the pleasure of making a daisy-chain would be worth the trouble of getting up and picking the daisies, when suddenly a White Rabbit with pink eyes ran close by her.

          There was nothing so very remarkable in that, nor did Alice think it so very much out of the way to hear the Rabbit say to itself, "Oh dear! Oh dear! I shall be too late!" But when the Rabbit actually took a watch out of its waistcoat-pocket and looked at it and then hurried on, Alice started to her feet, for it flashed across her mind that she had never before seen a rabbit with either a waistcoat-pocket, or a watch to take out of it, and, burning with curiosity, she ran across the field after it and was just in time to see it pop down a large rabbit-hole, under the hedge. In another moment, down went Alice after it!

          The rabbit-hole went straight on like a tunnel for some way and then dipped suddenly down, so suddenly that Alice had not a moment to think about stopping herself before she found herself falling down what seemed to be a very deep well.

          Either the well was very deep, or she fell very slowly, for she had plenty of time, as she went down, to look about her. First, she tried to make out what she was coming to, but it was too dark to see anything; then she looked at the sides of the well and noticed that they were filled with cupboards and book-shelves; here and there she saw maps and pictures hung upon pegs. She took down a jar from one of the shelves as she passed. It was labeled "ORANGE MARMALADE," but, to her great disappointment, it was empty; she did not like to drop the jar, so managed to put it into one of the cupboards as she fell past it.

          Down, down, down! Would the fall never come to an end? There was nothing else to do, so Alice soon began talking to herself. "Dinah'll miss me very much to-night, I should think!" (Dinah was the cat.) "I hope they'll remember her saucer of milk at tea-time. Dinah, my dear, I wish you were down here with me!" Alice felt that she was dozing off, when suddenly, thump! thump! down she came upon a heap of sticks and dry leaves, and the fall was over.

          Alice was not a bit hurt, and she jumped up in a moment. She looked up, but it was all dark overhead; before her was another long passage and the White Rabbit was still in sight, hurrying down it. There was not a moment to be lost. Away went Alice like the wind and was just in time to hear it say, as it turned a corner, "Oh, my ears and whiskers, how late it's getting!" She was close behind it when she turned the corner, but the Rabbit was no longer to be seen.

          She found herself in a long, low hall, which was lit up by a row of lamps hanging from the roof. There were doors all 'round the hall, but they were all locked; and when Alice had been all the way down one side and up the other, trying every door, she walked sadly down the middle, wondering how she was ever to get out again.

          Suddenly she came upon a little table, all made of solid glass. There was nothing on it but a tiny golden key, and Alice's first idea was that this might belong to one of the doors of the hall; but, alas! either the locks were too large, or the key was too small, but, at any rate, it would not open any of them. However, on the second time 'round, she came upon a low curtain she had not noticed before, and behind it was a little door about fifteen inches high. She tried the little golden key in the lock, and to her great delight, it fitted!

          Alice opened the door and found that it led into a small passage, not much larger than a rat-hole; she knelt down and looked along the passage into the loveliest garden you ever saw. How she longed to get out of that dark hall and wander about among those beds of bright flowers and those cool fountains, but she could not even get her head through the doorway. "Oh," said Alice, "how I wish I could shut up like a telescope! I think I could, if I only knew how to begin."

          Alice went back to the table, half hoping she might find another key on it, or at any rate, a book of rules for shutting people up like telescopes. This time she found a little bottle on it ("which certainly was not here before," said Alice), and tied 'round the neck of the bottle was a paper label, with the words "DRINK ME" beautifully printed on it in large letters.

          "No, I'll look first," she said, "and see whether it's marked '_poison_' or not," for she had never forgotten that, if you drink from a bottle marked "poison," it is almost certain to disagree with you, sooner or later. However, this bottle was _not_ marked "poison," so Alice ventured to taste it, and, finding it very nice (it had a sort of mixed flavor of cherry-tart, custard, pineapple, roast turkey, toffy and hot buttered toast), she very soon finished it off.

                 *       *       *       *       *

          "What a curious feeling!" said Alice. "I must be shutting up like a telescope!"

          And so it was indeed! She was now only ten inches high, and her face brightened up at the thought that she was now the right size for going through the little door into that lovely garden.

          After awhile, finding that nothing more happened, she decided on going into the garden at once; but, alas for poor Alice! When she got to the door, she found she had forgotten the little golden key, and when she went back to the table for it, she found she could not possibly reach it: she could see it quite plainly through the glass and she tried her best to climb up one of the legs of the table, but it was too slippery, and when she had tired herself out with trying, the poor little thing sat down and cried.

          "Come, there's no use in crying like that!" said Alice to herself rather sharply. "I advise you to leave off this minute!" She generally gave herself very good advice (though she very seldom followed it), and sometimes she scolded herself so severely as to bring tears into her eyes.

          Soon her eye fell on a little glass box that was lying under the table: she opened it and found in it a very small cake, on which the words "EAT ME" were beautifully marked in currants. "Well, I'll eat it," said Alice, "and if it makes me grow larger, I can reach the key; and if it makes me grow smaller, I can creep under the door: so either way I'll get into the garden, and I don't care which happens!"

          She ate a little bit and said anxiously to herself, "Which way? Which way?" holding her hand on the top of her head to feel which way she was growing; and she was quite surprised to find that she remained the same size. So she set to work and very soon finished off the cake.

          II--THE POOL OF TEARS

          "Curiouser and curiouser!" cried Alice (she was so much surprised that for the moment she quite forgot how to speak good English). "Now I'm opening out like the largest telescope that ever was! Good-by, feet! Oh, my poor little feet, I wonder who will put on your shoes and stockings for you now, dears? I shall be a great deal too far off to trouble myself about you."

          Just at this moment her head struck against the roof of the hall; in fact, she was now rather more than nine feet high, and she at once took up the little golden key and hurried off to the garden door.

          Poor Alice! It was as much as she could do, lying down on one side, to look through into the garden with one eye; but to get through was more hopeless than ever. She sat down and began to cry again.

          She went on shedding gallons of tears, until there was a large pool all 'round her and reaching half down the hall.

          After a time, she heard a little pattering of feet in the distance and she hastily dried her eyes to see what was coming. It was the White Rabbit returning, splendidly dressed, with a pair of white kid-gloves in one hand and a large fan in the other. He came trotting along in a great hurry, muttering to himself, "Oh! the Duchess, the Duchess! Oh! _won't_ she be savage if I've kept her waiting!"

          When the Rabbit came near her, Alice began, in a low, timid voice, "If you please, sir--" The Rabbit started violently, dropped the white kid-gloves and the fan and skurried away into the darkness as hard as he could go.

          Alice took up the fan and gloves and she kept fanning herself all the time she went on talking. "Dear, dear! How queer everything is to-day! And yesterday things went on just as usual. _Was_ I the same when I got up this morning? But if I'm not the same, the next question is, 'Who in the world am I?' Ah, _that's_ the great puzzle!"

          As she said this, she looked down at her hands and was surprised to see that she had put on one of the Rabbit's little white kid-gloves while she was talking. "How _can_ I have done that?" she thought. "I must be growing small again." She got up and went to the table to measure herself by it and found that she was now about two feet high and was going on shrinking rapidly. She soon found out that the cause of this was the fan she was holding and she dropped it hastily, just in time to save herself from shrinking away altogether.

          "That _was_ a narrow escape!" said Alice, a good deal frightened at the sudden change, but very glad to find herself still in existence. "And now for the garden!" And she ran with all speed back to the little door; but, alas! the little door was shut again and the little golden key was lying on the glass table as before. "Things are worse than ever," thought the poor child, "for I never was so small as this before, never!"

          As she said these words, her foot slipped, and in another moment, splash! she was up to her chin in salt-water. Her first idea was that she had somehow fallen into the sea. However, she soon made out that she was in the pool of tears which she had wept when she was nine feet high.

          Just then she heard something splashing about in the pool a little way off, and she swam nearer to see what it was: she soon made out that it was only a mouse that had slipped in like herself.

          "Would it be of any use, now," thought Alice, "to speak to this mouse? Everything is so out-of-the-way down here that I should think very likely it can talk; at any rate, there's no harm in trying." So she began, "O Mouse, do you know the way out of this pool? I am very tired of swimming about here, O Mouse!" The Mouse looked at her rather inquisitively and seemed to her to wink with one of its little eyes, but it said nothing.

          "Perhaps it doesn't understand English," thought Alice. "I dare say it's a French mouse, come over with William the Conqueror." So she began again: "Où est ma chatte?" which was the first sentence in her French lesson-book. The Mouse gave a sudden leap out of the water and seemed to quiver all over with fright. "Oh, I beg your pardon!" cried Alice hastily, afraid that she had hurt the poor animal's feelings. "I quite forgot you didn't like cats."

          "Not like cats!" cried the Mouse in a shrill, passionate voice. "Would _you_ like cats, if you were me?"

          "Well, perhaps not," said Alice in a soothing tone; "don't be angry about it. And yet I wish I could show you our cat Dinah. I think you'd take a fancy to cats, if you could only see her. She is such a dear, quiet thing." The Mouse was bristling all over and she felt certain it must be really offended. "We won't talk about her any more, if you'd rather not."

          "We, indeed!" cried the Mouse, who was trembling down to the end of its tail. "As if _I_ would talk on such a subject! Our family always _hated_ cats--nasty, low, vulgar things! Don't let me hear the name again!"

          "I won't indeed!" said Alice, in a great hurry to change the subject of conversation. "Are you--are you fond--of--of dogs? There is such a nice little dog near our house, I should like to show you! It kills all the rats and--oh, dear!" cried Alice in a sorrowful tone. "I'm afraid I've offended it again!" For the Mouse was swimming away from her as hard as it could go, and making quite a commotion in the pool as it went.

          So she called softly after it, "Mouse dear! Do come back again, and we won't talk about cats, or dogs either, if you don't like them!" When the Mouse heard this, it turned 'round and swam slowly back to her; its face was quite pale, and it said, in a low, trembling voice, "Let us get to the shore and then I'll tell you my history and you'll understand why it is I hate cats and dogs."

          It was high time to go, for the pool was getting quite crowded with the birds and animals that had fallen into it; there were a Duck and a Dodo, a Lory and an Eaglet, and several other curious creatures. Alice led the way and the whole party swam to the shore.

          III--A CAUCUS-RACE AND A LONG TALE

          They were indeed a queer-looking party that assembled on the bank--the birds with draggled feathers, the animals with their fur clinging close to them, and all dripping wet, cross and uncomfortable.

          The first question, of course, was how to get dry again. They had a consultation about this and after a few minutes, it seemed quite natural to Alice to find herself talking familiarly with them, as if she had known them all her life.

          At last the Mouse, who seemed to be a person of some authority among them, called out, "Sit down, all of you, and listen to me! _I'll_ soon make you dry enough!" They all sat down at once, in a large ring, with the Mouse in the middle.

          "Ahem!" said the Mouse with an important air. "Are you all ready? This is the driest thing I know. Silence all 'round, if you please! 'William the Conqueror, whose cause was favored by the pope, was soon submitted to by the English, who wanted leaders, and had been of late much accustomed to usurpation and conquest. Edwin and Morcar, the Earls of Mercia and Northumbria'--"

          "Ugh!" said the Lory, with a shiver.

          "--'And even Stigand, the patriotic archbishop of Canterbury, found it advisable'--"

          "Found _what_?" said the Duck.

          "Found _it_," the Mouse replied rather crossly; "of course, you know what 'it' means."

          "I know what 'it' means well enough, when _I_ find a thing," said the Duck; "it's generally a frog or a worm. The question is, what did the archbishop find?"

          The Mouse did not notice this question, but hurriedly went on, "'--found it advisable to go with Edgar Atheling to meet William and offer him the crown.'--How are you getting on now, my dear?" it continued, turning to Alice as it spoke.

          "As wet as ever," said Alice in a melancholy tone; "it doesn't seem to dry me at all."

          "In that case," said the Dodo solemnly, rising to its feet, "I move that the meeting adjourn, for the immediate adoption of more energetic remedies--"

          "Speak English!" said the Eaglet. "I don't know the meaning of half those long words, and, what's more, I don't believe you do either!"

          "What I was going to say," said the Dodo in an offended tone, "is that the best thing to get us dry would be a Caucus-race."

          "What _is_ a Caucus-race?" said Alice.

          "Why," said the Dodo, "the best way to explain it is to do it." First it marked out a race-course, in a sort of circle, and then all the party were placed along the course, here and there. There was no "One, two, three and away!" but they began running when they liked and left off when they liked, so that it was not easy to know when the race was over. However, when they had been running half an hour or so and were quite dry again, the Dodo suddenly called out, "The race is over!" and they all crowded 'round it, panting and asking, "But who has won?"

          This question the Dodo could not answer without a great deal of thought. At last it said, "_Everybody_ has won, and _all_ must have prizes."

          "But who is to give the prizes?" quite a chorus of voices asked.

          "Why, _she_, of course," said the Dodo, pointing to Alice with one finger; and the whole party at once crowded 'round her, calling out, in a confused way, "Prizes! Prizes!"

          Alice had no idea what to do, and in despair she put her hand into her pocket and pulled out a box of comfits (luckily the salt-water had not got into it) and handed them 'round as prizes. There was exactly one a-piece, all 'round.

          The next thing was to eat the comfits; this caused some noise and confusion, as the large birds complained that they could not taste theirs, and the small ones choked and had to be patted on the back. However, it was over at last and they sat down again in a ring and begged the Mouse to tell them something more.

          "You promised to tell me your history, you know," said Alice, "and why it is you hate--C and D," she added in a whisper, half afraid that it would be offended again.

          "Mine is a long and a sad tale!" said the Mouse, turning to Alice and sighing.

          "It _is_ a long tail, certainly," said Alice, looking down with wonder at the Mouse's tail, "but why do you call it sad?" And she kept on puzzling about it while the Mouse was speaking, so that her idea of the tale was something like this:--

          "You are not attending!" said the Mouse to Alice, severely. "What are you thinking of?"

          "I beg your pardon," said Alice very humbly, "you had got to the fifth bend, I think?"

          "You insult me by talking such nonsense!" said the Mouse, getting up and walking away.

          "Please come back and finish your story!" Alice called after it. And the others all joined in chorus, "Yes, please do!" But the Mouse only shook its head impatiently and walked a little quicker.

          "I wish I had Dinah, our cat, here!" said Alice. This caused a remarkable sensation among the party. Some of the birds hurried off at once, and a Canary called out in a trembling voice, to its children, "Come away, my dears! It's high time you were all in bed!" On various pretexts they all moved off and Alice was soon left alone.

          "I wish I hadn't mentioned Dinah! Nobody seems to like her down here and I'm sure she's the best cat in the world!" Poor Alice began to cry again, for she felt very lonely and low-spirited. In a little while, however, she again heard a little pattering of footsteps in the distance and she looked up eagerly.

          IV--THE RABBIT SENDS IN A LITTLE BILL

          It was the White Rabbit, trotting slowly back again and looking anxiously about as it went, as if it had lost something; Alice heard it muttering to itself, "The Duchess! The Duchess! Oh, my dear paws! Oh, my fur and whiskers! She'll get me executed, as sure as ferrets are ferrets! Where _can_ I have dropped them, I wonder?" Alice guessed in a moment that it was looking for the fan and the pair of white kid-gloves and she very good-naturedly began hunting about for them, but they were nowhere to be seen--everything seemed to have changed since her swim in the pool, and the great hall, with the glass table and the little door, had vanished completely.

          Very soon the Rabbit noticed Alice, and called to her, in an angry tone, "Why, Mary Ann, what _are_ you doing out here? Run home this moment and fetch me a pair of gloves and a fan! Quick, now!"

          "He took me for his housemaid!" said Alice, as she ran off. "How surprised he'll be when he finds out who I am!" As she said this, she came upon a neat little house, on the door of which was a bright brass plate with the name "W. RABBIT" engraved upon it. She went in without knocking and hurried upstairs, in great fear lest she should meet the real Mary Ann and be turned out of the house before she had found the fan and gloves.

          By this time, Alice had found her way into a tidy little room with a table in the window, and on it a fan and two or three pairs of tiny white kid-gloves; she took up the fan and a pair of the gloves and was just going to leave the room, when her eyes fell upon a little bottle that stood near the looking-glass. She uncorked it and put it to her lips, saying to herself, "I do hope it'll make me grow large again, for, really, I'm quite tired of being such a tiny little thing!"

          Before she had drunk half the bottle, she found her head pressing against the ceiling, and had to stoop to save her neck from being broken. She hastily put down the bottle, remarking, "That's quite enough--I hope I sha'n't grow any more."

          Alas! It was too late to wish that! She went on growing and growing and very soon she had to kneel down on the floor. Still she went on growing, and, as a last resource, she put one arm out of the window and one foot up the chimney, and said to herself, "Now I can do no more, whatever happens. What _will_ become of me?"

          Luckily for Alice, the little magic bottle had now had its full effect and she grew no larger. After a few minutes she heard a voice outside and stopped to listen.

          "Mary Ann! Mary Ann!" said the voice. "Fetch me my gloves this moment!" Then came a little pattering of feet on the stairs. Alice knew it was the Rabbit coming to look for her and she trembled till she shook the house, quite forgetting that she was now about a thousand times as large as the Rabbit and had no reason to be afraid of it.

          Presently the Rabbit came up to the door and tried to open it; but as the door opened inwards and Alice's elbow was pressed hard against it, that attempt proved a failure. Alice heard it say to itself, "Then I'll go 'round and get in at the window."

          "_That_ you won't!" thought Alice; and after waiting till she fancied she heard the Rabbit just under the window, she suddenly spread out her hand and made a snatch in the air. She did not get hold of anything, but she heard a little shriek and a fall and a crash of broken glass, from which she concluded that it was just possible it had fallen into a cucumber-frame or something of that sort.

          Next came an angry voice--the Rabbit's--"Pat! Pat! Where are you?" And then a voice she had never heard before, "Sure then, I'm here! Digging for apples, yer honor!"

          "Here! Come and help me out of this! Now tell me, Pat, what's that in the window?"

          "Sure, it's an arm, yer honor!"

          "Well, it's got no business there, at any rate; go and take it away!"

          There was a long silence after this and Alice could only hear whispers now and then, and at last she spread out her hand again and made another snatch in the air. This time there were _two_ little shrieks and more sounds of broken glass. "I wonder what they'll do next!" thought Alice. "As for pulling me out of the window, I only wish they _could_!"

          She waited for some time without hearing anything more. At last came a rumbling of little cart-wheels and the sound of a good many voices all talking together. She made out the words: "Where's the other ladder? Bill's got the other--Bill! Here, Bill! Will the roof bear?--Who's to go down the chimney?--Nay, _I_ sha'n't! _You_ do it! Here, Bill! The master says you've got to go down the chimney!"

          Alice drew her foot as far down the chimney as she could and waited till she heard a little animal scratching and scrambling about in the chimney close above her; then she gave one sharp kick and waited to see what would happen next.

          The first thing she heard was a general chorus of "There goes Bill!" then the Rabbit's voice alone--"Catch him, you by the hedge!" Then silence and then another confusion of voices--"Hold up his head--Brandy now--Don't choke him--What happened to you?"

          Last came a little feeble, squeaking voice, "Well, I hardly know--No more, thank ye. I'm better now--all I know is, something comes at me like a Jack-in-the-box and up I goes like a sky-rocket!"

          After a minute or two of silence, they began moving about again, and Alice heard the Rabbit say, "A barrowful will do, to begin with."

          "A barrowful of _what_?" thought Alice. But she had not long to doubt, for the next moment a shower of little pebbles came rattling in at the window and some of them hit her in the face. Alice noticed, with some surprise, that the pebbles were all turning into little cakes as they lay on the floor and a bright idea came into her head. "If I eat one of these cakes," she thought, "it's sure to make _some_ change in my size."

          So she swallowed one of the cakes and was delighted to find that she began shrinking directly. As soon as she was small enough to get through the door, she ran out of the house and found quite a crowd of little animals and birds waiting outside. They all made a rush at Alice the moment she appeared, but she ran off as hard as she could and soon found herself safe in a thick wood.

          "The first thing I've got to do," said Alice to herself, as she wandered about in the wood, "is to grow to my right size again; and the second thing is to find my way into that lovely garden. I suppose I ought to eat or drink something or other, but the great question is 'What?'"

          Alice looked all around her at the flowers and the blades of grass, but she could not see anything that looked like the right thing to eat or drink under the circumstances. There was a large mushroom growing near her, about the same height as herself. She stretched herself up on tiptoe and peeped over the edge and her eyes immediately met those of a large blue caterpillar, that was sitting on the top, with its arms folded, quietly smoking a long hookah and taking not the smallest notice of her or of anything else.

          V--ADVICE FROM A CATERPILLAR

          At last the Caterpillar took the hookah out of its mouth and addressed Alice in a languid, sleepy voice.

          "Who are _you_?" said the Caterpillar.

          Alice replied, rather shyly, "I--I hardly know, sir, just at present--at least I know who I _was_ when I got up this morning, but I think I must have changed several times since then."

          "What do you mean by that?" said the Caterpillar, sternly. "Explain yourself!"

          "I can't explain _myself_, I'm afraid, sir," said Alice, "because I'm not myself, you see--being so many different sizes in a day is very confusing." She drew herself up and said very gravely, "I think you ought to tell me who _you_ are, first."

          "Why?" said the Caterpillar.

          As Alice could not think of any good reason and the Caterpillar seemed to be in a _very_ unpleasant state of mind, she turned away.

          "Come back!" the Caterpillar called after her. "I've something important to say!" Alice turned and came back again.

          "Keep your temper," said the Caterpillar.

          "Is that all?" said Alice, swallowing down her anger as well as she could.

          "No," said the Caterpillar.

          It unfolded its arms, took the hookah out of its mouth again, and said, "So you think you're changed, do you?"

          "I'm afraid, I am, sir," said Alice. "I can't remember things as I used--and I don't keep the same size for ten minutes together!"

          "What size do you want to be?" asked the Caterpillar.

          "Oh, I'm not particular as to size," Alice hastily replied, "only one doesn't like changing so often, you know. I should like to be a _little_ larger, sir, if you wouldn't mind," said Alice. "Three inches is such a wretched height to be."

          "It is a very good height indeed!" said the Caterpillar angrily, rearing itself upright as it spoke (it was exactly three inches high).

          In a minute or two, the Caterpillar got down off the mushroom and crawled away into the grass, merely remarking, as it went, "One side will make you grow taller, and the other side will make you grow shorter."

          "One side of _what_? The other side of _what_?" thought Alice to herself.

          "Of the mushroom," said the Caterpillar, just as if she had asked it aloud; and in another moment, it was out of sight.

          Alice remained looking thoughtfully at the mushroom for a minute, trying to make out which were the two sides of it. At last she stretched her arms 'round it as far as they would go, and broke off a bit of the edge with each hand.

          "And now which is which?" she said to herself, and nibbled a little of the right-hand bit to try the effect. The next moment she felt a violent blow underneath her chin--it had struck her foot!

          She was a good deal frightened by this very sudden change, as she was shrinking rapidly; so she set to work at once to eat some of the other bit. Her chin was pressed so closely against her foot that there was hardly room to open her mouth; but she did it at last and managed to swallow a morsel of the left-hand bit....

          "Come, my head's free at last!" said Alice; but all she could see, when she looked down, was an immense length of neck, which seemed to rise like a stalk out of a sea of green leaves that lay far below her.

          "Where _have_ my shoulders got to? And oh, my poor hands, how is it I can't see you?" She was delighted to find that her neck would bend about easily in any direction, like a serpent. She had just succeeded in curving it down into a graceful zigzag and was going to dive in among the leaves, when a sharp hiss made her draw back in a hurry--a large pigeon had flown into her face and was beating her violently with its wings.

          "Serpent!" cried the Pigeon.

          "I'm _not_ a serpent!" said Alice indignantly. "Let me alone!"

          "I've tried the roots of trees, and I've tried banks, and I've tried hedges," the Pigeon went on, "but those serpents! There's no pleasing them!"

          Alice was more and more puzzled.

          "As if it wasn't trouble enough hatching the eggs," said the Pigeon, "but I must be on the look-out for serpents, night and day! And just as I'd taken the highest tree in the wood," continued the Pigeon, raising its voice to a shriek, "and just as I was thinking I should be free of them at last, they must needs come wriggling down from the sky! Ugh, Serpent!"

          "But I'm _not_ a serpent, I tell you!" said Alice. "I'm a--I'm a--I'm a little girl," she added rather doubtfully, as she remembered the number of changes she had gone through that day.

          "You're looking for eggs, I know _that_ well enough," said the Pigeon; "and what does it matter to me whether you're a little girl or a serpent?"

          "It matters a good deal to _me_," said Alice hastily; "but I'm not looking for eggs, as it happens, and if I was, I shouldn't want _yours_--I don't like them raw."

          "Well, be off, then!" said the Pigeon in a sulky tone, as it settled down again into its nest. Alice crouched down among the trees as well as she could, for her neck kept getting entangled among the branches, and every now and then she had to stop and untwist it. After awhile she remembered that she still held the pieces of mushroom in her hands, and she set to work very carefully, nibbling first at one and then at the other, and growing sometimes taller and sometimes shorter, until she had succeeded in bringing herself down to her usual height.

          It was so long since she had been anything near the right size that it felt quite strange at first. "The next thing is to get into that beautiful garden--how _is_ that to be done, I wonder?" As she said this, she came suddenly upon an open place, with a little house in it about four feet high. "Whoever lives there," thought Alice, "it'll never do to come upon them _this_ size; why, I should frighten them out of their wits!" She did not venture to go near the house till she had brought herself down to nine inches high.

          VI--PIG AND PEPPER

          For a minute or two she stood looking at the house, when suddenly a footman in livery came running out of the wood (judging by his face only, she would have called him a fish)--and rapped loudly at the door with his knuckles. It was opened by another footman in livery, with a round face and large eyes like a frog.

          The Fish-Footman began by producing from under his arm a great letter, and this he handed over to the other, saying, in a solemn tone, "For the Duchess. An invitation from the Queen to play croquet." The Frog-Footman repeated, in the same solemn tone, "From the Queen. An invitation for the Duchess to play croquet." Then they both bowed low and their curls got entangled together.

          When Alice next peeped out, the Fish-Footman was gone, and the other was sitting on the ground near the door, staring stupidly up into the sky. Alice went timidly up to the door and knocked.

          "There's no sort of use in knocking," said the Footman, "and that for two reasons. First, because I'm on the same side of the door as you are; secondly, because they're making such a noise inside, no one could possibly hear you." And certainly there _was_ a most extraordinary noise going on within--a constant howling and sneezing, and every now and then a great crash, as if a dish or kettle had been broken to pieces.

          "How am I to get in?" asked Alice.

          "_Are_ you to get in at all?" said the Footman. "That's the first question, you know."

          Alice opened the door and went in. The door led right into a large kitchen, which was full of smoke from one end to the other; the Duchess was sitting on a three-legged stool in the middle, nursing a baby; the cook was leaning over the fire, stirring a large caldron which seemed to be full of soup.

          "There's certainly too much pepper in that soup!" Alice said to herself, as well as she could for sneezing. Even the Duchess sneezed occasionally; and as for the baby, it was sneezing and howling alternately without a moment's pause. The only two creatures in the kitchen that did _not_ sneeze were the cook and a large cat, which was grinning from ear to ear.

          "Please would you tell me," said Alice, a little timidly, "why your cat grins like that?"

          "It's a Cheshire-Cat," said the Duchess, "and that's why."

          "I didn't know that Cheshire-Cats always grinned; in fact, I didn't know that cats _could_ grin," said Alice.

          "You don't know much," said the Duchess, "and that's a fact."

          Just then the cook took the caldron of soup off the fire, and at once set to work throwing everything within her reach at the Duchess and the baby--the fire-irons came first; then followed a shower of saucepans, plates and dishes. The Duchess took no notice of them, even when they hit her, and the baby was howling so much already that it was quite impossible to say whether the blows hurt it or not.

          "Oh, _please_ mind what you're doing!" cried Alice, jumping up and down in an agony of terror.

          "Here! You may nurse it a bit, if you like!" the Duchess said to Alice, flinging the baby at her as she spoke. "I must go and get ready to play croquet with the Queen," and she hurried out of the room.

          Alice caught the baby with some difficulty, as it was a queer-shaped little creature and held out its arms and legs in all directions. "If I don't take this child away with me," thought Alice, "they're sure to kill it in a day or two. Wouldn't it be murder to leave it behind?" She said the last words out loud and the little thing grunted in reply.

          "If you're going to turn into a pig, my dear," said Alice, "I'll have nothing more to do with you. Mind now!"

          Alice was just beginning to think to herself, "Now, what am I to do with this creature, when I get it home?" when it grunted again so violently that Alice looked down into its face in some alarm. This time there could be _no_ mistake about it--it was neither more nor less than a pig; so she set the little creature down and felt quite relieved to see it trot away quietly into the wood.

          Alice was a little startled by seeing the Cheshire-Cat sitting on a bough of a tree a few yards off. The Cat only grinned when it saw her. "Cheshire-Puss," began Alice, rather timidly, "would you please tell me which way I ought to go from here?"

          "In _that_ direction," the Cat said, waving the right paw 'round, "lives a Hatter; and in _that_ direction," waving the other paw, "lives a March Hare. Visit either you like; they're both mad."

          "But I don't want to go among mad people," Alice remarked.

          "Oh, you can't help that," said the Cat; "we're all mad here. Do you play croquet with the Queen to-day?"

          "I should like it very much," said Alice, "but I haven't been invited yet."

          "You'll see me there," said the Cat, and vanished.

          Alice had not gone much farther before she came in sight of the house of the March Hare; it was so large a house that she did not like to go near till she had nibbled some more of the left-hand bit of mushroom.

          VII--A MAD TEA-PARTY

          There was a table set out under a tree in front of the house, and the March Hare and the Hatter were having tea at it; a Dormouse was sitting between them, fast asleep.

          The table was a large one, but the three were all crowded together at one corner of it. "No room! No room!" they cried out when they saw Alice coming. "There's _plenty_ of room!" said Alice indignantly, and she sat down in a large arm-chair at one end of the table.

          The Hatter opened his eyes very wide on hearing this, but all he said was "Why is a raven like a writing-desk?"

          "I'm glad they've begun asking riddles--I believe I can guess that," she added aloud.

          "Do you mean that you think you can find out the answer to it?" said the March Hare.

          "Exactly so," said Alice.

          "Then you should say what you mean," the March Hare went on.

          "I do," Alice hastily replied; "at least--at least I mean what I say--that's the same thing, you know."

          "You might just as well say," added the Dormouse, which seemed to be talking in its sleep, "that 'I breathe when I sleep' is the same thing as 'I sleep when I breathe!'"

          "It _is_ the same thing with you," said the Hatter, and he poured a little hot tea upon its nose. The Dormouse shook its head impatiently and said, without opening its eyes, "Of course, of course; just what I was going to remark myself."

          "Have you guessed the riddle yet?" the Hatter said, turning to Alice again.

          "No, I give it up," Alice replied. "What's the answer?"

          "I haven't the slightest idea," said the Hatter.

          "Nor I," said the March Hare.

          Alice gave a weary sigh. "I think you might do something better with the time," she said, "than wasting it in asking riddles that have no answers."

          "Take some more tea," the March Hare said to Alice, very earnestly.

          "I've had nothing yet," Alice replied in an offended tone, "so I can't take more."

          "You mean you can't take _less_," said the Hatter; "it's very easy to take _more_ than nothing."

          At this, Alice got up and walked off. The Dormouse fell asleep instantly and neither of the others took the least notice of her going, though she looked back once or twice; the last time she saw them, they were trying to put the Dormouse into the tea-pot.

          "At any rate, I'll never go _there_ again!" said Alice, as she picked her way through the wood. "It's the stupidest tea-party I ever was at in all my life!" Just as she said this, she noticed that one of the trees had a door leading right into it. "That's very curious!" she thought. "I think I may as well go in at once." And in she went.

          Once more she found herself in the long hall and close to the little glass table. Taking the little golden key, she unlocked the door that led into the garden. Then she set to work nibbling at the mushroom (she had kept a piece of it in her pocket) till she was about a foot high; then she walked down the little passage; and _then_--she found herself at last in the beautiful garden, among the bright flower-beds and the cool fountains.

          VIII--THE QUEEN'S CROQUET GROUND

          A large rose-tree stood near the entrance of the garden; the roses growing on it were white, but there were three gardeners at it, busily painting them red. Suddenly their eyes chanced to fall upon Alice, as she stood watching them. "Would you tell me, please," said Alice, a little timidly, "why you are painting those roses?"

          Five and Seven said nothing, but looked at Two. Two began, in a low voice, "Why, the fact is, you see, Miss, this here ought to have been a _red_ rose-tree, and we put a white one in by mistake; and, if the Queen was to find it out, we should all have our heads cut off, you know. So you see, Miss, we're doing our best, afore she comes, to--" At this moment, Five, who had been anxiously looking across the garden, called out, "The Queen! The Queen!" and the three gardeners instantly threw themselves flat upon their faces. There was a sound of many footsteps and Alice looked 'round, eager to see the Queen.

          First came ten soldiers carrying clubs, with their hands and feet at the corners: next the ten courtiers; these were ornamented all over with diamonds. After these came the royal children; there were ten of them, all ornamented with hearts. Next came the guests, mostly Kings and Queens, and among them Alice recognized the White Rabbit. Then followed the Knave of Hearts, carrying the King's crown on a crimson velvet cushion; and last of all this grand procession came THE KING AND THE QUEEN OF HEARTS.

          When the procession came opposite to Alice, they all stopped and looked at her, and the Queen said severely, "Who is this?" She said it to the Knave of Hearts, who only bowed and smiled in reply.

          "My name is Alice, so please Your Majesty," said Alice very politely; but she added to herself, "Why, they're only a pack of cards, after all!"

          "Can you play croquet?" shouted the Queen. The question was evidently meant for Alice.

          "Yes!" said Alice loudly.

          "Come on, then!" roared the Queen.

          "It's--it's a very fine day!" said a timid voice to Alice. She was walking by the White Rabbit, who was peeping anxiously into her face.

          "Very," said Alice. "Where's the Duchess?"

          "Hush! Hush!" said the Rabbit. "She's under sentence of execution."

          "What for?" said Alice.

          "She boxed the Queen's ears--" the Rabbit began.

          "Get to your places!" shouted the Queen in a voice of thunder, and people began running about in all directions, tumbling up against each other. However, they got settled down in a minute or two, and the game began.

          Alice thought she had never seen such a curious croquet-ground in her life; it was all ridges and furrows. The croquet balls were live hedgehogs, and the mallets live flamingos and the soldiers had to double themselves up and stand on their hands and feet, to make the arches.

          The players all played at once, without waiting for turns, quarrelling all the while and fighting for the hedgehogs; and in a very short time, the Queen was in a furious passion and went stamping about and shouting, "Off with his head!" or "Off with her head!" about once in a minute.

          "They're dreadfully fond of beheading people here," thought Alice; "the great wonder is that there's anyone left alive!"

          She was looking about for some way of escape, when she noticed a curious appearance in the air. "It's the Cheshire-Cat," she said to herself; "now I shall have somebody to talk to."

          "How are you getting on?" said the Cat.

          "I don't think they play at all fairly," Alice said, in a rather complaining tone; "and they all quarrel so dreadfully one can't hear oneself speak--and they don't seem to have any rules in particular."

          "How do you like the Queen?" said the Cat in a low voice.

          "Not at all," said Alice.

          Alice thought she might as well go back and see how the game was going on. So she went off in search of her hedgehog. The hedgehog was engaged in a fight with another hedgehog, which seemed to Alice an excellent opportunity for croqueting one of them with the other; the only difficulty was that her flamingo was gone across to the other side of the garden, where Alice could see it trying, in a helpless sort of way, to fly up into a tree. She caught the flamingo and tucked it away under her arm, that it might not escape again.

          Just then Alice ran across the Duchess (who was now out of prison). She tucked her arm affectionately into Alice's and they walked off together. Alice was very glad to find her in such a pleasant temper. She was a little startled, however, when she heard the voice of the Duchess close to her ear. "You're thinking about something, my dear, and that makes you forget to talk."

          "The game's going on rather better now," Alice said, by way of keeping up the conversation a little.

          "'Tis so," said the Duchess; "and the moral of that is--'Oh, 'tis love, 'tis love that makes the world go 'round!'"

          "Somebody said," Alice whispered, "that it's done by everybody minding his own business!"

          "Ah, well! It means much the same thing," said the Duchess, digging her sharp little chin into Alice's shoulder, as she added "and the moral of _that_ is--'Take care of the sense and the sounds will take care of themselves.'"

          To Alice's great surprise, the Duchess's arm that was linked into hers began to tremble. Alice looked up and there stood the Queen in front of them, with her arms folded, frowning like a thunderstorm!

          "Now, I give you fair warning," shouted the Queen, stamping on the ground as she spoke, "either you or your head must be off, and that in about half no time. Take your choice!" The Duchess took her choice, and was gone in a moment.

          "Let's go on with the game," the Queen said to Alice; and Alice was too much frightened to say a word, but slowly followed her back to the croquet-ground.

          All the time they were playing, the Queen never left off quarreling with the other players and shouting, "Off with his head!" or "Off with her head!" By the end of half an hour or so, all the players, except the King, the Queen and Alice, were in custody of the soldiers and under sentence of execution.

          Then the Queen left off, quite out of breath, and walked away with Alice.

          Alice heard the King say in a low voice to the company generally, "You are all pardoned."

          Suddenly the cry "The Trial's beginning!" was heard in the distance, and Alice ran along with the others.

          IX--WHO STOLE THE TARTS?

          The King and Queen of Hearts were seated on their throne when they arrived, with a great crowd assembled about them--all sorts of little birds and beasts, as well as the whole pack of cards: the Knave was standing before them, in chains, with a soldier on each side to guard him; and near the King was the White Rabbit, with a trumpet in one hand and a scroll of parchment in the other. In the very middle of the court was a table, with a large dish of tarts upon it. "I wish they'd get the trial done," Alice thought, "and hand 'round the refreshments!"

          The judge, by the way, was the King and he wore his crown over his great wig. "That's the jury-box," thought Alice; "and those twelve creatures (some were animals and some were birds) I suppose they are the jurors."

          Just then the White Rabbit cried out "Silence in the court!"

          "Herald, read the accusation!" said the King.

          On this, the White Rabbit blew three blasts on the trumpet, then unrolled the parchment-scroll and read as follows:

          "Call the first witness," said the King; and the White Rabbit blew three blasts on the trumpet and called out, "First witness!"

          The first witness was the Hatter. He came in with a teacup in one hand and a piece of bread and butter in the other.

          "You ought to have finished," said the King. "When did you begin?"

          The Hatter looked at the March Hare, who had followed him into the court, arm in arm with the Dormouse. "Fourteenth of March, I _think_ it was," he said.

          "Give your evidence," said the King, "and don't be nervous, or I'll have you executed on the spot."

          This did not seem to encourage the witness at all; he kept shifting from one foot to the other, looking uneasily at the Queen, and, in his confusion, he bit a large piece out of his teacup instead of the bread and butter.

          Just at this moment Alice felt a very curious sensation--she was beginning to grow larger again.

          The miserable Hatter dropped his teacup and bread and butter and went down on one knee. "I'm a poor man, Your Majesty," he began.

          "You're a _very_ poor _speaker_," said the King.

          "You may go," said the King, and the Hatter hurriedly left the court.

          "Call the next witness!" said the King.

          The next witness was the Duchess's cook. She carried the pepper-box in her hand and the people near the door began sneezing all at once.

          "Give your evidence," said the King.

          "Sha'n't," said the cook.

          The King looked anxiously at the White Rabbit, who said, in a low voice, "Your Majesty must cross-examine _this_ witness."

          "Well, if I must, I must," the King said. "What are tarts made of?"

          "Pepper, mostly," said the cook.

          For some minutes the whole court was in confusion and by the time they had settled down again, the cook had disappeared.

          "Never mind!" said the King, "call the next witness."

          Alice watched the White Rabbit as he fumbled over the list. Imagine her surprise when he read out, at the top of his shrill little voice, the name "Alice!"

          X--ALICE'S EVIDENCE

          "Here!" cried Alice. She jumped up in such a hurry that she tipped over the jury-box, upsetting all the jurymen on to the heads of the crowd below.

          "Oh, I _beg_ your pardon!" she exclaimed in a tone of great dismay.

          "The trial cannot proceed," said the King, "until all the jurymen are back in their proper places--_all_," he repeated with great emphasis, looking hard at Alice.

          "What do you know about this business?" the King said to Alice.

          "Nothing whatever," said Alice.

          The King then read from his book: "Rule forty-two. _All persons more than a mile high to leave the court_."

          "_I'm_ not a mile high," said Alice.

          "Nearly two miles high," said the Queen.

          "Well, I sha'n't go, at any rate," said Alice.

          The King turned pale and shut his note-book hastily. "Consider your verdict," he said to the jury, in a low, trembling voice.

          "There's more evidence to come yet, please Your Majesty," said the White Rabbit, jumping up in a great hurry. "This paper has just been picked up. It seems to be a letter written by the prisoner to--to somebody." He unfolded the paper as he spoke and added, "It isn't a letter, after all; it's a set of verses."

          "Please, Your Majesty," said the Knave, "I didn't write it and they can't prove that I did; there's no name signed at the end."

          "You _must_ have meant some mischief, or else you'd have signed your name like an honest man," said the King. There was a general clapping of hands at this.

          "Read them," he added, turning to the White Rabbit.

          There was dead silence in the court whilst the White Rabbit read out the verses.

          "That's the most important piece of evidence we've heard yet," said the King.

          "_I_ don't believe there's an atom of meaning in it," ventured Alice.

          "If there's no meaning in it," said the King, "that saves a world of trouble, you know, as we needn't try to find any. Let the jury consider their verdict."

          "No, no!" said the Queen. "Sentence first--verdict afterwards."

          "Stuff and nonsense!" said Alice loudly. "The idea of having the sentence first!"

          "Hold your tongue!" said the Queen, turning purple.

          "I won't!" said Alice.

          "Off with her head!" the Queen shouted at the top of her voice. Nobody moved.

          "Who cares for _you_?" said Alice (she had grown to her full size by this time). "You're nothing but a pack of cards!"

          At this, the whole pack rose up in the air and came flying down upon her; she gave a little scream, half of fright and half of anger, and tried to beat them off, and found herself lying on the bank, with her head in the lap of her sister, who was gently brushing away some dead leaves that had fluttered down from the trees upon her face.

          "Wake up, Alice dear!" said her sister. "Why, what a long sleep you've had!"

          "Oh, I've had such a curious dream!" said Alice. And she told her sister, as well as she could remember them, all these strange adventures of hers that you have just been reading about. Alice got up and ran off, thinking while she ran, as well she might, what a wonderful dream it had been.
        EOF

        ps = PragmaticSegmenter::Segmenter.new(text: text, language: 'en')
        expect(ps.segment).to eq(["DOWN THE RABBIT-HOLE", "Alice was beginning to get very tired of sitting by her sister on the bank, and of having nothing to do.", "Once or twice she had peeped into the book her sister was reading, but it had no pictures or conversations in it, \"and what is the use of a book,\" thought Alice, \"without pictures or conversations?\"", "So she was considering in her own mind (as well as she could, for the day made her feel very sleepy and stupid), whether the pleasure of making a daisy-chain would be worth the trouble of getting up and picking the daisies, when suddenly a White Rabbit with pink eyes ran close by her.", "There was nothing so very remarkable in that, nor did Alice think it so very much out of the way to hear the Rabbit say to itself, \"Oh dear! Oh dear! I shall be too late!\"", "But when the Rabbit actually took a watch out of its waistcoat-pocket and looked at it and then hurried on, Alice started to her feet, for it flashed across her mind that she had never before seen a rabbit with either a waistcoat-pocket, or a watch to take out of it, and, burning with curiosity, she ran across the field after it and was just in time to see it pop down a large rabbit-hole, under the hedge.", "In another moment, down went Alice after it!", "The rabbit-hole went straight on like a tunnel for some way and then dipped suddenly down, so suddenly that Alice had not a moment to think about stopping herself before she found herself falling down what seemed to be a very deep well.", "Either the well was very deep, or she fell very slowly, for she had plenty of time, as she went down, to look about her.", "First, she tried to make out what she was coming to, but it was too dark to see anything; then she looked at the sides of the well and noticed that they were filled with cupboards and book-shelves; here and there she saw maps and pictures hung upon pegs.", "She took down a jar from one of the shelves as she passed.", "It was labeled \"ORANGE MARMALADE,\" but, to her great disappointment, it was empty; she did not like to drop the jar, so managed to put it into one of the cupboards as she fell past it.", "Down, down, down!", "Would the fall never come to an end?", "There was nothing else to do, so Alice soon began talking to herself.", "\"Dinah'll miss me very much to-night, I should think!\"", "(Dinah was the cat.)", "\"I hope they'll remember her saucer of milk at tea-time. Dinah, my dear, I wish you were down here with me!\"", "Alice felt that she was dozing off, when suddenly, thump! thump! down she came upon a heap of sticks and dry leaves, and the fall was over.", "Alice was not a bit hurt, and she jumped up in a moment.", "She looked up, but it was all dark overhead; before her was another long passage and the White Rabbit was still in sight, hurrying down it.", "There was not a moment to be lost.", "Away went Alice like the wind and was just in time to hear it say, as it turned a corner, \"Oh, my ears and whiskers, how late it's getting!\"", "She was close behind it when she turned the corner, but the Rabbit was no longer to be seen.", "She found herself in a long, low hall, which was lit up by a row of lamps hanging from the roof.", "There were doors all 'round the hall, but they were all locked; and when Alice had been all the way down one side and up the other, trying every door, she walked sadly down the middle, wondering how she was ever to get out again.", "Suddenly she came upon a little table, all made of solid glass.", "There was nothing on it but a tiny golden key, and Alice's first idea was that this might belong to one of the doors of the hall; but, alas! either the locks were too large, or the key was too small, but, at any rate, it would not open any of them.", "However, on the second time 'round, she came upon a low curtain she had not noticed before, and behind it was a little door about fifteen inches high.", "She tried the little golden key in the lock, and to her great delight, it fitted!", "Alice opened the door and found that it led into a small passage, not much larger than a rat-hole; she knelt down and looked along the passage into the loveliest garden you ever saw.", "How she longed to get out of that dark hall and wander about among those beds of bright flowers and those cool fountains, but she could not even get her head through the doorway.", "\"Oh,\" said Alice, \"how I wish I could shut up like a telescope! I think I could, if I only knew how to begin.\"", "Alice went back to the table, half hoping she might find another key on it, or at any rate, a book of rules for shutting people up like telescopes.", "This time she found a little bottle on it (\"which certainly was not here before,\" said Alice), and tied 'round the neck of the bottle was a paper label, with the words \"DRINK ME\" beautifully printed on it in large letters.", "\"No, I'll look first,\" she said, \"and see whether it's marked '_poison_' or not,\" for she had never forgotten that, if you drink from a bottle marked \"poison,\" it is almost certain to disagree with you, sooner or later.", "However, this bottle was _not_ marked \"poison,\" so Alice ventured to taste it, and, finding it very nice (it had a sort of mixed flavor of cherry-tart, custard, pineapple, roast turkey, toffy and hot buttered toast), she very soon finished it off.", "* * * * *", "\"What a curious feeling!\" said Alice.", "\"I must be shutting up like a telescope!\"", "And so it was indeed!", "She was now only ten inches high, and her face brightened up at the thought that she was now the right size for going through the little door into that lovely garden.", "After awhile, finding that nothing more happened, she decided on going into the garden at once; but, alas for poor Alice!", "When she got to the door, she found she had forgotten the little golden key, and when she went back to the table for it, she found she could not possibly reach it: she could see it quite plainly through the glass and she tried her best to climb up one of the legs of the table, but it was too slippery, and when she had tired herself out with trying, the poor little thing sat down and cried.", "\"Come, there's no use in crying like that!\" said Alice to herself rather sharply.", "\"I advise you to leave off this minute!\"", "She generally gave herself very good advice (though she very seldom followed it), and sometimes she scolded herself so severely as to bring tears into her eyes.", "Soon her eye fell on a little glass box that was lying under the table: she opened it and found in it a very small cake, on which the words \"EAT ME\" were beautifully marked in currants.", "\"Well, I'll eat it,\" said Alice, \"and if it makes me grow larger, I can reach the key; and if it makes me grow smaller, I can creep under the door: so either way I'll get into the garden, and I don't care which happens!\"", "She ate a little bit and said anxiously to herself, \"Which way? Which way?\" holding her hand on the top of her head to feel which way she was growing; and she was quite surprised to find that she remained the same size.", "So she set to work and very soon finished off the cake.", "II--THE POOL OF TEARS", "\"Curiouser and curiouser!\" cried Alice (she was so much surprised that for the moment she quite forgot how to speak good English).", "\"Now I'm opening out like the largest telescope that ever was! Good-by, feet! Oh, my poor little feet, I wonder who will put on your shoes and stockings for you now, dears? I shall be a great deal too far off to trouble myself about you.\"", "Just at this moment her head struck against the roof of the hall; in fact, she was now rather more than nine feet high, and she at once took up the little golden key and hurried off to the garden door.", "Poor Alice!", "It was as much as she could do, lying down on one side, to look through into the garden with one eye; but to get through was more hopeless than ever.", "She sat down and began to cry again.", "She went on shedding gallons of tears, until there was a large pool all 'round her and reaching half down the hall.", "After a time, she heard a little pattering of feet in the distance and she hastily dried her eyes to see what was coming.", "It was the White Rabbit returning, splendidly dressed, with a pair of white kid-gloves in one hand and a large fan in the other.", "He came trotting along in a great hurry, muttering to himself, \"Oh! the Duchess, the Duchess! Oh! _won't_ she be savage if I've kept her waiting!\"", "When the Rabbit came near her, Alice began, in a low, timid voice, \"If you please, sir--\"", "The Rabbit started violently, dropped the white kid-gloves and the fan and skurried away into the darkness as hard as he could go.", "Alice took up the fan and gloves and she kept fanning herself all the time she went on talking.", "\"Dear, dear! How queer everything is to-day! And yesterday things went on just as usual. _Was_ I the same when I got up this morning? But if I'm not the same, the next question is, 'Who in the world am I?' Ah, _that's_ the great puzzle!\"", "As she said this, she looked down at her hands and was surprised to see that she had put on one of the Rabbit's little white kid-gloves while she was talking.", "\"How _can_ I have done that?\" she thought.", "\"I must be growing small again.\"", "She got up and went to the table to measure herself by it and found that she was now about two feet high and was going on shrinking rapidly.", "She soon found out that the cause of this was the fan she was holding and she dropped it hastily, just in time to save herself from shrinking away altogether.", "\"That _was_ a narrow escape!\" said Alice, a good deal frightened at the sudden change, but very glad to find herself still in existence.", "\"And now for the garden!\"", "And she ran with all speed back to the little door; but, alas! the little door was shut again and the little golden key was lying on the glass table as before.", "\"Things are worse than ever,\" thought the poor child, \"for I never was so small as this before, never!\"", "As she said these words, her foot slipped, and in another moment, splash! she was up to her chin in salt-water.", "Her first idea was that she had somehow fallen into the sea.", "However, she soon made out that she was in the pool of tears which she had wept when she was nine feet high.", "Just then she heard something splashing about in the pool a little way off, and she swam nearer to see what it was: she soon made out that it was only a mouse that had slipped in like herself.", "\"Would it be of any use, now,\" thought Alice, \"to speak to this mouse? Everything is so out-of-the-way down here that I should think very likely it can talk; at any rate, there's no harm in trying.\"", "So she began, \"O Mouse, do you know the way out of this pool? I am very tired of swimming about here, O Mouse!\"", "The Mouse looked at her rather inquisitively and seemed to her to wink with one of its little eyes, but it said nothing.", "\"Perhaps it doesn't understand English,\" thought Alice.", "\"I dare say it's a French mouse, come over with William the Conqueror.\"", "So she began again: \"Où est ma chatte?\" which was the first sentence in her French lesson-book.", "The Mouse gave a sudden leap out of the water and seemed to quiver all over with fright.", "\"Oh, I beg your pardon!\" cried Alice hastily, afraid that she had hurt the poor animal's feelings.", "\"I quite forgot you didn't like cats.\"", "\"Not like cats!\" cried the Mouse in a shrill, passionate voice.", "\"Would _you_ like cats, if you were me?\"", "\"Well, perhaps not,\" said Alice in a soothing tone; \"don't be angry about it. And yet I wish I could show you our cat Dinah. I think you'd take a fancy to cats, if you could only see her. She is such a dear, quiet thing.\"", "The Mouse was bristling all over and she felt certain it must be really offended.", "\"We won't talk about her any more, if you'd rather not.\"", "\"We, indeed!\" cried the Mouse, who was trembling down to the end of its tail.", "\"As if _I_ would talk on such a subject! Our family always _hated_ cats--nasty, low, vulgar things! Don't let me hear the name again!\"", "\"I won't indeed!\" said Alice, in a great hurry to change the subject of conversation.", "\"Are you--are you fond--of--of dogs? There is such a nice little dog near our house, I should like to show you! It kills all the rats and--oh, dear!\" cried Alice in a sorrowful tone.", "\"I'm afraid I've offended it again!\"", "For the Mouse was swimming away from her as hard as it could go, and making quite a commotion in the pool as it went.", "So she called softly after it, \"Mouse dear! Do come back again, and we won't talk about cats, or dogs either, if you don't like them!\"", "When the Mouse heard this, it turned 'round and swam slowly back to her; its face was quite pale, and it said, in a low, trembling voice, \"Let us get to the shore and then I'll tell you my history and you'll understand why it is I hate cats and dogs.\"", "It was high time to go, for the pool was getting quite crowded with the birds and animals that had fallen into it; there were a Duck and a Dodo, a Lory and an Eaglet, and several other curious creatures.", "Alice led the way and the whole party swam to the shore.", "III--A CAUCUS-RACE AND A LONG TALE", "They were indeed a queer-looking party that assembled on the bank--the birds with draggled feathers, the animals with their fur clinging close to them, and all dripping wet, cross and uncomfortable.", "The first question, of course, was how to get dry again.", "They had a consultation about this and after a few minutes, it seemed quite natural to Alice to find herself talking familiarly with them, as if she had known them all her life.", "At last the Mouse, who seemed to be a person of some authority among them, called out, \"Sit down, all of you, and listen to me! _I'll_ soon make you dry enough!\"", "They all sat down at once, in a large ring, with the Mouse in the middle.", "\"Ahem!\" said the Mouse with an important air.", "\"Are you all ready? This is the driest thing I know. Silence all 'round, if you please! 'William the Conqueror, whose cause was favored by the pope, was soon submitted to by the English, who wanted leaders, and had been of late much accustomed to usurpation and conquest. Edwin and Morcar, the Earls of Mercia and Northumbria'--\"", "\"Ugh!\" said the Lory, with a shiver.", "\"--'And even Stigand, the patriotic archbishop of Canterbury, found it advisable'--\"", "\"Found _what_?\" said the Duck.", "\"Found _it_,\" the Mouse replied rather crossly; \"of course, you know what 'it' means.\"", "\"I know what 'it' means well enough, when _I_ find a thing,\" said the Duck; \"it's generally a frog or a worm. The question is, what did the archbishop find?\"", "The Mouse did not notice this question, but hurriedly went on, \"'--found it advisable to go with Edgar Atheling to meet William and offer him the crown.'--How are you getting on now, my dear?\" it continued, turning to Alice as it spoke.", "\"As wet as ever,\" said Alice in a melancholy tone; \"it doesn't seem to dry me at all.\"", "\"In that case,\" said the Dodo solemnly, rising to its feet, \"I move that the meeting adjourn, for the immediate adoption of more energetic remedies--\"", "\"Speak English!\" said the Eaglet.", "\"I don't know the meaning of half those long words, and, what's more, I don't believe you do either!\"", "\"What I was going to say,\" said the Dodo in an offended tone, \"is that the best thing to get us dry would be a Caucus-race.\"", "\"What _is_ a Caucus-race?\" said Alice.", "\"Why,\" said the Dodo, \"the best way to explain it is to do it.\"", "First it marked out a race-course, in a sort of circle, and then all the party were placed along the course, here and there.", "There was no \"One, two, three and away!\" but they began running when they liked and left off when they liked, so that it was not easy to know when the race was over.", "However, when they had been running half an hour or so and were quite dry again, the Dodo suddenly called out, \"The race is over!\" and they all crowded 'round it, panting and asking, \"But who has won?\"", "This question the Dodo could not answer without a great deal of thought.", "At last it said, \"_Everybody_ has won, and _all_ must have prizes.\"", "\"But who is to give the prizes?\" quite a chorus of voices asked.", "\"Why, _she_, of course,\" said the Dodo, pointing to Alice with one finger; and the whole party at once crowded 'round her, calling out, in a confused way, \"Prizes! Prizes!\"", "Alice had no idea what to do, and in despair she put her hand into her pocket and pulled out a box of comfits (luckily the salt-water had not got into it) and handed them 'round as prizes. There was exactly one a-piece, all 'round.", "The next thing was to eat the comfits; this caused some noise and confusion, as the large birds complained that they could not taste theirs, and the small ones choked and had to be patted on the back.", "However, it was over at last and they sat down again in a ring and begged the Mouse to tell them something more.", "\"You promised to tell me your history, you know,\" said Alice, \"and why it is you hate--C and D,\" she added in a whisper, half afraid that it would be offended again.", "\"Mine is a long and a sad tale!\" said the Mouse, turning to Alice and sighing.", "\"It _is_ a long tail, certainly,\" said Alice, looking down with wonder at the Mouse's tail, \"but why do you call it sad?\"", "And she kept on puzzling about it while the Mouse was speaking, so that her idea of the tale was something like this:--", "\"You are not attending!\" said the Mouse to Alice, severely.", "\"What are you thinking of?\"", "\"I beg your pardon,\" said Alice very humbly, \"you had got to the fifth bend, I think?\"", "\"You insult me by talking such nonsense!\" said the Mouse, getting up and walking away.", "\"Please come back and finish your story!\"", "Alice called after it.", "And the others all joined in chorus, \"Yes, please do!\"", "But the Mouse only shook its head impatiently and walked a little quicker.", "\"I wish I had Dinah, our cat, here!\" said Alice.", "This caused a remarkable sensation among the party.", "Some of the birds hurried off at once, and a Canary called out in a trembling voice, to its children, \"Come away, my dears! It's high time you were all in bed!\"", "On various pretexts they all moved off and Alice was soon left alone.", "\"I wish I hadn't mentioned Dinah! Nobody seems to like her down here and I'm sure she's the best cat in the world!\"", "Poor Alice began to cry again, for she felt very lonely and low-spirited.", "In a little while, however, she again heard a little pattering of footsteps in the distance and she looked up eagerly.", "IV--THE RABBIT SENDS IN A LITTLE BILL", "It was the White Rabbit, trotting slowly back again and looking anxiously about as it went, as if it had lost something; Alice heard it muttering to itself, \"The Duchess! The Duchess! Oh, my dear paws! Oh, my fur and whiskers! She'll get me executed, as sure as ferrets are ferrets! Where _can_ I have dropped them, I wonder?\"", "Alice guessed in a moment that it was looking for the fan and the pair of white kid-gloves and she very good-naturedly began hunting about for them, but they were nowhere to be seen--everything seemed to have changed since her swim in the pool, and the great hall, with the glass table and the little door, had vanished completely.", "Very soon the Rabbit noticed Alice, and called to her, in an angry tone, \"Why, Mary Ann, what _are_ you doing out here? Run home this moment and fetch me a pair of gloves and a fan! Quick, now!\"", "\"He took me for his housemaid!\" said Alice, as she ran off.", "\"How surprised he'll be when he finds out who I am!\"", "As she said this, she came upon a neat little house, on the door of which was a bright brass plate with the name \"W. RABBIT\" engraved upon it.", "She went in without knocking and hurried upstairs, in great fear lest she should meet the real Mary Ann and be turned out of the house before she had found the fan and gloves.", "By this time, Alice had found her way into a tidy little room with a table in the window, and on it a fan and two or three pairs of tiny white kid-gloves; she took up the fan and a pair of the gloves and was just going to leave the room, when her eyes fell upon a little bottle that stood near the looking-glass.", "She uncorked it and put it to her lips, saying to herself, \"I do hope it'll make me grow large again, for, really, I'm quite tired of being such a tiny little thing!\"", "Before she had drunk half the bottle, she found her head pressing against the ceiling, and had to stoop to save her neck from being broken.", "She hastily put down the bottle, remarking, \"That's quite enough--I hope I sha'n't grow any more.\"", "Alas!", "It was too late to wish that!", "She went on growing and growing and very soon she had to kneel down on the floor.", "Still she went on growing, and, as a last resource, she put one arm out of the window and one foot up the chimney, and said to herself, \"Now I can do no more, whatever happens. What _will_ become of me?\"", "Luckily for Alice, the little magic bottle had now had its full effect and she grew no larger.", "After a few minutes she heard a voice outside and stopped to listen.", "\"Mary Ann! Mary Ann!\" said the voice.", "\"Fetch me my gloves this moment!\"", "Then came a little pattering of feet on the stairs.", "Alice knew it was the Rabbit coming to look for her and she trembled till she shook the house, quite forgetting that she was now about a thousand times as large as the Rabbit and had no reason to be afraid of it.", "Presently the Rabbit came up to the door and tried to open it; but as the door opened inwards and Alice's elbow was pressed hard against it, that attempt proved a failure.", "Alice heard it say to itself, \"Then I'll go 'round and get in at the window.\"", "\"_That_ you won't!\" thought Alice; and after waiting till she fancied she heard the Rabbit just under the window, she suddenly spread out her hand and made a snatch in the air.", "She did not get hold of anything, but she heard a little shriek and a fall and a crash of broken glass, from which she concluded that it was just possible it had fallen into a cucumber-frame or something of that sort.", "Next came an angry voice--the Rabbit's--\"Pat! Pat! Where are you?\"", "And then a voice she had never heard before, \"Sure then, I'm here! Digging for apples, yer honor!\"", "\"Here! Come and help me out of this! Now tell me, Pat, what's that in the window?\"", "\"Sure, it's an arm, yer honor!\"", "\"Well, it's got no business there, at any rate; go and take it away!\"", "There was a long silence after this and Alice could only hear whispers now and then, and at last she spread out her hand again and made another snatch in the air.", "This time there were _two_ little shrieks and more sounds of broken glass.", "\"I wonder what they'll do next!\" thought Alice.", "\"As for pulling me out of the window, I only wish they _could_!\"", "She waited for some time without hearing anything more.", "At last came a rumbling of little cart-wheels and the sound of a good many voices all talking together.", "She made out the words: \"Where's the other ladder? Bill's got the other--Bill! Here, Bill! Will the roof bear?--Who's to go down the chimney?--Nay, _I_ sha'n't! _You_ do it! Here, Bill! The master says you've got to go down the chimney!\"", "Alice drew her foot as far down the chimney as she could and waited till she heard a little animal scratching and scrambling about in the chimney close above her; then she gave one sharp kick and waited to see what would happen next.", "The first thing she heard was a general chorus of \"There goes Bill!\" then the Rabbit's voice alone--\"Catch him, you by the hedge!\"", "Then silence and then another confusion of voices--\"Hold up his head--Brandy now--Don't choke him--What happened to you?\"", "Last came a little feeble, squeaking voice, \"Well, I hardly know--No more, thank ye. I'm better now--all I know is, something comes at me like a Jack-in-the-box and up I goes like a sky-rocket!\"", "After a minute or two of silence, they began moving about again, and Alice heard the Rabbit say, \"A barrowful will do, to begin with.\"", "\"A barrowful of _what_?\" thought Alice.", "But she had not long to doubt, for the next moment a shower of little pebbles came rattling in at the window and some of them hit her in the face.", "Alice noticed, with some surprise, that the pebbles were all turning into little cakes as they lay on the floor and a bright idea came into her head.", "\"If I eat one of these cakes,\" she thought, \"it's sure to make _some_ change in my size.\"", "So she swallowed one of the cakes and was delighted to find that she began shrinking directly.", "As soon as she was small enough to get through the door, she ran out of the house and found quite a crowd of little animals and birds waiting outside.", "They all made a rush at Alice the moment she appeared, but she ran off as hard as she could and soon found herself safe in a thick wood.", "\"The first thing I've got to do,\" said Alice to herself, as she wandered about in the wood, \"is to grow to my right size again; and the second thing is to find my way into that lovely garden. I suppose I ought to eat or drink something or other, but the great question is 'What?'\"", "Alice looked all around her at the flowers and the blades of grass, but she could not see anything that looked like the right thing to eat or drink under the circumstances.", "There was a large mushroom growing near her, about the same height as herself.", "She stretched herself up on tiptoe and peeped over the edge and her eyes immediately met those of a large blue caterpillar, that was sitting on the top, with its arms folded, quietly smoking a long hookah and taking not the smallest notice of her or of anything else.", "V--ADVICE FROM A CATERPILLAR", "At last the Caterpillar took the hookah out of its mouth and addressed Alice in a languid, sleepy voice.", "\"Who are _you_?\" said the Caterpillar.", "Alice replied, rather shyly, \"I--I hardly know, sir, just at present--at least I know who I _was_ when I got up this morning, but I think I must have changed several times since then.\"", "\"What do you mean by that?\" said the Caterpillar, sternly.", "\"Explain yourself!\"", "\"I can't explain _myself_, I'm afraid, sir,\" said Alice, \"because I'm not myself, you see--being so many different sizes in a day is very confusing.\"", "She drew herself up and said very gravely, \"I think you ought to tell me who _you_ are, first.\"", "\"Why?\" said the Caterpillar.", "As Alice could not think of any good reason and the Caterpillar seemed to be in a _very_ unpleasant state of mind, she turned away.", "\"Come back!\" the Caterpillar called after her.", "\"I've something important to say!\"", "Alice turned and came back again.", "\"Keep your temper,\" said the Caterpillar.", "\"Is that all?\" said Alice, swallowing down her anger as well as she could.", "\"No,\" said the Caterpillar.", "It unfolded its arms, took the hookah out of its mouth again, and said, \"So you think you're changed, do you?\"", "\"I'm afraid, I am, sir,\" said Alice.", "\"I can't remember things as I used--and I don't keep the same size for ten minutes together!\"", "\"What size do you want to be?\" asked the Caterpillar.", "\"Oh, I'm not particular as to size,\" Alice hastily replied, \"only one doesn't like changing so often, you know. I should like to be a _little_ larger, sir, if you wouldn't mind,\" said Alice.", "\"Three inches is such a wretched height to be.\"", "\"It is a very good height indeed!\" said the Caterpillar angrily, rearing itself upright as it spoke (it was exactly three inches high).", "In a minute or two, the Caterpillar got down off the mushroom and crawled away into the grass, merely remarking, as it went, \"One side will make you grow taller, and the other side will make you grow shorter.\"", "\"One side of _what_? The other side of _what_?\" thought Alice to herself.", "\"Of the mushroom,\" said the Caterpillar, just as if she had asked it aloud; and in another moment, it was out of sight.", "Alice remained looking thoughtfully at the mushroom for a minute, trying to make out which were the two sides of it.", "At last she stretched her arms 'round it as far as they would go, and broke off a bit of the edge with each hand.", "\"And now which is which?\" she said to herself, and nibbled a little of the right-hand bit to try the effect.", "The next moment she felt a violent blow underneath her chin--it had struck her foot!", "She was a good deal frightened by this very sudden change, as she was shrinking rapidly; so she set to work at once to eat some of the other bit.", "Her chin was pressed so closely against her foot that there was hardly room to open her mouth; but she did it at last and managed to swallow a morsel of the left-hand bit....", "\"Come, my head's free at last!\" said Alice; but all she could see, when she looked down, was an immense length of neck, which seemed to rise like a stalk out of a sea of green leaves that lay far below her.", "\"Where _have_ my shoulders got to? And oh, my poor hands, how is it I can't see you?\"", "She was delighted to find that her neck would bend about easily in any direction, like a serpent.", "She had just succeeded in curving it down into a graceful zigzag and was going to dive in among the leaves, when a sharp hiss made her draw back in a hurry--a large pigeon had flown into her face and was beating her violently with its wings.", "\"Serpent!\" cried the Pigeon.", "\"I'm _not_ a serpent!\" said Alice indignantly.", "\"Let me alone!\"", "\"I've tried the roots of trees, and I've tried banks, and I've tried hedges,\" the Pigeon went on, \"but those serpents! There's no pleasing them!\"", "Alice was more and more puzzled.", "\"As if it wasn't trouble enough hatching the eggs,\" said the Pigeon, \"but I must be on the look-out for serpents, night and day! And just as I'd taken the highest tree in the wood,\" continued the Pigeon, raising its voice to a shriek, \"and just as I was thinking I should be free of them at last, they must needs come wriggling down from the sky! Ugh, Serpent!\"", "\"But I'm _not_ a serpent, I tell you!\" said Alice.", "\"I'm a--I'm a--I'm a little girl,\" she added rather doubtfully, as she remembered the number of changes she had gone through that day.", "\"You're looking for eggs, I know _that_ well enough,\" said the Pigeon; \"and what does it matter to me whether you're a little girl or a serpent?\"", "\"It matters a good deal to _me_,\" said Alice hastily; \"but I'm not looking for eggs, as it happens, and if I was, I shouldn't want _yours_--I don't like them raw.\"", "\"Well, be off, then!\" said the Pigeon in a sulky tone, as it settled down again into its nest.", "Alice crouched down among the trees as well as she could, for her neck kept getting entangled among the branches, and every now and then she had to stop and untwist it.", "After awhile she remembered that she still held the pieces of mushroom in her hands, and she set to work very carefully, nibbling first at one and then at the other, and growing sometimes taller and sometimes shorter, until she had succeeded in bringing herself down to her usual height.", "It was so long since she had been anything near the right size that it felt quite strange at first.", "\"The next thing is to get into that beautiful garden--how _is_ that to be done, I wonder?\"", "As she said this, she came suddenly upon an open place, with a little house in it about four feet high.", "\"Whoever lives there,\" thought Alice, \"it'll never do to come upon them _this_ size; why, I should frighten them out of their wits!\"", "She did not venture to go near the house till she had brought herself down to nine inches high.", "VI--PIG AND PEPPER", "For a minute or two she stood looking at the house, when suddenly a footman in livery came running out of the wood (judging by his face only, she would have called him a fish)--and rapped loudly at the door with his knuckles.", "It was opened by another footman in livery, with a round face and large eyes like a frog.", "The Fish-Footman began by producing from under his arm a great letter, and this he handed over to the other, saying, in a solemn tone, \"For the Duchess. An invitation from the Queen to play croquet.\"", "The Frog-Footman repeated, in the same solemn tone, \"From the Queen. An invitation for the Duchess to play croquet.\"", "Then they both bowed low and their curls got entangled together.", "When Alice next peeped out, the Fish-Footman was gone, and the other was sitting on the ground near the door, staring stupidly up into the sky.", "Alice went timidly up to the door and knocked.", "\"There's no sort of use in knocking,\" said the Footman, \"and that for two reasons. First, because I'm on the same side of the door as you are; secondly, because they're making such a noise inside, no one could possibly hear you.\"", "And certainly there _was_ a most extraordinary noise going on within--a constant howling and sneezing, and every now and then a great crash, as if a dish or kettle had been broken to pieces.", "\"How am I to get in?\" asked Alice.", "\"_Are_ you to get in at all?\" said the Footman.", "\"That's the first question, you know.\"", "Alice opened the door and went in.", "The door led right into a large kitchen, which was full of smoke from one end to the other; the Duchess was sitting on a three-legged stool in the middle, nursing a baby; the cook was leaning over the fire, stirring a large caldron which seemed to be full of soup.", "\"There's certainly too much pepper in that soup!\"", "Alice said to herself, as well as she could for sneezing.", "Even the Duchess sneezed occasionally; and as for the baby, it was sneezing and howling alternately without a moment's pause.", "The only two creatures in the kitchen that did _not_ sneeze were the cook and a large cat, which was grinning from ear to ear.", "\"Please would you tell me,\" said Alice, a little timidly, \"why your cat grins like that?\"", "\"It's a Cheshire-Cat,\" said the Duchess, \"and that's why.\"", "\"I didn't know that Cheshire-Cats always grinned; in fact, I didn't know that cats _could_ grin,\" said Alice.", "\"You don't know much,\" said the Duchess, \"and that's a fact.\"", "Just then the cook took the caldron of soup off the fire, and at once set to work throwing everything within her reach at the Duchess and the baby--the fire-irons came first; then followed a shower of saucepans, plates and dishes.", "The Duchess took no notice of them, even when they hit her, and the baby was howling so much already that it was quite impossible to say whether the blows hurt it or not.", "\"Oh, _please_ mind what you're doing!\" cried Alice, jumping up and down in an agony of terror.", "\"Here! You may nurse it a bit, if you like!\" the Duchess said to Alice, flinging the baby at her as she spoke.", "\"I must go and get ready to play croquet with the Queen,\" and she hurried out of the room.", "Alice caught the baby with some difficulty, as it was a queer-shaped little creature and held out its arms and legs in all directions.", "\"If I don't take this child away with me,\" thought Alice, \"they're sure to kill it in a day or two. Wouldn't it be murder to leave it behind?\"", "She said the last words out loud and the little thing grunted in reply.", "\"If you're going to turn into a pig, my dear,\" said Alice, \"I'll have nothing more to do with you. Mind now!\"", "Alice was just beginning to think to herself, \"Now, what am I to do with this creature, when I get it home?\" when it grunted again so violently that Alice looked down into its face in some alarm.", "This time there could be _no_ mistake about it--it was neither more nor less than a pig; so she set the little creature down and felt quite relieved to see it trot away quietly into the wood.", "Alice was a little startled by seeing the Cheshire-Cat sitting on a bough of a tree a few yards off.", "The Cat only grinned when it saw her.", "\"Cheshire-Puss,\" began Alice, rather timidly, \"would you please tell me which way I ought to go from here?\"", "\"In _that_ direction,\" the Cat said, waving the right paw 'round, \"lives a Hatter; and in _that_ direction,\" waving the other paw, \"lives a March Hare. Visit either you like; they're both mad.\"", "\"But I don't want to go among mad people,\" Alice remarked.", "\"Oh, you can't help that,\" said the Cat; \"we're all mad here. Do you play croquet with the Queen to-day?\"", "\"I should like it very much,\" said Alice, \"but I haven't been invited yet.\"", "\"You'll see me there,\" said the Cat, and vanished.", "Alice had not gone much farther before she came in sight of the house of the March Hare; it was so large a house that she did not like to go near till she had nibbled some more of the left-hand bit of mushroom.", "VII--A MAD TEA-PARTY", "There was a table set out under a tree in front of the house, and the March Hare and the Hatter were having tea at it; a Dormouse was sitting between them, fast asleep.", "The table was a large one, but the three were all crowded together at one corner of it.", "\"No room! No room!\" they cried out when they saw Alice coming.", "\"There's _plenty_ of room!\" said Alice indignantly, and she sat down in a large arm-chair at one end of the table.", "The Hatter opened his eyes very wide on hearing this, but all he said was \"Why is a raven like a writing-desk?\"", "\"I'm glad they've begun asking riddles--I believe I can guess that,\" she added aloud.", "\"Do you mean that you think you can find out the answer to it?\" said the March Hare.", "\"Exactly so,\" said Alice.", "\"Then you should say what you mean,\" the March Hare went on.", "\"I do,\" Alice hastily replied; \"at least--at least I mean what I say--that's the same thing, you know.\"", "\"You might just as well say,\" added the Dormouse, which seemed to be talking in its sleep, \"that 'I breathe when I sleep' is the same thing as 'I sleep when I breathe!'\"", "\"It _is_ the same thing with you,\" said the Hatter, and he poured a little hot tea upon its nose.", "The Dormouse shook its head impatiently and said, without opening its eyes, \"Of course, of course; just what I was going to remark myself.\"", "\"Have you guessed the riddle yet?\" the Hatter said, turning to Alice again.", "\"No, I give it up,\" Alice replied.", "\"What's the answer?\"", "\"I haven't the slightest idea,\" said the Hatter.", "\"Nor I,\" said the March Hare.", "Alice gave a weary sigh.", "\"I think you might do something better with the time,\" she said, \"than wasting it in asking riddles that have no answers.\"", "\"Take some more tea,\" the March Hare said to Alice, very earnestly.", "\"I've had nothing yet,\" Alice replied in an offended tone, \"so I can't take more.\"", "\"You mean you can't take _less_,\" said the Hatter; \"it's very easy to take _more_ than nothing.\"", "At this, Alice got up and walked off.", "The Dormouse fell asleep instantly and neither of the others took the least notice of her going, though she looked back once or twice; the last time she saw them, they were trying to put the Dormouse into the tea-pot.", "\"At any rate, I'll never go _there_ again!\" said Alice, as she picked her way through the wood.", "\"It's the stupidest tea-party I ever was at in all my life!\"", "Just as she said this, she noticed that one of the trees had a door leading right into it.", "\"That's very curious!\" she thought.", "\"I think I may as well go in at once.\"", "And in she went.", "Once more she found herself in the long hall and close to the little glass table.", "Taking the little golden key, she unlocked the door that led into the garden.", "Then she set to work nibbling at the mushroom (she had kept a piece of it in her pocket) till she was about a foot high; then she walked down the little passage; and _then_--she found herself at last in the beautiful garden, among the bright flower-beds and the cool fountains.", "VIII--THE QUEEN'S CROQUET GROUND", "A large rose-tree stood near the entrance of the garden; the roses growing on it were white, but there were three gardeners at it, busily painting them red.", "Suddenly their eyes chanced to fall upon Alice, as she stood watching them.", "\"Would you tell me, please,\" said Alice, a little timidly, \"why you are painting those roses?\"", "Five and Seven said nothing, but looked at Two.", "Two began, in a low voice, \"Why, the fact is, you see, Miss, this here ought to have been a _red_ rose-tree, and we put a white one in by mistake; and, if the Queen was to find it out, we should all have our heads cut off, you know. So you see, Miss, we're doing our best, afore she comes, to--\"", "At this moment, Five, who had been anxiously looking across the garden, called out, \"The Queen! The Queen!\" and the three gardeners instantly threw themselves flat upon their faces.", "There was a sound of many footsteps and Alice looked 'round, eager to see the Queen.", "First came ten soldiers carrying clubs, with their hands and feet at the corners: next the ten courtiers; these were ornamented all over with diamonds.", "After these came the royal children; there were ten of them, all ornamented with hearts.", "Next came the guests, mostly Kings and Queens, and among them Alice recognized the White Rabbit.", "Then followed the Knave of Hearts, carrying the King's crown on a crimson velvet cushion; and last of all this grand procession came THE KING AND THE QUEEN OF HEARTS.", "When the procession came opposite to Alice, they all stopped and looked at her, and the Queen said severely, \"Who is this?\"", "She said it to the Knave of Hearts, who only bowed and smiled in reply.", "\"My name is Alice, so please Your Majesty,\" said Alice very politely; but she added to herself, \"Why, they're only a pack of cards, after all!\"", "\"Can you play croquet?\" shouted the Queen.", "The question was evidently meant for Alice.", "\"Yes!\" said Alice loudly.", "\"Come on, then!\" roared the Queen.", "\"It's--it's a very fine day!\" said a timid voice to Alice.", "She was walking by the White Rabbit, who was peeping anxiously into her face.", "\"Very,\" said Alice.", "\"Where's the Duchess?\"", "\"Hush! Hush!\" said the Rabbit.", "\"She's under sentence of execution.\"", "\"What for?\" said Alice.", "\"She boxed the Queen's ears--\" the Rabbit began.", "\"Get to your places!\" shouted the Queen in a voice of thunder, and people began running about in all directions, tumbling up against each other.", "However, they got settled down in a minute or two, and the game began.", "Alice thought she had never seen such a curious croquet-ground in her life; it was all ridges and furrows.", "The croquet balls were live hedgehogs, and the mallets live flamingos and the soldiers had to double themselves up and stand on their hands and feet, to make the arches.", "The players all played at once, without waiting for turns, quarrelling all the while and fighting for the hedgehogs; and in a very short time, the Queen was in a furious passion and went stamping about and shouting, \"Off with his head!\" or \"Off with her head!\" about once in a minute.", "\"They're dreadfully fond of beheading people here,\" thought Alice; \"the great wonder is that there's anyone left alive!\"", "She was looking about for some way of escape, when she noticed a curious appearance in the air.", "\"It's the Cheshire-Cat,\" she said to herself; \"now I shall have somebody to talk to.\"", "\"How are you getting on?\" said the Cat.", "\"I don't think they play at all fairly,\" Alice said, in a rather complaining tone; \"and they all quarrel so dreadfully one can't hear oneself speak--and they don't seem to have any rules in particular.\"", "\"How do you like the Queen?\" said the Cat in a low voice.", "\"Not at all,\" said Alice.", "Alice thought she might as well go back and see how the game was going on.", "So she went off in search of her hedgehog.", "The hedgehog was engaged in a fight with another hedgehog, which seemed to Alice an excellent opportunity for croqueting one of them with the other; the only difficulty was that her flamingo was gone across to the other side of the garden, where Alice could see it trying, in a helpless sort of way, to fly up into a tree.", "She caught the flamingo and tucked it away under her arm, that it might not escape again.", "Just then Alice ran across the Duchess (who was now out of prison).", "She tucked her arm affectionately into Alice's and they walked off together.", "Alice was very glad to find her in such a pleasant temper.", "She was a little startled, however, when she heard the voice of the Duchess close to her ear.", "\"You're thinking about something, my dear, and that makes you forget to talk.\"", "\"The game's going on rather better now,\" Alice said, by way of keeping up the conversation a little.", "\"'Tis so,\" said the Duchess; \"and the moral of that is--'Oh, 'tis love, 'tis love that makes the world go 'round!'\"", "\"Somebody said,\" Alice whispered, \"that it's done by everybody minding his own business!\"", "\"Ah, well! It means much the same thing,\" said the Duchess, digging her sharp little chin into Alice's shoulder, as she added \"and the moral of _that_ is--'Take care of the sense and the sounds will take care of themselves.'\"", "To Alice's great surprise, the Duchess's arm that was linked into hers began to tremble.", "Alice looked up and there stood the Queen in front of them, with her arms folded, frowning like a thunderstorm!", "\"Now, I give you fair warning,\" shouted the Queen, stamping on the ground as she spoke, \"either you or your head must be off, and that in about half no time. Take your choice!\"", "The Duchess took her choice, and was gone in a moment.", "\"Let's go on with the game,\" the Queen said to Alice; and Alice was too much frightened to say a word, but slowly followed her back to the croquet-ground.", "All the time they were playing, the Queen never left off quarreling with the other players and shouting, \"Off with his head!\" or \"Off with her head!\"", "By the end of half an hour or so, all the players, except the King, the Queen and Alice, were in custody of the soldiers and under sentence of execution.", "Then the Queen left off, quite out of breath, and walked away with Alice.", "Alice heard the King say in a low voice to the company generally, \"You are all pardoned.\"", "Suddenly the cry \"The Trial's beginning!\" was heard in the distance, and Alice ran along with the others.", "IX--WHO STOLE THE TARTS?", "The King and Queen of Hearts were seated on their throne when they arrived, with a great crowd assembled about them--all sorts of little birds and beasts, as well as the whole pack of cards: the Knave was standing before them, in chains, with a soldier on each side to guard him; and near the King was the White Rabbit, with a trumpet in one hand and a scroll of parchment in the other.", "In the very middle of the court was a table, with a large dish of tarts upon it.", "\"I wish they'd get the trial done,\" Alice thought, \"and hand 'round the refreshments!\"", "The judge, by the way, was the King and he wore his crown over his great wig.", "\"That's the jury-box,\" thought Alice; \"and those twelve creatures (some were animals and some were birds) I suppose they are the jurors.\"", "Just then the White Rabbit cried out \"Silence in the court!\"", "\"Herald, read the accusation!\" said the King.", "On this, the White Rabbit blew three blasts on the trumpet, then unrolled the parchment-scroll and read as follows:", "\"Call the first witness,\" said the King; and the White Rabbit blew three blasts on the trumpet and called out, \"First witness!\"", "The first witness was the Hatter.", "He came in with a teacup in one hand and a piece of bread and butter in the other.", "\"You ought to have finished,\" said the King.", "\"When did you begin?\"", "The Hatter looked at the March Hare, who had followed him into the court, arm in arm with the Dormouse.", "\"Fourteenth of March, I _think_ it was,\" he said.", "\"Give your evidence,\" said the King, \"and don't be nervous, or I'll have you executed on the spot.\"", "This did not seem to encourage the witness at all; he kept shifting from one foot to the other, looking uneasily at the Queen, and, in his confusion, he bit a large piece out of his teacup instead of the bread and butter.", "Just at this moment Alice felt a very curious sensation--she was beginning to grow larger again.", "The miserable Hatter dropped his teacup and bread and butter and went down on one knee.", "\"I'm a poor man, Your Majesty,\" he began.", "\"You're a _very_ poor _speaker_,\" said the King.", "\"You may go,\" said the King, and the Hatter hurriedly left the court.", "\"Call the next witness!\" said the King.", "The next witness was the Duchess's cook.", "She carried the pepper-box in her hand and the people near the door began sneezing all at once.", "\"Give your evidence,\" said the King.", "\"Sha'n't,\" said the cook.", "The King looked anxiously at the White Rabbit, who said, in a low voice, \"Your Majesty must cross-examine _this_ witness.\"", "\"Well, if I must, I must,\" the King said.", "\"What are tarts made of?\"", "\"Pepper, mostly,\" said the cook.", "For some minutes the whole court was in confusion and by the time they had settled down again, the cook had disappeared.", "\"Never mind!\" said the King, \"call the next witness.\"", "Alice watched the White Rabbit as he fumbled over the list.", "Imagine her surprise when he read out, at the top of his shrill little voice, the name \"Alice!\"", "X--ALICE'S EVIDENCE", "\"Here!\" cried Alice.", "She jumped up in such a hurry that she tipped over the jury-box, upsetting all the jurymen on to the heads of the crowd below.", "\"Oh, I _beg_ your pardon!\" she exclaimed in a tone of great dismay.", "\"The trial cannot proceed,\" said the King, \"until all the jurymen are back in their proper places--_all_,\" he repeated with great emphasis, looking hard at Alice.", "\"What do you know about this business?\" the King said to Alice.", "\"Nothing whatever,\" said Alice.", "The King then read from his book: \"Rule forty-two. _All persons more than a mile high to leave the court_.\"", "\"_I'm_ not a mile high,\" said Alice.", "\"Nearly two miles high,\" said the Queen.", "\"Well, I sha'n't go, at any rate,\" said Alice.", "The King turned pale and shut his note-book hastily.", "\"Consider your verdict,\" he said to the jury, in a low, trembling voice.", "\"There's more evidence to come yet, please Your Majesty,\" said the White Rabbit, jumping up in a great hurry.", "\"This paper has just been picked up. It seems to be a letter written by the prisoner to--to somebody.\"", "He unfolded the paper as he spoke and added, \"It isn't a letter, after all; it's a set of verses.\"", "\"Please, Your Majesty,\" said the Knave, \"I didn't write it and they can't prove that I did; there's no name signed at the end.\"", "\"You _must_ have meant some mischief, or else you'd have signed your name like an honest man,\" said the King.", "There was a general clapping of hands at this.", "\"Read them,\" he added, turning to the White Rabbit.", "There was dead silence in the court whilst the White Rabbit read out the verses.", "\"That's the most important piece of evidence we've heard yet,\" said the King.", "\"_I_ don't believe there's an atom of meaning in it,\" ventured Alice.", "\"If there's no meaning in it,\" said the King, \"that saves a world of trouble, you know, as we needn't try to find any. Let the jury consider their verdict.\"", "\"No, no!\" said the Queen.", "\"Sentence first--verdict afterwards.\"", "\"Stuff and nonsense!\" said Alice loudly.", "\"The idea of having the sentence first!\"", "\"Hold your tongue!\" said the Queen, turning purple.", "\"I won't!\" said Alice.", "\"Off with her head!\" the Queen shouted at the top of her voice.", "Nobody moved.", "\"Who cares for _you_?\" said Alice (she had grown to her full size by this time).", "\"You're nothing but a pack of cards!\"", "At this, the whole pack rose up in the air and came flying down upon her; she gave a little scream, half of fright and half of anger, and tried to beat them off, and found herself lying on the bank, with her head in the lap of her sister, who was gently brushing away some dead leaves that had fluttered down from the trees upon her face.", "\"Wake up, Alice dear!\" said her sister.", "\"Why, what a long sleep you've had!\"", "\"Oh, I've had such a curious dream!\" said Alice.", "And she told her sister, as well as she could remember them, all these strange adventures of hers that you have just been reading about.", "Alice got up and ran off, thinking while she ran, as well she might, what a wonderful dream it had been."])
      end

      it "correctly segments text #095" do
        ps = PragmaticSegmenter::Segmenter.new(text: "\"Dear, dear! How queer everything is to-day! And yesterday things went on just as usual. _Was_ I the same when I got up this morning? But if I'm not the same, the next question is, 'Who in the world am I?' Ah, _that's_ the great puzzle!\"")
        expect(ps.segment).to eq(["\"Dear, dear! How queer everything is to-day! And yesterday things went on just as usual. _Was_ I the same when I got up this morning? But if I'm not the same, the next question is, 'Who in the world am I?' Ah, _that's_ the great puzzle!\""])
      end

      it "correctly segments text #096" do
        ps = PragmaticSegmenter::Segmenter.new(text: "Two began, in a low voice, \"Why, the fact is, you see, Miss, this here ought to have been a _red_ rose-tree, and we put a white one in by mistake; and, if the Queen was to find it out, we should all have our heads cut off, you know. So you see, Miss, we're doing our best, afore she comes, to--\" At this moment, Five, who had been anxiously looking across the garden, called out, \"The Queen! The Queen!\" and the three gardeners instantly threw themselves flat upon their faces.")
        expect(ps.segment).to eq(["Two began, in a low voice, \"Why, the fact is, you see, Miss, this here ought to have been a _red_ rose-tree, and we put a white one in by mistake; and, if the Queen was to find it out, we should all have our heads cut off, you know. So you see, Miss, we're doing our best, afore she comes, to--\"", "At this moment, Five, who had been anxiously looking across the garden, called out, \"The Queen! The Queen!\" and the three gardeners instantly threw themselves flat upon their faces."])
      end

      it "correctly segments text #097" do
        ps = PragmaticSegmenter::Segmenter.new(text: "\"Dinah'll miss me very much to-night, I should think!\" (Dinah was the cat.) \"I hope they'll remember her saucer of milk at tea-time. Dinah, my dear, I wish you were down here with me!\"")
        expect(ps.segment).to eq(["\"Dinah'll miss me very much to-night, I should think!\"", "(Dinah was the cat.)", "\"I hope they'll remember her saucer of milk at tea-time. Dinah, my dear, I wish you were down here with me!\""])
      end

      it "correctly segments text #098" do
        ps = PragmaticSegmenter::Segmenter.new(text: "Hello. 'This is a test of single quotes.' A new sentence.")
        expect(ps.segment).to eq(["Hello.", "'This is a test of single quotes.'", "A new sentence."])
      end

      it "correctly segments text #099" do
        ps = PragmaticSegmenter::Segmenter.new(text: "[A sentence in square brackets.]")
        expect(ps.segment).to eq(["[A sentence in square brackets.]"])
      end

      it "correctly segments text #100" do
        ps = PragmaticSegmenter::Segmenter.new(text: "(iii) List item number 3.")
        expect(ps.segment).to eq(["(iii) List item number 3."])
      end

      it "correctly segments text #101" do
        ps = PragmaticSegmenter::Segmenter.new(text: "Unbelievable??!?!")
        expect(ps.segment).to eq(["Unbelievable??!?!"])
      end

      it "correctly segments text #102" do
        ps = PragmaticSegmenter::Segmenter.new(text: "This abbreviation f.e. means for example.")
        expect(ps.segment).to eq(["This abbreviation f.e. means for example."])
      end

      it "correctly segments text #103" do
        ps = PragmaticSegmenter::Segmenter.new(text: "The med. staff here is very kind.")
        expect(ps.segment).to eq(["The med. staff here is very kind."])
      end

      it "correctly segments text #104" do
        ps = PragmaticSegmenter::Segmenter.new(text: "What did you order btw., she wondered.")
        expect(ps.segment).to eq(["What did you order btw., she wondered."])
      end

      it "correctly segments text #105" do
        ps = PragmaticSegmenter::Segmenter.new(text: "SEC. 1262 AUTHORIZATION OF APPROPRIATIONS.")
        expect(ps.segment).to eq(["SEC. 1262 AUTHORIZATION OF APPROPRIATIONS."])
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

      it 'correctly segments text #033' do
        ps = PragmaticSegmenter::Segmenter.new(text: "Mit Inkrafttreten des Mindestlohngesetzes (MiLoG) zum 01. Januar 2015 werden in Bezug auf den Einsatz von Leistungs.", language: 'de')
        expect(ps.segment).to eq(["Mit Inkrafttreten des Mindestlohngesetzes (MiLoG) zum 01. Januar 2015 werden in Bezug auf den Einsatz von Leistungs."])
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

  context 'Language: Dutch (nl)' do
    describe '#segment' do
      it 'correctly segments text #001' do
        ps = PragmaticSegmenter::Segmenter.new(text: "Afkorting aanw. vnw.", language: 'nl')
        expect(ps.segment).to eq(["Afkorting aanw. vnw."])
      end
    end
  end

  context 'Language: Polish (pl)' do
    describe '#segment' do
      it 'correctly segments text #001' do
        ps = PragmaticSegmenter::Segmenter.new(text: "To słowo bałt. jestskrótem.", language: 'pl')
        expect(ps.segment).to eq(["To słowo bałt. jestskrótem."])
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
      it 'cleans the text #001' do
        ps = PragmaticSegmenter::Cleaner.new(text: "It was a cold \nnight in the city.", language: "en")
        expect(ps.clean).to eq("It was a cold night in the city.")
      end

      it 'cleans the text #002' do
        text = 'injections made by the Shareholder through the years. 7 (max.) 3. Specifications/4.Design and function The operating instructions are part of the product and must be kept in the immediate vicinity of the instrument and readily accessible to skilled "'
        ps = PragmaticSegmenter::Cleaner.new(text: text)
        expect(ps.clean).to eq('')
      end

      it 'does not mutate the input string (cleaner)' do
        text = "It was a cold \nnight in the city."
        PragmaticSegmenter::Cleaner.new(text: text, language: "en").clean
        expect(text).to eq("It was a cold \nnight in the city.")
      end
    end
  end
end
