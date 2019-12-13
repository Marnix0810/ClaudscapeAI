'==========================================================================================================================================
' play mp3 version 1
'
'
' usage:
' 
'
' plmp3 [mp3-file]
'
'
' example usage:
'
'
' plmp3 "im\alive\and\i'm\here,\made\by\the\genius\marnix\bloeiman\who\wrote\this\part\in\a\language\he\never\used\before\called\VBScript.mp3"
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
Set Sound = CreateObject("WMPlayer.OCX.7")
Set objArgs = WScript.Arguments
Sound.URL = objArgs(0)
Sound.Controls.play
Do while Sound.currentmedia.duration = 0
WScript.sleep 100
Loop
WScript.sleep (int(Sound.currentmedia.duration)+1)*1000