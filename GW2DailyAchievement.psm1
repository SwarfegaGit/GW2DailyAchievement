<#
.Synopsis
   Fetch today or tomorrows Daily Achievements.
.DESCRIPTION
   Fetch today or tomorrows Daily Achievements for PvE, PvP, WvW, Special (E.G Halloween).
.EXAMPLE
   Get-GW2DailyAchievement -Tomorrow
   This will return all PvE daily achievements for tomorrow for an account who has a character at level 80.
.EXAMPLE
   Get-GW2DailyAchievement -MaxLevel 31 -Edition GuildWars2 -Content All
   This will return all of todays daily achievements for a non-expansion account thats max character level is 31. The default edition is 'HeartOfThorns'.
.EXAMPLE
   Get-GW2DailyAchievement -Content PvP
   This will return all PvP daily achievements for an account who has a character at level 80 and has the Heart of Thorns expansion.
#>
function Get-GW2DailyAchievement {
    [CmdletBinding()]
    Param(
        $MaxLevel = '80',
        [ValidateSet('GuildWars2', 'HeartOfThorns')]
        $Edition = 'HeartOfThorns',
        [ValidateSet('All', 'PvE', 'PvP', 'WvW', 'Special')]
        $Content = 'PvE',
        [switch]$Tomorrow
    )

    Begin {

        Try {

            switch ($Tomorrow) {
                
                $false { 
                    Write-Verbose -Message "Fecthing daily achievements for $Content for today."
                    $APIv2 = Invoke-RestMethod -Uri https://api.guildwars2.com/v2/achievements/daily -ErrorAction Stop 
                }
                $true { 
                    Write-Verbose -Message "Fecthing daily achievements for $Content for tomorrow."
                    $APIv2 = Invoke-RestMethod -Uri https://api.guildwars2.com/v2/achievements/daily/tomorrow -ErrorAction Stop
                }

            }

        }
        Catch {
            Write-Warning -Message $PSItem.Exception.Message
        }

    }

    Process { 
        
        If ($Content -eq 'All') {
            'pve', 'pvp', 'wvw', 'special' | ForEach-Object {
                $QueryAll = $APIv2.$($PSItem.ToLower()) | Where-Object -FilterScript {
                    $PSItem.required_access -eq $Edition -and $PSItem.level.max -ge $MaxLevel -and $MaxLevel -ge $PSItem.level.min
                } 
                $Query = $Query + $QueryAll
            }
        }
        Else {
            $Query = $APIv2.$($Content.ToLower()) | Where-Object -FilterScript {
                $PSItem.required_access -eq $Edition -and $PSItem.level.max -ge $MaxLevel -and $MaxLevel -ge $PSItem.level.min
            } 
        }
        
        $Query | Foreach-Object { 
    
            $Item = Invoke-RestMethod -Uri "https://api.guildwars2.com/v2/achievements/$($PSItem.id)"

            [PSCustomObject] @{
                PSTypeName = 'AJP.XV5.GW2DailyAchievement'
                Id = $PSItem.id
                Name = $Item.Name
                Description = $Item.description
                Requirement = $Item.requirement
                MinLevelRequired = $PSItem.level.min
                MaxLevelRequired = $PSItem.level.max
                RequiredAccess = $PSItem.required_access
            }

        }

    }

    End {}

}

<#
.Synopsis
   To be used in the pipeline with the Get-GW2DailyAchievement function.
.DESCRIPTION
   To be used in the pipeline with the Get-GW2DailyAchievement function. This will fetch recommended tips on how to quickly complete a 'Miner', 'Forager', 'Lumberer' or 'Vista' daily achievement.
.EXAMPLE
   Get-GW2DailyAchievement | Get-GW2DailyAchievementTip
   This will return a tip on how to quickly complete todays daily achievements. 
.EXAMPLE
   Get-GW2DailyAchievement -Tomorrow | Get-GW2DailyAchievementTip
   This will return a tip on how to quickly complete tomorrows daily achievements. 
.EXAMPLE
   Get-GW2DailyAchievement -MaxLevel 24 -Edition GuildWars2 | Get-GW2DailyAchievementTip
   This will return a tip on how to quickly complete tomorrows daily achievements for an account with a max level character of 24 and owns the base version of the game. 
