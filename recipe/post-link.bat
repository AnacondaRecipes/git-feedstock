@ECHO OFF

REM The menuinst v2 json file is not compatible with menuinst versions
REM older than 2.1.0. Copy the appropriate file as the menu file.

FOR /F %%i IN (
    'conda run -n base python -c "import menuinst; print(tuple(int(x) for x in menuinst.__version__.split(\".\"))[:3] < (2, 1, 0))"'
) DO (
    IF "%%~i"=="True" GOTO :use_menuinst_v1
)
COPY /y %PREFIX%\Menu\%PKG_NAME%_menu-v2.json.bak %PREFIX%\Menu\%PKG_NAME%_menu.json
GOTO :exit

:use_menuinst_v1:
    COPY /y %PREFIX%\Menu\%PKG_NAME%_menu-v1.json.bak %PREFIX%\Menu\%PKG_NAME%_menu.json
    ECHO "Warning: using menuinst v1 shortcuts"
    ECHO "Please update menuinst in the base environment and reinstall %PKG_NAME%."
    GOTO :exit

:exit
    EXIT /B %ERRORLEVEL%
