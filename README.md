# 🎃 Introduction

This is my docker image for my self-hosted GitHub Action runners

It tries to emitate a very lite version of what the GitHub official runners have

# 🛠 Installed Tools

- build-essential
- curl
- wget
- sudo
- curl
- jq
- python3
- pip
- node.js
- rust
- cargo
- npm
- typescript
- ts-node

# 🗃 Setup

Edit your `docker-compose.yml` and add your organization & access token
_make sure your access token has the correct permissions_

# ☄ Usage

### 📦 NPM

I added a `package.json` file purely for the scripts
so you can use `npm run` to start up the dockers

- `npm run build` - to build the image
- `npm run start` - to start 8 runners
- `npm run stop` - to stop all runners

### 🐳 Docker Compose

- build image: `docker-compose build`
- start 8 instances: `docker-compose up --scale runner=8 -d`
- go from 8 -> 12 instances: `docker-compose up --scale runner=12 -d`
- stop all: `docker-compose down`
