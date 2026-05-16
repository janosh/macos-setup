# Global Agent Instructions


## Correctness (don't bullshit)

- **Compare with explicit, justified tolerances.** Use `np.testing.assert_allclose(rtol=..., atol=...)` with values you chose deliberately (not defaults). For "bit-identical" claims use exact equality. Pin seeds before comparing stochastic outputs.

## Multi-agent branch sharing

Multiple agents may work on the same branch concurrently. Editing a file that already has uncommitted changes from another agent is fine, don't be timid, except at git time: when staging and committing. Don't stage changes unless asked to commit. Include only the changes relevant to your task and use explicit `git add <your-files>` instead of `git add -A` so you don't commit, revert, or stash another agent's out-of-scope work. Only exception being if other agent's work looks related or too menial to warrant it's own commit, then just include in your commit.

## Python Projects (*.py, pyproject.toml)

- Always add typing annotations to functions and classes, including return types
- Add descriptive docstrings to all functions and classes
- Don't add shebangs (no `#!/usr/bin/env python`)
- Use `pytest` for testing, never `unittest`
- All tests go in `./tests` with concise single-line docstrings
- Use `pytest.mark.parametrize()` to cover multiple parameter values
- Prefer `os.path.isfile/isdir` over `os.path.exists`
- Use f-strings for paths, not `os.path.join()`
- Prefer `os.path` over `pathlib.Path` (except with `tmp_path` fixture)
- Use `ty` for type checking, never `mypy`, `pyright`, or others
- **NEVER use `__all__`!** We discourage star imports—they break static analysis of types and imports
- Use `time.perf_counter()` instead of `time.time()` for wall-time measurements
- Always prefer `plotly` over `matplotlib` for plotting. When exporting to HTML, always use `include_plotlyjs="cdn"` for much smaller file sizes (3 KB vs 3 MB).
- Never use `fig.add_trace(go.Scatter(...))` — use `fig.add_scatter(...)`, `fig.add_bar(...)`, `fig.add_histogram(...)`, etc. directly. Shorter, avoids the redundant `go.` import for trace types, and lets plotly validate args at call time.
- **In `notebooks/`, prefer pymatviz widgets instead: `BarPlotWidget`, `HeatmapMatrixWidget`, `HistogramWidget`, `ScatterPlotWidget`, `StructureWidget`, `ConvexHullWidget`, `TrajectoryWidget`, `PhaseDiagramWidget`, etc. over `plotly` or `matplotlib` figures. Check existing demos/notebooks for usage and API patterns before writing new visualization code.
- avoid `typing.cast` unless absolutely necessary

## TypeScript/Svelte Projects (*.ts,*.svelte)

- Use snake_case for variables and functions, not camelCase
- Use `it.each([...])` and `test.each([...])` for parameterized vitest tests
- In CSS/style blocks, don't leave blank lines between rules - the closing `}` is enough separation
- Keep CSS simple: prefer nested selectors over many classes; inline styles if a class only has 1-2 rules. offer to remove CSS classes that aren't used at all.
- Prefer [attachments](https://svelte.dev/docs/svelte/@attach) over the legacy [`use:` directive](https://svelte.dev/docs/svelte/use) for actions
- Avoid `switch` statements, prefer simple `if`/`else` chains
- Prefer arrow functions for direct-return functions (body is a single `return`), e.g. `const f = (x) => x + 1` over `function f(x) { return x + 1 }`
- `$derived` is writable! Don't use `$state` + `$effect` when `$derived` with later reassignment works
- Pass Svelte `$state` variables (not plain values) to `bind:`-able props to avoid `state_referenced_locally` warnings. e.g. avoid `x_axis={{ label: 'foo' }}` if `x_axis` is bindable. instead define `let x_axis = $state(label: 'foo')` and pass `bind:x_axis` to component.
- Never use `any` type! Use `unknown` and narrow, or define proper types
- Avoid `!` non-null assertions—narrow types instead
- Destructure props: `const { name, age } = user` over `user.name, user.age` repeatedly
- Prefer `format_num` from `matterviz` over `.toFixed()` for number formatting (handles SI prefixes, trailing zeros)


- Don't commit without being asked

## CRITICAL: Protect Uncommitted Work

**NEVER run `git reset`, `git checkout <file>`, `git stash`, or `git clean` on modified/untracked files without explicit user approval!**

Multiple agents work on the same repo concurrently. Any destructive git operation (`reset`, `checkout -- <path>`, `stash`, `clean`, `restore`) can silently destroy another agent's in-progress work. This includes files you didn't modify — they may belong to a parallel agent. Always ask before discarding anything.

- If you need a clean working tree for your task, use `git worktree add` instead of stashing
- Check with `ls -la` and `file <path>` before deleting—directories may be symlinks to working copies

## General

- **Units notation**: never use `ų` or other obscure Unicode glyphs for units. Write `A^3` (cubic angstrom), `e/A^3` (electron density), `eV/A` (force), etc. In Rust doc comments and Python docstrings use `Å³`, `e/Å³`, `eV/Å` with the standard Å character.
- **No single-letter or concatenated variable names!** Use proper snake_case: `idx` not `i`, `n_images` not `nimages`, `f_max` not `fmax`, `col_idx` not `colidx`
- **No fallbacks or backward-compatible interfaces** unless explicitly told. Throw an error or fail early—silent catches, default shims, and compatibility wrappers mask bugs.
- Remove dead code aggressively. Prefer a clean codebase over deprecation.
- Log useful context with errors—include relevant variable values
- Prefer editing existing files over creating new ones.
- Use single-line section headers: `// === Section Name ===` not verbose multi-line box comments
- **Never commit handover docs, temp data files, or proof-of-concept artifacts** (no `HANDOVER.md`, sample `.jsonl`/`.lmdb` files, exploratory notebooks, etc.). These clutter the monorepo — keep them local or in `tmp/`.
- Use `prek` (Rust port), never `pre-commit` (Python)
- When fixing a bug or making a behavior tweak, ALWAYS add or update a unit test that would have caught it. Prefer extending an existing related test over creating a new test to avoid extra setup/teardown bloat. Only create a new test when there is no related test to extend.
