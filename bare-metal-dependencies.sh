!/usr/bin/env bash

# Download and install binaries from github
if command -v N_m3u8DL-RE >/dev/null 2>&1; then
    echo "N_m3u8DL-RE installed"
else
        echo N_m3u8DL-RE...
        API_URL="https://api.github.com/repos/nilaoda/N_m3u8DL-RE/releases"
        json=$(curl -sL "$API_URL")
        rpm_url=$(echo $json | jq -r 'first(.[].assets[] | select( (.browser_download_url | contains("linux-x64"))) | .browser_download_url)')
        filename=$(basename "$rpm_url")
        curl -# -L -o "$filename" "$rpm_url"
        tar -xzf N_m3u8DL-RE_v*_linux-x64_20251029.tar.gz
        mv N_m3u8DL-RE ~/.local/bin
        rm N_m3u8DL-RE_v*_linux-x64_20251029.tar.gz
fi

if command -v shaka-packager >/dev/null 2>&1; then
    echo "Shaka Packager installed"
else
        echo Shaka Packager...
        API_URL="https://api.github.com/repos/shaka-project/shaka-packager/releases"
        json=$(curl -sL "$API_URL")
        rpm_url=$(echo $json | jq -r 'first(.[].assets[] | select( (.browser_download_url | contains("linux-x64"))) | .browser_download_url)')
        filename=$(basename "$rpm_url")
        curl -# -L -o "$filename" "$rpm_url"
        mv mpd_generator-linux-x64 ~/.local/bin/shaka-packager
        chmod +x ~/.local/bin/shaka-packager
fi

if command -v mp4decrypt >/dev/null 2>&1; then
    echo "Bento4 installed"
else
    echo Bento4...
    wget https://www.bok.net/Bento4/binaries/Bento4-SDK-1-6-0-641.x86_64-unknown-linux.zip && \
    unzip -j Bento4-SDK-1-6-0-641.x86_64-unknown-linux.zip \
    'Bento4-SDK-1-6-0-641.x86_64-unknown-linux/bin/*' -d ~/.local/bin/ && \
    rm Bento4-SDK-1-6-0-641.x86_64-unknown-linux.zip && \
    chmod +x ~/.local/bin/*
fi

# if command -v mp4decrypt >/dev/null 2>&1; then
#     echo "Bento4 installed"
# else
#     wget https://github.com/shaka-project/shaka-packager/releases/download/v3.2.0/packager-linux-x64 && \
#         mv packager-linux-x64 ~/.local/bin/shaka-packager && \
#         chmod +x ~/.local/bin/shaka-packager
# fi

if command -v mkvmerge >/dev/null 2>&1; then
    echo "mkvtoolnix installed"
else
    sudo zypper install -y mkvtoolnix mkvtoolnix-gui
fi

if zypper se -i libmediainfo0 | grep -q '^i'; then
    echo "libmediainfo0 installed"
else
    sudo zypper install -y libmediainfo0
fi

if command -v uv >/dev/null 2>&1; then
    echo "uv installed"
else
    curl -LsSf https://astral.sh/uv/install.sh | sh
fi


echo
echo "Version information"
echo "Python: $(python3 --version)"
echo "FFmpeg: $(ffmpeg -version | head -n1)"
echo "N_m3u8DL-RE: $(N_m3u8DL-RE --version)"
echo "mp4decrypt: $(which mp4decrypt)"
echo "MKVMerge: $(mkvmerge --version | head -n1)"
echo "Shaka Packager: $(shaka-packager --version 2>&1 | head -n1)"
echo "uv: $(uv --version)"