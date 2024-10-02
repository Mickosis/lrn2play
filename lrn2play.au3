#RequireAdmin
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Res_Description=Ragnarok Online Automated Farming System
#AutoIt3Wrapper_Res_Fileversion=1.0.0.5
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=p
#AutoIt3Wrapper_Res_LegalCopyright=© 2017 Mickosis. All rights reserved.
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#AutoIt3Wrapper_Run_Tidy=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <String.au3>
#include <AutoItConstants.au3>
#include <INet.au3>

Global $WALKTOTELE = 0
Global $FLYWINGCHECK
Global $WALKTOTELEINPUT
Global $PASSWORDINPUT
Global $EMOTEINPUT
Global $STOPPED
Global $EMOTICONCOUNT
Global $WALKFUNC = [WalkUp, WalkDown, WalkLeft, WalkRight, WalkUpperLeft, WalkUpperRight, WalkLowerLeft, WalkLowerRight]
HotKeySet("{HOME}", "Start")
HotKeySet("{END}", "_Exit")
HotKeySet("{INS}", "Stop")

#Region ### START Koda GUI section ###
$Form1_1 = GUICreate("lrn2play", 354, 279, 320, 169)
$btnStart = GUICtrlCreateButton("Start (HOME)", 48, 216, 113, 41, $WS_GROUP)
$btnStop = GUICtrlCreateButton("Stop (INSERT)", 184, 216, 113, 41, $WS_GROUP)
$Output = GUICtrlCreateLabel("", 8, 56, 4, 4)
$Label1 = GUICtrlCreateLabel("lrn2play", 120, 8, 119, 46)
GUICtrlSetFont(-1, 26, 400, 0, "Calibri")
$Label2 = GUICtrlCreateLabel("Pwned by @Mickosis", 128, 56, 102, 17)
GUICtrlSetFont(-1, 8, 400, 0, "Calibri")
$PWTextBox = GUICtrlCreateInput("", 72, 96, 121, 21, $ES_PASSWORD)
$Teleport = GUICtrlCreateGroup("Teleport", 216, 80, 121, 121)
$TeleSkill = GUICtrlCreateRadio("Teleport (Skill)", 224, 152, 113, 25)
GUICtrlSetState(-1, $GUI_CHECKED)
$FlyWing = GUICtrlCreateRadio("Fly Wing", 224, 176, 113, 17)
$Label3 = GUICtrlCreateLabel("Walks before Teleport", 224, 104, 109, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$WTTextBox = GUICtrlCreateInput("15", 224, 128, 105, 21, $ES_NUMBER)
$Label4 = GUICtrlCreateLabel("Password", 16, 96, 50, 17)
$EmoteTextBox = GUICtrlCreateInput("8", 104, 120, 89, 21, $ES_NUMBER)
$EmoteLabel = GUICtrlCreateLabel("Walks to Emote", 16, 128, 79, 17)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $btnStart
			Sleep(500)
			Start()
		Case $btnStop
			Sleep(500)
			Stop()
	EndSwitch
WEnd

Func Start()
	$STOPPED = 1
	$PASSWORDINPUT = GUICtrlRead($PWTextBox)
	$WALKTOTELEINPUT = GUICtrlRead($WTTextBox)
	$EMOTEINPUT = GUICtrlRead($EmoteTextBox)

	If $STOPPED = 1 Then
		While $STOPPED = 1
			If WinExists("Ragnarok") Then
				Battle()
			Else
				MouseMove(977, 38, 0)
				MouseClick($MOUSE_CLICK_LEFT)
				MouseClick($MOUSE_CLICK_LEFT)
				Sleep(2000)
			EndIf
		WEnd
	EndIf
EndFunc   ;==>Start

Func Battle()
	Call("Potion")
	WinActivate("Ragnarok")
	$DISCONNECT = PixelSearch(0, 0, @DesktopWidth, @DesktopHeight, 10872642)

	If IsArray($DISCONNECT) Then
		MouseClick("Primary", $DISCONNECT[0] + 0, $DISCONNECT[1] + 0, 5, 0)
		Sleep(100)
		Return
	EndIf
	
	$LOOTER = PixelSearch(341, 245, 490, 400, 8667788)
	$MOBS = [
		PixelSearch(358, 259, 451, 366, 65280),
		PixelSearch(188, 227, 309, 458, 65280),
		PixelSearch(195, 212, 342, 597, 65280),
		PixelSearch(354, 361, 445, 592, 65280),
		PixelSearch(465, 206, 64, 594, 65280),
		PixelSearch(646, 194, 796, 594, 65280),
		PixelSearch(248, 73, 664, 257, 65280),
		PixelSearch(30, 227, 201, 603, 65280)
	]

	For $i = 0 To UBound($MOBS) - 1
		If IsArray($MOBS[$i]) Then
			Sleep(100)
			MouseClick("Primary", $MOBS[$i][0] + 25, $MOBS[$i][1] + 25, 3, 0)
			Return
		EndIf
	Next

	$LOGINFLAG = PixelSearch(0, 0, @DesktopWidth, @DesktopHeight, 16711812)
	If IsArray($LOGINFLAG) Then
		Call("Login")
		Return
	EndIf
	
	Call("Potion")
	Call("Walk")
EndFunc   ;==>Battle

Func Potion()
	$HEAL = PixelSearch(0, 0, 137, 78, 13553366)
	If IsArray($HEAL) Then
		Send("{F8}")
		Sleep(150)
	EndIf
EndFunc   ;==>Potion

Func Walk()
	$EMOTICONCOUNT += 1
	If $EMOTICONCOUNT >= $EMOTEINPUT Then
		Send("!1")
		$EMOTICONCOUNT = 0
	EndIf
	$WALKFUNC[Random(0, 7, 1)]()
EndFunc   ;==>Walk

Func Teleport()
	$FLYWINGCHECK = GUICtrlRead($FlyWing)
	If $FLYWINGCHECK = 1 Or $WALKTOTELE = $WALKTOTELEINPUT Then
		Sleep(300)
		Send("{F9}")
		Sleep(1000)
		$WALKTOTELE = 0
	Else
		If $WALKTOTELE = $WALKTOTELEINPUT Then
			Sleep(300)
			Send("{F9}")
			Sleep(1500)
			Send("{ENTER}")
			Sleep(2000)
			$WALKTOTELE = 0
		EndIf
	EndIf
EndFunc   ;==>Teleport

Func Stop()
	$PASSWORDINPUT = 0
	$WALKTOTELEINPUT = 0
	$STOPPED = 0
EndFunc   ;==>Stop

Func _Exit()
	Exit
EndFunc   ;==>_Exit

Func Walk($x, $y)
	Global $WALKCOUNT = 0
	Do
		Send("{SPACE}")
		MouseMove($x, $y, 5)
		Sleep(100)
		MouseClick("Primary", $x, $y, 5, 0)
		Sleep(100)
		$WALKCOUNT += 1
		$WALKTOTELE += 1
		Call("Teleport")
	Until $WALKCOUNT = 3
EndFunc   ;==>Walk

Func WalkUp() Walk(406, 169) EndFunc   ;==>WalkUp
Func WalkDown() Walk(405, 514) EndFunc ;==>WalkDown
Func WalkLeft() Walk(206, 321) EndFunc ;==>WalkLeft
Func WalkRight() Walk(629, 320) EndFunc ;==>WalkRight
Func WalkUpperLeft() Walk(232, 227) EndFunc ;==>WalkUpperLeft
Func WalkUpperRight() Walk(562, 227) EndFunc ;==>WalkUpperRight
Func WalkLowerLeft() Walk(232, 418) EndFunc ;==>WalkLowerLeft
Func WalkLowerRight() Walk(562, 418) EndFunc ;==>WalkLowerRight
