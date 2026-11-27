# FiveM Media — Official Resource

Public downloads and installation guides for the **FiveM Media** FiveM server resource.

- **Current resource:** v0.5.6
- **Website:** https://media.dnnsitelaunch.com/
- **Latest ZIP:** [Download fivem_media-latest.zip](https://media.dnnsitelaunch.com/downloads/fivem_media-latest.zip)
- **Versioned ZIP:** [Download v0.5.6](https://media.dnnsitelaunch.com/downloads/fivem_media-v0.5.6.zip)

## Install

1. Download and extract the ZIP.
2. Put the extracted `fivem_media` folder in your server's `resources` directory.
3. Add your server's existing FiveM Media settings to `server.cfg`:

```cfg
set fivem_media_api "https://media.dnnsitelaunch.com"
set fivem_media_claim "YOUR_SERVER_CLAIM_CODE"
set fivem_media_join_code "YOUR_CFX_JOIN_CODE"
ensure fivem_media
```

4. Replace the placeholders with the values from your FiveM Media dashboard. Keep your claim code private.
5. Restart the resource/server and run `/fmstatus` in game.

Full instructions: [Installation guide](docs/INSTALLATION.md).

## Documentation

- [Installation](docs/INSTALLATION.md)
- [Configuration](docs/CONFIGURATION.md)
- [Commands](docs/COMMANDS.md)
- [Account linking](docs/ACCOUNT-LINKING.md)
- [Troubleshooting](docs/TROUBLESHOOTING.md)
- [Changelog](CHANGELOG.md)

## Included features

- Server claim and player-count heartbeat.
- Global player account linking with `/fmlink`.
- Custom NUI recorder prototype and in-game controls.
- Upload flow to FiveM Media for private clip review.

## Recorder status — read before installing

The custom recorder is experimental. It uses a NUI/WebGL game-view capture path and browser `MediaRecorder`; it does not use Rockstar Editor, GTA's recording system, or the separate ScreenCapture resource. The game-view texture path depends on FiveM client/NUI runtime behavior and has not been verified across all client/CEF/GPU combinations. A NUI `READY` response only confirms the page loaded; it does not prove that game frames are capturable. If the recorder stays on `STARTING`, it has not successfully started. See [Troubleshooting](docs/TROUBLESHOOTING.md).

The resource does not intentionally write clips to a local recordings folder. Encoded video is held in NUI memory and uploaded to the configured Worker. If the client closes before upload succeeds, an unsent in-memory clip may be lost. Current capture is video-only.

## Repository scope

This public repository is for the FiveM resource download and user documentation. It does not contain the private Cloudflare Worker source, database exports, user data, server claim codes, or API secrets.

## Support

When reporting an issue, include the resource version, complete `/fmstatus` output, exact in-game error, and relevant FXServer/F8 console messages. Never publish passwords, tokens, server keys, or claim codes.

## License

No open-source license is granted unless a LICENSE file is added. Public repository visibility alone does not grant permission to redistribute or modify the code.
