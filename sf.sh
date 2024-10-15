#!/bin/bash

# Update and upgrade the system
function update() {
    apt update && apt upgrade -y
}
update

# Install Docker and required dependencies
function installdocker(){
    apt-get update
    apt-get install -y ca-certificates curl gnupg lsb-release

    # Add Docker's official GPG key
    install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo tee /etc/apt/keyrings/docker.asc > /dev/null
    chmod a+r /etc/apt/keyrings/docker.asc

    # Set up Docker repository
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
      $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    tee /etc/apt/sources.list.d/docker.list > /dev/null

    # Update and install Docker
    apt-get update
    apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
}
installdocker

# Start and enable Docker
function startdocker(){
    systemctl start docker
    systemctl enable docker
}
startdocker

# Pull and run the Firefox container
function getfirefoxcontainer(){
    docker run -d \
    --name=firefox \
    --security-opt seccomp=unconfined \
    -e PUID=1000 \
    -e PGID=1000 \
    -e TZ=Etc/UTC \
    -p 3000:3000 \
    -p 3001:3001 \
    -v /home/ubuntu:/config \
    --shm-size="1gb" \
    --restart unless-stopped \
    lscr.io/linuxserver/firefox:latest
}
getfirefoxcontainer
