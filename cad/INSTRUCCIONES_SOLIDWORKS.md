# Guía SolidWorks — Encaje transtibial externo en PP con rCB

Trabajo de grado UAO 2026 · Bejarano Díaz, Cobo Jiménez, Gaitán Guerrero, Vargas
Dirección: M. L. Palacios Peñaranda · Facultad de Ciencias Básicas, Ingeniería Ambiental

## 1. Qué se entrega y cómo se abre en SolidWorks

| Archivo | Qué es | Cómo se abre en SolidWorks |
|---|---|---|
| `Encaje_Transtibial_UAO.step` | Sólido B-rep verificado (AP214, cerrado, válido, 9 caras, 307,4 cm³) | Archivo → Abrir → tipo STEP. Entra como **cuerpo sólido** editable. |
| `Ensamble_Protesis_Transtibial.step` | Encaje + interfaz piramidal + pilón tubular, posicionados | Archivo → Abrir → STEP. Entra como ensamblaje de 3 cuerpos. |
| `Encaje_Transtibial_UAO.SLDPRT` | Pieza nativa generada por el macro | Doble clic. |
| `macro_encaje_transtibial.bas` | Macro VBA: crea la pieza en mm, importa el STEP y graba todas las medidas reales en propiedades personalizadas | Herramientas → Macro → Ejecutar. |
| `Plano_Encaje_Transtibial_UAO.dxf` | Contornos reales por capas (FRONTAL, LATERAL, SECCION_AA, DETALLE_B, COTAS) | Insertar → Objeto DXF/DWG como boceto 2D. |
| `Plano_Encaje_Transtibial_UAO.pdf` / `.svg` | Plano A3 acotado (1:1 y 1:2) con notas y cajetín | Referencia de fabricación. |
| `Encaje_Transtibial_UAO.FCStd` | Modelo paramétrico editable (FreeCAD 1.1) con el árbol: 19 perfiles → Loft exterior → Loft cavidad → Cut → 4 taladros | FreeCAD; útil para modificar parámetros y re-exportar STEP. |
| `Encaje_Transtibial_UAO.stl` | Malla cerrada (23.152 triángulos, manifold χ=2) para visualización e impresión 3D | Archivo → Abrir → STL. |

La geometría de referencia se entrega como B-rep porque es la única forma de garantizar
que lo que se abre en SolidWorks coincide exactamente con lo verificado numéricamente
(volumen, centro de gravedad, inercias y secciones). El macro no inventa operaciones:
importa ese sólido y documenta las medidas.

## 2. Medidas reales del diseño (todas en mm)

Convención de ejes: **X** mediolateral (positivo lateral), **Y** anteroposterior
(negativo = anterior), **Z** axial (0 en el borde proximal de referencia, negativo distal).

| Parámetro | Valor | Origen |
|---|---|---|
| Ancho ML en la boca (con brim) | 114,9 (nominal 112) | Medido sobre el sólido / antropometría de referencia |
| Ancho AP en la boca (con barra patelar) | 95,0 (nominal 96) | Medido sobre el sólido |
| ML distal / AP distal | 64 / 58 | Antropometría de referencia para muñón transtibial medio |
| Profundidad útil H | 180 | Rango clínico habitual 150–200 |
| Pared nominal | 5 (rango de diseño 4–6) | Especificación del trabajo de grado |
| Pared medida sobre el sólido | 5,0 a 8,4 | Medición propia por secciones (z = −5 a −165) |
| Brim reforzado | 8 en los primeros 20 mm | Práctica habitual de encajes PTB |
| Placa distal maciza | 12 | Alojamiento de la interfaz piramidal |
| Barra patelar | indentación anterior de 8 a 45 mm del borde | Geometría PTB estándar |
| Flexión inicial | 5° | Alineación típica de encaje transtibial |
| Interfaz piramidal | 30 × 30 × 12, 4 × M6 a 22 mm entre ejes | Componente comercial normalizado |
| Pilón | tubo Ø30 × 1,5, L = 250 | Componente comercial normalizado |
| Altura total del ensamblado sin pie | 442 | Suma de componentes modelados |

Propiedades verificadas leyendo el STEP exportado: volumen de material 307,4 cm³,
superficie 1.009 cm², centro de gravedad (0,0; 7,5; −75,5) mm, masa estimada
278 g (PP virgen) a 301 g (PP + 15 % TTB) con las densidades del modelo Halpin–Tsai
del trabajo de grado.

## 3. Árbol de operaciones paramétrico equivalente (para remodelar a mano)

