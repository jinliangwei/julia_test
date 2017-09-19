ORION_HOME := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
AR = ar
CC = gcc
CXX = g++-5 -std=c++14

DFLAGS = -O3
# use -Wno-deprecated-declarations to turn off warnings from boost w/ g++-5
CFLAGS = $(DFLAGS) -fPIC \
	-W -Wall -Werror -Wno-sign-compare \
	-fno-builtin-malloc \
	-fno-builtin-calloc \
	-fno-builtin-realloc \
	-fno-builtin-free \
	-Wno-unused-parameter


JULIA_HOME=/home/ubuntu/julia-0.5.1/

CFLAGS += -I$(JULIA_HOME)/usr/include -I$(JULIA_HOME)/src -I$(JULIA_HOME)/src/support

CFLAGS += -DJULIA_ENABLE_THREADING=1 -DJULIA_INIT_DIR=\"$(JULIA_HOME)/usr/lib\"
LDFLAGS = -Wl,-rpath,$(JULIA_HOME)/usr/lib -L$(JULIA_HOME)/usr/lib
LIBS = -ljulia

embedding: embedding.cpp
	$(CXX) $(CFLAGS) $< $(LDFLAGS) $(LIBS) -o $@

clean:
	rm embedding

.PHONY: clean
