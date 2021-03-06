# Support for:
# - cl (Microsoft Visual C++)
# - icc (Intel C++)
# - g++ (GNU C++)

# Programs to use, override on the command
# line with BISON=something for example.

BISON := bison
LEX   := flex
GPERF := gperf

# Skip global definitions if recursive call

ifeq (0,${MAKELEVEL})

export MFLAGS := --no-print-directory -s
export GFLAGS := -C -E -t -L C++ -c
export SRCDIR := /home/caktus/bin/UPPAAL-dbm-2.0.8/modules
export DSTDIR := /home/caktus/bin/UPPAAL-dbm-2.0.8/modules
export CC     := gcc-7
export CXX    := g++-7
export AR     := /usr/bin/ar
export STRIP  := /usr/bin/strip
export XML_CONFIG := 
export CFLAGS := -Wall -DNDEBUG -O3 -ffloat-store -fgcse-las -fgcse-lm -fgcse-sm -ftree-loop-linear -funswitch-loops -ftree-loop-im -fivopts -ftree-vectorize -ftracer -msse2 -fPIC -march=native -DENABLE_64BIT    -DBOOST_DISABLE_THREADS $(XFLAGS)
export OS     := Linux
export LINKFLAGS :=   --strip-all   -static
export EXTRALIBS := 
export XMLSTATIC := 

endif

ifeq (Cygwin,$(OS))
EXE := .exe
endif

ifeq (i586-mingw32msvc-gcc,$(CC))
EXE := .exe
endif

ifeq (amd64-mingw32msvc-gcc,$(CC))
EXE := .exe
endif

# Setup (compile parser, include lexer, generated=.cc)