1. **Planos de referencia**: Frontal (XZ), Lateral (YZ), Superior (XY en z = 0).
2. **19 bocetos de sección** en planos paralelos al Superior, en z = +9, +6, +3, 0,
   −12, −24, …, −180. Cada boceto es una superelipse
   |x/a|^n + |y/b|^n = 1 con los semiejes de la tabla siguiente y el desplazamiento
   y = −z·tan 5°. La indentación de la barra patelar se aplica restando
   8·exp(−(z−45)²/(2·22²)) al semieje anterior, ponderada angularmente.
3. **Loft exterior** (sólido, no reglado) por los 19 bocetos, con ensanche del brim
   +0,8 mm en z = +6 y +1,4 mm en z = +3.
4. **15 bocetos interiores** (z = +9 a −168) con semiejes reducidos en
   t(z) = 8 mm para z ≥ −20, transición lineal a 5 mm en z = −60.
5. **Loft interior** (sólido) y **Cut** → pared con brim reforzado y placa distal de 12 mm.
6. **4 taladros** Ø6,5 pasantes en la placa distal, patrón de 22 mm entre ejes
   (boceto circular + Cut).
7. **Redondeos opcionales** R2 en la arista exterior del brim si el proceso lo permite.
8. **Configuraciones de material**: crear 4 configuraciones (0/5/10/15 % TTB) con
   ρ = 0,905 / 0,928 / 0,952 / 0,978 g/cm³ y E = 1.350 / 1.427 / 1.511 / 1.604 MPa
   (modelo Halpin–Tsai del capítulo 7 del trabajo de grado).

| z (mm) | a ext (ML/2) | b ext (AP/2) | n | t(z) interior |
|---|---|---|---|---|
| +9 | 56,0 | 48,0 | 2,60 | 8,0 |
| 0 | 56,0 | 48,0 | 2,60 | 8,0 |
| −12 | 53,1 | 45,5 | 2,63 | 8,0 |
| −24 | 50,2 | 43,0 | 2,66 | 7,7 |
| −36 | 47,4 | 40,4 | 2,68 | 6,8 |
| −48 | 44,5 | 37,9 | 2,71 | 5,9 |
| −60 | 41,6 | 35,4 | 2,74 | 5,0 |
| −90 | 34,4 | 29,2 | 2,80 | 5,0 |
| −120 | 27,2 | 23,0 | 2,87 | 5,0 |
| −150 | 20,0 | 16,8 | 2,93 | 5,0 |
| −168 | 15,7 | 13,2 | 2,97 | 5,0 |
| −180 | 32,0 | 29,0 | 3,00 | macizo |

(Los valores intermedios se interpolan linealmente; la tabla completa de 19 niveles
está en `perfiles.json` y `medidas.json`.)

## 4. Verificación estructural (comprobación analítica propia)

Con las cargas de ensayo de ISO 10328:2016 citadas en el trabajo de grado
(P5 = 1.200 N y P6 = 1.500 N) y una excentricidad conservadora de e = 25 mm entre la
línea de carga y el centroide de la sección de media altura (z = −90 mm,
A = 1.231 mm², Ixx = 810.278 mm⁴, Iyy = 1.000.285 mm⁴, c = 37,1 mm):

| Nivel | σ axial (MPa) | σ flexión AP (MPa) | σ máx (MPa) | FS con PP + 10 % TTB (σy = 29 MPa) |
|---|---|---|---|---|
| P5 | 0,98 | 1,38 | 2,36 | 12,3 |
| P6 | 1,22 | 1,72 | 2,94 | 9,9 |

El margen estático es amplio (FS ≥ 2,0 exigido), por lo que el dimensionamiento lo
gobiernan el **creep** del PP y la **fatiga cíclica**, no la rotura estática. Esto es una
estimación analítica de primer orden reproducible con `propiedades.json`; **no sustituye
el ensayo estructural normalizado ni un análisis por elementos finitos**, y no se
presenta como resultado experimental.

## 5. Trazabilidad y advertencias

- Geometría generada por script (FreeCAD 1.1) a partir de medidas antropométricas y
  normativas publicadas: es un **modelo de referencia académico, no un encaje prescrito
  para un paciente real** y no es apto para uso clínico.
- Propiedades del material según la declaración del productor (Pyrum Innovations AG):
  BET 65–85 m²/g y STSA 50–70 m²/g, valores **indicativos y no garantizados**; los
  módulos y densidades provienen del modelo micromecánico Halpin–Tsai del capítulo 7
  (escenario teórico, no medición).
- No se realizaron ensayos con muestras del material: ni solicitud de muestra ni
  campaña experimental formaron parte del proyecto (constancia en el Anexo B del
  trabajo de grado).
