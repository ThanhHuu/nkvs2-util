#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.2
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------
#include <SQLite.au3>
#include <File.au3>
#RequireAdmin

; Script Start - Add your code below here
Local $func = $CmdLine[1]; 0 or 1
Call($func)

Func Lock()
   _SQLite_Startup("sqlite3.dll", true, 0)
   Local $db = _SQLite_Open(@WorkingDir & "\lock.db")
   While _SQLite_Exec($db, 'INSERT INTO Lock("Name") VALUES ("Locking")') <> 0
	  Sleep(1000)
   WEnd
   _SQLite_Close($db)
   _SQLite_Shutdown()
EndFunc

Func UnLock()
   _SQLite_Startup("sqlite3.dll", true, 0)
   _SQLite_Open(@WorkingDir & "\lock.db")
   Local $db = _SQLite_Open(@WorkingDir & "\lock.db")
   While True
	  Local $count
	  _SQLite_Exec($db, 'DELETE FROM Lock')
	  _SQLite_QuerySingleRow($db, 'SELECT COUNT(1) FROM Lock', $count)
	  If $count[0] < 1 Then
		 ExitLoop
	  EndIf
	  Sleep(1000)
   WEnd
   _SQLite_Close($db)
   _SQLite_Shutdown()
EndFunc
