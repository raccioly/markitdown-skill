# Test Specification

<!-- docguard:version 0.1.0 -->
<!-- docguard:status draft -->
<!-- docguard:last-reviewed 2026-09-16 -->
<!-- docguard:owner @raccioly -->

> **Canonical document** — Required tests for this **Agent Skill** package.
> There is no web app, API, or database — **no Playwright/Cypress E2E fiction**.
> Focus: CLI smoke, skill packaging integrity, and DocGuard gates.
> Last updated: 2026-09-16

---

## Test Categories

| Category | Required | Applies To | Suggested Tools |
|----------|----------|-----------|-----------------|
| Unit | ❌ No | N/A — no application source tree | — |
| Integration | ⚠️ Optional | MarkItDown CLI against sample fixtures | shell + fixture files |
| E2E (web) | ❌ No | Not a web product | — |
| Smoke / canary | ✅ Yes | CLI availability, skill frontmatter, zip layout | `tests/smoke.sh` |
| DocGuard | ✅ Yes | CDD structure and score | `docguard guard`, `docguard score` |
| Load | ❌ No | Local CLI only | — |
| Security | ⚠️ Manual | Guardrail wording in SKILL.md | review checklist |

## Coverage Rules

| Source / Artifact | Required Check | Category |
|-------------------|----------------|----------|
| `markitdown/SKILL.md` | Frontmatter `name`/`description` present; Guardrails section exists | Smoke |
| MarkItDown CLI | `markitdown --version` or `uvx "markitdown[all]" --version` succeeds | Smoke |
| Release zip | `markitdown-skill.zip` (when built) contains `markitdown/SKILL.md` | Smoke |
| Canonical docs | `docguard guard` has no blocking structure failures | DocGuard |

## Service-to-Test Map

| Artifact | Smoke Test | Status |
|----------|------------|--------|
| `markitdown/SKILL.md` | `tests/smoke.sh` (frontmatter + guardrails) | ✅ |
| MarkItDown CLI | `tests/smoke.sh` (version probe) | ✅ |
| Zip package | `tests/smoke.sh` (optional if zip present) | ⚠️ |
| CDD docs | `docguard score` / `docguard guard` | ✅ |

## Critical journeys (skill — not web E2E)

| # | Journey | Verification | Status |
|---|---------|--------------|--------|
| 1 | Install CLI → convert a small `.docx`/`.csv` to Markdown | Manual or fixture smoke | ⚠️ |
| 2 | Skill loads and prefers CLI over ad-hoc Python extraction | Agent session checklist in README Verify | ⚠️ |
| 3 | Large file path uses `-o` then selective read | Manual against SKILL.md How section | ⚠️ |

## Canary Tests (pre-release)

| Canary | What It Checks | Command / File |
|--------|----------------|----------------|
| CLI present | MarkItDown or uvx fallback responds | `tests/smoke.sh` |
| Skill package | SKILL.md schema basics | `tests/smoke.sh` |
| DocGuard | Score / guard thresholds for the branch | `docguard score` |

## Recommended Test Patterns

| Pattern | Description | Priority |
|---------|-------------|----------|
| CLI version smoke | Fail fast if neither `markitdown` nor `uvx` works | High |
| Frontmatter pin | Assert `name: markitdown` stays stable for auto-load | High |
| Empty / missing file | CLI error path documented; smoke may skip without fixtures | Medium |
| No fake web E2E | Do not add Playwright suites for this skill pack | High |

## Running tests

```bash
# From repo root
bash tests/smoke.sh
docguard score
docguard guard
```
