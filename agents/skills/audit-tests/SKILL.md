---
name: audit-tests
description: Audit test files or directories for low-value coverage; simplify, fold duplicates, and delete only demonstrably redundant tests while preserving behavioral coverage. Use for test-suite cleanup.
---

# Audit Tests

## Workflow


## Scope handling


## Report


## Rules

- Distinct edge/error inputs and different test genres are not duplicates.
- Preserve snapshot, property, generated, integration/e2e, and skip/xfail/slow semantics.
- Coverage supports judgment but neither proves equivalence nor justifies a test by itself.
