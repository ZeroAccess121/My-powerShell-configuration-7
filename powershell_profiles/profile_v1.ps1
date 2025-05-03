# ==============================================
# PowerShell Profile Enhancement
# ==============================================

# Clear the screen for a fresh start
Clear-Host
$profileLoadStart = Get-Date
# ----------------------------------------------
# Oh My Posh Initialization
# ----------------------------------------------
try {
    # Check if oh-my-posh is available
    if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
        # Try multiple possible theme locations
        $possibleThemePaths = @(
            "${env:POSH_THEMES_PATH}\zash.omp.json",
            "${env:USERPROFILE}\AppData\Local\Programs\oh-my-posh\themes\zash.omp.json",
            "${env:ProgramFiles}\oh-my-posh\themes\zash.omp.json",
            "${env:LocalAppData}\Programs\oh-my-posh\themes\zash.omp.json"
        )

        $ompConfig = $possibleThemePaths | Where-Object { Test-Path $_ } | Select-Object -First 1

        if ($ompConfig) {
            oh-my-posh init pwsh --config $ompConfig | Invoke-Expression
            Write-Host "Oh My Posh initialized with $ompConfig" -ForegroundColor DarkGray
        } else {
            Write-Warning "Oh My Posh theme not found. Tried: $($possibleThemePaths -join ', ')"
            # Fallback to default theme
            oh-my-posh init pwsh | Invoke-Expression
        }
    } else {
        Write-Warning "oh-my-posh not found. Please install it with:"
        Write-Host "  winget install JanDeDobbeleer.OhMyPosh -s winget" -ForegroundColor Cyan
    }
} catch {
    Write-Error "Failed to initialize oh-my-posh: $_"
}

# ----------------------------------------------
# PSReadLine Configuration
# ----------------------------------------------
try {
    Import-Module PSReadLine -ErrorAction Stop
    
    # Enhanced command prediction and history
    Set-PSReadLineOption -PredictionSource History
    Set-PSReadLineOption -PredictionViewStyle ListView
    Set-PSReadLineOption -EditMode Windows
    Set-PSReadLineOption -HistorySearchCursorMovesToEnd
    Set-PSReadLineOption -Colors @{
        Command            = 'Green'
        Parameter         = 'DarkGray'
        Operator          = 'DarkGray'
        Variable          = 'Cyan'
        String           = 'DarkCyan'
        Number           = 'DarkCyan'
        Member           = 'DarkGray'
        Default          = 'White'
    }

    # Smart tab completion
    Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete

    # History navigation with up/down arrows
    Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
    Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward

} catch {
    Write-Warning "Failed to configure PSReadLine: $_"
}

# ----------------------------------------------
# Optional Module Imports
# ----------------------------------------------
$optionalModules = @(
    @{ Name = "Terminal-Icons"; Command = "Import-Module Terminal-Icons -ErrorAction SilentlyContinue" },
    @{ Name = "PSFzf"; Command = "Import-Module PSFzf -ErrorAction SilentlyContinue; Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+f' -PSReadlineChordReverseHistory 'Ctrl+r'" },
    @{ Name = "PSGitHub"; Command = "Import-Module PSGitHub -ErrorAction SilentlyContinue" },
    @{ Name = "posh-git"; Command = "Import-Module posh-git -ErrorAction SilentlyContinue" }
)

foreach ($module in $optionalModules) {
    try {
        if (Get-Module -ListAvailable -Name $module.Name) {
            Invoke-Expression $module.Command
            Write-Host "[+] Loaded module $($module.Name)" -ForegroundColor DarkGray
        }
    } catch {
        Write-Warning "Failed to load module $($module.Name): $_"
    }
}

# ----------------------------------------------
# Custom Aliases and Functions
# ----------------------------------------------

