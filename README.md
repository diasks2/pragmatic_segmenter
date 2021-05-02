# Pragmatic Segmenter

[![Gem Version](https://badge.fury.io/rb/pragmatic_segmenter.svg)](http://badge.fury.io/rb/pragmatic_segmenter) [![Build Status](https://travis-ci.org/diasks2/pragmatic_segmenter.png)](https://travis-ci.org/diasks2/pragmatic_segmenter) [![License](https://img.shields.io/badge/license-MIT-brightgreen.svg?style=flat)](https://github.com/diasks2/pragmatic_segmenter/blob/master/LICENSE.txt)

Pragmatic Segmenter is a rule-based sentence boundary detection gem that works out-of-the-box across many languages.

## Install

**Ruby**
*Supports Ruby 2.1.5 and above*
```
gem install pragmatic_segmenter
```

**Ruby on Rails**
Add this line to your application’s Gemfile:
```ruby
gem 'pragmatic_segmenter'
```

## Usage

* If no language is specified, the library will default to English.
* To specify a language use its two character [ISO 639-1 code](https://www.tm-town.com/languages).

```ruby
text = "Hello world. My name is Mr. Smith. I work for the U.S. Government and I live in the U.S. I live in New York."
ps = PragmaticSegmenter::Segmenter.new(text: text)
ps.segment
# => ["Hello world.", "My name is Mr. Smith.", "I work for the U.S. Government and I live in the U.S.", "I live in New York."]

# Specify a language
text = "Այսօր երկուշաբթի է: Ես գնում եմ աշխատանքի:"
ps = PragmaticSegmenter::Segmenter.new(text: text, language: 'hy')
ps.segment
# => ["Այսօր երկուշաբթի է:", "Ես գնում եմ աշխատանքի:"]

# Specify a PDF document type
text = "This is a sentence\ncut off in the middle because pdf."
ps = PragmaticSegmenter::Segmenter.new(text: text, language: 'en', doc_type: 'pdf')
ps.segment
# => ["This is a sentence cut off in the middle because pdf."]

# Turn off text cleaning and preprocessing
text = "This is a sentence\ncut off in the middle because pdf."
ps = PragmaticSegmenter::Segmenter.new(text: text, language: 'en', doc_type: 'pdf', clean: false)
ps.segment
# => ["This is a sentence cut", "off in the middle because pdf."]

# Text cleaning and preprocessing only
text = "This is a sentence\ncut off in the middle because pdf."
ps = PragmaticSegmenter::Cleaner.new(text: text, doc_type: 'pdf')
ps.clean
# => "This is a sentence cut off in the middle because pdf."
```

## Live Demo

Try out a [live demo](https://www.tm-town.com/natural-language-processing) of Pragmatic Segmenter in the browser.

## Background

According to Wikipedia, [sentence boundary disambiguation](http://en.wikipedia.org/wiki/Sentence_boundary_disambiguation) (aka sentence boundary detection, sentence segmentation) is defined as:

> Sentence boundary disambiguation (SBD), also known as sentence breaking, is the problem in natural language processing of deciding where sentences begin and end. Often natural language processing tools require their input to be divided into sentences for a number of reasons. However sentence boundary identification is challenging because punctuation marks are often ambiguous. For example, a period may denote an abbreviation, decimal point, an ellipsis, or an email address – not the end of a sentence. About 47% of the periods in the Wall Street Journal corpus denote abbreviations. As well, question marks and exclamation marks may appear in embedded quotations, emoticons, computer code, and slang. Languages like Japanese and Chinese have unambiguous sentence-ending markers.

The goal of **Pragmatic Segmenter** is to provide a "real-world" segmenter that works out of the box across many languages and does a reasonable job when the format and domain of the input text are unknown. Pragmatic Segmenter does not use any machine-learning techniques and thus does not require training data.

Pragmatic Segmenter aims to improve on other segmentation engines in 2 main areas:
1) Language support (most segmentation tools only focus on English)
2) Text cleaning and preprocessing

Pragmatic Segmenter is opinionated and made for the explicit purpose of segmenting texts to create translation memories. Therefore, things such as parenthesis within a sentence are kept as one segment, even if technically there are two or more sentences within the segment in order to maintain coherence. The algorithm is also conservative in that if it comes across an ambiguous sentence boundary it will ignore it rather than splitting.

**What do you mean by opinionated?**

Pragmatic Segmenter is specifically used for the purpose of segmenting texts for use in translation (and translation memory) related applications. Therefore Pragmatic Segmenter takes a stance on some formatting and segmentation gray areas with the goal of improving the segmentation for the above stated purpose. Some examples:

- Removes 'table of contents' style long string of periods ('............')
- Keeps parentheticals, quotations, and parentheticals or quotations within a sentence as one segment for clarity even though technically there may be multiple grammatical sentences within the segment
- Strips out any xhtml code
- Conservative in cases where the sentence boundary is ambigious and Pragmatic Segmenter does not have a built in rule

*There is an option to turn off text cleaning and preprocessing if you so choose.*

## The Golden Rules

*The Golden Rules* are a set of tests I developed that can be run through a segmenter to check its accuracy in regards to edge case scenarios. Most of the papers cited below in *Segmentation Papers and Books* either use the WSJ corpus or Brown corpus from the [Penn Treebank](https://catalog.ldc.upenn.edu/LDC99T42) to test their segmentation algorithm. In my opinion there are 2 limits to using these corpora:
1) The corpora may be too expensive for some people ($1,700).
2) The majority of the sentences in the corpora are sentences that end with a regular word followed by a period, thus testing the same thing over and over again.

> In the Brown Corpus 92% of potential sentence boundaries come after a regular word. The WSJ Corpus is richer with abbreviations and only 83% [53% according to Gale and Church, 1991] of sentences end with a regular word followed by a period.

Andrei Mikheev - *Periods, Capitalized Words, etc.*

Therefore, I created a set of distinct edge cases to compare segmentation tools on. As most segmentation tools have very high accuracy, in my opinion what is really important to test is how a segmenter handles the edge cases - not whether it can segment 20,000 sentences that end with a regular word followed by a period. These example tests I have named the “Golden Rules". This list is by no means complete and will evolve and expand over time. If you would like to contribute to (or complain about) the test set, please open an issue.

The Holy Grail of sentence segmentation appears to be **Golden Rule #18** as no segmenter I tested was able to correctly segment that text. The difficulty being that an abbreviation (in this case a.m./A.M./p.m./P.M.) followed by a capitalized abbreviation (such as Mr., Mrs., etc.) or followed by a proper noun such as a name can be both a sentence boundary and a non sentence boundary.

Download the Golden Rules: [[txt](https://s3.amazonaws.com/tm-town-nlp-resources/golden_rules.txt) | [Ruby RSpec](https://s3.amazonaws.com/tm-town-nlp-resources/golden_rules_rspec.rb)]

#### Golden Rules (English)

1.) **Simple period to end sentence**
```
Hello World. My name is Jonas.
=> ["Hello World.", "My name is Jonas."]
```

2.) **Question mark to end sentence**
```
What is your name? My name is Jonas.
=> ["What is your name?", "My name is Jonas."]
```

3.) **Exclamation point to end sentence**
```
There it is! I found it.
=> ["There it is!", "I found it."]
```

4.) **One letter upper case abbreviations**
```
My name is Jonas E. Smith.
=> ["My name is Jonas E. Smith."]
```

