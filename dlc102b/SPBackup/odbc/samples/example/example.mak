#
# Copyright 2012 Progress Software Corporation. All rights reserved
#
# Purpose:	Make file to build example application 
#
# Requirements:
#
# Shared Library Path Variable:
#	Environment variable should point to the lib directory
#	for this release. This will enable the linker to resolve the
#	location of the various shared libraries and the run-time linker to
#	resolve the location of run-time components.
#
# Note that you must set the make file variable CC in order to build this
# example program. Uncomment one of the platform specific lines in this
# make file.
# 
# To Build example, issue the following command:
#	%make -f example.mak
#
#
############################################################################

# For Linux
CC=g++
LIBC=-lc
CCFLAGS=-g

#
# Compiler options
#
# For 64-bit
DEFS=-DODBCVER=0x0350 -DODBC64
INCLUDE=-I../../include

#
# Definition for standard system linker
#
LD=ld

#
# Define Support Libraries used.
#
LIBPATH=-L../../lib

LIBS=$(LIBPATH) -lodbc 

# For Linux
LIBS=$(LIBPATH) -lodbc -lodbcinst

#
# Application that shows a single C source code connecting to different
# vendor databases by simply changing the passed in DSN.
#
#
# Sample program using C Compiler
#
example:	example.c
	$(CC) -o $@ $(DEFS) $(CCFLAGS) $(INCLUDE) example.c $(LIBS) $(LIBC)

clean:
	/bin/rm example
#
# End of Makefile
#
