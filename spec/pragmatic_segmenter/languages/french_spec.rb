require 'spec_helper'

RSpec.describe PragmaticSegmenter::Languages::French, '(fr)' do

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
