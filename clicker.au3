#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.2
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------
#include <WinAPIFiles.au3>
#include <File.au3>

Local $hwnd = $CmdLine[1]
Local $fClicking = $CmdLine[2]


Local $prevOpt = AutoItSetOption("MouseCoordMode", 2)
RunClicking($fClicking)
AutoItSetOption("MouseCoordMode", $prevOpt)

Func RunClicking($fClicking)
   If Not FileExists($fClicking) Then
	  _FileWriteLog("clicker.log", "Not found file " & $fClicking)
	  Exit
   EndIf
   Local $arrClickings = FileReadToArray($fClicking)
   WinActivate($hwnd)
   WinWaitActive($hwnd, "", 2)
   For $strClicking In $arrClickings
	  DoClick($strClicking)
   Next
   _FileWriteLog("clicker.log", StringFormat("Done click %s for %s", $fClicking, WinGetTitle($hwnd)))
EndFunc

;$strClicking: left-100,100-1 5
Func DoClick($strClicking)
   Local $arrInfo = StringSplit($strClicking, " ")

   Local $arrClickInfo = StringSplit($arrInfo[1], "-")
   Local $strMouse = $arrClickInfo[1]
   Local $iClicks = $arrClickInfo[3]
   Local $arrCoord = StringSplit($arrClickInfo[2], ",")

   Local $iWait = $arrInfo[2]

   MouseClick($strMouse, $arrCoord[1], $arrCoord[2], $iClicks)
   Sleep($iWait * 1000)
EndFunc