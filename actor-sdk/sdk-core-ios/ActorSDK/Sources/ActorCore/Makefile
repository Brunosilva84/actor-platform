.SUFFIXES: .java .m

# Reading configuration from XCode
WORKING_DIR = $(CONFIGURATION_TEMP_DIR)/j2objc
OBJ_DIR = $(WORKING_DIR)/Objects
ARCHFLAGS = $(ARCHS:%=-arch %)
SDKFLAGS = --sysroot $(SDKROOT)
SDK_ROOT = $(abspath $(PROJECT_DIR)/..)

ifdef OPTIMIZATION_LEVEL
DEBUGFLAGS := $(DEBUGFLAGS) -O$(OPTIMIZATION_LEVEL)
endif

ifdef OTHER_CFLAGS
DEBUGFLAGS := $(DEBUGFLAGS) $(OTHER_CFLAGS)
endif

# Workaround for iPhoneSimulator SDK's gcc bug
ifdef EFFECTIVE_PLATFORM_NAME
ifneq ($(EFFECTIVE_PLATFORM_NAME), -iphonesimulator)
WARNINGS := $(WARNINGS) -Wreturn-type
endif
endif

null :=
space := ${null} ${null}

J2OBJC_DISTRIBUTION = $(PODS_ROOT)/J2ObjC-Framework/Distributive
J2OBJC = $(J2OBJC_DISTRIBUTION)/j2objc
J2OBJCC = $(J2OBJC_DISTRIBUTION)/j2objcc
J2OBJC_ARGS = -use-arc --generate-deprecated --doc-comments -g --static-accessor-methods
J2OBJCC_ARGS = -ObjC -fobjc-arc -fembed-bitcode-marker -Wobjc-designated-initializers -g $(ARCHFLAGS) $(SDKFLAGS) -I$(J2OBJC_DISTRIBUTION)/include

LIBRARY_NAME = libactor.so

SOURCE_ROOTS = \
	$(SDK_ROOT)/sdk-core/runtime/runtime-shared/src/main/java \
	$(SDK_ROOT)/sdk-core/runtime/runtime-generic/src/main/java \
	$(SDK_ROOT)/sdk-core/runtime/runtime-cocoa/src/main/java \
	$(SDK_ROOT)/sdk-core/core/core-shared/src/main/java \
	$(SDK_ROOT)/sdk-core/core/core-cocoa/src/main/java

EXCLUDED_CLASSES = \
	com.google.j2objc.annotations.ObjectiveCName \
    com.google.j2objc.annotations.Propery

PREFIXES = \
    --prefixes $(SDK_ROOT)/sdk-core/runtime/runtime-cocoa/src/main/prefixes.properties \
	--prefixes $(SDK_ROOT)/sdk-core/core/core-cocoa/prefixes.properties

SOURCES_DIR = $(WORKING_DIR)/Sources

EXCLUDED_FILES	= $(foreach class,$(EXCLUDED_CLASSES),$(subst .,/,$(class)).java)
JAVA_FILES = $(filter-out $(EXCLUDED_FILES),$(foreach dir,$(SOURCE_ROOTS),$(shell dir2='${dir}//'; find $(dir) -name "*.java" | cut -c $${\#dir2}- )))
OBJC_FILES = $(addprefix $(SOURCES_DIR)/, $(JAVA_FILES:.java=.m))
OBJECT_FILES = $(addprefix $(OBJ_DIR)/, $(JAVA_FILES:.java=.o))
SOURCE_PATHS = $(subst $(space),:,$(SOURCE_ROOTS))

UPDATED_SOURCES = $(WORKING_DIR)/.sources.list

# Helper to avoid "Argument list too long"
define max_args
  $(eval _args:=)
  $(foreach obj,$3,$(eval _args+=$(obj))$(if $(word $2,$(_args)),$1$(_args)$(EOL)$(eval _args:=)))
  $(if $(_args),$1$(_args))
endef
define EOL


endef

# Build Tasks

# default:
# 	echo $(SDKROOT)

default: | translate build

# Translating files

translate: | $(SOURCES_DIR) $(WORKING_DIR) $(OBJ_DIR) pre_translate $(OBJC_FILES)
	@if [ `cat $(UPDATED_SOURCES) | wc -l` -ge 1 ] ; then \
	$(J2OBJC) $(J2OBJC_ARGS) $(PREFIXES) -sourcepath $(SOURCE_PATHS) -d $(SOURCES_DIR) \
	`cat $(UPDATED_SOURCES)` ; \
	fi

pre_translate:
	@rm -f $(UPDATED_SOURCES)
	@touch $(UPDATED_SOURCES)

define SOURCE_ROOT_RULE
$(SOURCES_DIR)/%.m: $1/%.java
	@echo $$? >> $$(UPDATED_SOURCES)
endef
$(foreach root,$(SOURCE_ROOTS),$(eval $(call SOURCE_ROOT_RULE,$(root))))

# Compile files
# $(call max_args,ar rcs $(OBJ_DIR)/$(LIBRARY_NAME),100,$(OBJECT_FILES))
# @ar rcs $(OBJ_DIR)/$(LIBRARY_NAME) $(OBJECT_FILES)
# @rm -f $(OBJ_DIR)/$(LIBRARY_NAME)
# $(call max_args,@ar crv $(OBJ_DIR)/$(LIBRARY_NAME),2,$(OBJECT_FILES))
build: $(OBJ_DIR) $(OBJECT_FILES)
	@rm -f $(OBJ_DIR)/$(LIBRARY_NAME)
	@ar rcs $(OBJ_DIR)/$(LIBRARY_NAME) $(OBJECT_FILES)
	@ranlib $(OBJ_DIR)/$(LIBRARY_NAME)

$(OBJ_DIR)/%.o: $(SOURCES_DIR)/%.m
	@mkdir -p $(dir $@)
	$(J2OBJCC) $(J2OBJCC_ARGS) -I$(SOURCES_DIR) -c $? -o $@

# Dirs
$(WORKING_DIR):
	@mkdir -p $(WORKING_DIR)

$(SOURCES_DIR):
	@mkdir -p $(SOURCES_DIR)

$(OBJ_DIR):
	@mkdir -p $(OBJ_DIR)

clean:
	@rm -rf $(SOURCES_DIR) $(WORKING_DIR)
