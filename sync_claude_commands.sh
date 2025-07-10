#!/bin/bash

# Claude Code commands setup
echo "Setting up Claude Code commands..."

# Create directories if they don't exist
mkdir -p ~/.claude/commands

# Remove old symlinks if they exist
find ~/.claude/commands -type l -delete

# Symlink all command files
for cmd in ~/dotfiles/claude/commands/**/*.md; do
    if [ -f "$cmd" ]; then
        # Get relative path from commands directory
        rel_path="${cmd#~/dotfiles/claude/commands/}"
        # Create directory structure if needed
        dir_path=$(dirname "$rel_path")
        if [ "$dir_path" != "." ]; then
            mkdir -p ~/.claude/commands/"$dir_path"
        fi
        # Create symlink
        ln -sf "$cmd" ~/.claude/commands/"$rel_path"
        echo "Linked: $rel_path"
    fi
done

echo "Claude commands synced!"