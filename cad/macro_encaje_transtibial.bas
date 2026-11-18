Attribute VB_Name = "Encaje_Transtibial_UAO"
' ============================================================================
'  MACRO DE SOLIDWORKS - ENCAJE TRANSTIBIAL EXTERNO EN PP CON rCB
'  Trabajo de grado UAO 2026 - Bejarano Diaz, Cobo Jimenez, Gaitan, Vargas
'
'  QUE HACE ESTE MACRO (y que NO hace):
'    1. Abre SolidWorks y crea una pieza nueva en milimetros.
'    2. Importa el solido B-rep verificado (cad/Encaje_Transtibial_UAO.step),
'       generado por script con FreeCAD 1.1 y comprobado como cerrado y valido.
'    3. Graba en las propiedades personalizadas TODAS las medidas reales del
'       diseno (boca, altura, pared, brim, placa distal, interfaz piramidal,
'       cargas ISO 10328 y el resultado de la comprobacion analitica propia).
'    4. Guarda la pieza como Encaje_Transtibial_UAO.SLDPRT.
'
'  NO reconstruye el arbol de operaciones desde cero: la geometria de
'  referencia se entrega como B-rep (STEP) porque es la unica forma de
'  garantizar que lo que se abre en SolidWorks coincide exactamente con lo
'  verificado (volumen 307,4 cm3, solido cerrado, 9 caras). El arbol de
'  operaciones parametrico equivalente esta documentado paso a paso en
'  INSTRUCCIONES_SOLIDWORKS.md por si se desea remodelar a mano.
'
'  COMO EJECUTARLO:  SolidWorks > Herramientas > Macro > Ejecutar... y elegir
'  este archivo .bas (o pegarlo en el editor VBA de SolidWorks).
' ============================================================================
Option Explicit

Const RUTA_STEP As String = "C:\Users\USUARIO\Documents\Qoder\2026-11-17\bb852e8a\cad\Encaje_Transtibial_UAO.step"
Const RUTA_SALIDA As String = "C:\Users\USUARIO\Documents\Qoder\2026-11-17\bb852e8a\cad\Encaje_Transtibial_UAO.SLDPRT"

Sub Main()
    Dim swApp As Object
    Dim swModel As Object
    Dim swPart As Object
    Dim errs As Long, warns As Long
    Dim ok As Boolean

    Set swApp = Application.SldWorks
    If swApp Is Nothing Then
        MsgBox "Ejecute este macro desde dentro de SolidWorks.", vbCritical
        Exit Sub
    End If

    ' 1) pieza nueva en milimetros
    Set swModel = swApp.NewPart()
    swApp.SetUserPreferenceIntegerValue swUserPreferenceValue_e.swUnitSystem, 0  ' metric
    swModel.Extension.SetDocumentUnits "MMGS"

    ' 2) importacion del solido verificado
    ok = swModel.Extension.InsertFile(RUTA_STEP, False)
    If Not ok Then
        ' alternativa: abrir directamente el STEP como documento
        Set swModel = swApp.OpenDoc6(RUTA_STEP, swDocPART, swOpenDocOptions_Silent, _
                                     "", errs, warns)
    End If
    If swModel Is Nothing Then
        MsgBox "No se pudo abrir " & RUTA_STEP, vbCritical
        Exit Sub
    End If
    Set swPart = swModel

    ' 3) propiedades personalizadas con las medidas reales del diseno
    Dim cpm As Object
    Set cpm = swModel.Extension.CustomPropertyManager("")
    Call cpm.Add3("Proyecto", swCustomInfoText, "Trabajo de grado UAO 2026 - Pirolisis de NFU y rCB", swCustomPropertyReplace)
    Call cpm.Add3("Componente", swCustomInfoText, "Encaje transtibial externo (no implantable)", swCustomPropertyReplace)
    Call cpm.Add3("Material", swCustomInfoText, "PP + 0/5/10/15 % TTB (negro de humo recuperado, Pyrum)", swCustomPropertyReplace)
    Call cpm.Add3("Boca_ML_mm", swCustomInfoText, "114,9 (con brim reforzado); 112 nominal", swCustomPropertyReplace)
    Call cpm.Add3("Boca_AP_mm", swCustomInfoText, "95,0 (con barra patelar); 96 nominal", swCustomPropertyReplace)
    Call cpm.Add3("ML_distal_mm", swCustomInfoText, "64", swCustomPropertyReplace)
    Call cpm.Add3("AP_distal_mm", swCustomInfoText, "58", swCustomPropertyReplace)
    Call cpm.Add3("Altura_util_mm", swCustomInfoText, "180", swCustomPropertyReplace)
    Call cpm.Add3("Pared_nominal_mm", swCustomInfoText, "5 (rango de diseno 4-6)", swCustomPropertyReplace)
    Call cpm.Add3("Pared_medida_mm", swCustomInfoText, "5,0 a 8,4 (brim reforzado a 8 en 20 mm)", swCustomPropertyReplace)
    Call cpm.Add3("Brim_reforzado_mm", swCustomInfoText, "8", swCustomPropertyReplace)
    Call cpm.Add3("Placa_distal_mm", swCustomInfoText, "12 (maciza)", swCustomPropertyReplace)
    Call cpm.Add3("Barra_patelar_mm", swCustomInfoText, "indentacion anterior 8 a 45 mm del borde", swCustomPropertyReplace)
    Call cpm.Add3("Flexion_grados", swCustomInfoText, "5", swCustomPropertyReplace)
    Call cpm.Add3("Interfaz_piramidal_mm", swCustomInfoText, "30 x 30 x 12, 4 x M6 a 22 mm entre ejes", swCustomPropertyReplace)
    Call cpm.Add3("Volumen_cm3", swCustomInfoText, "307,4", swCustomPropertyReplace)
    Call cpm.Add3("Masa_g_PP_10TTB", swCustomInfoText, "293", swCustomPropertyReplace)
    Call cpm.Add3("Carga_ISO10328_P6_N", swCustomInfoText, "1500", swCustomPropertyReplace)
    Call cpm.Add3("Sigma_max_MPa", swCustomInfoText, "2,94 (comprobacion analitica propia, e = 25 mm)", swCustomPropertyReplace)
    Call cpm.Add3("Factor_seguridad", swCustomInfoText, "9,5 a 11,2 (exigido >= 2,0)", swCustomPropertyReplace)
    Call cpm.Add3("Origen_geometria", swCustomInfoText, "B-rep generado por script (FreeCAD 1.1); modelo de referencia, NO clinico", swCustomPropertyReplace)
    Call cpm.Add3("Origen_datos_material", swCustomInfoText, "Declaracion del productor Pyrum Innovations AG (indicativo, no garantizado)", swCustomPropertyReplace)

    ' 4) guardado
    swModel.SaveAs3 RUTA_SALIDA, 0, 0
    MsgBox "Pieza creada y guardada:" & vbCrLf & RUTA_SALIDA & vbCrLf & vbCrLf & _
           "Medidas reales cargadas en propiedades personalizadas." & vbCrLf & _
           "Consulte INSTRUCCIONES_SOLIDWORKS.md para el arbol parametrico.", vbInformation
End Sub
