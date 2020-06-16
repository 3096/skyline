# TODO (Khangaroo): Make this process a lot less hacky (no, export did not work)
# See MakefileNSO

.PHONY: all clean skyline send

PYTHON := python3
ifeq (, $(shell which python3))
	# if no python3 alias, fall back to `python` and hope it's py3
	PYTHON   := python
endif

NAME 			:= $(shell basename $(CURDIR))
NAME_LOWER		:= $(shell echo $(NAME) | tr A-Z a-z)
TID				:= tid-goes-here
CODE_NAME		:= example
SUBSDK_NAME		:= subsdk1

SCRIPTS_DIR		:= scripts
BUILD_DIR 		:= build

SEND_PATCH		:= $(SCRIPTS_DIR)/send_over_ftp.py

MAKE_NSO		:= nso.mk

all: skyline $(CODE_NAME).npdm

skyline:
	$(MAKE) all -f $(MAKE_NSO) MAKE_NSO=$(MAKE_NSO) BUILD=$(BUILD_DIR) TARGET=$(NAME)

$(CODE_NAME).npdm: $(CODE_NAME).json
	npdmtool $(CODE_NAME).json $(CODE_NAME).npdm

send: all
	$(PYTHON) $(SEND_PATCH) $(IP) $(TID) $(CODE_NAME) $(SUBSDK_NAME)

clean:
	$(MAKE) clean -f $(MAKE_NSO)
	@rm $(CODE_NAME).npdm
