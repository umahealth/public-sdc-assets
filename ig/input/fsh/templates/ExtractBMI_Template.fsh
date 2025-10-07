Alias: $extract-value = http://hl7.org/fhir/uv/sdc/StructureDefinition/sdc-questionnaire-templateExtractValue
Alias: $observation-category = http://terminology.hl7.org/CodeSystem/observation-category
Alias: $loinc = http://loinc.org
Alias: $ucum = http://unitsofmeasure.org

Instance: ExtractBMITemplate
InstanceOf: ArgObservation
Usage: #inline

///////////////////////////
// Datos predefinidos en el template (fijos)
///////////////////////////
* status = #final
* category = $observation-category#vital-signs "Vital Signs"
* code = $loinc#39156-5 "Body mass index (BMI) [Ratio]"

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
* performer.extension.url = $extract-value
* performer.extension.valueString = "%resource.author"

// Extrae la fecha de registro
* effectiveDateTime = "2024-01-01"
* effectiveDateTime.extension.url = $extract-value
* effectiveDateTime.extension.valueString = "%resource.authored"

// Extrae el IMC calculado
* valueQuantity.value = 24.2
* valueQuantity.value.extension.url = $extract-value
* valueQuantity.value.extension.valueString = "answer.value.value.first()"

// Unidad de medida fija para IMC
* valueQuantity.unit = "kg/m²"
* valueQuantity.system = $ucum
* valueQuantity.code = #kg/m2

