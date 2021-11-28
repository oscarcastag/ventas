all: demoodbc driver_connect

demoodbc: demoodbc.c
	g++ -g -DODBC64 -o demoodbc -I../../include demoodbc.c -L../../lib -lodbc -lodbcinst -lc

driver_connect: driver_connect.cc
	g++ -w -g -DODBC64 -o driver_connect -I../../include -I/usr/X11R6/include driver_connect.cc -L../../lib -L/usr/X11R6/lib64 -lodbc -lodbcinst -lXm -lXt -lX11
