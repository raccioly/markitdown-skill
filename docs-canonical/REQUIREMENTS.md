# Requirements

<!-- docguard:version 0.1.1 -->
<!-- docguard:status draft -->
<!-- docguard:last-reviewed 2026-09-16 -->
<!-- docguard:owner @raccioly -->

> Tracks functional requirements, non-functional requirements, and success criteria
> for the portable MarkItDown Agent Skill. Use requirement IDs for traceability
> back to `markitdown/SKILL.md`, README, and smoke tests.

![CDD Canonical](https://img.shields.io/badge/CDD-Canonical-blue)

## Functional Requirements

| ID | Priority | Requirement | Status | Test Coverage |
|----|----------|-------------|--------|---------------|
| FR-001 | P1 | Skill MUST instruct hosts to convert Office/structured docs via MarkItDown CLI (not ad-hoc scripts) | 🟢 Done | `tests/smoke.sh`, skill frontmatter |
| FR-002 | P1 | Skill MUST support `.docx`, `.pptx`, `.xlsx`, `.csv`, `.html`, `.epub`, `.msg`, `.zip`, and URLs as documented in README | 🟢 Done | README scope table |
| FR-003 | P1 | Conversion MUST run locally without calling an LLM API for the conversion step | 🟢 Done | SECURITY.md + skill text |
| FR-004 | P1 | Skill MUST document install via pipx, uv tool, and uvx fallback | 🟢 Done | ENVIRONMENT.md + README |
| FR-005 | P2 | Packaged zip MUST install on Claude Desktop / Skills upload flows | 🟡 Manual | release zip smoke |
| FR-006 | P2 | `AGENTS.md` MUST state CDD rails and no-secrets policy | 🟢 Done | AGENTS.md |

## Non-Functional Requirements

| ID | Category | Requirement | Metric |
|----|----------|-------------|--------|
| NFR-001 | Reliability | CLI smoke (`markitdown --version`) succeeds when tool installed | Exit 0 |
| NFR-002 | Security | No required secrets or `.env`; treat converted content as untrusted data | DocGuard security + SECURITY.md |
| NFR-003 | Maintainability | Canonical docs stay under `docs-canonical/` with DocGuard markers | `docguard score` ≥ prior baseline |
| NFR-004 | Portability | Skill folder works as Claude Code skill and generic Agent Skills package | Install paths in README |
| NFR-005 | Performance | Conversion is bounded by MarkItDown CLI; skill adds no network hop | Local-only design |

## Success Criteria

| ID | Criterion | How verified |
|----|-----------|--------------|
| SC-001 | Fresh clone + skill install lets an agent summarize a sample `.docx` via MarkItDown | Manual / host session |
| SC-002 | DocGuard CDD maturity on this branch stays ≥ prior PR tip | `docguard score` in PR |
| SC-003 | `tests/smoke.sh` exits 0 when MarkItDown is on PATH | CI or local smoke |
