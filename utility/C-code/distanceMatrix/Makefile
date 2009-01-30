#
#	This must be run on maroon, I think -- BW
#
INC = -I/wusr3/matlab/extern/include
CMEX = /wusr3/matlab/bin/cmex
LIB = -L/usr/local/lib
CC = cc

all:  distanceMatrix.mexhp7

distanceMatrix.mexhp7: distanceMatrix.c
	$(CC)  -Aa +z -c $(LIB) $(INC) distanceMatrix.c
	$(CMEX) distanceMatrix.o
	mv distanceMatrix.mexhp7 ../..
