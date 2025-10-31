:: Convert JSON to VTT PowerShell
:: created with claude.ai
:: v7

@echo off
setlocal enabledelayedexpansion

:: Batch converter for all Wistia JSON files
:: Usage: convert_all.bat [folder_path]
:: If no folder specified, uses current directory

if "%~1"=="" (
    set "TARGET_FOLDER=%CD%"
) else (
    set "TARGET_FOLDER=%~f1"
)

:: Check if target folder exists
if not exist "%TARGET_FOLDER%\" (
    echo Error: Folder "%TARGET_FOLDER%" not found
    exit /b 1
)

:: Change to target folder
cd /d "%TARGET_FOLDER%"

:: Get the directory where this batch file is located
set "SCRIPT_DIR=%~dp0"

echo.
echo Scanning for JSON files in: %TARGET_FOLDER%
echo.

set "TOTAL_COUNT=0"
set "CONVERTED_COUNT=0"
set "SKIPPED_COUNT=0"
set "ERROR_COUNT=0"
set "ERROR_LOG=%TARGET_FOLDER%\errors.txt"

:: Clear or create error log
if exist "%ERROR_LOG%" del "%ERROR_LOG%"

echo.
echo Scanning for JSON files in: %TARGET_FOLDER%
echo Error log will be saved to: %ERROR_LOG%
echo.

:: Process all .json files recursively
for /r "%TARGET_FOLDER%" %%G in (*.json) do (
    set "JSON_FILE=%%G"
    set "VTT_FILE=%%~dpnG.vtt"
    
    set /a TOTAL_COUNT+=1
    
    if exist "!VTT_FILE!" (
        echo [SKIP] Already exists: %%~nxG
        set /a SKIPPED_COUNT+=1
    ) else (
        echo [PROCESS] Converting: %%~nxG
        
        :: Capture output from converter
        set "TEMP_OUTPUT=%TEMP%\converter_output_%RANDOM%.txt"
        call "%SCRIPT_DIR%convert_wistia_to_vtt_powershell.bat" "!JSON_FILE!" "!VTT_FILE!" > "!TEMP_OUTPUT!" 2>&1
        set "CONVERTER_RESULT=!ERRORLEVEL!"
        
        if !CONVERTER_RESULT! EQU 0 (
            set /a CONVERTED_COUNT+=1
        ) else (
            echo [ERROR] Failed - logged to errors.txt
            set /a ERROR_COUNT+=1
            
            :: Log error to file - full path on first line
            echo !JSON_FILE! >> "%ERROR_LOG%"
            
            :: Log error message on second line
            type "!TEMP_OUTPUT!" >> "%ERROR_LOG%"
            
            :: Add blank line for readability
            echo. >> "%ERROR_LOG%"
        )
        
        :: Clean up temp output file
        del "!TEMP_OUTPUT!" >nul 2>&1
    )
)

echo ========================================
echo Conversion Complete
echo ========================================
echo Total JSON files found: %TOTAL_COUNT%
echo Successfully converted: %CONVERTED_COUNT%
echo Skipped (VTT exists): %SKIPPED_COUNT%
echo Errors: %ERROR_COUNT%
echo ========================================

endlocal
exit /b 0