Create a pull request for the Parker project.

## Steps

### 1. Gather info

Ask the user these questions **one at a time, in order**:

#### a) Base branch

Run `git branch | sed 's/^[*+] //' | sed 's/^ *//'` to list local branches. Present as numbered list. Ask user to pick one.

#### b) Linear ticket ID

Ask: "Linear ticket ID? (number only, or 'none' for PAR-000)"

If user says none/skip/empty, use `000`.

#### c) Reviewers

Present this multi-select list:

```
1. Fernando (nandokferrari)
2. Federico (Knovatum)
3. Gilan (gksvParker)
4. Daniel (presser)
5. Kelvin (kelvinwelter)
```

Ask user to pick by numbers (e.g. "1, 3, 5"). Map to GitHub usernames.

### 2. Run checks

Run from `frontend/`:

```bash
cd frontend && yarn review
```

If it fails, stop and fix issues before proceeding. Do NOT create the PR until checks pass.

### 3. Build PR content

Run `git diff <base-branch>...HEAD` and `git log <base-branch>..HEAD --oneline` to understand what changed.

**Title format:** `PAR-<ticket-id> <concise description based on diff>`

PAR prefix always comes first. Description from the diff, NOT from conversation context.

**Body:** Use this template, filled from the diff:

```
**What does this PR do?**
- <concise bullet points from diff analysis>

**Checklist**
- [x] Ran `yarn review` from `frontend/` (lint + typecheck + tests pass)
- [x] Ticket/issue linked (PAR-####) if applicable, use PAR-000 if unknown.

**Testing Instructions**
- open the preview url

**Screenshots**

```

Keep description concise. No fluff.

### 4. Create PR

```bash
gh pr create --base <base-branch> --title "<title>" --reviewer <comma-separated-usernames> --assignee @me --body "<body>"
```

Always pass `--assignee @me` so the PR is assigned to the current user.

Show the PR URL when done.
And open the PR URL.

$ARGUMENTS
