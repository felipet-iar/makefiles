# Target CPU
CPU=cortex-m4

# Build directory
BINDIR = bin

# Target output name
TARGET = firmware

# Toolchain configurations
ICC ?= iccarm
ICCFLAGS = --silent --no_wrap_diagnostics -e --cpu=$(CPU)

IASM ?= iasmarm
IASMFLAGS = -S -s+ -w+ --cpu=$(CPU)

ILINK ?= ilinkarm
ILINKFLAGS = --silent --config generic.icf

IELFTOOL ?= ielftool
IELFTOOLHEX = --silent --ihex
IELFTOOLBIN = --silent --bin

# Debug flags?
DEBUG = 1
ifeq ($(DEBUG), 1)
	ICCFLAGS += -r
	IASMFLAGS += -r
else
	ICCFLAGS += -DNDEBUG
	IASMFLAGS += -DNDEBUG
endif

# The sources!
C_SOURCES = main.c caller.c callee.c
C_DEFS = -DUSE_HAL_DRIVER

ASM_SOURCES = foo.s

# And their respective objects
OBJS  = $(addprefix $(BINDIR)/,$(notdir $(C_SOURCES:.c=.o)))
OBJS += $(addprefix $(BINDIR)/,$(notdir $(ASM_SOURCES:.s=.o)))
-include $(wildcard $(BINDIR)/*.d)

### Build rules
all: $(BINDIR)/$(TARGET).out $(BINDIR)/$(TARGET).hex $(BINDIR)/$(TARGET).bin
	@echo "-- All done."

$(BINDIR)/$(TARGET).hex: $(BINDIR)/$(TARGET).out | $(BINDIR)
	@echo "-- Converting $^ to $@..."
	$(IELFTOOL) $(IELFTOOLHEX) $^ $@

$(BINDIR)/$(TARGET).bin: $(BINDIR)/$(TARGET).out | $(BINDIR)
	@echo "-- Converting $^ to $@..."
	$(IELFTOOL) $(IELFTOOLBIN) $^ $@

$(BINDIR)/$(TARGET).out: $(OBJS)
	@echo "-- Linking $@..."
	$(ILINK) $(ILINKFLAGS) --map $(BINDIR) $^ -o $@

$(BINDIR)/%.o: %.c Makefile | $(BINDIR)
	$(ICC) $(ICCFLAGS) $(C_DEFS) $< --dependencies=m $(BINDIR)/$*.d -o $@

$(BINDIR)/%.o: %.s Makefile | $(BINDIR)
	$(IASM) $(IASMFLAGS) $< -y $(BINDIR)/$*.d -O$(BINDIR)

$(BINDIR):
	@mkdir $@

.PHONY: clean
clean:
	@echo "-- Cleaning..."
	-rm -fR $(BINDIR)

