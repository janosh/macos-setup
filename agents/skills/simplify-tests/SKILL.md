---
name: simplify-tests
description: Refactor tests to be clearer and more concise while preserving coverage. Use when tests are verbose or repetitive.
---

# Simplify Tests

## When to use

- Tests pass but are hard to read or maintain
- Similar test cases can be parameterized

## Instructions

   - Parameterize repeated cases
   - Remove unnecessary setup and helper duplication
   - Clarify Arrange-Act-Assert flow

## Rules

- Preserve effective coverage
- Prefer readability over clever abstractions
- Accept only minor performance tradeoffs for substantially clearer tests
