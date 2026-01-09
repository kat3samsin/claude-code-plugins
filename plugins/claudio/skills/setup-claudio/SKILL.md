---
name: setup-claudio
description: Install and configure TTS Claude with audio announcements and customizable output styles
---

# Claudio: Talk to Claude Code

This skill sets up an enhanced Claude Code experience with voice output:

- **Audio announcements** for task completions, permission requests, and questions
- **Smart permission announcements** that tell you exactly what's being requested
- **Three output styles**: Full, Concise, and Conversational
- **Personalized** with your name

## How to Run

Users can trigger this skill by:

1. **Slash command**: `/setup-claudio`
2. **Ask Claude**: "Set up Claudio" or "Make Claude talk"

## What It Does

1. Asks for your name
2. Lets you choose your preferred style:
   - **Full**: Detailed responses with comprehensive audio summaries
   - **Concise**: Brief, efficient responses with short audio
   - **Conversational**: Natural, friendly dialogue with warm audio
3. Installs output styles to `~/.claude/output-styles/`
4. Installs TTS hooks for:
   - **PermissionRequest**: Announces what specific permission is needed
   - **Notification**: Announces when Claude has a question
   - **Stop**: Announces when task is complete
5. Updates your `~/.claude/settings.json`
6. Confirms setup with audio feedback

## After Setup

Switch styles anytime by editing `~/.claude/settings.json`:

```json
{
  "outputStyle": "TTS Conversational"
}
```

Options: `"TTS Full"`, `"TTS Concise"`, `"TTS Conversational"`

## Requirements

- macOS (uses `say` command for TTS)
- `jq` for settings configuration (`brew install jq`)
- Optional: Premium voices (System Settings > Accessibility > Spoken Content > System Voice > Manage Voices)

## Voice Customization

List available voices:
```bash
say -v '?'
```

Recommended voices:
- `Zoe (Premium)` - Australian female (default)
- `Samantha` - American female
- `Daniel` - British male

Premium voices sound more natural but must be downloaded separately.