5.) **One letter lower case abbreviations**
```
Please turn to p. 55.
=> ["Please turn to p. 55."]
```

6.) **Two letter lower case abbreviations in the middle of a sentence**
```
Were Jane and co. at the party?
=> ["Were Jane and co. at the party?"]
```

7.) **Two letter upper case abbreviations in the middle of a sentence**
```
They closed the deal with Pitt, Briggs & Co. at noon.
=> ["They closed the deal with Pitt, Briggs & Co. at noon."]
```

8.) **Two letter lower case abbreviations at the end of a sentence**
```
Let's ask Jane and co. They should know.
=> ["Let's ask Jane and co.", "They should know."]
```

9.) **Two letter upper case abbreviations at the end of a sentence**
```
They closed the deal with Pitt, Briggs & Co. It closed yesterday.
=> ["They closed the deal with Pitt, Briggs & Co.", "It closed yesterday."]
```

10.) **Two letter (prepositive) abbreviations**
```
I can see Mt. Fuji from here.
=> ["I can see Mt. Fuji from here."]
```

11.) **Two letter (prepositive & postpositive) abbreviations**
```
St. Michael's Church is on 5th st. near the light.
=> ["St. Michael's Church is on 5th st. near the light."]
```

12.) **Possesive two letter abbreviations**
```
That is JFK Jr.'s book.
=> ["That is JFK Jr.'s book."]
```

13.) **Multi-period abbreviations in the middle of a sentence**
```
I visited the U.S.A. last year.
=> ["I visited the U.S.A. last year."]
```

14.) **Multi-period abbreviations at the end of a sentence**
```
I live in the E.U. How about you?
=> ["I live in the E.U.", "How about you?"]
```

15.) **U.S. as sentence boundary**
```
I live in the U.S. How about you?
=> ["I live in the U.S.", "How about you?"]
```

16.) **U.S. as non sentence boundary with next word capitalized**
```
I work for the U.S. Government in Virginia.
=> ["I work for the U.S. Government in Virginia."]
```

17.) **U.S. as non sentence boundary**
```
I have lived in the U.S. for 20 years.
=> ["I have lived in the U.S. for 20 years."]
```

18.) **A.M. / P.M. as non sentence boundary and sentence boundary**
```
At 5 a.m. Mr. Smith went to the bank. He left the bank at 6 P.M. Mr. Smith then went to the store.
=> ["At 5 a.m. Mr. Smith went to the bank.", "He left the bank at 6 P.M.", "Mr. Smith then went to the store."]
```

19.) **Number as non sentence boundary**
```
She has $100.00 in her bag.
=> ["She has $100.00 in her bag."]
```

20.) **Number as sentence boundary**
```
She has $100.00. It is in her bag.
=> ["She has $100.00.", "It is in her bag."]
```

21.) **Parenthetical inside sentence**
```
He teaches science (He previously worked for 5 years as an engineer.) at the local University.
=> ["He teaches science (He previously worked for 5 years as an engineer.) at the local University."]
```

22.) **Email addresses**
```
Her email is Jane.Doe@example.com. I sent her an email.
=> ["Her email is Jane.Doe@example.com.", "I sent her an email."]
```

23.) **Web addresses**
```
The site is: https://www.example.50.com/new-site/awesome_content.html. Please check it out.
=> ["The site is: https://www.example.50.com/new-site/awesome_content.html.", "Please check it out."]
```

24.) **Single quotations inside sentence**
```
She turned to him, 'This is great.' she said.
=> ["She turned to him, 'This is great.' she said."]
```

25.) **Double quotations inside sentence**
```
She turned to him, "This is great." she said.
=> ["She turned to him, \"This is great.\" she said."]
```

26.) **Double quotations at the end of a sentence**
```
She turned to him, \"This is great.\" She held the book out to show him.
=> ["She turned to him, \"This is great.\"", "She held the book out to show him."]
```

