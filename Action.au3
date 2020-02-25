#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.2
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------
#include <WinAPIFiles.au3>
#include <File.au3>
#include "AutoNkvs2.au3"

Local $strName = $CmdLine[3]
Local $faction = $CmdLine[1]
Local $coordOpt = $CmdLine[2]

Local $sTitleReg = "[REGEXPTITLE:(Ngạo Kiếm Vô Song II)\((" & $strName & ").*]"
If Not WinExists($sTitleReg) Then
   _FileWriteLog(GetFileLog("action"), StringFormat("Not found window for %s", $strName))
   Exit
EndIf

Local $hwnd = WinGetHandle($sTitleReg)
Local $prevOpt = AutoItSetOption("MouseCoordMode", $coordOpt)
RunAction($faction)
AutoItSetOption("MouseCoordMode", $prevOpt)

Func RunAction($faction)
   _FileWriteLog(GetFileLog("action"), StringFormat("Start action %s within option %d for %s", $faction, 2, $strName))
   If Not FileExists($faction) Then
	  _FileWriteLog(GetFileLog("action"), "Not found file " & $faction)
	  Exit
   EndIf
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
		 DoClick($arrActionInfo[2], $arrActionInfo[3])
	  Case "send"
		 DoSend($arrActionInfo[2], $arrActionInfo[3])
	  Case "sleep"
		 Sleep($arrActionInfo[2])
	  EndSwitch
   Next
EndFunc


;$strClickInfo will be convention "left-x,y-clicks"
Func DoClick($strClickInfo, $iWait)
   Local $arrClickInfo = StringSplit($strClickInfo, "-")
   Local $strMouse = $arrClickInfo[1]
   Local $iClicks = $arrClickInfo[3]
   Local $arrCoord = StringSplit(StringReplace($arrClickInfo[2], " ", ""), ",")

   WinActivate($hwnd)
   MouseClick($strMouse, $arrCoord[1], $arrCoord[2], $iClicks)
   Sleep($iWait * 1000)
EndFunc

Func DoSend($strText, $iWait)
   WinActivate($hwnd)
   Send($strText)
   Sleep($iWait * 1000)
EndFunc

Func DoSleep($iWait)
   Sleep($iWait * 1000)
EndFunc