#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.2
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------
#include <FileConstants.au3>
#include <GUIConstantsEx.au3>
#include <File.au3>
#include <GuiListView.au3>
#include <Array.au3>
#include <GuiButton.au3>
#include <GuiTab.au3>
#include <GuiListBox.au3>
#include <GuiComboBox.au3>
#include <GuiComboBoxEx.au3>
#include "AutoNkvs2.au3"
#include <DateTimeConstants.au3>

#RequireAdmin
; Script Start - Add your code below here

Local $hwndAuto = WinGetHandle("[REGEXPTITLE:(Auto Ngạo Kiếm Vô Song 2).*]")
If Not WinExists($hwndAuto) Then
   _FileWriteLog("log\replace.log", "Prevent when not open auto yet")
   Exit
EndIf
Local $ui = GUICreate("Replace", 560, 300)
Local $ctrlInAccounts = GUICtrlCreateInput("", 10, 10, 200, 20)
Local $ctrlBtBrowse = GUICtrlCreateButton("Browse", 220, 9, 60, 22)
Local $ctrlCbFeature = GUICtrlCreateCombo("", 290, 10, 100, 20)
_GUICtrlComboBox_InsertString($ctrlCbFeature, "Bí Cảnh")
_GUICtrlComboBox_InsertString($ctrlCbFeature, "N.Trúc Đàm")
_GUICtrlComboBox_InsertString($ctrlCbFeature, "Điều Đội")
_GUICtrlComboBox_InsertString($ctrlCbFeature, "Truy Nã")
_GUICtrlComboBox_SetCurSel($ctrlCbFeature, 0)
Local $ctrlCbTime = GUICtrlCreateCombo("", 400, 10, 50, 20)
_GUICtrlComboBox_InsertString($ctrlCbTime, 1)
_GUICtrlComboBox_InsertString($ctrlCbTime, 2)
_GUICtrlComboBox_SetCurSel($ctrlCbTime, 0)
Local $ctrlBtAdd = GUICtrlCreateButton("Add", 460, 9, 40, 22)

Local $ctrlListAcc = GUICtrlCreateListView("Account File | Feature | Time", 10, 40, 490, 150)
_GUICtrlListView_SetColumnWidth($ctrlListAcc, 0, 305)
_GUICtrlListView_SetColumnWidth($ctrlListAcc, 1, 120)
_GUICtrlListView_SetColumnWidth($ctrlListAcc, 3, 50)

Local $ctrlBtUp = GUICtrlCreateButton("Up", 505, 40, 50, 20)
Local $ctrlBtDown = GUICtrlCreateButton("Down", 505, 70, 50, 20)
Local $ctrlbtMerge = GUICtrlCreateButton("Merge", 505, 100, 50, 20)
Local $ctrlBtRemove = GUICtrlCreateButton("Remove", 505, 130, 50, 20)

GUICtrlCreateLabel("Start From", 10, 203, 60, 20)
Local $ctrlCbIndex = GUICtrlCreateCombo("", 70, 200, 40, 20)
Local $iTotalIndex = _GUICtrlListView_GetItemCount($CTRL_LIST_NAME)
For $i = 0 To $iTotalIndex - 1
   _GUICtrlComboBox_InsertString($ctrlCbIndex, $i)
Next
_GUICtrlComboBox_SetCurSel($ctrlCbIndex, 6)

GUICtrlCreateLabel("On", 180, 203, 40, 20)
Local $ctrlDate = GUICtrlCreateDate("", 200, 200, 100, 20, $DTS_SHORTDATEFORMAT)
Local $ctrlTime = GUICtrlCreateDate("", 320, 200, 100, 20, $DTS_TIMEFORMAT)

Local $ctrlBtStart = GUICtrlCreateButton("Start", 450, 200, 50, 20)

