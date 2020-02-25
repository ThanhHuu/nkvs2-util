#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.2
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------
#include <Array.au3>
#include <GUIConstantsEx.au3>
#include <GuiListView.au3>
#include <WindowsConstants.au3>
#RequireAdmin
; Script Start - Add your code below here

Local $ui = GUICreate("Anonymous", 260, 150)
Local $listAcc = GUICtrlCreateListView("Name|Show", 10, 10, 240, 100, BitOR($LVS_REPORT,$LVS_SHOWSELALWAYS), BitOR($WS_EX_CLIENTEDGE,$LVS_EX_FULLROWSELECT))
_GUICtrlListView_SetColumnWidth($listAcc, 0, 160)
_GUICtrlListView_SetColumnWidth($listAcc, 1, 50)
Local $sTitleReg = "[REGEXPTITLE:(Ngạo Kiếm Vô Song II)\(.*]"
Local $arrWins = WinList($sTitleReg)
For $i = 1 To $arrWins[0][0]
   Local $strTitle = $arrWins[$i][0]
   Local $strName = StringSplit(StringTrimLeft($strTitle, 21), " ")[1]
   Local $strShow = BitAND(WinGetState($arrWins[$i][1]), 2) ? "" : "X"
   GUICtrlCreateListViewItem($strName & "|" & $strShow, $listAcc)
Next
Local $bt = GUICtrlCreateButton("Change", 190, 120, 60, 20)

GUISetState(@SW_SHOW, $ui)
While True
   Switch GUIGetMsg()
   Case $GUI_EVENT_CLOSE
	  ExitLoop
   Case $bt
	  Local $arrSelected = _GUICtrlListView_GetSelectedIndices($listAcc, True)
	  For $i = 1 To $arrSelected[0]
		 Local $strName = _GUICtrlListView_GetItemText($listAcc, $arrSelected[$i], 0)
		 Local $strShow = ReverseWindowState($strName)
		 _GUICtrlListView_SetItemText($listAcc, $arrSelected[$i], $strShow, 1)
	  Next
   EndSwitch
WEnd

Func ReverseWindowState($strName)
   Local $sTitleReg = "[REGEXPTITLE:(Ngạo Kiếm Vô Song II)\((" & $strName & ").*]"
   Local $hwnd = WinGetHandle($sTitleReg)
   If Not WinExists($hwnd) Then
	  MsgBox(0,"", "Not found " & $strName)
   EndIf
   If BitAND(WinGetState($hwnd), 2) Then
	  WinSetState($hwnd, "", @SW_HIDE)
	  Return "X"
   Else
	  WinSetState($hwnd, "", @SW_SHOW)
	  Return ""
   EndIf
EndFunc