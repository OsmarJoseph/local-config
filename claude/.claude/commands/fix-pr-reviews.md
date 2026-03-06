Review and fix unresolved CodeRabbit comments on a GitHub PR.

## Input

The user will provide a GitHub PR URL. Extract the owner, repo, and PR number from it.

## Steps

### 1. Fetch unresolved review threads

Use the GitHub GraphQL API to get all unresolved review threads:

```
gh api graphql -f query='
query {
  repository(owner: "<owner>", name: "<repo>") {
    pullRequest(number: <number>) {
      reviewThreads(first: 50) {
        nodes {
          isResolved
          id
          comments(first: 3) {
            nodes {
              path
              body
              author { login }
            }
          }
        }
      }
    }
  }
}'
```

Filter to only `isResolved == false` threads.

### 2. Present the list

Show the user a numbered table of all unresolved comments with:

- File path
- Issue title (the bold `**...**` line from the comment body)
- Severity (extract from the comment: Critical/Major/Minor)

Skip threads that are just human replies (no code suggestion) or that require manual steps outside of code changes (e.g., "run a build command").

### 3. Ask for authorization

Ask the user which items they want to fix. Options:

- "all" to fix everything
- Specific numbers (e.g., "1, 3, 5")
  - if given the number, show the user the message from CodeRabbit and the proposed fix.
- "skip" to skip

**Do NOT start fixing anything until the user explicitly authorizes which items to fix.**

### 4. Fix each authorized item

For each authorized item:

1. Read the file mentioned in the comment
2. Understand the suggested fix from the CodeRabbit comment body
3. Tell the user if CodeRabbit suggestion or report doesn't make sense, reason about it.
4. Apply the fix if it makes sense, otherwise prompt the user with a different fix.
5. Briefly tell the user what you changed, if you did.

### 5. Verify

Run type-checking to make sure nothing is broken:

```
npx tsc --noEmit --pretty
```

### 6. Commit and resolve

After all fixes are applied and verified, ask the user once whether they want to:

- Commit the changes (following the repo's commit conventions)
- Mark the fixed threads as resolved on GitHub

If authorized, do both. Resolve threads using the thread IDs collected in step 1:

```
gh api graphql -f query='mutation { resolveReviewThread(input: { threadId: "<threadId>" }) { thread { isResolved } } }'
```

$ARGUMENTS
