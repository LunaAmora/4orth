ifndef WABT_PATH
$(error Download Wabt (https://github.com/WebAssembly/wabt) and set $$WABT_PATH)
endif

4ORTH = 4orth

ifeq (, $(shell command -v $(4ORTH)))
$(error Download 4orth (https://github.com/FrankWPA/4orth) and add it to $$PATH)
endif

4ORTH_PATH  = $(shell command -v  $(4ORTH))
4ORTH_DIR   = $(shell dirname -- "$(4ORTH_PATH)")
4ORTH_FLAGS = -I $(4ORTH_DIR) -I $(4ORTH_DIR)/std
4ORTH_COMMAND := com -s

ifeq ($(b), 1)
	4ORTH_COMMAND := $(4ORTH_COMMAND) -b
endif

ifeq ($(r), 1)
	4ORTH_COMMAND := $(4ORTH_COMMAND) -r
endif 

# Optional dependency from binaryen for smaller builds
WASM_OPT = wasm-opt
WASM_OPT_FLAGS = -Oz

ifeq ($(opt), 1)
ifeq (, $(shell command -v $(WASM_OPT)))
$(error Using the subcommand -opt requires $(WASM_OPT) from binaryen)
endif
	4ORTH_COMMAND := $(4ORTH_COMMAND) -opt
endif 

ifeq ($(OS), Windows_NT)
	$(error 4orth compiler only supports Linux)
else
	MKDIR_BUILD = mkdir -p build
	RMDIR = rm -rf
endif

all: build/cart.wasm

# Build cart.wasm from main.porth and run wasm-opt
.PHONY: build/cart.wasm
build/cart.wasm: main.porth
	@$(MKDIR_BUILD)
	$(4ORTH) $(4ORTH_FLAGS) $(4ORTH_COMMAND) $< 
	mv main.wat  build/cart.wat
	mv main.wasm build/cart.wasm
ifeq ($(b), 1)
	mv main build/cart
endif
ifneq ($(opt), 1)
ifneq ($(DEBUG), 1)
ifeq (, $(shell command -v $(WASM_OPT)))
	@echo Tip: $(WASM_OPT) was not found. Install it from binaryen for smaller builds!
else
	$(WASM_OPT) $(WASM_OPT_FLAGS) $@ -o $@
endif
endif
endif

.PHONY: clean
clean:
	$(RMDIR) build
