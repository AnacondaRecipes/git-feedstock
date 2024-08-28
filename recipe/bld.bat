7za x PortableGit-%PKG_VERSION%-%ARCH%-bit.7z.exe -o"%LIBRARY_PREFIX%\" -aoa
if errorlevel 1 exit 1

cd %LIBRARY_PREFIX%
call post-install.bat
del git_bash.exe
del git_cmd.exe
del README.portable
del post-install.bat

REM Prepare shortcuts. The menuinst v2 json files are not compatible
REM with menuinst versions older than 2.1.1. The post-link script
REM will handle which shortcut to use. One file needs to be the default
REM menu file so that conda picks it up when running menuinst.
IF NOT EXIST %PREFIX%\Menu mkdir %PREFIX%\Menu
copy %RECIPE_DIR%\menu-v1.json %PREFIX%\Menu\%PKG_NAME%_menu-v1.json.bak
copy %RECIPE_DIR%\menu-v2.json %PREFIX%\Menu\%PKG_NAME%_menu-v2.json.bak
copy %RECIPE_DIR%\menu-v2.json %PREFIX%\Menu\%PKG_NAME%_menu.json
copy %RECIPE_DIR%\git-for-windows.ico %PREFIX%\Menu\

echo export PATH=$(cygpath -a %PREFIX:\=/%)/Library/bin:$PATH >> %LIBRARY_PREFIX%\etc\profile.d\env.sh
echo. >> %LIBRARY_PREFIX%\etc\profile.d\env.sh

exit 0