27.) **Double punctuation (exclamation point)**
```
Hello!! Long time no see.
=> ["Hello!!", "Long time no see."]
```

28.) **Double punctuation (question mark)**
```
Hello?? Who is there?
=> ["Hello??", "Who is there?"]
```

29.) **Double punctuation (exclamation point / question mark)**
```
Hello!? Is that you?
=> ["Hello!?", "Is that you?"]
```

30.) **Double punctuation (question mark / exclamation point)**
```
Hello?! Is that you?
=> ["Hello?!", "Is that you?"]
```

31.) **List (period followed by parens and no period to end item)**
```
1.) The first item 2.) The second item
=> ["1.) The first item", "2.) The second item"]
```

32.) **List (period followed by parens and period to end item)**
```
1.) The first item. 2.) The second item.
=> ["1.) The first item.", "2.) The second item."]
```

33.) **List (parens and no period to end item)**
```
1) The first item 2) The second item
=> ["1) The first item", "2) The second item"]
```

34.) **List (parens and period to end item)**
```
1) The first item. 2) The second item.
=> ["1) The first item.", "2) The second item."]
```

35.) **List (period to mark list and no period to end item)**
```
1. The first item 2. The second item
=> ["1. The first item", "2. The second item"]
```

36.) **List (period to mark list and period to end item)**
```
1. The first item. 2. The second item.
=> ["1. The first item.", "2. The second item."]
```

37.) **List with bullet**
```
• 9. The first item • 10. The second item
=> ["• 9. The first item", "• 10. The second item"]
```

38.) **List with hypthen**
```
⁃9. The first item ⁃10. The second item
=> ["⁃9. The first item", "⁃10. The second item"]
```

39.) **Alphabetical list**
```
a. The first item b. The second item c. The third list item
=> ["a. The first item", "b. The second item", "c. The third list item"]
```

40.) **Errant newline in the middle of a sentence (PDF)**
```
This is a sentence\ncut off in the middle because pdf.
=> ["This is a sentence\ncut off in the middle because pdf."]
```

41.) **Errant newline in the middle of a sentence**
```
It was a cold \nnight in the city.
=> ["It was a cold night in the city."]
```

42.) **Lower case list separated by newline**
```
features\ncontact manager\nevents, activities\n
=> ["features", "contact manager", "events, activities"]
```

43.) **Geo Coordinates**
```
You can find it at N°. 1026.253.553. That is where the treasure is.
=> ["You can find it at N°. 1026.253.553.", "That is where the treasure is."]
```

44.) **Named entities with an exclamation point**
```
She works at Yahoo! in the accounting department.
=> ["She works at Yahoo! in the accounting department."]
```

45.) **I as a sentence boundary and I as an abbreviation**
```
We make a good team, you and I. Did you see Albert I. Jones yesterday?
=> ["We make a good team, you and I.", "Did you see Albert I. Jones yesterday?"]
```

46.) **Ellipsis at end of quotation**
```
Thoreau argues that by simplifying one’s life, “the laws of the universe will appear less complex. . . .”
=> ["Thoreau argues that by simplifying one’s life, “the laws of the universe will appear less complex. . . .”"]
```

47.) **Ellipsis with square brackets**
```
"Bohr [...] used the analogy of parallel stairways [...]" (Smith 55).
=> ["\"Bohr [...] used the analogy of parallel stairways [...]\" (Smith 55)."]
```

48.) **Ellipsis as sentence boundary (standard ellipsis rules)**
```
If words are left off at the end of a sentence, and that is all that is omitted, indicate the omission with ellipsis marks (preceded and followed by a space) and then indicate the end of the sentence with a period . . . . Next sentence.
=> ["If words are left off at the end of a sentence, and that is all that is omitted, indicate the omission with ellipsis marks (preceded and followed by a space) and then indicate the end of the sentence with a period . . . .", "Next sentence."]
```

49.) **Ellipsis as sentence boundary (non-standard ellipsis rules)**
```
I never meant that.... She left the store.
=> ["I never meant that....", "She left the store."]
```

50.) **Ellipsis as non sentence boundary**
```
I wasn’t really ... well, what I mean...see . . . what I'm saying, the thing is . . . I didn’t mean it.
=> ["I wasn’t really ... well, what I mean...see . . . what I'm saying, the thing is . . . I didn’t mean it."
```

51.) **4-dot ellipsis**
```
One further habit which was somewhat weakened . . . was that of combining words into self-interpreting compounds. . . . The practice was not abandoned. . . .
=> ["One further habit which was somewhat weakened . . . was that of combining words into self-interpreting compounds.", ". . . The practice was not abandoned. . . ."]
```

52.) **No whitespace in between sentences** *Credit: Don_Patrick*
```
Hello world.Today is Tuesday.Mr. Smith went to the store and bought 1,000.That is a lot.
=> ["Hello world.", "Today is Tuesday.", "Mr. Smith went to the store and bought 1,000.", "That is a lot."]
```

#### Golden Rules (German)

1.) **Quotation at end of sentence**
```
„Ich habe heute keine Zeit“, sagte die Frau und flüsterte leise: „Und auch keine Lust.“ Wir haben 1.000.000 Euro.
=> ["„Ich habe heute keine Zeit“, sagte die Frau und flüsterte leise: „Und auch keine Lust.“", "Wir haben 1.000.000 Euro."]
```

2.) **Abbreviations**
```
Es gibt jedoch einige Vorsichtsmaßnahmen, die Du ergreifen kannst, z. B. ist es sehr empfehlenswert, dass Du Dein Zuhause von allem Junkfood befreist.
=> ["Es gibt jedoch einige Vorsichtsmaßnahmen, die Du ergreifen kannst, z. B. ist es sehr empfehlenswert, dass Du Dein Zuhause von allem Junkfood befreist."]
```

