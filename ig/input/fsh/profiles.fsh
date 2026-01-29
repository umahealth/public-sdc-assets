// This is a simple example of a FSH file.
// This file can be renamed, and additional FSH files can be added.
// SUSHI will look for definitions in any file using the .fsh ending.

// =============================================================================
// ArgPatient - Profile with 5 test cases for FHIRPath Field Navigator
// =============================================================================
// Test Case 1: Simple first-level field → Patient.gender
// Test Case 2: Nested field without slice → Patient.name.family
// Test Case 3: Field inside identifier slice → Patient.identifier:DNI.type.coding.code
// Test Case 4: Extension with slice → Patient.extension:birthPlace.valueAddress
// Test Case 5: Nested slice (address.extension) → Patient.address.extension:district.valueCodeableConcept.coding.code
// =============================================================================

Profile: ArgPatient
Parent: Patient
Id: ArgPatient
Title: "Argentina Patient Profile"
Description: "Patient profile with sliced identifiers, extensions, and nested extensions for testing FHIRPath generation"

// Case 1: Simple field (gender is already in Patient base)
* gender 1..1 MS
* gender ^short = "Género del paciente (male | female | other | unknown)"

// Case 2: Nested field without slice (name.family is already in Patient base)
* name 1..* MS
* name.family 1..1 MS
* name.family ^short = "Apellido del paciente"
* name.given 1..* MS
* name.given ^short = "Nombre(s) del paciente"

// Case 3: Identifier slice - DNI (Documento Nacional de Identidad)
* identifier ^slicing.discriminator.type = #value
* identifier ^slicing.discriminator.path = "type.coding.code"
* identifier ^slicing.rules = #open
* identifier ^slicing.description = "Slice by identifier type code"

* identifier contains DNI 0..1 MS
* identifier[DNI] ^short = "Documento Nacional de Identidad"
* identifier[DNI].use = #official
* identifier[DNI].type 1..1
* identifier[DNI].type.coding 1..1
* identifier[DNI].type.coding.system = "http://terminology.hl7.org/CodeSystem/v2-0203"
* identifier[DNI].type.coding.code = #NNCARG
* identifier[DNI].type.coding.display = "DNI Argentina"
* identifier[DNI].system = "http://www.renaper.gob.ar/dni"
* identifier[DNI].value 1..1 MS

// Optional: Passport slice for additional testing
* identifier contains Passport 0..1
* identifier[Passport] ^short = "Pasaporte"
* identifier[Passport].use = #secondary
* identifier[Passport].type 1..1
* identifier[Passport].type.coding 1..1
* identifier[Passport].type.coding.system = "http://terminology.hl7.org/CodeSystem/v2-0203"
* identifier[Passport].type.coding.code = #PPN
* identifier[Passport].type.coding.display = "Passport Number"
* identifier[Passport].value 1..1

// Case 4: Extension slice - Birth Place
* extension contains ExtensionBirthPlace named birthPlace 0..1 MS
* extension[birthPlace] ^short = "Lugar de nacimiento del paciente"

// Case 5: Address with nested extension slice - District
* address 0..* MS
* address ^short = "Dirección del paciente"
* address.line 0..* MS
* address.city 0..1 MS
* address.state 0..1 MS
* address.postalCode 0..1 MS
* address.country 0..1 MS

// Nested extension slice within address
* address.extension contains ExtensionDistrict named district 0..1 MS
* address.extension[district] ^short = "Distrito/Localidad de la dirección"

// Additional fields for completeness
* birthDate 0..1 MS
* birthDate ^short = "Fecha de nacimiento"
* telecom 0..* MS
* telecom ^short = "Información de contacto"

Profile: ArgPerson
Parent: Person

Profile: ArgOrganization
Parent: Organization

Profile: ArgPractitioner
Parent: Practitioner

Profile: ArgPractitionerRole
Parent: PractitionerRole

Profile: ArgLocation
Parent: Location

Profile: ArgBundle
Parent: Bundle

Profile: ArgEncounter
Parent: Encounter

Profile: ArgCondition
Parent: Condition

Profile: ArgMedication
Parent: Medication

Profile: ArgMedicationRequest
Parent: MedicationRequest

Profile: ArgObservation
Parent: Observation

Profile: ArgProcedure
Parent: Procedure

Profile: ArgDevice
Parent: Device

Profile: ArgImmunization
Parent: Immunization

Profile: ArgAllergyIntolerance
Parent: AllergyIntolerance

Profile: ArgFamilyMemberHistory
Parent: FamilyMemberHistory

Profile: ArgDiagnosticReport
Parent: DiagnosticReport

Profile: ArgQuestionnaireResponsef
Parent: QuestionnaireResponse