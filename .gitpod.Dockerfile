FROM gitpod/workspace-full-vnc
SHELL ["/bin/bash", "-c"]
ENV ANDROID_HOME=$HOME/Android/Sdk 
ENV PATH="$HOME/Android/Sdk/emulator:$HOME/Android/Sdk/tools:$HOME/Android/Sdk/cmdline-tools/latest/bin:$HOME/Android/Sdk/platform-tools:$PATH"

# Install Open JDK for android and other dependencies
USER root

RUN curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.gpg | sudo apt-key add - \
     && curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.list | sudo tee /etc/apt/sources.list.d/tailscale.list \
     && sudo apt-get update -q \
     && sudo apt-get install -yq tailscale jq \
     && sudo update-alternatives --set ip6tables /usr/sbin/ip6tables-nft
RUN update-alternatives --set ip6tables /usr/sbin/ip6tables-nft

RUN apt-get update && \
    apt-get install -y \
        openjdk-11-jdk \
        libgtk-3-dev \
        libnss3-dev \
        fonts-noto \
        fonts-noto-cjk

# Make some changes for our vnc client 
RUN sed -i 's|resize=scale|resize=remote|g' /opt/novnc/index.html 

# Install Android studio and dependencies

USER gitpod

RUN sudo add-apt-repository ppa:maarten-fonville/android-studio && sudo apt-get update && sudo apt-get install -y android-sdk android-sdk-build-tools android-studio