3.) **Numbers**
```
Was sind die Konsequenzen der Abstimmung vom 12. Juni?
=> ["Was sind die Konsequenzen der Abstimmung vom 12. Juni?"]
```

4.) **Cardinal numbers at end of sentence** *Credit: Dr. Michael Ustaszewski*
```
Die Information steht auf Seite 12. Dort kannst du nachlesen.
=> ["Die Information steht auf Seite 12.", "Dort kannst du nachlesen."]
```

#### Golden Rules (Japanese)

1.) **Simple period to end sentence**
```
これはペンです。それはマーカーです。
=> ["これはペンです。", "それはマーカーです。"]
```

2.) **Question mark to end sentence**
```
それは何ですか？ペンですか？
=> ["それは何ですか？", "ペンですか？"]
```

3.) **Exclamation point to end sentence**
```
良かったね！すごい！
=> ["良かったね！", "すごい！"]
```

4.) **Quotation**
```
自民党税制調査会の幹部は、「引き下げ幅は３．２９％以上を目指すことになる」と指摘していて、今後、公明党と合意したうえで、３０日に決定する与党税制改正大綱に盛り込むことにしています。
=> ["自民党税制調査会の幹部は、「引き下げ幅は３．２９％以上を目指すことになる」と指摘していて、今後、公明党と合意したうえで、３０日に決定する与党税制改正大綱に盛り込むことにしています。"]
```

5.) **Errant newline in the middle of a sentence**
```
これは父の\n家です。
=> ["これは父の家です。"]
```

#### Golden Rules (Arabic)

1.) **Regular punctuation**
```
سؤال وجواب: ماذا حدث بعد الانتخابات الايرانية؟ طرح الكثير من التساؤلات غداة ظهور نتائج الانتخابات الرئاسية الايرانية التي أججت مظاهرات واسعة واعمال عنف بين المحتجين على النتائج ورجال الامن. يقول معارضو الرئيس الإيراني إن الطريقة التي اعلنت بها النتائج كانت مثيرة للاستغراب.
=> ["سؤال وجواب:", "ماذا حدث بعد الانتخابات الايرانية؟", "طرح الكثير من التساؤلات غداة ظهور نتائج الانتخابات الرئاسية الايرانية التي أججت مظاهرات واسعة واعمال عنف بين المحتجين على النتائج ورجال الامن.", "يقول معارضو الرئيس الإيراني إن الطريقة التي اعلنت بها النتائج كانت مثيرة للاستغراب."]
```

2.) **Abbreviations**
```
وقال د‪.‬ ديفيد ريدي و الأطباء الذين كانوا يعالجونها في مستشفى برمنجهام إنها كانت تعاني من أمراض أخرى. وليس معروفا ما اذا كانت قد توفيت بسبب اصابتها بأنفلونزا الخنازير.
=> ["وقال د‪.‬ ديفيد ريدي و الأطباء الذين كانوا يعالجونها في مستشفى برمنجهام إنها كانت تعاني من أمراض أخرى.", "وليس معروفا ما اذا كانت قد توفيت بسبب اصابتها بأنفلونزا الخنازير."]
```

3.) **Numbers and Dates**
```
ومن المنتظر أن يكتمل مشروع خط أنابيب نابوكو البالغ طوله 3300 كليومترا في 12‪/‬08‪/‬2014 بتكلفة تُقدر بـ 7.9 مليارات يورو أي نحو 10.9 مليارات دولار. ومن المقرر أن تصل طاقة ضخ الغاز في المشروع 31 مليار متر مكعب انطلاقا من بحر قزوين مرورا بالنمسا وتركيا ودول البلقان دون المرور على الأراضي الروسية.
=> ["ومن المنتظر أن يكتمل مشروع خط أنابيب نابوكو البالغ طوله 3300 كليومترا في 12‪/‬08‪/‬2014 بتكلفة تُقدر بـ 7.9 مليارات يورو أي نحو 10.9 مليارات دولار.", "ومن المقرر أن تصل طاقة ضخ الغاز في المشروع 31 مليار متر مكعب انطلاقا من بحر قزوين مرورا بالنمسا وتركيا ودول البلقان دون المرور على الأراضي الروسية."]
```

4.) **Time**
```
الاحد, 21 فبراير/ شباط, 2010, 05:01 GMT الصنداي تايمز: رئيس الموساد قد يصبح ضحية الحرب السرية التي شتنها بنفسه. العقل المنظم هو مئير داجان رئيس الموساد الإسرائيلي الذي يشتبه بقيامه باغتيال القائد الفلسطيني في حركة حماس محمود المبحوح في دبي.
=> ["الاحد, 21 فبراير/ شباط, 2010, 05:01 GMT الصنداي تايمز:", "رئيس الموساد قد يصبح ضحية الحرب السرية التي شتنها بنفسه.", "العقل المنظم هو مئير داجان رئيس الموساد الإسرائيلي الذي يشتبه بقيامه باغتيال القائد الفلسطيني في حركة حماس محمود المبحوح في دبي."]
```

5.) **Comma**
```
عثر في الغرفة على بعض أدوية علاج ارتفاع ضغط الدم، والقلب، زرعها عملاء الموساد كما تقول مصادر إسرائيلية، وقرر الطبيب أن الفلسطيني قد توفي وفاة طبيعية ربما إثر نوبة قلبية، وبدأت مراسم الحداد عليه
=> ["عثر في الغرفة على بعض أدوية علاج ارتفاع ضغط الدم، والقلب،", "زرعها عملاء الموساد كما تقول مصادر إسرائيلية،", "وقرر الطبيب أن الفلسطيني قد توفي وفاة طبيعية ربما إثر نوبة قلبية،", "وبدأت مراسم الحداد عليه"]
```

