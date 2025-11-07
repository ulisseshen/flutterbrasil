# Flutter Brasil Documentation Translation Plan

## Overview
This plan ensures systematic translation of 802 markdown files while preserving links and handling large files correctly.

## Problems to Solve

### 1. Broken Links (Previous Issue)
**Why links broke before:**
- Link references `[text][ref]` and definitions `[ref]: /url` split across chunks
- No programmatic link preservation, only AI instructions
- No validation after translation

### 2. Large Files
**Current situation:**
- 37 files >40KB (largest: 1.7MB release notes)
- Previous 20KB chunk limit caused mid-section splits
- No smart boundary detection

## Solution Architecture

### Phase 1: Pre-Translation Processing

#### A. Link Extraction & Protection
```
1. Extract ALL link patterns from file:
   - Reference definitions: [ref]: /url
   - Inline links: [text](/url)
   - Template variables: {{site.api}}/...
   - Anchor links: #section-name

2. Create link registry for the file
3. Replace with protected markers
4. Store original links separately
```

#### B. Smart Chunking Strategy
```
For files >30KB:

1. Split ONLY at major headers (## or ###)
2. Keep each section complete (don't split mid-section)
3. Include link definitions in ALL chunks that reference them
4. Max chunk: 40KB (stay under Gemini limits)
5. If section >40KB, split at #### subheaders
```

**Chunk boundaries respect:**
- Markdown headers (natural sections)
- Code blocks (never split)
- Link reference definitions (always with their usage)

### Phase 2: Translation

#### A. Prepare Each Chunk
```
1. Extract code blocks → replace with markers
2. Extract protected links → replace with markers
3. Send clean text to AI with instructions
4. Translate content only (no links, no code)
```

#### B. AI Translation Prompt
```
Context:
- This is chunk X of Y from file.md
- Technical Flutter documentation
- Target: Brazilian Portuguese (PT-BR)

Rules:
- Translate content naturally to PT-BR
- Keep technical terms in English: Widget names, API names, class names
- Keep: Flutter, Widget, State, StatelessWidget, StatefulWidget, etc.
- Preserve all {{markers}} exactly as-is
- Preserve all [CODE_BLOCK_N] markers exactly
- Preserve markdown formatting (headers, lists, tables)
- Preserve line breaks and spacing

Examples of what NOT to translate:
- Widget, Text, Container, Row, Column, Stack
- State, StatelessWidget, StatefulWidget, InheritedWidget
- build(), setState(), initState()
- pubspec.yaml, main.dart
- Flutter, Dart, Material, Cupertino
```

#### C. Post-Translation Restoration
```
1. Verify all markers present
2. Restore code blocks
3. Restore links in original form
4. Reassemble chunks in correct order
5. Validate final document structure
```

### Phase 3: Validation

#### A. Automated Checks
```
1. Link integrity check:
   - All reference-style links have definitions
   - No broken [text][ref] without [ref]: url

2. Structure validation:
   - YAML frontmatter intact with ia-translate: true
   - All code blocks closed properly
   - Headers maintain hierarchy

3. Use existing tools:
   - dart run flutter_site check-link-references
   - dart run flutter_site check-links
```

#### B. Manual Review Checklist
```
- [ ] Technical terms kept in English
- [ ] Links work correctly
- [ ] Code examples unchanged
- [ ] Natural Portuguese flow
- [ ] Consistent terminology across files
```

## Translation Workflow

### Step-by-Step Process

```
For each folder:

1. LIST all .md files
2. FILTER already translated (ia-translate: true)
3. SORT by size (small to large)
4. For each file:

   A. Pre-process:
      - Read file
      - Extract & protect links
      - Extract & protect code blocks
      - Check size → determine chunking

   B. Translate:
      - If <30KB: translate as single chunk
      - If >30KB: smart split by headers
      - For each chunk: send to AI
      - Collect translated chunks

   C. Post-process:
      - Reassemble chunks
      - Restore code blocks
      - Restore links
      - Add ia-translate: true
      - Validate structure

   D. Verify:
      - Run link checks
      - Compare file sizes (should be similar)
      - Spot check random sections

   E. Commit:
      - git add <file>
      - Descriptive commit message
      - Include file name in commit

5. After folder complete:
   - Run full link validation
   - Test site build
   - Push to branch
```

## Folder Priority

Based on user impact and importance:

