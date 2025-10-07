// Aliases utilizados en este questionnaire
Alias: $sct = http://snomed.info/sct
Alias: $questionnaire-item-control = http://hl7.org/fhir/questionnaire-item-control
Alias: $administrative-gender = http://hl7.org/fhir/administrative-gender
Alias: $loinc = http://loinc.org
Alias: $rendering-markdown = http://hl7.org/fhir/StructureDefinition/rendering-markdown
Alias: $minValue = http://hl7.org/fhir/StructureDefinition/minValue
Alias: $maxValue = http://hl7.org/fhir/StructureDefinition/maxValue
Alias: $questionnaire-unitOption = http://hl7.org/fhir/StructureDefinition/questionnaire-unitOption
Alias: $questionnaire-itemControl = http://hl7.org/fhir/StructureDefinition/questionnaire-itemControl
Alias: $ucum = http://unitsofmeasure.org
Alias: $orientation = http://hl7.org/fhir/StructureDefinition/questionnaire-choiceOrientation
Alias: $alergias-valueset = https://fhir.example.org/ValueSet/allergies-jis
Alias: $categories = http://hl7.org/fhir/allergy-intolerance-category

Instance: TiposDeDatos
InstanceOf: Questionnaire
Usage: #definition

//URL
* url = "https://fhir.example.org/Questionnaire/tipos-de-datos"
* version = "0.1"
* name = "tipos-de-datos"
* title = "Ejemplos de tipos de datos"
* status = #active
* date = "2025-10-08"
* publisher = "UMA Health"
* description = "Formulario de ejemplo para JIS 2025"
* useContext[+].code = $sct#394733009 "especialidades médicas"
* useContext[=].valueCodeableConcept = $sct#715184008 "ejemplos de tipos de datos"

//SECCION DATOS FILIATORIOS
* item[+]
  * type = #group
  * linkId = "demographics"
  * text = "Datos filiatorios"
  * required = false
  * repeats = false
  * readOnly = false

  // NOMBRE Y APELLIDO
  * item[+]
    * type = #string
    * linkId = "full-name"
    * text = "Nombre y apellido (texto no modificable)"
    * required = true
    * repeats = false
    * readOnly = true
    * initial.valueString = "Juan Perez"

  // EDAD
  * item[+]
    * type = #integer
    * linkId = "age"
    * text = "Edad (números enteros)"
    * required = true
    * repeats = false
    * readOnly = false

  // SEXO
  * item[+]
    * type = #choice
    * linkId = "gender"
    * text = "Sexo (desplegable)"
    * required = true
    * repeats = false
    * readOnly = false
    * answerOption[+].valueCoding = $administrative-gender#male "Masculino"
    * answerOption[+].valueCoding = $administrative-gender#female "Femenino"
    * answerOption[+].valueCoding = $administrative-gender#other "Otro"
    * answerOption[+].valueCoding = $administrative-gender#unknown "Desconocido"
    * extension[+]
      * url = $questionnaire-itemControl
      * valueCodeableConcept = $questionnaire-item-control#drop-down "Drop down"


