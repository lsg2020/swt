PLAT ?= none
PLATS = linux freebsd macosx

none :
	@echo "Please do 'make PLATFORM' where PLATFORM is one of these:"
	@echo "   $(PLATS)"

.PHONY: all clean build skynet

BUILD_DIR = $(PWD)/build
BIN_DIR = $(BUILD_DIR)
CLUALIB_DIR = $(BUILD_DIR)/clualib
CSERVICE_DIR = $(BUILD_DIR)/cservice

linux : PLAT = linux
macosx : PLAT = macosx
freebsd : PLAT = freebsd
linux macosx freebsd: all

all: build

build:
	-mkdir -p $(BIN_DIR)
	-mkdir -p $(CLUALIB_DIR)
	-mkdir -p $(CSERVICE_DIR)

# skynet
all: skynet
SKYNET_MAKEFILE=skynet/Makefile

$(SKYNET_MAKEFILE):
	git submodule update --init

SKYNET_DEP_PATH= SKYNET_BUILD_PATH=$(BIN_DIR) \
		LUA_CLIB_PATH=$(CLUALIB_DIR) \
		CSERVICE_PATH=$(CSERVICE_DIR)

build-lua:
ifeq ($(CLONEFUNC),true)
	cd skynet/3rd/lua && $(MAKE) CC='$(CC) -std=gnu99 -fPIC' $(PLAT)
endif

build-skynet: | $(SKYNET_MAKEFILE)
	cd skynet && $(MAKE) PLAT=$(PLAT) $(SKYNET_DEP_PATH)

copy-skynet-bin:
	cp skynet/3rd/lua/lua $(BIN_DIR)
	cp skynet/3rd/lua/luac $(BIN_DIR)

skynet: build-lua build-skynet copy-skynet-bin

clean-skynet:
	cd skynet && $(MAKE) $(SKYNET_DEP_PATH) clean

clean: clean-skynet


# 3rd
.PHONY: 3rd
all: 3rd

linux: CFLAGS = -g3 -O2 -rdynamic -Wall -Iskynet/3rd/lua -Iskynet/skynet-src
linux: LDFLAGS += -lrt -pthread -lm -ldl
macosx: CFLAGS = -dynamiclib -Wl,-undefined,dynamic_lookup -g3 -O2 -rdynamic -Iskynet/3rd/lua -Iskynet/skynet-src
macosx: LDFLAGS += -pthread -lm -ldl

SHARED = -fPIC --shared
CLUALIB=profile cjson
CSERVICE=


CLUALIB_TARGET=$(patsubst %, $(CLUALIB_DIR)/%.so, $(CLUALIB))
CSERVICE_TARGET=$(patsubst %, $(CSERVICE_DIR)/%.so, $(CSERVICE))

3rd: $(CLUALIB_TARGET) \
	$(CSERVICE_TARGET)

# lua cjson ####################################
CJSON_SOURCE=3rd/lua-cjson/lua_cjson.c \
	3rd/lua-cjson/strbuf.c \
	3rd/lua-cjson/fpconv.c

3rd/lua-cjson/lua_cjson.c:
	git submodule update --init 3rd/lua-cjson

$(CLUALIB_DIR)/cjson.so: $(CJSON_SOURCE)
	gcc $(CFLAGS) -I3rd/lua-cjson $(SHARED) $^ -o $@ $(LDFLAGS)

# lua profile ####################################
LUAPROFILE_SOURCE=3rd/luaprofile/imap.c \
	3rd/luaprofile/profile.c \
	3rd/luaprofile/icallpath.c

3rd/luaprofile/imap.c:
	git submodule update --init 3rd/luaprofile

$(CLUALIB_DIR)/profile.so: $(LUAPROFILE_SOURCE)
	#gcc $(CFLAGS) $(SHARED) -lprofiler -DUSE_EXPORT_NAME -DUSE_RDTSC $^ -o $@
	gcc $(CFLAGS) $(SHARED) -DUSE_EXPORT_NAME -DUSE_RDTSC $^ -o $@

# vue ####################################
.PHONY: vue
build_vue:
	cd vue && npm install
	# export NODE_OPTIONS=--openssl-legacy-provider
	cd vue && npm run build
	
# clean ####################################
clean:
	-rm -rf $(BUILD_DIR)
