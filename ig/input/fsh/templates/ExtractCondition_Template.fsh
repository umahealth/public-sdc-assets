Alias: $extract-value = http://hl7.org/fhir/uv/sdc/StructureDefinition/sdc-questionnaire-templateExtractValue
Alias: $condition-category = http://terminology.hl7.org/CodeSystem/condition-category
Alias: $condition-clinical = http://terminology.hl7.org/CodeSystem/condition-clinical
Alias: $condition-ver-status = http://terminology.hl7.org/CodeSystem/condition-ver-status
Alias: $sct = http://snomed.info/sct

Instance: ExtractConditionTemplate
InstanceOf: ArgCondition
Usage: #inline

///////////////////////////
// Datos predefinidos en el template (fijos)
///////////////////////////
* category = $condition-category#encounter-diagnosis "Encounter Diagnosis"
* clinicalStatus = $condition-clinical#active "Active"

///////////////////////////
// Datos a extraer del cuestionario
///////////////////////////

// Extrae la referencia del paciente
* subject.extension.url = $extract-value
* subject.extension.valueString = "%resource.subject"

// Extrae la referencia del encuentro
* encounter.extension.url = $extract-value
* encounter.extension.valueString = "%resource.encounter"

// Extrae el profesional que registra
* recorder.extension.url = $extract-value
* recorder.extension.valueString = "%resource.author"

// Extrae la fecha de registro
* recordedDate = "2024-01-01T00:00:00Z"
* recordedDate.extension.url = $extract-value
* recordedDate.extension.valueString = "%resource.authored"

// Extrae el código del diagnóstico
* code = $sct#38341003 "hipertensión"
* code.coding.code.extension.url = $extract-value
* code.coding.code.extension.valueString = "item.where(linkId='diagnosis-code').answer.value.code.first()"
* code.coding.system.extension.url = $extract-value
* code.coding.system.extension.valueString = "item.where(linkId='diagnosis-code').answer.value.system.first()"
* code.coding.display.extension.url = $extract-value
* code.coding.display.extension.valueString = "item.where(linkId='diagnosis-code').answer.value.display.first()"

// Extrae el estado de verificación
* verificationStatus = $condition-ver-status#confirmed "Confirmed"
* verificationStatus.coding.code.extension.url = $extract-value
* verificationStatus.coding.code.extension.valueString = "item.where(linkId='diagnosis-verification').answer.value.code.first()"
* verificationStatus.coding.system.extension.url = $extract-value
* verificationStatus.coding.system.extension.valueString = "item.where(linkId='diagnosis-verification').answer.value.system.first()"
* verificationStatus.coding.display.extension.url = $extract-value
* verificationStatus.coding.display.extension.valueString = "item.where(linkId='diagnosis-verification').answer.value.display.first()"

// Extrae las notas del diagnóstico
* note.text = "Notas del diagnóstico"
* note.text.extension.url = $extract-value
* note.text.extension.valueString = "item.where(linkId='diagnosis-notes').answer.value.first()"

// Extrae la fecha de la nota
* note.time = "2024-01-01T00:00:00Z"
* note.time.extension.url = $extract-value
* note.time.extension.valueString = "%resource.authored"

