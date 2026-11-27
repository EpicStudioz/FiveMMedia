FiveM Media Resource v0.5.6

IMPORTANT
This is an experimental custom NUI recorder. NUI readiness does not prove game-frame capture or encoding works on every FiveM/CEF/GPU combination. Test an actual clip and upload before using it on a production server.

INSTALL
1. Stop the old fivem_media resource.
2. Replace the entire resources/fivem_media folder with this folder.
3. Add to server.cfg:
   set fivem_media_api "https://fivemmedia.dnnstudios.workers.dev"
   set fivem_media_claim "YOUR-ONE-TIME-CLAIM-CODE"
   set fivem_media_join_code "YOUR-CFX-JOIN-CODE"
   ensure fivem_media
4. Do not add or install ScreenCapture for this version.
5. Restart the resource/server.
6. Run /fmstatus, then /fmclip.

The manifest loads config.lua as a shared script because both client.lua and server.lua read FMConfig.

For full installation, configuration, account-linking and troubleshooting instructions, see the docs/ directory in the repository.
