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
