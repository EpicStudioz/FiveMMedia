# Troubleshooting

## Resource does not start
- Confirm the folder is named `fivem_media`.
- Confirm `fxmanifest.lua` is directly inside that folder.
- Confirm `ensure fivem_media` is in `server.cfg`.
- Read the FXServer console for resource startup errors.

## NUI reports NOT READY
- Confirm `html/index.html` exists in the installed resource.
- Restart the resource after replacing its files.
- Check the FiveM F8 console for NUI callback errors.

## Recorder remains on STARTING
Run `/fmstatus` and capture every line. Check the first relevant JavaScript error in the FiveM F8 console.

Version 0.5.6 fixes a specific Lua configuration issue by loading `config.lua` as a shared script. This ensures `FMConfig` is available to client.lua and server.lua. It does not prove the custom game-view capture path works on every FiveM client.

The custom recorder depends on the NUI/WebGL game-view texture path. If the page says READY but no frames can be captured, the issue is not the chat command trigger; it is the game-view capture integration/runtime. Do not treat a STARTING message as a successful recording.

## Upload fails
- Check that `fivem_media_api` points to the correct Worker.
- Confirm the server has completed its claim/verification.
- Check the in-game error and Cloudflare Worker logs.
- If the clip remains in memory, keep FiveM open and try `/fmretry`.

## Include this in a bug report
- Resource version.
- Full `/fmstatus` output.
- Exact command and error notification.
- Relevant FXServer console and FiveM F8 console messages.

Never include claim codes, server API keys, upload tokens, passwords, or session cookies in a public issue.
