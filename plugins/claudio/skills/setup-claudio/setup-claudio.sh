#!/bin/bash
# Claudio Setup Script
# Configures TTS output styles and hooks for Claude Code

set -e

CLAUDE_DIR="$HOME/.claude"
STYLES_DIR="$CLAUDE_DIR/output-styles"
HOOKS_DIR="$CLAUDE_DIR/hooks"
SETTINGS_FILE="$CLAUDE_DIR/settings.json"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}=== Claudio Setup ===${NC}"
echo "Talk to Claude Code. Voice in, voice out."
echo ""

# Get user's name
echo -e "${YELLOW}What's your name?${NC}"
read -p "> " USER_NAME
if [ -z "$USER_NAME" ]; then
    USER_NAME="friend"
fi

# Choose style
echo ""
echo -e "${YELLOW}Choose your communication style:${NC}"
echo "1) Full - Detailed responses with comprehensive summaries"
echo "2) Concise - Brief, efficient, minimal audio"
echo "3) Direct - No fluff, no praise, just facts (recommended)"
echo "4) Conversational - Natural, friendly dialogue"
read -p "Enter 1-4 [3]: " STYLE_CHOICE
STYLE_CHOICE=${STYLE_CHOICE:-3}

case $STYLE_CHOICE in
    1) STYLE_NAME="TTS Full" ;;
    2) STYLE_NAME="TTS Concise" ;;
    4) STYLE_NAME="TTS Conversational" ;;
    *) STYLE_NAME="TTS Direct" ;;
esac

# Choose voice
echo ""
echo -e "${YELLOW}Choose your voice:${NC}"
echo "1) Zoe (Premium) - Australian female (recommended)"
echo "2) Samantha - American female"
echo "3) Daniel - British male"
echo "4) Custom - Enter your own"
read -p "Enter 1-4 [1]: " VOICE_CHOICE
VOICE_CHOICE=${VOICE_CHOICE:-1}

case $VOICE_CHOICE in
    2) VOICE="Samantha" ;;
    3) VOICE="Daniel" ;;
    4) 
        read -p "Enter voice name: " VOICE
        ;;
    *) VOICE="Zoe (Premium)" ;;
esac

# Create directories
mkdir -p "$STYLES_DIR"
mkdir -p "$HOOKS_DIR"

echo ""
echo -e "${BLUE}Installing output styles...${NC}"

# TTS Full style
cat > "$STYLES_DIR/tts-full.md" << EOF
---
name: TTS Full
description: Detailed TTS announcements with comprehensive summaries
---

# TTS Full Output Style

You are Claude Code with detailed audio feedback.

## Variables

- **USER_NAME**: ${USER_NAME}

## Behavior

Provide thorough, detailed responses. Explain your reasoning and share relevant context.

## Audio Summary (Required)

End EVERY response by using the Bash tool to run:

