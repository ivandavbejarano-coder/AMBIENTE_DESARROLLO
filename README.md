# PASO CIRCULAR — De la llanta usada al paso recuperado

Sitio web estático del trabajo de grado
*«Aprovechamiento de negro de humo recuperado por pirólisis de llantas usadas para el desarrollo
de prótesis biomédicas con apoyo de ingeniería multimedia. Caso de estudio: Pyrum Innovations AG»*
(Universidad Autónoma de Occidente, Programa de Ingeniería Ambiental e Ingeniería Multimedia, 2026).

El sitio presenta la investigación y un **visor 3D interactivo del encaje transtibial externo**
modelado en CAD, renderizado con Three.js directamente en el navegador.

## Cómo verlo

No requiere servidor, instalación ni conexión a internet: abra `index.html` en cualquier navegador
moderno (Chrome, Edge, Firefox). Todo el código, las librerías, el modelo 3D y los datos están en
esta carpeta.

## Contenido

| Ruta | Descripción |
| --- | --- |
| `index.html` | Página completa (inicio, problema, investigación, materiales, modelo 3D, resultados, documentación) |
| `datos.js` | Datos verificados del proyecto (geometría, masas, Halpin–Tsai, escenarios de ACV) |
| `lib/` | Three.js r147 UMD: núcleo, OrbitControls, GLTFLoader, RoomEnvironment |
| `cad/` | Modelo CAD del encaje: STEP, IGES, STL, FCStd, GLB y `modelo_glb.js` (GLB en base64 para `file://`) |
| `cad/SOLIDWORKS/` | Macro VBA e instrucciones para reconstruir la pieza en SolidWorks |
| `img/` | Figuras del documento, capturas reales de SolidWorks y capturas reales del sitio |
| `descargas/` | Documento definitivo (DOCX y PDF), matriz de trazabilidad (XLSX) |
| `INTEGRACION_CAD_WEB.md` | Trazabilidad técnica de la cadena CAD → GLB → visor web |
| `_cap_*.html` | Páginas auxiliares de encuadre usadas para generar las capturas de secciones |

## El modelo 3D

El sólido B-rep del encaje (secciones superelípticas, barra patelar, placa distal, interfaz
piramidal y pilón) se teseló desde FreeCAD y se escribió como glTF binario (`cad/Encaje_Transtibial_UAO.glb`,
29.774 triángulos, tres nodos nombrados). El visor lo incrusta en base64 para funcionar bajo
`file://` y ofrece rotación libre, zoom, cuatro vistas, despiece animado, plano de corte, modo de
aristas, puntos de interés anotados y selector de material (PP con 0, 5, 10 y 15 % en peso de
ThermoTireBlack; 278 a 301 g).

## Publicar con GitHub Desktop

1. GitHub Desktop → **File → Add Local Repository…** y seleccione esta carpeta.
2. **Publish repository…**: elija nombre (p. ej. `paso-circular`) y visibilidad.
3. Para obtener un enlace público: en github.com, **Settings → Pages → Source: Deploy from a
   branch → main / (root)**. El sitio quedará en `https://<usuario>.github.io/<repo>/`.

El sitio funciona igual publicado o abierto en local, porque no usa módulos ES ni recursos remotos.

## Nota científica

Cada cifra del sitio indica su procedencia (dato real del proyecto, dato de Pyrum, bibliográfico o
escenario teórico). Los resultados de ACV corresponden al modelo de 2022 y **no se extrapolan a
Colombia**. No se realizaron ensayos de laboratorio ni validación clínica: el modelo CAD es una
**propuesta de diseño de ingeniería, no un dispositivo médico validado**.
