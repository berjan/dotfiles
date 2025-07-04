# Claude Code Configuration

## Commit Guidelines

When making commits, use the following format without Claude references:

```bash
git commit -m "Brief description of change

- Bullet point of specific change
- Another specific change
- Additional context if needed"
```

### Example:
```bash
git commit -m "Fix claude alias to be conditional and portable

- Use HOME variable instead of hardcoded path
- Only create alias if claude binary exists
- Prevents errors on servers without claude installed"
```

## Notes

- Avoid adding Claude Code references or attributions in commit messages
- Keep commit messages descriptive but concise
- Use bullet points for multiple changes