GUISetState(@SW_SHOW, $ui)
RunWait(@AutoItExe & " " & @WorkingDir & "\Locker.au3 UnLock")
While True
   Switch GUIGetMsg()
   Case $GUI_EVENT_CLOSE
	  ExitLoop
   Case $ctrlBtBrowse
	  Local $strFiles = FileOpenDialog("Chon file", @WorkingDir, "Text files (*.txt)", 4)
	  _GUICtrlEdit_SetText($ctrlInAccounts, $strFiles)
   Case $ctrlBtAdd
	  Local $strFiles = _GUICtrlEdit_GetText($ctrlInAccounts)
	  If $strFiles == "" Then
		 ContinueCase
	  EndIf
	  Local $strFeature = _GUICtrlComboBoxEx_GetItem($ctrlCbFeature, _GUICtrlComboBox_GetCurSel($ctrlCbFeature))[0]
	  Local $iTimes = _GUICtrlComboBoxEx_GetItem($ctrlCbTime, _GUICtrlComboBox_GetCurSel($ctrlCbTime))[0]
	  Local $arrFile = StringSplit($strFiles, '|')
	  If $arrFile[0] > 2 Then
		 Local $strFolder = $arrFile[1]
		 For $i = 2 To $arrFile[0]
			Local $strItem = StringFormat("%s|%s|%i", $strFolder & '\' & $arrFile[$i], $strFeature, $iTimes)
			GUICtrlCreateListViewItem($strItem, $ctrlListAcc)
		 Next
	  Else
		 Local $strItem = StringFormat("%s|%s|%i", $arrFile[1], $strFeature, $iTimes)
		 GUICtrlCreateListViewItem($strItem, $ctrlListAcc)
	  EndIf
	  _GUICtrlEdit_SetText($ctrlInAccounts, "")
   Case $ctrlBtRemove
	  Local $arrSelectedItem = _GUICtrlListView_GetSelectedIndices($ctrlListAcc, True)
	  For $i = 0 To $arrSelectedItem[0] - 1
		 _GUICtrlListView_DeleteItem($ctrlListAcc, $i)
	  Next
   Case $ctrlbtMerge
	  Local $arrSelectedItem = _GUICtrlListView_GetSelectedIndices($ctrlListAcc, True)
	  For $i = 1 To $arrSelectedItem[0]
		 MergeItem($arrSelectedItem[$i])
	  Next
   Case $ctrlBtUp
	  Local $arrSelectedItem = _GUICtrlListView_GetSelectedIndices($ctrlListAcc, True)
	  For $i = 1 To $arrSelectedItem[0]
		 Local $iCurIndex = $arrSelectedItem[$i]
		 If $iCurIndex == 0 Then
			ContinueLoop
		 EndIf
		 SwapItem($iCurIndex, $iCurIndex - 1)
	  Next
   Case $ctrlBtDown
	  Local $arrSelectedItem = _GUICtrlListView_GetSelectedIndices($ctrlListAcc, True)
	  Local $iTotal = _GUICtrlListView_GetItemCount($ctrlListAcc)
	  For $i = 1 To $arrSelectedItem[0]
		 Local $iCurIndex = $arrSelectedItem[$i]
		 If $iCurIndex == $iTotal - 1 Then
			ContinueLoop
		 EndIf
		 SwapItem($iCurIndex, $iCurIndex + 1)
	  Next
   EndSwitch
WEnd

Func FindItem($strFile, $strFeature)
   Local $iItems = _GUICtrlListView_GetItemCount($ctrlListAcc)
   For $i = 0 To $iItems - 1
	  Local $arrItemInfo = _GUICtrlListView_GetItemTextArray($ctrlListAcc, $i)
	  If $arrItemInfo[1] == $strFile AND $arrItemInfo[2] == $strFeature Then
		 Return $i
	  EndIf
   Next
   Return -1
EndFunc

Func AddingTime($index, $iTimes)
   Local $arrItemInfo = _GUICtrlListView_GetItemTextArray($ctrlListAcc, $index)
   Local $iNewTimes = $arrItemInfo[3] + $iTimes
   _GUICtrlListView_SetItemText($ctrlListAcc, $index, $iNewTimes > 2 ? 2 : $iNewTimes, 2)
EndFunc

Func MergeItem($index)
   Local $iTotal = _GUICtrlListView_GetItemCount($ctrlListAcc)
   If $index > $iTotal Then
	  Return
   EndIf
   Local $arrCur = _GUICtrlListView_GetItemTextArray($ctrlListAcc, $index)
   Local $iTimes = $arrCur[3]
   Local $iTotal = _GUICtrlListView_GetItemCount($ctrlListAcc)
   Local $arrDuplicated[0]
   For $i = 0 To $iTotal - 1
	  If $i == $index Then
		 ContinueLoop
	  EndIf
	  Local $arrItemText = _GUICtrlListView_GetItemTextArray($ctrlListAcc, $i)
	  If $arrCur[1] == $arrItemText[1] AND $arrCur[2] == $arrItemText[2] Then
		 _ArrayAdd($arrDuplicated, $i)
		 $iTimes += $arrItemText[3]
	  EndIf
   Next
   _GUICtrlListView_SetItemText($ctrlListAcc, $index, $iTimes, 2)
   _ArrayReverse($arrDuplicated)
   For $duplicated In $arrDuplicated
	  _GUICtrlListView_DeleteItem($ctrlListAcc, $duplicated)
   Next
EndFunc

Func SwapItem($index1, $index2)
   Local $arrItem1 = _GUICtrlListView_GetItemTextArray($ctrlListAcc, $index1)
   Local $arrItem2 = _GUICtrlListView_GetItemTextArray($ctrlListAcc, $index2)
   Local $iColumns = _GUICtrlListView_GetColumnCount($ctrlListAcc)
   For $i = 0 To $iColumns - 1
	  _GUICtrlListView_SetItemText($ctrlListAcc, $index1, $arrItem2[$i + 1], $i)
	  _GUICtrlListView_SetItemText($ctrlListAcc, $index2, $arrItem1[$i + 1], $i)
   Next
EndFunc
