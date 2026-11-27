# Installation

## Requirements
- A running FiveM FXServer.
- Access to the server's `resources` directory and `server.cfg`.
- A FiveM Media account and a server claim code from the website.

## Download
- [Latest resource ZIP](https://media.dnnsitelaunch.com/downloads/fivem_media-latest.zip)
- [Version 0.5.6 ZIP](https://media.dnnsitelaunch.com/downloads/fivem_media-v0.5.6.zip)

## Install
1. Download and extract the ZIP.
2. Copy the extracted `fivem_media` folder into your server's `resources` directory.
3. Check that `fxmanifest.lua` is directly inside `resources/fivem_media/`. Avoid an extra nested `fivem_media/fivem_media` folder.
4. Add the following to `server.cfg`, replacing the placeholders with your dashboard values:

```cfg
set fivem_media_api "https://media.dnnsitelaunch.com"
set fivem_media_claim "YOUR_SERVER_CLAIM_CODE"
set fivem_media_join_code "YOUR_CFX_JOIN_CODE"
ensure fivem_media
```

5. Restart the resource or FXServer.
6. Join the server and run `/fmstatus`.

## No extra recorder resource
Version 0.5.6 does not require `screencapture`. Do not add `ensure screencapture`.

## Update
Stop the resource, replace the complete `fivem_media` folder with the new version, then restart it. Keep your existing claim/config values unless the dashboard tells you to rotate them.
