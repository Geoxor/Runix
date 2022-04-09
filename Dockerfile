# ⚡ base
FROM node:17

# 🔨 set the github runner version
ARG RUNNER_VERSION="2.289.2"

# ⚡ update the base packages 
RUN apt update -y && apt upgrade -y

# 🔨 add the runix user
RUN useradd -m runix

# ⚡ install sudo for runix 
RUN DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends sudo

# 🔨 move over the sudoers.txt file allowing sudo to be executed at runtime
ADD /sudoers.txt /etc/sudoers
USER runix

# ⚡ install python and the packages the your code depends on along with jq so we can parse json
# ⚡ add additional packages as necessary
RUN DEBIAN_FRONTEND=noninteractive sudo apt install -y --no-install-recommends build-essential curl wget sudo curl jq python3 python3-venv python3-dev python3-pip

# ⚡ install github runner pacakge, cd into the user directory and
# ⚡ download and unzip the github actions runner
RUN cd /home/runix && mkdir actions-runner && cd actions-runner && curl -O -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz && tar xzf ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz

# install linters needed for different architectures for auritia
RUN sudo apt install gcc-multilib -y
RUN sudo apt install gcc-mips-linux-gnu -y
RUN sudo apt install gcc-mipsel-linux-gnu -y
RUN sudo apt install gcc-aarch64-linux-gnu -y


RUN sudo apt install pkg-config libssl-dev

# ⚡ install some additional dependencies that github runners need
RUN sudo /home/runix/actions-runner/bin/installdependencies.sh

# Install Node stuff
RUN sudo npm i typescript -g
RUN sudo npm i ts-node -g

# Install Rust stuff
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y
ENV PATH="/home/runix/.cargo/bin:${PATH}"
RUN cargo --version

# Install Go stuff
RUN sudo wget https://go.dev/dl/go1.17.4.linux-amd64.tar.gz && sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go1.17.4.linux-amd64.tar.gz && sudo rm -f go1.17.4.linux-amd64.tar.gz
ENV PATH="/usr/local/go/bin:${PATH}"
RUN go version
RUN go get github.com/mitchellh/gox
ENV PATH="/home/runix/go/bin:${PATH}"
RUN gox -h

RUN sudo wget https://github.com/upx/upx/releases/download/v3.96/upx-3.96-amd64_linux.tar.xz && sudo tar -xvf upx-3.96-amd64_linux.tar.xz && cd upx-3.96-amd64_linux && sudo mv * /usr/local/bin && sudo rm -f upx-3.96-amd64_linux.tar.xz
RUN upx --help

# 🔨 since the config and run script for actions are not allowed to be run by root,
# 🔨 set the user to "runix" so all subsequent commands are run as the runix user
USER runix

COPY start.sh start.sh
RUN sudo chmod +x start.sh
ENTRYPOINT ["./start.sh"]
