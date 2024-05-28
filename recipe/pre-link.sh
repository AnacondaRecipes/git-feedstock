#!/bin/bash

RM_MENUFILE=$(conda run -n base python -c 'import menuinst; rm_menufile = "menu-v1.json" if tuple(int(x) for x in menuinst.__version__.split(".")[:2]) < (2, 1, 0) else "menu-v2.json"; print(rm_menufile)')

rm ${PREFIX}/Menu/${RM_MENUFILE}