#### Golden Rules (Italian)

1.) **Abbreviations**
```
Salve Sig.ra Mengoni! Come sta oggi?
=> ["Salve Sig.ra Mengoni!", "Come sta oggi?"]
```

2.) **Quotations**
```
Una lettera si può iniziare in questo modo «Il/la sottoscritto/a.».
=> ["Una lettera si può iniziare in questo modo «Il/la sottoscritto/a.»."]
```

3.) **Numbers**
```
La casa costa 170.500.000,00€!
=> ["La casa costa 170.500.000,00€!"]
```

#### Golden Rules (Russian)

1.) **Abbreviations**
```
Объем составляет 5 куб.м.
=> ["Объем составляет 5 куб.м."]
```

2.) **Quotations**
```
Маленькая девочка бежала и кричала: «Не видали маму?».
=> ["Маленькая девочка бежала и кричала: «Не видали маму?»."]
```

3.) **Numbers**
```
Сегодня 27.10.14
=> ["Сегодня 27.10.14"]
```

#### Golden Rules (Spanish)

1.) **Question mark to end sentence**
```
¿Cómo está hoy? Espero que muy bien.
=> ["¿Cómo está hoy?", "Espero que muy bien."]
```

2.) **Exclamation point to end sentence**
```
¡Hola señorita! Espero que muy bien.
=> ["¡Hola señorita!", "Espero que muy bien."]
```

3.) **Abbreviations**
```
Hola Srta. Ledesma. Buenos días, soy el Lic. Naser Pastoriza, y él es mi padre, el Dr. Naser.
=> ["Hola Srta. Ledesma.", "Buenos días, soy el Lic. Naser Pastoriza, y él es mi padre, el Dr. Naser."]
```

4.) **Numbers**
```
¡La casa cuesta $170.500.000,00! ¡Muy costosa! Se prevé una disminución del 12.5% para el próximo año.
=> ["¡La casa cuesta $170.500.000,00!", "¡Muy costosa!", "Se prevé una disminución del 12.5% para el próximo año."]
```

5.) **Quotations**
```
«Ninguna mente extraordinaria está exenta de un toque de demencia.», dijo Aristóteles.
=> ["«Ninguna mente extraordinaria está exenta de un toque de demencia.», dijo Aristóteles."]
```

#### Golden Rules (Greek)

1.) **Question mark to end sentence**
```
Με συγχωρείτε· πού είναι οι τουαλέτες; Τις Κυριακές δε δούλευε κανένας. το κόστος του σπιτιού ήταν £260.950,00.
=> ["Με συγχωρείτε· πού είναι οι τουαλέτες;", "Τις Κυριακές δε δούλευε κανένας.", "το κόστος του σπιτιού ήταν £260.950,00."]
```

#### Golden Rules (Hindi)

1.) **Full stop**
```
सच्चाई यह है कि इसे कोई नहीं जानता। हो सकता है यह फ़्रेन्को के खिलाफ़ कोई विद्रोह रहा हो, या फिर बेकाबू हो गया कोई आनंदोत्सव।
=> ["सच्चाई यह है कि इसे कोई नहीं जानता।", "हो सकता है यह फ़्रेन्को के खिलाफ़ कोई विद्रोह रहा हो, या फिर बेकाबू हो गया कोई आनंदोत्सव।"]
```

#### Golden Rules (Armenian)

1.) **Sentence ending punctuation**
```
Ի՞նչ ես մտածում: Ոչինչ:
=> ["Ի՞նչ ես մտածում:", "Ոչինչ:"]
```

2.) **Ellipsis**
```
Ապրիլի 24-ին սկսեց անձրևել...Այդպես էի գիտեի:
=> ["Ապրիլի 24-ին սկսեց անձրևել...Այդպես էի գիտեի:"]
```

