# kat3samsin/claude-code-plugins

Claude Code plugins for productivity and accessibility.

## claudio

Talk to Claude Code. Voice in, voice out.

Claude runs in the background and tells you what it's doing while you work on other things.

**What's included:**

- **setup-claudio skill** - Configure TTS output and permission announcements

**Features:**

- Audio summaries after every response
- Permission announcements ("I need permission to edit: index.tsx")
- Notification sounds for questions and task completion
- Three output styles: Full, Concise, Conversational
- Customizable voice and speech rate

**Use cases:**

- Hands-free coding with voice input (Superwhisper, macOS Voice Control)
- Background task monitoring without watching the terminal
- Accessibility for screen reader users
- Multitasking while Claude works

**Requirements:**

- macOS (uses built-in `say` command)
- `jq` for configuration (`brew install jq`)
- Optional: Premium system voices

## Install the Marketplace

Add this marketplace to Claude Code:

```bash
/plugin marketplace add kat3samsin/claude-code-plugins
```

This makes all plugins available for installation.

Install Claudio:

```bash
# Install Claudio
/plugin install claudio@kat3samsin-claude-code-plugins

Run the setup skill to configure:
# Run setup
/claudio:setup-claudio
```

## License

MIT License - see [LICENSE](LICENSE) file for details.
