---
name: review-branch
description: Perform full branch review against main and propose high-impact fixes. Use for pre-PR quality review.
---

# Review Branch

## When to use

- Branch is ready for full review before PR
- You need architecture/correctness/style assessment across all branch changes

## Instructions

1. Inspect branch scope (`git log main..HEAD`, diff stats, full diff).

## Rules

- Review entire branch diff, not only latest commit
- Prioritize correctness and regressions over stylistic polish
