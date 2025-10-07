# Guía de Implementación SDC con Ejemplos (Structured Data Capture) - FSH/SUSHI

## 📋 Índice

1. [Introducción](#introducción)
2. [Requisitos Previos](#requisitos-previos)
3. [Estructura del Proyecto](#estructura-del-proyecto)
4. [Compilación con SUSHI](#compilación-con-sushi)
5. [Conceptos Fundamentales](#conceptos-fundamentales)
   - [Validaciones Básicas](#validaciones-básicas)
   - [Populate con FHIRPath](#populate-con-fhirpath)
   - [Extract con Templates](#extract-con-templates)
   - [Variables Globales](#variables-globales)
   - [Target Constraints](#target-constraints)
   - [Allocate ID](#allocate-id)
6. [Ejemplos Prácticos](#ejemplos-prácticos)
7. [Referencias](#referencias)

---

## Introducción

Esta guía de implementación (IG) está diseñada para **informáticos médicos** y **especialistas en authoring de guías FHIR** que necesitan crear cuestionarios estructurados usando el estándar **SDC (Structured Data Capture)**.
Solo incluye ejemplos de Questionnaires, sin profiles definidos (hay algunos creados a modo de ejemplo para varios recursos, sin modificaciones).

### ¿Qué es SDC?

SDC es una especificación de HL7 FHIR que define cómo:
- **Capturar datos estructurados** mediante formularios (Questionnaires)
- **Pre-llenar formularios** con datos existentes del paciente (`$populate`)
- **Extraer recursos FHIR** desde respuestas de cuestionarios (`$extract`)

### ¿Qué es SUSHI?

**SUSHI** (SUSHI Unshortens ShortHand Inputs) es un compilador que convierte archivos **FSH** (FHIR Shorthand) en recursos FHIR JSON válidos. FSH es un lenguaje de dominio específico diseñado para facilitar la creación de Implementation Guides.

---

## Requisitos Previos

### Software Necesario

```bash
# Node.js 14+ y npm
node --version
npm --version

# Instalar SUSHI globalmente
npm install -g fsh-sushi

# Verificar instalación
sushi --version
```

### Conocimientos Recomendados

- **FHIR R4**: Recursos básicos (Patient, Observation, Condition, etc.)
- **FHIRPath**: Lenguaje de expresiones para navegar recursos FHIR. [Herramienta online](https://hl7.github.io/fhirpath.js/)
- **JSON**: Estructura de datos
- **Conceptos clínicos**: Terminologías (SNOMED CT, LOINC)

---

## Estructura del Proyecto

```
ig/
├── input/
│   ├── fsh/
│   │   ├── profiles.fsh              # Perfiles FHIR (wrappers simples)
│   │   ├── valueset.fsh              # Conjuntos de valores (terminologías)
│   │   ├── questionnaries/           # Questionnaires SDC
│   │   │   ├── tiposdedatos.fsh      # Validaciones y tipos de campos
│   │   │   ├── populate.fsh          # Demostración de $populate
│   │   │   ├── extract.fsh           # Demostración de $extract
│   │   │   └── restricciones.fsh     # Variables y targetConstraints
│   │   └── templates/                # Templates de extract
│   │       ├── ExtractBodyWeight_Template.fsh
│   │       ├── ExtractBodyHeight_Template.fsh
│   │       ├── ExtractCondition_Template.fsh
│   │       └── ... (más templates)
│   └── ignoreWarnings.txt
├── sushi-config.yaml                 # Configuración de SUSHI
└── README.md                         # Este archivo
```

---

## Compilación con SUSHI

### Compilar la IG

Desde la raíz del proyecto (`ig/`):

```bash
# Compilar con SUSHI
sushi build .

# Salida esperada
# ✔ Preprocessed 15 FSH files
# ✔ Exported 48 FHIR resources (25 Questionnaires, 15 StructureDefinitions, ...)
```

### Verificar Salida

Los recursos JSON generados se encuentran en:

```
ig/fsh-generated/resources/
├── Questionnaire-Extract.json
├── Questionnaire-Populate.json
├── Questionnaire-TiposDeDatos.json
├── Questionnaire-Restricciones.json
└── ... (profiles, valuesets, etc.)
```


---

## Conceptos Fundamentales

### Validaciones Básicas

Las validaciones básicas controlan qué datos puede ingresar el usuario en cada campo del formulario.

#### 1. Campos Requeridos

```fsh
* item[+]
  * type = #string
  * linkId = "patient-name"
  * text = "Nombre del paciente"
  * required = true        // Campo obligatorio
  * repeats = false        // No permite múltiples valores
```

#### 2. Restricciones de Valores (min/max)

```fsh
// Para números enteros
* item[+]
  * type = #integer
  * linkId = "age"
  * text = "Edad del paciente"
  * extension[+]
    * url = $minValue
    * valueInteger = 0     // Mínimo: 0
  * extension[+]
    * url = $maxValue
    * valueInteger = 125   // Máximo: 125

// Para cantidades (quantity)
* item[+]
  * type = #quantity
  * linkId = "weight"
  * text = "Peso (kg)"
  * extension[+]
    * url = $minValue
    * valueQuantity.value = 1
  * extension[+]
    * url = $maxValue
    * valueQuantity.value = 300

// Para fechas
* item[+]
  * type = #date
  * linkId = "birth-date"
  * text = "Fecha de nacimiento"
  * extension[+]
    * url = $minValue
    * valueDate = "1900-01-01"
  * extension[+]
    * url = $maxValue
    * valueDate = "2025-12-31"
```

#### 3. Longitud de Texto

```fsh
* item[+]
  * type = #string
  * linkId = "dni"
  * text = "DNI"
  * maxLength = 8        // Máximo 8 caracteres
```

#### 4. Campos de Solo Lectura

```fsh
* item[+]
  * type = #string
  * linkId = "patient-id"
  * text = "ID del paciente (no editable)"
  * readOnly = true      // Campo no editable
```

#### 5. Lógica Condicional (enableWhen)

Mostrar u ocultar campos basándose en respuestas previas:

```fsh
// Campo que se muestra solo si el paciente es femenino
* item[+]
  * type = #group
  * linkId = "pregnancy-history"
  * text = "Antecedentes obstétricos"
  * enableWhen.question = "gender"
  * enableWhen.operator = #=
  * enableWhen.answerCoding = $administrative-gender#female
  * enableBehavior = #all
```

**Operadores de `enableWhen`:**
- `#=` : Igual a
- `#!=` : Diferente de
- `#>` : Mayor que
- `#<` : Menor que
- `#>=` : Mayor o igual que
- `#<=` : Menor o igual que
- `#exists` : Existe (respondido)

---

### Populate con FHIRPath

El **populate** permite pre-llenar un formulario con datos existentes del paciente, encuentro clínico, o practitioner. Hay 3 métodos, en esta guia usamos el [Expression-based Population](https://build.fhir.org/ig/HL7/sdc/populate.html#exp-pop) definido en el estándar.

#### 1. Declarar Launch Context

Primero, se declaran los recursos externos que estarán disponibles durante el populate:

```fsh
Instance: MyQuestionnaire
InstanceOf: Questionnaire

// Declarar que Patient estará disponible como %patient
* extension[+]
  * extension[+]
    * url = "name"
    * valueCoding = $launchContext#patient "Patient"
  * extension[+]
    * url = "type"
    * valueCode = #Patient
  * url = $sdc-questionnaire-launchContext

// Declarar que Encounter estará disponible como %encounter
* extension[+]
  * extension[+]
    * url = "name"
    * valueCoding = $launchContext#encounter "Encounter"
  * extension[+]
    * url = "type"
    * valueCode = #Encounter
  * url = $sdc-questionnaire-launchContext

// Declarar que Practitioner estará disponible como %practitioner
* extension[+]
  * extension[+]
    * url = "name"
    * valueCoding = $launchContext#practitioner "Practitioner"
  * extension[+]
    * url = "type"
    * valueCode = #Practitioner
  * url = $sdc-questionnaire-launchContext
```

#### 2. Initial Expression

Cada campo que desee pre-llenarse debe tener una `initialExpression`:

```fsh
// Pre-llenar nombre del paciente
* item[+]
  * type = #string
  * linkId = "patient-name"
  * text = "Nombre del paciente"
  * readOnly = true
  * extension[+]
    * url = $sdc-questionnaire-initialExpression
    * valueExpression.language = #text/fhirpath
    * valueExpression.expression = "%patient.name.first().select(given.first() & ' ' & family).first()"

// Pre-llenar edad (calculada desde fecha de nacimiento)
* item[+]
  * type = #integer
  * linkId = "age"
  * text = "Edad"
  * extension[+]
    * url = $sdc-questionnaire-initialExpression
    * valueExpression.language = #text/fhirpath
    * valueExpression.expression = "today().toString().substring(0, 4).toInteger() - %patient.birthDate.toString().substring(0, 4).toInteger()"

// Pre-llenar sexo
* item[+]
  * type = #choice
  * linkId = "gender"
  * text = "Sexo"
  * answerOption[+].valueCoding = $administrative-gender#male "Masculino"
  * answerOption[+].valueCoding = $administrative-gender#female "Femenino"
  * extension[+]
    * url = $sdc-questionnaire-initialExpression
    * valueExpression.language = #text/fhirpath
    * valueExpression.expression = "answerOption.where(valueCoding.code = %patient.gender).valueCoding.first()"
```

#### 3. Expresiones FHIRPath Comunes para Populate

```fhirpath
// Acceder al primer nombre del paciente
%patient.name.first().given.first()

// Acceder al apellido del paciente
%patient.name.first().family

// Acceder a la fecha de nacimiento
%patient.birthDate

// Calcular edad actual
today().toString().substring(0, 4).toInteger() - %patient.birthDate.toString().substring(0, 4).toInteger()

// Acceder al género
%patient.gender

// Acceder al ID del encuentro
%encounter.id

// Acceder al ID del practitioner
%practitioner.id
```

#### 4. Flujo de $populate

```
1. Frontend/Backend llama POST /$populate
2. Body contiene Parameters:
   - questionnaire: URL del Questionnaire
   - subject: Reference(Patient/123)
   - context: Reference(Encounter/456)
   - practitioner: Reference(Practitioner/789)
3. Backend evalúa todas las initialExpression
4. Retorna QuestionnaireResponse con status "in-progress" y valores pre-llenados
5. Usuario completa el resto del formulario
```

---

### Extract con Templates

El **extract** convierte un QuestionnaireResponse completado en recursos FHIR estructurados (Observation, Condition, MedicationRequest, etc.).
Hay 4 métodos para realizar esto definido en el estándar. El que mostramos en este tutorial es el [Template-based Extraction](https://build.fhir.org/ig/HL7/sdc/extraction.html#template-extract) definido en la última versión de SDC.

#### 1. Template Básico

Un template es un recurso FHIR con valores dummy y extensiones `$extract-value` que indican qué extraer del QuestionnaireResponse.

**Estructura de un Template:**

```fsh
Alias: $extract-value = http://hl7.org/fhir/uv/sdc/StructureDefinition/sdc-questionnaire-templateExtractValue

Instance: ExtractBodyWeightTemplate
InstanceOf: ArgObservation  // Profile al que conforma
Usage: #inline              // Se usará como contained

///////////////////////////
// Datos predefinidos (fijos)
///////////////////////////
* status = #final
* category = $observation-category#vital-signs "Vital Signs"
* code = $loinc#29463-7 "Body Weight"

///////////////////////////
// Datos a extraer del QuestionnaireResponse
///////////////////////////

// Extraer referencia del paciente desde el QR
* subject.extension.url = $extract-value
* subject.extension.valueString = "%resource.subject"

// Extraer fecha de registro
* effectiveDateTime = "2024-01-01"  // Valor dummy
* effectiveDateTime.extension.url = $extract-value
* effectiveDateTime.extension.valueString = "%resource.authored"

// Extraer valor del peso
* valueQuantity.value = 70  // Valor dummy
* valueQuantity.value.extension.url = $extract-value
* valueQuantity.value.extension.valueString = "answer.value.value.first()"

// Extraer unidad del peso
* valueQuantity.unit = "kg"
* valueQuantity.unit.extension.url = $extract-value
* valueQuantity.unit.extension.valueString = "answer.value.unit.first()"

* valueQuantity.system = $ucum
* valueQuantity.code = #kg
```

#### 2. Tres Extensiones Clave del Extract

##### a) `sdc-questionnaire-templateExtract`

Define qué template usar para extraer datos de un item o grupo:

```fsh
// En el Questionnaire
* item[+]
  * type = #quantity
  * linkId = "weight"
  * text = "Peso (kg)"
  
  // Asociar template de extract
  * extension[+]
    * url = $sdc-questionnaire-templateExtract
    * extension[+]
      * url = "template"
      * valueReference = Reference(ExtractBodyWeightTemplate)
```

##### b) `sdc-questionnaire-templateExtractValue`

Indica qué valor extraer del QuestionnaireResponse (se usa **dentro del template**):

```fsh
// Extraer un valor simple
* valueQuantity.value.extension.url = $extract-value
* valueQuantity.value.extension.valueString = "answer.value.value.first()"

// Extraer de un item específico por linkId
* code.coding.code.extension.url = $extract-value
* code.coding.code.extension.valueString = "item.where(linkId='diagnosis-code').answer.value.code.first()"

// Extraer desde el QuestionnaireResponse root
* subject.extension.url = $extract-value
* subject.extension.valueString = "%resource.subject"
```

###### `resourceId` (opcional)

Es una subextensión dentro de templateExtractValue
Permite especificar el ID del recurso extraído usando una expresión FHIRPath.
En general es un identificador lógico del servidor, que previamente capturamos con el $populate
No se suele mostrar, y está oculto en algún item para poder acceder al momento del $extract
Si el FHIRPath arroja un valor, entonces el $extract debe crear un entry con method = PUT

```fsh
* extension[+]
  * url = $sdc-questionnaire-templateExtract
  * extension[+]
    * url = "template"
    * valueReference = Reference(ExtractPatientTemplate)
  * extension[+]
    * url = "resourceId"
    * valueString = "item.where(linkId='hidden-patient-id').answer.value.first()"
```

##### d) `sdc-questionnaire-templateExtractContext`

Se coloca esta extensión a nivel del template, en algún campo padre. Por ejemplo a nivel del campo identifier.

A los fines de simplificar la guia no incluimos ejemplos de esto pero pueden probarlo en algún template agregando la extensión.

Siempre va asociado a una extensión `templateExtractValue` en los campos hijos. 

Esta extensión nos permite hacer estas dos cosas:

1) Crear una condicion en la cuál, si el contexto es nulo, el campo padre se borra. Por ejemplo: si no tenemos un Questionnaire.item que registre el identifier.value, todo el campo identifier se borra y no se incluye en el recurso extraido. 
2) Crear un loop para iterar cada item repetitivo. Por ejemplo: si tenemos un Questionnaire.item repetible que registra identifier.value, se genera un arreglo de identifier por cada repetición de ese item.

Ejemplo práctico donde podríamos usarlo:
```
// Extrae las observaciones para algun medicamento (una o muchas)
* note.text = "Tomar con las comidas" // Valores dummy

// Contexto de donde se van a extraer los datos (crea un recurso por cada item que devuelva el extractContext o elimina el campo note si no hay ningun item)
* note.extension[+].url = $extract-context
* note.extension[=].valueString = "item.where(linkId='notas-del-medicamento').answer.value"  ⭐ CLAVE

// Datos a reemplazar (si el length del contexto >0)
* note.text.extension.url = $extract-value
* note.text.extension.valueString = "first()" ⭐ CLAVE

* note.time.extension.url = $extract-value
* note.time.extension.valueString = "%resource.authored"
```

#### 3. Incluir Templates como Contained

Los templates deben estar incluidos en el Questionnaire como recursos contained:

```fsh
Instance: Extract
InstanceOf: Questionnaire

// Incluir templates
* contained[+] = ExtractBodyWeightTemplate
* contained[+] = ExtractBodyHeightTemplate
* contained[+] = ExtractConditionTemplate
* contained[+] = ExtractMedicationTemplate

// ... resto del questionnaire
```

#### 4. Contextos de Extracción

Dentro de las expresiones `$extract-value`, hay dos contextos principales:

**Contexto del QuestionnaireResponse (`%resource`):**

```fhirpath
%resource.subject          // Referencia al paciente
%resource.authored         // Fecha de autoría
%resource.author           // Referencia al autor (practitioner)
%resource.encounter        // Referencia al encuentro
```

**Contexto del Item actual:**

Cuando el template está asociado a un item específico, el contexto es ese item. Esto se define con la extension extractTemplate en algún item del Questionnaire. 

```fhirpath
answer.value.value.first()      // Valor de la respuesta
answer.value.unit.first()       // Unidad (para quantity)
answer.value.code.first()       // Código (para choice)
answer.value.system.first()     // Sistema del código
answer.value.display.first()    // Display del código
```

**Contexto de Items por linkId:**

Para extraer valores de items específicos (desde cualquier parte del template):

```fhirpath
item.where(linkId='weight').answer.value.value.first()
item.where(linkId='diagnosis-code').answer.value.code.first()
```

#### 5. Grupos Repetibles (repeats=true)

Cuando un grupo se repite, se crea un recurso por cada repetición. Esta es la forma de generar 1 recurso por item repetido (tiene que repetirse el grupo)

```fsh
// En el Questionnaire
* item[+]
  * type = #group
  * linkId = "allergies"
  * text = "Alergias"
  * repeats = true  // Permite múltiples alergias
  
  // Template de extract (se aplica a cada repetición)
  * extension[+]
    * url = $sdc-questionnaire-templateExtract
    * extension[+]
      * url = "template"
      * valueReference = Reference(ExtractAllergyTemplate)
  
  * item[+]
    * type = #choice
    * linkId = "allergy-substance"
    * text = "Sustancia alergénica"
  
  * item[+]
    * type = #string
    * linkId = "allergy-reaction"
    * text = "Reacción presentada"
```

**Resultado del $extract:**

Si el usuario ingresa 3 alergias, se generarán 3 recursos `AllergyIntolerance` en el Bundle.

#### 6. Template para Condition (Ejemplo Completo)

```fsh
Instance: ExtractConditionTemplate
InstanceOf: ArgCondition
Usage: #inline

///////////////////////////
// Datos fijos
///////////////////////////
* category = $condition-category#encounter-diagnosis "Encounter Diagnosis"
* clinicalStatus = $condition-clinical#active "Active"

///////////////////////////
// Datos a extraer
///////////////////////////

// Referencia al paciente
* subject.extension.url = $extract-value
* subject.extension.valueString = "%resource.subject"

// Referencia al encuentro
* encounter.extension.url = $extract-value
* encounter.extension.valueString = "%resource.encounter"

// Profesional que registra
* recorder.extension.url = $extract-value
* recorder.extension.valueString = "%resource.author"

// Fecha de registro
* recordedDate = "2024-01-01T00:00:00Z"
* recordedDate.extension.url = $extract-value
* recordedDate.extension.valueString = "%resource.authored"

// Código del diagnóstico (desde item con linkId='diagnosis-code')
* code = $sct#38341003 "hipertensión"  // Dummy
* code.coding.code.extension.url = $extract-value
* code.coding.code.extension.valueString = "item.where(linkId='diagnosis-code').answer.value.code.first()"
* code.coding.system.extension.url = $extract-value
* code.coding.system.extension.valueString = "item.where(linkId='diagnosis-code').answer.value.system.first()"
* code.coding.display.extension.url = $extract-value
* code.coding.display.extension.valueString = "item.where(linkId='diagnosis-code').answer.value.display.first()"

// Estado de verificación
* verificationStatus = $condition-ver-status#confirmed "Confirmed"
* verificationStatus.coding.code.extension.url = $extract-value
* verificationStatus.coding.code.extension.valueString = "item.where(linkId='diagnosis-verification').answer.value.code.first()"

// Notas del diagnóstico
* note.text = "Notas del diagnóstico"
* note.text.extension.url = $extract-value
* note.text.extension.valueString = "item.where(linkId='diagnosis-notes').answer.value.first()"

* note.time = "2024-01-01T00:00:00Z"
* note.time.extension.url = $extract-value
* note.time.extension.valueString = "%resource.authored"
```

---

### Variables Globales

Las **variables** permiten definir expresiones FHIRPath reutilizables a nivel del Questionnaire, útiles para cálculos complejos o validaciones cruzadas entre múltiples items. 

#### 1. Declarar Variables

Las variables se declaran a nivel raíz del Questionnaire usando la extensión `$sdc-variable`:

```fsh
Alias: $sdc-variable = http://hl7.org/fhir/StructureDefinition/variable

Instance: MyQuestionnaire
InstanceOf: Questionnaire

// Variable para peso
* extension[+]
  * url = $sdc-variable
  * valueExpression
    * language = #text/fhirpath
    * expression = "%resource.repeat(item).where(linkId='weight').answer.value.value.first()"
    * name = "weightValue"
    * description = "Peso en kilogramos"

// Variable para altura
* extension[+]
  * url = $sdc-variable
  * valueExpression
    * language = #text/fhirpath
    * expression = "%resource.repeat(item).where(linkId='height').answer.value.value.first()"
    * name = "heightValue"
    * description = "Altura en centímetros"

// Variable para fecha actual
* extension[+]
  * url = $sdc-variable
  * valueExpression
    * language = #text/fhirpath
    * expression = "now().toString().split('T').first()"
    * name = "today"
    * description = "Fecha actual en formato ISO 8601"

// Variable para alergias (array)
* extension[+]
  * url = $sdc-variable
  * valueExpression
    * language = #text/fhirpath
    * expression = "%resource.item.where(linkId='medical-history').item.where(linkId='allergies').item.where(linkId = 'allergy-substance').answer.valueCoding.select(code + '|' + system)"
    * name = "allergies"
    * description = "Lista de alergias con formato code|system"
```

#### 2. Usar Variables en Calculated Expression

Una vez declaradas, las variables pueden usarse en `calculatedExpression` para calcular valores automáticamente:

```fsh
// IMC calculado automáticamente desde peso y altura
* item[+]
  * type = #quantity
  * linkId = "bmi"
  * text = "IMC (kg/m²) - calculado automáticamente"
  * readOnly = true
  * extension[+]
    * url = $calculatedExpression
    * valueExpression
      * language = #text/fhirpath
      * expression = "iif(%weightValue.exists() and %heightValue.exists() and %heightValue > 0, (%weightValue / ((%heightValue/100).power(2))).round(1), {})"
      * description = "IMC calculado desde peso y altura"
```

**Explicación de la expresión:**
- `%weightValue.exists()` : Verifica que el peso existe
- `%heightValue.exists() and %heightValue > 0` : Verifica que la altura existe y es mayor que 0
- `(%weightValue / ((%heightValue/100).power(2)))` : Fórmula del IMC (peso / altura²)
- `.round(1)` : Redondea a 1 decimal
- `iif(condición, valor-si-true, valor-si-false)` : Operador condicional
- `{}` : Valor vacío si no cumple la condición

#### 3. Usar Variables en targetConstraint

Las variables son especialmente útiles para validaciones complejas:

```fsh
// Variable para fecha de inicio de menarquía
* extension[+]
  * url = $sdc-variable
  * valueExpression
    * language = #text/fhirpath
    * expression = "%resource.repeat(item).where(linkId='menarche-age').answer.value.first()"
    * name = "menarcheAge"

// Variable para fecha de inicio de menopausia
* extension[+]
  * url = $sdc-variable
  * valueExpression
    * language = #text/fhirpath
    * expression = "%resource.repeat(item).where(linkId='menopause-age').answer.value.first()"
    * name = "menopauseAge"

// Item con validación usando variables
* item[+]
  * type = #integer
  * linkId = "menopause-age"
  * text = "Edad de inicio de menopausia"
  * extension[+]
    * url = $targetConstraint
    * extension[+]
      * url = "expression"
      * valueExpression.language = #text/fhirpath
      * valueExpression.expression = "iif(%context.exists() and %menarcheAge.exists(), %context >= %menarcheAge, true)"
    * extension[+]
      * url = "severity"
      * valueCode = #error
    * extension[+]
      * url = "human"
      * valueString = "La edad de menopausia no puede ser menor a la edad de menarquía"
```

#### 4. Variables Contextuales

Dentro de las expresiones FHIRPath, hay contextos especiales disponibles:

| Variable | Contexto | Descripción |
|----------|----------|-------------|
| `%resource` | QuestionnaireResponse | El QuestionnaireResponse completo |
| `%context` | Valor del item actual | El valor del item donde se evalúa la expresión |
| `%patient` | Patient | Solo en $populate con launchContext |
| `%encounter` | Encounter | Solo en $populate con launchContext |
| `%practitioner` | Practitioner | Solo en $populate con launchContext |
| Variables custom | Definidas por usuario | `%weightValue`, `%heightValue`, `%today`, etc. |

---

### Target Constraints

Las **target constraints** son validaciones personalizadas que se evalúan en tiempo real usando expresiones FHIRPath. Permiten crear reglas de negocio complejas que van más allá de las validaciones básicas (min/max).

#### 1. Estructura Básica

```fsh
Alias: $targetConstraint = http://hl7.org/fhir/StructureDefinition/targetConstraint

* item[+]
  * type = #string
  * linkId = "patient-name"
  * text = "Nombre del paciente (no permite números)"
  
  // Target Constraint
  * extension[+]
    * url = $targetConstraint
    * extension[+]
      * url = "expression"
      * valueExpression.language = #text/fhirpath
      * valueExpression.expression = "EXPRESION_FHIRPATH"
    * extension[+]
      * url = "severity"
      * valueCode = #error   // error | warning | information
    * extension[+]
      * url = "human"
      * valueString = "MENSAJE DE ERROR PARA EL USUARIO"
```

#### 2. Validar Formato de Texto (Regex)

**Ejemplo 1: No permitir números en el nombre**

```fsh
* item[+]
  * type = #string
  * linkId = "full-name"
  * text = "Nombre completo (solo letras)"
  
  * extension[+]
    * url = $targetConstraint
    * extension[+]
      * url = "expression"
      * valueExpression.language = #text/fhirpath
      * valueExpression.expression = "iif(%context.exists() and %context.toString().exists() and %context.toString().length() > 0, %context.toString().matches('.*\\\\p{N}.*').not(), true)"
    * extension[+]
      * url = "severity"
      * valueCode = #error
    * extension[+]
      * url = "human"
      * valueString = "El nombre no puede contener números"
```

**Explicación:**
- `%context` : Valor actual del campo
- `.toString()` : Convertir a string
- `.matches('.*\\\\p{N}.*')` : Expresión regular que verifica si contiene números
- `.not()` : Negar (no debe contener números)
- `iif(condición, valor-true, valor-false)` : Si el campo está vacío, retorna true (válido)

**Ejemplo 2: Validar formato de email**

```fsh
* item[+]
  * type = #string
  * linkId = "email"
  * text = "Correo electrónico"
  
  * extension[+]
    * url = $targetConstraint
    * extension[+]
      * url = "expression"
      * valueExpression.language = #text/fhirpath
      * valueExpression.expression = "iif(%context.exists(), %context.toString().matches('^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\\\.[a-zA-Z]{2,}$'), true)"
    * extension[+]
      * url = "severity"
      * valueCode = #error
    * extension[+]
      * url = "human"
      * valueString = "Formato de email inválido"
```

#### 3. Validaciones Entre Campos

**Ejemplo 1: Fecha de fin mayor que fecha de inicio**

```fsh
// Variable para fecha de inicio
* extension[+]
  * url = $sdc-variable
  * valueExpression
    * language = #text/fhirpath
    * expression = "%resource.repeat(item).where(linkId='leave-start').answer.valueDate.first()"
    * name = "startDate"

// Campo de fecha de fin con validación
* item[+]
  * type = #date
  * linkId = "leave-end"
  * text = "Fecha de fin"
  
  * extension[+]
    * url = $targetConstraint
    * extension[+]
      * url = "expression"
      * valueExpression.language = #text/fhirpath
      * valueExpression.expression = "iif(%context.exists() and %startDate.exists(), %context.toDate() >= %startDate.toDate(), true)"
    * extension[+]
      * url = "severity"
      * valueCode = #error
    * extension[+]
      * url = "human"
      * valueString = "La fecha de fin no puede ser menor a la fecha de inicio"
```

**Ejemplo 2: Edad de menopausia mayor que edad de menarquía**

```fsh
// Variable para menarquía
* extension[+]
  * url = $sdc-variable
  * valueExpression
    * language = #text/fhirpath
    * expression = "%resource.repeat(item).where(linkId='menarche-age').answer.value.first()"
    * name = "menarcheAge"

// Campo menopausia con validación
* item[+]
  * type = #integer
  * linkId = "menopause-age"
  * text = "Edad de inicio de menopausia"
  
  * extension[+]
    * url = $targetConstraint
    * extension[+]
      * url = "expression"
      * valueExpression.language = #text/fhirpath
      * valueExpression.expression = "iif(%context.exists() and %menarcheAge.exists(), %context >= %menarcheAge, true)"
    * extension[+]
      * url = "severity"
      * valueCode = #error
    * extension[+]
      * url = "human"
      * valueString = "La edad de menopausia no puede ser menor a la edad de menarquía"
```

#### 4. Validar Contra Fecha Actual

```fsh
// Variable para fecha actual
* extension[+]
  * url = $sdc-variable
  * valueExpression
    * language = #text/fhirpath
    * expression = "now().toString().split('T').first()"
    * name = "today"

// Campo fecha con validación
* item[+]
  * type = #date
  * linkId = "leave-start"
  * text = "Fecha de inicio (no puede ser anterior a hoy)"
  
  * extension[+]
    * url = $targetConstraint
    * extension[+]
      * url = "expression"
      * valueExpression.language = #text/fhirpath
      * valueExpression.expression = "iif(%context.exists() and %today.exists(), %context.toDate() >= %today.toDate(), true)"
    * extension[+]
      * url = "severity"
      * valueCode = #error
    * extension[+]
      * url = "human"
      * valueString = "La fecha de inicio no puede ser anterior a hoy"
```

#### 5. Evitar Valores Duplicados

**Ejemplo: No permitir alergias duplicadas**

```fsh
// Variable que captura todas las alergias
* extension[+]
  * url = $sdc-variable
  * valueExpression
    * language = #text/fhirpath
    * expression = "%resource.item.where(linkId='medical-history').item.where(linkId='allergies').item.where(linkId = 'allergy-substance').answer.valueCoding.select(code + '|' + system)"
    * name = "allergies"

// Campo con validación de duplicados
* item[+]
  * type = #choice
  * linkId = "allergy-substance"
  * text = "Sustancia alergénica (no permite duplicados)"
  * repeats = false
  
  * extension[+]
    * url = $targetConstraint
    * extension[+]
      * url = "expression"
      * valueExpression.language = #text/fhirpath
      * valueExpression.expression = "%allergies.count() = %allergies.distinct().count()"
    * extension[+]
      * url = "severity"
      * valueCode = #error
    * extension[+]
      * url = "human"
      * valueString = "No se puede ingresar dos veces la misma alergia"
```

**Explicación:**
- `%allergies.count()` : Cantidad total de alergias
- `%allergies.distinct().count()` : Cantidad de alergias únicas
- Si ambos son iguales, no hay duplicados

#### 6. Niveles de Severidad

```fsh
// Error (bloquea el envío del formulario)
* extension[+]
  * url = "severity"
  * valueCode = #error

// Warning (advierte pero permite enviar)
* extension[+]
  * url = "severity"
  * valueCode = #warning
```

---

### Allocate ID

La extensión `extractAllocateId` permite **generar y asignar IDs únicos** a recursos durante el proceso de extract, facilitando referencias entre recursos extraídos del mismo QuestionnaireResponse.

#### 1. ¿Para Qué Sirve?

Cuando se extraen múltiples recursos relacionados (ej: Condition + CarePlan + MedicationRequest), es necesario que se referencien entre sí. `extractAllocateId` genera un **UUID único** que puede usarse en referencias entre recursos extraídos del mismo formulario.

**Casos de uso comunes:**
- Un `CarePlan` que referencia a un `Condition` (diagnóstico)
- Un `MedicationRequest` que referencia a un `Condition` (razón de prescripción)
- Un `Procedure` que referencia a un `Specimen` (muestra recolectada)

#### 2. Alias Requerido

```fsh
Alias: $sdc-questionnaire-extractAllocateId = http://hl7.org/fhir/uv/sdc/StructureDefinition/sdc-questionnaire-extractAllocateId
Alias: $sdc-questionnaire-templateExtract = http://hl7.org/fhir/uv/sdc/StructureDefinition/sdc-questionnaire-templateExtract
Alias: $extract-value = http://hl7.org/fhir/uv/sdc/StructureDefinition/sdc-questionnaire-templateExtractValue
```

#### 3. Sintaxis Básica

```fsh
// Paso 1: Declarar el allocateId en el grupo repetible (o item individual)
* item[+]
  * type = #group
  * linkId = "diagnosticos"
  * text = "Diagnósticos"
  * repeats = true  // Importante: permite múltiples diagnósticos
  
  // Generar un UUID único para cada diagnóstico
  * extension[+]
    * url = $sdc-questionnaire-extractAllocateId
    * valueString = "DiagnosticoId"  // Nombre de la variable UUID
  
  // Asociar template de extract
  * extension[+]
    * url = $sdc-questionnaire-templateExtract
    * extension[+]
      * url = "template"
      * valueReference = Reference(DiagnosticoTemplate)
    * extension[+]
      * url = "fullUrl"
      * valueString = "%DiagnosticoId.reference"  // Usar el UUID generado
  
  * item[+]
    * type = #choice
    * linkId = "diagnostico-item"
    * text = "Selecciona un diagnóstico"
    * answerValueSet = $diagnosticos-valueset
```

**Explicación:**
- `extractAllocateId`: Crea una variable `%DiagnosticoId` con un UUID único
- `fullUrl`: Define la URL completa del recurso en el Bundle usando el UUID
- `%DiagnosticoId.reference`: Genera una referencia tipo `Condition/uuid-generado`

#### 4. Ejemplo Completo: Diagnosis + CarePlan (Recomendaciones)

Este ejemplo muestra cómo un `CarePlan` (recomendaciones) referencia a un `Condition` (diagnóstico) usando el ID asignado.

**Paso 1: Definir Diagnosis con allocateId**
Aca se define la variable que despues usamos en el paso 4.

```fsh
// Sección de diagnósticos (grupo repetible)
* item[+]
  * type = #group
  * linkId = "seccion-diagnostico"
  * text = "Diagnósticos"
  * required = false
  * repeats = true  // Permite múltiples diagnósticos
  
  // Extensión para alocar un UUID para cada diagnóstico
  * extension[+]
    * url = $sdc-questionnaire-extractAllocateId
    * valueString = "DiagnosticoId" ⭐ CLAVE
  
  // Extensión para extraer el template
  * extension[+]
    * url = $sdc-questionnaire-templateExtract
    * extension[+]
      * url = "template"
      * valueReference = Reference(DiagnosticoTemplate)
    * extension[+]
      * url = "fullUrl"
      * valueString = "%DiagnosticoId.reference" ⭐ CLAVE
  
  // Campo para seleccionar el diagnóstico
  * item[+]
    * type = #choice
    * linkId = "item-diagnosticos"
    ------
```

**Paso 2: Definir Questionnaire.item con Recomendaciones que referencian al Diagnosis**
Nada que customizar aqui.

```fsh
// Sección de recomendaciones
* item[+]
  * type = #group
  * linkId = "seccion-recomendaciones"
  * text = "Recomendaciones"
  * required = false
  * repeats = false
  
  // Extensión para extraer el template
  * extension[+]
    * url = $sdc-questionnaire-templateExtract
    * extension[+]
      * url = "template"
      * valueReference = Reference(RecomendacionesTemplate)
  
  * item[+]
    * type = #text
    * linkId = "recomendaciones-text"
    * text = "Ingrese las recomendaciones generales"
```

**Paso 3: Template de Diagnosis (genera el Condition)**
Nada distinto a un template comun

```fsh
Instance: DiagnosticoTemplate
InstanceOf: ArgCondition
Usage: #inline

///////////////////////////
// Datos a extraer (ejemplo)
///////////////////////////
* subject.extension.url = $extract-value
* subject.extension.valueString = "%resource.subject"

* encounter.extension.url = $extract-value
* encounter.extension.valueString = "%resource.encounter"

----
```

**Paso 4: Template de Recomendaciones que referencia al Diagnosis**
Aca usamos la variable que declaramos en el paso 1.

```fsh
Instance: RecomendacionesTemplate
InstanceOf: CarePlan
Usage: #inline


///////////////////////////
// Datos a extraer del cuestionario
///////////////////////////

// Extrae la referencia del paciente
* subject.extension.url = $extract-value
* subject.extension.valueString = "%resource.subject"

// Resto de los campos
...

// Referencia al Condition usando el UUID asignado con allocateId
* addresses.extension.url = $extract-value
* addresses.extension.valueString = "%DiagnosticoId" ⭐ CLAVE

```

**Clave del ejemplo:**
```fsh
// En el template de Recomendaciones
* addresses.extension.url = $extract-value
* addresses.extension.valueString = "%DiagnosticoId"
```

Esto crea una referencia automática al `Condition` extraído usando el UUID generado por `extractAllocateId`.

#### 5. Flujo de Extract con allocateId

```
1. Usuario completa formulario con 2 diagnósticos y 1 recomendación
2. Backend procesa $extract:
   a. Genera UUID1 para primer diagnóstico → %DiagnosticoId = "Condition/uuid1"
   b. Crea Condition/uuid1 (primer diagnóstico)
   c. Genera UUID2 para segundo diagnóstico → %DiagnosticoId = "Condition/uuid2"
   d. Crea Condition/uuid2 (segundo diagnóstico)
   e. Crea CarePlan con addresses = [Reference(Condition/uuid1), Reference(Condition/uuid2)]
3. Retorna Bundle tipo "transaction" con 3 recursos:
   - Entry 1: Condition/uuid1 (method: POST)
   - Entry 2: Condition/uuid2 (method: POST)
   - Entry 3: CarePlan/uuid3 (method: POST, referencia a Condition/uuid1 y uuid2)
```

#### 6. Ventajas de extractAllocateId

| Ventaja | Descripción |
|---------|-------------|
| **Referencias consistentes** | Garantiza que los recursos extraídos se referencien correctamente |
| **UUIDs únicos** | Genera identificadores únicos para cada recurso extraído |
| **Grupos repetibles** | Funciona perfectamente con items que tienen `repeats=true` |
| **Transaccionalidad** | Permite referencias temporales en Bundles tipo `transaction` |
| **Sin dependencias externas** | No requiere IDs pre-existentes en el servidor |

#### 7. Consideraciones Importantes

- **Scope de la variable**: El UUID generado por `extractAllocateId` solo está disponible dentro del mismo QuestionnaireResponse. Podemos declarar la variable para que se use a nivel de todo el Questionnaire o solo a nivel de un item padre. 
- **Grupos repetibles**: Si el grupo tiene `repeats=true`, se genera un UUID diferente para cada repetición
- **fullUrl requerido**: Siempre debe incluirse la subextensión `fullUrl` en el `templateExtract`
- **Referencia cruzada**: Otros templates pueden referenciar el UUID usando `%NombreVariable` en expresiones FHIRPath 

---

## Ejemplos Prácticos

### Ejemplo 1: Questionnaire Simple con Validaciones

```fsh
Instance: SimpleQuestionnaire
InstanceOf: Questionnaire
Usage: #definition

* url = "https://fhir.example.org/Questionnaire/simple"
* status = #active
* title = "Formulario Simple"

// Nombre del paciente (requerido, solo letras)
* item[+]
  * type = #string
  * linkId = "name"
  * text = "Nombre completo"
  * required = true
  * extension[+]
    * url = $targetConstraint
    * extension[+]
      * url = "expression"
      * valueExpression.expression = "%context.toString().matches('.*\\\\p{N}.*').not()"
    * extension[+]
      * url = "severity"
      * valueCode = #error
    * extension[+]
      * url = "human"
      * valueString = "No se permiten números en el nombre"

// Edad (0-125)
* item[+]
  * type = #integer
  * linkId = "age"
  * text = "Edad"
  * required = true
  * extension[+]
    * url = $minValue
    * valueInteger = 0
  * extension[+]
    * url = $maxValue
    * valueInteger = 125

// Peso (1-300 kg)
* item[+]
  * type = #quantity
  * linkId = "weight"
  * text = "Peso (kg)"
  * extension[+]
    * url = $questionnaire-unitOption
    * valueCoding = $ucum#kg
  * extension[+]
    * url = $minValue
    * valueQuantity.value = 1
  * extension[+]
    * url = $maxValue
    * valueQuantity.value = 300
```

### Ejemplo 2: Questionnaire con Populate

```fsh
Instance: PopulateQuestionnaire
InstanceOf: Questionnaire
Usage: #definition

* url = "https://fhir.example.org/Questionnaire/populate-demo"
* status = #active
* title = "Formulario con Populate"

// Launch Context para Patient
* extension[+]
  * extension[+]
    * url = "name"
    * valueCoding = $launchContext#patient "Patient"
  * extension[+]
    * url = "type"
    * valueCode = #Patient
  * url = $sdc-questionnaire-launchContext

// Nombre (pre-llenado desde Patient)
* item[+]
  * type = #string
  * linkId = "patient-name"
  * text = "Nombre del paciente"
  * readOnly = true
  * extension[+]
    * url = $sdc-questionnaire-initialExpression
    * valueExpression.language = #text/fhirpath
    * valueExpression.expression = "%patient.name.first().select(given.first() & ' ' & family).first()"

// Edad calculada
* item[+]
  * type = #integer
  * linkId = "age"
  * text = "Edad"
  * extension[+]
    * url = $sdc-questionnaire-initialExpression
    * valueExpression.language = #text/fhirpath
    * valueExpression.expression = "today().toString().substring(0, 4).toInteger() - %patient.birthDate.toString().substring(0, 4).toInteger()"
```

### Ejemplo 3: Questionnaire con Extract

```fsh
Instance: ExtractQuestionnaire
InstanceOf: Questionnaire
Usage: #definition

* url = "https://fhir.example.org/Questionnaire/extract-demo"
* status = #active
* title = "Formulario con Extract"

// Incluir template como contained
* contained[+] = ExtractWeightTemplate

// Peso con extract
* item[+]
  * type = #quantity
  * linkId = "weight"
  * text = "Peso (kg)"
  * extension[+]
    * url = $questionnaire-unitOption
    * valueCoding = $ucum#kg
  * extension[+]
    * url = $sdc-questionnaire-templateExtract
    * extension[+]
      * url = "template"
      * valueReference = Reference(ExtractWeightTemplate)

// Template
Instance: ExtractWeightTemplate
InstanceOf: ArgObservation
Usage: #inline

* status = #final
* code = $loinc#29463-7 "Body Weight"
* subject.extension.url = $extract-value
* subject.extension.valueString = "%resource.subject"
* effectiveDateTime = "2024-01-01"
* effectiveDateTime.extension.url = $extract-value
* effectiveDateTime.extension.valueString = "%resource.authored"
* valueQuantity.value = 70
* valueQuantity.value.extension.url = $extract-value
* valueQuantity.value.extension.valueString = "answer.value.value.first()"
* valueQuantity.unit = "kg"
* valueQuantity.system = $ucum
* valueQuantity.code = #kg
```

---

## Referencias

### Especificaciones Oficiales

- **[SDC Implementation Guide](https://build.fhir.org/ig/HL7/sdc/)** - Especificación completa de SDC
- **[FHIR R4 Specification](http://hl7.org/fhir/R4/)** - Especificación base de FHIR
- **[FHIRPath Specification](http://hl7.org/fhirpath/)** - Lenguaje de expresiones
- **[SUSHI Documentation](https://fshschool.org/docs/sushi/)** - Documentación de SUSHI

### Herramientas Útiles

- **[FHIRPath Playground](https://hl7.github.io/fhirpath.js/)** - Probar expresiones FHIRPath
- **[Questionnaire Lab](https://dev.fhirpath-lab.com/Questionnaire/tester)** - Creado por Brian Postlethwaite (coautor de SDC)


---