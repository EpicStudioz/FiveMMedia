# Configuration

The resource reads these server convars from `server.cfg`.

| Convar | Required | Purpose |
| --- | --- | --- |
| `fivem_media_api` | Yes | Base URL of the FiveM Media Worker |
| `fivem_media_claim` | For first claim | One-time server claim code from the dashboard |
| `fivem_media_join_code` | Optional | Cfx server join code displayed with server metadata |

Example:

```cfg
set fivem_media_api "https://media.dnnsitelaunch.com"
set fivem_media_claim "YOUR_SERVER_CLAIM_CODE"
set fivem_media_join_code "YOUR_CFX_JOIN_CODE"
ensure fivem_media
```

The resource stores the server API key in resource KVP after a successful claim. Do not publish that key or your claim code.

## Defaults

The packaged `config.lua` sets:
- 1280×720 capture canvas
- 30 FPS target
- 4 Mbps video bitrate
- 60-second maximum clip duration
- 75 MB maximum upload size
- Five-minute server heartbeat interval

These are defaults, not a guarantee that the target FiveM client can capture the game view at those settings.
