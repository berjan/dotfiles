---
description: Add all files, analyze changes, create commit message, commit and push
allowed-tools: Bash
---

First, let me check the git status and understand what changes need to be committed:

!git status

Now let me see the detailed changes:

!git diff --cached
!git diff

Based on the changes above, I'll analyze what was modified and create an appropriate commit message.

Important: The commit message should describe the actual changes made, without any references to AI tools or assistants.

!git add -A

Now I'll commit with a descriptive message based on the changes I analyzed:

!git commit -m "appropriate commit message describing the actual changes"

!git push