#>
function Get-GW2DailyAchievementTip {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,
            ValueFromPipelineByPropertyName=$true)]
        $id,
        [Parameter(Mandatory=$true,
            ValueFromPipelineByPropertyName=$true)]
        [string]$Name
    )

    Begin {
        
        #New-Variable -Name Waypoint
        #New-Variable -Name Tip
    
    }

    Process {

        $PSItem | ForEach-Object {

            If ($PSitem.Name -match 'Viewer' -or $PSitem.Name -match 'Forager' -or $PSitem.Name -match 'Lumberer' -or $PSitem.Name -match 'Miner') {

                $switch = switch ($id) {
                
                    # Ascalon
                    1838 { $Waypoint = '[&BMcDAAA=]'; $Tip = "Plains of Ashford -> Loreclaw Waypoint -> South is a potato patch." } # Forager
                    1837 { $Waypoint = '[&BIABAAA=]'; $Tip = "Plains of Ashford -> Run east from Smokestead Waypoint, there to find lots of trees (usually)." } # Lumberer
                    1981 { $Waypoint = '[&BPgGAAA=]'; $Tip = "Plains of Ashford -> Langmar Estate Waypoint -> there is a rich copper vein on the wp." } # Miner
                    1938 { $Waypoint = '[&BIgBAAA=]'; $Tip = "Plains of Ashford -> Watchcrag Tower Waypoint (Up the stairs/ledge)." } # Vista

                    # Heart of Maguuma
                    2912 { $Waypoint = '[&BOAHAAA=]'; $Tip = "Verdant Brink -> Jump north east of the Jaka Itzel waypoint and fall down to the bottom of the map glide at the bottom under the tree." } # Forager
                    0003 { $Waypoint = 'None'; $Tip = "None. Please report if you have a valid tip." } # Lumberer
                    2957 { $Waypoint = 'None'; $Tip = "None. Please report if you have a valid tip." } # Miner
                    2983 { $Waypoint = '[&BOAHAAA=]'; $Tip = "Verdent Brink -> Right next the Jaka Itzel Waypoint." } # Vista

                    # Kryta
                    1975 { $Waypoint = '[&BPoAAAA=]'; $Tip = "Queensdale -> Beetletun Waypoint (CM entrance) -> Run south, you'll find a farm with lots of foraging." } # Forager
                    1972 { $Waypoint = '[&BLIAAAA=]'; $Tip = "Harathi Hinterlands -> Arca Waypoint -> On this land mass there are usually lots of trees if you go South and East respectively." } # Lumberer
                    1971 { $Waypoint = '[&BPMAAAA=]'; $Tip = "Queensdale -> Phinney Waypoint -> North you will find an ettin cave with lots of ore, including a rich copper ore vein." } # Miner
                    1839 { $Waypoint = '[&BPoAAAA=]'; $Tip = "Queensdale -> Beetletun Waypoint" } # Vista - Kryta

                    # Maguuma Jungle
                    1973 { $Waypoint = '[&BEIAAAA=]'; $Tip = "Metrica Province -> Akk Wilds Waypoint -> To the North is a platform with a farm, it is above ground." } # Forager
                    1970 { $Waypoint = '[&BM0BAAA=] [&BM4BAAA=]'; $Tip = "Sparkfly Fen -> Between Darkweather Waypoint, Brackwater Waypont and the portal to Straits of Devastation: usually a few trees." } # Lumberer
                    1969 { $Waypoint = '[&BMkCAAA=]'; $Tip = "Mount Maelstrom -> Criterion Waypoint -> To the west (close to the POI) is a rich platinum vein." } # Miner
                    1931 { $Waypoint = '[&BEQAAAA=]'; $Tip = "Metrica Province -> Atrerium Haven (West, up the tower)." } # Vista

                    # Maguuma Wastes
                    1980 { $Waypoint = '[&BIYHAAA=]'; $Tip = "Dry Top -> North West corner of the map from the Vine Bridge Waypoint." } # Forager
                    1979 { $Waypoint = 'None'; $Tip = "For the Maguuma Wastes, since there is a lack of waypoints, you'll just have to run through Drytop and Silverwastes, I'll update the locations once guaranteed spots are found." } # Lumberer
                    1978 { $Waypoint = 'None'; $Tip = "For the Maguuma Wastes, since there is a lack of waypoints, you'll just have to run through Drytop and Silverwastes, I'll update the locations once guaranteed spots are found." } # Miner
                    1937 { $Waypoint = '[&BH8HAAA=]'; $Tip = "Camp Resolve -> Right next to the waypoint up the stairs." } # Vista
                    
                    # Shiverpeaks
                    1985 { $Waypoint = '[&BFECAAA=]'; $Tip = "Timberline Falls -> Thistlereed Waypoint -> West of this waypoint, you need to go up a hill to the North, you'll find a patch of Califlowers (yes, this waypoint is broken)" } # Forager
                    1968 { $Waypoint = '[&BEYEAAA=]'; $Tip = "Timberline Falls -> Stromkarl waypoint -> direction Stromkarl's heights." } # Lumberer
                    1984 { $Waypoint = '[&BFECAAA=]'; $Tip = "Timberline Falls -> Thistlereed Waypoint -> West of this waypoint in an underwater cave is a rich platinum ore vein (yes, this waypoint is broken)" } # Miner
                    1936 { $Waypoint = '[&BI4DAAA=]'; $Tip = "Hoelbrak -> Southern Watchpost Waypoint (North, one jump)." } # Vista
                    
                    # Orr
                    1974 { $Waypoint = '[&BB8DAAA=]'; $Tip = "Swim in the river of Cursed Shore." } # Forager
                    1976 { $Waypoint = '[&BKYCAAA=]'; $Tip = "Malchor's Leap -> Pagga's Waypoint -> West -> Loads of trees near the statue of Melandru." } # Lumberer
                    1977 { $Waypoint = '[&BKYCAAA=]'; $Tip = "Malchor's Leap -> Pagga's Waypoint -> West -> usually a few mithrils around the cliffs nearby" } # Miner
                    1932 { $Waypoint = '[&BKYCAAA=]'; $Tip = "Malchor's -> Pagga's Waypoint (North up the Mountain)(Other vistas closer to waypoints, but these are usually contested)." } # Vista
                    
                    default { $Waypoint = $null; $Tip = "Tip not found. Report this as a bug quoting ID '$($PSitem.id)'." } 
                }

                [PSCustomObject] @{
                    PSTypeName = 'AJP.XV5.GW2DailyAchievementTips'
                    Id = $PSitem.id
                    Name = $PSitem.Name
                    Waypoint = $Waypoint
                    Tip = $Tip
                }

                #Clear-Variable -Name Waypoint
                #Clear-Variable -Name Tip

            }
            Else {
                
                Write-Verbose -Message "Discarding item '$($PSitem.Name)' as it is not of type 'Miner', 'Forager', 'Lumberer' or 'Vista'."

            }
        }

    }

    End{}

}