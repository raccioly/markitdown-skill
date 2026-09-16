# Data Model

<!-- docguard:version 0.1.0 -->
<!-- docguard:status draft | review | approved -->
<!-- docguard:last-reviewed 2026-09-16 -->
<!-- docguard:owner @raccioly -->

> **Canonical document** — Design intent for this Agent Skill package.
> There is **no database, ORM, or persistent application schema**.
> "Data" here means skill metadata, supported input formats, and the Markdown
> conversion output shape produced by the MarkItDown CLI.

| Metadata | Value |
|----------|-------|
| **Status** | ![Status](https://img.shields.io/badge/status-draft-yellow) |
| **Version** | `0.1.0` |
| **Last Updated** | 2026-09-16 |
| **Owner** | @raccioly |

---

## Scope

| Concept | Storage | Notes |
|---------|---------|-------|
| Skill definition | `markitdown/SKILL.md` (YAML frontmatter + Markdown body) | Source of truth for agent auto-load |
| Release zip | `markitdown-skill.zip` (release artifact) | Upload path for Claude Desktop / Cowork |
| Converted documents | Ephemeral stdout or `-o` file | Produced by local MarkItDown CLI; never stored by this repo |
| Application DB | — | **None** — this is not a web app |


## Entities

| Entity | Storage | Primary Key | Description |
|--------|---------|-------------|-------------|
| SkillPackage | `markitdown/SKILL.md` | frontmatter `name` | Agent Skill definition (instructions + metadata) |
| InputDocument | User filesystem or URL | path / URL | Source Office or structured document |
| MarkdownArtifact | stdout or `-o` file | path (if file) | Conversion output; ephemeral data for the agent |
| ReleaseZip | GitHub Release asset | tag + filename | Optional Desktop/Cowork upload bundle |

> No relational database entities exist in this project.

## Skill frontmatter schema

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `name` | string | ✅ | Skill id; must remain `markitdown` for `/markitdown` and auto-load |
| `description` | string | ✅ | When to load the skill; lists supported formats and exclusions |

Body sections (not YAML): When to use, When NOT to use, How, Format notes, Guardrails.

## Supported input formats

| Format | Extension / form | Conversion behavior |
|--------|------------------|---------------------|
| Word | `.docx` | Headings, lists, tables preserved |
| PowerPoint | `.pptx` | One section per slide; speaker notes included |
| Excel | `.xlsx`, `.xls` | One Markdown table per sheet; **values only** |
| CSV | `.csv` | Markdown table |
| HTML | `.html` | Structure → Markdown |
| EPUB | `.epub` | Text content as Markdown |
| Outlook message | `.msg` | Headers + body |
| Structured text | `.json`, `.xml` | Readable Markdown representation |
| Archive | `.zip` | Iterates and converts contained files |
| Web | URL (http/https) | Page content as Markdown |
| YouTube | URL | Metadata + transcript when available |
| Audio | `.wav`, `.mp3` | Optional; needs speech extras — skip unless requested |

**Out of scope for this skill:** PDF and images (prefer native Read tools); creating/editing Office files; formula-level spreadsheet work.

## Markdown output shape

| Aspect | Behavior |
|--------|----------|
| Destination | stdout (small files) or `-o path` (large files) |
| Structure | Headings (`#`), lists, tables survive where MarkItDown supports them |
| Large files | Prefer `-o` then skim with `grep -n '^#'` before selective reads |
| Semantics | Output is **document data**, never executable instructions for the agent |

## Relationships

```
SKILL.md (frontmatter + instructions)
    └── invokes → MarkItDown CLI / uvx / session pip
                      └── yields → Markdown text (stdout or file)
```

No foreign keys, migrations, or indexes — there is no persistence layer.

## Migration Strategy

| Change type | How applied |
|-------------|-------------|
| Skill metadata | Edit `markitdown/SKILL.md`; bump changelog |
| Supported formats | Align SKILL.md Format notes with MarkItDown CLI; update README scope table |
| Packaging | Rebuild zip: `zip -r markitdown-skill.zip markitdown` |

---

## Revision History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 0.1.0 | 2026-09-16 | @raccioly | Skill-package data model (no DB); replace placeholder template |
