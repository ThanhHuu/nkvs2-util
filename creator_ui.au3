#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.2
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------
#include <Array.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <GuiListView.au3>
#include <File.au3>

; Script Start - Add your code below here
Local $arrHwnd = WinList("[REGEXPTITLE:(Ngạo Kiếm Vô Song II )(Số phiên bản:|Version).*]")
Local $idUI = GUICreate("Select hwnd", 300, 200);
Local $idListview = GUICtrlCreateListView("Window Title", 10, 10, 280, 150)
Local $idButton = GUICtrlCreateButton("Start", 240, 170, 50, 20)
For $i = 1 To $arrHwnd[0][0]
   Local $sTitle = $arrHwnd[$i][0]
   _GUICtrlListView_AddItem($idListview, $sTitle)
Next
GUISetState(@SW_SHOW)
While 1
   Switch GUIGetMsg()
	  Case $GUI_EVENT_CLOSE
		 ExitLoop
	  Case $idButton
		 Local $arrSelected = _GUICtrlListView_GetSelectedIndices($idListview, true)
		 For $i = 1 To $arrSelected[0]
			Local $sTitle = _GUICtrlListView_GetItemText($idListview, $arrSelected[$i])
			Local $strAutoDir = FileSelectFolder ("Chon thu nhan vat", "C:\Users\htra\Downloads")
			Run(@WorkingDir & "\creator " & $strAutoDir & " " & $sTitle)
		 Next
		 ExitLoop
   EndSwitch
WEnd