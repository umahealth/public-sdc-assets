// Aliases utilizados en este questionnaire
Alias: $sct = http://snomed.info/sct
Alias: $questionnaire-item-control = http://hl7.org/fhir/questionnaire-item-control
Alias: $administrative-gender = http://hl7.org/fhir/administrative-gender
Alias: $loinc = http://loinc.org
Alias: $minValue = http://hl7.org/fhir/StructureDefinition/minValue
Alias: $maxValue = http://hl7.org/fhir/StructureDefinition/maxValue
Alias: $questionnaire-unitOption = http://hl7.org/fhir/StructureDefinition/questionnaire-unitOption
Alias: $questionnaire-itemControl = http://hl7.org/fhir/StructureDefinition/questionnaire-itemControl
Alias: $ucum = http://unitsofmeasure.org
Alias: $allergyintolerance-clinical = http://terminology.hl7.org/CodeSystem/allergyintolerance-clinical
Alias: $condition-clinical = http://terminology.hl7.org/CodeSystem/condition-clinical
Alias: $condition-ver-status = http://terminology.hl7.org/CodeSystem/condition-ver-status
Alias: $sdc-questionnaire-templateExtract = http://hl7.org/fhir/uv/sdc/StructureDefinition/sdc-questionnaire-templateExtract
Alias: $calculatedExpression = http://hl7.org/fhir/uv/sdc/StructureDefinition/sdc-questionnaire-calculatedExpression
Alias: $sdc-variable = http://hl7.org/fhir/StructureDefinition/variable
Alias: $sdc-questionnaire-launchContext = http://hl7.org/fhir/uv/sdc/StructureDefinition/sdc-questionnaire-launchContext
Alias: $launchContext = http://hl7.org/fhir/uv/sdc/CodeSystem/launchContext
Alias: $sdc-questionnaire-initialExpression = http://hl7.org/fhir/uv/sdc/StructureDefinition/sdc-questionnaire-initialExpression
Alias: $questionnaire-hidden = http://hl7.org/fhir/StructureDefinition/questionnaire-hidden

Instance: Extract
InstanceOf: Questionnaire
Usage: #definition

// Extensiones de contexto de $populate
* extension[+]
  * extension[+]
    * url = "name"
    * valueCoding = $launchContext#patient "Patient"
  * extension[+]
    * url = "type"
    * valueCode = #Patient
  * url = $sdc-questionnaire-launchContext

* extension[+]
  * extension[+]
    * url = "name"
    * valueCoding = $launchContext#encounter "Encounter"
  * extension[+]
    * url = "type"
    * valueCode = #Encounter
  * url = $sdc-questionnaire-launchContext

* extension[+]
  * extension[+]
    * url = "name"
    * valueCoding = $launchContext#practitioner "Practitioner"
  * extension[+]
    * url = "type"
    * valueCode = #Practitioner
  * url = $sdc-questionnaire-launchContext

//URL
* url = "https://fhir.example.org/Questionnaire/extract"
* version = "0.1"
* name = "extract"
* title = "Ejemplo de Extract"
* status = #active
* date = "2025-10-08"
* publisher = "UMA Health"
* description = "Formulario de ejemplo para demostrar $extract con template-based extraction"
* useContext[+].code = $sct#394733009 "especialidades médicas"
* useContext[=].valueCodeableConcept = $sct#123457 "extract"

// Extensiones para especificar a que QR profile conforma la respuesta de este QuestionnaireResponse
* extension[+]
  * url = "https://fhir.example.org/StructureDefinition/profile-target"
  * valueUri = "https://fhir.example.org/StructureDefinition/ArgQuestionnaire"

// Extension para extraer bundle specs
* extension[+]
  * extension[+]
    * url = "profile"
    * valueUri = "https://fhir.example.org/StructureDefinition/ArgBundle"
  * extension[+]
    * url = "source"
    * valueString = "jis"
  * extension[+]
    * url = "system"
    * valueUri = "https://fhir.example.org/jis"
  * url = "https://fhir.example.org/StructureDefinition/bundle-specs"

