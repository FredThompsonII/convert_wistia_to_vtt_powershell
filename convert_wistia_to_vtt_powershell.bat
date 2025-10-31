:: Convert Wistia to VTT PowerShell
:: created with claude.ai
:: v3

@echo off
setlocal enabledelayedexpansion

:: Wistia JSON to VTT Converter (PowerShell Version)
:: Usage: converter.bat input.json [output.vtt]

if "%~1"=="" (
    echo Usage: %~nx0 input.json [output.vtt]
    echo.
    echo Converts a Wistia JSON subtitle file to VTT format
    exit /b 1
)

set "INPUT=%~1"
set "OUTPUT=%~2"

:: If no output file specified, use input filename with .vtt extension
if "%OUTPUT%"=="" (
    set "OUTPUT=%~dpn1.vtt"
)

:: Check if input file exists
if not exist "%INPUT%" (
    echo Error: Input file "%INPUT%" not found
    exit /b 1
)

:: Get full paths
for %%F in ("%INPUT%") do set "INPUT_FULL=%%~fF"
for %%F in ("%OUTPUT%") do set "OUTPUT_FULL=%%~fF"

:: Create a temporary PowerShell script file to avoid command line parsing issues
set "TEMP_PS1=%TEMP%\wistia_converter_%RANDOM%.ps1"

(
echo param^(
echo     [string]$jsonPath,
echo     [string]$vttPath
echo ^)
echo.
echo function Format-Timestamp {
echo     param^([double]$seconds^)
echo     $hours = [Math]::Floor^($seconds / 3600^)
echo     $minutes = [Math]::Floor^(^($seconds %% 3600^) / 60^)
echo     $secs = [Math]::Floor^($seconds %% 60^)
echo     $millis = [Math]::Floor^(^($seconds - [Math]::Floor^($seconds^)^) * 1000^)
echo     $timeStr = $hours.ToString^('00'^) + ':' + $minutes.ToString^('00'^) + ':' + $secs.ToString^('00'^) + '.' + $millis.ToString^('000'^)
echo     return $timeStr
echo }
echo.
echo try {
echo     $json = Get-Content -LiteralPath $jsonPath -Raw -Encoding UTF8 ^| ConvertFrom-Json
echo     if ^(-not $json.captions -or $json.captions.Count -eq 0^) {
echo         Write-Host 'Error: No captions found in JSON file' -ForegroundColor Red
echo         exit 1
echo     }
echo     $lines = $json.captions[0].hash.lines
echo     if ^(-not $lines -or $lines.Count -eq 0^) {
echo         Write-Host 'Error: No subtitle lines found' -ForegroundColor Red
echo         exit 1
echo     }
echo     $vttContent = 'WEBVTT' + [Environment]::NewLine + [Environment]::NewLine
echo     foreach ^($line in $lines^) {
echo         $start = Format-Timestamp -seconds $line.start
echo         $end = Format-Timestamp -seconds $line.end
echo         $text = if ^($line.text -is [Array]^) { $line.text -join [Environment]::NewLine } else { $line.text }
echo         $vttContent += $start + ' --^>' + $end + [Environment]::NewLine
echo         $vttContent += $text + [Environment]::NewLine + [Environment]::NewLine
echo     }
echo     [System.IO.File]::WriteAllText^($vttPath, $vttContent, [System.Text.Encoding]::UTF8^)
echo     Write-Host ^('Successfully converted ' + $jsonPath + ' to ' + $vttPath^) -ForegroundColor Green
echo     Write-Host ^('Total subtitle entries: ' + $lines.Count^) -ForegroundColor Cyan
echo     exit 0
echo } catch {
echo     Write-Host ^('Error: ' + $_.Exception.Message^) -ForegroundColor Red
echo     exit 1
echo }
) > "%TEMP_PS1%"

:: Run PowerShell script from file with parameters
powershell -NoProfile -ExecutionPolicy Bypass -File "%TEMP_PS1%" -jsonPath "%INPUT_FULL%" -vttPath "%OUTPUT_FULL%"
set RESULT=%ERRORLEVEL%

:: Clean up temporary script
del "%TEMP_PS1%" >nul 2>&1

exit /b %RESULT%
function Format-Timestamp { ^
    param([double]$seconds); ^
    $hours = [Math]::Floor($seconds / 3600); ^
    $minutes = [Math]::Floor(($seconds %% 3600) / 60); ^
    $secs = [Math]::Floor($seconds %% 60); ^
    $millis = [Math]::Floor(($seconds - [Math]::Floor($seconds)) * 1000); ^
    $timeStr = $hours.ToString('00') + ':' + $minutes.ToString('00') + ':' + $secs.ToString('00') + '.' + $millis.ToString('000'); ^
    return $timeStr ^
}; ^
try { ^
    $json = Get-Content -Path $jsonPath -Raw -Encoding UTF8 ^| ConvertFrom-Json; ^
    if (-not $json.captions -or $json.captions.Count -eq 0) { ^
        Write-Host 'Error: No captions found in JSON file' -ForegroundColor Red; ^
        exit 1 ^
    }; ^
    $lines = $json.captions[0].hash.lines; ^
    if (-not $lines -or $lines.Count -eq 0) { ^
        Write-Host 'Error: No subtitle lines found' -ForegroundColor Red; ^
        exit 1 ^
    }; ^
    $vttContent = 'WEBVTT' + [Environment]::NewLine + [Environment]::NewLine; ^
    foreach ($line in $lines) { ^
        $start = Format-Timestamp -seconds $line.start; ^
        $end = Format-Timestamp -seconds $line.end; ^
        $text = if ($line.text -is [Array]) { $line.text -join [Environment]::NewLine } else { $line.text }; ^
        $vttContent += $start + ' --^> ' + $end + [Environment]::NewLine; ^
        $vttContent += $text + [Environment]::NewLine + [Environment]::NewLine ^
    }; ^
    [System.IO.File]::WriteAllText($vttPath, $vttContent, [System.Text.Encoding]::UTF8); ^
    Write-Host ('Successfully converted ' + $jsonPath + ' to ' + $vttPath) -ForegroundColor Green; ^
    Write-Host ('Total subtitle entries: ' + $lines.Count) -ForegroundColor Cyan; ^
    exit 0 ^
} catch { ^
    Write-Host ('Error: ' + $_.Exception.Message) -ForegroundColor Red; ^
    exit 1 ^
}"

exit /b %ERRORLEVEL%