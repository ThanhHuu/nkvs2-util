#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.2
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------
#include <GuiListView.au3>
#include <Array.au3>
#include <GUIConstantsEx.au3>
#include <GuiTab.au3>
#include <GuiEdit.au3>
#include <GuiButton.au3>
#include <WinAPIFiles.au3>
#include <File.au3>
#include <GuiComboBox.au3>
#include <GuiListBox.au3>
#include "AutoNkvs2.au3"
Opt("MouseCoordMode", 2)

#RequireAdmin

Local $hwndAuto = WinGetHandle("[REGEXPTITLE:(Auto Ngạo Kiếm Vô Song 2).*]")
If Not WinExists($hwndAuto) Then
   _FileWriteLog("replace.log", StringFormat("Not found auto %s", "Auto Ngạo Kiếm Vô Song 2 - v2.0.3.2"))
   Exit
EndIf

HotKeySet("^p", "Stop")

Local $strFiles = "C:\Users\htra\Downloads\NKVSUtil\ThienGiang1.txt;";$CmdLine[1];
Local $iFrom =4;$CmdLine[2]
Local $iSize = 3;$CmdLine[3]
Local $iFromIndex = 6;$CmdLine[4]
Local $isAutoNext = False;$CmdLine[5]
Local $isReceiveAward = False
Local $isNeedLogout = False

Local $BC = "Bí Cảnh"
Local $NTD = "N.Trúc Đàm"
Local $TN = "Truy Nã"
Local $DV = "Đố vui"
Local $DD = "Điều Đội"
Local $TM = "ThienMenh"
Local $CP = "CauPhuc"
Local $NSN = "NhanSoiNoi"
Local $DLQ = "Đ.Linh Quả"
Local $THDC = "ThuHoiDaoCu"
Local $NT = "NoThing"
Local $LL = "Lịch Luyện"
Local $TSK = "TangSkill"
Local $NQ = "QuaDangNhap"

Func IsTeamFeature($strFeature)
   Local $arrTeamFeature = [$BC, $NTD, $TN, $NT, $LL]
   For $strTeamFeature In $arrTeamFeature
	  If $strTeamFeature == $strFeature Then
		 Return True
	  EndIf
   Next
   Return False
EndFunc

Func IsNeedFollow($strFeature)
   Local $arrTeamFeature = [$BC, $NTD]
   For $strTeamFeature In $arrTeamFeature
	  If $strTeamFeature == $strFeature Then
		 Return True
	  EndIf
   Next
   Return False
EndFunc

Func IsSyncFeature($strFeature)
   Local $arrSyncFeature = [$TM, $CP, $NSN, $THDC, $NQ]
   For $strTeamFeature In $arrSyncFeature
	  If $strTeamFeature == $strFeature Then
		 Return True
	  EndIf
   Next
   Return False
EndFunc

Func Stop()
   _FileCreate("Pause")
   ;MsgBox(0,"","STOPPED")
EndFunc

RunWait(@AutoItExe & " " & @WorkingDir & "\Locker.au3 UnLock")
FileDelete("Pause")
#cs
RunForFile($DD, "C:\Users\htra\Downloads\NKVSUtil\ThienGiang1.txt", 1, 3)
RunForFile($DD, "C:\Users\htra\Downloads\NKVSUtil\ThienGiang2.txt", 1, 3)
RunForFile($DD, "C:\Users\htra\Downloads\NKVSUtil\ThienGiang3.txt", 1, 3)
RunForFile($DD, "C:\Users\htra\Downloads\NKVSUtil\ThienGiang4.txt", 1, 3)

RunForFile($BC, "C:\Users\htra\Downloads\NKVSUtil\ThienGiang1.txt", 1, 3)
RunForFile($BC, "C:\Users\htra\Downloads\NKVSUtil\ThienGiang2.txt", 1, 3)
RunForFile($BC, "C:\Users\htra\Downloads\NKVSUtil\ThienGiang3.txt", 1, 3)
RunForFile($BC, "C:\Users\htra\Downloads\NKVSUtil\ThienGiang4.txt", 1, 3)

