#
# A convenience Makefile with commonly used commands for webui
#
# Written by Glen Darling (mosquito@darlingevil.com), June 2019.
#


# Configure all of these "MY_" variables for your personal situation

MY_BIND_ADDRESS  := '0.0.0.0'
MY_BIND_PORT     := 3000
MY_HOST_PORT     := 80


# Running `make` with no target builds and runs netmon as a restarting daemon
all: build run

# Build the container and tag it, "webui".
build:
	docker build -t webui .

# Running `make dev` will setup a working environment, just the way I like it.
# On entry to the container's bash shell, run `cd /outside` to work here.
dev: build
	-docker rm -f webui 2>/dev/null || :
	docker run -it \
	    --name webui \
	    -e MY_BIND_ADDRESS=$(MY_BIND_ADDRESS) \
	    -e MY_BIND_PORT=$(MY_BIND_PORT) \
	    -p $(MY_HOST_PORT):3000 \
	    --volume `pwd`:/outside webui /bin/sh

# Run the container as a daemon (build not forecd here, so must build it first)
run:
	-docker rm -f webui 2>/dev/null || :
	docker run -d \
	    --name webui --restart unless-stopped \
	    -e MY_BIND_ADDRESS=$(MY_BIND_ADDRESS) \
	    -e MY_BIND_PORT=$(MY_BIND_PORT) \
	    -p $(MY_HOST_PORT):$(MY_BIND_PORT) \
	    webui

# Enter the context of the daemon container
exec:
	docker exec -it webui /bin/sh

# Stop the daemon container
stop:
	-docker rm -f webui 2>/dev/null || :

# Stop the daemon container, and cleanup
clean: stop
	-docker rmi webui 2>/dev/null || :

# Declare all non-file-system targets as .PHONY
.PHONY: all build dev run exec stop clean

