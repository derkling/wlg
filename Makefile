# This file is part of wlg - A pretty simple workload mix generator
# Copyright (C) 2014 Patrick Bellasi <derkling@gmail.com>
#
# This program is free software; you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation; either version 2 of the License, or (at your option) any later
# version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.  See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along with
# this program; if not, write to the Free Software Foundation, Inc., 51 Franklin
# Street, Fifth Floor, Boston, MA  02110-1301, USA.

CC=arm-linux-gnueabihf-gcc

ifdef DEBUG
  CFLAGS=-DDEBUG -g
else
  CFLAGS=-O3
endif

all: wlg

wlg: wlg.c Makefile
	$(CC) ${CFLAGS} --static -o $@ $< -lpthread -lrt

PHONY: clean trace
clean:
	rm -f wlg

trace:
	sudo trace-cmd record -e "sched:*" ./wlg -d5 -b1 -p1,100000,30 -i1,200000,3000
	kernelshark

ifndef CORE
  CORE=3
endif

trace1c:
	sudo trace-cmd record -e "sched:*" taskset -c ${CORE} ./wlg -d5 -b1 -p1,100000,30 -i1,200000,3000
	kernelshark