3.) **Period is not a sentence boundary**
```
Այսպիսով` մոտենում ենք ավարտին: Տրամաբանությյունը հետևյալն է. պարզություն և աշխատանք:
=> ["Այսպիսով` մոտենում ենք ավարտին:", "Տրամաբանությյունը հետևյալն է. պարզություն և աշխատանք:"]
```

#### Golden Rules (Burmese)

1.) **Sentence ending punctuation**
```
ခင္ဗ်ားနာမည္ဘယ္လိုေခၚလဲ။၇ွင္ေနေကာင္းလား။
=> ["ခင္ဗ်ားနာမည္ဘယ္လိုေခၚလဲ။", "၇ွင္ေနေကာင္းလား။"]
```

#### Golden Rules (Amharic)

1.) **Sentence ending punctuation**
```
እንደምን አለህ፧መልካም ቀን ይሁንልህ።እባክሽ ያልሽዉን ድገሚልኝ።
=> ["እንደምን አለህ፧", "መልካም ቀን ይሁንልህ።", "እባክሽ ያልሽዉን ድገሚልኝ።"]
```

#### Golden Rules (Persian)

1.) **Sentence ending punctuation**
```
خوشبختم، آقای رضا. شما کجایی هستید؟ من از تهران هستم.
=> ["خوشبختم، آقای رضا.", "شما کجایی هستید؟", "من از تهران هستم."]
```

#### Golden Rules (Urdu)

1.) **Sentence ending punctuation**
```
کیا حال ہے؟ ميرا نام ___ ەے۔ میں حالا تاوان دےدوں؟
=> ["کیا حال ہے؟", "ميرا نام ___ ەے۔", "میں حالا تاوان دےدوں؟"]
```

#### Golden Rules (Dutch)

1.) **Sentence starting with a number**
```
Hij schoot op de JP8-brandstof toen de Surface-to-Air (sam)-missiles op hem af kwamen. 81 procent van de schoten was raak.
=> ["Hij schoot op de JP8-brandstof toen de Surface-to-Air (sam)-missiles op hem af kwamen.", "81 procent van de schoten was raak."]
```

2.) **Sentence starting with an ellipsis**
```
81 procent van de schoten was raak. ...en toen barste de hel los.
=> ["81 procent van de schoten was raak.", "...en toen barste de hel los."]
```

## Comparison of Segmentation Tools, Libraries and Algorithms

Name                                                                 | Programming Language | License                                             | GRS (English) | GRS (Other Languages)† | Speed‡
---------------------------------------------------------------------| -------------------- | --------------------------------------------------- | ------------- | ---------------------- | -------
Pragmatic Segmenter                                                  | Ruby                 | [MIT](http://opensource.org/licenses/MIT)           | 98.08%        | 100.00%                | 3.84 s
[TactfulTokenizer](https://github.com/zencephalon/Tactful_Tokenizer) | Ruby                 | [GNU GPLv3](http://www.gnu.org/copyleft/gpl.html)   | 65.38%        | 48.57%                 | 46.32 s
[OpenNLP](https://opennlp.apache.org/)                               | Java                 | [APLv2](http://www.apache.org/licenses/LICENSE-2.0) | 59.62%        | 45.71%                 | 1.27 s
[Standford CoreNLP](http://nlp.stanford.edu/software/corenlp.shtml)  | Java                 | [GNU GPLv3](http://www.gnu.org/copyleft/gpl.html)   | 59.62%        | 31.43%                 | 0.92 s
[Splitta](http://www.nltk.org/_modules/nltk/tokenize/punkt.html)     | Python               | [APLv2](http://www.apache.org/licenses/LICENSE-2.0) | 55.77%        | 37.14%                 | N/A
[Punkt](http://www.nltk.org/_modules/nltk/tokenize/punkt.html)       | Python               | [APLv2](http://www.apache.org/licenses/LICENSE-2.0) | 46.15%        | 48.57%                 | 1.79 s
[SRX English](https://github.com/apohllo/srx-english)                | Ruby                 | [GNU GPLv3](http://www.gnu.org/copyleft/gpl.html)   | 30.77%        | 28.57%                 | 6.19 s
[Scapel](https://github.com/louismullie/scalpel)                     | Ruby                 | [GNU GPLv3](http://www.gnu.org/copyleft/gpl.html)   | 28.85%        | 20.00%                 | 0.13 s

†GRS (Other Languages) is the total of the Golden Rules listed above for all languages other than English. This metric by no means includes all languages, only the ones that have Golden Rules listed above.
‡ Speed is based on the performance benchmark results detailed in the section "Speed Performance Benchmarks" below. The number is an average of 10 runs.

Other tools not yet tested:
* [FreeLing](http://nlp.lsi.upc.edu/freeling/)
* [Alpino](http://www.let.rug.nl/vannoord/alp/Alpino/)
* [trtok](https://github.com/jirkamarsik/trainable-tokenizer)
* [segtok](https://github.com/fnl/segtok)
* [LingPipe](http://alias-i.com/lingpipe/demos/tutorial/sentences/read-me.html)
* [Elephant](http://gmb.let.rug.nl/elephant/experiments.php)
* [Ucto: Unicode Tokenizer](http://ilk.uvt.nl/ucto/)
* [tokenizer](http://moin.delph-in.net/WeSearch/DocumentParsing)
* [spaCy](http://honnibal.github.io/spaCy/)
* [GATE](https://gate.ac.uk/)
* [University of Illinois Sentence Segmentation tool](http://cogcomp.cs.illinois.edu/page/tools_view/2)
* [DetectorMorse](https://github.com/cslu-nlp/detectormorse)

## Speed Performance Benchmarks

To test the relative performance of different segmentation tools and libraries I created a simple benchmark test. The test takes the 50 English Golden Rules combined into one string and runs it 100 times through the segmenter. This speed benchmark is by no means the most scientific benchmark, but it should help to give some relative performance data. The tests were done on a Mac Pro 3.7 GHz Quad-Core Intel Xeon E5 running 10.9.5. For Punkt the tests were run using this [Ruby port](https://github.com/lfcipriani/punkt-segmenter), for Standford CoreNLP the tests were run using this [Ruby port](https://github.com/louismullie/stanford-core-nlp), and for OpenNLP the tests were run using this [Ruby port](https://github.com/louismullie/open-nlp).

## Languages with sentence boundary punctuation that is different than English

*If you know of any languages that are missing from the list below, please open an issue. Thank you.*

**Pragmatic Segmenter** supports the following languages with regards to sentence boundary punctuation that is different than English:
* Amharic
* Arabic
* Armenian
* Burmese
* Chinese
* Greek
* Hindi
* Japanese
* Persian
* Urdu

## Segmentation Papers and Books

* *Elephant: Sequence Labeling for Word and Sentence Segmentation* - Kilian Evang, Valerio Basile, Grzegorz Chrupała and Johan Bos (2013) [[pdf](http://www.aclweb.org/anthology/D13-1146) | [mirror](https://s3.amazonaws.com/tm-town-nlp-resources/Elephant-+Sequence+Labeling+for+Word+and+Sentence+Segmentation.pdf)]
* *Sentence Boundary Detection: A Long Solved Problem?* (Second Edition) - Jonathon Read, Rebecca Dridan, Stephan Oepen, Lars Jørgen Solberg (2012) [[pdf](http://www.aclweb.org/anthology/C12-2096) | [mirror](https://s3.amazonaws.com/tm-town-nlp-resources/C12-2096.pdf)]
* *Handbook of Natural Language Processing* (Second Edition) - Nitin Indurkhya and Fred J. Damerau (2010) [[amazon](http://www.amazon.com/Handbook-Language-Processing-Learning-Recognition/dp/1420085921)]
* *Sentence Boundary Detection and the Problem with the U.S.* - Dan Gillick (2009) [[pdf](http://dgillick.com/resource/sbd_naacl_2009.pdf) | [mirror](https://s3.amazonaws.com/tm-town-nlp-resources/sbd_naacl_2009.pdf)]
* *Thoughts on Word and Sentence Segmentation in Thai* - Wirote Aroonmanakun (2007) [[pdf](http://pioneer.chula.ac.th/~awirote/ling/snlp2007-wirote.pdf) | [mirror](https://s3.amazonaws.com/tm-town-nlp-resources/snlp2007-wirote.pdf)]
* *Unsupervised Multilingual Sentence Boundary Detection* - Tibor Kiss and Jan Strunk (2005) [[pdf](http://www.linguistics.ruhr-uni-bochum.de/~strunk/ks2005FINAL.pdf) | [mirror](https://s3.amazonaws.com/tm-town-nlp-resources/ks2005FINAL.pdf)]
* *An Analysis of Sentence Boundary Detection Systems for English and Portuguese Documents* - Carlos N. Silla Jr. and Celso A. A. Kaestner (2004) [[pdf](https://www.cs.kent.ac.uk/pubs/2004/2930/content.pdf) | [mirror](https://s3.amazonaws.com/tm-town-nlp-resources/An+Analysis+of+Sentence+Boundary+Detection+Systems+for+English+and+Portuguese+Documents.pdf)]
* *Periods, Capitalized Words, etc.* - Andrei Mikheev (2002) [[pdf](https://s3.amazonaws.com/tm-town-nlp-resources/cl-prop.pdf)]
* *Scaled log likelihood ratios for the detection of abbreviations in text corpora* - Tibor Kiss and Jan Strunk (2002) [[pdf](http://www.linguistics.ruhr-uni-bochum.de/~kiss/publications/abbrev.pdf) | [mirror](https://s3.amazonaws.com/tm-town-nlp-resources/abbrev.pdf)]
* *Viewing sentence boundary detection as collocation identification* - Tibor Kiss and Jan Strunk (2002) [[pdf](http://www.linguistics.rub.de/~kiss/publications/07v-kiss.pdf) | [mirror](https://s3.amazonaws.com/tm-town-nlp-resources/07v-kiss.pdf)]
* *Automatic Sentence Break Disambiguation for Thai* - Paisarn Charoenpornsawat and Virach Sornlertlamvanich (2001) [[pdf](http://www.cs.cmu.edu/~paisarn/papers/iccpol2001.pdf) | [mirror](https://s3.amazonaws.com/tm-town-nlp-resources/iccpol2001.pdf)]
* *Sentence Boundary Detection: A Comparison of Paradigms for Improving MT Quality* - Daniel J. Walker, David E. Clements, Maki Darwin and Jan W. Amtrup (2001) [[pdf](https://www.cs.kent.ac.uk/pubs/2004/2930/content.pdf) | [mirror](https://s3.amazonaws.com/tm-town-nlp-resources/walker.pdf)]
* *A Sentence Boundary Detection System* - Wendy Chen (2000) [[ppt](www.deg.byu.edu/presentations/SpResConf00.chen/SpResConf00.ppt) | [mirror](https://s3.amazonaws.com/tm-town-nlp-resources/SpResConf00.ppt)]
* *Tagging Sentence Boundaries* - Andrei Mikheev (2000) [[pdf](http://www.aclweb.org/anthology/A00-2035) | [mirror](https://s3.amazonaws.com/tm-town-nlp-resources/A00-2035.pdf)]
* *Automatic Extraction of Rules For Sentence Boundary Disambiguation* - E. Stamatatos, N. Fakotakis, AND G. Kokkinakis (1999) [[pdf](https://s3.amazonaws.com/tm-town-nlp-resources/Automatic+Extraction+of+Rules+For+Sentence+Boundary+Disambiguation.pdf)]
* *A Maximum Entropy Approach to Identifying Sentence Boundaries* - Jeffrey C. Reynar and Adwait Ratnaparkhi (1997) [[pdf](https://www.aclweb.org/anthology/A/A97/A97-1004.pdf) | [mirror](https://s3.amazonaws.com/tm-town-nlp-resources/A97-1004.pdf)]
* *Adaptive Multilingual Sentence Boundary Disambiguation* - David D. Palmer and Marti A. Hearst (1997) [[pdf](http://people.ischool.berkeley.edu/~hearst/papers/cl-palmer.pdf) | [mirror](https://s3.amazonaws.com/tm-town-nlp-resources/cl-palmer.pdf)]
* *What is a word, What is a sentence? Problems of Tokenization* - Gregory Grefenstette and Pasi Tapanainen (1994) [[pdf](https://files.ifi.uzh.ch/cl/siclemat/lehre/papers/GrefenstetteTapanainen1994.pdf) | [mirror](https://s3.amazonaws.com/tm-town-nlp-resources/GrefenstetteTapanainen1994.pdf)]
* *Chapter 2: Tokenisation and Sentence Segmentation* - David D. Palmer [[pdf](http://comp.mq.edu.au/units/comp348/ch2.pdf) | [mirror](https://s3.amazonaws.com/tm-town-nlp-resources/ch2.pdf)]
* *Using SRX standard for sentence segmentation in LanguageTool* - Marcin Miłkowski and Jarosław Lipski [[pdf](http://marcinmilkowski.pl/downloads/ltc-043-milkowski.pdf) | [mirror](https://s3.amazonaws.com/tm-town-nlp-resources/ltc-043-milkowski.pdf)]

## TODO

* Add additional language support
* Add abbreviation lists for any languages that do not currently have one (only relevant for languages that have the concept of abbreviations with periods)
* Get Golden Rule #18 passing - Handling of a.m. or p.m. followed by a capitalized non sentence starter (ex. "At 5 p.m. Mr. Smith went to the bank. He left the bank at 6 p.m. Next he went to the store." --> ["At 5 p.m. Mr. Smith went to the bank.", "He left the bank at 6 p.m.", "Next he went to the store."])
* Support for Thai. This is a very challenging problem due to the absence of explicit sentence markers (i.e. like a period in English) and the ambiguity in Thai regarding what constitutes a sentence even among native speakers. For more information see the following research papers ([#1](http://www.cs.cmu.edu/~paisarn/papers/iccpol2001.pdf) | [#2](http://pioneer.chula.ac.th/~awirote/ling/snlp2007-wirote.pdf)).

## Change Log

**Version 0.0.1**
* Initial Release

**Version 0.0.2**
* Major design refactor

**Version 0.0.3**
* Add travis.yml
* Add Code Climate
* Update README

**Version 0.0.4**
* Add `ConsecutiveForwardSlashRule` to cleaner
* Refactor `segmenter.rb` and `process.rb`

**Version 0.0.5**
* Make symbol substitution safer
* Refactor `process.rb`
* Update cleaner with escaped newline rules

**Version 0.0.6**
* Add rule for escaped newlines that include a space between the slash and character
* Add Golden Rule #52 and code to make it pass

**Version 0.0.7**
* Add change log to README
* Add passing spec for new end of sentence abbreviation (EN)
* Add roman numeral list support

**Version 0.0.8**
* Fix error in `list.rb`

**Version 0.0.9**
* Improve handling of alphabetical and roman numeral lists

**Version 0.1.0**
* Add Kommanditgesellschaft Rule

**Version 0.1.1**
* Fix handling of German dates

**Version 0.1.2**
* Fix missing abbreviations
* Add footnote rule to `cleaner.rb`

**Version 0.1.3**
* Improve punctuation in bracket replacement

**Version 0.1.4**
* Fix missing abbreviations

**Version 0.1.5**
* Fix comma at end of quotation bug

**Version 0.1.6**
* Fix bug in numbered list finder (ignore longer digits)

**Version 0.1.7**
* Add Alice in Wonderland specs
* Fix parenthesis between double quotations bug
* Fix split after quotation ending in dash bug

**Version 0.1.8**
* Fix bug in splitting new sentence after single quotes

**Version 0.2.0**
* Add Dutch Golden Rules and abbreviations
* Update README with additional tools
* Update segmentation test scores in README with results of new Golden Rule tests
* Add Polish abbreviations

**Version 0.3.0**
* Add support for square brackets
* Add support for continuous exclamation points or questions marks or combinations of both
* Fix Roman numeral support
* Add English abbreviations

**Version 0.3.1**
* Fix undefined method 'gsub!' for nil:NilClass issue

**Version 0.3.2**
* Add English abbreviations

**Version 0.3.3**
* Fix cleaner bug

**Version 0.3.4**
* Large refactor

**Version 0.3.5**
* Reduce GC by replacing `#gsub` with `#gsub!` where possible

