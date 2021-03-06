export MFLAGS := --no-print-directory -s
export GFLAGS := -C -E -t -L C++ -c
export SRCDIR := /home/caktus/bin/UPPAAL-dbm-2.0.8/modules
export DSTDIR := /home/caktus/bin/UPPAAL-dbm-2.0.8/modules
export CC  := gcc-7
export CCC := g++-7
export AR := /usr/bin/ar
export STRIP = /usr/bin/strip
export XML_CONFIG := 
export CFLAGS := -Wall -DNDEBUG -O3 -ffloat-store -fgcse-las -fgcse-lm -fgcse-sm -ftree-loop-linear -funswitch-loops -ftree-loop-im -fivopts -ftree-vectorize -ftracer -msse2 -fPIC -march=native -DENABLE_64BIT    -DBOOST_DISABLE_THREADS
export LINKFLAGS :=   --strip-all   -static
export EXTRALIBS := 

PREFIX=/usr/local

# Modules to compile

MODULES :=  base.lib dbm.lib debug.lib hash.lib io.lib

# Rules:

default:
	@if [ ! -f .config ]; then \
	 $(MAKE) help $(MFLAGS);\
	 echo ; \
	 echo "Setting up build system and compiling."; \
	 echo "If you use different build directories, invoke make there."; \
	 echo ; \
	 $(MAKE) setup $(MFLAGS); \
	 $(MAKE) clean $(MFLAGS); \
	fi
	@$(MAKE) libs $(MFLAGS)

help:
	@echo "General targets:"
	@echo " help    : print this help"
	@echo " setup   : setup compiler,flags,makefiles"
	@echo " all     : make all libs and tests"
	@echo " libs    : make all libs"
	@echo " tests   : make all tests"
	@echo " doc	: generate doxygen documentation (exec make setup first)"
	@echo " clean   : remove all generated files"
	@echo " cleanall: clean + removes config + makefiles"
	@echo " cleanconf: remove temporary configuration directory"
	@echo
	@echo "Targets for specific modules:"
	@echo " %.lib	: make a given module"
	@echo " %.tests	: make tests of a given module"
	@echo " %.clean : clean a given module"

all: libs $(MODULES:.lib=.testonly)

tests: $(MODULES:.lib=.tests)

libs: $(MODULES)

%.lib:
	@if [ -d $(DSTDIR)/$* ]; then \
	 echo "------- make $*"; \
	 $(MAKE) -C $(DSTDIR)/$* $(MFLAGS) MODULE=$*; \
	fi

doc:
	@.scripts/gendoc.sh .. ../documentation/doxygen

%.clean:
	@if [ -d $(DSTDIR)/$* ]; then \
	 $(MAKE) -C $(DSTDIR)/$* clean $(MFLAGS) MODULE=$*; \
	fi

clean: $(MODULES:.lib=.clean)

cleanall: clean
	@rm -rf lib *~ */*~ */*/*~ */.depend */*/.depend .config */Makefile */*/Makefile

%.tests:
	@if [ -d $(DSTDIR)/$*/tests ]; then \
	 echo "------- make $*/tests"; \
	 $(MAKE) -C $(DSTDIR)/$*/tests $(MFLAGS); \
	fi

%.testonly:
	@if [ -d $(DSTDIR)/$*/tests ]; then \
	 echo "------- make $*/tests"; \
	 $(MAKE) -C $(DSTDIR)/$*/tests .depend $(MFLAGS); \
	 $(MAKE) -C $(DSTDIR)/$*/tests $(MFLAGS); \
	fi

install: base.lib dbm.lib debug.lib hash.lib
	@.scripts/mergelibs.sh
	@echo "Installing in $(PREFIX)"
	@install -d $(PREFIX)/uppaal/include
	@install -d $(PREFIX)/uppaal/lib
	@install -d $(PREFIX)/uppaal/bin
	@mv lib/libudbm.a $(PREFIX)/uppaal/lib/
	@cp -r include/* $(PREFIX)/uppaal/include/
	@cp udbm-config $(PREFIX)/uppaal/bin/
	@if [ -d $(PREFIX)/bin ]; then ln -sf $(PREFIX)/uppaal/bin/udbm-config $(PREFIX)/bin/; fi
	@rm -f $(PREFIX)/uppaal/include/config.h.in
