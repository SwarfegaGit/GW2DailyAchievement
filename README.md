# GW2DailyAchievement

GW2DailyAchievement is a simple PowerShell module to fetch and parse the daily achievement [API](https://wiki.guildwars2.com/wiki/API:2/achievements/daily).

## Installation via the PowerShell Gallery

```powershell
Install-Module GW2DailyAchievement
```

## Usage

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
Get-GW2DailyAchievement -Content WvW -MaxLevel 23
```

Fetch all available Daily Achievements including Special (events such as Wintersday) achievements

```powershell
Get-GW2DailyAchievement -Content All
```

Fetch todays PvE Daily Achievements and get a tip (with waypoint) on the quickest method of completing. Use Format-Table to wrap the often lengthy Tip property

```powershell
Get-GW2DailyAchievement | Get-GW2DailyAchievementTip | Format-Table -Wrap
```

Fetch todays PvE Daily Achievements with tip and save the waypoint to the clipboard ready for pasting into the game (PowerShell v5 required)

```powershell
Get-GW2DailyAchievement | Get-GW2DailyAchievementTip -OutVariable GW2 | Format-Table -Wrap ; ($GW2).Waypoint | Set-Clipboard
```

(Pre-PowerShell v5)

```powershell
Get-GW2DailyAchievement | Get-GW2DailyAchievementTip -OutVariable GW2 | Format-Table -Wrap ; ($GW2).Waypoint | clip
```

## Build status of master branches

| Travis CI |
|--------------------------|
| [![tv-image][]][tv-site] |

[tv-image]: https://travis-ci.org/SwarfegaGit/GW2DailyAchievement.svg?branch=master
[tv-site]: https://travis-ci.org/SwarfegaGit/GW2DailyAchievement