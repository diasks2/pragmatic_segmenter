require 'spec_helper'

RSpec.describe PragmaticSegmenter::Languages::Danish, "(da)" do

  context "Golden Rules" do
    it "Simple period to end sentence #001" do
      ps = PragmaticSegmenter::Segmenter.new(text: "Hej Verden. Mit navn er Jonas.", language: "da")
      expect(ps.segment).to eq(["Hej Verden.", "Mit navn er Jonas."])
    end

    it "Question mark to end sentence #002" do
      ps = PragmaticSegmenter::Segmenter.new(text: "Hvad er dit navn? Mit nav er Jonas.", language: "da")
      expect(ps.segment).to eq(["Hvad er dit navn?", "Mit nav er Jonas."])
    end

    it "Exclamation point to end sentence #003" do
      ps = PragmaticSegmenter::Segmenter.new(text: "There it is! I found it.", language: "da")
      expect(ps.segment).to eq(["There it is!", "I found it."])
    end

    it "One letter upper case abbreviations #004" do
      ps = PragmaticSegmenter::Segmenter.new(text: "My name is Jonas E. Smith.", language: "da")
      expect(ps.segment).to eq(["My name is Jonas E. Smith."])
    end

    it "One letter lower case abbreviations #005" do
      ps = PragmaticSegmenter::Segmenter.new(text: "Please turn to p. 55.", language: "da")
      expect(ps.segment).to eq(["Please turn to p. 55."])
    end

    it "Two letter lower case abbreviations in the middle of a sentence #006" do
      ps = PragmaticSegmenter::Segmenter.new(text: "Were Jane and co. at the party?", language: "da")
      expect(ps.segment).to eq(["Were Jane and co. at the party?"])
    end

    it "Two letter upper case abbreviations in the middle of a sentence #007" do
      ps = PragmaticSegmenter::Segmenter.new(text: "They closed the deal with Pitt, Briggs & Co. at noon.", language: "da")
      expect(ps.segment).to eq(["They closed the deal with Pitt, Briggs & Co. at noon."])
    end

    it "Two letter lower case abbreviations at the end of a sentence #008" do
      ps = PragmaticSegmenter::Segmenter.new(text: "Lad os spørge Jane og co. De burde vide det.", language: "da")
      expect(ps.segment).to eq(["Lad os spørge Jane og co.", "De burde vide det."])
    end

    it "Two letter upper case abbreviations at the end of a sentence #009" do
      ps = PragmaticSegmenter::Segmenter.new(text: "De lukkede aftalen med Pitt, Briggs & Co. Det lukkede i går.", language: "da")
      expect(ps.segment).to eq(["De lukkede aftalen med Pitt, Briggs & Co.", "Det lukkede i går."])
    end

    it "Two letter (prepositive) abbreviations #010" do
      ps = PragmaticSegmenter::Segmenter.new(text: "De holdt Skt. Hans i byen.", language: "da")
      expect(ps.segment).to eq(["De holdt Skt. Hans i byen."])
    end

    it "Two letter (prepositive & postpositive) abbreviations #011" do
      ps = PragmaticSegmenter::Segmenter.new(text: "St. Michael's Kirke er på 5. gade nær ved lyset.", language: "da")
      expect(ps.segment).to eq(["St. Michael's Kirke er på 5. gade nær ved lyset."])
    end

    it "Possesive two letter abbreviations #012" do
      ps = PragmaticSegmenter::Segmenter.new(text: "That is JFK Jr.'s book.", language: "da")
      expect(ps.segment).to eq(["That is JFK Jr.'s book."])
    end

    it "Multi-period abbreviations in the middle of a sentence #013" do
      ps = PragmaticSegmenter::Segmenter.new(text: "I visited the U.S.A. last year.", language: "da")
      expect(ps.segment).to eq(["I visited the U.S.A. last year."])
    end

    it "Multi-period abbreviations at the end of a sentence #014" do
      ps = PragmaticSegmenter::Segmenter.new(text: "Jeg bor i E.U. Hvad med dig?", language: "da")
      expect(ps.segment).to eq(["Jeg bor i E.U.", "Hvad med dig?"])
    end

    it "U.S. as sentence boundary #015" do
      ps = PragmaticSegmenter::Segmenter.new(text: "I live in the U.S. Hvad med dig?", language: "da")
      expect(ps.segment).to eq(["I live in the U.S.", "Hvad med dig?"])
    end

    it "U.S. as non sentence boundary with next word capitalized #016" do
      ps = PragmaticSegmenter::Segmenter.new(text: "I work for the U.S. Government in Virginia.", language: "da")
      expect(ps.segment).to eq(["I work for the U.S. Government in Virginia."])
    end

    it "U.S. as non sentence boundary #017" do
      ps = PragmaticSegmenter::Segmenter.new(text: "I have lived in the U.S. for 20 years.", language: "da")
      expect(ps.segment).to eq(["I have lived in the U.S. for 20 years."])
    end

    it "A.M. / P.M. as non sentence boundary and sentence boundary #018" do
      skip "NOT IMPLEMENTED"
      ps = PragmaticSegmenter::Segmenter.new(text: "At 5 a.m. Hr. Smith went to the bank. He left the bank at 6 P.M. Hr. Smith then went to the store.", language: "da")
      expect(ps.segment).to eq(["At 5 a.m. Hr. Smith went to the bank.", "He left the bank at 6 P.M.", "Hr. Smith then went to the store."])
    end

    it "Number as non sentence boundary #019" do
      ps = PragmaticSegmenter::Segmenter.new(text: "She has $100.00 in her bag.", language: "da")
      expect(ps.segment).to eq(["She has $100.00 in her bag."])
    end

    it "Number as sentence boundary #020" do
      ps = PragmaticSegmenter::Segmenter.new(text: "She has $100.00. It is in her bag.", language: "da")
      expect(ps.segment).to eq(["She has $100.00.", "It is in her bag."])
    end

    it "Parenthetical inside sentence #021" do
      ps = PragmaticSegmenter::Segmenter.new(text: "He teaches science (He previously worked for 5 years as an engineer.) at the local University.", language: "da")
      expect(ps.segment).to eq(["He teaches science (He previously worked for 5 years as an engineer.) at the local University."])
    end

    it "Email addresses #022" do
      ps = PragmaticSegmenter::Segmenter.new(text: "Her email is Jane.Doe@example.com. I sent her an email.", language: "da")
      expect(ps.segment).to eq(["Her email is Jane.Doe@example.com.", "I sent her an email."])
    end

    it "Web addresses #023" do
      ps = PragmaticSegmenter::Segmenter.new(text: "The site is: https://www.example.50.com/new-site/awesome_content.html. Please check it out.", language: "da")
      expect(ps.segment).to eq(["The site is: https://www.example.50.com/new-site/awesome_content.html.", "Please check it out."])
    end

    it "Single quotations inside sentence #024" do
      ps = PragmaticSegmenter::Segmenter.new(text: "She turned to him, 'This is great.' she said.", language: "da")
      expect(ps.segment).to eq(["She turned to him, 'This is great.' she said."])
    end

    it "Double quotations inside sentence #025" do
      ps = PragmaticSegmenter::Segmenter.new(text: "She turned to him, \"This is great.\" she said.", language: "da")
      expect(ps.segment).to eq(["She turned to him, \"This is great.\" she said."])
    end

    it "Double quotations at the end of a sentence #026" do
      ps = PragmaticSegmenter::Segmenter.new(text: "She turned to him, \"This is great.\" Hun held the book out to show him.", language: "da")
      expect(ps.segment).to eq(["She turned to him, \"This is great.\"", "Hun held the book out to show him."])
    end

    it "Double punctuation (exclamation point) #027" do
      ps = PragmaticSegmenter::Segmenter.new(text: "Hello!! Long time no see.", language: "da")
      expect(ps.segment).to eq(["Hello!!", "Long time no see."])
    end

    it "Double punctuation (question mark) #028" do
      ps = PragmaticSegmenter::Segmenter.new(text: "Hello?? Who is there?", language: "da")
      expect(ps.segment).to eq(["Hello??", "Who is there?"])
    end

    it "Double punctuation (exclamation point / question mark) #029" do
      ps = PragmaticSegmenter::Segmenter.new(text: "Hello!? Is that you?", language: "da")
      expect(ps.segment).to eq(["Hello!?", "Is that you?"])
    end

    it "Double punctuation (question mark / exclamation point) #030" do
      ps = PragmaticSegmenter::Segmenter.new(text: "Hello?! Is that you?", language: "da")
      expect(ps.segment).to eq(["Hello?!", "Is that you?"])
    end

    it "List (period followed by parens and no period to end item) #031" do
      ps = PragmaticSegmenter::Segmenter.new(text: "1.) The first item 2.) The second item", language: "da")
      expect(ps.segment).to eq(["1.) The first item", "2.) The second item"])
    end

    it "List (period followed by parens and period to end item) #032" do
      ps = PragmaticSegmenter::Segmenter.new(text: "1.) The first item. 2.) The second item.", language: "da")
      expect(ps.segment).to eq(["1.) The first item.", "2.) The second item."])
    end

    it "List (parens and no period to end item) #033" do
      ps = PragmaticSegmenter::Segmenter.new(text: "1) The first item 2) The second item", language: "da")
      expect(ps.segment).to eq(["1) The first item", "2) The second item"])
    end

    it "List (parens and period to end item) #034" do
      ps = PragmaticSegmenter::Segmenter.new(text: "1) The first item. 2) The second item.", language: "da")
      expect(ps.segment).to eq(["1) The first item.", "2) The second item."])
    end

    it "List (period to mark list and no period to end item) #035" do
      ps = PragmaticSegmenter::Segmenter.new(text: "1. The first item 2. The second item", language: "da")
      expect(ps.segment).to eq(["1. The first item", "2. The second item"])
    end

    it "List (period to mark list and period to end item) #036" do
      ps = PragmaticSegmenter::Segmenter.new(text: "1. The first item. 2. The second item.", language: "da")
      expect(ps.segment).to eq(["1. The first item.", "2. The second item."])
    end

    it "List with bullet #037" do
      ps = PragmaticSegmenter::Segmenter.new(text: "• 9. The first item • 10. The second item", language: "da")
      expect(ps.segment).to eq(["• 9. The first item", "• 10. The second item"])
    end

    it "List with hypthen #038" do
      ps = PragmaticSegmenter::Segmenter.new(text: "⁃9. The first item ⁃10. The second item", language: "da")
      expect(ps.segment).to eq(["⁃9. The first item", "⁃10. The second item"])
    end

    it "Alphabetical list #039" do
      ps = PragmaticSegmenter::Segmenter.new(text: "a. The first item b. The second item c. The third list item", language: "da")
      expect(ps.segment).to eq(["a. The first item", "b. The second item", "c. The third list item"])
    end

    it "Errant newlines in the middle of sentences (PDF) #040" do
      ps = PragmaticSegmenter::Segmenter.new(text: "This is a sentence\ncut off in the middle because pdf.", language: "da", doc_type: "pdf")
      expect(ps.segment).to eq(["This is a sentence cut off in the middle because pdf."])
    end

    it "Errant newlines in the middle of sentences #041" do
      ps = PragmaticSegmenter::Segmenter.new(text: "It was a cold \nnight in the city.", language: "da")
      expect(ps.segment).to eq(["It was a cold night in the city."])
    end

    it "Lower case list separated by newline #042" do
      ps = PragmaticSegmenter::Segmenter.new(text: "features\ncontact manager\nevents, activities\n", language: "da")
      expect(ps.segment).to eq(["features", "contact manager", "events, activities"])
    end

    it "Geo Coordinates #043" do
      ps = PragmaticSegmenter::Segmenter.new(text: "You can find it at N°. 1026.253.553. That is where the treasure is.", language: "da")
      expect(ps.segment).to eq(["You can find it at N°. 1026.253.553.", "That is where the treasure is."])
    end

    it "Named entities with an exclamation point #044" do
      ps = PragmaticSegmenter::Segmenter.new(text: "She works at Yahoo! in the accounting department.", language: "da")
      expect(ps.segment).to eq(["She works at Yahoo! in the accounting department."])
    end

    it "Ellipsis at end of quotation #046" do
      ps = PragmaticSegmenter::Segmenter.new(text: "Thoreau argues that by simplifying one’s life, “the laws of the universe will appear less complex. . . .”", language: "da")
      expect(ps.segment).to eq(["Thoreau argues that by simplifying one’s life, “the laws of the universe will appear less complex. . . .”"])
    end

    it "Ellipsis with square brackets #047" do
      ps = PragmaticSegmenter::Segmenter.new(text: "\"Bohr [...] used the analogy of parallel stairways [...]\" (Smith 55).", language: "da")
      expect(ps.segment).to eq(["\"Bohr [...] used the analogy of parallel stairways [...]\" (Smith 55)."])
    end

    it "Ellipsis as sentence boundary (standard ellipsis rules) #048" do
      ps = PragmaticSegmenter::Segmenter.new(text: "If words are left off at the end of a sentence, and that is all that is omitted, indicate the omission with ellipsis marks (preceded and followed by a space) and then indicate the end of the sentence with a period . . . . Next sentence.", language: "da")
      expect(ps.segment).to eq(["If words are left off at the end of a sentence, and that is all that is omitted, indicate the omission with ellipsis marks (preceded and followed by a space) and then indicate the end of the sentence with a period . . . .", "Next sentence."])
    end

    it "Ellipsis as sentence boundary (non-standard ellipsis rules) #049" do
      ps = PragmaticSegmenter::Segmenter.new(text: "I never meant that.... She left the store.", language: "da")
      expect(ps.segment).to eq(["I never meant that....", "She left the store."])
    end

    it "Ellipsis as non sentence boundary #050" do
      ps = PragmaticSegmenter::Segmenter.new(text: "I wasn’t really ... well, what I mean...see . . . what I'm saying, the thing is . . . I didn’t mean it.", language: "da")
      expect(ps.segment).to eq(["I wasn’t really ... well, what I mean...see . . . what I'm saying, the thing is . . . I didn’t mean it."])
    end

    it "4-dot ellipsis #051" do
      ps = PragmaticSegmenter::Segmenter.new(text: "One further habit which was somewhat weakened . . . was that of combining words into self-interpreting compounds. . . . The practice was not abandoned. . . .", language: "da")
      expect(ps.segment).to eq(["One further habit which was somewhat weakened . . . was that of combining words into self-interpreting compounds.", ". . . The practice was not abandoned. . . ."])
    end

    it "No whitespace in between sentences #052" do
      ps = PragmaticSegmenter::Segmenter.new(text: "Hello world.I dag is Tuesday.Hr. Smith went to the store and bought 1,000.That is a lot.", language: "da")
      expect(ps.segment).to eq(["Hello world.", "I dag is Tuesday.", "Hr. Smith went to the store and bought 1,000.", "That is a lot."])
    end
  end

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
      expect(ps.segment).to eq(["CELLULAR COMMUNICATIONS INC. sold 1,550,000 common shares at $21.75 each yesterday, according to lead underwriter L.F. Rothschild & Co. (cited from WSJ 05/29/1987)"])
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
      ps = PragmaticSegmenter::Segmenter.new(text: "His name is Mark E. Smith. a. here it is b. another c. one more\n They went to the store. It was John A. Smith. She was Jane B. Smith.", language: "da")
      expect(ps.segment).to eq(["His name is Mark E. Smith.", "a. here it is", "b. another", "c. one more", "They went to the store.", "It was John A. Smith.", "She was Jane B. Smith."])
    end

    it 'correctly segments text #076' do
      ps = PragmaticSegmenter::Segmenter.new(text: "a) here it is b) another c) one more\n They went to the store. w) hello x) hello y) hello", language: "da")
      expect(ps.segment).to eq(["a) here it is", "b) another", "c) one more", "They went to the store.", "w) hello",  "x) hello",  "y) hello"])
    end

    it 'correctly segments text #077' do
      ps = PragmaticSegmenter::Segmenter.new(text: "Hello{b^&gt;1&lt;b^} hello{b^>1<b^}.", language: "da")
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
      ps = PragmaticSegmenter::Segmenter.new(text: "The nurse gave him the s.u. in his vein. She gave him the s.u. Det var a great S.U. that she gave him. She gave him the S.U. Det was night.", language: "da")
      expect(ps.segment).to eq(["The nurse gave him the s.u. in his vein.", "She gave him the s.u.", "Det var a great S.U. that she gave him.", "She gave him the S.U.", "Det was night."])
    end

    it "correctly segments text #084" do
      ps = PragmaticSegmenter::Segmenter.new(text: "(i) Hello world. \n(ii) Hello world.\n(iii) Hello world.\n(iv) Hello world.\n(v) Hello world.\n(vi) Hello world.", language: "da")
      expect(ps.segment).to eq(["(i) Hello world.", "(ii) Hello world.", "(iii) Hello world.", "(iv) Hello world.", "(v) Hello world.", "(vi) Hello world."])
    end

    it "correctly segments text #085" do
      ps = PragmaticSegmenter::Segmenter.new(text: "i) Hello world. \nii) Hello world.\niii) Hello world.\niv) Hello world.\nv) Hello world.\nvi) Hello world.", language: "da")
      expect(ps.segment).to eq(["i) Hello world.", "ii) Hello world.", "iii) Hello world.", "iv) Hello world.", "v) Hello world.", "vi) Hello world."])
    end

    it "correctly segments text #086" do
      ps = PragmaticSegmenter::Segmenter.new(text: "(a) Hello world. (b) Hello world. (c) Hello world. (d) Hello world. (e) Hello world.\n(f) Hello world.", language: "da")
      expect(ps.segment).to eq(["(a) Hello world.", "(b) Hello world.", "(c) Hello world.", "(d) Hello world.", "(e) Hello world.", "(f) Hello world."])
    end

    it "correctly segments text #087" do
      ps = PragmaticSegmenter::Segmenter.new(text: "(A) Hello world. \n(B) Hello world.\n(C) Hello world.\n(D) Hello world.\n(E) Hello world.\n(F) Hello world.", language: "da")
      expect(ps.segment).to eq(["(A) Hello world.", "(B) Hello world.", "(C) Hello world.", "(D) Hello world.", "(E) Hello world.", "(F) Hello world."])
    end

    it "correctly segments text #088" do
      ps = PragmaticSegmenter::Segmenter.new(text: "A) Hello world. \nB) Hello world.\nC) Hello world.\nD) Hello world.\nE) Hello world.\nF) Hello world.", language: "da")
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
      expect(ps.segment).to eq(["DOWN THE RABBIT-HOLE", "Alice was beginning to get very tired of sitting by her sister on the bank, and of having nothing to do.", "Once or twice she had peeped into the book her sister was reading, but it had no pictures or conversations in it, \"and what is the use of a book,\" thought Alice, \"without pictures or conversations?\"", "So she was considering in her own mind (as well as she could, for the day made her feel very sleepy and stupid), whether the pleasure of making a daisy-chain would be worth the trouble of getting up and picking the daisies, when suddenly a White Rabbit with pink eyes ran close by her.", "There was nothing so very remarkable in that, nor did Alice think it so very much out of the way to hear the Rabbit say to itself, \"Oh dear! Oh dear! I shall be too late!\"", "But when the Rabbit actually took a watch out of its waistcoat-pocket and looked at it and then hurried on, Alice started to her feet, for it flashed across her mind that she had never before seen a rabbit with either a waistcoat-pocket, or a watch to take out of it, and, burning with curiosity, she ran across the field after it and was just in time to see it pop down a large rabbit-hole, under the hedge.", "In another moment, down went Alice after it!", "The rabbit-hole went straight on like a tunnel for some way and then dipped suddenly down, so suddenly that Alice had not a moment to think about stopping herself before she found herself falling down what seemed to be a very deep well.", "Either the well was very deep, or she fell very slowly, for she had plenty of time, as she went down, to look about her.", "First, she tried to make out what she was coming to, but it was too dark to see anything; then she looked at the sides of the well and noticed that they were filled with cupboards and book-shelves; here and there she saw maps and pictures hung upon pegs.", "She took down a jar from one of the shelves as she passed.", "It was labeled \"ORANGE MARMALADE,\" but, to her great disappointment, it was empty; she did not like to drop the jar, so managed to put it into one of the cupboards as she fell past it.", "Down, down, down!", "Would the fall never come to an end?", "There was nothing else to do, so Alice soon began talking to herself.", "\"Dinah'll miss me very much to-night, I should think!\"", "(Dinah was the cat.)", "\"I hope they'll remember her saucer of milk at tea-time. Dinah, my dear, I wish you were down here with me!\"", "Alice felt that she was dozing off, when suddenly, thump! thump! down she came upon a heap of sticks and dry leaves, and the fall was over.", "Alice was not a bit hurt, and she jumped up in a moment.", "She looked up, but it was all dark overhead; before her was another long passage and the White Rabbit was still in sight, hurrying down it.", "There was not a moment to be lost.", "Away went Alice like the wind and was just in time to hear it say, as it turned a corner, \"Oh, my ears and whiskers, how late it's getting!\"", "She was close behind it when she turned the corner, but the Rabbit was no longer to be seen.", "She found herself in a long, low hall, which was lit up by a row of lamps hanging from the roof.", "There were doors all 'round the hall, but they were all locked; and when Alice had been all the way down one side and up the other, trying every door, she walked sadly down the middle, wondering how she was ever to get out again.", "Suddenly she came upon a little table, all made of solid glass.", "There was nothing on it but a tiny golden key, and Alice's first idea was that this might belong to one of the doors of the hall; but, alas! either the locks were too large, or the key was too small, but, at any rate, it would not open any of them.", "However, on the second time 'round, she came upon a low curtain she had not noticed before, and behind it was a little door about fifteen inches high.", "She tried the little golden key in the lock, and to her great delight, it fitted!", "Alice opened the door and found that it led into a small passage, not much larger than a rat-hole; she knelt down and looked along the passage into the loveliest garden you ever saw.", "How she longed to get out of that dark hall and wander about among those beds of bright flowers and those cool fountains, but she could not even get her head through the doorway.", "\"Oh,\" said Alice, \"how I wish I could shut up like a telescope! I think I could, if I only knew how to begin.\"", "Alice went back to the table, half hoping she might find another key on it, or at any rate, a book of rules for shutting people up like telescopes.", "This time she found a little bottle on it (\"which certainly was not here before,\" said Alice), and tied 'round the neck of the bottle was a paper label, with the words \"DRINK ME\" beautifully printed on it in large letters.", "\"No, I'll look first,\" she said, \"and see whether it's marked '_poison_' or not,\" for she had never forgotten that, if you drink from a bottle marked \"poison,\" it is almost certain to disagree with you, sooner or later.", "However, this bottle was _not_ marked \"poison,\" so Alice ventured to taste it, and, finding it very nice (it had a sort of mixed flavor of cherry-tart, custard, pineapple, roast turkey, toffy and hot buttered toast), she very soon finished it off.", "* * * * *", "\"What a curious feeling!\" said Alice.", "\"I must be shutting up like a telescope!\"", "And so it was indeed!", "She was now only ten inches high, and her face brightened up at the thought that she was now the right size for going through the little door into that lovely garden.", "After awhile, finding that nothing more happened, she decided on going into the garden at once; but, alas for poor Alice!", "When she got to the door, she found she had forgotten the little golden key, and when she went back to the table for it, she found she could not possibly reach it: she could see it quite plainly through the glass and she tried her best to climb up one of the legs of the table, but it was too slippery, and when she had tired herself out with trying, the poor little thing sat down and cried.", "\"Come, there's no use in crying like that!\" said Alice to herself rather sharply.", "\"I advise you to leave off this minute!\"", "She generally gave herself very good advice (though she very seldom followed it), and sometimes she scolded herself so severely as to bring tears into her eyes.", "Soon her eye fell on a little glass box that was lying under the table: she opened it and found in it a very small cake, on which the words \"EAT ME\" were beautifully marked in currants.", "\"Well, I'll eat it,\" said Alice, \"and if it makes me grow larger, I can reach the key; and if it makes me grow smaller, I can creep under the door: so either way I'll get into the garden, and I don't care which happens!\"", "She ate a little bit and said anxiously to herself, \"Which way? Which way?\" holding her hand on the top of her head to feel which way she was growing; and she was quite surprised to find that she remained the same size.", "So she set to work and very soon finished off the cake.", "II--THE POOL OF TEARS", "\"Curiouser and curiouser!\" cried Alice (she was so much surprised that for the moment she quite forgot how to speak good English).", "\"Now I'm opening out like the largest telescope that ever was! Good-by, feet! Oh, my poor little feet, I wonder who will put on your shoes and stockings for you now, dears? I shall be a great deal too far off to trouble myself about you.\"", "Just at this moment her head struck against the roof of the hall; in fact, she was now rather more than nine feet high, and she at once took up the little golden key and hurried off to the garden door.", "Poor Alice!", "It was as much as she could do, lying down on one side, to look through into the garden with one eye; but to get through was more hopeless than ever.", "She sat down and began to cry again.", "She went on shedding gallons of tears, until there was a large pool all 'round her and reaching half down the hall.", "After a time, she heard a little pattering of feet in the distance and she hastily dried her eyes to see what was coming.", "It was the White Rabbit returning, splendidly dressed, with a pair of white kid-gloves in one hand and a large fan in the other.", "He came trotting along in a great hurry, muttering to himself, \"Oh! the Duchess, the Duchess! Oh! _won't_ she be savage if I've kept her waiting!\"", "When the Rabbit came near her, Alice began, in a low, timid voice, \"If you please, sir--\"", "The Rabbit started violently, dropped the white kid-gloves and the fan and skurried away into the darkness as hard as he could go.", "Alice took up the fan and gloves and she kept fanning herself all the time she went on talking.", "\"Dear, dear! How queer everything is to-day! And yesterday things went on just as usual. _Was_ I the same when I got up this morning? But if I'm not the same, the next question is, 'Who in the world am I?' Ah, _that's_ the great puzzle!\"", "As she said this, she looked down at her hands and was surprised to see that she had put on one of the Rabbit's little white kid-gloves while she was talking.", "\"How _can_ I have done that?\" she thought.", "\"I must be growing small again.\"", "She got up and went to the table to measure herself by it and found that she was now about two feet high and was going on shrinking rapidly.", "She soon found out that the cause of this was the fan she was holding and she dropped it hastily, just in time to save herself from shrinking away altogether.", "\"That _was_ a narrow escape!\" said Alice, a good deal frightened at the sudden change, but very glad to find herself still in existence.", "\"And now for the garden!\"", "And she ran with all speed back to the little door; but, alas! the little door was shut again and the little golden key was lying on the glass table as before.", "\"Things are worse than ever,\" thought the poor child, \"for I never was so small as this before, never!\"", "As she said these words, her foot slipped, and in another moment, splash! she was up to her chin in salt-water.", "Her first idea was that she had somehow fallen into the sea.", "However, she soon made out that she was in the pool of tears which she had wept when she was nine feet high.", "Just then she heard something splashing about in the pool a little way off, and she swam nearer to see what it was: she soon made out that it was only a mouse that had slipped in like herself.", "\"Would it be of any use, now,\" thought Alice, \"to speak to this mouse? Everything is so out-of-the-way down here that I should think very likely it can talk; at any rate, there's no harm in trying.\"", "So she began, \"O Mouse, do you know the way out of this pool? I am very tired of swimming about here, O Mouse!\"", "The Mouse looked at her rather inquisitively and seemed to her to wink with one of its little eyes, but it said nothing.", "\"Perhaps it doesn't understand English,\" thought Alice.", "\"I dare say it's a French mouse, come over with William the Conqueror.\"", "So she began again: \"Où est ma chatte?\" which was the first sentence in her French lesson-book.", "The Mouse gave a sudden leap out of the water and seemed to quiver all over with fright.", "\"Oh, I beg your pardon!\" cried Alice hastily, afraid that she had hurt the poor animal's feelings.", "\"I quite forgot you didn't like cats.\"", "\"Not like cats!\" cried the Mouse in a shrill, passionate voice.", "\"Would _you_ like cats, if you were me?\"", "\"Well, perhaps not,\" said Alice in a soothing tone; \"don't be angry about it. And yet I wish I could show you our cat Dinah. I think you'd take a fancy to cats, if you could only see her. She is such a dear, quiet thing.\"", "The Mouse was bristling all over and she felt certain it must be really offended.", "\"We won't talk about her any more, if you'd rather not.\"", "\"We, indeed!\" cried the Mouse, who was trembling down to the end of its tail.", "\"As if _I_ would talk on such a subject! Our family always _hated_ cats--nasty, low, vulgar things! Don't let me hear the name again!\"", "\"I won't indeed!\" said Alice, in a great hurry to change the subject of conversation.", "\"Are you--are you fond--of--of dogs? There is such a nice little dog near our house, I should like to show you! It kills all the rats and--oh, dear!\" cried Alice in a sorrowful tone.", "\"I'm afraid I've offended it again!\"", "For the Mouse was swimming away from her as hard as it could go, and making quite a commotion in the pool as it went.", "So she called softly after it, \"Mouse dear! Do come back again, and we won't talk about cats, or dogs either, if you don't like them!\"", "When the Mouse heard this, it turned 'round and swam slowly back to her; its face was quite pale, and it said, in a low, trembling voice, \"Let us get to the shore and then I'll tell you my history and you'll understand why it is I hate cats and dogs.\"", "It was high time to go, for the pool was getting quite crowded with the birds and animals that had fallen into it; there were a Duck and a Dodo, a Lory and an Eaglet, and several other curious creatures.", "Alice led the way and the whole party swam to the shore.", "III--A CAUCUS-RACE AND A LONG TALE", "They were indeed a queer-looking party that assembled on the bank--the birds with draggled feathers, the animals with their fur clinging close to them, and all dripping wet, cross and uncomfortable.", "The first question, of course, was how to get dry again.", "They had a consultation about this and after a few minutes, it seemed quite natural to Alice to find herself talking familiarly with them, as if she had known them all her life.", "At last the Mouse, who seemed to be a person of some authority among them, called out, \"Sit down, all of you, and listen to me! _I'll_ soon make you dry enough!\"", "They all sat down at once, in a large ring, with the Mouse in the middle.", "\"Ahem!\" said the Mouse with an important air.", "\"Are you all ready? This is the driest thing I know. Silence all 'round, if you please! 'William the Conqueror, whose cause was favored by the pope, was soon submitted to by the English, who wanted leaders, and had been of late much accustomed to usurpation and conquest. Edwin and Morcar, the Earls of Mercia and Northumbria'--\"", "\"Ugh!\" said the Lory, with a shiver.", "\"--'And even Stigand, the patriotic archbishop of Canterbury, found it advisable'--\"", "\"Found _what_?\" said the Duck.", "\"Found _it_,\" the Mouse replied rather crossly; \"of course, you know what 'it' means.\"", "\"I know what 'it' means well enough, when _I_ find a thing,\" said the Duck; \"it's generally a frog or a worm. The question is, what did the archbishop find?\"", "The Mouse did not notice this question, but hurriedly went on, \"'--found it advisable to go with Edgar Atheling to meet William and offer him the crown.'--How are you getting on now, my dear?\" it continued, turning to Alice as it spoke.", "\"As wet as ever,\" said Alice in a melancholy tone; \"it doesn't seem to dry me at all.\"", "\"In that case,\" said the Dodo solemnly, rising to its feet, \"I move that the meeting adjourn, for the immediate adoption of more energetic remedies--\"", "\"Speak English!\" said the Eaglet.", "\"I don't know the meaning of half those long words, and, what's more, I don't believe you do either!\"", "\"What I was going to say,\" said the Dodo in an offended tone, \"is that the best thing to get us dry would be a Caucus-race.\"", "\"What _is_ a Caucus-race?\" said Alice.", "\"Why,\" said the Dodo, \"the best way to explain it is to do it.\"", "First it marked out a race-course, in a sort of circle, and then all the party were placed along the course, here and there.", "There was no \"One, two, three and away!\" but they began running when they liked and left off when they liked, so that it was not easy to know when the race was over.", "However, when they had been running half an hour or so and were quite dry again, the Dodo suddenly called out, \"The race is over!\" and they all crowded 'round it, panting and asking, \"But who has won?\"", "This question the Dodo could not answer without a great deal of thought.", "At last it said, \"_Everybody_ has won, and _all_ must have prizes.\"", "\"But who is to give the prizes?\" quite a chorus of voices asked.", "\"Why, _she_, of course,\" said the Dodo, pointing to Alice with one finger; and the whole party at once crowded 'round her, calling out, in a confused way, \"Prizes! Prizes!\"", "Alice had no idea what to do, and in despair she put her hand into her pocket and pulled out a box of comfits (luckily the salt-water had not got into it) and handed them 'round as prizes.", "There was exactly one a-piece, all 'round.", "The next thing was to eat the comfits; this caused some noise and confusion, as the large birds complained that they could not taste theirs, and the small ones choked and had to be patted on the back.", "However, it was over at last and they sat down again in a ring and begged the Mouse to tell them something more.", "\"You promised to tell me your history, you know,\" said Alice, \"and why it is you hate--C and D,\" she added in a whisper, half afraid that it would be offended again.", "\"Mine is a long and a sad tale!\" said the Mouse, turning to Alice and sighing.", "\"It _is_ a long tail, certainly,\" said Alice, looking down with wonder at the Mouse's tail, \"but why do you call it sad?\"", "And she kept on puzzling about it while the Mouse was speaking, so that her idea of the tale was something like this:--", "\"You are not attending!\" said the Mouse to Alice, severely.", "\"What are you thinking of?\"", "\"I beg your pardon,\" said Alice very humbly, \"you had got to the fifth bend, I think?\"", "\"You insult me by talking such nonsense!\" said the Mouse, getting up and walking away.", "\"Please come back and finish your story!\"", "Alice called after it.", "And the others all joined in chorus, \"Yes, please do!\"", "But the Mouse only shook its head impatiently and walked a little quicker.", "\"I wish I had Dinah, our cat, here!\" said Alice.", "This caused a remarkable sensation among the party.", "Some of the birds hurried off at once, and a Canary called out in a trembling voice, to its children, \"Come away, my dears! It's high time you were all in bed!\"", "On various pretexts they all moved off and Alice was soon left alone.", "\"I wish I hadn't mentioned Dinah! Nobody seems to like her down here and I'm sure she's the best cat in the world!\"", "Poor Alice began to cry again, for she felt very lonely and low-spirited.", "In a little while, however, she again heard a little pattering of footsteps in the distance and she looked up eagerly.", "IV--THE RABBIT SENDS IN A LITTLE BILL", "It was the White Rabbit, trotting slowly back again and looking anxiously about as it went, as if it had lost something; Alice heard it muttering to itself, \"The Duchess! The Duchess! Oh, my dear paws! Oh, my fur and whiskers! She'll get me executed, as sure as ferrets are ferrets! Where _can_ I have dropped them, I wonder?\"", "Alice guessed in a moment that it was looking for the fan and the pair of white kid-gloves and she very good-naturedly began hunting about for them, but they were nowhere to be seen--everything seemed to have changed since her swim in the pool, and the great hall, with the glass table and the little door, had vanished completely.", "Very soon the Rabbit noticed Alice, and called to her, in an angry tone, \"Why, Mary Ann, what _are_ you doing out here? Run home this moment and fetch me a pair of gloves and a fan! Quick, now!\"", "\"He took me for his housemaid!\" said Alice, as she ran off.", "\"How surprised he'll be when he finds out who I am!\"", "As she said this, she came upon a neat little house, on the door of which was a bright brass plate with the name \"W. RABBIT\" engraved upon it.", "She went in without knocking and hurried upstairs, in great fear lest she should meet the real Mary Ann and be turned out of the house before she had found the fan and gloves.", "By this time, Alice had found her way into a tidy little room with a table in the window, and on it a fan and two or three pairs of tiny white kid-gloves; she took up the fan and a pair of the gloves and was just going to leave the room, when her eyes fell upon a little bottle that stood near the looking-glass.", "She uncorked it and put it to her lips, saying to herself, \"I do hope it'll make me grow large again, for, really, I'm quite tired of being such a tiny little thing!\"", "Before she had drunk half the bottle, she found her head pressing against the ceiling, and had to stoop to save her neck from being broken.", "She hastily put down the bottle, remarking, \"That's quite enough--I hope I sha'n't grow any more.\"", "Alas!", "It was too late to wish that!", "She went on growing and growing and very soon she had to kneel down on the floor.", "Still she went on growing, and, as a last resource, she put one arm out of the window and one foot up the chimney, and said to herself, \"Now I can do no more, whatever happens. What _will_ become of me?\"", "Luckily for Alice, the little magic bottle had now had its full effect and she grew no larger.", "After a few minutes she heard a voice outside and stopped to listen.", "\"Mary Ann! Mary Ann!\" said the voice.", "\"Fetch me my gloves this moment!\"", "Then came a little pattering of feet on the stairs.", "Alice knew it was the Rabbit coming to look for her and she trembled till she shook the house, quite forgetting that she was now about a thousand times as large as the Rabbit and had no reason to be afraid of it.", "Presently the Rabbit came up to the door and tried to open it; but as the door opened inwards and Alice's elbow was pressed hard against it, that attempt proved a failure.", "Alice heard it say to itself, \"Then I'll go 'round and get in at the window.\"", "\"_That_ you won't!\" thought Alice; and after waiting till she fancied she heard the Rabbit just under the window, she suddenly spread out her hand and made a snatch in the air.", "She did not get hold of anything, but she heard a little shriek and a fall and a crash of broken glass, from which she concluded that it was just possible it had fallen into a cucumber-frame or something of that sort.", "Next came an angry voice--the Rabbit's--\"Pat! Pat! Where are you?\"", "And then a voice she had never heard before, \"Sure then, I'm here! Digging for apples, yer honor!\"", "\"Here! Come and help me out of this! Now tell me, Pat, what's that in the window?\"", "\"Sure, it's an arm, yer honor!\"", "\"Well, it's got no business there, at any rate; go and take it away!\"", "There was a long silence after this and Alice could only hear whispers now and then, and at last she spread out her hand again and made another snatch in the air.", "This time there were _two_ little shrieks and more sounds of broken glass.", "\"I wonder what they'll do next!\" thought Alice.", "\"As for pulling me out of the window, I only wish they _could_!\"", "She waited for some time without hearing anything more.", "At last came a rumbling of little cart-wheels and the sound of a good many voices all talking together.", "She made out the words: \"Where's the other ladder? Bill's got the other--Bill! Here, Bill! Will the roof bear?--Who's to go down the chimney?--Nay, _I_ sha'n't! _You_ do it! Here, Bill! The master says you've got to go down the chimney!\"", "Alice drew her foot as far down the chimney as she could and waited till she heard a little animal scratching and scrambling about in the chimney close above her; then she gave one sharp kick and waited to see what would happen next.", "The first thing she heard was a general chorus of \"There goes Bill!\" then the Rabbit's voice alone--\"Catch him, you by the hedge!\"", "Then silence and then another confusion of voices--\"Hold up his head--Brandy now--Don't choke him--What happened to you?\"", "Last came a little feeble, squeaking voice, \"Well, I hardly know--No more, thank ye. I'm better now--all I know is, something comes at me like a Jack-in-the-box and up I goes like a sky-rocket!\"", "After a minute or two of silence, they began moving about again, and Alice heard the Rabbit say, \"A barrowful will do, to begin with.\"", "\"A barrowful of _what_?\" thought Alice.", "But she had not long to doubt, for the next moment a shower of little pebbles came rattling in at the window and some of them hit her in the face.", "Alice noticed, with some surprise, that the pebbles were all turning into little cakes as they lay on the floor and a bright idea came into her head.", "\"If I eat one of these cakes,\" she thought, \"it's sure to make _some_ change in my size.\"", "So she swallowed one of the cakes and was delighted to find that she began shrinking directly.", "As soon as she was small enough to get through the door, she ran out of the house and found quite a crowd of little animals and birds waiting outside.", "They all made a rush at Alice the moment she appeared, but she ran off as hard as she could and soon found herself safe in a thick wood.", "\"The first thing I've got to do,\" said Alice to herself, as she wandered about in the wood, \"is to grow to my right size again; and the second thing is to find my way into that lovely garden. I suppose I ought to eat or drink something or other, but the great question is 'What?'\"", "Alice looked all around her at the flowers and the blades of grass, but she could not see anything that looked like the right thing to eat or drink under the circumstances.", "There was a large mushroom growing near her, about the same height as herself.", "She stretched herself up on tiptoe and peeped over the edge and her eyes immediately met those of a large blue caterpillar, that was sitting on the top, with its arms folded, quietly smoking a long hookah and taking not the smallest notice of her or of anything else.", "V--ADVICE FROM A CATERPILLAR", "At last the Caterpillar took the hookah out of its mouth and addressed Alice in a languid, sleepy voice.", "\"Who are _you_?\" said the Caterpillar.", "Alice replied, rather shyly, \"I--I hardly know, sir, just at present--at least I know who I _was_ when I got up this morning, but I think I must have changed several times since then.\"", "\"What do you mean by that?\" said the Caterpillar, sternly.", "\"Explain yourself!\"", "\"I can't explain _myself_, I'm afraid, sir,\" said Alice, \"because I'm not myself, you see--being so many different sizes in a day is very confusing.\"", "She drew herself up and said very gravely, \"I think you ought to tell me who _you_ are, first.\"", "\"Why?\" said the Caterpillar.", "As Alice could not think of any good reason and the Caterpillar seemed to be in a _very_ unpleasant state of mind, she turned away.", "\"Come back!\" the Caterpillar called after her.", "\"I've something important to say!\"", "Alice turned and came back again.", "\"Keep your temper,\" said the Caterpillar.", "\"Is that all?\" said Alice, swallowing down her anger as well as she could.", "\"No,\" said the Caterpillar.", "It unfolded its arms, took the hookah out of its mouth again, and said, \"So you think you're changed, do you?\"", "\"I'm afraid, I am, sir,\" said Alice.", "\"I can't remember things as I used--and I don't keep the same size for ten minutes together!\"", "\"What size do you want to be?\" asked the Caterpillar.", "\"Oh, I'm not particular as to size,\" Alice hastily replied, \"only one doesn't like changing so often, you know. I should like to be a _little_ larger, sir, if you wouldn't mind,\" said Alice.", "\"Three inches is such a wretched height to be.\"", "\"It is a very good height indeed!\" said the Caterpillar angrily, rearing itself upright as it spoke (it was exactly three inches high).", "In a minute or two, the Caterpillar got down off the mushroom and crawled away into the grass, merely remarking, as it went, \"One side will make you grow taller, and the other side will make you grow shorter.\"", "\"One side of _what_? The other side of _what_?\" thought Alice to herself.", "\"Of the mushroom,\" said the Caterpillar, just as if she had asked it aloud; and in another moment, it was out of sight.", "Alice remained looking thoughtfully at the mushroom for a minute, trying to make out which were the two sides of it.", "At last she stretched her arms 'round it as far as they would go, and broke off a bit of the edge with each hand.", "\"And now which is which?\" she said to herself, and nibbled a little of the right-hand bit to try the effect.", "The next moment she felt a violent blow underneath her chin--it had struck her foot!", "She was a good deal frightened by this very sudden change, as she was shrinking rapidly; so she set to work at once to eat some of the other bit.", "Her chin was pressed so closely against her foot that there was hardly room to open her mouth; but she did it at last and managed to swallow a morsel of the left-hand bit....", "\"Come, my head's free at last!\" said Alice; but all she could see, when she looked down, was an immense length of neck, which seemed to rise like a stalk out of a sea of green leaves that lay far below her.", "\"Where _have_ my shoulders got to? And oh, my poor hands, how is it I can't see you?\"", "She was delighted to find that her neck would bend about easily in any direction, like a serpent.", "She had just succeeded in curving it down into a graceful zigzag and was going to dive in among the leaves, when a sharp hiss made her draw back in a hurry--a large pigeon had flown into her face and was beating her violently with its wings.", "\"Serpent!\" cried the Pigeon.", "\"I'm _not_ a serpent!\" said Alice indignantly.", "\"Let me alone!\"", "\"I've tried the roots of trees, and I've tried banks, and I've tried hedges,\" the Pigeon went on, \"but those serpents! There's no pleasing them!\"", "Alice was more and more puzzled.", "\"As if it wasn't trouble enough hatching the eggs,\" said the Pigeon, \"but I must be on the look-out for serpents, night and day! And just as I'd taken the highest tree in the wood,\" continued the Pigeon, raising its voice to a shriek, \"and just as I was thinking I should be free of them at last, they must needs come wriggling down from the sky! Ugh, Serpent!\"", "\"But I'm _not_ a serpent, I tell you!\" said Alice.", "\"I'm a--I'm a--I'm a little girl,\" she added rather doubtfully, as she remembered the number of changes she had gone through that day.", "\"You're looking for eggs, I know _that_ well enough,\" said the Pigeon; \"and what does it matter to me whether you're a little girl or a serpent?\"", "\"It matters a good deal to _me_,\" said Alice hastily; \"but I'm not looking for eggs, as it happens, and if I was, I shouldn't want _yours_--I don't like them raw.\"", "\"Well, be off, then!\" said the Pigeon in a sulky tone, as it settled down again into its nest.", "Alice crouched down among the trees as well as she could, for her neck kept getting entangled among the branches, and every now and then she had to stop and untwist it.", "After awhile she remembered that she still held the pieces of mushroom in her hands, and she set to work very carefully, nibbling first at one and then at the other, and growing sometimes taller and sometimes shorter, until she had succeeded in bringing herself down to her usual height.", "It was so long since she had been anything near the right size that it felt quite strange at first.", "\"The next thing is to get into that beautiful garden--how _is_ that to be done, I wonder?\"", "As she said this, she came suddenly upon an open place, with a little house in it about four feet high.", "\"Whoever lives there,\" thought Alice, \"it'll never do to come upon them _this_ size; why, I should frighten them out of their wits!\"", "She did not venture to go near the house till she had brought herself down to nine inches high.", "VI--PIG AND PEPPER", "For a minute or two she stood looking at the house, when suddenly a footman in livery came running out of the wood (judging by his face only, she would have called him a fish)--and rapped loudly at the door with his knuckles.", "It was opened by another footman in livery, with a round face and large eyes like a frog.", "The Fish-Footman began by producing from under his arm a great letter, and this he handed over to the other, saying, in a solemn tone, \"For the Duchess. An invitation from the Queen to play croquet.\"", "The Frog-Footman repeated, in the same solemn tone, \"From the Queen. An invitation for the Duchess to play croquet.\"", "Then they both bowed low and their curls got entangled together.", "When Alice next peeped out, the Fish-Footman was gone, and the other was sitting on the ground near the door, staring stupidly up into the sky.", "Alice went timidly up to the door and knocked.", "\"There's no sort of use in knocking,\" said the Footman, \"and that for two reasons. First, because I'm on the same side of the door as you are; secondly, because they're making such a noise inside, no one could possibly hear you.\"", "And certainly there _was_ a most extraordinary noise going on within--a constant howling and sneezing, and every now and then a great crash, as if a dish or kettle had been broken to pieces.", "\"How am I to get in?\" asked Alice.", "\"_Are_ you to get in at all?\" said the Footman.", "\"That's the first question, you know.\"", "Alice opened the door and went in.", "The door led right into a large kitchen, which was full of smoke from one end to the other; the Duchess was sitting on a three-legged stool in the middle, nursing a baby; the cook was leaning over the fire, stirring a large caldron which seemed to be full of soup.", "\"There's certainly too much pepper in that soup!\"", "Alice said to herself, as well as she could for sneezing.", "Even the Duchess sneezed occasionally; and as for the baby, it was sneezing and howling alternately without a moment's pause.", "The only two creatures in the kitchen that did _not_ sneeze were the cook and a large cat, which was grinning from ear to ear.", "\"Please would you tell me,\" said Alice, a little timidly, \"why your cat grins like that?\"", "\"It's a Cheshire-Cat,\" said the Duchess, \"and that's why.\"", "\"I didn't know that Cheshire-Cats always grinned; in fact, I didn't know that cats _could_ grin,\" said Alice.", "\"You don't know much,\" said the Duchess, \"and that's a fact.\"", "Just then the cook took the caldron of soup off the fire, and at once set to work throwing everything within her reach at the Duchess and the baby--the fire-irons came first; then followed a shower of saucepans, plates and dishes.", "The Duchess took no notice of them, even when they hit her, and the baby was howling so much already that it was quite impossible to say whether the blows hurt it or not.", "\"Oh, _please_ mind what you're doing!\" cried Alice, jumping up and down in an agony of terror.", "\"Here! You may nurse it a bit, if you like!\" the Duchess said to Alice, flinging the baby at her as she spoke.", "\"I must go and get ready to play croquet with the Queen,\" and she hurried out of the room.", "Alice caught the baby with some difficulty, as it was a queer-shaped little creature and held out its arms and legs in all directions.", "\"If I don't take this child away with me,\" thought Alice, \"they're sure to kill it in a day or two. Wouldn't it be murder to leave it behind?\"", "She said the last words out loud and the little thing grunted in reply.", "\"If you're going to turn into a pig, my dear,\" said Alice, \"I'll have nothing more to do with you. Mind now!\"", "Alice was just beginning to think to herself, \"Now, what am I to do with this creature, when I get it home?\" when it grunted again so violently that Alice looked down into its face in some alarm.", "This time there could be _no_ mistake about it--it was neither more nor less than a pig; so she set the little creature down and felt quite relieved to see it trot away quietly into the wood.", "Alice was a little startled by seeing the Cheshire-Cat sitting on a bough of a tree a few yards off.", "The Cat only grinned when it saw her.", "\"Cheshire-Puss,\" began Alice, rather timidly, \"would you please tell me which way I ought to go from here?\"", "\"In _that_ direction,\" the Cat said, waving the right paw 'round, \"lives a Hatter; and in _that_ direction,\" waving the other paw, \"lives a March Hare. Visit either you like; they're both mad.\"", "\"But I don't want to go among mad people,\" Alice remarked.", "\"Oh, you can't help that,\" said the Cat; \"we're all mad here. Do you play croquet with the Queen to-day?\"", "\"I should like it very much,\" said Alice, \"but I haven't been invited yet.\"", "\"You'll see me there,\" said the Cat, and vanished.", "Alice had not gone much farther before she came in sight of the house of the March Hare; it was so large a house that she did not like to go near till she had nibbled some more of the left-hand bit of mushroom.", "VII--A MAD TEA-PARTY", "There was a table set out under a tree in front of the house, and the March Hare and the Hatter were having tea at it; a Dormouse was sitting between them, fast asleep.", "The table was a large one, but the three were all crowded together at one corner of it.", "\"No room! No room!\" they cried out when they saw Alice coming.", "\"There's _plenty_ of room!\" said Alice indignantly, and she sat down in a large arm-chair at one end of the table.", "The Hatter opened his eyes very wide on hearing this, but all he said was \"Why is a raven like a writing-desk?\"", "\"I'm glad they've begun asking riddles--I believe I can guess that,\" she added aloud.", "\"Do you mean that you think you can find out the answer to it?\" said the March Hare.", "\"Exactly so,\" said Alice.", "\"Then you should say what you mean,\" the March Hare went on.", "\"I do,\" Alice hastily replied; \"at least--at least I mean what I say--that's the same thing, you know.\"", "\"You might just as well say,\" added the Dormouse, which seemed to be talking in its sleep, \"that 'I breathe when I sleep' is the same thing as 'I sleep when I breathe!'\"", "\"It _is_ the same thing with you,\" said the Hatter, and he poured a little hot tea upon its nose.", "The Dormouse shook its head impatiently and said, without opening its eyes, \"Of course, of course; just what I was going to remark myself.\"", "\"Have you guessed the riddle yet?\" the Hatter said, turning to Alice again.", "\"No, I give it up,\" Alice replied.", "\"What's the answer?\"", "\"I haven't the slightest idea,\" said the Hatter.", "\"Nor I,\" said the March Hare.", "Alice gave a weary sigh.", "\"I think you might do something better with the time,\" she said, \"than wasting it in asking riddles that have no answers.\"", "\"Take some more tea,\" the March Hare said to Alice, very earnestly.", "\"I've had nothing yet,\" Alice replied in an offended tone, \"so I can't take more.\"", "\"You mean you can't take _less_,\" said the Hatter; \"it's very easy to take _more_ than nothing.\"", "At this, Alice got up and walked off.", "The Dormouse fell asleep instantly and neither of the others took the least notice of her going, though she looked back once or twice; the last time she saw them, they were trying to put the Dormouse into the tea-pot.", "\"At any rate, I'll never go _there_ again!\" said Alice, as she picked her way through the wood.", "\"It's the stupidest tea-party I ever was at in all my life!\"", "Just as she said this, she noticed that one of the trees had a door leading right into it.", "\"That's very curious!\" she thought.", "\"I think I may as well go in at once.\"", "And in she went.", "Once more she found herself in the long hall and close to the little glass table.", "Taking the little golden key, she unlocked the door that led into the garden.", "Then she set to work nibbling at the mushroom (she had kept a piece of it in her pocket) till she was about a foot high; then she walked down the little passage; and _then_--she found herself at last in the beautiful garden, among the bright flower-beds and the cool fountains.", "VIII--THE QUEEN'S CROQUET GROUND", "A large rose-tree stood near the entrance of the garden; the roses growing on it were white, but there were three gardeners at it, busily painting them red.", "Suddenly their eyes chanced to fall upon Alice, as she stood watching them.", "\"Would you tell me, please,\" said Alice, a little timidly, \"why you are painting those roses?\"", "Five and Seven said nothing, but looked at Two.", "Two began, in a low voice, \"Why, the fact is, you see, Miss, this here ought to have been a _red_ rose-tree, and we put a white one in by mistake; and, if the Queen was to find it out, we should all have our heads cut off, you know. So you see, Miss, we're doing our best, afore she comes, to--\"", "At this moment, Five, who had been anxiously looking across the garden, called out, \"The Queen! The Queen!\" and the three gardeners instantly threw themselves flat upon their faces.", "There was a sound of many footsteps and Alice looked 'round, eager to see the Queen.", "First came ten soldiers carrying clubs, with their hands and feet at the corners: next the ten courtiers; these were ornamented all over with diamonds.", "After these came the royal children; there were ten of them, all ornamented with hearts.", "Next came the guests, mostly Kings and Queens, and among them Alice recognized the White Rabbit.", "Then followed the Knave of Hearts, carrying the King's crown on a crimson velvet cushion; and last of all this grand procession came THE KING AND THE QUEEN OF HEARTS.", "When the procession came opposite to Alice, they all stopped and looked at her, and the Queen said severely, \"Who is this?\"", "She said it to the Knave of Hearts, who only bowed and smiled in reply.", "\"My name is Alice, so please Your Majesty,\" said Alice very politely; but she added to herself, \"Why, they're only a pack of cards, after all!\"", "\"Can you play croquet?\" shouted the Queen.", "The question was evidently meant for Alice.", "\"Yes!\" said Alice loudly.", "\"Come on, then!\" roared the Queen.", "\"It's--it's a very fine day!\" said a timid voice to Alice.", "She was walking by the White Rabbit, who was peeping anxiously into her face.", "\"Very,\" said Alice.", "\"Where's the Duchess?\"", "\"Hush! Hush!\" said the Rabbit.", "\"She's under sentence of execution.\"", "\"What for?\" said Alice.", "\"She boxed the Queen's ears--\" the Rabbit began.", "\"Get to your places!\" shouted the Queen in a voice of thunder, and people began running about in all directions, tumbling up against each other.", "However, they got settled down in a minute or two, and the game began.", "Alice thought she had never seen such a curious croquet-ground in her life; it was all ridges and furrows.", "The croquet balls were live hedgehogs, and the mallets live flamingos and the soldiers had to double themselves up and stand on their hands and feet, to make the arches.", "The players all played at once, without waiting for turns, quarrelling all the while and fighting for the hedgehogs; and in a very short time, the Queen was in a furious passion and went stamping about and shouting, \"Off with his head!\" or \"Off with her head!\" about once in a minute.", "\"They're dreadfully fond of beheading people here,\" thought Alice; \"the great wonder is that there's anyone left alive!\"", "She was looking about for some way of escape, when she noticed a curious appearance in the air.", "\"It's the Cheshire-Cat,\" she said to herself; \"now I shall have somebody to talk to.\"", "\"How are you getting on?\" said the Cat.", "\"I don't think they play at all fairly,\" Alice said, in a rather complaining tone; \"and they all quarrel so dreadfully one can't hear oneself speak--and they don't seem to have any rules in particular.\"", "\"How do you like the Queen?\" said the Cat in a low voice.", "\"Not at all,\" said Alice.", "Alice thought she might as well go back and see how the game was going on.", "So she went off in search of her hedgehog.", "The hedgehog was engaged in a fight with another hedgehog, which seemed to Alice an excellent opportunity for croqueting one of them with the other; the only difficulty was that her flamingo was gone across to the other side of the garden, where Alice could see it trying, in a helpless sort of way, to fly up into a tree.", "She caught the flamingo and tucked it away under her arm, that it might not escape again.", "Just then Alice ran across the Duchess (who was now out of prison).", "She tucked her arm affectionately into Alice's and they walked off together.", "Alice was very glad to find her in such a pleasant temper.", "She was a little startled, however, when she heard the voice of the Duchess close to her ear.", "\"You're thinking about something, my dear, and that makes you forget to talk.\"", "\"The game's going on rather better now,\" Alice said, by way of keeping up the conversation a little.", "\"'Tis so,\" said the Duchess; \"and the moral of that is--'Oh, 'tis love, 'tis love that makes the world go 'round!'\"", "\"Somebody said,\" Alice whispered, \"that it's done by everybody minding his own business!\"", "\"Ah, well! It means much the same thing,\" said the Duchess, digging her sharp little chin into Alice's shoulder, as she added \"and the moral of _that_ is--'Take care of the sense and the sounds will take care of themselves.'\"", "To Alice's great surprise, the Duchess's arm that was linked into hers began to tremble.", "Alice looked up and there stood the Queen in front of them, with her arms folded, frowning like a thunderstorm!", "\"Now, I give you fair warning,\" shouted the Queen, stamping on the ground as she spoke, \"either you or your head must be off, and that in about half no time. Take your choice!\"", "The Duchess took her choice, and was gone in a moment.", "\"Let's go on with the game,\" the Queen said to Alice; and Alice was too much frightened to say a word, but slowly followed her back to the croquet-ground.", "All the time they were playing, the Queen never left off quarreling with the other players and shouting, \"Off with his head!\" or \"Off with her head!\"", "By the end of half an hour or so, all the players, except the King, the Queen and Alice, were in custody of the soldiers and under sentence of execution.", "Then the Queen left off, quite out of breath, and walked away with Alice.", "Alice heard the King say in a low voice to the company generally, \"You are all pardoned.\"", "Suddenly the cry \"The Trial's beginning!\" was heard in the distance, and Alice ran along with the others.", "IX--WHO STOLE THE TARTS?", "The King and Queen of Hearts were seated on their throne when they arrived, with a great crowd assembled about them--all sorts of little birds and beasts, as well as the whole pack of cards: the Knave was standing before them, in chains, with a soldier on each side to guard him; and near the King was the White Rabbit, with a trumpet in one hand and a scroll of parchment in the other.", "In the very middle of the court was a table, with a large dish of tarts upon it.", "\"I wish they'd get the trial done,\" Alice thought, \"and hand 'round the refreshments!\"", "The judge, by the way, was the King and he wore his crown over his great wig.", "\"That's the jury-box,\" thought Alice; \"and those twelve creatures (some were animals and some were birds) I suppose they are the jurors.\"", "Just then the White Rabbit cried out \"Silence in the court!\"", "\"Herald, read the accusation!\" said the King.", "On this, the White Rabbit blew three blasts on the trumpet, then unrolled the parchment-scroll and read as follows:", "\"Call the first witness,\" said the King; and the White Rabbit blew three blasts on the trumpet and called out, \"First witness!\"", "The first witness was the Hatter.", "He came in with a teacup in one hand and a piece of bread and butter in the other.", "\"You ought to have finished,\" said the King.", "\"When did you begin?\"", "The Hatter looked at the March Hare, who had followed him into the court, arm in arm with the Dormouse.", "\"Fourteenth of March, I _think_ it was,\" he said.", "\"Give your evidence,\" said the King, \"and don't be nervous, or I'll have you executed on the spot.\"", "This did not seem to encourage the witness at all; he kept shifting from one foot to the other, looking uneasily at the Queen, and, in his confusion, he bit a large piece out of his teacup instead of the bread and butter.", "Just at this moment Alice felt a very curious sensation--she was beginning to grow larger again.", "The miserable Hatter dropped his teacup and bread and butter and went down on one knee.", "\"I'm a poor man, Your Majesty,\" he began.", "\"You're a _very_ poor _speaker_,\" said the King.", "\"You may go,\" said the King, and the Hatter hurriedly left the court.", "\"Call the next witness!\" said the King.", "The next witness was the Duchess's cook.", "She carried the pepper-box in her hand and the people near the door began sneezing all at once.", "\"Give your evidence,\" said the King.", "\"Sha'n't,\" said the cook.", "The King looked anxiously at the White Rabbit, who said, in a low voice, \"Your Majesty must cross-examine _this_ witness.\"", "\"Well, if I must, I must,\" the King said.", "\"What are tarts made of?\"", "\"Pepper, mostly,\" said the cook.", "For some minutes the whole court was in confusion and by the time they had settled down again, the cook had disappeared.", "\"Never mind!\" said the King, \"call the next witness.\"", "Alice watched the White Rabbit as he fumbled over the list.", "Imagine her surprise when he read out, at the top of his shrill little voice, the name \"Alice!\"", "X--ALICE'S EVIDENCE", "\"Here!\" cried Alice.", "She jumped up in such a hurry that she tipped over the jury-box, upsetting all the jurymen on to the heads of the crowd below.", "\"Oh, I _beg_ your pardon!\" she exclaimed in a tone of great dismay.", "\"The trial cannot proceed,\" said the King, \"until all the jurymen are back in their proper places--_all_,\" he repeated with great emphasis, looking hard at Alice.", "\"What do you know about this business?\" the King said to Alice.", "\"Nothing whatever,\" said Alice.", "The King then read from his book: \"Rule forty-two. _All persons more than a mile high to leave the court_.\"", "\"_I'm_ not a mile high,\" said Alice.", "\"Nearly two miles high,\" said the Queen.", "\"Well, I sha'n't go, at any rate,\" said Alice.", "The King turned pale and shut his note-book hastily.", "\"Consider your verdict,\" he said to the jury, in a low, trembling voice.", "\"There's more evidence to come yet, please Your Majesty,\" said the White Rabbit, jumping up in a great hurry.", "\"This paper has just been picked up. It seems to be a letter written by the prisoner to--to somebody.\"", "He unfolded the paper as he spoke and added, \"It isn't a letter, after all; it's a set of verses.\"", "\"Please, Your Majesty,\" said the Knave, \"I didn't write it and they can't prove that I did; there's no name signed at the end.\"", "\"You _must_ have meant some mischief, or else you'd have signed your name like an honest man,\" said the King.", "There was a general clapping of hands at this.", "\"Read them,\" he added, turning to the White Rabbit.", "There was dead silence in the court whilst the White Rabbit read out the verses.", "\"That's the most important piece of evidence we've heard yet,\" said the King.", "\"_I_ don't believe there's an atom of meaning in it,\" ventured Alice.", "\"If there's no meaning in it,\" said the King, \"that saves a world of trouble, you know, as we needn't try to find any. Let the jury consider their verdict.\"", "\"No, no!\" said the Queen.", "\"Sentence first--verdict afterwards.\"", "\"Stuff and nonsense!\" said Alice loudly.", "\"The idea of having the sentence first!\"", "\"Hold your tongue!\" said the Queen, turning purple.", "\"I won't!\" said Alice.", "\"Off with her head!\" the Queen shouted at the top of her voice.", "Nobody moved.", "\"Who cares for _you_?\" said Alice (she had grown to her full size by this time).", "\"You're nothing but a pack of cards!\"", "At this, the whole pack rose up in the air and came flying down upon her; she gave a little scream, half of fright and half of anger, and tried to beat them off, and found herself lying on the bank, with her head in the lap of her sister, who was gently brushing away some dead leaves that had fluttered down from the trees upon her face.", "\"Wake up, Alice dear!\" said her sister.", "\"Why, what a long sleep you've had!\"", "\"Oh, I've had such a curious dream!\" said Alice.", "And she told her sister, as well as she could remember them, all these strange adventures of hers that you have just been reading about.", "Alice got up and ran off, thinking while she ran, as well she might, what a wonderful dream it had been."])
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

    it "correctly segments text #106" do
      ps = PragmaticSegmenter::Segmenter.new(text: "a")
      expect(ps.segment).to eq(["a"])
    end

    it "correctly segments text #107" do
      ps = PragmaticSegmenter::Segmenter.new(text: "I wrote this in the 'nineties.  It has four sentences.  This is the third, isn't it?  And this is the last")
      expect(ps.segment).to eq(["I wrote this in the 'nineties.", "It has four sentences.", "This is the third, isn't it?", "And this is the last"])
    end

    it "correctly segments text #108" do
      ps = PragmaticSegmenter::Segmenter.new(text: "I wrote this in the ’nineties.  It has four sentences.  This is the third, isn't it?  And this is the last")
      expect(ps.segment).to eq(["I wrote this in the ’nineties.", "It has four sentences.", "This is the third, isn't it?", "And this is the last"])
    end

    it "correctly segments text #109" do
      ps = PragmaticSegmenter::Segmenter.new(text: "He has Ph.D.-level training", clean: false)
      expect(ps.segment).to eq(["He has Ph.D.-level training"])
    end

    it "correctly segments text #110" do
      ps = PragmaticSegmenter::Segmenter.new(text: "He has Ph.D. level training", clean: false)
      expect(ps.segment).to eq(["He has Ph.D. level training"])
    end

    it "correctly segments text #111" do
      ps = PragmaticSegmenter::Segmenter.new(text: "I will be paid Rs. 16720/- in total for the time spent and the inconvenience caused to me, only after completion of all aspects of the study.", clean: false)
      expect(ps.segment).to eq(["I will be paid Rs. 16720/- in total for the time spent and the inconvenience caused to me, only after completion of all aspects of the study."])
    end

    it "correctly segments text #112" do
      ps = PragmaticSegmenter::Segmenter.new(text: "If I decide to withdraw from the study for other reasons, I will be paid only up to the extent of my participation amount according to the approved procedure of Apotex BEC. If I complete all aspects in Period 1, I will be paid Rs. 3520 and if I complete all aspects in Period 1 and Period 2, I will be paid Rs. 7790 and if I complete all aspects in Period 1, Period 2 and Period 3, I will be paid Rs. 12060 at the end of the study.", clean: false)
      expect(ps.segment).to eq(["If I decide to withdraw from the study for other reasons, I will be paid only up to the extent of my participation amount according to the approved procedure of Apotex BEC.", "If I complete all aspects in Period 1, I will be paid Rs. 3520 and if I complete all aspects in Period 1 and Period 2, I will be paid Rs. 7790 and if I complete all aspects in Period 1, Period 2 and Period 3, I will be paid Rs. 12060 at the end of the study."])
    end

    it "correctly segments text #113" do
      ps = PragmaticSegmenter::Segmenter.new(text: "After completion of each Period, I will be paid an advance amount of rs. 1000 and this amount will be deducted from my final study compensation.", clean: false)
      expect(ps.segment).to eq(["After completion of each Period, I will be paid an advance amount of rs. 1000 and this amount will be deducted from my final study compensation."])
    end

    it "correctly segments text #114" do
      ps = PragmaticSegmenter::Segmenter.new(text: "Mix it, put it in the oven, and -- voila! -- you have cake.", clean: false)
      expect(ps.segment).to eq(["Mix it, put it in the oven, and -- voila! -- you have cake."])
    end

    it "correctly segments text #115" do
      ps = PragmaticSegmenter::Segmenter.new(text: "Some can be -- if I may say so? -- a bit questionable.", clean: false)
      expect(ps.segment).to eq(["Some can be -- if I may say so? -- a bit questionable."])
    end

    it "correctly segments text #116" do
      ps = PragmaticSegmenter::Segmenter.new(text: "What do you see? - Posted like silent sentinels all around the town, stand thousands upon thousands of mortal men fixed in ocean reveries.", clean: false)
      expect(ps.segment).to eq(["What do you see?", "- Posted like silent sentinels all around the town, stand thousands upon thousands of mortal men fixed in ocean reveries."])
    end
  end
end
