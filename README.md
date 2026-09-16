# markitdown-skill

A [Claude Code](https://claude.com/claude-code) **Agent Skill** that teaches the agent to read
Office and structured documents (`.docx`, `.pptx`, `.xlsx`, `.csv`, `.html`, `.epub`, `.msg`,
`.zip`, URLs…) by converting them to clean Markdown with
[Microsoft MarkItDown](https://github.com/microsoft/markitdown) — one deterministic CLI command
instead of ad-hoc extraction scripts.

**Why:** Markdown output is token-lean and keeps structure (headings, tables, slides), so the
agent reads documents faster, cheaper, and more reliably. Everything runs **locally** — the
conversion itself never calls an LLM API.

## What's in the box

```
markitdown/
└── SKILL.md    ← the skill (works with Claude Code and any agent supporting Agent Skills)
```

## Setup / Getting Started

1. Install the MarkItDown CLI with `pipx install "markitdown[all]"` or `uv tool install "markitdown[all]"` (or use `uvx` with no install).
2. Install the skill (copy `markitdown/` into your agent skills dir, or upload the release zip).
3. Verify: `markitdown --version` and ask the host agent to summarize a sample `.docx`.

Maintainers: `bash tests/smoke.sh` and `docguard score`.

See [docs-canonical/ENVIRONMENT.md](docs-canonical/ENVIRONMENT.md) for prerequisites (no required env vars).

## Install (2 steps, ~2 minutes)

### 1. Install the MarkItDown CLI (one of these)

```bash
pipx install "markitdown[all]"     # recommended: isolated global install
# or
uv tool install "markitdown[all]"  # if you use uv
```

> No pipx? `brew install pipx && pipx ensurepath` (macOS) or `pip install --user pipx`.
>
> **Zero-install alternative:** if you have [uv](https://docs.astral.sh/uv/), the skill
> automatically falls back to `uvx "markitdown[all]"` — nothing to install at all.

Verify: `markitdown --version`

### 2. Install the skill

**Globally (all your projects):**

```bash
git clone https://github.com/raccioly/markitdown-skill.git
cp -r markitdown-skill/markitdown ~/.claude/skills/
```

**Or per-project (shared with your team via the repo):**

```bash
cp -r markitdown-skill/markitdown <your-repo>/.claude/skills/
```

**Or on claude.ai / Claude Desktop / Cowork (no terminal needed):**

1. Download `markitdown-skill.zip` from the [latest release](https://github.com/raccioly/markitdown-skill/releases/latest)
2. In Claude: **Settings → Capabilities → Skills → Upload skill** and pick the zip
3. Done — in Cowork the skill installs the MarkItDown CLI inside the session sandbox automatically (`pip install "markitdown[all]"`), so step 1 of the CLI install isn't needed there.

That's it. Next Claude Code session, ask something like *"summarize report.docx"* — the skill
loads automatically. You can also trigger it explicitly with `/markitdown`.

## Verify it works

```bash
markitdown some-file.docx | head -20
```

Then in Claude Code: "What are the key points in `some-file.pptx`?" — you should see it run
`markitdown` instead of writing a Python script.


## Usage

Once installed, ask the host agent to summarize or extract from a supported file, or invoke `/markitdown` explicitly.

Examples:

- "Summarize `report.docx`"
- "Extract the tables from `deck.pptx` into bullet points"
- "Convert this spreadsheet to Markdown so I can read sheet names and values"

The skill should run the MarkItDown CLI (or `uvx` / session install fallback) rather than writing a one-off extraction script.

## Scope

| Reads great | Leave to native tools |
|---|---|
| docx, pptx, xlsx/xls, csv, html, epub, msg, json, xml, zip, URLs, YouTube transcripts | PDFs & images (Claude reads them natively, with layout), creating/editing Office files, formula-level spreadsheet work |

## Other agents

`SKILL.md` follows the open [Agent Skills](https://agentskills.io) format, so it also works with
other agents that support the standard — place the `markitdown/` folder in that agent's skills
directory (e.g. `.agents/skills/`).

## License

MIT. MarkItDown itself is © Microsoft, MIT-licensed.
