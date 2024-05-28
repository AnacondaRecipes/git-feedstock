FOR /F %%i in ('conda run -n base python -c "import menuinst; rm_menufile = \"menu-v1.json\" if tuple(int(x) for x in menuinst.__version__.split(\".\"))[:2] < (2, 1, 0) else \"menu-v2.json\"; print(rm_menufile)"') DO SET RM_MENUFILE=%%i
IF ERRORLEVEL 1 EXIT 1

DEL %PREFIX%\Menu\%RM_MENUFILE%
IF ERRORLEVEL 1 EXIT 1
