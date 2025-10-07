Alias: $extract-value = http://hl7.org/fhir/uv/sdc/StructureDefinition/sdc-questionnaire-templateExtractValue
Alias: $sct = http://snomed.info/sct

Instance: ExtractMedicationTemplate
InstanceOf: ArgMedicationRequest
Usage: #inline

///////////////////////////
// Datos predefinidos en el template (fijos)
///////////////////////////
* status = #active
* intent = #order

///////////////////////////
// Datos a extraer del cuestionario
///////////////////////////

// Extrae el código del medicamento
* medicationCodeableConcept = $sct#387207008 "ibuprofeno"
* medicationCodeableConcept.coding.code.extension.url = $extract-value
* medicationCodeableConcept.coding.code.extension.valueString = "item.where(linkId='medication-name').answer.value.code.first()"
* medicationCodeableConcept.coding.system.extension.url = $extract-value
* medicationCodeableConcept.coding.system.extension.valueString = "item.where(linkId='medication-name').answer.value.system.first()"
* medicationCodeableConcept.coding.display.extension.url = $extract-value
* medicationCodeableConcept.coding.display.extension.valueString = "item.where(linkId='medication-name').answer.value.display.first()"

// Extrae la referencia del paciente
* subject.extension.url = $extract-value
* subject.extension.valueString = "%resource.subject"

// Extrae la referencia del encuentro
* encounter.extension.url = $extract-value
* encounter.extension.valueString = "%resource.encounter"

// Extrae el profesional que prescribe
* requester.extension.url = $extract-value
* requester.extension.valueString = "%resource.author"

// Extrae la fecha de prescripción
* authoredOn = "2024-01-01T00:00:00Z"
* authoredOn.extension.url = $extract-value
* authoredOn.extension.valueString = "%resource.authored"

// Extrae las instrucciones de dosificación
* dosageInstruction.text = "Instrucciones de dosificación"
* dosageInstruction.text.extension.url = $extract-value
* dosageInstruction.text.extension.valueString = "item.where(linkId='medication-dosage').answer.value.first()"

// Extrae la vía de administración
* dosageInstruction.route = $sct#26643006 "vía oral"
* dosageInstruction.route.coding.code.extension.url = $extract-value
* dosageInstruction.route.coding.code.extension.valueString = "item.where(linkId='medication-route').answer.value.code.first()"
* dosageInstruction.route.coding.system.extension.url = $extract-value
* dosageInstruction.route.coding.system.extension.valueString = "item.where(linkId='medication-route').answer.value.system.first()"
* dosageInstruction.route.coding.display.extension.url = $extract-value
* dosageInstruction.route.coding.display.extension.valueString = "item.where(linkId='medication-route').answer.value.display.first()"