# ----------------------------------------------
# Git Aliases and Helpers
# ----------------------------------------------
function git-menu {
    $gitCommands = @(
        # Status & Information
        "git status"
        "git status -v"
        "git status -s"
        "git shortlog -sn --all"
        "git shortlog -sn"
        "git show --name-only"
        
        # Branching
        "git checkout"
        "git switch"
        "git switch -c"
        "git branch"
        "git branch -a"
        "git branch -vv"
        "git branch -d"
        "git blame"
        
        # Committing
        "git add"
        "git add ."
        "git add --all"
        "git add -p"
        "git commit -m"
        "git commit -am"
        "git commit --amend"
        "git commit --amend --no-edit"
        "git commit --amend --no-edit --reset-author"
        
        # History
        "git log --graph --oneline --decorate --all"
        "git log"
        "git log --pretty=format:'%h %ad | %s%d [%an]' --graph --date=short"
        "git log --follow"
        "git log --stat"
        "git log --summary"
        
        # Remote Operations
        "git push"
        "git push --force"
        "git push -u origin HEAD"
        "git pull"
        "git pull --rebase"
        "git fetch --prune"
        "git fetch --all"
        "git remote -v"
        "git remote add"
        "git remote remove"
        
        # Diffing
        "git diff"
        "git diff --cached"
        "git diff-tree --no-commit-id --name-only -r"
        "git diff --word-diff"
        "git diff --stat"
        
        # Stashing
        "git stash"
        "git stash apply"
        "git stash pop"
        "git stash list"
        "git stash drop"
        "git stash clear"
        
        # Rebasing
        "git rebase"
        "git rebase --abort"
        "git rebase --continue"
        "git rebase -i"
        "git rebase --skip"
        
        # Merging
        "git merge"
        "git merge --no-ff"
        "git merge --abort"
        "git merge --continue"
        
        # Resetting
        "git reset"
        "git reset --hard"
        "git reset --soft"
        "git reset --mixed"
        
        # Cleaning
        "git clean"
        "git clean -d"
        "git clean -f"
        "git clean -fd"
        
        # Tags
        "git tag"
        "git tag -a"
        "git tag -d"
        "git tag --list"
        
        # Submodules
        "git submodule"
        "git submodule init"
        "git submodule update"
        "git submodule update --recursive"
        "git submodule update --init --recursive"
        
        # Worktree
        "git worktree"
        "git worktree add"
        "git worktree list"
        "git worktree remove"
        
        # Bisect
        "git bisect"
        "git bisect start"
        "git bisect good"
        "git bisect bad"
        "git bisect reset"
        
        # Cherry-pick
        "git cherry-pick"
        "git cherry-pick --abort"
        "git cherry-pick --continue"
        
        # Reflog
        "git reflog"
        
        # Config
        "git config --list"
        "git config --global --list"
    )

    if (Get-Command fzf -ErrorAction SilentlyContinue) {
        # Create a temporary file for FZF input and output
        $tempInput = New-TemporaryFile
        $tempOutput = New-TemporaryFile
        
        try {
            # Write commands to the input file
            $gitCommands | Out-File -FilePath $tempInput
            
            # Run FZF with the input file and capture output to the output file
            $fzfCmd = "Get-Content '$tempInput' | fzf --height 40% --reverse --prompt='Git Commands > ' --print-query > '$tempOutput'"
            Invoke-Expression $fzfCmd
            
            # Read the output file
            $results = Get-Content -Path $tempOutput -ErrorAction SilentlyContinue
            
            if ($results -and $results.Count -gt 0) {
                # First line is always the query
                $query = $results[0].Trim()
                
                # If there's a second line, it's the selection
                if ($results.Count -gt 1) {
                    $command = $results[1].Trim()
                } else {
                    # No selection, use the query
                    $command = $query
                }
                
                # Add git prefix if needed
                if (-not $command.StartsWith("git ")) {
                    $command = "git $command"
                }
                
                # Check if command requires a message
                if ($command -match "git commit -m$" -or $command -match "git commit -am$" -or $command -match "git tag -a$") {
                    $message = Read-Host "Enter message"
                    $command = "$command `"$message`""
                }
                # Check if command requires a branch name
                elseif ($command -match "git checkout$" -or $command -match "git switch$" -or $command -match "git switch -c$" -or $command -match "git branch -d$") {
                    $branch = Read-Host "Enter branch name"
                    $command = "$command $branch"
                }
                # Check if command requires a remote name
                elseif ($command -match "git remote add$" -or $command -match "git remote remove$") {
                    $remote = Read-Host "Enter remote name"
                    if ($command -match "git remote add$") {
                        $url = Read-Host "Enter remote URL"
                        $command = "$command $remote $url"
                    } else {
                        $command = "$command $remote"
                    }
                }
                # Check if command is git add (without parameters)
                elseif ($command -eq "git add") {
                    $files = Read-Host "Enter file paths (space separated) or . for all"
                    $command = "$command $files"
                }
                
                Write-Host "Executing: $command" -ForegroundColor Cyan
                
                # Execute the command
                Invoke-Expression $command
            }
        }
        finally {
            # Clean up temp files
            Remove-Item -Path $tempInput -ErrorAction SilentlyContinue
            Remove-Item -Path $tempOutput -ErrorAction SilentlyContinue
        }
    } else {
        Write-Host "Git Commands:" -ForegroundColor Yellow
        $gitCommands | ForEach-Object {
            Write-Host $_
        }
        
        Write-Host "`nFZF not found. Install FZF for interactive selection." -ForegroundColor Red
    }
}

# ----------------------------------------------
# Oh My Posh Theme Switcher
# ----------------------------------------------
function theme {
    if (-not (Get-Command oh-my-posh -ErrorAction SilentlyContinue)) {
        Write-Warning "Oh My Posh is not installed. Please install it first."
        return
    }

    if (-not (Get-Command fzf -ErrorAction SilentlyContinue)) {
        Write-Warning "FZF is not installed. Please install it for interactive theme selection."
        return
    }

    # Determine themes location
    $themesPath = $null
    $possibleThemesPaths = @(
        $env:POSH_THEMES_PATH,
        "${env:USERPROFILE}\AppData\Local\Programs\oh-my-posh\themes",
        "${env:ProgramFiles}\oh-my-posh\themes",
        "${env:LocalAppData}\Programs\oh-my-posh\themes"
    )

    foreach ($path in $possibleThemesPaths) {
        if ($path -and (Test-Path $path)) {
            $themesPath = $path
            break
        }
    }

    if (-not $themesPath) {
        Write-Error "Could not find Oh My Posh themes directory."
        return
    }

    Write-Host "Finding themes in $themesPath..." -ForegroundColor Cyan

    # Get all theme files
    $themeFiles = Get-ChildItem -Path $themesPath -Filter "*.omp.json" | Select-Object -ExpandProperty Name

    if ($themeFiles.Count -eq 0) {
        Write-Error "No themes found in $themesPath"
        return
    }

    # Create temporary files for FZF input and output
    $tempInput = New-TemporaryFile
    $tempOutput = New-TemporaryFile

    try {
        # Write theme names to input file
        $themeFiles | Out-File -FilePath $tempInput

        # Use FZF for theme selection with preview
        # We need to avoid using complex commands with pipes in the preview
        # Instead, create a simple preview function
        $previewScript = New-TemporaryFile
        @"
        param(`$themeName)
        `$themePath = Join-Path "$themesPath" `$themeName
        Write-Output "Theme: `$themeName"
        Write-Output ""
        Write-Output "Preview not available in FZF window."
        Write-Output "Theme will be applied when selected."
"@ | Out-File -FilePath $previewScript

        $fzfCmd = "Get-Content '$tempInput' | fzf --height 70% --reverse --prompt='Select Theme > ' --preview='pwsh -NoProfile -File $previewScript {1}' > '$tempOutput'"
        Invoke-Expression $fzfCmd

        # Get selected theme
        $selectedTheme = Get-Content -Path $tempOutput -ErrorAction SilentlyContinue

        if ($selectedTheme) {
            $themeFullPath = Join-Path $themesPath $selectedTheme
            Write-Host "Applying theme: $selectedTheme" -ForegroundColor Green
            
            # Apply the theme
            & oh-my-posh init pwsh --config $themeFullPath | Invoke-Expression
            
            # Check if profile has POSH_THEME variable for persistence
            $profileContent = Get-Content $PROFILE -ErrorAction SilentlyContinue
            
            # Offer to update profile for persistence
            $updateProfile = Read-Host "Do you want to save this theme as your default? (y/n)"
            if ($updateProfile -eq "y") {
                $themeVarLine = "`$env:POSH_THEME = '$themeFullPath'"
                
                if ($profileContent -match '\$env:POSH_THEME\s*=') {
                    # Update existing POSH_THEME line
                    $profileContent = $profileContent -replace '\$env:POSH_THEME\s*=.*', $themeVarLine
                    $profileContent | Set-Content $PROFILE
                } else {
                    # Add new POSH_THEME line at the beginning of the file
                    @($themeVarLine) + $profileContent | Set-Content $PROFILE
                }
                Write-Host "Profile updated. Theme will be applied on new shells." -ForegroundColor Green
            }
        }
    }
    finally {
        # Clean up temp files
        Remove-Item -Path $tempInput -ErrorAction SilentlyContinue
        Remove-Item -Path $tempOutput -ErrorAction SilentlyContinue
        Remove-Item -Path $previewScript -ErrorAction SilentlyContinue
    }
}
# ----------------------------------------------
# Network Information Function
# ----------------------------------------------
function Get-NetworkInfo {
    [CmdletBinding()]
    param (
        [switch]$IPOnly,
        [switch]$Detailed
    )

    $separator = "=" * 50
    
    # Create color function for output
    function Write-ColorOutput($text, $color) {
        Write-Host $text -ForegroundColor $color
    }

    if (-not $IPOnly) {
        Write-ColorOutput "`n$separator" "Cyan"
        Write-ColorOutput " NETWORK INFORMATION SUMMARY" "Cyan"
        Write-ColorOutput "$separator`n" "Cyan"
    }

    # IPv4 Addresses
    $ipv4Info = Get-NetIPAddress -AddressFamily IPv4 | 
                Where-Object { $_.InterfaceAlias -notmatch 'Loopback' -and $_.IPAddress -ne '127.0.0.1' } |
                Select-Object InterfaceAlias, IPAddress, PrefixLength
    
    if ($IPOnly) {
        # Return only IP addresses for piping to other commands
        return $ipv4Info.IPAddress
    }
    
    # IPv4 Addresses
    Write-ColorOutput "IPv4 ADDRESSES:" "Yellow"
    if ($ipv4Info) {
        $ipv4Info | ForEach-Object {
            Write-Host "$($_.InterfaceAlias): " -NoNewline
            Write-ColorOutput "$($_.IPAddress)/$($_.PrefixLength)" "Green"
        }
    } else {
        Write-Host "No IPv4 addresses found."
    }
    
    Write-Host ""
    
    # IPv6 Addresses (non-temporary, non-link-local)
    Write-ColorOutput "IPv6 ADDRESSES:" "Yellow"
    $ipv6Info = Get-NetIPAddress -AddressFamily IPv6 | 
                Where-Object { 
                    $_.InterfaceAlias -notmatch 'Loopback' -and 
                    $_.IPAddress -ne '::1' -and 
                    -not $_.IPAddress.StartsWith('fe80')
                } |
                Select-Object InterfaceAlias, IPAddress, PrefixLength
                
    if ($ipv6Info) {
        $ipv6Info | ForEach-Object {
            Write-Host "$($_.InterfaceAlias): " -NoNewline
            Write-ColorOutput "$($_.IPAddress)/$($_.PrefixLength)" "Green"
        }
    } else {
        Write-Host "No public IPv6 addresses found."
    }
    
    Write-Host ""
    
    # MAC Addresses
    Write-ColorOutput "MAC ADDRESSES:" "Yellow"
    $adapters = Get-NetAdapter | Where-Object Status -eq 'Up'
    if ($adapters) {
        foreach ($adapter in $adapters) {
            Write-Host "$($adapter.Name): " -NoNewline
            Write-ColorOutput "$($adapter.MacAddress)" "Green"
        }
    } else {
        Write-Host "No active network adapters found."
    }
    
    Write-Host ""
    
    # Default gateway
    Write-ColorOutput "DEFAULT GATEWAY:" "Yellow"
    $defaultGateways = Get-NetRoute -DestinationPrefix '0.0.0.0/0' | Select-Object -ExpandProperty NextHop
    if ($defaultGateways) {
        $defaultGateways | ForEach-Object {
            Write-ColorOutput $_ "Green"
        }
    } else {
        Write-Host "No default gateway found."
    }
    
    Write-Host ""
    
    # DNS Servers
    Write-ColorOutput "DNS SERVERS:" "Yellow"
    $dnsServers = Get-DnsClientServerAddress | 
                  Where-Object { $_.ServerAddresses -and $_.AddressFamily -eq 2 } |
                  Select-Object InterfaceAlias, ServerAddresses
    
    if ($dnsServers) {
        foreach ($dns in $dnsServers) {
            Write-Host "$($dns.InterfaceAlias): " -NoNewline
            Write-ColorOutput "$($dns.ServerAddresses -join ', ')" "Green"
        }
    } else {
        Write-Host "No DNS servers found."
    }
    
    Write-Host ""
    
    # External IP
    Write-ColorOutput "EXTERNAL IP:" "Yellow"
    try {
        $externalIP = Invoke-RestMethod -Uri 'https://api.ipify.org?format=json' -TimeoutSec 5
        Write-ColorOutput $externalIP.ip "Green"
    } catch {
        Write-Host "Could not retrieve external IP. Check your internet connection."
    }
    
    # Additional detailed information if requested
    if ($Detailed) {
        Write-Host ""
        Write-ColorOutput "LISTENING PORTS:" "Yellow"
        $openPorts = Get-NetTCPConnection -State Listen | 
                     Select-Object LocalAddress, LocalPort, @{Name="ProcessName";Expression={(Get-Process -Id $_.OwningProcess).Name}} |
                     Sort-Object LocalPort
        
        if ($openPorts) {
            $openPorts | Format-Table -AutoSize
        } else {
            Write-Host "No listening ports found."
        }
        
        Write-Host ""
        Write-ColorOutput "NETWORK INTERFACES:" "Yellow"
        Get-NetAdapter | Where-Object Status -eq "Up" | Format-Table -AutoSize Name, InterfaceDescription, Status, LinkSpeed
        
        Write-Host ""
        Write-ColorOutput "NETWORK STATISTICS:" "Yellow"
        $netStats = Get-NetAdapterStatistics | Where-Object { $_.ReceivedBytes -gt 0 -or $_.SentBytes -gt 0 }
        $netStats | Format-Table -AutoSize Name, 
            @{Name="Received (MB)";Expression={[math]::Round($_.ReceivedBytes/1MB, 2)}}, 
            @{Name="Sent (MB)";Expression={[math]::Round($_.SentBytes/1MB, 2)}}
    }
}


# ----------------------------------------------
# System utilities
# ----------------------------------------------

function l { Get-ChildItem  | Format-Table -AutoSize }
function ll { Get-ChildItem -Force | Format-Table -AutoSize }
function la { Get-ChildItem -Force -Hidden | Format-Table -AutoSize }
function which ($command) { Get-Command $command | Select-Object -ExpandProperty Path }

# ----------------------------------------------
# Environment Setup
# ----------------------------------------------

# Better history commands
function Get-EnhancedHistory {
    Get-History | Format-Table -AutoSize -Wrap @{
        Label="Time"
        Expression={$_.StartExecutionTime.ToString("HH:mm:ss")}
        Width=8
    }, @{
        Label="Duration"
        Expression={($_.EndExecutionTime - $_.StartExecutionTime).ToString("hh\:mm\:ss")}
        Width=10
    }, @{
        Label="Command"
        Expression={if ($_.CommandLine.Length -gt 50) { $_.CommandLine.Substring(0,47) + "..." } else { $_.CommandLine }}
    }
}


# ----------------------------------------------
# Network Information && information
# ----------------------------------------------

Function netinfo { Get-NetAdapter | Select-Object Name, Status, MacAddress, LinkSpeed }
Function pingtest { Test-Connection -Count 4 }
Function ports { Get-NetTCPConnection | Select-Object LocalAddress, LocalPort, RemoteAddress, RemotePort, State }
Function size { Get-ChildItem -Recurse | Measure-Object -Property Length -Sum | Select-Object Count, Sum }
Function cpuinfo { Get-WmiObject Win32_Processor | Select-Object Name, NumberOfCores, MaxClockSpeed }
Function raminfo { Get-WmiObject Win32_PhysicalMemory | Select-Object Manufacturer, Capacity, Speed }
Function sysinfo { Get-ComputerInfo | Select-Object CsName, WindowsVersion, OsArchitecture, CsManufacturer, CsModel }
function check-disk {
    Get-PSDrive | Where-Object { $_.Used -ne $null } | Select-Object Name, @{n="Used (GB)";e={[math]::Round($_.Used/1GB,2)}}, @{n="Free (GB)";e={[math]::Round($_.Free/1GB,2)}}
}
function hack-server{
    ssh root@segfault.net
}
function my-hack-server{
    ssh -o "SetEnv SECRET=FksPpsOTJseCOrZBPWmRpQRz" root@lsd.segfault.net
}


# ----------------------------------------------
# Startup Message
# ----------------------------------------------
Write-Host "PowerShell $($PSVersionTable.PSVersion) ready!" -ForegroundColor Green
Write-Host "Running on $([System.Environment]::OSVersion.VersionString)" -ForegroundColor DarkGray
Write-Host "Profile loaded from $PROFILE" -ForegroundColor DarkGray
Write-Host "Profile loaded in $((Get-Date) - $profileLoadStart)" -ForegroundColor DarkGray
Write-Host "  theme  " -ForegroundColor Cyan -NoNewline; Write-Host "- Switch Oh My Posh themes using FZF"
python -c "import pyfiglet; from colorama import Fore, init; init(); print(Fore.CYAN + pyfiglet.figlet_format('ZeroAccess', font='puffy'))"
