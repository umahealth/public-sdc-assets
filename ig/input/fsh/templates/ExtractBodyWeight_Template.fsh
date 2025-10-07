Alias: $extract-value = http://hl7.org/fhir/uv/sdc/StructureDefinition/sdc-questionnaire-templateExtractValue
Alias: $observation-category = http://terminology.hl7.org/CodeSystem/observation-category
Alias: $loinc = http://loinc.org
Alias: $ucum = http://unitsofmeasure.org

Instance: ExtractBodyWeightTemplate
InstanceOf: ArgObservation
Usage: #inline

///////////////////////////
// Datos predefinidos en el template (fijos)
///////////////////////////
* status = #final
* category = $observation-category#vital-signs "Vital Signs"
* code = $loinc#29463-7 "Body Weight"

///////////////////////////
// Datos a extraer del cuestionario
///////////////////////////

// Extrae la referencia del paciente desde el QuestionnaireResponse
* subject.extension.url = $extract-value
* subject.extension.valueString = "%resource.subject"

// Extrae la referencia del encuentro (construida desde el ID hidden)
* encounter.extension.url = $extract-value
* encounter.extension.valueString = "%resource.encounter"

// Extrae el profesional que registra (construida desde el ID hidden)
* performer.extension.url = $extract-value
* performer.extension.valueString = "%resource.author"

// Extrae la fecha de registro (usando la fecha de autoría del QuestionnaireResponse)
* effectiveDateTime = "2024-01-01"
* effectiveDateTime.extension.url = $extract-value
* effectiveDateTime.extension.valueString = "%resource.authored"

// Extrae el peso corporal
* valueQuantity.value = 70
* valueQuantity.value.extension.url = $extract-value
* valueQuantity.value.extension.valueString = "answer.value.value.first()"

* valueQuantity.unit = "kg"
* valueQuantity.unit.extension.url = $extract-value
* valueQuantity.unit.extension.valueString = "answer.value.unit.first()"

* valueQuantity.system = $ucum
* valueQuantity.code = #kg

