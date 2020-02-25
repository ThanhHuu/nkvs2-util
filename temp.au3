#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.2
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------
#include-once
#include <WinAPIFiles.au3>
#include <File.au3>

#RequireAdmin

RunWait(@AutoItExe & ' ' & @WorkingDir & '\Action.au3' & ' '& '"' & @WorkingDir & '\action\ThienMenh\HaoHuu.txt"' & ' 2 ' & "ThienGiangXVIIIA")
RunWait(@AutoItExe & ' ' & @WorkingDir & '\Action.au3' & ' '& '"' & @WorkingDir & '\action\ThienMenh\HaoHuu.txt"' & ' 2 ' & "ThienGiangXVIIIB")
RunWait(@AutoItExe & ' ' & @WorkingDir & '\Action.au3' & ' '& '"' & @WorkingDir & '\action\ThienMenh\HaoHuu.txt"' & ' 2 ' & "ThienGiangXVIIIC")