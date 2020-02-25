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

;Local $strDir = $CmdLine[1]
;Local $hwnd = $CmdLine[2]

HotKeySet("^p", "Stop")

Local $hwnd = "Ngạo Kiếm Vô Song II Version: 0.280[1]"
Local $strUserPrefix = "thien_giang"
Local $strPrefix = "ThienGiang"
Local $arrSuffix = ["V"]
Local $arrOrder = ["A", "B", "C", "D", "E", "F"]

For $strSuffix In $arrSuffix
   CreateForSuffix($strSuffix)
Next

Func CreateForSuffix($strSuffix)
   Local $index = 7
   For $strOrder in $arrOrder
	  Local $strUsr = $strUserPrefix & $index
	  Local $strPwd = "Ngoc@nh91"
	  Login($hwnd, $strUsr, $strPwd)
	  Local $strName = $strPrefix & $strSuffix & $strOrder
	  CreateCharacter($hwnd, $strName)
	  _FileWriteLog("creator.log", StringFormat("Create character %s", $strName))
	  $index += 1
   Next
   MsgBox(0,"", "OK")
EndFunc

Func Login($hwnd, $sUsr, $pwd)
   Local $optPrevious = Opt("MouseCoordMode", 2)
   WinActivate($hwnd)
   If WinWaitActive($hwnd, "", 3) Then
	  MouseClick("left", 353, 245)
	  Send("{DEL 32}")
	  Send("{BS 32}")
	  Send($sUsr)
	  Send("{TAB}")
	  Send($pwd)
	  Local $before = PixelChecksum(755, 468, 803, 481, 1, $hwnd)
	  Send("{ENTER}")
	  Local $bSuccess = False
	  For $i = 1 To 5
		 Sleep($i * 2000)
		 Local $after = PixelChecksum(755, 468, 803, 481, 1, $hwnd)
		 If $before <> $after Then
			$bSuccess = True
			ExitLoop
		 EndIf
	  Next
   Else
	  MsgBox(0, "", "Error active window")
   EndIf
   Opt("MouseCoordMode", $optPrevious)
EndFunc

Func CreateCharacter($hwnd, $sName)
   Local $optPrevious = Opt("MouseCoordMode", 2)
   WinActivate($hwnd)
   If WinWaitActive($hwnd, "", 3) Then
	  MouseClick("left", 212, 562)
	  Sleep(3000)
	  MouseClick("left", 341, 494)
	  Send("{DEL 32}")
	  Send("{BS 32}")
	  Send($sName)
	  MouseClick("left", 563, 258)
	  Sleep(1000)
	  MouseClick("left", 400, 566)
	  Sleep(1000)
	  MouseClick("left", 405, 377)
	  Sleep(1000)
	  MouseClick("left", 405, 377)
	  Sleep(2000)
	  MouseClick("left", 70, 564)
	  Sleep(1000)
	  MouseClick("left", 70, 564)
   Else
	  MsgBox(0, "", "Error active window")
   EndIf
   Opt("MouseCoordMode", $optPrevious)
EndFunc

Func Stop()
   Exit
EndFunc