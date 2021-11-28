all: demoodbc driver_connect

demoodbc: demoodbc.c
	g++ -g -o demoodbc -I../include demoodbc.c -L../lib -lodbc -lodbcinst -lc

driver_connect: driver_connect.cc
	g++ -w -g -o driver_connect -I../include -I/usr/openwin/include -I/usr/dt/include -I/usr/X11R6/include driver_connect.cc -L../lib -L/usr/openwin/lib -L/usr/dt/lib -L/usr/X11R6/lib -lodbc -lodbcinst -lXm -lXt -lX11
