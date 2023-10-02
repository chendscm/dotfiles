#!/bin/sh

DIR=/run/current-system/profile

$DIR/bin/xinit -- $DIR/bin/Xorg :0 vt1 -keeptty \
	       -configdir $DIR/share/X11/xorg.cnf.d \
	       -modulepath $DIR/lib/xorg/modules