### High Priority (Start Here)
1. ✅ **app-architecture/** (16 files) - ALREADY DONE
2. 🔄 **ai-toolkit/** (2 remaining files)
3. 📖 **get-started/** (42 files) - Critical for beginners
4. 🍳 **cookbook/** (87 files) - Most used by developers

### Medium Priority
5. **ui/** (61 files) - Core UI concepts
6. **data-and-backend/** (13 files) - State management
7. **testing/** (20 files) - Testing guides
8. **deployment/** (10 files) - Publishing apps

### Lower Priority (Can wait)
9. **platform-integration/** (64 files) - Platform-specific
10. **tools/** (108 files) - IDE and tooling
11. **perf/** (12 files) - Performance optimization
12. **release/** (180 files) - Release notes (very large files)

### Special Considerations
- **release/** folder: Files up to 1.7MB - requires special handling
- **_includes/docs/**: 122 shared snippets - translate after main content

## Technical Terms to Keep in English

### Flutter/Dart Core
- Widget, State, StatelessWidget, StatefulWidget, InheritedWidget
- BuildContext, BuildContext, Key, GlobalKey
- Hot reload, Hot restart
- Scaffold, AppBar, FloatingActionButton
- MaterialApp, CupertinoApp, WidgetsApp
- Theme, ThemeData, TextTheme
- Navigator, Route, MaterialPageRoute

### Development Terms
- IDE, SDK, CLI, API, REST, HTTP, JSON
- Debugging, Debug mode, Profile mode, Release mode
- Breakpoint, Stack trace
- Package, Plugin, Dependency
- Git, GitHub, Repository

### File/Project Terms
- pubspec.yaml, main.dart, lib/, test/
- Android Studio, VS Code, IntelliJ
- iOS, Android, Web, Desktop
- Gradle, CocoaPods, Xcode

### When to Translate
- UI text visible to users
- Conceptual explanations
- Instructions and steps
- Descriptions and documentation
- Common programming concepts (variable → variável, function → função)

## Implementation Details

### File Structure After Translation
```yaml
---
ia-translate: true
title: Título em Português
short-title: Título Curto
description: >
  Descrição em português do conteúdo.
---

# Título Principal em Português

Conteúdo traduzido mantendo links e código...

[Flutter documentation]: /docs/get-started
[Widget catalog]: /ui/widgets

\```dart
// Code blocks remain in English
void main() {
  runApp(MyApp());
}
\```
```

### Git Commit Strategy
```bash
# Small files (1-5): Single commit
git commit -m "translate: get-started/install.md"

# Medium batch (5-10): Group commit
git commit -m "translate: get-started - install, editor, test-drive"

# Large folder: Multiple commits by section
git commit -m "translate: cookbook/navigation/*.md (8 files)"
git commit -m "translate: cookbook/networking/*.md (12 files)"
```

## Success Metrics

### Per-File Validation
- ✅ `ia-translate: true` in frontmatter
- ✅ All links validated (no broken references)
- ✅ Code blocks intact and unchanged
- ✅ File size within 10% of original
- ✅ Markdown builds without errors

### Per-Folder Validation
- ✅ All files translated
- ✅ Site builds successfully
- ✅ Link checker passes
- ✅ No regression in existing translations

### Overall Goal
- 📊 802 files translated
- 🔗 Zero broken links
- 🚀 Site builds and deploys
- 📝 Consistent terminology across all docs

## Tools & Scripts Needed

### 1. Translation Script (new)
```dart
// Handles:
- File reading and writing
- Link extraction and restoration
- Code block protection
- Smart chunking
- AI API calls (Gemini/Claude)
- Validation
```

### 2. Link Validator (existing)
```bash
dart run flutter_site check-link-references
dart run flutter_site check-links
```

### 3. Batch Processor
```bash
# Process entire folder
./translate_folder.sh src/content/get-started/

# Process with validation
./translate_folder.sh --validate src/content/cookbook/
```

## Risk Mitigation

### What Could Go Wrong?
1. **AI mistranslates technical terms** → Use strict prompts + validation
2. **Links break during chunking** → Smart boundary detection + link registry
3. **Code blocks get translated** → Extract before translation, restore after
4. **Large files timeout** → Chunk intelligently, retry with backoff
5. **Inconsistent terminology** → Maintain glossary, review translated files

### Rollback Strategy
```bash
# Each folder on separate branch
git checkout -b translate/get-started
# ... translate ...
git push origin translate/get-started

# If issues found:
git revert <commit>
# or
git reset --hard origin/main
```

## Next Steps

1. **Choose first folder** to translate (recommendation: complete `ai-toolkit` - only 2 files)
2. **Build translation script** with proper link preservation
3. **Test on 1-2 files** and validate thoroughly
4. **Iterate and improve** based on results
5. **Scale to full folders** once process is solid

---

## Questions to Answer

1. Which folder should we start with?
2. Should we use Gemini (like before) or Claude Sonnet for translation?
3. Do you want to review translations before committing, or trust the automated validation?
4. What's your preferred batch size (files per commit)?
