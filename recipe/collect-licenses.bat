@echo off
REM Consolidate the license texts bundled inside the Git for Windows
REM PortableGit archive into a single file, so conda-build can ship it
REM through about/license_file.
REM
REM Usage: collect-licenses.bat <extracted-prefix> <output-file>
REM   <extracted-prefix>  where PortableGit was extracted (%LIBRARY_PREFIX%)
REM   <output-file>       consolidated text file to write
REM
REM Identical license texts (matched by SHA-256) are written once; later
REM occurrences only get a header pointing at the first copy.
setlocal EnableExtensions EnableDelayedExpansion

set "ROOT=%~1"
set "OUT=%~2"
if "%ROOT%"=="" goto :usage
if "%OUT%"=="" goto :usage
if not exist "%ROOT%\usr\share\licenses" (
    echo ERROR: "%ROOT%\usr\share\licenses" not found - was PortableGit extracted there?
    exit /b 1
)

set "SEEN=%TEMP%\git-license-seen-%RANDOM%.txt"
if exist "%SEEN%" del "%SEEN%"
type nul > "%SEEN%"

> "%OUT%" echo This package bundles the Git for Windows distribution, which includes
>> "%OUT%" echo git itself plus many MSYS2/MinGW components. The license texts shipped
>> "%OUT%" echo with those components are consolidated below. Each text appears once;
>> "%OUT%" echo later files with identical content only reference the first copy.
>> "%OUT%" echo.

REM Git itself and miscellaneous license files outside the licenses trees
call :add "%ROOT%\LICENSE.txt"
call :add "%ROOT%\ucrt64\doc\git-credential-manager\LICENSE"
call :add "%ROOT%\ucrt64\doc\git-credential-manager\NOTICE"
call :add "%ROOT%\ucrt64\lib\tk8.6\demos\license.terms"
call :add "%ROOT%\usr\share\vim\vim92\LICENSE"

REM Per-component license trees (recursive: gettext-runtime\intl, etc.)
for %%T in ("usr\share\licenses" "ucrt64\share\licenses") do (
    if exist "%ROOT%\%%~T" (
        for /r "%ROOT%\%%~T" %%F in (*) do call :add "%%F"
    )
)

del "%SEEN%" >nul 2>&1
echo Wrote %OUT%
endlocal & exit /b 0

:usage
echo Usage: %~nx0 ^<extracted-prefix^> ^<output-file^>
exit /b 1

REM ---------------------------------------------------------------------------
REM :add <file>  - append one license file (or a back-reference) to %OUT%
REM ---------------------------------------------------------------------------
:add
set "F=%~1"
if not exist "%F%" exit /b 0
set "REL=!F:%ROOT%\=!"

set "H="
for /f "skip=1 delims=" %%H in ('certutil -hashfile "%F%" SHA256 2^>nul') do (
    if not defined H set "H=%%H"
)
set "H=!H: =!"

>> "%OUT%" echo ================================================================================
>> "%OUT%" echo !REL!
>> "%OUT%" echo ================================================================================

set "FIRST="
for /f "usebackq tokens=1,* delims=|" %%A in ("%SEEN%") do (
    if /i "%%A"=="!H!" set "FIRST=%%B"
)
if defined FIRST (
    >> "%OUT%" echo [identical to the text of !FIRST! above]
) else (
    >> "%SEEN%" echo !H!^|!REL!
    type "%F%" >> "%OUT%"
)
>> "%OUT%" echo.
exit /b 0