**Version 0.3.6**
* Refactor SENTENCE_STARTERS to each individual language and add SENTENCE_STARTERS for German

**Version 0.3.7**
* Add `unicode` gem and use it for downcasing to better handle cyrillic languages

**Version 0.3.8**
* Fix bug that cleaned away single letter segments

**Version 0.3.9**
* Remove `guard-rspec` development dependency

**Version 0.3.10**
* Change load order of dependencies to fix bug

**Version 0.3.11**
* Update German abbreviation list
* Refactor 'remove_newline_in_middle_of_sentence' method

**Version 0.3.12**
* Fix issue involving words with leading apostrophes

**Version 0.3.13**
* Fix issue involving unexpected sentence break between abbreviation and hyphen

**Version 0.3.14**
* Add English abbreviation Rs. to denote the Indian currency

**Version 0.3.15**
* Handle em dashes that appear in the middle of a sentence and include a sentence ending punctuation mark

**Version 0.3.16**
* Add support and tests for Danish

**Version 0.3.17**
* Fix issue involving the HTML regex in the cleaner

**Version 0.3.18**
* Performance optimizations

**Version 0.3.19**
* Treat a parenthetical following an abbreviation as part of the same segment

**Version 0.3.20**
* Handle slanted single quotation as a single quote
* Handle a single character abbreviation as part of a list
* Add support for Chinese caret brackets
* Add viz as abbreviation

**Version 0.3.21**
* Add support for file formats
* Add support for numeric references at the end of a sentence (i.e. Wikipedia references)

**Version 0.3.22**
* Add initial support and tests for Kazakh

**Version 0.3.23**
* Refactor for Ruby 3.0 compatibility

## Contributing

If you find a text that is incorrectly segmented using this gem, please submit an issue.

1. Fork it ( https://github.com/diasks2/pragmatic_segmenter/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Ports

* [C# - PragmaticSegmenterNet](https://github.com/UglyToad/PragmaticSegmenterNet)
* [Python - pySBD](https://github.com/nipunsadvilkar/pySBD)

## License

The MIT License (MIT)

Copyright (c) 2015 Kevin S. Dias

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.