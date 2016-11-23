Import-Module $PSScriptRoot\..\GW2DailyAchievement -Force

Describe "Get-GW2DailyAchievement PS$PSVersion Integrations tests" {

    It 'Should not error' {
        Get-GW2DailyAchievement | Should Not BeNullOrEmpty
    }

    It 'Tomorrow - Should not error' {
        Get-GW2DailyAchievement -Tomorrow | Should Not BeNullOrEmpty
    }

     It 'Edition and Tip Should not error' {
        Get-GW2DailyAchievement -Edition GuildWars2 | Get-GW2DailyAchievementTip | Should Not BeNullOrEmpty
    }

     It 'Level 21 - Should not error' {
        Get-GW2DailyAchievement -MaxLevel 21 | Should Not BeNullOrEmpty
    }

     It 'WvW - Should not error' {
        Get-GW2DailyAchievement -Content WvW | Should Not BeNullOrEmpty
    }

}