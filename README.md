# FiveM Media — Official Resource

Public download page and installation documentation for the **FiveM Media** FiveM server resource.

- **Current resource:** v0.5.6
- **Website:** https://fivemmedia.dnnstudios.workers.dev/
- **Download latest resource:** [fivem_media-latest.zip](https://fivemmedia.dnnstudios.workers.dev/downloads/fivem_media-latest.zip)
- **Download version 0.5.6:** [fivem_media-v0.5.6.zip](https://fivemmedia.dnnstudios.workers.dev/downloads/fivem_media-v0.5.6.zip)

The resource ZIP is hosted by the official FiveM Media website Worker. This repository is the public download hub and documentation; it does not contain the private website/backend source or secrets.

## Install

1. Download the latest resource ZIP using the link above.
2. Extract the ZIP. It contains a folder named `fivem_media`.
3. Put that folder in your FXServer `resources` directory.
4. Add your server settings to `server.cfg`:

```cfg
set fivem_media_api "https://fivemmedia.dnnstudios.workers.dev"
set fivem_media_claim "YOUR_ONE_TIME_SERVER_CLAIM_CODE"
set fivem_media_join_code "YOUR_CFX_JOIN_CODE"
ensure fivem_media
```

5. Generate the one-time claim code from your FiveM Media dashboard. Keep it private.
6. Restart the resource/server and run `/fmstatus` in game.

Full instructions: [Installation guide](docs/INSTALLATION.md).

## Documentation

- [Installation](docs/INSTALLATION.md)
- [Configuration](docs/CONFIGURATION.md)
- [Commands](docs/COMMANDS.md)
- [Account linking](docs/ACCOUNT-LINKING.md)
- [Troubleshooting](docs/TROUBLESHOOTING.md)
- [Changelog](CHANGELOG.md)

## Features

- Server claim and player-count heartbeat.
- Global player account linking with `/fmlink`.
- Custom NUI recorder prototype and in-game controls.
- Upload-ticket flow to FiveM Media for private clip review.

## Recorder status — read before installing

The custom recorder is experimental. It uses a NUI/WebGL game-view capture path and browser `MediaRecorder`; it does not use Rockstar Editor, GTA's recording system, or the separate ScreenCapture resource. The game-view texture path depends on FiveM client/NUI runtime behavior and has not been verified across all client/CEF/GPU combinations. A NUI `READY` response only confirms the page loaded; it does not prove that game frames are capturable. If the recorder stays on `STARTING`, it has not successfully started. See [Troubleshooting](docs/TROUBLESHOOTING.md).

The resource does not intentionally write clips to a local recordings folder. Encoded video is held in NUI memory and uploaded to the configured Worker. If the client closes before upload succeeds, an unsent in-memory clip may be lost. Current capture is video-only.

## Repository scope

This public repository contains the resource download links and user documentation. It does not contain the private Cloudflare Worker source, database exports, user data, server claim codes, or API secrets.

## Support

When reporting an issue, include the resource version, complete `/fmstatus` output, exact in-game error, and relevant FXServer/F8 console messages. Never publish passwords, tokens, server keys, or claim codes.

## License

No open-source license is granted unless a LICENSE file is added. Public repository visibility alone does not grant permission to redistribute or modify the code.
