---
name: memory
description: Persistent memory system backed by an Obsidian vault, accessed via the Obsidian CLI. Use for managing tasks, loading session context, updating progress, generating status / weekly updates, and listing tasks by priority. Commands - start, update, list, status, weekly.
argument-hint: <start|update|list|status|weekly>
allowed-tools: Bash(obsidian *) Bash(find *) Bash(ls *) Read Edit Write Glob Grep
---

# Memory

Persistent memory backed by an Obsidian vault, accessed entirely through the `obsidian` CLI (requires Obsidian to be running).

Run the command matching `$ARGUMENTS`. If no arguments given, ask the user which command to run.

## Discover before acting

Do not assume any folder names, file names, tag conventions, or frontmatter schema. Discover the vault's actual shape at the start of every command, then act on what's there.

Use the CLI to learn what exists:

- `obsidian help` lists every command; `obsidian help <command>` shows that command's options. This is authoritative and always current — consult it whenever you need a capability.
- `obsidian vault` shows the active vault.
- `obsidian folders` and `obsidian files` enumerate the layout.
- `obsidian tags counts`, `obsidian properties`, `obsidian tasks todo` reveal conventions (tag names, frontmatter keys, where open checkboxes live).
- `obsidian search:context query="..."` finds anything by content.

From those, infer:

- Where projects/tasks live (a folder, a tag, or just `obsidian tasks`).
- What frontmatter keys carry priority/status/dates.
- Whether there is a hub note, a status-updates note, a people folder, etc.

If discovery is ambiguous, ask the user once and proceed. Don't fabricate structure.

## Commands

Each command describes the goal. Translate it into the right CLI calls based on what discovery reveals — use `obsidian help` to find any command you need.

### `start`

Load the user into a task session.

**Do not read any task's body before the user confirms the choice.** Reading every task's full content pollutes context with irrelevant material. Use frontmatter-only / metadata-only CLI calls for the candidate list (e.g. property reads, tag/folder listings) — never a full file read.

1. Discover where tasks live.
2. List candidates by name only, with priority/status pulled via metadata-only calls if available. Suggest the most relevant one first (try to infer from `pwd`).
3. Ask the user which task to work on. **Stop and wait for their answer.**
4. Only after the user confirms: read the chosen task's body, plus any notes it wikilinks to that look relevant.
5. Summarize current state: goal, open sub-tasks, blockers, recent notes.
6. Remember the active task for the session (use it in `update`).

### `update`

Persist the session's work into the active task.

1. Confirm the active task (from `start`, or ask).
2. Summarize what was accomplished by reviewing the conversation.
3. Update the task file:
   - Mark completed checkboxes done.
   - Add new findings, decisions, and notes to the appropriate section.
   - Add newly revealed sub-tasks.
   - Update frontmatter (status, last-updated, etc.) when warranted.
4. If new concepts, people, or knowledge emerged, create or update linked notes and reference them via `[[wikilinks]]`. Ask the user where new notes should live if the destination isn't obvious. Don't duplicate content — link.
5. Show a diff summary before writing.

### `list`

Show open work, prioritized.

1. Discover tasks.
2. Read their priority, status, and one-line goal.
3. Display sorted by priority (high -> medium -> low) with task name, priority, status, goal.
4. Suggest which task to start.

### `status`

Generate a manager-ready (Omer) status update. Cadence: twice weekly.

Run the [periodic update flow](#periodic-update-flow) with target note = the vault's status note (e.g. `updates/status`).

### `weekly`

Generate a manager-ready weekly progress update. Cadence: weekly. Covers a longer window than `status` and is sent less often.

Run the [periodic update flow](#periodic-update-flow) with target note = the vault's weekly note (e.g. `updates/weekly`).

### Periodic update flow

Shared procedure for `status` and `weekly`. The only difference between them is which note the result is prepended to.

1. Find or ask for the target note (discover via `obsidian search` / `obsidian files folder=updates`; don't hardcode the path).
2. Read the latest entry there.
3. Discover the task set; for each, extract priority, status, and open sub-tasks.
4. Compare current state against the previous entry to identify what changed.
5. Present a table sorted by priority (high -> medium -> low) with columns:
   - **Task** — task name
   - **Priority** — High, Medium, Low
   - **Progress (since last update)** — what changed; "No progress" if nothing.
   - **Next Sub-tasks** — immediate open sub-tasks. Concise. Use the user's wording when they override.
6. Include all tasks, even those with no progress.
7. If the user corrects sub-tasks or wording, write the corrections back to the task files and update `last-updated`.
8. On confirmation, prepend the finalized table to the target note so the latest is on top.

## Guidelines

### Obsidian flavored markdown

- Use `[[wikilinks]]` for internal links; `[text](url)` only for external URLs.
- Use `![[embed]]` to embed instead of copy-pasting.
- Add frontmatter (`tags`, `status`, `priority`, `aliases`) when creating notes that will be queried.
- Use callouts (`> [!type]`) for important notices.
- Use `==highlights==` for emphasis in reading view.
- Use `%%hidden comments%%` for agent-only metadata if needed.

### Writing style

- Write plainly, like to a colleague, not a press release.
- Avoid unicode. Use plain ASCII equivalents:
  - `x` instead of `×` (e.g., "15 runs x 3 cases")
  - `,` instead of `·`
  - `-` instead of `—` or `–`
  - Plain quotes `"` `'` instead of curly ones

### Memory principles

1. **Discover, don't assume** — `obsidian help` and the discovery commands above are the source of truth. Run them before acting.
2. **Link, don't duplicate** — if information exists in another note, `[[wikilink]]` it.
3. **Preserve structure** — once the user has a convention, follow it consistently.
4. **Atomic updates** — change only what changed. Prefer surgical edits (toggle a checkbox, set one property) over rewriting whole files.
5. **Backlinks matter** — when creating a note, add a `## Related` section linking parent/sibling notes so the graph stays connected.
6. **Frontmatter is queryable** — keep `tags`, `status`, `priority` accurate when they exist.
7. **Date everything** — when adding notes or completing tasks, include the date.

## CLI essentials

The CLI talks to the running Obsidian app and targets the most-recently-focused vault by default; pass `vault=<name>` as the first parameter to target another.

- **Parameters** take values with `=`; quote values with spaces. **Flags** are boolean switches.
- File targeting: `file=<name>` resolves wikilink-style; `path=<path>` is exact from vault root.
- Use `\n` for newline and `\t` for tab in `content=` values.
- Useful flags on many commands: `silent` (don't open the file), `total` (return just a count), `--copy` (copy output to clipboard).

When in doubt, run `obsidian help` or `obsidian help <command>`. Don't guess flags or paths — discover them.
