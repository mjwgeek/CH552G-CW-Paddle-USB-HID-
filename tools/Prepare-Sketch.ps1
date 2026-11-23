# One-time preparation for a standalone Arduino sketch.
# Creates build/<mode>/Morse_Code/ using the CH55xDuino HID Keyboard example.
param(
    [ValidateSet('hold', 'tap')]
    [string]$Mode = 'hold',
    [string]$ExamplePath = ''
)

$ErrorActionPreference = 'Stop'
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$packageRoot = Join-Path $env:LOCALAPPDATA 'Arduino15\packages'

if (-not $ExamplePath) {
    if (-not (Test-Path $packageRoot)) {
        throw "Arduino package folder not found: $packageRoot. Install CH55xDuino or pass -ExamplePath."
    }
    $found = @(Get-ChildItem -LiteralPath $packageRoot -Recurse -File -Filter 'HidKeyboard.ino' -ErrorAction SilentlyContinue |
        Where-Object { (Test-Path (Join-Path $_.DirectoryName 'src\userUsbHidKeyboard\USBconstant.c')) })
    if ($found.Count -eq 0) {
        throw 'Could not find CH55xDuino HidKeyboard example. Pass -ExamplePath "C:\...\HidKeyboard".'
    }
    $ExamplePath = $found[0].DirectoryName
}

$sourceDir = Join-Path $ExamplePath 'src'
if (-not (Test-Path (Join-Path $sourceDir 'userUsbHidKeyboard\USBconstant.c'))) {
    throw "Invalid HidKeyboard example: $ExamplePath"
}

$target = Join-Path $repoRoot "build\$Mode\Morse_Code"
if (Test-Path $target) {
    throw "Output already exists: $target. Move/delete it yourself before regenerating (to protect edits)."
}
New-Item -ItemType Directory -Force -Path $target | Out-Null
Copy-Item -LiteralPath $sourceDir -Destination (Join-Path $target 'src') -Recurse

$overrides = Join-Path $repoRoot 'usb-overrides\userUsbHidKeyboard'
$destinationLib = Join-Path $target 'src\userUsbHidKeyboard'
Get-ChildItem -LiteralPath $overrides -File | ForEach-Object {
    Copy-Item -LiteralPath $_.FullName -Destination (Join-Path $destinationLib $_.Name) -Force
}
Copy-Item -LiteralPath (Join-Path $repoRoot "firmware\$Mode\Morse_Code.ino") -Destination (Join-Path $target 'Morse_Code.ino')
Write-Host "Prepared Arduino sketch: $target" -ForegroundColor Green
Write-Host 'Open Morse_Code.ino in Arduino IDE, select CH552 and USER CODE w/ 148B USB RAM.'
