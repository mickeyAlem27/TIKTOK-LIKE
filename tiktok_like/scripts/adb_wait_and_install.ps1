param(
  [string]$ApkPath = "build\app\outputs\flutter-apk\app-debug.apk",
  [string]$AppId = "com.example.tiktok_like",
  [int]$MaxWaitSeconds = 30,
  [switch]$SkipUninstall
)

$ErrorActionPreference = 'Stop'

function Get-AdbPath {
  $candidate = Join-Path $env:LOCALAPPDATA "Android\Sdk\platform-tools\adb.exe"
  if (Test-Path $candidate) { return $candidate }
  throw "adb.exe not found. Install Android SDK Platform-Tools and ensure adb is available."
}

$adb = Get-AdbPath

Write-Host "[ADB] Restarting server and waiting for device..." -ForegroundColor Cyan
& $adb kill-server | Out-Null
& $adb start-server | Out-Null
& $adb wait-for-device

Write-Host "[ADB] Waiting for boot animation to stop (device fully ready)..." -ForegroundColor Cyan
$stopped = $false
for ($i=0; $i -lt $MaxWaitSeconds; $i++) {
  try {
    $state = (& $adb shell getprop init.svc.bootanim).Trim()
    if ($state -match 'stopped') { $stopped = $true; break }
  } catch {}
  Start-Sleep -Seconds 1
}
if (-not $stopped) {
  Write-Warning "Boot animation still running after $MaxWaitSeconds seconds. Proceeding anyway."
}

# Extra brief wait for late system services (activity/package/settings)
Start-Sleep -Seconds 3

# Sanity info (non-fatal)
try {
  $sys = (& $adb shell getprop sys.boot_completed).Trim()
  $dev = (& $adb shell getprop dev.bootcomplete).Trim()
  Write-Host "[ADB] sys.boot_completed=$sys, dev.bootcomplete=$dev" -ForegroundColor DarkGray
} catch {}

if (-not (Test-Path $ApkPath)) {
  Write-Host "[BUILD] APK not found at '$ApkPath'. Attempting to build debug APK with Flutter..." -ForegroundColor Yellow
  if (Get-Command flutter -ErrorAction SilentlyContinue) {
    flutter build apk --debug
  } else {
    throw "APK not found and 'flutter' CLI not available to build it. Please build the APK manually or adjust -ApkPath."
  }
  if (-not (Test-Path $ApkPath)) { throw "APK still not found at '$ApkPath' after build." }
}

if (-not $SkipUninstall) {
  Write-Host "[ADB] Uninstalling existing app ($AppId) if present..." -ForegroundColor Cyan
  & $adb uninstall $AppId | Out-Null
}

Write-Host "[ADB] Installing APK: $ApkPath" -ForegroundColor Cyan
& $adb install -r -t "$ApkPath"

if ($LASTEXITCODE -ne 0) {
  throw "adb install failed with exit code $LASTEXITCODE. Try cold booting or wiping the AVD, then re-run this script."
}

Write-Host "[SUCCESS] APK installed. You can now run 'flutter run'." -ForegroundColor Green