MODULETEST := $(shell cd .. ; basename `pwd`)/$(shell basename `pwd`)
TESTSRC    := $(SRCDIR)/$(MODULETEST)
TESTDST    := $(DSTDIR)/$(MODULETEST)
LEXER      := $(wildcard $(TESTSRC)/*.l $(TESTSRC)/*.gperf)
PARSER     := $(wildcard $(TESTSRC)/*.y)
PARSEROBJS := $(patsubst %.y,%.o,$(notdir $(PARSER)))
GENERATED  := $(patsubst %.l,%.cc,$(patsubst %.y,%.cc,$(patsubst %.gperf,%.cc,$(notdir $(LEXER) $(PARSER)))))
IGNORE     := $(shell if [ -f $(TESTSRC)/.ignore ] ; then cat $(TESTSRC)/.ignore; fi)
SOURCES    := $(filter-out $(patsubst %,$(TESTSRC)/%,$(IGNORE)), $(wildcard $(TESTSRC)/*.cpp $(TESTSRC)/*.c))
OBJS       := $(patsubst %.c,%.o,$(patsubst %.cpp,%.o,$(notdir $(SOURCES))))
TARGET     := $(OBJS:.o=$(EXE))
OBJS       += $(PARSEROBJS)
INC    	   := -I$(TESTDST) -I$(DSTDIR)/include -I$(TESTSRC) -I$(SRCDIR)/include
DEPEND     := $(shell cat $(TESTSRC)/lib.dep)
DEPLIBS    := $(DEPEND:--start-group=)
DEPLIBS    := $(DEPLIBS:--end-group=)
LIBS       := $(addprefix $(DSTDIR)/lib/lib, $(addsuffix .a, $(DEPLIBS)))
LIBRULES   := $(addsuffix .rule, $(DEPLIBS))

# Fix flags for MacOSX
DEPCFLAGS  := $(CFLAGS:-isysroot=)
DEPCFLAGS  := $(DEPCFLAGS:/Developer/SDKs/MacOSX10.5.sdk=)

# Link options depend on Cygwin

ifeq (Cygwin,$(OS))
LINKLIBS += -liberty
endif

# Link options depend on icc options

ifeq (icc-ipo,$(CXX)$(findstring -ipo,$(CFLAGS)))
LINKLIBS := $(addprefix $(DSTDIR)/,$(addsuffix /*.o, $(DEPLIBS)))
else
LINKLIBS := -L$(DSTDIR)/lib $(addprefix -l, $(DEPEND))
LINKLIBS := $(LINKLIBS:-l--start-group=--start-group)
LINKLIBS := $(LINKLIBS:-l--end-group=--end-group)
endif

# Link flags depend depend on Mac OS X

ifeq (Darwin,$(OS))
LINKFLAGS += -Wl,-search_paths_first
endif

# Local override of definitions

-include $(TESTSRC)/makefile.def

# Common rules

default :
	@$(MAKE) lib $(MFLAGS) && $(MAKE) targetsonly $(MFLAGS)

all : $(GENERATED) $(LIBRULES) $(OBJS) $(TARGET)

gen : $(GENERATED)

targetsonly : gen $(TARGET)

lib : dep $(LIBRULES)

dep: .depend

show_cflags:
	@echo "Compiling $(MODULETEST) using $(CFLAGS)"

.depend: show_cflags $(GENERATED) $(SOURCES) makedep

makedep:
#	@echo "makedepend $(CFLAGS): $(MODULETEST)/.depend"
	@echo "# DO NOT DELETE" > $(TESTDST)/.depend
	@makedepend -f- -o.o -- $(DEPCFLAGS) -- -Y $(INC) $(SOURCES) $(PARSER) 2>/dev/null | sed "s:^$(TESTSRC)/::g" > $(TESTDST)/.depend

.PRECIOUS: $(OBJS) $(GENERATED)

clean :
	@echo "------- clean $(MODULETEST)"
	@rm -f *.o $(TARGET) $(GENERATED) $(addsuffix .exe,$(TARGET)) *~ *.pdb *.il *.stackdump *.core core

%.rule :
	@if [ -d $(DSTDIR)/$* ]; then \
	 echo "------- make $*"; \
	 $(MAKE) -C $(DSTDIR)/$* $(MFLAGS) MODULE=$*; \
	else echo "Error: no module $*"; exit 1; fi

# Rules for *nix

%.a : $(notdir $*.rule)

%.o : $(TESTSRC)/%.cpp
	@echo "$(CXX) $($@-FLAGS): $(MODULETEST)/$@"
	@$(CXX) -o $@ -c $< $(CFLAGS) $($@-FLAGS) $(INC)

%.o : %.cc
	@echo "$(CXX) $($@-FLAGS): $(MODULETEST)/$@"
	@$(CXX) -o $@ -c $< $(CFLAGS) $($@-FLAGS) $(INC)

%.o : $(TESTSRC)/%.c
	@echo "$(CC) $($@-FLAGS): $(MODULETEST)/$@"
	@$(CC) -o $@ -c $< $(CFLAGS) $($@-FLAGS) $(INC)

%$(EXE) : %.o $(LIBS)
	@echo "$(CXX) $(LINKFLAGS) $($@-FLAGS): $(MODULETEST)/$@"
	@$(CXX) -o $@ $< $(LINKFLAGS) $($@-FLAGS) $(LINKLIBS) $(EXTRALIBS)
ifeq (,$(findstring -g,$(CFLAGS))$(findstring -pg,$(CFLAGS)))
	@echo "$(STRIP) $@"
	@$(STRIP) $@
endif

# Generic rules to generate source (gperf,lex,bison)

%.cc : $(TESTSRC)/%.gperf
	@echo "$(GPERF) $(GFLAGS) $($@-FLAGS): $(MODULETEST)/$@"
	@$(GPERF) $(GFLAGS) $($@-FLAGS) $< > $@

%.cc : $(TESTSRC)/%.l
	@echo "$(LEX) $($@-FLAGS): $(MODULETEST)/$@"
	@$(LEX) $($@-FLAGS) -o$@ $<

%.cc : $(TESTSRC)/%.y
	@echo "$(BISON) -y $($@-FLAGS): $(MODULETEST)/$@"
	@$(BISON) -y $($@-FLAGS) -o $@ $<

# Additional rules

-include $(TESTSRC)/makefile.rules

# Dependencies (after make dep)

-include $(TESTDST)/.depend
