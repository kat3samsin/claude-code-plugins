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

## refocus

Refocus on your terminal when Claude Code tasks complete. Clickable notifications bring you right back.

**What's included:**

- **setup-refocus skill** - Configure clickable notifications for task completion

**Features:**

- Notification on task completion - Know when Claude is done
- Click to refocus - Activate your terminal window instantly
- Smart messages - Different notifications for different completion types
- Customizable sounds - Choose your notification sound

**Use cases:**

- Background task monitoring while working in other apps
- Never miss when Claude finishes a long-running task
- Quick context switching back to your terminal

**Requirements:**

- macOS
- `terminal-notifier` (`brew install terminal-notifier`)
- `jq` for configuration (`brew install jq`)

**Supported Terminals:**

- iTerm2
- Ghostty
- Terminal.app

## Install the Marketplace

Add this marketplace to Claude Code:

```bash
/plugin marketplace add kat3samsin/claude-code-plugins
```

This makes all plugins available for installation.

Install plugins:

```bash
# Install Claudio (voice output)
/plugin install claudio@kat3samsin-claude-code-plugins
/claudio:setup-claudio

# Install Refocus (clickable notifications)
/plugin install refocus@kat3samsin-claude-code-plugins
/refocus:setup-refocus
```

## License

MIT License - see [LICENSE](LICENSE) file for details.
