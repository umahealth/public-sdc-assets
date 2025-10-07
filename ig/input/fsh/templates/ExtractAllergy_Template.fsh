Alias: $extract-value = http://hl7.org/fhir/uv/sdc/StructureDefinition/sdc-questionnaire-templateExtractValue
Alias: $allergyintolerance-clinical = http://terminology.hl7.org/CodeSystem/allergyintolerance-clinical
Alias: $sct = http://snomed.info/sct

Instance: ExtractAllergyTemplate
InstanceOf: ArgAllergyIntolerance
Usage: #inline

///////////////////////////
// Datos predefinidos en el template (fijos)
///////////////////////////
* clinicalStatus = $allergyintolerance-clinical#active "Active"
* type = #allergy

///////////////////////////
// Datos a extraer del cuestionario
///////////////////////////

// Extrae el código de la alergia
* code.coding = $sct#609328004 "disposición alérgica"
* code.coding.code.extension.url = $extract-value
* code.coding.code.extension.valueString = "item.where(linkId='allergy-substance').answer.value.code.first()"
* code.coding.system.extension.url = $extract-value
* code.coding.system.extension.valueString = "item.where(linkId='allergy-substance').answer.value.system.first()"
* code.coding.display.extension.url = $extract-value
* code.coding.display.extension.valueString = "item.where(linkId='allergy-substance').answer.value.display.first()"

// Extrae la referencia del paciente
* patient.extension.url = $extract-value
* patient.extension.valueString = "%resource.subject"

// Extrae la referencia del encuentro
* encounter.extension.url = $extract-value
* encounter.extension.valueString = "%resource.encounter"

// Extrae el profesional que registra
* recorder.extension.url = $extract-value
* recorder.extension.valueString = "%resource.author"

// Extrae la fecha de registro
* recordedDate = "2024-01-01"
* recordedDate.extension.url = $extract-value
* recordedDate.extension.valueString = "%resource.authored"

// Extrae las notas de la reacción
* note.text = "Reacción alérgica"
* note.text.extension.url = $extract-value
* note.text.extension.valueString = "item.where(linkId='allergy-reaction').answer.value.first()"

// Extrae la fecha de la nota
* note.time = "2024-01-01"
* note.time.extension.url = $extract-value
* note.time.extension.valueString = "%resource.authored"

