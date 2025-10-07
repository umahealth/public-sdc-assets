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
Alias: $targetConstraint = http://hl7.org/fhir/StructureDefinition/targetConstraint
Alias: $sdc-variable = http://hl7.org/fhir/StructureDefinition/variable

Instance: Restricciones
InstanceOf: Questionnaire
Usage: #definition

//URL
* url = "https://fhir.example.org/Questionnaire/restricciones"
* version = "0.1"
* name = "restricciones"
* title = "Ejemplos de restricciones"
* status = #active
* date = "2025-10-08"
* publisher = "UMA Health"
* description = "Formulario de ejemplo para JIS 2025"
* useContext[+]
  * code = $sct#394733009
  * valueCodeableConcept = $sct#715184066 "restricciones"

// Variables declaradas
* extension[+]
  * url = $sdc-variable
  * valueExpression
    * language = #text/fhirpath
    * expression = "%resource.repeat(item).where(linkId='body-weight').answer.value.value.first()"
    * name = "weight"
    * description = "Peso en kilogramos"
* extension[+]
  * url = $sdc-variable
  * valueExpression
    * language = #text/fhirpath
    * expression = "%resource.repeat(item).where(linkId='body-height').answer.value.value.first()"
    * name = "height"
    * description = "Altura en centímetros"
* extension[+]
  * url = $sdc-variable
  * valueExpression
    * language = #text/fhirpath
    * expression = "%resource.repeat(item).where(linkId='menarche-age').answer.value.first()"
    * name = "menarche"
    * description = "Edad de inicio de menstruacion"
* extension[+]
  * url = $sdc-variable
  * valueExpression
    * language = #text/fhirpath
    * expression = "now().toString().split('T').first()"
    * name = "timenow"
    * description = "El tiempo actual en formato ISO 8601"
* extension[+]
  * url = $sdc-variable
  * valueExpression
    * language = #text/fhirpath
    * expression = "%resource.repeat(item).where(linkId='leave-start').answer.valueDate.first()"
    * name = "startperiod"
    * description = "Fecha de inicio"
* extension[+]
  * url = $sdc-variable
  * valueExpression
    * language = #text/fhirpath
    * expression = "%resource.item.where(linkId='medical-history').item.where(linkId='allergies').item.where(linkId = 'allergy-substance').answer.valueCoding.select(code + '|' + system)"
    * name = "allergies"
    * description = "Alergias"

