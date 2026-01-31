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

// Gender - optional (may come in various formats)
* gender 0..1 MS
* gender ^short = "Género del paciente (male | female | other | unknown)"

// Case 2: Name - text is sufficient (family/given optional for UMA data)
* name 1..* MS
* name.text 0..1 MS
* name.text ^short = "Nombre completo del paciente"
* name.family 0..1 MS
* name.family ^short = "Apellido del paciente (opcional)"
* name.given 0..* MS
* name.given ^short = "Nombre(s) del paciente (opcional)"

// Identifiers - flexible for UMA data (any system/value allowed)
* identifier 0..* MS
* identifier ^short = "Identificadores del paciente"
* identifier.system 0..1 MS
* identifier.value 1..1 MS

// Address - simple structure
* address 0..* MS
* address ^short = "Dirección del paciente"
* address.country 0..1 MS

// Extensions - optional
* extension 0..* MS

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