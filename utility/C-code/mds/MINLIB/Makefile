LIBDIR = ../MATLIB
INCDIR = $(LIBDIR)
LIBS =  -lm  
MODULES = brent mnbrak f1dim ff1dim linmin powell func_min dbrent df1dim dlinmin frprmn 
OBJS = $(MODULES:%=%.o)
LDFLAGS =  -L$(LIBDIR)
CINC = -I$(INCDIR)
ARCS = $(LIBDIR)/matrix.a
CFLAGS =  -I$(INCDIR)
CC = gcc -c -D_NO_PROTO

run: $(OBJS)	
	ar cr libmin.a  $(OBJS)
	ranlib libmin.a


brnet.o:	brent.c 
mnbrak.o:	mnbrak.c 
f1dim.o:	f1dim.c 
ff1dim.o:	ff1dim.c 
linmin.o:	linmin.c 
powell.o:	powell.c 
func_min.o:	func_min.c 
dbrent.o:	dbrent.c 
df1dim.o:	df1dim.c 
dlinmin.o:	dlinmin.c 
frprmn.o:	frprmn.c 




