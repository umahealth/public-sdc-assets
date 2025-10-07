// Aliases utilizados en este template
Alias: $extract-value = http://hl7.org/fhir/uv/sdc/StructureDefinition/sdc-questionnaire-templateExtractValue
Alias: $administrative-gender = http://hl7.org/fhir/administrative-gender

Instance: ExtractPatientTemplate
InstanceOf: ArgPatient
Usage: #inline

///////////////////////////
// Datos predefinidos (fijos)
///////////////////////////
* active = true

///////////////////////////
// Datos a extraer del cuestionario
///////////////////////////

// Nombre completo (desde el campo full-name)
* name[+].use = #official
* name[=].text = "Nombre completo del paciente"
* name[=].text.extension.url = $extract-value
* name[=].text.extension.valueString = "item.where(linkId='full-name').answer.value.first()"

// Nombre (desde campo oculto)
* name[=].given[+] = "Nombre"
* name[=].given[=].extension.url = $extract-value
* name[=].given[=].extension.valueString = "item.where(linkId='hidden-patient-given-name').answer.value.first()"

// Apellido (desde campo oculto)
* name[=].family = "Apellido"
* name[=].family.extension.url = $extract-value
* name[=].family.extension.valueString = "item.where(linkId='hidden-patient-family-name').answer.value.first()"

// Fecha de nacimiento (desde el campo birth-date)
* birthDate = "1990-01-01"
* birthDate.extension.url = $extract-value
* birthDate.extension.valueString = "item.where(linkId='birth-date').answer.value.first()"

// Sexo (desde el campo gender)
* gender = #unknown
* gender.extension.url = $extract-value
* gender.extension.valueString = "item.where(linkId='gender').answer.value.code.first()"

// Identificador (documento de identidad)
* identifier[+].use = #usual
* identifier[=].type.coding[+].system = "http://terminology.hl7.org/CodeSystem/v2-0203"
* identifier[=].type.coding[=].code = #NN
* identifier[=].type.coding[=].display = "National Number"
* identifier[=].value = "12345678"
* identifier[=].value.extension.url = $extract-value
* identifier[=].value.extension.valueString = "item.where(linkId='document-id').answer.value.first()"

// Teléfono de contacto
* telecom[+].system = #phone
* telecom[=].value = "1234567890"
* telecom[=].value.extension.url = $extract-value
* telecom[=].value.extension.valueString = "item.where(linkId='phone').answer.value.first()"
