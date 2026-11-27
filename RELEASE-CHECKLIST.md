# Release checklist

Before publishing a new FiveM Media resource version:

- [ ] Test the resource on a clean FXServer installation.
- [ ] Confirm the resource folder is named `fivem_media`.
- [ ] Confirm `fxmanifest.lua` is at the top level of the resource folder.
- [ ] Verify `/fmstatus` reports the correct NUI and recorder phases.
- [ ] Test actual game-frame capture in a live FiveM client.
- [ ] Record a short clip and verify the resulting video is playable.
- [ ] Test `/save`, upload failure and `/fmretry`.
- [ ] Test server claim, heartbeat and player account linking against the production Worker.
- [ ] Update the ZIP at the Worker download routes.
- [ ] Update the version number and `CHANGELOG.md`.
- [ ] Update the download version and setup notes in `README.md`.
- [ ] Verify both download links work before announcing the release.

Do not label the recorder stable based only on syntax checks or a successful NUI ready handshake. A real clip must be captured, uploaded and played back successfully.
