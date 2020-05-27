# What is Docker?

<img src="screenshots/what-is-docker.png" width=600>

<img src="screenshots/what-is-docker-2.png" width=400>

<img src="screenshots/docker-compose.png" width=350>

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

## New way Docker CLI commands

- `docker container --help`: get the list of subcommands that works with command `container`
- `docker container ls`: list out running docker containers (~ `docker ps`)
- `docker container ls -a`: list out running docker containers (~ `docker ps --all`)
- `docker container run --publish 80:80 --detach --name webhost nginx`: (~ `docker run -p 80:80 -d --name webhost nginx`) run nginx container downloaded from Docker Hub. `--name webhost` is to set the name of this container to webhost instead of using the randomly generated name by docker
- `docker container logs webhost`: (~ `docker logs webhost`)
- `docker container top webhost`: display running processes of a container
- `docker container rm CONTAINER_ID CONTAINER_ID CONTAINER_ID`: (~ `docker system prune`) to remove containers
- `docker container rm -f CONTAINER_ID`: to force remove a running container

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

<img src="screenshots/create-custom-image-11.png" width=400>

# Create A Docker Image for a Simple Node App

```Dockerfile
# Specify a base image
FROM node:alpine

# Define which folder in the base image that we will install dependencies
WORKDIR /usr/app

# install some dependencies
COPY ./package.json ./
RUN npm install

# Copy the rest of the code to the current working directory
COPY ./ ./

# defaul command
CMD ["npm", "start"]
```

- We have to use `node:alpine` as the base image because the `alpine` base image we use before doesn't include `npm`, so we have to get an image with node preinstalled (we could also add more code to install node to the base alpine). `:alpine` simply means we only get the bare minium file needed for this node image, not the full node image

- `WORKDIR /usr/app`: We want to have a working directory as a sub-directory of the base image, in case our files have the same name with what the base image file system already has

- `COPY ./package.json ./`: copy the file package.json from the current `build .` folder, to the working directory of the docker image, in this case it is what we define in `WORKDIR /usr/app`

- `RUN npm install`: install all dependencies in the file package.json

- We split into 2 copy commands so that when there's no changes to the package.json file, there's no need to run `npm install` again. For a big project, that would take too long

