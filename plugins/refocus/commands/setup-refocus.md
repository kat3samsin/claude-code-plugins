---
description: Set up clickable notifications to refocus on your terminal when tasks complete
---

Base directory for this skill: {{plugin_dir}}/skills/setup-refocus

# Refocus: Never Lose Track of Your Terminal

This skill sets up clickable macOS notifications for Claude Code:

- **Notification on task completion** - Know when Claude is done
- **Click to refocus** - Activate your terminal window instantly
- **Smart messages** - Different notifications for different completion types
- **Customizable sounds** - Choose your notification sound

## How to Run

Users can trigger this skill by:

1. **Slash command**: `/refocus:setup-refocus`
2. **Ask Claude**: "Set up refocus" or "I want clickable notifications when tasks complete"

## What It Does

1. Asks which terminal you use (iTerm2, Ghostty, or Terminal.app)
2. Asks your preferred notification sound
3. Creates the notification handler script at `~/.claude/hooks/refocus-handler.sh`
4. Configures the Stop hook in `~/.claude/settings.json`
5. Sends a test notification to confirm it works

## After Setup

When Claude Code finishes a task:
1. A notification appears in your macOS notification center
2. Click the notification to activate your terminal window
3. You're right back where you left off!

## Requirements

- macOS
- `terminal-notifier` - Install with: `brew install terminal-notifier`
- `jq` for settings configuration (`brew install jq`)

## Supported Terminals

- **iTerm2** - Bundle ID: `com.googlecode.iterm2`
- **Ghostty** - Bundle ID: `com.mitchellh.ghostty`
- **Terminal.app** - Bundle ID: `com.apple.Terminal`

## Troubleshooting

### Notification doesn't appear

1. Check macOS notification settings for terminal-notifier
2. Go to System Settings > Notifications > terminal-notifier
3. Ensure "Allow Notifications" is enabled
