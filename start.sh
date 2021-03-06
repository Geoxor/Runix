#!/bin/bash

sudo dockerd
sudo service docker start

ACCESS_TOKEN=$ACCESS_TOKEN
ORGANIZATION=$ORGANIZATION

echo $ACCESS_TOKEN
echo $ORGANIZATION

REG_TOKEN=$(curl -sX POST -H "Authorization: token ${ACCESS_TOKEN}" https://api.github.com/orgs/${ORGANIZATION}/actions/runners/registration-token | jq .token --raw-output)
# For solo repos we can do the same thing to /repos/{owner}/{repo}/actions/runners/registration-token

echo $(ls -a)

cd /home/runix/actions-runner

./config.sh --url https://github.com/${ORGANIZATION} --token ${REG_TOKEN}

cleanup() {
    echo "Removing runner..."
    ./config.sh remove --unattended --token ${REG_TOKEN}
}

trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM

./run.sh & wait $!