- `docker build -t ngantxnguyen/simpleweb .`: in terminal of the build directory (it'd be `2-simple-web` in this case)

- `docker run -p 5000:8080 ngantxnguyen/simpleweb`: to map requests from localhost port 5000 to this container on port 8080 (without mapping, we won't be able to access the node app within the container)

- `docker run -it ngantxnguyen/simpleweb sh`: to access the container file system in terminal

# Use Docker Compose to automatically do networking between multiple containers

**Project: 3-visits**

In the root directory (3-visits), create a `docker-compose.yml` file. To use `docker-compose` command in terminal, we need to make sure we in the same directory as the `docker-compose.yml` file because `docker-compose` cmd always refers to that file to run its sub-commands.

`docker-compose.yml` is where we set up to build/run and connect different containers together. When we declare those containers in this `.yml` file, docker-compose automatically do the networking part to for these containers to communicate with each other.

<img src="screenshots/docker-compose-1.png" width=700>

<img src="screenshots/docker-compose-2.png" width=350>

```yml
version: '3'
services:
  redis-server:
    image: 'redis'
  node-app:
    restart: on-failure
    build: .
    ports:
      - '4001:8081'
```

```js
// in NodeJS app index.js
const client = redis.createClient({
  host: 'redis-server',
  port: 6379,
});
```

<img src="screenshots/docker-compose-5.png" width=400>

<img src="screenshots/docker-compose-6.png" width=400>

- For the NodeJS app to connect to redis db server, we use the name we declare in the `services` of the yml file as the host of this redis server. When docker sees that, it knows we want to connect to the container called `redis-server`
- `restart: on-failure`: restart policy for each container based on the process.exit status code
- `build: .`: look into the current directory, find the Dockerfile and build this container based on that
- `image: 'redis'`: Build this redis-server container based on an image on Docker Hub
- `ports: - '4001:8081'`: Mapping port on localhost to port 8081 of this node-app container

To run/build all of those containers using `docker-compose`

<img src="screenshots/docker-compose-3.png" width=550>

<img src="screenshots/docker-compose-4.png" width=300>

# Production-Grade Workflow

<img src="screenshots/workflow-1.png" width=200>
<img src="screenshots/workflow-2.png" width=700>
<img src="screenshots/workflow-3.png" width=400>

## Workflow example with a React App

<img src="screenshots/workflow-4.png" width=550>
<img src="screenshots/workflow-5.png" width=400>

- ### Development

  <img src="screenshots/workflow-dev-0.png" width=550>

  - Have a docker file made specifically for development called `Dockerfile.dev`

    ```Dockerfile
    FROM node:alpine

    WORKDIR '/app'

    COPY package.json .
    RUN npm install

    COPY . .

    CMD [ "npm", "run", "start" ]
    ```

  - To build and run this dev container in terminal (root directory 4-frontend)

    ```
    docker build -f Dockerfile.dev .

    docker run -it -p 3000:3000 -v /app/node_modules -v $(pwd):/app CONTAINER_ID
    ```

  - For the docker container to reflect the updates when we make changes to the main content of the react app (`App.js`) without us manually rebuild the container, we use `Docker Volume`.

    <img src="screenshots/workflow-dev-1.png" width=550>
    <img src="screenshots/workflow-dev-2.png" width=850>

  - In order not having to type the 2 above command everytime we want to start up this dev container, we create a docker-compose.yml to combine the 2 steps and run `docker-compose up` command instead

    ```yml
    version: '3'
    services:
      web:
        stdin_open: true
        build:
          context: .
          dockerfile: Dockerfile.dev
        ports:
          - '3000:3000'
        volumes:
          - /app/node_modules
          - .:/app
    ```

- ### Testing

  There are 2 possible ways to do testing container with docker. In both methods, we want to make sure the test container will rerun when we make changes to any tests

  - **Method 1**

    Step 1: Start up the dev server `docker-compose up`

    Step 2: Open another terminal tab, in the same directory, get the above running container ID by `docker ps`. Then run this command with that ID `docker run CONTAINER_ID npm run test`. By overriding the container, we get access to the same setting that updates the output if there're changes in the source code. So when we make changes to the file `App.test.js`, the test container will rerun the test.

    This method allows us to use the stdin to interact with the test suite if it provides any sub-commands.

  - **Method 2**

    Add a test service to the docker-compose.yml, in addition to the web service

    ```yml
    tests:
      build:
        context: .
        dockerfile: Dockerfile.dev
      volumes:
        - /app/node_modules
        - .:/app
      command: ['npm', 'run', 'test']
    ```

    In terminal, `docker-compose up` will run both containers. However, we will not be able to send any input/command to the test suite in terminal

    Reason: Run `docker exec -it CONTAINER_ID npm run test` => `ps` to show the processes of this container. We'll see that there are multiple processes that's running this container. It starts with the main `npm` process, which the stdin is attached to the terminal. The actual test is running in another process executing file start.js. This is the process that we need to attach the stdin from the terminal for it to receive sub-command of the tests. However, there's no way we can switch the stdin to the sub-process.

    <img src="screenshots/workflow-test.png" width=550>

- ### Production

  <img src="screenshots/workflow-prod-1.png" width=550>
  <img src="screenshots/workflow-prod-2.png" width=510>
  <img src="screenshots/workflow-prod-3.png" width=650>

  We create another `Dockerfile` for a production container

  ```Dockerfile
  FROM node:alpine as builder
  WORKDIR '/app'
  COPY package.json .
  RUN npm install
  COPY . .
  RUN npm run build

  FROM nginx
  COPY --from=builder /app/build usr/share/nginx/html
  ```

  Each `FROM` is a phase. `FROM node:alpine as builder`: we name this phase `builder` so we can refer to it at a later phase

  For the nginx server to work, we only need the build folder from the previous phase. When we don't specify a `CMD` for the image, it'll use the default CMD that nginx image has

  In terminal, run `docker build .`, copy the container ID. To start the prod server, run `docker run -p 8080:80 CONTAINER_ID`. Port `80` is default for `nginx`

# Continuous Integration and Deployment with Travis CI and AWS Elastic Beanstalk

<img src="screenshots/deployment-travis-ci-aws-elasticbeanstalk-1.png" width=550>
<img src="screenshots/deployment-travis-ci-aws-elasticbeanstalk-2.png" width=350>
<img src="screenshots/deployment-travis-ci-aws-elasticbeanstalk-3.png" width=550>
<img src="screenshots/deployment-travis-ci-aws-elasticbeanstalk-4.png" width=550>

- Create an account with `travis-ci.org` by signing in with Github. It'll link all github repo to Travis.
- Travis => setting (under Account) => search for the docker-react github project => Turn on the switch for Travis to watch for changes in that repo
- In our local repository docker-react (4-frontend), create a `.travis.yml` config file for Travis that follows the above flow

  ```yml
  sudo: required
  language: generic
  services:
    - docker

  before_install:
    - docker build -t ngantxnguyen/docker-react -f Dockerfile.dev .

  script:
    - docker run -e CI=true ngantxnguyen/docker-react npm run test

  deploy:
    provider: elasticbeanstalk
    region: 'us-east-2'
    app: 'docker-react'
    env: 'DockerReact-env'
    bucket_name: 'elasticbeanstalk-us-east-2-581442385236'
    bucket_path: 'docker-react'
    on:
      branch: master
    access_key_id: $AWS_ACCESS_KEY
    secret_access_key: $AWS_SECRET_KEY
  ```

- We get the AWS access key and secret key by create a new IAM user (with full access to Elastic Beanstalk policy). After the user creation, AWS will display these 2 keys

- We have to create a new Application in AWS Elastic Beanstalk, give it a name (that'll be the app name), choose docker. This process will automatically create a S3 bucket (where it'll store all the built version of the github repo).

- In prod `Dockerfile`, we need to add `EXPOSE 80` so that once it is deployed to Elastic Beanstalk, we can access port 80 of the container. Make changes to the `.` as in `COPY package*.json ./` because AWS has problem processing the dot. Lastly, we need to remove named stages, refer to the stages/phases as number `COPY --from=0`.
