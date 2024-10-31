STYLE_TOML_FILE := .stylua.toml
STARTUP_VIM_SCRIPT := tests/minimal_init.lua
TEST_ROOT := tests/

.PHONY: pr-ready fmt lint test

pr-ready: fmt lint

fmt: $(STYLE_TOML_FILE)
	@echo "===> Formatting"
	stylua lua/ --config-path=$(STYLE_TOML_FILE)

lint:
	@echo "===> Linting"
	luacheck lua/ --globals vim

test: $(STARTUP_VIM_SCRIPT) $(TEST_ROOT)
	@nvim \
		--headless \
		--noplugin \
		-u $(STARTUP_VIM_SCRIPT) \
		-c "PlenaryBustedDirectory $(TEST_ROOT) { minimal_init = '$(STARTUP_VIM_SCRIPT)' }"
