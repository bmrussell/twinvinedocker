# CONTAINTERISED TwinVine

Docker wrapper for [TwinVine](https://github.com/vinefeeder/TwinVine)

##  BUILD
```bash
./init.sh
cp ./TwinVine/WVDs/device.wvd device.wvd # or use your own
./build.sh
```

## RUN
Pass envied commands to the run script. See Twinvine for details or command line help:

```bash
./run.sh "dl -?"
```

```bash
docker run \
    -v $HOME/.log:/app/Logs:z \
    -v $HOME/.temp:/app/Temp:z \
    -v $HOME/Downloads:/app/Downloads:z \
    -v $HOME/.config/twinvine/wvd:/app/WVDs:z \
    -v $HOME/.config/twinvine/cookies:/app/packages/envied/src/Cookies:Z \
    -it twinvine bash -c "uv run envied dl --no-folder itv $@"
```
