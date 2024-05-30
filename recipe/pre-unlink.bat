REM If a menuinst v1 shortcut has been used, uninstalling will result in a size mismatch warning
REM since conda expects the v2 shortcut. Copying the v2 shortcut file will remove this.

COPY /y %PREFIX%\Menu\%PKG_NAME%_menu-v2.json.bak %PREFIX%\Menu\%PKG_NAME%_menu.json
