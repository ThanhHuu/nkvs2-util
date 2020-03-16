#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.2
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------
#include <Array.au3>
#include "AutoNkvs2.au3"
#include <File.au3>
#RequireAdmin

; Script Start - Add your code below here

Local $strFuncName = $CmdLine[1]
Local $strParameter  = $CmdLine[2]

Switch $strFuncName
Case "LoginAtIndex"
   Local $arrParam = StringSplit($strParameter, '|')
   Call($strFuncName, $arrParam[1], $arrParam[2], $arrParam[3], $arrParam[4], $arrParam[5], $arrParam[6] == True)
EndSwitch

Func LoginAtIndex($iIndex, $strServer, $strUsr, $strPwd, $strName, $isNeedLogout)
   RunWait(@AutoItExe & " " & @WorkingDir & "\Locker.au3 Lock")
   Local $strCurName = _GUICtrlListView_GetItemText($CTRL_LIST_NAME, $iIndex, 1)
   ClickItem($CTRL_LIST_NAME, $iIndex, 0)
   If $isNeedLogout Then
	  Local $isShow = True
	  $isShow = ShowWindow($iIndex, $isShow)
	  While True
		 If Not WinExists("[REGEXPTITLE:(Ngạo Kiếm Vô Song II)\((" & $strCurName & ").*]") Then
			ExitLoop
		 EndIf
		 RunWait(@AutoItExe & ' ' & @WorkingDir & '\Action.au3' & ' "' & @WorkingDir & '\action\Logout.txt"' & ' 2 ' & $strCurName)
	  WEnd
	  ShowWindow($iIndex, $isShow)
	  ChangeLoginInfo($strCurName, $strServer, $strUsr, $strPwd, $strName)
	  ClickItem($CTRL_LIST_NAME, $iIndex, 0)
	  RunWait(@AutoItExe & " " & @WorkingDir & "\Locker.au3 UnLock")
   Else
	  ChangeLoginInfo($strCurName, $strServer, $strUsr, $strPwd, $strName)
	  RunWait(@AutoItExe & " " & @WorkingDir & "\Locker.au3 UnLock")
	  _FileCreate($strName & ".logged")
	  Return
   EndIf
   For $i = 1 To 40
	  Sleep(2 * 1000)
	  If WinExists("[REGEXPTITLE:(Ngạo Kiếm Vô Song II)\((" & $strName & ").*]") Then
		 _FileCreate($strName & ".logged")
		 Return
	  EndIf
	  If Mod($i, 20) == 0 Then
		 RunWait(@AutoItExe & " " & @WorkingDir & "\Locker.au3 Lock")
		 ClickItem($CTRL_LIST_NAME, $iIndex, 0)
		 Sleep(1000)
		 ClickItem($CTRL_LIST_NAME, $iIndex, 0)
		 RunWait(@AutoItExe & " " & @WorkingDir & "\Locker.au3 UnLock")
	  EndIf
   Next
   _FileWriteLog(GetFileLog("executor"), StringFormat("Error Logged %s at %i", $strName, $iIndex))
EndFunc