//SECCION ANTECEDENTES
* item[+]
  * type = #group
  * linkId = "medical-history"
  * text = "Antecedentes"
  * required = false
  * repeats = false
  * readOnly = false


  // SUBSECCION ALERGIAS

  * item[+]
    * type = #group
    * linkId = "allergies"
    * text = "Alergias (subseccion)"
    * required = false
    * repeats = true

    // ALERGIA ITEM
    * item[+]
      * type = #choice
      * linkId = "allergy-substance"
      * text = "Alergias (busqueda por texto)"
      * required = false
      * repeats = false
      * readOnly = false
      * answerValueSet = $alergias-valueset
      * enableWhen.question = "no-known-allergies"
      * enableWhen.operator = #exists
      * enableWhen.answerBoolean = false
      * enableBehavior = #all
      * extension[+]
        * url = $questionnaire-itemControl
        * valueCodeableConcept = $questionnaire-item-control#lookup "Lookup"

    // ALERGIA OBSERVACION
    * item[+]
      * type = #string
      * linkId = "allergy-notes"
      * text = "Observaciones (aparición condicional)"
      * enableWhen.question = "allergy-substance"
      * enableWhen.operator = #exists
      * enableWhen.answerBoolean = true
      * enableBehavior = #all
      * required = false
      * repeats = false
      * readOnly = false

    // ALERGIA TIPO
    * item[+]
      * type = #choice
      * linkId = "allergy-category"
      * text = "Tipo de alergia (radio-button)"
      * enableWhen.question = "allergy-substance"
      * enableWhen.operator = #exists
      * enableWhen.answerBoolean = true
      * enableBehavior = #all
      * required = false
      * repeats = false
      * readOnly = false
      * answerOption[+].valueCoding = $categories#food "Alimentaria"
      * answerOption[+].valueCoding = $categories#environmental "Ambiental"
      * answerOption[+].valueCoding = $categories#medication "Medicamentosa"
      * answerOption[+].valueCoding = $categories#biological "Biologico"
      * extension[+]
        * url = $questionnaire-itemControl
        * valueCodeableConcept = $questionnaire-item-control#radio-button "Radio-button"

    // ALERGIA NIEGA
    * item[+]
      * type = #choice
      * linkId = "no-known-allergies"
      * required = false
      * repeats = false
      * readOnly = false
      * text = "Niega alergias (desaparece las demas)"
      * answerOption[+].valueCoding = $sct#716186003 "Sin alergia conocida"
      * answerOption[+].valueCoding = $sct#716186004 "Se niega a contestar"
      * enableWhen.question = "allergy-substance"
      * enableWhen.operator = #exists
      * enableWhen.answerBoolean = false
      * enableBehavior = #all
      * extension[+]
        * url = $questionnaire-itemControl
        * valueCodeableConcept = $questionnaire-item-control#check-box "Check-box"
      * extension[+]
        * url = $orientation
        * valueCode = #horizontal  

  // SUBSECCION COMENTARIOS ADICIONALES
  * item[+]
    * type = #group
    * linkId = "additional-comments"
    * text = "Comentarios adicionales"
    * required = false
    * repeats = false
    * readOnly = false

    // CAMPO DE TEXTO LIBRE
    * item[+]
      * type = #string
      * linkId = "physical-activity"
      * text = "Detalle del ejercicio físico"
      * code = $sct#256235009 "Ejercicio físico (Entidad Observable)"
      * required = false
      * repeats = false
      * readOnly = false

// SECCION SEXUALIDAD Y ANTECEDENTES OBSTERICO-GINECOLOGICOS

* item[+]
  * type = #group
  * linkId = "ob-gyn-history"
  * code = $sct#248983002 "antecedentes obstetricos"
  * text = "Sexualidad y antecedentes obstétricos"
  * enableWhen.question = "gender"
  * enableWhen.operator = #=
  * enableWhen.answerCoding = $administrative-gender#female "Femenino"
  * enableBehavior = #all
  * required = false
  * repeats = false
  * readOnly = false

  // SUBSECCION MENARQUIA

  * item[+]
    * type = #group
    * linkId = "menarche"
    * text = "Menarquía"
    * enableBehavior = #all
    * required = false
    * repeats = false
    * readOnly = false

    // MENARQUIA EDAD
    * item[+]
      * type = #quantity
      * linkId = "menarche-age"
      * code = $sct#364314008 "Edad de inicio de la menstruación"
      * text = "Edad de menarquía"
      * text.extension.url = $rendering-markdown
      * enableBehavior = #all
      * required = false
      * repeats = false
      * readOnly = false
      * extension[+]
        * url = $questionnaire-unitOption
        * valueCoding = $ucum#a "años"
      * extension[+]
        * url = $minValue
        * valueQuantity.value = 5
      * extension[+]
        * url = $maxValue
        * valueQuantity.value = 40


