require 'spec_helper'

RSpec.describe PragmaticSegmenter::Languages::Italian, "(it)" do

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
