#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.2
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------
#include-once
#include <GuiComboBox.au3>
#include <GuiListBox.au3>
#include <GuiListView.au3>
#include <Array.au3>
#include <GUIConstantsEx.au3>
#include <GuiTab.au3>
#include <GuiEdit.au3>
#include <GuiButton.au3>
#include <GUIConstantsEx.au3>
#include <File.au3>

Opt("MouseCoordMode", 2)
#RequireAdmin

; Script Start - Add your code below here

Local $HWND_AUTO = WinGetHandle("[REGEXPTITLE:(Auto Ngạo Kiếm Vô Song 2).*]")
Local $CTRL_BT_FOLLOW = ControlGetHandle($HWND_AUTO, "", "[CLASS:Button; TEXT:T.Sau (Ctrl + S)]")
Local $CTRL_BT_FOLLOW_QUICKLY = ControlGetHandle($HWND_AUTO, "", "[CLASS:Button; TEXT:Thần Hành Thạch]")
Local $CTRL_LIST_NAME = ControlGetHandle($HWND_AUTO, "", "[CLASS:SysListView32; INSTANCE:1]")
Local $CTRL_LIST_FEATRUE = ControlGetHandle($HWND_AUTO, "", "[CLASS:SysListView32; INSTANCE:2]")
Local $CTRL_TAB_CONFIGURATION = ControlGetHandle($HWND_AUTO, "", "[CLASS:SysTabControl32; INSTANCE:1]")
If Not WinExists($HWND_AUTO) Then
   MsgBox(0,"", "We cannot run unless open AutoNkvs2")
   Exit
EndIf

Func ClickOnName($strName)
   Local $index = _GUICtrlListView_FindInText($CTRL_LIST_NAME, $strName)
   ClickItem($CTRL_LIST_NAME, $index, 0)
EndFunc

Func ClickOnFeature($strName, $feature)
   SelectName($strName)
   _GUICtrlTab_SetCurFocus($CTRL_TAB_CONFIGURATION, _GUICtrlTab_FindTab($CTRL_TAB_CONFIGURATION, "Cơ bản"))
   Local $index = _GUICtrlListView_FindInText($CTRL_LIST_FEATRUE, $feature)
   ClickItem($CTRL_LIST_FEATRUE, $index, 0)
   ClickItem($CTRL_LIST_FEATRUE, $index, 2, 2)
   EndFunc

Func SetFollow($strName, $follow, $quickly)
   SelectName($strName)
   _GUICtrlTab_SetCurFocus($CTRL_TAB_CONFIGURATION, _GUICtrlTab_FindTab($CTRL_TAB_CONFIGURATION, "Cơ bản"))
   If $follow Then
	  If Not _GUICtrlButton_GetCheck($CTRL_BT_FOLLOW) Then
		 _GUICtrlButton_Click($CTRL_BT_FOLLOW)
	  EndIf
   ElseIf _GUICtrlButton_GetCheck($CTRL_BT_FOLLOW) Then
	  _GUICtrlButton_Click($CTRL_BT_FOLLOW)
   EndIf
   If $quickly Then
	  If Not _GUICtrlButton_GetCheck($CTRL_BT_FOLLOW_QUICKLY) Then
		 _GUICtrlButton_Click($CTRL_BT_FOLLOW_QUICKLY)
	  EndIf
   ElseIf _GUICtrlButton_GetCheck($CTRL_BT_FOLLOW_QUICKLY) Then
	  _GUICtrlButton_Click($CTRL_BT_FOLLOW_QUICKLY)
   EndIf
EndFunc

