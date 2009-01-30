#
#	Metric multidimensional scaling makefile
#
LDIR = -L./MATLIB -L./MINLIB
IDIR = -I./MATLIB -I./MINLIB
LIBS = -lm -lmatSPARC -lminSPARC
OBJS = main.o mds.o distrb.o
CFLAGS =  -g -c -D_NO_PROTO
CC = gcc

mds: $(OBJS)
	$(CC) $(OBJS) $(LDIR) $(LIBS) -o mmds 

main.o: main.c mds.h
	$(CC) $(CFLAGS) $(IDIR) main.c

mds.o: mds.c mds.h
	$(CC) $(CFLAGS) $(IDIR) mds.c

distrb.o: distrb.c distrb.h
	$(CC) $(CFLAGS) $(IDIR) distrb.c

install:
	mv mmds /usr/local/bin/mmds

######  These were the commands we used to make it go on the HP.

#gcc -c -g -D_NO_PROTO -IMATLIB -IMINLIB -LMATLIB -LMINLIB main.c -o main.o
#gcc -c -g -D_NO_PROTO -IMATLIB -IMINLIB -LMATLIB -LMINLIB mds.c -o mds.o
#gcc -c -g -D_NO_PROTO -IMATLIB -IMINLIB -LMATLIB -LMINLIB distrb.c -o distrb.o

#gcc main.o distrb.o mds.o MINLIB/libminHP.a MATLIB/libmatHP.a -lm -o mds
