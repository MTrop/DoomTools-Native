##############################################################################
## DoomTools GUI Bootstrap Makefile
##############################################################################

##############
### PATHS
##############

# Source directory.
SRC_DIR       := src
# Resource directory.
RES_DIR       := resources
# Build directory.
BUILD_DIR     := build
# Distributable directory.
DIST_DIR      := dist
# Modules to build.
MODULES       := common
# Images to build.
RESOURCES     := doomtools-gui
EXECUTABLES   := doomtools-gui
EXE_SUFFIX    := .exe


##############
### UTILITIES
##############

# WinDRes
WRES          := windres
# C Compiler
CC            := gcc
# C Compiler Flags
CCFLAGS       := -Wall
# C Include Directories
INCLUDES      := "-I./$(SRC_DIR)"

# Make directory command.
MKDIR_CMD     := @mkdir
# Delete directory tree command.
DELDIR_CMD    := @rm -Rf


##############
### LISTS
##############

vpath %.c $(SRC_DIR)

RESOURCE_FILES   := $(addprefix $(BUILD_DIR)/,$(addsuffix .res,$(RESOURCES))) 

MODULE_DEST      := $(BUILD_DIR) $(addprefix $(BUILD_DIR)/,$(MODULES)) 
MODULE_SRC_PATHS := $(foreach sdir,$(MODULES),$(wildcard $(SRC_DIR)/$(sdir)/*.c))
MODULE_SRC_FILES := $(patsubst $(SRC_DIR)/%,%,$(MODULE_SRC_PATHS))
MODULE_OBJ_FILES := $(addprefix $(BUILD_DIR)/,$(patsubst %.c,%.o,$(MODULE_SRC_FILES)))

LINKED_SRC_FILES := $(addsuffix .c,$(EXECUTABLES))
LINKED_OBJ_FILES := $(addprefix $(BUILD_DIR)/,$(addsuffix .o,$(EXECUTABLES)))
LINKED_FILES     := $(addprefix $(DIST_DIR)/,$(addsuffix $(EXE_SUFFIX),$(EXECUTABLES)))


## ---------------------------------------------------------------------------
## Targets
## ---------------------------------------------------------------------------

default: makedirs resources compile link
	
clean:
	@echo Cleaning....
	@rm -Rf $(DIST_DIR)
	@rm -Rf $(BUILD_DIR)
	@echo Done.

resources: makedirs $(RESOURCE_FILES)

compile: makedirs $(MODULE_OBJ_FILES)

link: resources compile $(LINKED_FILES)

makedirs: $(MODULE_DEST) $(DIST_DIR)

$(DIST_DIR):
	@mkdir $@

$(MODULE_DEST):
	@mkdir $@

$(BUILD_DIR)/%.res: $(RES_DIR)/%.rc
	@echo ==== Constructing resource $< to $@ ....
	@$(WRES) $< -O coff $@

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c
	@echo ==== Compiling $< to $@ ....
	@$(CC) $(CCFLAGS) $(INCLUDES) -o $@ -c $<

$(LINKED_FILES): $(LINKED_OBJ_FILES)
	@echo ==== Linking $@ ....
	@$(CC) $(CCFLAGS) $(INCLUDES) -o $@ -mwindows $< $(MODULE_OBJ_FILES) $(RESOURCE_FILES)