Func ChangeLoginInfo($strCurrent, $server, $strUsr, $strPwd, $strNext)
   SelectName($strCurrent)
   _GUICtrlTab_SetCurFocus($CTRL_TAB_CONFIGURATION, _GUICtrlTab_FindTab($CTRL_TAB_CONFIGURATION, "Đăng nhập"))
   While True
	  Local $ctrlServer = ControlGetHandle($HWND_AUTO, "", "[CLASS:ComboBox; INSTANCE:9]")
	  _GUICtrlComboBox_SetCurSel($ctrlServer, _GUICtrlComboBox_SelectString($ctrlServer, $server))
	  Local $ctrInputUsr = ControlGetHandle($HWND_AUTO, "", "[CLASS:Edit; INSTANCE:27]")
	  _GUICtrlEdit_SetText ( $ctrInputUsr, $strUsr )
	  Local $ctrInputPwd = ControlGetHandle($HWND_AUTO, "", "[CLASS:Edit; INSTANCE:28]")
	  _GUICtrlEdit_SetText ( $ctrInputPwd, $strPwd )
	  Local $ctrInputName = ControlGetHandle($HWND_AUTO, "", "[CLASS:Edit; INSTANCE:29]")
	  _GUICtrlEdit_SetText ( $ctrInputName, $strNext )
	  Local $ctrBtUpdate = ControlGetHandle($HWND_AUTO, "", "[CLASS:Button; INSTANCE:104]")
	  _GUICtrlButton_Click($ctrBtUpdate)
	  If _GUICtrlListView_FindInText($CTRL_LIST_NAME, $strNext) >= 0 Then
		 ExitLoop
	  EndIf
	  Sleep(500)
   WEnd
EndFunc

Func SelectName($strName)
   Local $index = _GUICtrlListView_FindInText($CTRL_LIST_NAME, $strName)
   If $index >= 0 Then
	  _GUICtrlListView_SetItemSelected($CTRL_LIST_NAME, $index, true, true)
	  Return $index
   EndIf
   Return -1
EndFunc

Func ShowWindow($index, $isShow)
   If $index < 0 Then
	  Return
   EndIf
   Local $strCurrentState = _GUICtrlListView_GetItemText($CTRL_LIST_NAME, $index, 3)
   If $isShow Then
	  If $strCurrentState == "" Then
		 Return True
	  Else
		 ClickItem($CTRL_LIST_NAME, $index, 3)
		 Sleep(500)
		 Return False
	  EndIf
   Else
	  If $strCurrentState == "" Then
		 ClickItem($CTRL_LIST_NAME, $index, 3)
		 Sleep(500)
		 Return True
	  Else
		 Return False
	  EndIf
   EndIf
EndFunc

Func ClickItem($ctrlList, $item, $subItem, $iClicks = 1)
   If $subItem = 0 Then
	  WinActivate($HWND_AUTO)
	  _GUICtrlListView_ClickItem($ctrlList, $item)
	  Return
   EndIf
   Local $offSet = 0
   For $i = 0 To $subItem - 1
	  $offSet += _GUICtrlListView_GetColumnWidth($ctrlList, $i)
   Next
   $offSet += _GUICtrlListView_GetColumnWidth($ctrlList, $subItem)/2
   Local $arrCoord = _GUICtrlListView_GetItemRect($ctrlList, $item)
   Local $x = $arrCoord[0] + $offSet + 3
   Local $y = $arrCoord[1] + 10
   ControlClick($HWND_AUTO, "", $ctrlList, "left", $iClicks, $x, $y)
EndFunc

