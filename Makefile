
ifdef DEBUG
  CFLAGS=-DDEBUG -g
else
  CFLAGS=-O3
endif

all: wlg

wlg: wlg.c Makefile
	gcc -O3 -o $@ $< ${CFLAGS} -lpthread -lrt

PHONY: clean trace
clean:
	rm -f wlg

trace:
	sudo trace-cmd record -e "sched:*" ./wlg -d5 -b1 -p1,100000,30 -i1,200000,3000
	kernelshark

