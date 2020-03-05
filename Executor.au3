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
   ClickOnName($strCurName)
   ChangeLoginInfo($strCurName, $strServer, $strUsr, $strPwd, $strName)
   _FileWriteLog(GetFileLog("executor"), StringFormat("Changed index %i to %s", $iIndex, $strName))
   If Not $isNeedLogout Then
	  ClickOnName($strName)
	  RunWait(@AutoItExe & " " & @WorkingDir & "\Locker.au3 UnLock")
	  _FileWriteLog(GetFileLog("executor"), StringFormat("Change %i to %s", $iIndex, $strName))
	  _FileCreate($strName & ".logged")
	  Return
   EndIf
   Local $isShow = ShowWindow($iIndex, True)
   RunWait(@AutoItExe & ' ' & @WorkingDir & '\Action.au3' & ' "' & @WorkingDir & '\action\Logout.txt"' & ' 2 ' & $strCurName)
   ClickOnName($strName)
   RunWait(@AutoItExe & " " & @WorkingDir & "\Locker.au3 UnLock")
   Local $iWaitingTime = 0
   While True
	  Sleep(5 * 1000)
	  $iWaitingTime += 1
	  Local $loggedIn = WinExists("[REGEXPTITLE:(Ngạo Kiếm Vô Song II)\((" & $strName & ").*]")
	  If $loggedIn Then
		 _FileWriteLog(GetFileLog("executor"), StringFormat("Logged %s at %i", $strName, $iIndex))
		 ExitLoop
	  EndIf
	  If $iWaitingTime == 6 Then
		 RunWait(@AutoItExe & " " & @WorkingDir & "\Locker.au3 Lock")
		 ClickOnName($strName)
		 RunWait(@AutoItExe & ' ' & @WorkingDir & '\Action.au3' & ' "' & @WorkingDir & '\action\Logout.txt"' & ' 2 ' & $strCurName)
		 Sleep(1000)
		 ClickOnName($strName)
		 RunWait(@AutoItExe & " " & @WorkingDir & "\Locker.au3 UnLock")
		 $iWaitingTime = 0
	  EndIf
   WEnd
   RunWait(@AutoItExe & " " & @WorkingDir & "\Locker.au3 Lock")
   ShowWindow($iIndex, $isShow)
   _FileCreate($strName & ".logged")
   RunWait(@AutoItExe & " " & @WorkingDir & "\Locker.au3 UnLock")
EndFunc
