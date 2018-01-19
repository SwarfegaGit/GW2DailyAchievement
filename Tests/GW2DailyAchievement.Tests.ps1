$root = (Resolve-Path $PSScriptRoot\..\..).Path
$outFolder = "$root\out"

Import-Module $outFolder\GW2DailyAchievement -Force

Describe 'GW2DailyAchievement Tests' {

    Context 'Get-GW2DailyAchievement Tests' {

        It 'Use default parameters' {
            Get-GW2DailyAchievement | Should Not BeNullOrEmpty
        }

        It 'Custom parameter Tomorrow' {
            Get-GW2DailyAchievement -Tomorrow | Should Not BeNullOrEmpty
        }

        It 'Custom parameter MaxLevel' {
            Get-GW2DailyAchievement -MaxLevel 21 | Should Not BeNullOrEmpty
        }

        It 'Custom parameter Content' {
            Get-GW2DailyAchievement -Content WvW, PvP | Should Not BeNullOrEmpty
        }

        It 'Set Edition to Base' {
            Get-GW2DailyAchievement -Edition GuildWars2 | Should Not BeNullOrEmpty
        }

        It 'Set Edition to HeartOfThorns' {
            Get-GW2DailyAchievement -Edition HeartOfThorns | Should Not BeNullOrEmpty
        }

        It 'Set Edition to PathOfFire' {
            Get-GW2DailyAchievement -Edition PathOfFire | Should Not BeNullOrEmpty
        }

    }

    Context 'Get-GW2DailyAchievementTip Tests' {

        It 'No custom parameters' {
            Get-GW2DailyAchievement | Get-GW2DailyAchievementTip | Should Not BeNullOrEmpty
        }

        It 'Custom parameter Edition' {
            Get-GW2DailyAchievement -Edition GuildWars2 | Get-GW2DailyAchievementTip | Should Not BeNullOrEmpty
        }

        It 'Custom parameter MaxLevel' {
            Get-GW2DailyAchievement -MaxLevel 32 | Get-GW2DailyAchievementTip | Should Not BeNullOrEmpty
        }

        It 'Custom parameter MaxLevel, Edition and Tomorrow' {
            Get-GW2DailyAchievement -MaxLevel 32 -Edition GuildWars2 -Tomorrow | Get-GW2DailyAchievementTip | Should Not BeNullOrEmpty
        }

    }

    Context 'Get-GW2DailyFractals Tests' {

        It 'No custom parameters' {
            Get-GW2DailyFractals | Should Not BeNullOrEmpty
        }

    }

    Context 'Get-GW2DailyFractalsReward Tests' {

        It 'No custom parameters' {
            Get-GW2DailyFractals | Get-GW2DailyFractalsReward | Should Not BeNullOrEmpty
        }

    }

}