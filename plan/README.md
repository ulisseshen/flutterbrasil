# Translation Plan - 10 Sections

This directory contains 10 section prompts for translating the remaining Flutter Brasil documentation files that don't have `ia-translate: true`.

## Overview

- **Total files to translate:** 347
- **Total lines:** 213,741
- **Target lines per section:** ~21,374
- **Agent:** @.claude/agents/translate-pt-br

## Section Distribution

| Section | Files | Lines | % of Total | Notes |
|---------|-------|-------|------------|-------|
| [Section 01](section-01.md) | 1 | 29,353 | 13.7% | Large release note (2.0.0) |
| [Section 02](section-02.md) | 1 | 22,209 | 10.4% | Large release note (2.5.0) |
| [Section 03](section-03.md) | 17 | 20,273 | 9.5% | Release notes, breaking changes, docs |
| [Section 04](section-04.md) | 35 | 20,273 | 9.5% | Breaking changes, install docs |
| [Section 05](section-05.md) | 47 | 20,273 | 9.5% | Release notes, platform integration |
| [Section 06](section-06.md) | 47 | 20,272 | 9.5% | Release notes, toolkit docs |
| [Section 07](section-07.md) | 47 | 20,272 | 9.5% | Breaking changes, cookbook |
| [Section 08](section-08.md) | 49 | 20,272 | 9.5% | Changelogs, FAQs, deprecations |
| [Section 09](section-09.md) | 51 | 20,272 | 9.5% | Platform integration, accessibility |
| [Section 10](section-10.md) | 52 | 20,272 | 9.5% | Internationalization, navigation |

## How to Use

Each section file contains:
1. Agent reference (@.claude/agents/translate-pt-br)
2. Overview statistics
3. Complete list of files to translate
4. Step-by-step instructions
5. Context-specific notes

### Workflow

For each section:

1. Open the section file (e.g., `section-01.md`)
2. Follow the agent reference and instructions
3. Translate all files in that section
4. Commit files individually as you complete them
5. Push regularly (every 5-10 files recommended)
6. Move to the next section

### Parallel Processing

These sections can be processed in parallel if you have multiple agents or sessions working on the translation.

### Priority Recommendations

If you want to prioritize user-facing content:

**High Priority:**
- Section 04: Install documentation
- Section 05: Platform integration, accessibility
- Section 09: Accessibility, contribute docs
- Section 10: Internationalization, navigation

**Medium Priority:**
- Section 03: Breaking changes, learning resources
- Section 06: Toolkits, reference docs
- Section 07: Cookbook examples

**Lower Priority (but important):**
- Section 01-02: Large historical release notes
- Section 08: Old changelogs
- Section 09: Deprecated version changelogs

## Translation Agent

All sections reference the translation agent located at:
`.claude/agents/translate-pt-br.md`

This agent ensures:
- Adding `ia-translate: true` metadata
- Preserving all links and code blocks
- Keeping technical terms in English
- Natural PT-BR translations
- Mandatory link validation before committing

## Progress Tracking

You can mark sections as complete by updating this README or creating a separate tracking file.

---

**Created:** 2025-11-10
**Purpose:** Organize translation work for 347 remaining markdown files
**Method:** Balanced by line count (not file count) for equal workload distribution
