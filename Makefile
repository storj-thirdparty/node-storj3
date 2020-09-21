GOBUNDLE=$(PWD)/go.tar.gz
GOBIN=$(PWD)/go/bin/go

GOURL_DARWIN_AMD64=https://dl.google.com/go/go1.15.2.darwin-amd64.tar.gz
GOURL_LINUX_AMD64=https://dl.google.com/go/go1.15.2.linux-amd64.tar.gz

# Go parameters
GOCMD=go
GOBUILD=$(GOCMD) build
GOCLEAN=$(GOCMD) clean
GOTEST=$(GOCMD) test
GOGET=$(GOCMD) get
# Uplink-c
GIT_REPO=https://github.com/storj/uplink-c
UPLINKC_NAME=uplink-c
UPLINKC_VERSION=v1.0.5
#Library Name
LIBRARY_NAME_LINUX=libuplinkc.so
LIBRARY_NAME_DARWIN=libuplinkc.dylib
LIBRARY_NAME_WIN=libuplinkc.dll
LIBRARY_UPLINK=uplink_definitions.h
DELETE_LIBRARY_HEADER=libuplinkc.h
#Color
RED_COLOR=\033[31m
GREEN_COLOR=\033[32m
RESET_COLOR=\033[0m
#
build:
ifdef OS
	git clone -b ${UPLINKC_VERSION} ${GIT_REPO}
	(cd ${UPLINKC_NAME}) && (${GOBUILD} -o ../${LIBRARY_NAME_WIN} -buildmode=c-shared) && (move ${LIBRARY_UPLINK} ../)
	rmdir /s ${UPLINKC_NAME}
else
	echo "$(shell uname)";\
     if [ ! -d $(UPLINKC_NAME) ]; then\
      git clone -b $(UPLINKC_VERSION) $(GIT_REPO);\
     fi;\
     if [ $(shell uname) = Darwin ]; then\
	 	curl $(GOURL_DARWIN_AMD64) --output $(GOBUNDLE);\
		gunzip -c $(GOBUNDLE) | tar xopf -;\
		rm $(GOBUNDLE);\
		chmod +x $(GOBIN);\
		cd $(UPLINKC_NAME);\
		$(GOBIN) build -o ../$(LIBRARY_NAME_DARWIN) -buildmode=c-shared;\
		mv $(LIBRARY_UPLINK) ../;\
		cd ../;\
     fi;\
     if [ $(shell uname) = Linux ]; then\
		curl $(GOURL_LINUX_AMD64) --output $(GOBUNDLE);\
		tar xvfs $(GOBUNDLE);\
		rm $(GOBUNDLE);\
		chmod +x $(GOBIN);\
		cd $(UPLINKC_NAME);\
		$(GOBUILD) -o ../$(LIBRARY_NAME_LINUX) -buildmode=c-shared;\
		mv $(LIBRARY_UPLINK) ../;\
		cd ../;\
     fi;\
  if test -d ./$(UPLINKC_NAME); then rm -rf ./$(UPLINKC_NAME); fi;\
  echo ' $(GREEN_COLOR) \n Successfully build $(RESET_COLOR)';
endif
clean:
ifdef OS
	(IF EXIST ${LIBRARY_UPLINK}; (del "${LIBRARY_UPLINK}")) && (IF EXIST ${DELETE_LIBRARY_HEADER}; (del "${DELETE_LIBRARY_HEADER}")) && (IF EXIST ${LIBRARY_NAME_WIN}; (del "${LIBRARY_NAME_WIN}")) && (IF EXIST ${UPLINKC_NAME}; (rmdir /s "${UPLINKC_NAME}"))
else
	if test -d $(UPLINKC_NAME); then rm -rf $(UPLINKC_NAME); fi
	if test -f ./$(LIBRARY_UPLINK); then rm ./$(LIBRARY_UPLINK); fi;\
  if test -f ./$(DELETE_LIBRARY_HEADER); then rm ./$(DELETE_LIBRARY_HEADER); fi;\
    if [ $(shell uname) = Darwin ]; then\
      if test -f ./$(LIBRARY_NAME_DARWIN); then rm ./$(LIBRARY_NAME_DARWIN); fi;\
     fi;\
     if [ $(shell uname) = Linux ]; then\
      if test -f $(LIBRARY_NAME_LINUX); then rm $(LIBRARY_NAME_LINUX); fi;\
     fi;
endif
	@echo ' $(GREEN_COLOR) \n Successfully cleaned $(RESET_COLOR)';
