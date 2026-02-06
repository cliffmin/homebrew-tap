# Homebrew Tap

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

| Component | Purpose | Repository |
|-----------|---------|------------|
| **VoxCore** | Core transcription engine | [cliffmin/voxcore](https://github.com/cliffmin/voxcore) |
| **VoxCompose** | ML transcript refinement (optional) | [cliffmin/voxcompose](https://github.com/cliffmin/voxcompose) |
| **homebrew-tap** | Distribution via Homebrew | This repo |

## Troubleshooting

```bash
brew update                        # Refresh tap
brew info voxcore                  # Check installed version
brew reinstall voxcore             # Clean reinstall
brew audit --strict voxcore        # Check formula integrity
```

## License

All formulae are subject to their respective project licenses.