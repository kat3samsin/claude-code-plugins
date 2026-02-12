---
description: Install and configure TTS Claude with audio announcements
---

Base directory for this skill: {{plugin_dir}}/skills/setup-claudio

Run the setup script to configure Claudio:

```bash
bash "{{plugin_dir}}/skills/setup-claudio/setup-claudio.sh"
```

This will:
1. Ask for your name
2. Let you choose a communication style (Full, Concise, Direct, or Conversational)
3. Let you choose a voice
4. Install output styles and TTS hooks
5. Test the voice