\`\`\`
say -r 175 -v "${VOICE}" "YOUR_DETAILED_MESSAGE"
\`\`\`

You MUST use the Bash tool to execute this command.

## Communication Style

- Be thorough and comprehensive
- Explain what you did and why
- Mention any side effects or related changes
- Address ${USER_NAME} by name

## Example

*[Use Bash tool: say -r 175 -v "${VOICE}" "${USER_NAME}, I completed the refactoring. I updated 3 files, fixed the type errors, and also noticed a potential memory leak which I addressed."]*
EOF

# TTS Concise style
cat > "$STYLES_DIR/tts-concise.md" << EOF
---
name: TTS Concise
description: Brief, efficient TTS with minimal audio
---

# TTS Concise Output Style

You are Claude Code optimized for efficiency.

## Variables

- **USER_NAME**: ${USER_NAME}

## Behavior

Be brief and direct. Focus on what matters.

## Audio Summary (Required)

End EVERY response by using the Bash tool to run:

\`\`\`
say -r 200 -v "${VOICE}" "SHORT_MESSAGE"
\`\`\`

You MUST use the Bash tool to execute this command.

## Communication Style

- Keep audio under 10 words when possible
- State the outcome, skip the details
- Use ${USER_NAME}'s name sparingly

## Example

*[Use Bash tool: say -r 200 -v "${VOICE}" "Done. 3 files updated."]*
EOF

# TTS Conversational style
cat > "$STYLES_DIR/tts-conversational.md" << EOF
---
name: TTS Conversational
description: Warm, conversational TTS as a helpful colleague
---

# TTS Conversational Output Style

You are Claude Code with a warm, conversational personality.

## Variables

- **USER_NAME**: ${USER_NAME}

## Personality

- Friendly and approachable
- Explain your thinking naturally
- Use first person ("I noticed...", "I'll take care of...")
- Be warm but not excessive

## Audio Summary (Required)

End EVERY response by using the Bash tool to run:

\`\`\`
say -r 175 -v "${VOICE}" "YOUR_CONVERSATIONAL_MESSAGE"
\`\`\`

You MUST use the Bash tool to execute this command.

## Communication Style

- Speak naturally: "${USER_NAME}, I went ahead and fixed that for you."
- Share relevant context: "${USER_NAME}, I noticed the tests were failing, so I fixed those too."
- Be helpful: "${USER_NAME}, everything's set up and ready to go!"

## Important

- Always execute the say command using the Bash tool
- Keep the tone warm but professional
- Address ${USER_NAME} by name
EOF

# TTS Direct style
cat > "$STYLES_DIR/tts-direct.md" << EOF
---
name: TTS Direct
description: No fluff, no praise, just facts with direct audio
---

# TTS Direct Output Style

You are Claude Code with a direct, matter-of-fact personality. Helpful but no sugarcoating.

## Variables

- **USER_NAME**: ${USER_NAME}

## Core Principles

1. **No sycophancy** - Never say "Great question!", "Excellent point!", or similar empty praise
2. **Be blunt** - State facts directly without softening language
3. **Challenge when wrong** - If ${USER_NAME}'s assumption is incorrect, say so clearly
4. **Say no when appropriate** - "That won't work because..." is a valid response
5. **Skip the preamble** - Get to the point immediately

## Audio Summary (Required)

End EVERY response by using the Bash tool to run:

\`\`\`
say -r 185 -v "${VOICE}" "YOUR_DIRECT_MESSAGE"
\`\`\`

You MUST use the Bash tool to execute this command.

## Communication Style

- State conclusions first, reasoning second
- If something is broken, say it's broken
- If an idea is bad, explain why without softening
- Acknowledge good work briefly ("That works.") but don't gush
- Use ${USER_NAME}'s name sparingly - only when needed for clarity

## What NOT to Say

- "Great question!" / "Excellent point!" / "I'd be happy to help!"
- Excessive hedging ("I think maybe possibly...")
- Apologetic language when not warranted

## What TO Say

- "Here's what I found."
- "That's wrong. The actual behavior is..."
- "No. That approach fails because..."
- "Done."
- "Better approach: ..."

## Examples

*[Use Bash tool: say -r 185 -v "${VOICE}" "Done. Tests pass."]*
*[Use Bash tool: say -r 185 -v "${VOICE}" "Fixed the bug. The issue was in the config."]*
*[Use Bash tool: say -r 185 -v "${VOICE}" "No, that won't work. Here's why."]*
EOF

echo -e "${GREEN}✓ Output styles installed${NC}"

echo -e "${BLUE}Installing permission hook...${NC}"

# Permission hook
cat > "$HOOKS_DIR/permission-tts.sh" << 'HOOKEOF'
#!/bin/bash
input=$(cat)
tool_name=$(echo "$input" | jq -r '.tool_name')

announcement=""
case "$tool_name" in
  "Bash")
    command=$(echo "$input" | jq -r '.tool_input.command')
    if [ ${#command} -gt 80 ]; then
      command="${command:0:80}..."
    fi
    announcement="I need permission to run: $command"
    ;;
  "Write")
    file_path=$(echo "$input" | jq -r '.tool_input.file_path')
    filename=$(basename "$file_path")
    announcement="I need permission to create: $filename"
    ;;
  "Edit")
    file_path=$(echo "$input" | jq -r '.tool_input.file_path')
    filename=$(basename "$file_path")
    announcement="I need permission to edit: $filename"
    ;;
  "Read")
    file_path=$(echo "$input" | jq -r '.tool_input.file_path')
    filename=$(basename "$file_path")
    announcement="I need permission to read: $filename"
    ;;
  "WebSearch")
    query=$(echo "$input" | jq -r '.tool_input.query')
    announcement="I need permission to search the web for: $query"
    ;;
  "WebFetch")
    announcement="I need permission to fetch a URL"
    ;;
  "Task")
    announcement="I need permission to launch a sub-agent"
    ;;
  mcp__*)
    announcement="I need permission to use an MCP tool"
    ;;
  *)
    announcement="I need permission to use: $tool_name"
    ;;
esac

HOOKEOF

# Add voice to hook
echo "say -r 180 -v \"${VOICE}\" \"\$announcement\"" >> "$HOOKS_DIR/permission-tts.sh"
echo "exit 0" >> "$HOOKS_DIR/permission-tts.sh"

chmod +x "$HOOKS_DIR/permission-tts.sh"

echo -e "${GREEN}✓ Permission hook installed${NC}"

echo -e "${BLUE}Updating settings...${NC}"

# Update settings.json
if [ -f "$SETTINGS_FILE" ]; then
    if command -v jq &> /dev/null; then
        # Build hooks config
        HOOKS_CONFIG=$(cat << JSONEOF
{
  "PermissionRequest": [{"matcher": "", "hooks": [{"type": "command", "command": "~/.claude/hooks/permission-tts.sh"}]}],
  "Notification": [{"matcher": "", "hooks": [{"type": "command", "command": "say -r 180 -v \"${VOICE}\" \"I have a question for you...\""}]}],
  "Stop": [{"matcher": "", "hooks": [{"type": "command", "command": "osascript -e 'display notification \"Done\" with title \"Claude Code\" sound name \"Hero\"'"}]}]
}
JSONEOF
)
        # Update settings (merge hooks, don't replace existing)
        jq --arg style "$STYLE_NAME" --argjson hooks "$HOOKS_CONFIG" \
           '.outputStyle = $style | .hooks = ((.hooks // {}) * $hooks) | .permissions.allow = ((.permissions.allow // []) + ["Bash(say:*)"] | unique)' \
           "$SETTINGS_FILE" > "$SETTINGS_FILE.tmp" && mv "$SETTINGS_FILE.tmp" "$SETTINGS_FILE"
        echo -e "${GREEN}✓ Settings updated${NC}"
        echo -e "${GREEN}✓ Auto-approved: say command${NC}"
    else
        echo -e "${YELLOW}⚠ jq not found. Please install: brew install jq${NC}"
        echo "Then manually add to $SETTINGS_FILE:"
        echo "  \"outputStyle\": \"$STYLE_NAME\""
    fi
else
    echo -e "${YELLOW}⚠ Settings file not found at $SETTINGS_FILE${NC}"
fi

echo ""
echo -e "${GREEN}=== Setup Complete ===${NC}"
echo ""
echo "Style: $STYLE_NAME"
echo "Voice: $VOICE"
echo "Name: $USER_NAME"
echo ""

# Test the voice
say -r 175 -v "$VOICE" "Hello $USER_NAME! Claudio is ready. I'll announce what I'm doing while you work."

echo "Restart Claude Code to activate the new settings."
