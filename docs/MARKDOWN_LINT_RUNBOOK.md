# Markdown Lint Runbook

**Purpose:** Provide reusable markdown linting scripts and guidance for cross-repo adoption.

---

## Installation

### Option A: Use npx (no install)

This option is simplest for one-off runs and CI where you do not want to add dependencies.

```bash
npx markdownlint-cli2 "**/*.md" "!node_modules" "!**/node_modules"
```

### Option B: Install locally (recommended for repeat usage)

```bash
npm install --save-dev markdownlint-cli2
```

Then run:

```bash
npx markdownlint-cli2 "**/*.md" "!node_modules" "!**/node_modules"
```

---

## Running Checks (Local Repo)

From the repo root:

```bash
bash scripts/markdownlint-check.sh .
```

You can also pass a specific path:

```bash
bash scripts/markdownlint-check.sh /path/to/repo
```

---

## Auto-Fixing Errors

Auto-fix where possible:

```bash
bash scripts/markdownlint-fix.sh .
```

Dry-run check (no writes):

```bash
bash scripts/markdownlint-fix.sh . --check
```

---

## Common Rules

- **MD022:** Headings should be surrounded by blank lines. Add a blank line before and after headers.
- **MD031:** Fenced code blocks should be surrounded by blank lines. Add blank lines before/after code blocks.
- **MD032:** Lists should be surrounded by blank lines. Add a blank line before and after list blocks.
- **MD058:** Tables should be surrounded by blank lines. Add a blank line before/after tables.

---

## IDE Integration

Add a `.markdownlint.json` and optional `.markdownlintignore` at the repo root. Example config is in:

- [templates/markdown/.markdownlint.json](../templates/markdown/.markdownlint.json)
- [templates/markdown/.markdownlintignore](../templates/markdown/.markdownlintignore)

Most IDEs (VS Code, JetBrains) will automatically pick up these files once a markdownlint extension is installed.

---

## Cross-Repo Workflow

1. Copy the templates from [templates/markdown/](../templates/markdown/) into the target repo root.
1. Copy the scripts from [scripts/](../scripts/) into the target repo `scripts/` folder.
1. Make scripts executable:

```bash
chmod +x scripts/markdownlint-check.sh scripts/markdownlint-fix.sh
```

1. Run checks:

```bash
bash scripts/markdownlint-check.sh .
```

---

## CI/CD Integration Guidance

### GitHub Actions (example)

```yaml
name: markdownlint
on:
  pull_request:
  push:
    branches:
      - main
jobs:
  markdownlint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Lint markdown
        run: npx markdownlint-cli2 "**/*.md" "!node_modules" "!**/node_modules"
```

### CI Tips

- Use `--fix` only in local scripts. Keep CI in check-only mode.
- Add `.markdownlintignore` to exclude generated files.
- Fail fast on lint errors to keep PRs consistent.

---

## Troubleshooting

- **Command not found:** Use `npx` or install `markdownlint-cli2`.
- **Unexpected file matches:** Verify glob patterns and `.markdownlintignore`.
- **CI fails but local passes:** Ensure CI uses the same config and ignores.
