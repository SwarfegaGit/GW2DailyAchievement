function Get-GW2DailyAchievement {
    [CmdletBinding()]
    Param(
        [switch]$Tomorrow,
        [ValidateSet('GuildWars2', 'HeartOfThorns')]
        $Edition = 'HeartOfThorns',
        $MaxLevel = '80'
    )

    Begin {

        If ($Tomorrow) {
            Write-Verbose -Message 'Fecthing daily achievements for tomorrow'
            $APIv2 = Invoke-RestMethod -Uri https://api.guildwars2.com/v2/achievements/daily/tomorrow
        }
        Else {
            Write-Verbose -Message 'Fecthing daily achievements for today'
            $APIv2 = Invoke-RestMethod -Uri https://api.guildwars2.com/v2/achievements/daily
        }

    }

    Process {

        $APIv2.pve | Where-Object -FilterScript {

            $PSItem.required_access -eq $Edition -and $PSItem.level.max -ge $MaxLevel -and $MaxLevel -ge $PSItem.level.min
                
        } | Foreach { 
    
            $Item = Invoke-RestMethod -Uri "https://api.guildwars2.com/v2/achievements/$($PSItem.id)"

            [PSCustomObject] @{
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

function Get-GW2DailyAchievementTips {
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

            $switch = switch ($id) 
            { 
                1972 { $Waypoint = '[&BLIAAAA=]'; $Tip = "Harathi Hinterlands -> Arca Waypoint -> On this land mass there are usually lots of trees if you go South and East respectively." } 
                1938 { $Waypoint = '[&BIgBAAA=]'; $Tip = "Ashford -> Watchcrag Tower Waypoint (Up the stairs/ledge)." } 
                1985 { $Waypoint = '[&BFECAAA=]'; $Tip = "Timberline Falls -> Thistlereed Waypoint -> West of this waypoint, you need to go up a hill to the North, you'll find a patch of Califlowers (yes, this waypoint is broken)" } 
                1839 { $Waypoint = '[&BPoAAAA=]'; $Tip = "Queensdale -> Beetletun Waypoint" } 
                0001 { $Waypoint = ''; $Tip = "" }
                default { $Waypoint = $null; $Tip = "Tip not found. Report this as a bug quoting ID '$id'." } 
            }

            [PSCustomObject] @{
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