Func BuildTeam($strCaptain, $arrMembers)
   SelectName($strCaptain)
   _GUICtrlTab_SetCurFocus($CTRL_TAB_CONFIGURATION, _GUICtrlTab_FindTab($CTRL_TAB_CONFIGURATION, "Tổ đội"))
   ControlClick($HWND_AUTO, "", "[CLASS:Button; INSTANCE:87]")
   If Not _GUICtrlButton_GetCheck(ControlGetHandle($HWND_AUTO, "", "[CLASS:Button; INSTANCE:91]")) Then
	  _GUICtrlButton_Click(ControlGetHandle($HWND_AUTO, "", "[CLASS:Button; INSTANCE:91]"))
   EndIf
   If _GUICtrlButton_GetCheck(ControlGetHandle($HWND_AUTO, "", "[CLASS:Button; INSTANCE:90]")) Then
	  _GUICtrlButton_Click(ControlGetHandle($HWND_AUTO, "", "[CLASS:Button; INSTANCE:90]"))
   EndIf
   ControlClick($HWND_AUTO, "", ControlGetHandle($HWND_AUTO, "", "[CLASS:SysLink; INSTANCE:4]"))
   Local $ctrlListMember = ControlGetHandle($HWND_AUTO, "", "[CLASS:ListBox; INSTANCE:3]")
   Local $total = _GUICtrlListBox_GetCount($ctrlListMember)
   For $i = 1 To $total
	  _GUICtrlListBox_SetCurSel($ctrlListMember, 0)
	  Sleep(100)
	  _GUICtrlButton_Click(ControlGetHandle($HWND_AUTO, "", "[CLASS:Button; INSTANCE:120]"))
	  Sleep(100)
   Next
   For $member In $arrMembers
	  Local $ctrlCb = ControlGetHandle($HWND_AUTO, "", "[CLASS:ComboBox; INSTANCE:12]")
	  Local $index = _GUICtrlComboBox_SelectString($ctrlCb, $member)
	  If $index < 0 Then
		 ContinueLoop
	  EndIf
	  _GUICtrlComboBox_SetCurSel($ctrlCb, $index)
	  Sleep(100)
	  Local $ctrlBtAdd = ControlGetHandle($HWND_AUTO, "", "[CLASS:Button; INSTANCE:119]")
	  _GUICtrlButton_Click($ctrlBtAdd)
	  Sleep(100)
   Next
   _GUICtrlButton_Click(ControlGetHandle($HWND_AUTO, "", "[CLASS:Button; INSTANCE:116]"))
   For $strMember In $arrMembers
	  If $strMember == $strCaptain Then
		 ContinueLoop
	  EndIf
	  SelectName($strMember)
	  ControlClick($HWND_AUTO, "", ControlGetHandle($HWND_AUTO, "", "[CLASS:Button; INSTANCE:88]"))
	  If _GUICtrlButton_GetCheck(ControlGetHandle($HWND_AUTO, "", "[CLASS:Button; INSTANCE:95]")) Then
		 _GUICtrlButton_Click(ControlGetHandle($HWND_AUTO, "", "[CLASS:Button; INSTANCE:95]"))
	  EndIf
	  _GUICtrlEdit_SetText(ControlGetHandle($HWND_AUTO, "", "[CLASS:Edit; INSTANCE:26]"), $strCaptain)
	  _GUICtrlButton_Click(ControlGetHandle($HWND_AUTO, "", "[CLASS:Button; INSTANCE:95]"))
	  If Not _GUICtrlButton_GetCheck(ControlGetHandle($HWND_AUTO, "", "[CLASS:Button; INSTANCE:93]")) Then
		 _GUICtrlButton_Click(ControlGetHandle($HWND_AUTO, "", "[CLASS:Button; INSTANCE:93]"))
	  EndIf
   Next
   SelectName($strCaptain)
EndFunc

;DestroyTeam("ThienGiangXA")
Func DestroyTeam($strCaptain)
   SelectName($strCaptain)
   _GUICtrlTab_SetCurFocus($CTRL_TAB_CONFIGURATION, _GUICtrlTab_FindTab($CTRL_TAB_CONFIGURATION, "Tổ đội"))
   ControlClick($HWND_AUTO, "", ControlGetHandle($HWND_AUTO, "", "[CLASS:Button; INSTANCE:88]"))
EndFunc

Func GetCurrentState($strName)
   Local $index = _GUICtrlListView_FindInText($CTRL_LIST_NAME, $strName)
   Return _GUICtrlListView_GetItemText($CTRL_LIST_NAME, $index, 2)
EndFunc

Func GetFileLog($strFileName)
   Return StringFormat("log\%s-%s%s%s.log", $strFileName, @YEAR, @MON, @MDAY)
EndFunc