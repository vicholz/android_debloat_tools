#!/usr/bin/env pwsh
param (
    [string]$l = $null,
    [string]$a = $null
)

$basename = $MyInvocation.MyCommand.Name

function usage {
    Write-Output "USAGE: $basename -l <PKG_LIST_FILE> -a <ACTION>"
    Write-Output "  -l Package List File - List of packages to take action on."
    Write-Output "  -a Action to take - disable, uninstall, or enable."
    exit 1
}

function check_adb {
    # check if adb is installed
    if ((Get-Command "adb" -ErrorAction SilentlyContinue) -eq $null) { 
        Throw "ADB is not installed please install it and try running it again."
    }
}

function enable_package {
    param ($pkg)
    Write-Output "[ENABLING] $pkg..."
    & adb shell "pm enable --user 0 $pkg"
}

function disable_package {
    param ($pkg)
    Write-Output "[DISABLING] $pkg..."
    & adb shell "pm disable-user --user 0 $pkg"
}

function uninstall_package {
    param ($pkg)
    Write-Output "[UNINSTALLING] $pkg..."
    & adb shell "pm uninstall -k --user 0 $pkg"
}

if ($l -eq $null -Or $l -eq "" -Or $a -eq $null -Or $a -eq ""){
    Write-Output "ERROR: missing one or more required arguments!"
    usage
}

check_adb

foreach($pkg in [System.IO.File]::ReadLines("${l}"))
{
    if($pkg -ne $null -And $pkg -ne ""){
        &"${a}_package" $pkg
    }
}
