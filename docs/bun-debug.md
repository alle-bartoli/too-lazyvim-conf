# Bun debugging in LazyVim (nvim-dap)

DAP-based debugging for [Bun](https://bun.sh) runtime via a custom stdio shim
wrapping the upstream `bun-debug-adapter-protocol` package (the same code that
powers the official `bun-vscode` extension).

Configured in `lua/plugins/dap.lua` (`dap.adapters.bun` + `bun_configs`).

## Why a custom setup

`bun-debug-adapter-protocol` is not published to npm and ships only inside the
`bun-vscode` VSCode extension. To use it from nvim-dap we:

1. Sparse-clone the two needed packages from `oven-sh/bun`.
2. Wrap the inline `WebSocketDebugAdapter` in a tiny Node-style **DAP stdio
   shim** that nvim-dap can spawn as `command + args`.
3. Patch three race/bug issues that prevented breakpoints from being hit (see
   below).

## Install

```sh
# 1. Sparse-clone bun adapter packages
TARGET=~/.local/share/bun-dap
mkdir -p "$TARGET" && cd "$TARGET"
git init -q
git remote add origin https://github.com/oven-sh/bun.git
git sparse-checkout init --cone
git sparse-checkout set packages/bun-debug-adapter-protocol packages/bun-inspector-protocol
git fetch --depth=1 origin main -q
git checkout FETCH_HEAD -q

# 2. Install deps
(cd packages/bun-debug-adapter-protocol && bun install)
(cd packages/bun-inspector-protocol && bun install)

# 3. Apply the local patches (see ~/.local/share/bun-dap/bp-fix.patch)
git apply --check bp-fix.patch && git apply bp-fix.patch
```

The shim itself is at `~/.local/share/bun-dap/bun-dap-stdio.mjs`. It speaks DAP
Content-Length frames on stdio and translates them to/from
`WebSocketDebugAdapter` events.

## DAP configs (in `lua/plugins/dap.lua`)

| Name                                 | Use                                                 |
| ------------------------------------ | --------------------------------------------------- |
| `Bun: Debug Current File`            | Launch `${file}` under bun debugger                 |
| `Bun: Debug Tests in Current File`   | Launch `bun test ${file}`                           |
| `Bun: Attach (ws://localhost:6499)`  | Attach to running `bun --inspect=127.0.0.1:6499/`   |

For attach mode, start bun manually first:

```sh
bun --inspect=127.0.0.1:6499/ index.ts
```

## Patches applied (`bp-fix.patch`)

Stored at `~/.local/share/bun-dap/bp-fix.patch`. Three discrete fixes inside
`packages/bun-debug-adapter-protocol/src/debugger/adapter.ts`:

1. **`#setBreakpointsByUrl` placeholder uses real line.** Upstream hardcodes
   `lineNumber: 0` when the source isn't loaded yet, then waits for
   `Debugger.breakpointResolved` to retry at the real line. Bun's event
   ordering means the bp can hit at line 0 before the retry completes. Patch:
   wait up to 500ms for the script to be parsed; if still not loaded, set the
   placeholder at the user's actual `line` / `column` so a hit lands at the
   right place.

2. **Skip the early auto-`configurationDone`.** Upstream auto-fires
   `configurationDone()` during `initialize` for any client that doesn't set
   `supportsConfigurationDoneRequest=true` (and isn't `vscode`). nvim-dap
   omits the capability flag in its `initialize` args, so the adapter
   prematurely signals "ready" and bun starts executing before breakpoints
   are registered. Patch: whitelist known DAP clients (`neovim`, `nvim-dap`,
   `vscode-js-debug`) and only auto-fire for unknown clients.

3. **`Debugger.paused` on a placeholder bp at the intended line emits
   `stopped` instead of auto-resuming.** Combined with patch 1, the
   placeholder now sits at the user's line, so a hit there IS the intended
   one. Auto-resume would skip the user's bp. Patch: in the `Breakpoint`
   reason branch, if the pause location matches one of the future bp's
   intended lines, fall through to `stopped` emission.

## Updating bun-dap

The local sparse clone tracks `oven-sh/bun#main`. To update:

```sh
cd ~/.local/share/bun-dap
git stash                      # save local patches
git fetch --depth=1 origin main && git checkout FETCH_HEAD
git stash pop                  # reapply patches (may conflict)
```

If `git stash pop` conflicts, the upstream may have fixed the issue. Run
`grep -c "PATCH:" packages/bun-debug-adapter-protocol/src/debugger/adapter.ts`
to see how many of our patches survived.

## Troubleshooting

Re-enable shim logging (temporary, then revert):

```js
// In ~/.local/share/bun-dap/bun-dap-stdio.mjs, add near the top:
import { appendFileSync } from "node:fs";
const LOG = "/tmp/bun-dap-shim.log";
const tlog = (tag, obj) => {
  try { appendFileSync(LOG, `[${new Date().toISOString()}] ${tag} ${JSON.stringify(obj)}\n`); } catch {}
};
// Wrap the adapter.on(...) handlers and stdin parser with tlog(...) calls.
```

Then tail `/tmp/bun-dap-shim.log` while reproducing.

Native nvim-dap log: `~/.cache/nvim/dap.log` (TRACE level is enabled in
`dap.lua`).

## Upstream tracking

- `oven-sh/bun#22914` — request for spec-compliant DAP package outside VSCode.
- `oven-sh/bun#27054` — stable IDE debugging across files.

When fixed upstream, the patches and the shim become unnecessary and the
adapter could be invoked directly.