// Recursos contenidos como templates
* contained[+] = ExtractPatientTemplate
* contained[+] = ExtractBodyWeightTemplate
* contained[+] = ExtractBodyHeightTemplate
* contained[+] = ExtractAllergyTemplate
* contained[+] = ExtractConditionTemplate
* contained[+] = ExtractMedicationTemplate

//////////////////////////////////////////////////
// SECCION 0: DATOS FILIATORIOS
//////////////////////////////////////////////////
* item[+]
  * type = #group
  * linkId = "demographics"
  * text = "Datos filiatorios"
  * required = false
  * repeats = false
  * readOnly = false

  // Template extract para datos filiatorios (crea un recurso Patient)
  * extension[+]
    * url = $sdc-questionnaire-templateExtract
    * extension[+]
      * url = "template"
      * valueReference = Reference(ExtractPatientTemplate)
    * extension[+]
      * url = "resourceId"
      * valueString = "item.where(linkId='hidden-patient-id').answer.value.first()"

  // NOMBRE Y APELLIDO
  * item[+]
    * type = #string
    * linkId = "full-name"
    * text = "Nombre y apellido (texto no modificable)"
    * required = true
    * repeats = false
    * readOnly = true
    // Extensiones para $populate
    * extension[+]
      * url = $sdc-questionnaire-initialExpression
      * valueExpression.language = #text/fhirpath
      * valueExpression.expression = "%patient.name.first().select(given.first() & ' ' & family).first()"

  // EDAD
  * item[+]
    * type = #integer
    * linkId = "age"
    * text = "Edad (números enteros)"
    * required = true
    * repeats = false
    * readOnly = false
    // Extensiones para $populate
    * extension[+]
      * url = $sdc-questionnaire-initialExpression
      * valueExpression.language = #text/fhirpath
      * valueExpression.expression = "today().toString().substring(0, 4).toInteger() - %patient.birthDate.toString().substring(0, 4).toInteger()"

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
    // Extensiones para $populate
    * extension[+]
      * url = $sdc-questionnaire-initialExpression
      * valueExpression.language = #text/fhirpath
      * valueExpression.expression = "answerOption.where(valueCoding.code = %patient.gender).valueCoding.first()"

  // FECHA DE NACIMIENTO
  * item[+]
    * type = #date
    * linkId = "birth-date"
    * text = "Fecha de nacimiento"
    * required = true
    * repeats = false
    * readOnly = false
    // Extensiones para $populate
    * extension[+]
      * url = $sdc-questionnaire-initialExpression
      * valueExpression.language = #text/fhirpath
      * valueExpression.expression = "%patient.birthDate"

  // CAMPOS OCULTOS PARA TEMPLATE DE PATIENT
  // Nombre del paciente (oculto)
  * item[+]
    * type = #string
    * linkId = "hidden-patient-given-name"
    * text = "Nombre del paciente (oculto)"
    * required = false
    * repeats = false
    * readOnly = true
    * extension[+]
      * url = $questionnaire-hidden
      * valueBoolean = true
    * extension[+]
      * url = $sdc-questionnaire-initialExpression
      * valueExpression.language = #text/fhirpath
      * valueExpression.expression = "%patient.name.first().given.first()"

  // Apellido del paciente (oculto)
  * item[+]
    * type = #string
    * linkId = "hidden-patient-family-name"
    * text = "Apellido del paciente (oculto)"
    * required = false
    * repeats = false
    * readOnly = true
    * extension[+]
      * url = $questionnaire-hidden
      * valueBoolean = true
    * extension[+]
      * url = $sdc-questionnaire-initialExpression
      * valueExpression.language = #text/fhirpath
      * valueExpression.expression = "%patient.name.first().family"

  * item[+]
    * type = #string
    * linkId = "hidden-patient-id"
    * text = "ID del paciente (oculto)"
    * required = false
    * repeats = false
    * readOnly = true
    * extension[+]
      * url = $questionnaire-hidden
      * valueBoolean = true
    * extension[+]
      * url = $sdc-questionnaire-initialExpression
      * valueExpression.language = #text/fhirpath
      * valueExpression.expression = "%patient.id"
    
