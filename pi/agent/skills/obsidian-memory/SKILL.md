---
name: obsidian-memory
description: Persistent memory system backed by an Obsidian vault. Use for managing work and personal tasks, loading session context, updating progress, generating status updates, and listing tasks by priority. Commands - work start task, work update task, work list task, work status update, personal start task, personal update task, personal list task.
---

# Obsidian Memory

Persistent memory backed by the Obsidian vault at `/Users/ysaraf/dev/obsidian`.

## Vault Structure

```
/Users/ysaraf/dev/obsidian/
├── Home.md                      # Dashboard
├── Work/
│   ├── NVIDIA Home.md           # Work hub
│   ├── Tasks/                   # Work tasks (each .md or folder)
│   │   └── Tasks Home.md
│   ├── Concepts/
│   ├── Knowledge Base/
│   ├── Meetings/
│   ├── Onboarding/
│   └── People/
├── Personal/
│   ├── Personal Home.md         # Personal hub
│   ├── Tasks/
│   │   └── Personal Tasks.md   # Personal tasks (single file, sections by priority)
│   ├── Goals.md
│   ├── Finance/
│   ├── Health/
│   ├── Hobbies/
│   └── Relationships/
├── Daily Notes/
├── Templates/
├── Inbox/
└── Archive/
```

## Commands

### `work start task`

1. List all work tasks from `/Users/ysaraf/dev/obsidian/Work/Tasks/`:
   ```bash
   find "/Users/ysaraf/dev/obsidian/Work/Tasks" -name "*.md" ! -name "Tasks Home.md" -maxdepth 1 | sort
   ```
2. Show each task name, its `status` and `priority` from frontmatter.
3. Ask the user which task they want to work on this session.
4. Once selected, read the full task file (and any subfolder contents if the task has a directory).
5. Read any `[[wikilinked]]` notes referenced in the task for full context.
6. Summarize the current state: goal, open tasks, blockers, and recent notes.
7. Remember the active task for this session (use it in `work update task`).

### `work update task`

1. Confirm which task is active (from `work start task`, or ask).
2. Summarize what was accomplished this session by reviewing the conversation.
3. Update the task markdown file:
   - Check off completed `- [ ]` items → `- [x]`.
   - Add new findings, decisions, or notes to the `## 📝 Notes` section.
   - Add new sub-tasks if work revealed them.
   - Update `status` in frontmatter if appropriate.
4. If new concepts, people, or knowledge emerged, create or update linked notes in the appropriate vault folders (`Concepts/`, `Knowledge Base/`, `People/`, etc.) — use `[[wikilinks]]` from the task instead of duplicating content.
5. Show a diff summary of all changes before writing.

### `work list task`

1. Scan all work task files in `/Users/ysaraf/dev/obsidian/Work/Tasks/`.
2. Extract `priority` and `status` from each file's frontmatter.
3. Display tasks sorted by priority (high → medium → low), showing:
   - Task name
   - Priority
   - Status
   - One-line goal (from `## 🎯 Goal`)
4. Suggest which task to start based on priority and status.

### `work status update`

Generate a manager-ready status update table by comparing current task state against the user's previous status update.

**Requires:** User provides their last status update text (freeform, any format).

1. Scan all work task files in `/Users/ysaraf/dev/obsidian/Work/Tasks/`.
2. For each task, extract `priority`, `status`, and open sub-tasks from `## 📋 Sub Tasks`.
3. Compare current state against the provided previous status update to determine what changed.
4. Present a table sorted by priority (high → medium → low) with columns:
   - **Task** — task name
   - **Priority** — emoji indicator (🔴 High, 🟡 Medium, 🟢 Low)
   - **Progress (since last update)** — what changed since the previous status update, not just "last week". If nothing changed, say "No progress".
   - **Next Sub-tasks** — the immediate open sub-tasks the user will focus on. Keep concise — use the user's own wording when they override defaults.
