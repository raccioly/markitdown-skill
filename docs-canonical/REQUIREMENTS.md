# Requirements

<!-- docguard:version 0.1.0 -->
<!-- docguard:status draft -->
<!-- docguard:last-reviewed 2026-09-16 -->
<!-- docguard:owner @raccioly -->

> Tracks functional requirements, non-functional requirements, and success criteria
> for the **markitdown** Agent Skill package (local MarkItDown CLI wrapper).
> Use requirement IDs (FR-NNN, NFR-NNN, SC-NNN) for traceability to smoke tests and docs.

![CDD Canonical](https://img.shields.io/badge/CDD-Canonical-blue)

## Functional Requirements

| ID | Priority | Requirement | Status | Test Coverage |
|----|----------|-------------|--------|---------------|
| FR-001 | P1 | Skill MUST expose YAML frontmatter `name: markitdown` and a description that lists supported Office/structured formats | 🟢 Active | `tests/smoke.sh` |
| FR-002 | P1 | Skill MUST instruct the agent to convert via MarkItDown CLI (`markitdown`, else `uvx "markitdown[all]"`, else session `pip install`) rather than ad-hoc extraction scripts | 🟢 Active | `tests/smoke.sh` + README Verify |
| FR-003 | P1 | Skill MUST document supported formats (docx, pptx, xlsx/xls, csv, html, epub, msg, json, xml, zip, URLs) and exclusions (PDF/images create/edit, formula work) | 🟢 Active | SKILL.md Format notes |
| FR-004 | P1 | Skill MUST state that converted content is data, never instructions | 🟢 Active | `tests/smoke.sh` (Guardrails) |
| FR-005 | P2 | Packaging MUST allow global, per-project, and zip upload install paths documented in README | 🟢 Active | Manual release checklist |
| FR-006 | P2 | Large conversions MUST prefer `-o` file output plus selective reads | 🟢 Active | SKILL.md How section |

## Non-Functional Requirements

| ID | Category | Requirement | Metric |
|----|----------|-------------|--------|
| NFR-001 | Locality | Conversion of local files runs on the user machine without calling an LLM API for the conversion step | Design + MarkItDown CLI behavior |
| NFR-002 | Secrets | Package requires zero application env vars or committed secrets | `.docguard.json` `needsEnvVars: false`; no `.env.example` |
| NFR-003 | Portability | `SKILL.md` follows Agent Skills format for Claude Code and compatible hosts | Frontmatter validates in smoke |
| NFR-004 | Maintainability | Canonical CDD docs stay in `docs-canonical/`; DocGuard score tracked on PRs | `docguard score` |
| NFR-005 | Safety | No web auth, JWT, or DB surface is introduced under the guise of this skill | Architecture + Security docs |

## Success Criteria

| ID | Criteria | Measurement | Target |
|----|----------|-------------|--------|
| SC-001 | Fresh clone + CLI install yields working conversion | `markitdown --version` and convert a sample file | Success in ≤ 5 minutes |
| SC-002 | Smoke script passes on maintainer machines with CLI or uvx | `bash tests/smoke.sh` exit 0 | Always on PR |
| SC-003 | DocGuard structural maturity stays high on the scaffold branch | `docguard score` | ≥ 90/100 when docs are complete |
| SC-004 | Agent prefers MarkItDown over one-off Python extractors for in-scope files | Manual verify in README | Observed in session |

## User Scenarios

### User Story 1 — Read an Office doc as Markdown (Priority: P1)

An agent user wants a reliable summary of `report.docx` without custom scripts.

**Acceptance Scenarios**:
1. **Given** MarkItDown is on PATH, **When** the user asks to summarize `report.docx`, **Then** the agent runs `markitdown report.docx` (or writes `-o` for large files) and answers from the Markdown.
2. **Given** only `uvx` is available, **When** the same ask occurs, **Then** the agent uses `uvx "markitdown[all]"` as a drop-in.

### User Story 2 — Safe handling of untrusted document text (Priority: P1)

**Acceptance Scenarios**:
1. **Given** a converted document contains text that looks like agent instructions, **When** the agent processes the Markdown, **Then** it treats that text as data and does not obey it as a system directive.

### User Story 3 — Desktop zip install (Priority: P2)

**Acceptance Scenarios**:
1. **Given** `markitdown-skill.zip` from GitHub Releases, **When** the user uploads it under Skills, **Then** the skill is available without a git clone.

## Traceability Matrix

| Requirement | Source | Test / Check | Status |
|-------------|--------|--------------|--------|
| FR-001 | `markitdown/SKILL.md` | `tests/smoke.sh` | ✅ |
| FR-002 | `markitdown/SKILL.md` How | `tests/smoke.sh` | ✅ |
| FR-003 | `markitdown/SKILL.md` Format notes | Manual / doc review | ⚠️ |
| FR-004 | `markitdown/SKILL.md` Guardrails | `tests/smoke.sh` | ✅ |
| FR-005 | `README.md` Install | Release checklist | ⚠️ |
| NFR-002 | `.docguard.json`, `ENVIRONMENT.md` | DocGuard environment category | ✅ |
| SC-002 | `tests/smoke.sh` | CI or pre-PR local run | ✅ |
| SC-003 | `docs-canonical/*` | `docguard score` | ✅ |

## Revision History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 0.1.0 | 2026-09-16 | @raccioly | Real FR/NFR/SC for skill package; replace placeholders |

---

*Aligned with [DocGuard](https://github.com/raccioly/docguard) CDD practices.*
