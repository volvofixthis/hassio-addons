# AGENTS.md

Operational guide for coding agents working in this repository.

## Repository Overview

- This repo hosts Home Assistant add-ons, not a single app/library package.
- Add-ons currently present:
  - `alertmanager/`
  - `vmalert/`
  - `prom-write/`
  - `klipper-exporter/`
- Main artifact types:
  - Bash entrypoints (`run.sh`)
  - Add-on metadata (`config.yaml`)
  - Dockerfiles
  - Alert/routing YAML files
  - Alertmanager templates (`*.tmpl`)

## Source of Truth and Rule Files

- Checked for Cursor rules: no `.cursor/rules/` and no `.cursorrules` found.
- Checked for Copilot rules: no `.github/copilot-instructions.md` found.
- If such files are added later, treat them as additional constraints and update this file.

## Build Commands

- Build Alertmanager add-on image:
  - `docker build --build-arg BUILD_FROM=ghcr.io/home-assistant/amd64-base:3.19 -t hass-addon-alertmanager ./alertmanager`
- Build VMAlert add-on image:
  - `docker build --build-arg BUILD_FROM=ghcr.io/home-assistant/amd64-base:3.19 -t hass-addon-vmalert ./vmalert`
- Build Prom-write add-on image:
  - `docker build --build-arg BUILD_FROM=ghcr.io/home-assistant/amd64-base:3.19 -t hass-addon-prom-write ./prom-write`
- Build Klipper Exporter add-on image:
  - `docker build --build-arg BUILD_FROM=ghcr.io/home-assistant/amd64-base:3.19 -t hass-addon-klipper-exporter ./klipper-exporter`
- Build all add-ons (sequential):
  - `docker build --build-arg BUILD_FROM=ghcr.io/home-assistant/amd64-base:3.19 -t hass-addon-alertmanager ./alertmanager && docker build --build-arg BUILD_FROM=ghcr.io/home-assistant/amd64-base:3.19 -t hass-addon-vmalert ./vmalert && docker build --build-arg BUILD_FROM=ghcr.io/home-assistant/amd64-base:3.19 -t hass-addon-prom-write ./prom-write && docker build --build-arg BUILD_FROM=ghcr.io/home-assistant/amd64-base:3.19 -t hass-addon-klipper-exporter ./klipper-exporter`

- `BUILD_FROM` must be compatible with your architecture.
- Keep tags local unless explicitly publishing.

## Lint and Static Validation Commands

There is no centralized lint task yet; run tool-specific checks.

- Lint all shell scripts:
  - `shellcheck alertmanager/run.sh vmalert/run.sh prom-write/run.sh klipper-exporter/run.sh`
- Lint a single shell script:
  - `shellcheck vmalert/run.sh`
- Fast shell syntax check (all):
  - `bash -n alertmanager/run.sh vmalert/run.sh prom-write/run.sh klipper-exporter/run.sh`
- Fast shell syntax check (single file):
  - `bash -n prom-write/run.sh`
- Lint all YAML files:
  - `yamllint repository.json alertmanager/config.yaml alertmanager/alertmanager.yml vmalert/config.yaml vmalert/rules/*.yml prom-write/config.yaml klipper-exporter/config.yaml`
- Lint a single YAML file:
  - `yamllint vmalert/rules/alerts-hass.yml`
- Validate Prometheus/VictoriaMetrics rule file (single rule file):
  - `promtool check rules vmalert/rules/alerts-hass.yml`
- Validate both rule files:
  - `promtool check rules vmalert/rules/alerts-hass.yml vmalert/rules/alerts-bet-feeder.yml`

## Test Commands

No formal automated test suite exists in this repo.
Use these checks as the practical baseline:

- Build the changed add-on Docker image.
- Run `bash -n` and `shellcheck` on changed shell scripts.
- Run `yamllint` on changed YAML files.
- Run `promtool check rules` for changed `vmalert/rules/*.yml` files.

### Running a Single Test

- Single shell script syntax test:
  - `bash -n alertmanager/run.sh`
- Single shell script lint test:
  - `shellcheck prom-write/run.sh`
- Single YAML lint test:
  - `yamllint alertmanager/alertmanager.yml`
- Single alert rule validation test:
  - `promtool check rules vmalert/rules/alerts-bet-feeder.yml`

## Code Style Guidelines

### General

- Keep diffs small and focused; avoid broad refactors without request.
- Preserve existing directory structure and naming.
- Use UTF-8 only when file content already requires it (some summaries are non-English).
- Do not add new tooling/config files unless needed for the task.

### Bash Style (`run.sh`)

- Use shebang: `#!/usr/bin/with-contenv bashio`.
- Preferred safety mode for new scripts is `set -euo pipefail`.
- If compatibility requires softer behavior, document why in a short comment.
- Use uppercase variable names for environment/config-derived values.
- Read add-on options via `bashio::config '<key>'`.
- Quote variable expansions by default: `"${VAR}"`.
- Use `$(...)` command substitution.
- Prefer `[[ ... ]]` in new conditional logic.
- Use `exec` for long-running foreground process handoff where appropriate.
- Log meaningful lifecycle events via `bashio::log.info` and failures via `bashio::log.error`.
- Avoid parsing command output with fragile text pipelines when structured APIs are available.

### Imports / Dependencies

- Bash has no imports; treat external commands as dependencies.
- Current runtime dependencies include `bashio`, `curl`, and add-on binaries (`alertmanager`, `vmalert`).
- Do not introduce new runtime dependencies unless clearly necessary.

### Formatting

- Shell indentation: 2 spaces (match current files).
- YAML indentation: 2 spaces; no tabs.
- Keep lines readable; no strict length limit is required.
- Keep one logical operation per line in shell where possible.

### Types and Data Contracts

- Respect `config.yaml` `options` and `schema` alignment.
- Keep schema types explicit (`str`, `int`, etc.) and consistent with script usage.
- When adding new options, update both `options` and `schema`.

### Naming Conventions

- Add-on option keys: lowercase snake_case (`notifier_endpoint`).
- Shell vars derived from options: uppercase snake case (`NOTIFIER_ENDPOINT`).
- Alert names: concise PascalCase-like style (`BetFeederFeedErrors`) consistent with existing rules.
- Rule file names should stay descriptive (for example `alerts-hass.yml`).
- Entrypoint scripts should remain `run.sh`.

### Error Handling

- Fail fast for startup/configuration issues unless the add-on is explicitly designed to retry.
- For polling/loop workloads (like `prom-write`), log failures and continue with controlled sleep/retry.
- Check command exit statuses when non-fatal behavior is intended.
- Emit actionable error logs (what failed and which endpoint/file).

### Dockerfile Conventions

- Keep base image and copied artifacts explicit.
- Keep executable permissions set during build (`chmod +x /run.sh`).
- Keep `CMD ["/run.sh"]` unless a runtime change is intentional.
- Avoid unnecessary packages/layers in add-on images.

## Validation Checklist Before Finishing

- Changed files pass relevant lint/syntax checks.
- Changed rule files pass `promtool check rules`.
- Changed add-on builds successfully with `docker build`.
- Config keys added/renamed are reflected in both `options` and `schema`.
- No secrets/tokens hardcoded in committed files.

## Agent Behavior in This Repo

- Prefer small, surgical edits.
- Preserve user-authored unrelated changes.
- When uncertain about behavior, inspect sibling add-ons and follow established patterns.
- If adding new tests/tooling, document usage in this file.
