# What is Docker?

<img src="screenshots/what-is-docker.png" width=600>

<img src="screenshots/what-is-docker-2.png" width=400>

<img src="screenshots/image-container.png" width=400>

When we install Docker, Docker creates a Linux virtual machine. Everything related to Docker is run within this machine.

<img src="screenshots/what-is-docker-3.png" width=600>

# Why use Docker?

<img src="screenshots/why-use-docker.png" width=600>

# What happens when you run `docker run hello-world`?

When we run command `docker run hello-world` in terminal, we interact with `Docker Client`. We tell Docker Cli what we want to do, Docker Cli forward it to `Docker Server` to process.

`hello-world` is the name of the image. The Docker Server first check in the image cache to see if the image already exists, if not, it reaches out to a free library called `Docker Hub` to download the image and save it in the cache.

Docker Server uses the image to create a container, and start the container with the default command.

<img src="screenshots/hello-world.png" width=700>

# What is a container?

<img src="screenshots/container-1.png" width=700>

<img src="screenshots/container-2.png" width=550>

<img src="screenshots/container-3.png" width=600>

<img src="screenshots/container-4.png" width=500>

<img src="screenshots/container-5.png" width=500>

<img src="screenshots/container-6.png" width=900>

# Commands in Docker Client

Command `run` is a combination of two commands `create` and `start`. It creates a container based on the image, and runs the container with the default command or the override command (if provided). Whatever command we enter, the image has to support it (has code to run it)

<img src="screenshots/docker-run.png" width=700>

<img src="screenshots/docker-run-create-start.png" width=500>

<img src="screenshots/docker-create-start.png" width=700>

<img src="screenshots/docker-logs.png" width=500>

<img src="screenshots/docker-ps.png" width=500>

We can use `docker exec` to execute a container that's been created and run before. We cannot override starting command because we are not creating a new container, we're only execute an existing container

<img src="screenshots/docker-exec.png" width=700>

We can use `docker stop` or `docker kill` to end a running container (in case we don't have the current running container in a terminal window to `cmd C` to exit)

<img src="screenshots/docker-stop-kill.png" width=700>

`docker stop` issues a `SIGTERM` to the container and gives it 10 seconds to gracefully shut down its processes. As a fallback, if after 10s, the container is still running, `docker kill` will be called to shut the container down immediately

<img src="screenshots/docker-stop.png" width=700>

<img src="screenshots/docker-kill.png" width=700>

Example of running a redis container

<img src="screenshots/docker-cmd-example-1.png" width=200>

<img src="screenshots/docker-cmd-example-2.png" width=400>

<img src="screenshots/docker-cmd-example-3.png" width=800>

# Create Custom Image

<img src="screenshots/create-custom-image-1.png" width=600>

<img src="screenshots/create-custom-image-2.png" width=600>

<img src="screenshots/create-custom-image-4.png" width=550>

```Dockerfile
// in Dockerfile (no extension)
# Use an existing docker image as a base
FROM alpine

# Download and install a dependency
RUN apk add --update redis

# Tell the image what to do when it starts as a container
CMD ["redis-server"]
```

<img src="screenshots/create-custom-image-5.png" width=400>

<img src="screenshots/create-custom-image-6.png" width=700>

<img src="screenshots/create-custom-image-7.png" width=500>

After we run `docker build .` at the current directory (where's all the files, and code needs to be included in the image), docker creates the image and saves cache of each step container (`FROM`, `RUN`, `CMD`), so that if it sees the instruction is the same, it'll use cache. This makes building docker image more efficient. So if we add `RUN apk add --update gcc` after update redis, and run `docker build .`, docker uses cache it had for alpine, for running redis, it only needs to run the added step and whatever's after it. So it's best to try to add additional steps as far down as possible.

<img src="screenshots/create-custom-image-8.png" width=600>

<img src="screenshots/create-custom-image-9.png" width=700>

How to add a name to the image

<img src="screenshots/create-custom-image-10.png" width=700>

<img src="screenshots/create-custom-image-11.png" width=700>
