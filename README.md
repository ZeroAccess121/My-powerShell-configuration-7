# PowerShell Configuration for Dynamic Themes, Aliases, and System Management

This configuration file is designed to provide a highly customizable PowerShell experience. It includes functionality for dynamic theme switching with Oh My Posh, aliases for frequently used commands, system information functions, network utilities, and advanced fuzzy search capabilities for files and directories.

## Table of Contents

1. [Initializing Oh My Posh with Themes](#initializing-oh-my-posh-with-themes)
2. [Importing Necessary Modules](#importing-necessary-modules)
3. [Theme Switching Functions](#theme-switching-functions)
4. [Aliases for Common Commands](#aliases-for-common-commands)
5. [Functions for Extended Functionality](#functions-for-extended-functionality)
6. [Search and Fuzzy Search Functions](#search-and-fuzzy-search-functions)
7. [Open Files and Folders](#open-files-and-folders)

---

## Initializing Oh My Posh with Themes

Oh My Posh allows you to customize the PowerShell prompt's appearance with various themes. You can easily switch between these themes by initializing them in your PowerShell session.

### Example themes already initialized (uncomment as needed):

```powershell
# oh-my-posh init pwsh --config 'C:\Users\Amr khaled\AppData\Local\Programs\oh-my-posh\themes\json.omp.json' | Invoke-Expression
oh-my-posh init pwsh --config 'C:\Users\Amr khaled\AppData\Local\Programs\oh-my-posh\themes\cloud-native-azure.omp.json' | Invoke-Expression
# oh-my-posh init pwsh --config 'C:\Users\Amr khaled\AppData\Local\Programs\oh-my-posh\themes\jandedobbeleer.omp.json' | Invoke-Expression
# oh-my-posh init pwsh --config 'C:\Users\Amr khaled\AppData\Local\Programs\oh-my-posh\themes\chips.omp.json' | Invoke-Expression
# oh-my-posh init pwsh --config 'C:\Users\Amr khaled\AppData\Local\Programs\oh-my-posh\themes\dracula.omp.json' | Invoke-Expression
# oh-my-posh init pwsh --config 'C:\Users\Amr khaled\AppData\Local\Programs\oh-my-posh\themes\if_tea.omp.json' | Invoke-Expression
# oh-my-posh init pwsh --config 'C:\Users\Amr khaled\AppData\Local\Programs\oh-my-posh\themes\sonicboom_dark.omp.json' | Invoke-Expression
# oh-my-posh init pwsh --config 'C:\Users\Amr khaled\AppData\Local\Programs\oh-my-posh\themes\atomic.omp.json' | Invoke-Expression
# oh-my-posh init pwsh --config 'C:\Users\Amr khaled\AppData\Local\Programs\oh-my-posh\themes\blue-owl.omp.json' | Invoke-Expression
# oh-my-posh init pwsh --config 'C:\Users\Amr khaled\AppData\Local\Programs\oh-my-posh\themes\bubbles.omp.json' | Invoke-Expression
# oh-my-posh init pwsh --config 'C:\Users\Amr khaled\AppData\Local\Programs\oh-my-posh\themes\devious-diamonds.omp.json' | Invoke-Expression
```
## Importing Necessary Modules
This section imports essential modules for enhancing your PowerShell experience. These modules enable fuzzy searching, terminal icons, Windows update management, and improved shell functionalities.

```powershell
Import-Module PSFzf
Import-Module PSWindowsUpdate
Import-Module PSColor
Import-Module PSReadLine
Set-PSReadLineOption -PredictionSource History
Import-Module -Name Terminal-Icons
```
##Theme Switching Functions
The following functions allow you to switch themes dynamically using Oh My Posh with fuzzy search. The Set-PoshTheme function allows you to change themes, and Choose-PoshTheme lets you select a theme interactively.
```powershell
function Set-PoshTheme {
    param (
        [Parameter(Mandatory)]
        [string]$Theme
    )

    $themePath = "C:\Users\Amr khaled\AppData\Local\Programs\oh-my-posh\themes\$Theme.omp.json"
    if (Test-Path $themePath) {
        oh-my-posh init pwsh --config $themePath | Invoke-Expression
        Write-Host "Switched to theme: $Theme" -ForegroundColor Green
    } else {
        Write-Host "Theme '$Theme' not found!" -ForegroundColor Red
    }
}

```
## Choose-PoshTheme Function
This function allows you to select a theme from a list using fuzzy search. The fzf utility helps you interactively choose a theme.
```powershell
function Choose-PoshTheme {
    $themes = @(
        "jandedobbeleer",
        "chips",
        "dracula",
        "if_tea",
        "sonicboom_dark",
        "atomic",
        "blue-owl",
        "bubbles",
        "devious-diamonds",
        "cloud-native-azure",
        "mario",
        "powerline",
        "paradox",
        "pure",
        "snowy-night",
        "tango",
        "vscode",
        "powerline-v2",
        "crystal",
        "horizon",
        "sphinx",
        "old-skool",
        "seabird",
        "new-age",
        "macchiato",
        "react",
        "dracula-dark",
        "frodo",
        "night-owl",
        "1_shell",
        "agnoster.minimal",
        "agnoster",
        "agnosterplus",
        "aliens",
        "amro",
        "atomicBit",
        "avit",
        "blueish",
        "bubblesextra",
        "bubblesline",
        "capr4n",
        "catppuccin_frappe",
        "catppuccin_latte",
        "catppuccin_macchiato",
        "catppuccin_mocha",
        "catppuccin",
        "cert",
        "cinnamon",
        "clean-detailed",
        "cloud-context",
        "cobalt2",
        "craver",
        "darkblood",
        "di4am0nd",
        "easy-term",
        "emodipt-extend",
        "emodipt",
        "fish",
        "free-ukraine",
        "froczh",
        "gmay",
        "grandpa-style",
        "gruvbox",
        "half-life",
        "honukai",
        "hotstick.minimal",
        "hul10",
        "hunk",
        "huvix",
        "illusi0n",
        "iterm2",
        "jblab_2021",
        "jonnychipz",
        "json",
        "jtracey93",
        "jv_sitecorian",
        "kali",
        "kushal",
        "lambda",
        "lambdageneration",
        "larserikfinholt",
        "lightgreen",
        "M365Princess",
        "marcduiker",
        "markbull",
        "material",
        "microverse-power",
        "mojada"
    )

    Write-Host "Available Themes:" -ForegroundColor Cyan
    $themes | fzf --preview 'echo {}' --preview-window=up:20 | ForEach-Object {
        Set-PoshTheme -Theme $_
    }
}
```
##Aliases for Common Commands
Here, we define several useful aliases to simplify and speed up common PowerShell commands. These aliases make it easier to work with network commands, system commands, file explorers, and more.


```powershell
Set-Alias posh-theme Choose-PoshTheme
Set-Alias tt tree
Set-Alias gnip Get-NetIPAddress
Set-Alias vim nvim
Set-Alias alies Get-Alias
Set-Alias edit notepad
Set-Alias pscan Test-NetConnection  # Alias for testing network connections
```
##Functions for Extended Functionality
This section contains a set of custom functions for retrieving system information, managing network connections, exploring directories, and gathering various system metrics like CPU and memory usage.
```powershell
Function getip { Get-NetIPAddress | Where-Object { $_.AddressFamily -eq 'IPv4' } }
Function ll { Get-ChildItem -Force | Sort-Object Name }
Function lsr { Get-ChildItem -Recurse -Force }
Function gs { Get-Service }
Function md { New-Item -ItemType Directory }
Function netinfo { Get-NetAdapter | Select-Object Name, Status, MacAddress, LinkSpeed }
Function pingtest { Test-Connection -Count 4 }
Function ports { Get-NetTCPConnection | Select-Object LocalAddress, LocalPort, RemoteAddress, RemotePort, State }
Function size { Get-ChildItem -Recurse | Measure-Object -Property Length -Sum | Select-Object Count, Sum }
Function tree { Get-ChildItem -Recurse -Force | Format-Table FullName, Attributes }
Function listusers { Get-LocalUser }
Function groups { Get-LocalGroupMember -Group "Administrators" }
Function clsrv { Clear-DnsClientCache }
Function cpuinfo { Get-WmiObject Win32_Processor | Select-Object Name, NumberOfCores, MaxClockSpeed }
Function raminfo { Get-WmiObject Win32_PhysicalMemory | Select-Object Manufacturer, Capacity, Speed }
Function sysinfo { Get-ComputerInfo | Select-Object CsName, WindowsVersion, OsArchitecture, CsManufacturer, CsModel }
```
##Search and Fuzzy Search Functions
This section introduces fuzzy search capabilities using the fzf tool, which enables you to search through files, directories, and content interactively. The functions here allow for flexible and powerful searching.
```powershell
function search {
    Get-ChildItem -Path C:\ -Recurse -File -ErrorAction SilentlyContinue | ForEach-Object { $_.FullName } | fzf
}

function fuzzysearch {
    Get-ChildItem -Path C:\ -Recurse -File -ErrorAction SilentlyContinue | ForEach-Object { $_.FullName } | fzf --preview="type {}"
}
Set-Alias fs fuzzysearch

function fuzzydirs {
    Get-ChildItem -Path C:\ -Recurse -Directory -ErrorAction SilentlyContinue | ForEach-Object { $_.FullName } | fzf
}
Set-Alias fd fuzzydirs

function fuzzyext {
    param (
        [string]$ext = "*.txt"
    )
    Get-ChildItem -Path C:\ -Recurse -File -Include $ext -ErrorAction SilentlyContinue | ForEach-Object { $_.FullName } | fzf
}
Set-Alias fx fuzzyext
```
##Open Files and Folders
These functions let you open files or directories directly from your PowerShell session, using the power of fuzzy searching and previewing.

```powershell
function openfile {
    Get-ChildItem -Path C:\ -Recurse -File -ErrorAction SilentlyContinue | ForEach-Object { $_.FullName } | fzf | ForEach-Object { notepad $_ }
}
Set-Alias of openfile

function searchpreview {
    Get-ChildItem -Path C:\ -Recurse -File -ErrorAction SilentlyContinue | ForEach-Object { $_.FullName } | fzf --preview="if ($env:OS -eq 'Windows_NT') { type {} | Out-String } else { cat {} }"
}
Set-Alias fsp searchpreview

function copyfilepath {
    Get-ChildItem -Path C:\ -Recurse -File -ErrorAction SilentlyContinue | ForEach-Object { $_.FullName } | fzf | Set-Clipboard
}
Set-Alias fcfp copyfilepath

function recentfiles {
    param (
        [int]$days = 7
    )
    Get-ChildItem -Path C:\ -Recurse -File -ErrorAction SilentlyContinue | Where-Object { $_.LastWriteTime -ge (Get-Date).AddDays(-$days) } | ForEach-Object { $_.FullName } | fzf
}
Set-Alias frf recentfiles

function searchtext {
    param (
        [string]$query
    )
    rg --files-with-matches $query | fzf
}
Set-Alias fst searchtext

function openfolder {
    Get-ChildItem -Path C:\ -Recurse -Directory -ErrorAction SilentlyContinue | ForEach-Object { $_.FullName } | fzf | ForEach-Object { Start-Process explorer $_ }
}
Set-Alias fofd openfolder
```