RunForFile($DD, "C:\Users\htra\Downloads\NKVSUtil\ThienGiang1.txt", 1, 3)
RunForFile($DD, "C:\Users\htra\Downloads\NKVSUtil\ThienGiang2.txt", 1, 3)
RunForFile($DD, "C:\Users\htra\Downloads\NKVSUtil\ThienGiang3.txt", 1, 3)
RunForFile($DD, "C:\Users\htra\Downloads\NKVSUtil\ThienGiang4.txt", 1, 3)

RunForFile($BC, "C:\Users\htra\Downloads\NKVSUtil\ThienGiang1.txt", 1, 3)
RunForFile($BC, "C:\Users\htra\Downloads\NKVSUtil\ThienGiang2.txt", 1, 3)
RunForFile($BC, "C:\Users\htra\Downloads\NKVSUtil\ThienGiang3.txt", 1, 3)
RunForFile($BC, "C:\Users\htra\Downloads\NKVSUtil\ThienGiang4.txt", 1, 3)

RunForFile($NQ, "C:\Users\htra\Downloads\NKVSUtil\ThienGiang2.txt", 1, 3)
#ce

RunForFile($NT, "C:\Users\htra\Downloads\NKVSUtil\ThienGiang3.txt", 7, 3)
; Script Start - Add your code below here

Func RunForFile($strFeature, $fAccount, $iFrom, $iSize)
   _FileWriteLog(GetFileLog("replace"), StringFormat("Run %s For %s From %i", $strFeature, $fAccount, $iFrom))
   Local $iLines = _FileCountLines($fAccount)
   Local $iLine = $iFrom
   While $iLine <= $iLines
	  Local $arrName[$iSize]
	  For $i = 0 To $iSize - 1
		 Local $strLine = FileReadLine($fAccount, $iLine)
		 If FileExists("Pause") Then
			_FileWriteLog(GetFileLog("replace"), StringFormat("Pause At Feature: %s - Line %i", $strFeature, $iLine))
			Exit
		 EndIf
		 Local $arrInfo = StringSplit($strLine, "-")
		 Local $strServer = $arrInfo[1]
		 Local $strUsr = $arrInfo[2]
		 Local $strName = $arrInfo[3]
		 Local $strParams = StringFormat("%i|%s|%s|%s|%s|%s", $iFromIndex + $i, $strServer, $strUsr, "Ngoc@nh91", $strName, $isNeedLogout)
		 Run(@AutoItExe & ' ' & @WorkingDir & '\Executor.au3' & ' LoginAtIndex ' & '"' & $strParams &'"')
		 _FileWriteLog(GetFileLog("replace"), StringFormat("Submit for %s", $strName))
		 $arrName[$i] = $strName
		 $iLine += 1
	  Next
	  While True
		 Sleep(5 * 1000)
		 Local $arrLogged = _FileListToArray(@WorkingDir, "*.logged", 1)
		 If Not @error And $arrLogged[0] >= $iSize Then
			For $i = 1 To $arrLogged[0]
			   FileMove($arrLogged[$i], StringReplace($arrLogged[$i], ".logged", ".running"))
			   ;FileDelete($arrLogged[$i])
			Next
			ExitLoop
		 EndIf
	  WEnd
	  _FileWriteLog(GetFileLog("replace"), "Logged for all")
	  RunFeature($strFeature, $arrName)
   WEnd
EndFunc

