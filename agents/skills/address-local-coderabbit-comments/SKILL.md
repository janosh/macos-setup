---
name: address-local-coderabbit-comments
description: Extract CodeRabbit comments for the most recent review round in the active repo and triage them for action.
---

# Address Local CodeRabbit Comments

## When to use

Use this skill when a user asks for:

- triaging or addressing the latest CodeRabbit feedback
- the current review round status, not historical rounds

## Quick workflow

1. Identify the target workspace path (usually current repo).

```bash
```



## Critical behavior


## Review style guardrails

When acting on extracted comments:

- Verify every comment against the current code before changing anything.
- Treat findings as suggestions, not mandates; reject false positives explicitly.
- Prefer simplification and clarity over defensive complexity.
- If a suggestion conflicts with project conventions, keep the convention and note why.
