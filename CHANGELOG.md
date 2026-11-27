# Changelog

## v0.5.6
- Loads `config.lua` as a shared script so both client.lua and server.lua receive `FMConfig`.
- Fixes the client-side missing configuration issue that could stop `/fmclip` before it sent the NUI start request.
- Does not require a separate ScreenCapture resource.

## v0.5.5
- Adds a retrying NUI readiness handshake.
- Adds request IDs and startup timeouts.
- Adds recorder phase diagnostics and explicit startup errors.
- Keeps the HUD/toast in the middle-bottom area.

## Earlier versions
Earlier releases added server claim/heartbeat, player linking, and the custom NUI recorder/upload prototype.
