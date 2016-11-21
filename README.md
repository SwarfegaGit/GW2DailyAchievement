GW2DailyAchievement
=======
GW2DailyAchievement is a simple PowerShell module to fetch and parse the daily achievement API (https://wiki.guildwars2.com/wiki/API:2/achievements/daily).

Usage
-----

Fetch todays PvE Daily Achievements
```powershell
Get-GW2DailyAchievement
```
Fetch tomorrows PvE Daily Achievements
```powershell
Get-GW2DailyAchievement -Tomorrow
```
Fetch todays PvP Daily Achievements
```powershell
Get-GW2DailyAchievement -Content PvP
```
Fetch todays WvW Daily Achievement when the highest level character in your account is 23
```powershell
Get-GW2DailyAchievement -Content WvW -Level 23
```
Fetch all available Daily Achievements including Special (events such as Wintersday) achievements
```powershell
Get-GW2DailyAchievement -Content All
```
Fetch todays PvE Daily Achievements and get a tip (with waypoint) on the quickest method of completing
```powershell
Get-GW2DailyAchievement | Get-GW2DailyAchievementTip
```
Fetch todays PvE Daily Achievements with tip and save the waypoint to the clipboard ready for pasting into the game (PowerShell v5 required)
```powershell
(Get-GW2DailyAchievement | Get-GW2DailyAchievementTip).Waypoint -join '' | Set-Clipboard
```
