# Use an official Python runtime as a parent image
FROM python:3.9-slim-buster

RUN apt-get update && \
    apt-get install -y \
    git \
    curl \
    unzip \
    sudo \
    && rm -rf /var/lib/apt/lists/*

RUN echo 'dev ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
RUN useradd -m dev && echo "dev:dev" | chpasswd && adduser dev sudo

# Switch to the dev user
USER dev

RUN git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && \
    ~/.fzf/install

# Set the working directory in the container to /app
WORKDIR /app

# Make port 80 available to the world outside this container
EXPOSE 80

COPY .devcontainer/.bashrc /home/dev/