Func RunFeature($strFeature, $arrName)
   Local $isTeamFeature = IsTeamFeature($strFeature)
   If $isTeamFeature And UBound($arrName) > 1 Then
	  BuildTeam($arrName[0], $arrName)
	  Sleep(3*1000)
   EndIf
   Local $isFollow = IsNeedFollow($strFeature)
   If $isFollow Then
	  For $strName In $arrName
		 SetFollow($strName, True, True)
	  Next
   EndIf
   Local $arrAction[0]
   Switch $strFeature
   Case $NTD
	  While Not (GetCurrentState($arrName[0]) == 'Online')
		 ClickOnFeature($arrName[0], $strFeature)
		 Sleep(3*1000)
	  WEnd
	  Sleep(15 * 1000)
	  _ArrayAdd($arrAction, '"' & @WorkingDir & '\action\' & $strFeature & '.txt"')
   Case $TM
	  _ArrayAdd($arrAction, '"' & @WorkingDir & '\action\ThienMenh80\HaoHuu.txt"')
	  _ArrayAdd($arrAction, '"' & @WorkingDir & '\action\ThienMenh80\DanhGia.txt"')
	  _ArrayAdd($arrAction, '"' & @WorkingDir & '\action\ThienMenh80\LuuGuong.txt"')
	  _ArrayAdd($arrAction, '"' & @WorkingDir & '\action\ThienMenh80\CuongHoa.txt"')
   Case $NT
	  Local $arrRunning = _FileListToArray(@WorkingDir, "*.running", 1)
	  For $i = 1 To $arrRunning[0]
		 FileDelete($arrRunning[$i])
	  Next
	  If Not $isAutoNext Then
		 Local $choice = MsgBox(4, "Choices", "Continue ?")
		 If $choice == $IDNO Then
			Exit
		 EndIf
		 Return
	  EndIf
   Case Else
	  _ArrayAdd($arrAction, '"' & @WorkingDir & '\action\' & $strFeature & '.txt"')
   EndSwitch

   If IsSyncFeature($strFeature) Then
	  For $strName In $arrName
		 For $strAction In $arrAction
			RunWait(@AutoItExe & ' ' & @WorkingDir & '\Action.au3' & ' '& $strAction & ' 2 ' & $strName)
		 Next
	  Next
   Else
	  Local $strPresentName = $arrName[0]
	  If $isFollow Then
		 ClickOnFeature($strPresentName, $strFeature)
	  Else
		 For $strName In $arrName
			ClickOnFeature($strName, $strFeature)
			If $strFeature == $TN Then
			   Local $index = SelectName($strName)
			   Local $isShow = ShowWindow($index, True)
			   RunWait(@AutoItExe & ' ' & @WorkingDir & '\Action.au3' & ' "' & @WorkingDir & '\action\MoNhiemVu.txt" 2 ' & $strName)
			   ShowWindow($index, $isShow)
			EndIf
		 Next
	  EndIf
	  For $strAction In $arrAction
		 _FileWriteLog(GetFileLog("replace"), StringFormat("Start %s with present %s",$strAction, $strName))
		 RunWait(@AutoItExe & ' ' & @WorkingDir & '\Action.au3' & ' '& $strAction & ' 2 ' & $strPresentName)
	  Next
	  If $isFollow Then
		 ClickOnFeature($strPresentName, $strFeature)
	  Else
		 For $strName In $arrName
			ClickOnFeature($strName, $strFeature)
		 Next
	  EndIf
   EndIf
   ; Unset follow captain
   If $isFollow Then
	  For $strName In $arrName
		 SetFollow($strName, False, True)
	  Next
   EndIf
   If $isTeamFeature And UBound($arrName) > 1 Then
	  DestroyTeam($arrName[0])
   EndIf
   If $isReceiveAward Then
	  For $strName In $arrName
		 _FileWriteLog(GetFileLog("replace"), StringFormat("Receive for %s", $strName))
		 RunWait(@AutoItExe & ' ' & @WorkingDir & '\Action.au3' & ' '& '"' & @WorkingDir & '\action\NhanSoiNoi.txt"' & ' 2 ' & $strName)
	  Next
   EndIf
   Local $arrRunning = _FileListToArray(@WorkingDir, "*.running", 1)
   For $i = 1 To $arrRunning[0]
	  FileDelete($arrRunning[$i])
   Next
   If Not $isAutoNext Then
	  Local $choice = MsgBox(4, "Choices", "Continue ?")
	  If $choice == $IDNO Then
		 Exit
	  EndIf
   EndIf
EndFunc