FROM golang:1.18.1

RUN apt-get update && \
    apt-get install -y \
    git \
    curl \
    unzip \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Install Go tools for VSCode development
RUN go install github.com/cweill/gotests/gotests@latest
RUN go install github.com/fatih/gomodifytags@latest
RUN go install github.com/josharian/impl@latest
RUN go install github.com/haya14busa/goplay/cmd/goplay@latest
RUN go install github.com/go-delve/delve/cmd/dlv@latest
RUN go install golang.org/x/tools/gopls@latest
RUN go install github.com/ramya-rao-a/go-outline@latest
RUN go install golang.org/x/tools/cmd/gorename@latest

# Fix locale
RUN apt-get update && apt-get install -y locales
RUN echo "LC_ALL=en_US.UTF-8" >> /etc/environment
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
RUN echo "LANG=en_US.UTF-8" > /etc/locale.conf
RUN locale-gen en_US.UTF-8

RUN echo 'dev ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
RUN useradd -m dev && echo "dev:dev" | chpasswd && adduser dev sudo

# Switch to the dev user
USER dev

RUN git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && \
    ~/.fzf/install

# Set the working directory
WORKDIR /go/src

COPY .devcontainer/.bashrc /home/dev/