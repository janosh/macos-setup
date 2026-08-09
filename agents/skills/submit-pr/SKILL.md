---
name: submit-pr
disable-model-invocation: true
---

# Submit PR Flow

## When to use

- User explicitly asks to open a PR

## Instructions

1. Ensure current branch is not `main`.
2. If on `main`, auto-create a descriptive param-case branch name:
   - max 5-6 words
   - preferably shorter when clarity is preserved
3. Review local changes and organize semantic commits in dependency order.
4. Derive PR metadata from the full diff, not the branch name or latest commit.
   - Use literal, implementation-specific language. Never use vague LLM packaging such as “harden,” “strengthen,” “improve,” “enhance,” “streamline,” “robust,” or “load-bearing.” Prefer “Initialize background tabs, protect dirty buffers, and bound shared dashboard plots” over “Harden background tab and dashboard safety.”
   - Do not use Conventional Commit prefixes such as `feat:` or `fix:`.
5. Inspect labels and apply best-fit labels.

## Rules

- Use `gh` for PR and labels workflow
- Keep commit and PR messaging concise and descriptive
