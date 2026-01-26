// SDC CDS Hook Trigger Extension
// Allows Questionnaire items to trigger CDS Hooks when values change

Extension: SDCCDSHookTrigger
Id: sdc-cds-hook-trigger
Title: "SDC CDS Hook Trigger"
Description: "Extension for Questionnaire items to trigger CDS Hooks when the field value changes. The EHR receives the trigger via postMessage and is responsible for calling the CDS service."
Context: Questionnaire.item, Questionnaire.item.item

* extension contains
    hook 1..1 MS and
    serviceId 1..1 MS and
    triggerOn 0..1

* extension[hook] ^short = "CDS Hook type"
* extension[hook] ^definition = "The type of CDS Hook to trigger. Standard hooks from CDS Hooks specification: order-select, order-sign, patient-view, encounter-start, encounter-discharge. See https://cds-hooks.hl7.org/ for the complete list."
* extension[hook].value[x] only code
// Note: CDS Hooks does not define a formal CodeSystem for hook types.
// The hook name is a simple string defined in the CDS Hooks Hook Library.
// Common values: order-select, order-sign, patient-view, encounter-start, encounter-discharge

* extension[serviceId] ^short = "CDS Service identifier"
* extension[serviceId] ^definition = "The identifier of the CDS service to call (e.g., generic-allergy-check). This must match a service id from the CDS Service discovery endpoint."
* extension[serviceId].value[x] only string

* extension[triggerOn] ^short = "When to trigger"
* extension[triggerOn] ^definition = "When the CDS Hook should be triggered. Default is 'change'."
* extension[triggerOn].value[x] only code
* extension[triggerOn].valueCode from SDCCDSTriggerTypes (required)


// =============================================================================
// Code System and ValueSet for triggerOn (our custom extension, not from CDS Hooks)
// =============================================================================

CodeSystem: SDCCDSTriggerTypesCS
Id: sdc-cds-trigger-types
Title: "SDC CDS Trigger Types"
Description: "Code system defining when a CDS Hook should be triggered from an SDC form field. This is a custom extension, not part of the CDS Hooks specification."
* ^experimental = false
* ^caseSensitive = true
* ^url = "https://fhir.example.org/CodeSystem/sdc-cds-trigger-types"
* #change "On Change" "Trigger immediately when the field value changes"
* #submit "On Submit" "Trigger when the form is submitted"


ValueSet: SDCCDSTriggerTypes
Id: sdc-cds-trigger-types-vs
Title: "SDC CDS Trigger Types"
Description: "When the CDS Hook should be triggered from an SDC form field"
* ^experimental = false
* include codes from system SDCCDSTriggerTypesCS
