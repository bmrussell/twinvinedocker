#!/usr/bin/env bash

echo "Python: $(python3 --version)"
echo "FFmpeg: $(ffmpeg -version | head -n1)"
echo "N_m3u8DL-RE: $(N_m3u8DL-RE --version)"
echo "mp4decrypt: $(which mp4decrypt)"
echo "MKVMerge: $(mkvmerge --version | head -n1)"
echo "Shaka Packager: $(shaka-packager --version 2>&1 | head -n1)"
echo "uv: $(uv --version)"


# 