// SECCION EXAMEN FISICO
* item[+]
  * type = #group
  * linkId = "physical-exam"
  * text = "Examen físico"
  * required = false
  * repeats = false
  * readOnly = false
  * extension[+]
    * url = $questionnaire-itemControl
    * valueCodeableConcept = $questionnaire-item-control#grid "Grid"

  // FILA 1
  * item[+]
    * type = #group
    * linkId = "vitals"
    * required = false
    * repeats = false
    * readOnly = false
    * text = "Parámetros del examen físico"

    // PESO
    * item[+]
      * type = #quantity
      * linkId = "weight"
      * code = $loinc#29463-7 "Body weight"
      * text = "Peso (kg)"
      * required = false
      * repeats = false
      * readOnly = false
      * extension[+]
        * url = $questionnaire-unitOption
        * valueCoding = $ucum#kg "kg"
      * extension[+]
        * url = $minValue
        * valueQuantity.value = 0
      * extension[+]
        * url = $maxValue
        * valueQuantity.value = 600

    // ALTURA
    * item[+]
      * type = #quantity
      * linkId = "height"
      * code = $loinc#8302-2 "Body height"
      * text = "Altura (cm)"
      * required = false
      * repeats = false
      * readOnly = false
      * extension[+]
        * url = $questionnaire-unitOption
        * valueCoding = $ucum#cm "cm"
      * extension[+]
        * url = $minValue
        * valueQuantity.value = 0
      * extension[+]
        * url = $maxValue
        * valueQuantity.value = 250

    // BMI
    * item[+]
      * type = #quantity
      * linkId = "bmi"
      * code = $loinc#9156-5 "Body mass index (BMI) [Ratio]"
      * text = "IMC (kg/m2)"
      * required = false
      * repeats = false
      * readOnly = false
      * extension[+]
        * url = $questionnaire-unitOption
        * valueCoding = $ucum#kg/m2 "kg/m2"

  // GRUPO: Comentario general 
  * item[+]
    * type = #group
    * linkId = "exam-comments"
    * text = "Comentario general"
    * required = false
    * repeats = false
    * readOnly = false

    // CAMPO DE TEXTO LIBRE
    * item[+]
      * type = #string
      * linkId = "exam-findings"
      * text = "Describa los hallazgos generales del examen físico"
      * code = $sct#5880005 "examen físico (procedimiento)"
      * required = false
      * repeats = false
      * readOnly = false

// SECCION REPOSO MÉDICO

* item[+]
  * type = #group
  * linkId = "sick-leave"
  * text = "Indicación de reposo médico"
  * required = false
  * repeats = false
  * readOnly = false
  * extension[+]
    * url = $questionnaire-itemControl
    * valueCodeableConcept = $questionnaire-item-control#grid "Grid"

  // GRUPO NECESARIO PARA MOSTRAR EL GRID FILA 1 (start + end)
  * item[+]
    * type = #group
    * linkId = "leave-period"
    * required = false
    * repeats = false
    * readOnly = false
    * text = "Periodo de reposo médico"

    // START
    * item[+]
      * type = #date
      * linkId = "leave-start"
      * text = "Fecha de inicio"
      * required = false
      * repeats = false
      * readOnly = false
      * extension[+]
        * url = $minValue
        * valueDate = "1990-01-01"
      * extension[+]
        * url = $maxValue
        * valueDate = "2030-01-01"

    // END
    * item[+]
      * type = #date
      * linkId = "leave-end"
      * text = "Fecha de fin"
      * required = false
      * repeats = false
      * readOnly = false
      * extension[+]
        * url = $minValue
        * valueDate = "1990-01-01"
      * extension[+]
        * url = $maxValue
        * valueDate = "2030-01-01"
