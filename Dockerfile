# Use Ubuntu 24.04 as base image
FROM ubuntu:24.04

# Accept build args for UID and GID and debug
ARG USER_ID
ARG GROUP_ID
ARG DEBUG=0

# Create group only if it doesn't exist
RUN if ! getent group ${GROUP_ID} > /dev/null; then \
        groupadd -g ${GROUP_ID} appgroup; \
    fi

# Create or reuse user
RUN if ! id -u ${USER_ID} > /dev/null 2>&1; then \
        useradd -m -u ${USER_ID} -g ${GROUP_ID} appuser; \
    else \
        existing_user=$(getent passwd ${USER_ID} | cut -d: -f1); \
        usermod -g ${GROUP_ID} ${existing_user}; \
    fi

# Avoid prompts from apt
ENV DEBIAN_FRONTEND=noninteractive

# Set working directory
WORKDIR /app

# Install system dependencies, Python, FFmpeg, and Qt/X11 libraries
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \
    python3-full \
    git \
    curl \
    wget \
    unzip \
    tar \
    aria2 \
    ffmpeg \
    libgl1 \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender1 \
    libgomp1 \
    libxkbcommon-x11-0 \
    libdbus-1-3 \
    ca-certificates \
    software-properties-common \
    mediainfo \
    libxcb-cursor0 \
    libxcb-cursor-dev \
    libxcb-icccm4 \
    libxcb-image0 \
    libxcb-keysyms1 \
    libxcb-randr0 \
    libxcb-render-util0 \
    libxcb-render0 \
    libxcb-shape0 \
    libxcb-shm0 \
    libxcb-sync1 \
    libxcb-xfixes0 \
    libxcb-xinerama0 \
    libxcb-xinput0 \
    libxcb-xkb1 \
    libxcb1 \
    libx11-xcb1 \
    libfontconfig1 \
    libfreetype6 \
    libxi6 \
    libxkbcommon0 \
    mkvtoolnix mkvtoolnix-gui \
    jq


# Install Bento4 (mp4decrypt)
RUN wget https://www.bok.net/Bento4/binaries/Bento4-SDK-1-6-0-641.x86_64-unknown-linux.zip && \
    unzip -j Bento4-SDK-1-6-0-641.x86_64-unknown-linux.zip \
    'Bento4-SDK-1-6-0-641.x86_64-unknown-linux/bin/*' -d /usr/local/bin/ && \
    rm Bento4-SDK-1-6-0-641.x86_64-unknown-linux.zip && \
    chmod +x /usr/local/bin/*

# Install N_m3u8DL-RE
# RUN wget https://github.com/nilaoda/N_m3u8DL-RE/releases/download/v0.3.0-beta/N_m3u8DL-RE_v0.3.0-beta_linux-x64_20241203.tar.gz && \
#     tar -xzf N_m3u8DL-RE_v0.3.0-beta_linux-x64_20241203.tar.gz && \
#     find . -name "N_m3u8DL-RE" -type f -exec mv {} /usr/local/bin/ \; && \
#     chmod +x /usr/local/bin/N_m3u8DL-RE && \
#     rm -rf N_m3u8DL-RE_v0.3.0-beta_linux-x64_20241203.tar.gz

RUN     curl -sL "https://api.github.com/repos/nilaoda/N_m3u8DL-RE/releases" | tr -d '\000-\011\013-\037' > json.json && \        
        rpm_url=$(cat json.json | jq -r 'first(.[].assets[] | select( (.browser_download_url | contains("linux-x64"))) | .browser_download_url)') && \
        filename=$(basename "$rpm_url") && \ 
        curl -# -L -o "$filename" "$rpm_url" && \
        tar -xzf N_m3u8DL-RE_v*.tar.gz && \
        mv N_m3u8DL-RE /usr/local/bin && \
        rm N_m3u8DL-RE_v*.tar.gz


# Install Shaka Packager
RUN wget https://github.com/shaka-project/shaka-packager/releases/download/v3.2.0/packager-linux-x64 && \
    mv packager-linux-x64 /usr/local/bin/shaka-packager && \
    chmod +x /usr/local/bin/shaka-packager

# Install uv by copying from official image
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# Clone TwinVine repository
#RUN git clone https://github.com/vinefeeder/TwinVine.git .
COPY TwinVine/ /app/
COPY device.wvd /app/WVDs/
COPY versions.sh /app

# Install Python dependencies using uv
RUN uv clean && uv lock && uv sync

# Install debugpy for remote debugging support if required
RUN if [ "$DEBUG" = "1" ]; then \
        apt-get update && \
        apt-get install -y python3-debugpy build-essential && \
        pip install debugpy; \
    else \
        rm -rf /var/lib/apt/lists/*; \
    fi

# Copy example config and set up environment
RUN cp packages/envied/src/envied/envied-working-example.yaml \
       packages/envied/src/envied/envied.yaml

RUN mkdir -p Downloads
RUN mkdir -p Temp
RUN mkdir -p PRDs
RUN mkdir -p Logs

RUN uv run envied --help

RUN chown -R  ubuntu:ubuntu /app && \
    chmod -R o+r /app && \
    chmod -R o+w /app

# Switch to the non root user
USER ubuntu

# Default command runs vinefeeder
CMD ["uv", "run", "env"]

