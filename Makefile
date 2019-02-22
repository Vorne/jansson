BUILD_DIR ?= ../xl
include $(BUILD_DIR)/makefile.d/base.mk

CFLAGS += -Isrc -DHAVE_STDINT_H=1

# Fall back to OUTPUT_DIR. Keeps this build working if there is a mismatch with the xl repo.
LIBRARY_OUTPUT_DIR ?= $(OUTPUT_DIR)

JANSSON_A = $(LIBRARY_OUTPUT_DIR)/libjansson.a

HEADERS += src/jansson.h
HEADERS += src/jansson_config.h
HEADERS += src/hashtable.h
HEADERS += src/strbuffer.h
HEADERS += src/utf.h
HEADERS += src/jansson_private.h

OBJS += $(LIBRARY_OUTPUT_DIR)/dump.o
OBJS += $(LIBRARY_OUTPUT_DIR)/error.o
OBJS += $(LIBRARY_OUTPUT_DIR)/hashtable.o
OBJS += $(LIBRARY_OUTPUT_DIR)/hashtable_seed.o
OBJS += $(LIBRARY_OUTPUT_DIR)/load.o
OBJS += $(LIBRARY_OUTPUT_DIR)/memory.o
OBJS += $(LIBRARY_OUTPUT_DIR)/pack_unpack.o
OBJS += $(LIBRARY_OUTPUT_DIR)/strbuffer.o
OBJS += $(LIBRARY_OUTPUT_DIR)/strconv.o
OBJS += $(LIBRARY_OUTPUT_DIR)/utf.o
OBJS += $(LIBRARY_OUTPUT_DIR)/value.o

src/jansson_config.h: cppunit/jansson_config.h
	cp $< $@

$(LIBRARY_OUTPUT_DIR):
	$(VERBOSE)mkdir -p $(LIBRARY_OUTPUT_DIR)

$(LIBRARY_OUTPUT_DIR)/%.o: src/%.c $(HEADERS) | $(LIBRARY_OUTPUT_DIR)
	$(CC) $(CFLAGS) $(PROFILE_FLAGS) -c $< -o $@

$(JANSSON_A): $(HEADERS) $(OBJS) | $(LIBRARY_OUTPUT_DIR)
	echo $(findstring fPIC,$(CFLAGS))
	$(AR) src $(JANSSON_A) $(OBJS)

clean:
	rm -rf $(LIBRARY_OUTPUT_DIR) src/jansson_config.h

all: $(JANSSON_A)
