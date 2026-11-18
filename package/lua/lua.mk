define MYOSOTIS_LUA_LINK_LIBM
	$(SED) '/-shared -Wl,-soname/s|$$| $$(LIBS)|' $(@D)/src/Makefile
endef
LUA_POST_PATCH_HOOKS += MYOSOTIS_LUA_LINK_LIBM