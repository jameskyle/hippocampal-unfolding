#
INC = -I/usr/local/matlab/extern/include
LIB = -L/usr/local/lib
CMEX = /usr/local/matlab/bin/cmex
CC = gcc

all: rgb2ind.mexhp7

rgb2ind.mexhp7: rgb2ind.c
	$(CC) -c $(INC) $(LIB)  rgb2ind.c
	$(CMEX) rgb2ind.o











