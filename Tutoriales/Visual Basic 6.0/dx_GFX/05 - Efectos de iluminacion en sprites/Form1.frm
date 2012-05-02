VERSION 5.00
Begin VB.Form Form1 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "dx_GFX - Efectos de iluminacion en sprites"
   ClientHeight    =   3060
   ClientLeft      =   45
   ClientTop       =   345
   ClientWidth     =   4560
   Icon            =   "Form1.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   3060
   ScaleWidth      =   4560
   StartUpPosition =   3  'Windows Default
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Graphics As dx_GFX_Class ' Instancia del objeto grafico de dx_lib32.
Private Render As Boolean ' Controla el bucle de renderizado.
Private Texture As Long ' Identificador de la textura.

Private Sub Form_Load()
    Me.Show ' Forzamos al formulario a mostrarse.
    Set Graphics = New dx_GFX_Class ' Creamos la instancia del objeto grafico.
    Render = Graphics.Init(Me.hWnd, 640, 480, 32, True) ' Inicializamos el objeto grafico y el modo de video.
    Texture = Graphics.MAP_Load(App.Path & "\texture.png", 0) ' Cargamos la textura para el sprite.
    
    Do While Render
        ' Definir el color de cada vertice del sprite:
        Graphics.DEVICE_SetVertexColor &HFFFFFFFF, &HFFFF0000, &HFF00FF00, &HFF0000FF
        Graphics.DRAW_Map Texture, 0, 0, 0, 200, 200
        
        ' Definir el tono de iluminacion de cada vertice:
        Graphics.DEVICE_SetSpecularChannel &HFFFFFFFF, &HFFFF0000, &HFF00FF00, &HFF0000FF
        Graphics.DRAW_MapEx Texture, Graphics.Screen.Width \ 2, Graphics.Screen.Height \ 2, 0, 200, 200, 0, Blendop_Color, &HFFFFFFFF, Mirror_None, Filter_Bilinear, True
        
        ' Combinar ambas tecnicas:
        Graphics.DEVICE_SetVertexColor &HFFFFFFFF, &HFFFF0000, &HFF00FF00, &HFF0000FF
        Graphics.DEVICE_SetSpecularChannel &HFFFFFFFF, 0, 0, &HFFFF0000
        Graphics.DRAW_Map Texture, Graphics.Screen.Width - 200, Graphics.Screen.Height - 200, 0, 200, 200
        
        Graphics.Frame ' Renderizamos la escena.
    Loop
End Sub

Private Sub Form_Unload(Cancel As Integer)
    Graphics.MAP_Unload Texture ' Descargamos la textura de memoria.
    Render = False ' Termina el bucle de renderizado.
    Graphics.Terminate ' Terminamos la ejecucion de la clase grafica y liberamos los recursos utilizados.
    Set Graphics = Nothing ' Destruimos la instancia del objeto grafico.
End Sub
