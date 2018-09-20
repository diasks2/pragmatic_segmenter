require 'spec_helper'

RSpec.describe PragmaticSegmenter::Languages::Deutsch, "(de)" do

  context "Golden Rules" do
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

    it "Numbers #004" do
      # Credit: Dr. Michael Ustaszewski
      # A numeral followed by a dot within the sentence should not be treated as a sentence,
      # because the meaning of numeral + dot is that of an ordinal number.
      # However, if the numeral + dot is in the last position of the sentence, then it is not an ordinal,
      # but a cardinal number and thus a sentence break should be made. See the following example:

      # <INPUT>Die Information steht auf Seite 12. Dort kannst du nachlesen.</INPUT>
      # <SHOULDBE>["Die Information steht auf Seite 12.", "Dort kannst du nachlesen."]</SHOULDBE>
      # The sentence translates as "The information can be found on page 12. You can read it there".

      # That's a tricky one I guess, because the capitalisation of the word following the dot is not necessarily a clue,
      # since German nouns are usually always capitalised.
      skip "NOT IMPLEMENTED"
      ps = PragmaticSegmenter::Segmenter.new(text: "Die Information steht auf Seite 12. Dort kannst du nachlesen.", language: "de")
      expect(ps.segment).to eq(["Die Information steht auf Seite 12.", "Dort kannst du nachlesen."])
    end
  end

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
