#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.2
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

#include <FileConstants.au3>
#include <GUIConstantsEx.au3>
#include <File.au3>
#RequireAdmin

Local $strAutoDir = FileSelectFolder ("Chon thu muc auto", "C:\Users\htra\Downloads")
Local $ui = GUICreate("NKVS", 150, 45)
Local $bt = GUICtrlCreateButton("Start", 70, 10, 60)
Local $strSettings = @WorkingDir & "\settings.txt"
GUISetState(@SW_SHOW, $ui)
InitSettings()
Local $strExit = @WorkingDir & "\exit"

While True
   Switch GUIGetMsg()
   Case $GUI_EVENT_CLOSE
	  ExitLoop
   Case $bt
	  Local $strCurrent = GUICtrlRead($bt)
	  If $strCurrent == "Start" Then
		 GUICtrlSetData($bt, "Stop")
		 FileDelete($strExit)
		 Run(@WorkingDir & "\main.exe " & $strAutoDir & " " & $strSettings)
	  Else
		 GUICtrlSetData($bt, "Start")
		 _FileCreate($strExit)
	  EndIf
   EndSwitch
WEnd

Func InitSettings()
   If Not FileExists($strSettings) Then
	  _FileCreate($strSettings)
	  FileWriteLine($strSettings, "BiCanh 2 5")
	  FileWriteLine($strSettings, "NTD 2 5")
	  FileWriteLine($strSettings, "DoVui 1 5")
   EndIf
EndFunc


