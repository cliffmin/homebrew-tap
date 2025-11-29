# Clifford Min's Homebrew Tap

## Installation

```bash
brew tap cliffmin/tap
```

## Available Formulae

### VoxCore

Offline push-to-talk dictation for macOS with on-device transcription.

```bash
brew install voxcore
```

**Features:**
- 🏠 100% offline transcription with Whisper
- ⚡ Sub-second response for short recordings
- ⌨️ System-wide hotkey integration
- 🧹 Automatic disfluency removal
- 🔧 Optional daemon with audio padding and WebSocket API

**Post-install:**
```bash
voxcore-install                  # Setup Hammerspoon integration
brew services start voxcore      # Start background daemon (optional)
```

**Repository:** https://github.com/cliffmin/voxcore

### VoxCompose

Smart transcript refinement with self-learning corrections and local LLM processing.

```bash
brew install voxcompose
```

**Features:**
- 🧠 Self-learning corrections (92% faster, 75% fewer errors)
- ⚡ Smart processing with duration-based thresholds
- 🔒 100% local processing with Ollama
- 🍎 Integrates with [VoxCore](https://github.com/cliffmin/voxcore)

**Repository:** https://github.com/cliffmin/voxcompose

## Documentation

For more information about specific formulae, use:

```bash
brew info voxcore
brew info voxcompose
```

## Troubleshooting

If you encounter issues:

1. **Update the tap:**
   ```bash
   brew update
   ```

2. **Reinstall the tap:**
   ```bash
   brew untap cliffmin/tap
   brew tap cliffmin/tap
   ```

3. **Check formula integrity:**
   ```bash
   brew audit --strict voxcompose
   ```

## Upgrading

Update to the latest versions:

```bash
brew update
brew upgrade voxcore voxcompose
```

Check available versions:
```bash
brew info voxcore
brew info voxcompose
```

After upgrading VoxCore, reload Hammerspoon integration:
```bash
voxcore-install
# Then reload Hammerspoon: ⌘+⌥+⌃+R
```

## Contributing

To report issues or contribute, please visit the main project repository:
- VoxCompose: https://github.com/cliffmin/voxcompose/issues

## License

All formulae are subject to their respective project licenses.