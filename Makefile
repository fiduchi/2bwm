VERSION=20120124
DIST=mcwm-$(VERSION)
SRC=mcwm.c list.c config.h events.h list.h
DISTFILES=LICENSE Makefile NEWS README TODO WISHLIST mcwm.man $(SRC)

CFLAGS+=-g -std=c99 -Wall -O3 -march=i686 -mtune=i686 -Wextra -I/usr/local/include -DNDEBUG -DNDMALLOC #-DDEBUG #-DDMALLOC
LDFLAGS+=-L/usr/local/lib -lxcb -lxcb-randr -lxcb-keysyms -lxcb-icccm -lxcb-util #-ldmalloc

RM=/bin/rm
PREFIX=/usr/local

TARGETS=mcwm 
OBJS=mcwm.o list.o

all: $(TARGETS)

mcwm: $(OBJS)
	clang $(CFLAGS) $(LDFLAGS) -o $@ $(OBJS)

mcwm-static: $(OBJS)
	$(CC) -o $@ $(OBJS) -static $(CFLAGS) $(LDFLAGS) \
	-lXau -lpthread -lxcb-util

mcwm.o: mcwm.c events.h list.h config.h Makefile

list.o: list.c list.h Makefile

install: $(TARGETS)
	install -m 755 mcwm $(PREFIX)/bin

uninstall: deinstall
deinstall:
	$(RM) $(PREFIX)/bin/mcwm

$(DIST).tar.bz2:
	mkdir $(DIST)
	cp $(DISTFILES) $(DIST)/
	tar cf $(DIST).tar --exclude .git $(DIST)
	bzip2 -9 $(DIST).tar
	$(RM) -rf $(DIST)

dist: $(DIST).tar.bz2

clean:
	$(RM) -f $(TARGETS) *.o

distclean: clean
	$(RM) -f $(DIST).tar.bz2
