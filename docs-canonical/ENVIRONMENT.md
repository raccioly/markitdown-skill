# Environment & Configuration

<!-- docguard:version 0.1.0 -->
<!-- docguard:status draft -->
<!-- docguard:last-reviewed 2026-09-16 -->
<!-- docguard:owner @raccioly -->

> **Canonical document** — How to run and use this Agent Skill package.
> **No required environment variables.** Conversion is a local CLI concern.
> Last updated: 2026-09-16

---

## Prerequisites

| Requirement | Version | Purpose |
|------------|---------|---------|
| Python tooling | pipx **or** uv/uvx **or** session pip | Install / run MarkItDown CLI |
| MarkItDown | `"markitdown[all]"` | Document → Markdown conversion |
| Host agent | Claude Code or any Agent Skills–compatible host | Loads `markitdown/SKILL.md` |
| DocGuard (maintainers) | `docguard-cli` via npm/npx or `docguard-cli` PyPI wrapper | CDD score/guard |
| zip (maintainers) | system `zip` | Build Desktop upload artifact |

## Environment Variables

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| — | ❌ None | — | This skill does **not** read `DATABASE_URL`, API keys, ports, or JWT secrets |

Optional host/agent variables may exist for the IDE or Claude session; they are outside this package.

## Configuration Files

| File | Purpose | Template |
|------|---------|----------|
| `markitdown/SKILL.md` | Skill instructions + frontmatter | (the file itself) |
| `.docguard.json` | DocGuard profile for maintainers | committed |
| `.env` / `.env.example` | **Not used** | Do not add |

## Install paths (runtime)

| Path | Commands |
|------|----------|
| Recommended CLI | `pipx install "markitdown[all]"` |
| uv tool | `uv tool install "markitdown[all]"` |
| Zero install | `uvx "markitdown[all]" …` (skill fallback) |
| Sandbox session | `pip install "markitdown[all]"` inside Cowork / claude.ai session |

Verify: `markitdown --version` (or the uvx equivalent).

## Setup Steps

1. Clone `https://github.com/raccioly/markitdown-skill.git` (or download the release zip).
2. Install MarkItDown via pipx, uv, or rely on `uvx` / session pip as above.
3. Copy `markitdown/` into the agent skills directory (global `~/.claude/skills/` or per-project `.claude/skills/`), **or** upload `markitdown-skill.zip` in Claude Desktop / Cowork.
4. Verify with `markitdown sample.docx | head` and a host-agent ask such as “summarize report.docx”.
5. Maintainers: run `docguard score` and `bash tests/smoke.sh` before cutting a release.

## Runtime notes

- Default conversion of **local files** does not need network after MarkItDown is installed.
- URL / YouTube conversion requires network by design.
- Scratch output for large files should use a temp path (`-o`), not committed repo files.
