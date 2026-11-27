# Commands

| Command | Description |
| --- | --- |
| `/fmstatus` | Displays NUI readiness, recorder state, and diagnostics. |
| `/fmclip` | Requests a custom recording start. |
| `/record` | Alias for `/fmclip`. |
| `/save` | Stops and uploads the custom recording. |
| `/fmsave` | Alias for `/save`. |
| `/fmretry` | Retries a failed upload while the clip remains in memory. |
| `/fmcancel` | Cancels/discards the active recording or pending in-memory clip. |
| `/fmlink CODE` | Redeems a one-time website account-link code. |

## Typical flow
1. Run `/fmclip`.
2. Confirm that the HUD says recording has started.
3. Run `/save` when finished.
4. Open Creator Dashboard → My Clips to manage the uploaded draft.

If upload fails, keep FiveM open and use `/fmretry`. An unsent clip exists only in memory and can be lost if the client closes.
