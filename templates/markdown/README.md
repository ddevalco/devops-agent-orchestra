# Markdown Lint Quick Start

Use these templates to enable markdown linting in any repository.

## Install

```bash
npm install --save-dev markdownlint-cli2
```

## Add Config

Copy the following files to the repo root:

- `.markdownlint.json`
- `.markdownlintignore`

## Add Scripts

Copy the scripts into `scripts/`:

- `scripts/markdownlint-check.sh`
- `scripts/markdownlint-fix.sh`

Make them executable:

```bash
chmod +x scripts/markdownlint-check.sh scripts/markdownlint-fix.sh
```

## Run

```bash
bash scripts/markdownlint-check.sh .
```

Auto-fix (local only):

```bash
bash scripts/markdownlint-fix.sh .
```
