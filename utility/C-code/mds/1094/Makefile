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

mmds: $(OBJS) 
	$(CC) -g -o mmds $(CFLAGS) $(OBJS) $(LDFLAGS) $(LIBS) 

main.o: main.c mds.h
mds.o: mds.c mds.h
distrb.o: distrb.c distrb.h

install:
	mv mmds /home/brian/bin


######  These were the commands we used to make it go
on the HP.

gcc -c -g -D_NO_PROTO -IMATLIB -IMINLIB -LMATLIB -LMINLIB main.c -o main.o
gcc -c -g -D_NO_PROTO -IMATLIB -IMINLIB -LMATLIB -LMINLIB mds.c -o mds.o
gcc -c -g -D_NO_PROTO -IMATLIB -IMINLIB -LMATLIB -LMINLIB distrb.c -o distrb.o

gcc main.o distrb.o mds.o MINLIB/libminHP.a MATLIB/libmatHP.a -lm -o mds
