# 🎃 Introduction

This is my docker image for my self-hosted [GitHub Actions](https://github.com/features/actions) runners
as self-hosted runners tend to be a lot faster since you can dedicate a server or multiple for an organization
as supposed to how github runs multiple dockers on the same machine making compile times take really long

It tries to emitate a very lite version of what the [GitHub Official Runners](https://github.com/actions/runner) have and you can farther take
this and build your own purpose built runner for your repo to improve performance
by editing the `Dockerfile` installing everything your repo needs

# 🛠 Installed Tools

- gcc-i386
- gcc-mips
- gcc-mipsel
- gcc-aarch64
- [upx 3.96](https://github.com/upx/upx)
- build-essential
- curl
- wget
- [go](https://go.dev)
- [gox](https://github.com/mitchellh/gox)
- sudo
- curl
- jq
- python3
- pip
- node.js
- rust
- cargo
- npm
- docker
- typescript
- ts-node
- cross

# 🗃 Setup

Install [Docker](https://www.docker.com/products/docker-desktop)

Edit the `docker-compose.yml` and add your organization & access token
_make sure your access token has the correct permissions_

Do this so dockers within the runners can execute

```bash
chmod 777 /var/run/docker.sock
```

# ☄ Usage

### 🐳 Docker Compose

- `docker-compose build` - build image
- `docker-compose up --scale runner=8 -d` - start 8 instances
- `docker-compose up --scale runner=12 -d` - go from 8 -> 12 instances
- `docker-compose down` - stop all
