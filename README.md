# Homebrew Tap


> ## Archived · 2026-08-26
>
> **This project is no longer developed.** Work has moved to **SelfTalk** — a rebuild of
> the same idea (press a key, speak, get your words at the cursor) with a deliberately
> smaller scope and the lessons this line of work paid for written down as constraints
> rather than rediscovered.
>
> **What carried forward: the measurements and the failures, not the code.** SelfTalk
> starts from an empty repository. Nothing here is maintained; issues and pull requests
> will not be answered.
>
> **Why this one stopped.** Three failures from this project are now permanent rules
> elsewhere. A dangling symlink after a directory move killed the hotkey **silently for
> five weeks** — `require` failed at startup and nothing a user would look at said so.
> A zero-byte vocabulary file changed decoding by its *presence*, not its contents, and
> removing it was worth 6.7 points of word error rate. And the benchmark compared two
> word lists by index, so a single inserted word zeroed everything after it — a transcript
> whose only defect was `Vox Core` for `VoxCore` scored 0%.
>
> The rules those became: fail loudly or not at all; presence is not content; never score
> by index.

---

Homebrew formulae for the VoxCore ecosystem -- local voice-to-text on macOS.

## Installation

```bash
brew tap cliffmin/tap
```

## Formulae

### VoxCore

Offline push-to-talk transcription for macOS. One hotkey, any app, sub-second, 100% on-device.

```bash
brew install --cask hammerspoon
brew install voxcore
voxcore-install
```

After install, reload Hammerspoon (Cmd+Opt+Ctrl+R) and grant Microphone + Accessibility permissions.

**Repository:** https://github.com/cliffmin/voxcore

### VoxCompose (optional)

Self-learning transcript refinement plugin for VoxCore. Fixes concatenations, capitalizes technical terms, and optionally applies local LLM polish.

```bash
brew install voxcompose ollama
ollama serve &
ollama pull llama3.1
```

Then enable in `~/.hammerspoon/ptt_config.lua`:
```lua
LLM_REFINER = { ENABLED = true, CMD = { "voxcompose", "--duration" } }
```

**Repository:** https://github.com/cliffmin/voxcompose

## Upgrading

```bash
brew update
brew upgrade voxcore voxcompose
voxcore-install  # Re-links Hammerspoon integration
# Reload Hammerspoon: Cmd+Opt+Ctrl+R
```

## Ecosystem

| Component | Purpose | Repository | Documentation |
|-----------|---------|------------|---------------|
| **VoxCore** | Core transcription engine | [cliffmin/voxcore](https://github.com/cliffmin/voxcore) | [Setup](https://github.com/cliffmin/voxcore/tree/main/docs/setup) · [Architecture](https://github.com/cliffmin/voxcore/blob/main/docs/development/architecture.md) · [Performance](https://github.com/cliffmin/voxcore/blob/main/docs/performance.md) |
| **VoxCompose** | ML transcript refinement (optional) | [cliffmin/voxcompose](https://github.com/cliffmin/voxcompose) | [Integration](https://github.com/cliffmin/voxcompose/blob/main/docs/voxcore-integration.md) · [Architecture](https://github.com/cliffmin/voxcompose/blob/main/docs/architecture.md) |
| **homebrew-tap** | Distribution via Homebrew | This repo | — |

## Troubleshooting

```bash
brew update                        # Refresh tap
brew info voxcore                  # Check installed version
brew reinstall voxcore             # Clean reinstall
brew audit --strict voxcore        # Check formula integrity
```

## License

All formulae are subject to their respective project licenses.