require 'spec_helper'

RSpec.describe PragmaticSegmenter::Languages::Spanish, '(es)' do

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
