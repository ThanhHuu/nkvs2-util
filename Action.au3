#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.2
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------
#include <WinAPIFiles.au3>
#include <File.au3>
#include "AutoNkvs2.au3"
#include <Array.au3>

;RunAction("C:\Users\htra\Downloads\NKVSUtil\action\QuaDangNhap.txt", "ThienGiangVB")
;Exit

Local $strName = $CmdLine[3]
Local $faction = $CmdLine[1]
Local $coordOpt = $CmdLine[2]

Local $prevOpt = AutoItSetOption("MouseCoordMode", $coordOpt)
RunAction($faction, $strName)
AutoItSetOption("MouseCoordMode", $prevOpt)

Func RunAction($faction, $strName)
   If Not FileExists($faction) Then
	  _FileWriteLog(GetFileLog("action"), "Not found file " & $faction)
	  Exit
   EndIf
   Local $sTitleReg = "[REGEXPTITLE:(Ngạo Kiếm Vô Song II)\((" & $strName & ").*]"
   Local $hwnd = WinGetHandle($sTitleReg)
   If Not WinExists($hwnd) Then
	  _FileWriteLog(GetFileLog("action"), StringFormat("Not found window for %s", $strName))
	  Return
   EndIf
   _FileWriteLog(GetFileLog("action"), StringFormat("Start action %s within option %d for %s", $faction, 2, $strName))
   Local $arrActions = FileReadToArray($faction)
   For $strAction In $arrActions
	  If StringLen($strAction) = 0 Then
		 ContinueLoop
	  EndIf
	  Local $arrActionInfo = StringSplit($strAction, " ")
	  If $arrActionInfo[0] < 2 Then
		 ContinueLoop
	  EndIf
	  Switch $arrActionInfo[1]
	  Case "click"
		 DoClick($hwnd, $arrActionInfo[2], $arrActionInfo[3])
	  Case "send"
		 DoSend($hwnd, $arrActionInfo[2], $arrActionInfo[3])
	  Case "sleep"
		 Sleep($arrActionInfo[2])
	  Case "state"
		 DoWaitState($strName, $arrActionInfo[2])
	  EndSwitch
   Next
EndFunc


;$strClickInfo will be convention "left-x,y-clicks"
Func DoClick($hwnd, $strClickInfo, $iWait)
   If Not BitAND(WinGetState($hwnd), 2) Then
	  _FileWriteLog(GetFileLog("action"), StringFormat("Not DoClick Invisible window - %s", $strName))
	  Return
   EndIf
   Local $arrClickInfo = StringSplit($strClickInfo, "-")
   Local $strMouse = $arrClickInfo[1]
   Local $iClicks = $arrClickInfo[3]
   Local $arrCoord = StringSplit(StringReplace($arrClickInfo[2], " ", ""), ",")

   WinActivate($hwnd)
   MouseClick($strMouse, $arrCoord[1], $arrCoord[2], $iClicks)
   Sleep($iWait * 1000)
EndFunc

Func DoSend($hwnd, $strText, $iWait)
   If Not BitAND(WinGetState($hwnd), 2) Then
	  _FileWriteLog(GetFileLog("action"), StringFormat("Not DoSend Invisible window - %s", $strName))
	  Return
   EndIf
   WinActivate($hwnd)
   Send($strText)
   Sleep($iWait * 1000)
EndFunc

Func DoSleep($iWait)
   Sleep($iWait * 1000)
EndFunc

Func DoWaitState($strName, $strRequiredState)
   For $i = 1 To 60
	  Sleep(60 * 1000)
	  If GetCurrentState($strName) == $strRequiredState Then
		 _FileWriteLog(GetFileLog("action"), StringFormat("Found state %s for %s", $strRequiredState, $strName))
		 Return
	  EndIf
	  If Mod($i, 3) == 0 Then
		 Local $arrRunning = _FileListToArray(@WorkingDir, "*.running", 1)
		 For $i = 1 To $arrRunning[0]
			Local $strRunning = StringReplace($arrRunning[$i], ".running", "")
			Local $index = SelectName($strRunning)
			Local $isShow = ShowWindow($index, True)
			RunAction(@WorkingDir & "\action\MoHanhTrang.txt", $strRunning)
			ShowWindow($index, $isShow)
		 Next
	  EndIf
   Next
   _FileWriteLog(GetFileLog("action"), StringFormat("Maybe stucked at %s", $strName))
EndFunc