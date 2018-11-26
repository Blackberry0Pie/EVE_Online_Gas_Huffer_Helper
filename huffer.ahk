#Include Class_ImageButton.ahk
;Menu, Tray, Icon, F:\coding\AHK\eve_huffer\raw\C60_16.ico
version := "1.0b"
timeSpawn = 900000
minute = 60000
beep = 0
m15 = 0
m5 = 0
m1 = 0
s30 = 0
s10 = 0
sd = 0
game = 0
info_id = 0
global TabNum = 1
overwrite = 0
;test = 0
;testTime := A_NowUTC

SetWorkingDir, %A_AppData%
FileCreateDir, Huffer
SetWorkingDir, Huffer

IniRead, prevVer, settings.ini, version, version, -1
;msgbox, version: %version%`nprevious: %prevver%
if(version <> prevVer)
{
    overwrite = 1
    IniWrite, %version%, settings.ini, version, version
}

FileInstall, resc\15m.wav, 15m.wav, %overwrite%
FileInstall, resc\05m.wav, 05m.wav, %overwrite%
FileInstall, resc\01m.wav, 01m.wav, %overwrite%
FileInstall, resc\30s.wav, 30s.wav, %overwrite%
FileInstall, resc\10s.wav, 10s.wav, %overwrite%
FileInstall, resc\sudden_death.wav, sudden_death.wav, %overwrite%
FileInstall, resc\game_over.wav, game_over.wav, %overwrite%
FileInstall, resc\respawn.wav, respawn.wav, %overwrite%
FileInstall, resc\link_table.png, link_table.png, %overwrite%
FileInstall, resc\probabilities.png, probabilities.png, %overwrite%
FileInstall, resc\info_explanation.png, info_explanation.png, %overwrite%
FileInstall, resc\daily_player_density.png, daily_player_density.png, %overwrite%
FileInstall, resc\sites.png, sites.png, %overwrite%
FileInstall, resc\wormholes_sbs.png, wormholes_sbs.png, %overwrite%
FileInstall, resc\ui_bottombox.png, ui_bottombox.png, %overwrite%
FileInstall, resc\ui_topbar.png, ui_topbar.png, %overwrite%
FileInstall, resc\ui_min.png, ui_min.png, %overwrite%
FileInstall, resc\ui_close.png, ui_close.png, %overwrite%
FileInstall, resc\button.png, button.png, %overwrite%
FileInstall, resc\button_hot.png, button_hot.png, %overwrite%
FileInstall, resc\button_selected.png, button_selected.png, %overwrite%
FileInstall, resc\divider.png, divider.png, %overwrite%
FileInstall, resc\EveSans.ttf, EveSans.ttf, %overwrite%

IniRead, gui_position, settings.ini, position, main, Center

Gui, 1: +Hwndgui_id
global MainHwnd := gui_id
DllCall("Gdi32.dll\AddFontResourceEx", "Str", "EveSans.ttf", "UInt", 0x10, "UInt", 0)
Gui, 1: Font, s10 cWhite, EveSans

Gui, 1: Add, Picture, x90 y4 w15 h15 gGuiMinimize Hidden, ui_min.png
Gui, 1: Add, Picture, x107 y4 w15 h15 gGuiclose Hidden, ui_close.png
Gui, 1: Add, Picture, x0 y0 w123 h19 vPicture guiMove 0x4000000, ui_topbar.png ;0x4000000 makes it play nice with the buttons
Gui, 1: Add, Text, x5 y5 w123 h19 vHeader, Huffing Toolkit
GuiControl, 1:+BackgroundTrans, Header

Gui, 1: Add, Picture, x0 y19 w123 h66, ui_bottombox.png

Gui, 1: Add, Button, x9 y29 h20 w50 vWarp gWarp hwndHBT1, Warp
Opt1 := {1:0, 2:"button.png", 4: 0xFFCBCACA}
Opt2 := {2:"button_hot.png", 4: 0xFFD0D0D0}
Opt3 := {4: 0xFFCACA00}
If !ImageButton.Create(HBT1, Opt1, Opt2, Opt3)
   MsgBox, 0, ImageButton Error Btn1, % ImageButton.LastError

Gui, 1: Font, s12
Gui, 1: Add, Edit, x+5 y29 w50 h20 vGUITime +Center +Disabled -E0x200, % Format("{:.1f}", timeSpawn / 1000 )
Gui, 1: Font, s10

Gui, 1: Add, Button, x9 y+5 h20 w50 vStop gStop hwndHBT3, Stop
Opt1 := {1:0, 2:"button.png", 4: 0xFFCBCACA}
Opt2 := {2:"button_hot.png", 4: 0xFFD0D0D0}
Opt3 := {4: 0xFFCACA00}
If !ImageButton.Create(HBT3, Opt1, Opt2, Opt3)
   MsgBox, 0, ImageButton Error Btn3, % ImageButton.LastError

Gui, 1: Add, Button, x+5 h20 w50 vInfo gInfo hwndHBT4, Tools
Opt1 := {1:0, 2:"button.png", 4: 0xFFCBCACA}
Opt2 := {2:"button_hot.png", 4: 0xFFD0D0D0}
Opt3 := {4: 0xFFCACA00}
If !ImageButton.Create(HBT4, Opt1, Opt2, Opt3)
   MsgBox, 0, ImageButton Error Btn4, % ImageButton.LastError

;Gui, 1: Color, FF00FF
;Gui 1: +LastFound
;WinSet, TransColor, FF00FF

Gui, 1: Color, 000000
Gui, 1: +LastFound 
;WinSet, TransColor, 000000, 200 ;0 ;100
;WinSet, Transparent, 200
Gui, 1: +AlwaysOnTop -Caption ; +Border ;+ToolWindow

Gui, 1: Show, %gui_position% w123 h85
OnMessage("0x200", "MOUSEOVER")
;OnMessage("0x2A2", "MOUSELEAVE")
SetTimer, MOUSELEAVE, 100

;tools gui
IniRead, info_position, settings.ini, position, info, Center
;add class id, link table, gank times
Gui, INFO: +Hwndinfo_id
Gui, INFO: Add, Tab3, vTabNum x0 y0 w537 h293 +AltSubmit, Visual|Link IDs|Link Info|Link Probabilities|Gank Info|Gas ISK/m3|Time to Full|Credits && Links
Gui, INFO: Add, Picture, x0 y19 w537, wormholes_sbs.png
Gui, INFO: Tab, 2
Gui, INFO: Add, Picture, x0 y19 w537 h274, link_table.png ;BackgroundTrans
Gui, INFO: Tab, 3
Gui, INFO: Add, Picture, x0 y19 Center, info_explanation.png
;Gui, INFO: Add, Text, x0 y137 w537 h19 +0x201, PvP COMPARISON NOT YET IMPLEMENTED
Gui, INFO: Tab, 4
Gui, INFO: Add, Picture, x0 y19 Center, probabilities.png
Gui, INFO: Tab, 5
FormatTime, CurrentTimeUTC, %A_NowUTC%, HH:mm
FormatTime, CurrentDayUTC, %A_NowUTC%, dddd
pictureMinutes := 60 * Substr(CurrentTimeUTC,1,2) + Substr(CurrentTimeUTC,4,2)
pictureOffset := Mod(265 - (531 / (24 * 60) * pictureMinutes), 531)
secondaryOffset := pictureOffset < 0 ? 531 + pictureOffset : -531 + pictureOffset
Gui, INFO: Add, Picture, x%secondaryOffset% y23 vSecondaryDensity, daily_player_density.png
Gui, INFO: Add, Picture, x%pictureOffset% y23 vPrimaryDensity, daily_player_density.png
Gui, INFO: Add, Picture, x269 y19 vDensityDivider, divider.png
Gui, INFO: Font, cWhite
Gui, INFO: Add, Text, x165 y42 w100 h19 vCurrentTimeUTC Right, %CurrentTimeUTC% ;+0x201
Gui, INFO: Add, Text, x274 y42 w100 h19 vCurrentDayUTC, %CurrentDayUTC%
Gui, INFO: Font, cBlack
GuiControl, INFO: +BackgroundTrans, CurrentTimeUTC
GuiControl, INFO: +BackgroundTrans, CurrentDayUTC
SetTimer, UpdateTime, 60000 ;6000 testing
Gui, INFO: Tab, 6
Gui, INFO: Add, Picture, x0 y19 w537, sites.png
Gui, INFO: Font, cRed
Gui, INFO: Add, Text, x0 y19 w537 h19 +0x201, ESTIMATIONS based on market values 8/17/2018:
Gui, INFO: Font, cBlack
;Gui, INFO: Add, Text, y+0 w537 h19 +0x201, I'll add market checking functionality later. Maybe.
Gui, INFO: Tab, 7


Gui, INFO: Add, Text,, Gas Harvester Amount:
IniRead, NumHarvester, settings.ini, harvest, NumHarvester, 2
Gui, INFO: Add, DropDownList, x+5 w35 vNumHarvester gUpdateHarvest Choose%NumHarvester%, 1|2

Gui, INFO: Add, Text, x+20, Using Mining Frigate:
IniRead, Frigate, settings.ini, harvest, Frigate, YES
Frigate := Frigate = "YES" ? 1 : 2
Gui, INFO: Add, DropDownList, x+5 w50 vFrigate gUpdateHarvest Choose%Frigate%, YES|NO
Gui, INFO: Add, Text, x+15, Harvest Rate:
IniRead, MiningRate, settings.ini, harvest, rate, 0
Gui, INFO: Add, Edit, x+5 w50 vMiningRate +ReadOnly, % Format("{:.4f}", MiningRate)
Gui, INFO: Add, Text, x+5, m3/s

Gui, INFO: Add, Text, x53 y+15, Harvester Tier:
IniRead, HarvestTier, settings.ini, harvest, HarvestTier, T2
HarvestTier := HarvestTier = "T2" ? 2 : 1
Gui, INFO: Add, DropDownList, x+4 w40 vHarvestTier gUpdateHarvest Choose%HarvestTier%, T1|T2
Gui, INFO: Add, Text, x+16, Mining Frigate Level:
IniRead, FrigateLevel, settings.ini, harvest, FrigateLevel, 3

Gui, INFO: Add, DropDownList, x+5 w35 vFrigateLevel gUpdateHarvest Choose%FrigateLevel%, 1|2|3|4|5
Gui, INFO: Add, Text, x+52, Capacity:
IniRead, Capacity, settings.ini, harvest, capacity, 5000
Gui, INFO: Add, Edit, x+5 w50 vCapacity gUpdateHarvest +Number, % Format("{:.2f}", Capacity )
Gui, INFO: Add, Text, x+5, m3

Gui, INFO: Add, Text, x43 y+15, Gas Implant Tier:
IniRead, ImplantTier, settings.ini, harvest, ImplantTier, 0
ImplantTier := ImplantTier = "T3" ? 4 : ImplantTier = "T2" ? 3 : ImplantTier = "T1" ? 2 : 1
Gui, INFO: Add, DropDownList, x+4 w40 vImplantTier gUpdateHarvest Choose%ImplantTier%, 0|T1|T2|T3
Gui, INFO: Add, Text, x+211, Loaded:
IniRead, Loaded, settings.ini, harvest, loaded, 0
Gui, INFO: Add, Edit, x+5 w50 vLoaded gUpdateHarvest +Number, % Format("{:.2f}", Loaded )
Gui, INFO: Add, Text, x+5, m3

Gui, INFO: Font, s16
Gui, INFO: Add, Text, x0 y+30 w537 h29 +0x201, Mining Time Until Full:
Gui, INFO: Font, s64
IniRead, Remaining, settings.ini, harvest, remaining, 000:00
Gui, INFO: Add, Edit, x130 y+10 w277 h100 vRemaining +Disabled +0x201, %Remaining%
Gui, INFO: Font, s8


Gui, INFO: Tab, 8
Gui, INFO: Add, Text,, CREDITS:
Gui, INFO: Add, Text, y+5, Announcer: Jeff Steitzer, Halo Series
Gui, INFO: Add, Link, y+5, Link IDs: <a href="http://anoik.is/wormholes">anoik.is</a>
Gui, INFO: Add, Link, y+5, Link Info(PvP section): Shawn Shadrix, using data from: <a href="https://www.reddit.com/r/Eve/comments/4qp8sr/wh_stats_summary_june_2016/">www.reddit.com/r/Eve</a> by TurnLeftAtThePossum.
Gui, INFO: Add, Link, y+5, Link Probabilities: Shawn Shadrix, using community data compiled at: <a href="https://www.fuzzwork.co.uk/evelopedia/index.php/List_of_All_W-Space_Systems">fuzzwork.co.uk</a>
Gui, INFO: Add, Link, y+5, Gank Info: edited from an <a href="http://www.eve-offline.net/?server=tranquility">EVE Offline</a> daily chart. ;<a href="https://k162space.com/2012/10/15/highsec-freighter-gank-statistics/">k162space.com</a>(2012)
Gui, INFO: Add, Text, y+5, This program and most other things used in it by: Shawn Shadrix.
Gui, INFO: Add, Text, y+25, LINKS:
;Gui, INFO: Add, Link, y+5, My Video Guides: COMING SOON.
Gui, INFO: Add, Link, y+5, Guides: <a href="http://www.tigerears.org/guides/">TigerEars</a>, <a href="https://wiki.eveuniversity.org/Wormhole_Space">EVE Uni Wormhole Space</a>
Gui, INFO: Add, Link, y+5, Spreadsheets: <a href="https://www.fuzzwork.co.uk/ore/gas.html?region=10000002">fuzzwork ISK/m3</a>, <a href="https://docs.google.com/spreadsheets/d/1tMjTWl-6ZgKD_WwzF_CfIL3eGdGAV7VjoZA8dyjLlpU/edit?usp=sharing">Gas Sites</a>, <a href="https://docs.google.com/spreadsheets/u/1/d/17cNu8hxqJKqkkPnhDlIuJY-IT6ps7kTNCd3BEz0Bvqs/pubhtml#">Rykki's Guides: Wormhole PvE</a>
Gui, INFO: Add, Link, y+5, Videos: <a href="https://youtu.be/6miRA8vCLmE?list=PLBD59459E625C2A27">WF 1.0 - Asayanami Dei</a>, <a href="https://youtu.be/U3Qs_0ggZVM?list=PLFG0PnPrUYRJlb4fzjOAUuu3NOEzJOYpw">WF 2.0 - Asayanami Dei</a>, <a href="https://youtu.be/wErCHjNTsRA?list=PL5GQsDr656AEEZwSBklFvnCoX96q4iq5v">Exploration Tutorials - Should Be Stopped</a>
Gui, INFO: Add, Link, y+5, Mapping Tool: <a href="https://www.pathfinder-w.space/">Pathfinder</a>
;ending gui stuffs
Gui, INFO: +ToolWindow +AlwaysOnTop

;choose tab
IniRead, tab, settings.ini, position, tab, 1
guicontrol, INFO:choose, TabNum, %tab%
return

;MOUSEOVER()
;{
;    GuiControl, 1:Show, ui_close.png
;    GuiControl, 1:Show, ui_min.png
;}

;MOUSELEAVE()
;{
;    GuiControl, 1:Hide, ui_close.png
;    GuiControl, 1:Hide, ui_min.png
;}

MOUSEOVER(){
	MouseGetPos, , , Hwnd
	if(Hwnd = MainHwnd){
		GuiControl, 1:Show, ui_close.png
        GuiControl, 1:Show, ui_min.png
	}
}

MOUSELEAVE(){
	MouseGetPos, , , Hwnd
	if(Hwnd != MainHwnd){
		GuiControl, 1:Hide, ui_close.png
        GuiControl, 1:Hide, ui_min.png
	}
}

uiMove:
  PostMessage, 0xA1, 2,,, A ;click and drag this control to move the window
return

;called from button g-label
Info:
    WinGetPos, info_x, info_y,,, ahk_id %info_id%
    if(info_x && info_y)
        IniWrite, x%info_x% y%info_y%, settings.ini, position, info
    IniRead, info_position, settings.ini, position, info, Center
    Gui, INFO: Show, %info_position% w537 h293, Tools
return

UpdateHarvest:
    Gui, INFO:Submit, NoHide
    frigateMod := Frigate = "YES" ? 2 / ( 1 - 0.05 * FrigateLevel ) : 1
    HarvesterMod := HarvestTier = "T2" ? 1/2 : 1/3
    ImplantMod := ImplantTier = "T3" ? 0.95 : ImplantTier = "T2" ? 0.97 : ImplantTier = "T1" ? 0.99 : 1
    MiningRate := frigateMod * NumHarvester * HarvesterMod / ImplantMod
    GuiControl, INFO:, MiningRate, %MiningRate%
    TotalTimeSecondsFloat := ( Capacity - Loaded ) / MiningRate
    ttMinsInt := Format("{:3u}", Floor(TotalTimeSecondsFloat / 60))
    ttSecsInt := Format("{:02u}", Mod(TotalTimeSecondsFloat, 60))
    Remaining = %ttMinsInt%:%ttSecsInt%
    GuiControl, INFO:, Remaining, %Remaining%
    IniWrite, %MiningRate%, settings.ini, harvest, rate
    IniWrite, %Capacity%, settings.ini, harvest, capacity
    IniWrite, %Loaded%, settings.ini, harvest, loaded
    IniWrite, %Remaining%, settings.ini, harvest, remaining
    
    IniWrite, %NumHarvester%, settings.ini, harvest, NumHarvester
    IniWrite, %Frigate%, settings.ini, harvest, Frigate
    IniWrite, %HarvestTier%, settings.ini, harvest, HarvestTier
    IniWrite, %FrigateLevel%, settings.ini, harvest, FrigateLevel
    IniWrite, %ImplantTier%, settings.ini, harvest, ImplantTier
return

;^w::
Warp:
    beep = 0
    m15 = 0
    m5 = 0
    m1 = 0
    s30 = 0
    s10 = 0
    sd = 0
    game = 0
    initial_time := A_TickCount
    SetTimer, TeleportTimer, 50
Return

GuiMinimize:
    Gui, 1: Minimize
return

GuiClose:
    Gui, 1: Restore ;briefly restore the window before saving the position
    WinGetPos, gui_x, gui_y ;,,, ahk_id %gui_id%
    if(gui_x && gui_y)
        IniWrite, x%gui_x% y%gui_y%, settings.ini, position, main
    ExitApp
Return

;INFOGuiEscape:
;INFOButtonCancel:
INFOGuiClose:
    Gui, INFO:Submit
    WinGetPos, info_x, info_y ;,,, ahk_id %info_id%
    if(info_x && info_y)
        IniWrite, x%info_x% y%info_y%, settings.ini, position, info
    IniWrite, %TabNum%, settings.ini, position, tab
    
    Gui, INFO: Hide
Return

TeleportTimer:
    tInterval := A_TickCount - initial_time
    timeRemaining := timeSpawn - tInterval
    If(timeRemaining <= 15 * minute)
    {
        if(m15 == 0)
        {
            m15 = 1
            SoundPlay, 15m.wav
        }
        If(timeRemaining <= 5 * minute)
        {
            if(m5 == 0)
            {
                m5 = 1
                SoundPlay, 05m.wav
            }
            If(timeRemaining <= 1 * minute)
            {
                if(m1 == 0)
                {
                    m1 = 1
                    SoundPlay, 01m.wav
                }
                If(timeRemaining <= 30000)
                {
                    if(s30 == 0)
                    {
                        s30 = 1
                        SoundPlay, 30s.wav
                    }
                    If(timeRemaining <= 10000)
                    {
                        if(s10 == 0)
                        {
                            s10 = 1
                            SoundPlay, 10s.wav
                        }
                        If(timeRemaining <= 3000)
                        {
                            if(beep == 0)
                            {
                                beep = 1
                                SoundPlay, respawn.wav
                            }
                            If(timeRemaining < -300)
                            {
                                if(sd == 0)
                                {
                                    sd = 1
                                    SoundPlay, sudden_death.wav
                                }
                                If(timeRemaining < -5 * minute)
                                {
                                    if(game == 0)
                                    {
                                        game = 1
                                        SoundPlay, game_over.wav
                                    }
                                    gosub, Stop
                                    return
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    ;Gui, 1: Font, s20
    GuiControl, 1: , GUITime, % Format("{:.1f}", timeRemaining / 1000 )
    ;Gui, 1: Font, s8
return

;^e::
Stop:
    SetTimer, TeleportTimer, Off
    ;Gui, 1: Font, s20
    GuiControl, 1: , GUITime, % Format("{:.1f}", timeSpawn / 1000 )
    ;Gui, 1: Font, s8
return

UpdateTime:
    ;testTime += 1, Hours
    ;test++
    
    FormatTime, CurrentTimeUTC, %A_NowUTC%, HH:mm
    FormatTime, CurrentDayUTC, %A_NowUTC%, dddd
    pictureMinutes := 60 * Substr(CurrentTimeUTC,1,2) + Substr(CurrentTimeUTC,4,2)
    pictureOffset := Mod(265 - (531 / (24 * 60) * pictureMinutes), 531)
    secondaryOffset := pictureOffset < 0 ? 531 + pictureOffset : -531 + pictureOffset

    GuiControl, INFO: MoveDraw, SecondaryDensity, x%secondaryOffset%
    GuiControl, INFO: MoveDraw, PrimaryDensity, x%pictureOffset%

    GuiControl, INFO:, CurrentTimeUTC, %CurrentTimeUTC%
    GuiControl, INFO:, CurrentDayUTC, %CurrentDayUTC%
return

;^r::
;    reload
;return
