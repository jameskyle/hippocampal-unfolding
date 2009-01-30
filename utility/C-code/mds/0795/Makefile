LIBDIR = MATLIB MINLIB
INCDIR = $(LIBDIR)
LIBS = -lm -lmat -lmin 
MODULES = main mds distrb
OBJS = $(MODULES:%=%.o)
LDFLAGS = $(LIBDIR:%=-L%)
CINC =  $(INCDIR:%=-I%)
ARCS = 
CFLAGS =  $(INCDIR:%=-I%)
CC = gcc -g -D_NO_PROTO

mds: $(OBJS) 
	$(CC) -g -o mds $(OBJS) $(LDFLAGS) $(LIBS) 
main.o: main.c mds.h
mds.o: mds.c mds.h
distrb.o: distrb.c distrb.h