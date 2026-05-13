---
ame: obsidian-memory
description: Persistent memory system backed by an Obsidian vault. Use for managing work and personal tasks, loading session context, updating progress, generating status updates, and listing tasks by priority. Commands - work start, work update, work list, work status, personal start, personal update, personal list.
argument-hint: <work|personal> <start|update|list|status>
allowed-tools: Bash(find *) Bash(ls *) Read Edit Write Glob Grep
---

# Obsidian Memory

Persistent memory backed by the Obsidian vault at `~/dev/obsidian`. All paths below are relative to the vault root.

Run the command matching `$ARGUMENTS`. If no arguments given, ask the user which command to run.

## Vault Structure

```
./
├── Home.md                      # Dashboard
├── Work/
│   ├── NVIDIA Home.md           # Work hub
│   ├── Status Updates.md        # Status update history (latest on top)
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

### `work start`

1. List all work tasks from `./Work/Tasks/`:
   ```bash
   ls -d ./Work/Tasks
   ```
2. Show each task name, try to figure out from pwd  which task and suggest that first (option 0), others will be numbered 1 and more.
3. Ask the user which task they want to work on this session.
4. Once selected, read the full task file inside the folder.
5. Read any `[[wikilinked]]` notes referenced in the task for full context.
6. Summarize the current state: goal, open tasks, blockers, and recent notes.
7. Remember the active task for this session (use it in `work update`).

### `work update`

1. Confirm which task is active (from `work start`, or ask).
2. Summarize what was accomplished this session by reviewing the conversation.
3. Update the task markdown file:
   - Check off completed `- [ ]` items -> `- [x]`.
   - Add new findings, decisions, or notes to the `## Notes` section.
   - Add new sub-tasks if work revealed them.
   - Update `status` in frontmatter if appropriate.
4. If new concepts, people, or knowledge emerged, create or update linked notes in the appropriate vault folders (`Concepts/`, `Knowledge Base/`, `People/`, etc.) — use `[[wikilinks]]` from the task instead of duplicating content.
5. Show a diff summary of all changes before writing.

### `work list`

1. Scan all work task files in `./Work/Tasks/`.
2. Extract `priority` and `status` from each file's frontmatter.
3. Display tasks sorted by priority (high -> medium -> low), showing:
   - Task name
   - Priority
   - Status
   - One-line goal (from `## Goal`)
4. Suggest which task to start based on priority and status.

### `work status`

Generate a manager-ready (Omer) status update table by comparing current task state against the last status update stored in the vault.

1. Read the latest status update from `./Work/Status Updates.md`.
2. Scan all work task folders in `./Work/Tasks/`.
3. For each task, extract `priority`, `status`, and open sub-tasks from `## Sub Tasks`.
4. Compare current state against the previous status update to determine what changed.
5. Present a table sorted by priority (high -> medium -> low) with columns:
   - **Task** — task name
   - **Priority** — High, Medium, Low
   - **Progress (since last update)** — what changed since the previous status update. If nothing changed, say "No progress".
   - **Next Sub-tasks** — the immediate open sub-tasks the user will focus on. Keep concise — use the user's own wording when they override defaults.
6. Include all tasks, even those with no progress.
7. If the user provides corrections to sub-tasks or progress wording, update the actual task files in the vault to match (edit `## Sub Tasks`, `last-updated` frontmatter).
8. When the user confirms the final status update, override latest update in `Status Updates.md` with the finalized table.

### `personal start`

1. Read `./Personal/Tasks/Personal Tasks.md`.
2. Parse priority sections (`High Priority`, `Medium Priority`, `Low Priority`).
3. List all open tasks with their priority.
4. Ask which task or area the user wants to focus on.
5. Load related notes via wikilinks for context.
6. Summarize current state.

### `personal update`

1. Confirm which personal task or area is active.
2. Update `./Personal/Tasks/Personal Tasks.md`:
   - Check off completed items.
   - Add new items to the appropriate priority section.
   - Move completed items to `## Completed` with date.
3. If relevant, update linked notes (`Goals.md`, `Finance/`, `Health/`, etc.) — link don't duplicate.
4. Show a diff summary before writing.

### `personal list`

1. Read `./Personal/Tasks/Personal Tasks.md`.
2. Display open tasks grouped by priority (High -> Medium -> Low).
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

People referenced in tasks should have notes in `./Work/People/`.

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

  ## Context

  - <Role or reason they're referenced>
  - Involved in [[<task name>]] — <brief context>

  ## Related

  - [[Organization]]
  - [[<task name>]]
  ```
- When updating tasks, if new context about a person emerges (new role, new task involvement), update their people file.
- Use `[[Full Name]]` wikilinks in task files to reference people, with an alias for first-name lookup.
- The `Organization.md` file contains the team org chart — reference it but don't duplicate its content in people files.

### Writing Style

- Write everything in a plain, human way — like you'd write to a colleague, not a press release.
- Avoid weird/unicode characters. Use plain ASCII equivalents:
  - `x` instead of `×` (e.g., "15 runs x 3 cases", not "15 runs × 3 cases")
  - `,` instead of `·` (e.g., "Run tests, decide, ship", not "Run tests · decide · ship")
  - `-` instead of `—` or `–` where a regular dash works
  - Plain quotes `"` `'` instead of curly `"` `'` `'`
- This applies to status update tables, task notes, and anything else written into the vault or shown to the user.

### Memory Principles

1. **Link, don't duplicate** — if information exists in another note, use `[[wikilinks]]` to reference it. Never repeat content that lives elsewhere.
2. **Preserve structure** — maintain the existing folder hierarchy and note conventions (headers, section patterns, frontmatter schema).
3. **Atomic updates** — change only what changed. Don't rewrite entire files when updating a single checkbox.
4. **Backlinks matter** — when creating a new note, add a `## Related` section linking back to parent/sibling notes so Obsidian's graph view stays connected.
5. **Frontmatter is queryable** — always keep `tags`, `status`, and `priority` accurate. Dataview queries and Obsidian search depend on them.
6. **Date everything** — when adding notes or completing tasks, include the date (e.g., `~~2026-04-12~~` for completions, or a `last-updated` property).
7. **Inbox for unknowns** — if something doesn't fit an existing folder, put it in `Inbox/` and link from the relevant task.
