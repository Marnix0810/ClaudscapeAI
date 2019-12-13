'==========================================================================================================================================
' talk and msg version 2
'
' example usage:
'
'
' tlk "i'm alive and i'm here, made by the genius marnix bloeiman who wrote this part in a language he never used before, called VBScript."
'
' (from CMD)
' this was originally meant as part of marnix bloeiman's own-made personal assistants.
'
' Marnix Bloeiman
'
'
'
'
'
'
'
'==========================================================================================================================================
Set objArgs = WScript.Arguments
messageText = objArgs(0)
set speech = Wscript.CreateObject("SAPI.spVoice")
speech.speak messageText
MsgBox messageText
