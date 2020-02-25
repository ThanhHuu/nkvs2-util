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
#RequireAdmin
; Script Start - Add your code below here

Local $hwndAuto = WinGetHandle("[REGEXPTITLE:(Auto Ngạo Kiếm Vô Song 2).*]")
If Not WinExists($hwndAuto) Then
   _FileWriteLog("log\replace.log", "Prevent when not open auto yet")
   Exit
EndIf
Local $ui = GUICreate("Replace", 300, 200)
Local $listAcc = GUICtrlCreateListView("Account File", 10, 10, 280, 80)
_GUICtrlListView_SetColumnWidth($listAcc, 0, 260)
Local $fAccounts = FileOpenDialog("Select file", @WorkingDir, "Text files (*.txt)", 4)
Local $arrAccInfo = StringSplit($fAccounts, "|")
Local $prFiles
If $arrAccInfo[0] < 2 Then
   GUICtrlCreateListViewItem($arrAccInfo[1], $listAcc)
   $prFiles = $arrAccInfo[1]
Else
   $prFiles = ""
   For $i = 2 To $arrAccInfo[0]
	  Local $fAcc = $arrAccInfo[1] & "\" & $arrAccInfo[$i]
	  $prFiles &= $arrAccInfo[$i] & ";"
	  GUICtrlCreateListViewItem($fAcc, $listAcc)
   Next
   $prFiles = StringTrimRight($prFiles, 1)
EndIf

Local $ctrlList = ControlGetHandle($hwndAuto, "", "[CLASS:SysListView32; INSTANCE:1]")
Local $iTotal = _GUICtrlListView_GetItemCount($ctrlList)
If $iTotal < 7 Then
   _FileWriteLog("log\replace.log", "Prevent when total item < 7")
   Exit
EndIf
Local $arrCtrlNames[0]
Local $arrSize = 0
For $i = 6 To $iTotal - 1
   Local $strName = _GUICtrlListView_GetItemText($ctrlList, $i, 1)
   Local $sTitleReg = "[REGEXPTITLE:(Ngạo Kiếm Vô Song II)\((" & $strName & ").*]"
   If WinExists($sTitleReg) Then
	  $arrSize += 1
	  ReDim $arrCtrlNames[$arrSize]
	  Local $ctrlName = GUICtrlCreateCheckbox($strName, 10, 100 + ($i - 6) * 20, 150, 20)
	  _GUICtrlButton_SetCheck($ctrlName, $BST_CHECKED)
	  $arrCtrlNames[$arrSize - 1] = $ctrlName
   EndIf
Next

Local $bt = GUICtrlCreateButton("Start", 240, 170, 50, 20)

GUISetState(@SW_SHOW, $ui)
RunWait(@AutoItExe & " " & @WorkingDir & "\Locker.au3 UnLock")
While True
   Switch GUIGetMsg()
   Case $GUI_EVENT_CLOSE
	  ExitLoop
   Case $bt
	  Local $offset = 0
	  Local $arrNames[0]
	  For $ctrlName In $arrCtrlNames
		 If _GUICtrlButton_GetCheck($ctrlName) Then
			$offset += 1
			ReDim $arrNames[$offset]
			$arrNames[$offset - 1] = _GUICtrlButton_GetText($ctrlName)
		 EndIf
	  Next
	  Local $action = _GUICtrlButton_GetText($bt)
	  Switch $action
	  Case "Start"
		 If $offset = 0 Then
			MsgBox(0, "", "Please select name")
			ContinueLoop
		 EndIf
		 _GUICtrlButton_SetText($bt, "Stop")
		 FileDelete("Pause")
		 Local $threadId = 1
		 For $name In $arrNames
			Run(@AutoItExe & " " & @WorkingDir & "\replace.au3 " & $prFiles & " " & $name & " " & $offset  & " " & $threadId)
			$threadId += 1
		 Next
		 For $ctrlName In $arrCtrlNames
			_GUICtrlButton_Enable($ctrlName, False)
		 Next
	  Case "Stop"
		 _GUICtrlButton_SetText($bt, "Start")
		 _GUICtrlButton_Enable($bt, False)
		 _FileCreate("Pause")
		 _GUICtrlButton_Enable($bt, True)
		 Local $index = 6
		 For $ctrlName In $arrCtrlNames
			_GUICtrlButton_Enable($ctrlName, True)
			Local $newName = _GUICtrlListView_GetItemText($ctrlList, $index, 1)
			_GUICtrlButton_SetText($ctrlName, $newName)
			$index += 1
		 Next
	  EndSwitch
   EndSwitch
WEnd