//////////////////////////////////////////////////
// SECCION 1: SIGNOS VITALES
//////////////////////////////////////////////////
* item[+]
  * type = #group
  * linkId = "vital-signs"
  * text = "Signos Vitales"
  * required = false
  * repeats = false
  * readOnly = false
  * extension[+]
    * url = $questionnaire-itemControl
    * valueCodeableConcept = $questionnaire-item-control#grid "Grid"

  // FILA: Peso, Altura, IMC
  * item[+]
    * type = #group
    * linkId = "anthropometric-row"
    * text = "Medidas Antropométricas"
    * required = false
    * repeats = false
    * readOnly = false

    // PESO
    * item[+]
      * type = #quantity
      * linkId = "weight"
      * code = $loinc#29463-7 "Body weight"
      * text = "Peso (kg)"
      * required = true
      * repeats = false
      * readOnly = false
      * extension[+]
        * url = $questionnaire-unitOption
        * valueCoding = $ucum#kg "kg"
      * extension[+]
        * url = $minValue
        * valueQuantity.value = 1
      * extension[+]
        * url = $maxValue
        * valueQuantity.value = 300

      // Template extract para peso
      * extension[+]
        * url = $sdc-questionnaire-templateExtract
        * extension[+]
          * url = "template"
          * valueReference = Reference(ExtractBodyWeightTemplate)

    // ALTURA
    * item[+]
      * type = #quantity
      * linkId = "height"
      * code = $loinc#8302-2 "Body height"
      * text = "Altura (cm)"
      * required = true
      * repeats = false
      * readOnly = false
      * extension[+]
        * url = $questionnaire-unitOption
        * valueCoding = $ucum#cm "cm"
      * extension[+]
        * url = $minValue
        * valueQuantity.value = 50
      * extension[+]
        * url = $maxValue
        * valueQuantity.value = 250

      // Template extract para altura
      * extension[+]
        * url = $sdc-questionnaire-templateExtract
        * extension[+]
          * url = "template"
          * valueReference = Reference(ExtractBodyHeightTemplate)

//////////////////////////////////////////////////
// SECCION 2: ALERGIAS
//////////////////////////////////////////////////
* item[+]
  * type = #group
  * linkId = "allergies"
  * text = "Alergias"
  * required = false
  * repeats = true
  * readOnly = false

  // Template extract para alergias (se crea un recurso por cada repetición)
  * extension[+]
    * url = $sdc-questionnaire-templateExtract
    * extension[+]
      * url = "template"
      * valueReference = Reference(ExtractAllergyTemplate)

  // ALERGIA - SUSTANCIA
  * item[+]
    * type = #choice
    * linkId = "allergy-substance"
    * text = "Sustancia alergénica"
    * required = true
    * repeats = false
    * readOnly = false
    * answerOption[+].valueCoding = $sct#387207008 "ibuprofeno"
    * answerOption[+].valueCoding = $sct#372687004 "amoxicilina"
    * answerOption[+].valueCoding = $sct#387458008 "aspirina"
    * answerOption[+].valueCoding = $sct#226361007 "ácido butírico"
    * answerOption[+].valueCoding = $sct#102263004 "huevos (comestibles)"
    * extension[+]
      * url = $questionnaire-itemControl
      * valueCodeableConcept = $questionnaire-item-control#drop-down "Drop down"

  // ALERGIA - REACCION
  * item[+]
    * type = #string
    * linkId = "allergy-reaction"
    * text = "Reacción presentada"
    * required = false
    * repeats = false
    * readOnly = false

