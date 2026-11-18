# Integración del modelo CAD con el sitio web PASO CIRCULAR

Documento breve de trazabilidad técnica. Fecha: 2026-11-17. Autor: elaboración propia del proyecto
«De la llanta usada al paso recuperado» (Ingeniería Ambiental e Ingeniería Multimedia, UAO).

## 1. Cadena completa del modelo

1. **Geometría fuente (B-rep).** El encaje transtibial externo se modeló por script en FreeCAD 1.1
   (`cad/`): secciones superelípticas (n = 2,6 en boca, n = 2,2 en distal), barra patelar, placa
   distal, interfaz piramidal y pilón tubular. El sólido es válido y cerrado; sus magnitudes se
   midieron con `cad_props.py` (caja 114,9 × 97,9 × 189,0 mm; volumen 307,4 cm³; pared 5,0–8,4 mm).
2. **Formatos de intercambio.** Desde ese B-rep se exportaron `Encaje_Transtibial_UAO.step`
   (AP214), `.iges`, `.stl` y `.FCStd`, además del ensamblaje `Ensamble_Protesis_Transtibial.step`
   y el plano A3 (SVG/PDF/DXF).
3. **glTF binario para web.** `glb_export.py` (ejecutado con `freecadcmd`) tesela el **mismo**
   B-rep con tolerancia 0,15 mm (29.774 triángulos), promedia normales por vértice y escribe
   `cad/Encaje_Transtibial_UAO.glb` a mano: cabecera `glTF` v2, chunk JSON con tres nodos y mallas
   nombradas (`Encaje_PP_rCB`, `Interfaz_piramidal`, `Pilon_tubular`) y materiales PBR, y chunk BIN
   con posiciones, normales e índices uint32. No se usó ninguna geometría aproximada distinta del
   sólido verificado.
4. **Incrustación para `file://`.** Como `GLTFLoader.load()` usa `fetch` y el protocolo `file://`
   lo bloquea por CORS, el GLB se codificó en base64 dentro de `cad/modelo_glb.js`
   (`const GLB_B64 = "..."`). El visor lo decodifica a `ArrayBuffer` y lo entrega a
   `GLTFLoader.parse(buffer, '', onLoad, onError)`.
5. **Visor.** Three.js r147 en distribución UMD (`web/lib/three.min.js`, `OrbitControls.js`,
   `GLTFLoader.js`, `RoomEnvironment.js`) para funcionar sin módulos ES ni servidor. Escena con
   `PMREMGenerator` + `RoomEnvironment`, luz direccional con `PCFSoftShadowMap` y plano receptor de
   sombra, `OrbitControls` con amortiguación, y controles de vistas predefinidas, despiece animado,
   plano de corte (`THREE.Plane` en espacio de mundo), modo aristas, giro automático, cuatro puntos
   de interés proyectados por fotograma y selector de material que actualiza color y masa
   (278/285/293/301 g para 0/5/10/15 % en peso de TTB).

## 2. Paso por SolidWorks

- Instalación del equipo: SOLIDWORKS Design Premium for Students 2026 SP5.2 (`D:\SOLIDWORKS\SLDWORKS.exe`).
- La edición para estudiantes restringe la API COM: `OpenDoc6` devolvió el error 2097152 y
  `NewPart` falló con DISP_E_MEMBERNOTFOUND (−2147352573); `makepy`/`EnsureDispatch` y las llamadas
  desde PowerShell también fallaron (TYPE_E_ELEMENTNOTFOUND 0x8002802B). Por ello **no fue posible
  guardar el .SLDPRT de forma automática**.
- Alternativa verificable: el STEP se abrió en la interfaz gráfica de SolidWorks por línea de
  comandos y la pieza quedó cargada como `Encaje_Transtibial_UAO.SLDPRT` con el sólido importado en
  el árbol de características; se obtuvieron capturas reales de pantalla
  (`web/img/sw_vista_lateral.png`, `web/img/sw_importacion_dialogo.png`).
- El guardado nativo queda a una acción del usuario (Archivo > Guardar como) o mediante
  `cad/SOLIDWORKS/macro_encaje_transtibial.bas`; el procedimiento está en
  `cad/SOLIDWORKS/INSTRUCCIONES_SOLIDWORKS.md`. Los registros de ejecución y errores quedaron en
  `cad/SOLIDWORKS/registro_ejecucion.txt` y `registro_gui.txt`.

## 3. Verificación realizada

- En navegador: las cuatro librerías cargan, el GLB se analiza sin errores, el panel reporta
  29.774 triángulos, masa 293 g con 10 % en peso, y los cuatro puntos de interés se proyectan.
- Capturas reales de la página terminada con Edge sin interfaz mediante páginas de encuadre
  `web/_cap_*.html` (marco interno del mismo origen que desplaza la sección deseada):
  `web/img/captura_web_inicio.png`, `..._modelo.png`, `..._resultados.png`, `..._materiales.png`,
  `..._investigacion.png`.
- Coherencia de valores entre documento, CAD y web: ver Tabla 17 del documento definitivo
  (sección 7.11).

## 4. Regeneración

```
freecadcmd glb_export.py            # B-rep -> cad/Encaje_Transtibial_UAO.glb
python -c "import base64,pathlib; pathlib.Path('web/cad/modelo_glb.js').write_text('const GLB_B64=\"'+base64.b64encode(pathlib.Path('web/cad/Encaje_Transtibial_UAO.glb').read_bytes()).decode()+'\";',encoding='utf-8')"
python gen_capturas.py              # páginas de encuadre para capturas de secciones
```

Abrir `web/index.html` en cualquier navegador moderno: no requiere servidor ni conexión.
