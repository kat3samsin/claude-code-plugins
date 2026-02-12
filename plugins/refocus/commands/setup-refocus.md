---
description: Set up clickable notifications to refocus on your terminal when tasks complete
---

Base directory for this skill: {{plugin_dir}}/skills/setup-refocus

Run the setup script to configure Refocus:

```bash
bash "{{plugin_dir}}/skills/setup-refocus/setup-refocus.sh"
```

This will:
1. Ask which terminal you use (iTerm2, Ghostty, or Terminal.app)
2. Ask your preferred notification sound
3. Create the notification handler script
4. Configure the Stop hook in settings
5. Send a test notification
