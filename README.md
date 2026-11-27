# FiveM Media — Server Resource

The public download and documentation repository for the **FiveM Media** standalone FiveM resource.

- **Current package:** `fivem_media` v0.5.6
- **Resource folder:** `fivem_media/`
- **Download ZIP:** [Download v0.5.6](releases/v0.5.6/fivem_media-v0.5.6.zip)
- **Website:** https://media.dnnsitelaunch.com/

This repository contains only the downloadable FiveM resource and its setup documentation. It does **not** contain the FiveM Media website source, Cloudflare Worker source, database, credentials, or private server keys.

## Important status notice

The v0.5.6 custom recorder is **experimental**. It uses a custom NUI/WebGL canvas capture path and the browser `MediaRecorder` API; it does not use Rockstar Editor, GTA's recording system, or the separate ScreenCapture resource. Capture startup has not been verified across all FiveM/CEF/GPU configurations. In particular, a recorder that stays on `STARTING` is not a successful recording. See [Troubleshooting](docs/TROUBLESHOOTING.md) before deploying it on a live server.

## What this resource provides

- Standalone `fivem_media` resource.
- FiveM Media server claim and player-count heartbeat integration.
- Global FiveM account-link command.
- Custom NUI recorder prototype, using in-memory video chunks and direct upload flow.
- Upload-to-dashboard workflow for private clip review and publishing.

## Quick start

1. Create or sign in to an account at [FiveM Media](https://fivemmedia.dnnstudios.workers.dev/).
2. Open the Creator Dashboard and create a server claim code.
3. Install the `fivem_media` folder in your server's `resources` directory.
4. Add the server convars and `ensure` line shown in [Installation](docs/INSTALLATION.md).
5. Restart the resource and run `/fmstatus` in game.
6. Try `/fmclip` only after `/fmstatus` reports `NUI: READY`.

Full instructions:

- [Installation](docs/INSTALLATION.md)
- [Configuration](docs/CONFIGURATION.md)
- [Commands](docs/COMMANDS.md)
- [Account linking and server verification](docs/ACCOUNT-LINKING.md)
- [Troubleshooting](docs/TROUBLESHOOTING.md)

## Requirements

- A running FiveM FXServer.
- A FiveM client with NUI enabled.
- A FiveM Media account and a server claim code for server verification and upload-ticket access.
- The server must be able to make HTTPS requests to the configured FiveM Media Worker URL.

No ScreenCapture resource is required for v0.5.6.

## Downloads

Use the ZIP in [releases/v0.5.6/](releases/v0.5.6/). When a newer release is published, download the ZIP attached to the newest GitHub Release.

## Reporting a problem

When reporting a recorder issue, include:

- Resource version (`/fmstatus` includes the NUI and recorder state).
- The exact command used (`/fmclip`, `/save`, etc.).
- The full `/fmstatus` output.
- Any FiveM F8 console error from `[FiveM Media]`.
- Your FiveM game build and whether NUI/CEF hardware acceleration is enabled.

Do not post passwords, session tokens, private server keys, claim codes, or upload tokens in an issue.

## License

No open-source license is granted by this repository unless a license file is added by the project owner. Public visibility allows people to view and download the files; it does not automatically grant permission to redistribute or modify them.