5. Include all tasks, even those with no progress.
6. If the user provides corrections to sub-tasks or progress wording, update the actual task files in the vault to match (edit `## 📋 Sub Tasks`, `last-updated` frontmatter).
7. If new people are mentioned, check `/Users/ysaraf/dev/obsidian/Work/People/` — if no file exists for them, create one (see People Management below).

### `personal start task`

1. Read `/Users/ysaraf/dev/obsidian/Personal/Tasks/Personal Tasks.md`.
2. Parse priority sections (`🔴 High Priority`, `🟡 Medium Priority`, `🟢 Low Priority`).
3. List all open tasks with their priority.
4. Ask which task or area the user wants to focus on.
5. Load related notes via wikilinks for context.
6. Summarize current state.

### `personal update task`

1. Confirm which personal task or area is active.
2. Update `/Users/ysaraf/dev/obsidian/Personal/Tasks/Personal Tasks.md`:
   - Check off completed items.
   - Add new items to the appropriate priority section.
   - Move completed items to `## ✅ Completed` with date.
3. If relevant, update linked notes (`Goals.md`, `Finance/`, `Health/`, etc.) — link don't duplicate.
4. Show a diff summary before writing.

### `personal list task`

1. Read `/Users/ysaraf/dev/obsidian/Personal/Tasks/Personal Tasks.md`.
2. Display open tasks grouped by priority (🔴 → 🟡 → 🟢).
3. Include recurring tasks section.
4. Suggest what to tackle based on urgency.

## Guidelines

### Obsidian Flavored Markdown

See [OBSIDIAN-MARKDOWN.md](references/OBSIDIAN-MARKDOWN.md) for full syntax reference.

Key rules:
- Use `[[wikilinks]]` for all internal vault links, `[text](url)` only for external URLs.
- Use `![[embed]]` to embed content instead of copy-pasting.
- Add frontmatter properties (`tags`, `status`, `priority`, `aliases`) to every note.
- Use callouts (`> [!type]`) for important notices.
- Use `==highlights==` for emphasis in reading view.
- Use `%%hidden comments%%` for agent-only metadata if needed.

### People Management

People referenced in tasks should have notes in `/Users/ysaraf/dev/obsidian/Work/People/`.

- When a task references a person by `[[wikilink]]` or by name, check if a file exists in `Work/People/`.
- If no file exists, create one with this structure:
  ```markdown
  ---
  tags:
    - work
    - nvidia
    - people
  aliases:
    - <First Name>
  ---

  # <Full Name>

  ## 🔗 Context

  - <Role or reason they're referenced>
  - Involved in [[<task name>]] — <brief context>

  ## 🔗 Related

  - [[Organization]]
  - [[<task name>]]
  ```
- When updating tasks, if new context about a person emerges (new role, new task involvement), update their people file.
- Use `[[Full Name]]` wikilinks in task files to reference people, with an alias for first-name lookup.
- The `Organization.md` file contains the team org chart — reference it but don't duplicate its content in people files.

### Memory Principles

1. **Link, don't duplicate** — if information exists in another note, use `[[wikilinks]]` to reference it. Never repeat content that lives elsewhere.
2. **Preserve structure** — maintain the existing folder hierarchy and note conventions (emoji headers, section patterns, frontmatter schema).
3. **Atomic updates** — change only what changed. Don't rewrite entire files when updating a single checkbox.
4. **Backlinks matter** — when creating a new note, add a `## 🔗 Related` section linking back to parent/sibling notes so Obsidian's graph view stays connected.
5. **Frontmatter is queryable** — always keep `tags`, `status`, and `priority` accurate. Dataview queries and Obsidian search depend on them.
6. **Date everything** — when adding notes or completing tasks, include the date (e.g., `~~2026-04-12~~` for completions, or a `last-updated` property).
7. **Inbox for unknowns** — if something doesn't fit an existing folder, put it in `Inbox/` and link from the relevant task.
