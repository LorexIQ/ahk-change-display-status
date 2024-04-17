; nircmdc - required (Download: https://www.nirsoft.net/utils/nircmd-x64.zip)

; Config
MonitorID := 1
TVID := 2
ScenarioOnID := ""
ScenarioOffID := ""
YOAuthKey := ""
IsTakeMainMonitor := false

Gui, Add, Text, x12 y9 w190 h20 +Center, Выберите режим работы скрипта
Gui, Add, Button, x12 y39 w90 h30 , Выключить
Gui, Add, Button, x112 y39 w90 h30 , Включить
Gui, Add, CheckBox, x22 y69 w180 h30 vIsTakeMainMonitor gSubmit_All, `  Делать дисплей главным
Gui, Show, h100 w214, CDS
Gui, Submit, NoHide
Return

ButtonВыключить:
{
	TrayTip Выключение, Второй дисплей выключается, ожидайте!
	SendRequestToYandex(ScenarioOffID, YOAuthKey)
	ChangeDisplayStatus("off", MonitorID, IsTakeMainMonitor)
	ExitApp
}

ButtonВключить:
{
	TrayTip Включение, Второй дисплей включается, ожидайте!
	SendRequestToYandex(ScenarioOnID, YOAuthKey)
	ChangeDisplayStatus("on", TVID, IsTakeMainMonitor)
	ExitApp
}

GuiClose:
{
	ExitApp
	Return
}
	
Submit_All:
{
	Gui, Submit, NoHide
	return
}
	

SendRequestToYandex(ScenarioId, YOAuthKey) {
	RequestUrl := "https://api.iot.yandex.net/v1.0/scenarios/" ScenarioId "/actions"
	Authorization := "Bearer " YOAuthKey
	
	oWhr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	oWhr.Open("POST", RequestUrl, false)
	oWhr.SetRequestHeader("Content-Type", "application/json")
	oWhr.SetRequestHeader("Authorization", Authorization)
	oWhr.Send()
	Return oWhr.ResponseText
}

SetMainDisplay(DisplayIdToMain) {
	Run, nircmdc setprimarydisplay %DisplayIdToMain%
	Gui, Cancel
}

ChangeDisplayStatus(Mode, DisplayIdToMain, IsTakeMainMonitor) {
	If Mode = off
	{
		SetMainDisplay(DisplayIdToMain)
		sleep 1000
		Run, displayswitch /internal
		return
	}
	If Mode = on
	{
		Run, displayswitch /extend
		sleep 1000
		If IsTakeMainMonitor = 1
			SetMainDisplay(DisplayIdToMain)
		return
	}
}