#!/bin/bash
# Refocus Setup Script
# Configures clickable notifications for Claude Code task completion

set -e

CLAUDE_DIR="$HOME/.claude"
HOOKS_DIR="$CLAUDE_DIR/hooks"
SETTINGS_FILE="$CLAUDE_DIR/settings.json"
HANDLER_SCRIPT="$HOOKS_DIR/refocus-handler.sh"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}=== Refocus Setup ===${NC}"
echo "Refocus on your terminal when Claude Code tasks complete."
echo ""

# Check for terminal-notifier
if ! command -v terminal-notifier &> /dev/null; then
    echo -e "${RED}Error: terminal-notifier is not installed.${NC}"
    echo "Install it with: brew install terminal-notifier"
    exit 1
fi

# Choose terminal
echo -e "${YELLOW}Which terminal do you use with Claude Code?${NC}"
echo "1) iTerm2"
echo "2) Ghostty"
echo "3) Terminal.app (built-in)"
read -p "Enter 1, 2, or 3 [1]: " TERMINAL_CHOICE
TERMINAL_CHOICE=${TERMINAL_CHOICE:-1}

case $TERMINAL_CHOICE in
    2)
        TERMINAL_NAME="Ghostty"
        BUNDLE_ID="com.mitchellh.ghostty"
        ;;
    3)
        TERMINAL_NAME="Terminal"
        BUNDLE_ID="com.apple.Terminal"
        ;;
    *)
        TERMINAL_NAME="iTerm2"
        BUNDLE_ID="com.googlecode.iterm2"
        ;;
esac

echo ""
echo -e "${YELLOW}What sound should play on notification?${NC}"
echo "1) Hero (recommended)"
echo "2) Glass"
echo "3) Pop"
echo "4) Submarine"
echo "5) None (silent)"
read -p "Enter 1-5 [1]: " SOUND_CHOICE
SOUND_CHOICE=${SOUND_CHOICE:-1}

case $SOUND_CHOICE in
    2) SOUND_NAME="Glass" ;;
    3) SOUND_NAME="Pop" ;;
    4) SOUND_NAME="Submarine" ;;
    5) SOUND_NAME="" ;;
    *) SOUND_NAME="Hero" ;;
esac

# Create hooks directory
mkdir -p "$HOOKS_DIR"

echo ""
echo -e "${BLUE}Creating notification handler...${NC}"

# Create the handler script
cat > "$HANDLER_SCRIPT" << 'HANDLER_SCRIPT_CONTENT'
#!/bin/bash
# Refocus Handler - Called by Claude Code's Stop hook
# Sends a clickable notification that activates the terminal

# Configuration (set by setup script)
BUNDLE_ID="__BUNDLE_ID__"
TERMINAL_NAME="__TERMINAL_NAME__"
SOUND_NAME="__SOUND_NAME__"

# Function to strip markdown formatting
strip_markdown() {
    echo "$1" | sed \
        -e 's/\*\*\([^*]*\)\*\*/\1/g' \
        -e 's/__\([^_]*\)__/\1/g' \
        -e 's/\*\([^*]*\)\*/\1/g' \
        -e 's/_\([^_]*\)_/\1/g' \
        -e 's/`\([^`]*\)`/\1/g' \
        -e 's/^#{1,6} //g' \
        -e 's/\[([^]]*)\]([^)]*)/\1/g'
}

# Read JSON from stdin (Stop hook context)
input=$(cat)

# Extract message content if available, otherwise use stop_reason
raw_message=$(echo "$input" | jq -r '.message // .content // empty' 2>/dev/null)

if [ -n "$raw_message" ]; then
    # Strip markdown from the message
    message=$(strip_markdown "$raw_message")
else
    # Fall back to stop_reason based messages
    stop_reason=$(echo "$input" | jq -r '.stop_reason // "completed"' 2>/dev/null || echo "completed")

    case "$stop_reason" in
        "end_turn")
            message="Task completed successfully"
            ;;
        "tool_use")
            message="Waiting for your input"
            ;;
        "max_tokens")
            message="Response was truncated"
            ;;
        *)
            message="Task completed"
            ;;
    esac
fi

# Build notification command
notify_args=(
    -title "Claude Code"
    -message "$message"
    -activate "$BUNDLE_ID"
)

# Add sound if specified
if [ -n "$SOUND_NAME" ]; then
    notify_args+=(-sound "$SOUND_NAME")
fi

# Send notification
terminal-notifier "${notify_args[@]}"

exit 0
HANDLER_SCRIPT_CONTENT

# Replace placeholders with actual values
sed -i '' "s|__BUNDLE_ID__|$BUNDLE_ID|g" "$HANDLER_SCRIPT"
sed -i '' "s|__TERMINAL_NAME__|$TERMINAL_NAME|g" "$HANDLER_SCRIPT"
sed -i '' "s|__SOUND_NAME__|$SOUND_NAME|g" "$HANDLER_SCRIPT"

chmod +x "$HANDLER_SCRIPT"

echo -e "${GREEN}✓ Handler script created${NC}"

echo -e "${BLUE}Updating settings...${NC}"

# Update settings.json
if [ -f "$SETTINGS_FILE" ]; then
    if command -v jq &> /dev/null; then
        # Build the Stop hook config
        STOP_HOOK=$(cat << JSONEOF
[{"matcher": "", "hooks": [{"type": "command", "command": "~/.claude/hooks/refocus-handler.sh"}]}]
JSONEOF
)
        # Update settings - add or replace Stop hook
        jq --argjson stopHook "$STOP_HOOK" \
           '.hooks.Stop = $stopHook | .permissions.allow = ((.permissions.allow // []) + ["Bash(terminal-notifier:*)"] | unique)' \
           "$SETTINGS_FILE" > "$SETTINGS_FILE.tmp" && mv "$SETTINGS_FILE.tmp" "$SETTINGS_FILE"
        echo -e "${GREEN}✓ Settings updated${NC}"
        echo -e "${GREEN}✓ Auto-approved: terminal-notifier command${NC}"
    else
        echo -e "${YELLOW}⚠ jq not found. Please install: brew install jq${NC}"
        echo "Then manually configure the Stop hook in $SETTINGS_FILE"
    fi
else
    echo -e "${YELLOW}⚠ Settings file not found at $SETTINGS_FILE${NC}"
    echo "Creating initial settings..."
    cat > "$SETTINGS_FILE" << SETTINGSEOF
{
  "hooks": {
    "Stop": [{"matcher": "", "hooks": [{"type": "command", "command": "~/.claude/hooks/refocus-handler.sh"}]}]
  },
  "permissions": {
    "allow": ["Bash(terminal-notifier:*)"]
  }
}
SETTINGSEOF
    echo -e "${GREEN}✓ Settings file created${NC}"
fi

echo ""
echo -e "${GREEN}=== Setup Complete ===${NC}"
echo ""
echo "Terminal: $TERMINAL_NAME"
echo "Sound: ${SOUND_NAME:-None}"
echo ""
echo "When Claude Code finishes a task:"
echo "  1. A notification will appear"
echo "  2. Click it to jump back to $TERMINAL_NAME"
echo ""

# Send a test notification
echo "Sending test notification..."
terminal-notifier \
    -title "Claude Code" \
    -message "Refocus is ready! Click to test." \
    -activate "$BUNDLE_ID" \
    ${SOUND_NAME:+-sound "$SOUND_NAME"}

echo ""
echo "Restart Claude Code to activate the new settings."