//////////////////////////////////////////////////
// SECCION 3: DIAGNOSTICO
//////////////////////////////////////////////////
* item[+]
  * type = #group
  * linkId = "diagnosis"
  * text = "Diagnóstico"
  * required = false
  * repeats = false
  * readOnly = false

  // Template extract para diagnóstico
  * extension[+]
    * url = $sdc-questionnaire-templateExtract
    * extension[+]
      * url = "template"
      * valueReference = Reference(ExtractConditionTemplate)

  // DIAGNOSTICO - CODIGO
  * item[+]
    * type = #choice
    * linkId = "diagnosis-code"
    * text = "Código de diagnóstico"
    * required = true
    * repeats = false
    * readOnly = false
    * answerOption[+].valueCoding = $sct#38341003 "hipertensión"
    * answerOption[+].valueCoding = $sct#73211009 "diabetes mellitus"
    * answerOption[+].valueCoding = $sct#195967001 "asma"
    * answerOption[+].valueCoding = $sct#22298006 "infarto del miocardio"
    * extension[+]
      * url = $questionnaire-itemControl
      * valueCodeableConcept = $questionnaire-item-control#drop-down "Drop down"

  // DIAGNOSTICO - ESTADO DE VERIFICACION
  * item[+]
    * type = #choice
    * linkId = "diagnosis-verification"
    * text = "Estado de verificación"
    * required = true
    * repeats = false
    * readOnly = false
    * answerOption[+].valueCoding = $condition-ver-status#unconfirmed "No confirmado"
    * answerOption[+].valueCoding = $condition-ver-status#confirmed "Confirmado"
    * extension[+]
      * url = $questionnaire-itemControl
      * valueCodeableConcept = $questionnaire-item-control#radio-button "Radio Button"

  // DIAGNOSTICO - NOTAS
  * item[+]
    * type = #text
    * linkId = "diagnosis-notes"
    * text = "Notas adicionales sobre el diagnóstico"
    * required = false
    * repeats = false
    * readOnly = false

//////////////////////////////////////////////////
// SECCION 4: MEDICAMENTOS
//////////////////////////////////////////////////
* item[+]
  * type = #group
  * linkId = "medications"
  * text = "Medicamentos"
  * required = false
  * repeats = true
  * readOnly = false

  // Template extract para medicamentos (se crea un recurso por cada repetición)
  * extension[+]
    * url = $sdc-questionnaire-templateExtract
    * extension[+]
      * url = "template"
      * valueReference = Reference(ExtractMedicationTemplate)

  // MEDICAMENTO - NOMBRE
  * item[+]
    * type = #choice
    * linkId = "medication-name"
    * text = "Medicamento prescrito"
    * required = true
    * repeats = false
    * readOnly = false
    * answerOption[+].valueCoding = $sct#387207008 "ibuprofeno"
    * answerOption[+].valueCoding = $sct#387517004 "paracetamol"
    * answerOption[+].valueCoding = $sct#372687004 "amoxicilina"
    * answerOption[+].valueCoding = $sct#387475002 "furosemida"
    * extension[+]
      * url = $questionnaire-itemControl
      * valueCodeableConcept = $questionnaire-item-control#drop-down "Drop down"

  // MEDICAMENTO - DOSIS
  * item[+]
    * type = #string
    * linkId = "medication-dosage"
    * text = "Dosis e instrucciones"
    * required = true
    * repeats = false
    * readOnly = false

  // MEDICAMENTO - VIA DE ADMINISTRACION
  * item[+]
    * type = #choice
    * linkId = "medication-route"
    * text = "Vía de administración"
    * required = true
    * repeats = false
    * readOnly = false
    * answerOption[+].valueCoding = $sct#26643006 "vía oral"
    * answerOption[+].valueCoding = $sct#47625008 "vía intravenosa"
    * answerOption[+].valueCoding = $sct#78421000 "vía intramuscular"
    * extension[+]
      * url = $questionnaire-itemControl
      * valueCodeableConcept = $questionnaire-item-control#drop-down "Drop down"

