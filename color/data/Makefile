#
INC = -I/home/cap/include -I/usr/local/matlab/extern/include
LIB = -L/usr/local/lib
CMEX = /usr/local/matlab/bin/cmex

all: readcap.mex4

readcap.mex4: readcap.c
	gcc -c $(INC) $(LIB) readcap.c
	$(CMEX) readcap.o /usr/local/lib/libcap.a

#readcap: readcap.c
# gcc -c $(INC) $(LIB) readcap.c
# cmex -debug readcap.o /usr/local/lib/libcap.a


