STARTUP_VIM_SCRIPT := tests/minimal_init.lua
TEST_ROOT := tests/

.PHONY: test

test: $(STARTUP_VIM_SCRIPT) $(TEST_ROOT)
	@nvim \
		--headless \
		--noplugin \
		-u $(STARTUP_VIM_SCRIPT) \
		-c "PlenaryBustedDirectory $(TEST_ROOT) { minimal_init = '$(STARTUP_VIM_SCRIPT)' }"
