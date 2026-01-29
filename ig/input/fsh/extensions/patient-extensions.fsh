// Extensions for ArgPatient profile - Test cases for FHIRPath Field Navigator

// Extension for birth place (Case 4: Extension with slice)
Extension: ExtensionBirthPlace
Id: extension-birth-place
Title: "Birth Place Extension"
Description: "Extension to capture the birth place of a patient"
* ^url = "https://fhir.example.org/StructureDefinition/extension-birth-place"
* ^context[0].type = #element
* ^context[0].expression = "Patient"
* value[x] only Address
* valueAddress 1..1

// Extension for district within address (Case 5: Nested slice in address.extension)
Extension: ExtensionDistrict
Id: extension-district
Title: "District Extension"
Description: "Extension to capture the district/locality within an address"
* ^url = "https://fhir.example.org/StructureDefinition/extension-district"
* ^context[0].type = #element
* ^context[0].expression = "Address"
* value[x] only CodeableConcept
* valueCodeableConcept 1..1
* valueCodeableConcept from DistrictValueSet (example)

// ValueSet for districts (example)
ValueSet: DistrictValueSet
Id: district-valueset
Title: "District Value Set"
Description: "Example value set for districts"
* ^url = "https://fhir.example.org/ValueSet/district-valueset"
* include codes from system http://example.org/CodeSystem/districts
