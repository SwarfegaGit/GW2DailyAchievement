function Get-GW2DailyAchievement {
    [CmdletBinding()]
    Param(
        $MaxLevel = '80',
        [ValidateSet('GuildWars2', 'HeartOfThorns')]
        $Edition = 'HeartOfThorns',
        [ValidateSet('PvE', 'PvP', 'WvW', 'Special')]
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
        
        $APIv2.$($Content.ToLower()) | Where-Object -FilterScript {
                $PSItem.required_access -eq $Edition -and $PSItem.level.max -ge $MaxLevel -and $MaxLevel -ge $PSItem.level.min
        } | Foreach-Object { 
    
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
        
        New-Variable -Name Waypoint
        New-Variable -Name Tip
    
    }

    Process {

        If ($Name -match 'Viewer' -or $Name -match 'Forager' -or $Name -match 'Lumberer' -or $Name -match 'Miner') {

            $switch = switch ($id) {
            
                # Ascalon
                0001 { $Waypoint = '[&BMcDAAA=]'; $Tip = "Plains of Ashford -> Loreclaw Waypoint -> South is a potato patch." } # Forager
                0002 { $Waypoint = '[&BIABAAA=]'; $Tip = "Plains of Ashford -> Run east from Smokestead Waypoint, there to find lots of trees (usually)." } # Lumberer
                1981 { $Waypoint = '[&BPgGAAA=]'; $Tip = "Plains of Ashford -> Langmar Estate Waypoint -> there is a rich copper vein on the wp." } # - Miner
                1938 { $Waypoint = '[&BIgBAAA=]'; $Tip = "Plains of Ashford -> Watchcrag Tower Waypoint (Up the stairs/ledge)." } # Vista

                # Heart of Maguuma
                2912 { $Waypoint = '[&BOAHAAA=]'; $Tip = "Verdant Brink -> Jump north east of the Jaka Itzel waypoint and fall down to the bottom of the map glide at the bottom under the tree." } # Forager
                0003 { $Waypoint = 'None Yet'; $Tip = "None Yet." } # Lumberer
                0004 { $Waypoint = 'None Yet'; $Tip = "None Yet." } # Miner
                0005 { $Waypoint = 'None Yet'; $Tip = "None Yet." } # Vista

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
                1979 { $Waypoint = 'None Yet'; $Tip = "For the Maguuma Wastes, since there is a lack of waypoints, you'll just have to run through Drytop and Silverwastes, I'll update the locations once guaranteed spots are found." } # Lumberer
                1978 { $Waypoint = 'None Yet'; $Tip = "For the Maguuma Wastes, since there is a lack of waypoints, you'll just have to run through Drytop and Silverwastes, I'll update the locations once guaranteed spots are found." } # Miner
                1937 { $Waypoint = '[&BH8HAAA=]'; $Tip = "SW -> Camp Resolve (West, one tricky jump at the Office Post)." } # Vista
                
                # Shiverpeaks
                1985 { $Waypoint = '[&BFECAAA=]'; $Tip = "Timberline Falls -> Thistlereed Waypoint -> West of this waypoint, you need to go up a hill to the North, you'll find a patch of Califlowers (yes, this waypoint is broken)" } # Forager
                1968 { $Waypoint = '[&BEYEAAA=]'; $Tip = "Timberline Falls -> Stromkarl waypoint -> direction Stromkarl's heights." } # Lumberer
                1984 { $Waypoint = '[&BFECAAA=]'; $Tip = "Timberline Falls -> Thistlereed Waypoint -> West of this waypoint in an underwater cave is a rich platinum ore vein (yes, this waypoint is broken)" } # Miner
                1936 { $Waypoint = '[&BI4DAAA=]'; $Tip = "Hoelbrak -> Southern Watchpost Waypoint (North, one jump)." } # Vista
                
                # Orr
                0006 { $Waypoint = ''; $Tip = "Swim in the river of Cursed Shore." } # Forager
                1976 { $Waypoint = '[&BKYCAAA=]'; $Tip = "Malchor's Leap -> Pagga's Waypoint -> West -> Loads of trees near the statue of Melandru." } # Lumberer
                1977 { $Waypoint = '[&BKYCAAA=]'; $Tip = "Malchor's Leap -> Pagga's Waypoint -> West -> usually a few mithrils around the cliffs nearby" } # Miner
                1932 { $Waypoint = '[&BKYCAAA=]'; $Tip = "Malchor's -> Pagga's Waypoint (North up the Mountain)(Other vistas closer to waypoints, but these are usually contested)." } # Vista
                
                default { $Waypoint = $null; $Tip = "Tip not found. Report this as a bug quoting ID '$id'." } 
            }

            [PSCustomObject] @{
                PSTypeName = 'AJP.XV5.GW2DailyAchievementTips'
                Id = $id
                Name = $Name
                Waypoint = $Waypoint
                Tip = $Tip
            }

            Clear-Variable -Name Waypoint
            Clear-Variable -Name Tip

        }
        Else {
            
            Write-Verbose -Message "Discarding item '$Name' as it is not of type 'Miner', 'Forager', 'Lumberer' or 'Vista'."

        }

    }

    End{}

}