//SECCION DATOS FILIATORIOS
* item[+]
  * type = #group
  * linkId = "demographics"
  * text = "Datos del paciente"
  * required = false
  * repeats = false
  * readOnly = false

  // NOMBRE Y APELLIDO
  * item[+]
    * type = #string
    * linkId = "full-name"
    * text = "Nombre y apellido (no permite numeros)"
    * required = true
    * repeats = false
    * readOnly = false
    
    // Extension de targetConstraint
    * extension[+]
      * url = $targetConstraint
      * extension[+]
        * url = "expression"
        * valueExpression.language = #text/fhirpath
        * valueExpression.expression = "iif(%context.exists() and %context.toString().exists() and %context.toString().length() > 0, %context.toString().matches('.*\\\\p{N}.*').not(), true)"
      * extension[+]
        * url = "severity"
        * valueCode = #error
      * extension[+]
        * url = "human"
        * valueString = "No se puede ingresar números"

  // EDAD
  * item[+]
    * type = #integer
    * linkId = "age"
    * text = "Edad (numeros max y min)"
    * required = true
    * repeats = false
    * readOnly = false
    * extension[+]
      * url = $maxValue
      * valueInteger = 125
    * extension[+]
      * url = $minValue
      * valueInteger = 0

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
      * text = "Alergias (no permite repetir)"
      * required = false
      * repeats = false
      * readOnly = false
      * answerOption[+]
        * valueCoding = $sct#387207008 "ibuprofeno"
      * answerOption[+]
        * valueCoding = $sct#372687004 "amoxicilina"
      * answerOption[+]
        * valueCoding = $sct#387458008 "aspirina"
      * answerOption[+]
        * valueCoding = $sct#226361007 "ácido butírico"
      * answerOption[+]
        * valueCoding = $sct#102263004 "huevos (comestibles)"


      * extension[+]
        * url = $questionnaire-itemControl
        * valueCodeableConcept = $questionnaire-item-control#drop-down "Drop down"

      // Extensión de targetConstraint
      * extension[+]
        * url = $targetConstraint
        * extension[+]
          * url = "expression"
          * valueExpression.language = #text/fhirpath
          * valueExpression.expression = "%allergies.count() = %allergies.distinct().count()"
        * extension[+]
          * url = "severity"
          * valueCode = #error
        * extension[+]
          * url = "human"
          * valueString = "No se puede ingresar dos veces una alergia al mismo componente"


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
    * linkId = "menarche-group"
    * text = "Datos de prueba sexualidad"
    * enableBehavior = #all
    * required = false
    * repeats = false
    * readOnly = false

    // MENARQUIA EDAD
    * item[+]
      * type = #integer
      * linkId = "menarche-age"
      * text = "Edad de inicio de menstruacion"
      * required = false
      * repeats = false
      * readOnly = false
      * extension[+]
        * url = $minValue
        * valueInteger = 5
      * extension[+]
        * url = $maxValue
        * valueInteger = 40

    // MENOPAUSIA EDAD
    * item[+]
      * type = #integer
      * linkId = "menopause-age"
      * text = "Edad en años de inicio de menopausia (restricciones con otro item)"
      * required = false
      * repeats = false
      * readOnly = false
      * extension[+]
        * url = $minValue
        * valueInteger = 20
      * extension[+]
        * url = $maxValue
        * valueInteger = 80
      * extension[+]
        * url = $targetConstraint
        * extension[+]
          * url = "expression"
          * valueExpression.language = #text/fhirpath
          * valueExpression.expression = "iif(%context.exists() and %menarche.exists(), %context >= %menarche, true)"
        * extension[+]
          * url = "severity"
          * valueCode = #error
        * extension[+]
          * url = "human"
          * valueString = "La edad de inicio de menopausia no puede ser menor a la edad de inicio de menstruacion"



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
      * linkId = "body-weight"
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
      * linkId = "body-height"
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
      * text = "IMC (calculado)"
      * required = false
      * repeats = false
      * readOnly = false
      * extension[+]
        * url = $questionnaire-unitOption
        * valueCoding = $ucum#kg/m2 "kg/m2"
      // Extensión para configurar variables para calculatedExpressions
      * extension[+]
        * url = $calculatedExpression
        * valueExpression
          * language = #text/fhirpath
          * expression = "iif(%weight.exists() and %height.exists() and %height > 0, (%weight / ((%height/100).power(2))).round(1), {})"
          * description = "IMC en kg/m2 calculado"


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
      * text = "Fecha de inicio (no menor a hoy)"
      * required = false
      * repeats = false
      * readOnly = false
      * extension[+]
        * url = $maxValue
        * valueDate = "2030-01-01"
      * extension[+]
        * url = $targetConstraint
        * extension[+]
          * url = "expression"
          * valueExpression.language = #text/fhirpath
          * valueExpression.expression = "iif(%context.exists() and %timenow.exists(), %context.toDate() >= %timenow.toDate(), true)"
        * extension[+]
          * url = "severity"
          * valueCode = #error
        * extension[+]
          * url = "human"
          * valueString = "La fecha de inicio no puede ser menor a hoy"

    // END
    * item[+]
      * type = #date
      * linkId = "leave-end"
      * text = "Fecha de fin (no menor a inicio)"
      * required = false
      * repeats = false
      * readOnly = false
      * extension[+]
        * url = $minValue
        * valueDate = "1990-01-01"
      * extension[+]
        * url = $maxValue
        * valueDate = "2030-01-01"
      * extension[+]
        * url = $targetConstraint
        * extension[+]
          * url = "expression"
          * valueExpression.language = #text/fhirpath
          * valueExpression.expression = "iif(%context.exists() and %startperiod.exists(), %context.toDate() >= %startperiod.toDate(), true)"
        * extension[+]
          * url = "severity"
          * valueCode = #error
        * extension[+]
          * url = "human"
          * valueString = "La fecha de fin no puede ser menor a la fecha de inicio"