# Download FiveM Media v0.5.6

The official FiveM Media resource ZIP is hosted on the FiveM Media download server:

- [Download latest resource ZIP](https://fivemmedia.dnnstudios.workers.dev/downloads/fivem_media-latest.zip)
- [Download v0.5.6 ZIP](https://fivemmedia.dnnstudios.workers.dev/downloads/fivem_media-v0.5.6.zip)

## Verify the download

Expected SHA-256:

`75b822b39e2f2f759deeaa9a2e3e89af5b9d45e1bf980612d6acc5f347890b6c`

On Windows PowerShell, after downloading:

```powershell
Get-FileHash .\fivem_media-v0.5.6.zip -Algorithm SHA256
```

The output hash should match the value above.

## Install

Follow [the installation guide](../../docs/INSTALLATION.md). The archive extracts to a folder named `fivem_media`.

This release does not require the separate ScreenCapture resource. The custom recorder remains experimental; see [troubleshooting](../../docs/TROUBLESHOOTING.md) for known capture limitations.
