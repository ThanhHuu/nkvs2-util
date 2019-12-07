#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.2
 Author:         htra

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#include <Array.au3>
#include <Process.au3>
#include <WinAPIFiles.au3>
#include <File.au3>
#include <GUIConstantsEx.au3>

#RequireAdmin

Func ExitGame()
   Local $arrGames = ProcessList("ClientX86.exe")
   For $i = 1 To $arrGames[0][0]
	  Local $gamePid = $arrGames[$i][1]
	  While Not ProcessClose($gamePid)
	  WEnd
   Next
EndFunc

Local $strAutoDir = $CmdLine[1];"C:\Users\htra\Downloads\AutoNKVS2_2030"
Local $strSettings = $CmdLine[2];"C:\Users\htra\Downloads\NKVSUtil\settings.txt"
Local $iAutoNext = $CmdLine[3]
Local $strAutoApp = $strAutoDir & "\nkvs2Auto.exe"

Local $arrFeatures = FileReadToArray($strSettings)
ExitGame()

For $strConf In $arrFeatures
   If $strConf <> "" Then
	  Local $arr = StringSplit($strConf, " ")
	  RunFeature($arr[1], $arr[2], $arr[3])
   EndIf
Next

Func RunFeature($strFeature, $iTimes, $iWait)
   For $i = 1 To $iTimes
	  _FileWriteLog("apllication.log", StringFormat("Start %d times for %s", $i, $strFeature))
	  Work($strFeature, $iWait)
	  _FileWriteLog("apllication.log", StringFormat("Done %d times for %s", $i, $strFeature))
	  ReduceTime($strFeature)
	  FileDelete("current")
   Next
EndFunc

Func IsExit()
   Local $strExit = @WorkingDir & "\exit"
   If FileExists($strExit) Then
	  FileDelete($strExit)
	  _FileWriteLog("apllication.log", "Exit")
	  Exit
   EndIf
   Return False
EndFunc

Func ReduceTime($strFeature)
   Local $arrFeatures = FileReadToArray($strSettings)
   Local $i = 1
   For $strFeatureCfg In $arrFeatures
	  Local $arrConf = StringSplit($strFeatureCfg, " ")
	  If $arrConf[1] == $strFeature Then
		 Local $strNewConf = $strFeature & " " & $arrConf[2] - 1 & " " & $arrConf[3]
		 _FileWriteToLine($strSettings, $i, $strNewConf, True)
	  EndIf
	  $i += 1
   Next
EndFunc

Func Work($strFeature, $iWait)
   Local $strFeatureDir = $strAutoDir & "\Settings\" & $strFeature
   Local $i = FileExists("current") ? FileReadLine("current", 1) + 1 : 1
   While Not IsExit()
	  Local $strAccFile = $strFeatureDir & '\Accounts.xml' & $i
	  If FileExists($strAccFile) Then
		 _FileWriteLog("apllication.log", "Run " & $i)
		 _FileCreate("current")
		 FileWrite("current", $i)
		 DoWork($strAccFile, $iWait)
	  Else
		 FileDelete($i - 1)
		 ExitLoop;
	  EndIf
	  $i += 1
   WEnd
EndFunc

Func DoWork($strAccFile, $iWait)
   Local $strAutoSetting = $strAutoDir & "\Settings\Accounts.xml"
   FileMove($strAccFile, $strAutoSetting, 1)
   If $iAutoNext == $GUI_CHECKED Then
	  Local $pid = Run($strAutoApp)
	  Sleep($iWait * 60 * 1000)
	  ProcessClose($pid)
   Else
	  RunWait($strAutoApp)
   EndIf
   ExitGame()
   Sleep(3000)
   FileMove($strAutoSetting, $strAccFile, 1)
EndFunc

