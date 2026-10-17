Set WshShell = CreateObject("WScript.Shell")
Set FSO = CreateObject("Scripting.FileSystemObject")
ScriptDir = FSO.GetParentFolderName(WScript.ScriptFullName)
GuardianScript = ScriptDir & "\os-guardian.ps1"

' Run PowerShell completely hidden (window style 0, non-blocking)
WshShell.Run "powershell.exe -NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File """ & GuardianScript & """", 0, False
