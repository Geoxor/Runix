# ⚡ base
FROM node:17

# 🔨 set the github runner version
ARG RUNNER_VERSION="2.285.0"

# ⚡ update the base packages 
RUN apt update -y && apt upgrade -y

# 🔨 add the docker user
RUN useradd -m docker

# ⚡ install sudo for docker 
RUN DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends sudo

# 🔨 move over the sudoers.txt file allowing sudo to be executed at runtime
ADD /sudoers.txt /etc/sudoers
USER docker

# ⚡ install python and the packages the your code depends on along with jq so we can parse json
# ⚡ add additional packages as necessary
RUN DEBIAN_FRONTEND=noninteractive sudo apt install -y --no-install-recommends \
    build-essential curl wget sudo curl jq python3 python3-venv python3-dev python3-pip

# ⚡ install github runner pacakge, cd into the user directory and
# ⚡ download and unzip the github actions runner
RUN cd /home/docker && mkdir actions-runner && cd actions-runner \
    && curl -O -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz \
    && tar xzf ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz

# install linters needed for different architectures for auritia
RUN sudo apt install gcc-multilib -y
RUN sudo apt install gcc-mips-linux-gnu -y
RUN sudo apt install gcc-mipsel-linux-gnu -y
RUN sudo apt install gcc-aarch64-linux-gnu -y

# ⚡ install some additional dependencies that github runners need
RUN sudo /home/docker/actions-runner/bin/installdependencies.sh

RUN sudo npm i typescript -g
RUN sudo npm i ts-node -g

# Install Rust Stuff
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y
ENV PATH="/home/docker/.cargo/bin:${PATH}"
RUN cargo --version

# 🔨 since the config and run script for actions are not allowed to be run by root,
# 🔨 set the user to "docker" so all subsequent commands are run as the docker user
USER docker

COPY start.sh start.sh
RUN sudo chmod +x start.sh
ENTRYPOINT ["./start.sh"]
