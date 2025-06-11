7za x PortableGit-%PKG_VERSION%-%ARCH%-bit.7z.exe -o"%LIBRARY_PREFIX%\" -aoa
if errorlevel 1 exit 1

cd "%LIBRARY_PREFIX%"
call post-install.bat
del git_bash.exe
del git_cmd.exe
del README.portable
del post-install.bat

REM Prepare shortcuts. menuinst v2 shortcuts should only be used starting
REM at menuinst v2.1.1 due to bugs. The post-link script
REM will handle which shortcut to use. One file needs to be the default
REM menu file so that conda picks it up when running menuinst.
SET "MENU_DIR=%PREFIX%\Menu"
IF NOT EXIST "%MENU_DIR%" MKDIR "%MENU_DIR%"
if errorlevel 1 exit 1
copy "%RECIPE_DIR%\menu-v1.json" "%MENU_DIR%\%PKG_NAME%_menu-v1.json.bak"
if errorlevel 1 exit 1
copy "%RECIPE_DIR%\menu-v2.json" "%MENU_DIR%\%PKG_NAME%_menu-v2.json.bak"
if errorlevel 1 exit 1
copy "%RECIPE_DIR%\menu-v2.json" "%MENU_DIR%\%PKG_NAME%_menu.json"
if errorlevel 1 exit 1
copy "%RECIPE_DIR%\git-for-windows.ico" "%PREFIX%\Menu\"
if errorlevel 1 exit 1

echo export PATH=$(cygpath -a %PREFIX:\=/%)/Library/bin:$PATH >> %LIBRARY_PREFIX%\etc\profile.d\env.sh
echo. >> "%LIBRARY_PREFIX%\etc\profile.d\env.sh"

exit 0
