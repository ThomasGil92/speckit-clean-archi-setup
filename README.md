# Spec Kit – Clean Architecture + TDD Setup

One-shot script to quickly set up a **Spec Kit** project with a minimal stack focused on **Clean Architecture** and **TDD**, language-agnostic.

## What the script does

1. Installs the presets:
   - `test-first-governance` (TDD + Gherkin / BDD)
   - `architecture-governance`
2. Installs the extension:
   - `architecture-guard` (boundary review, drift, DRY…)
3. Writes three files under `.specify/memory/`:
   - `constitution.md` → a **seed only**: product context + Tech defaults. Nothing else is written here.
   - `coding_standards.md` → naming, error handling, logging, API conventions, testing, complexity
   - `quality_gate.md` → the checklist a feature must pass before being considered done

`constitution.md`'s governance principles (TDD/BDD/ATDD discipline, security architecture) and `architecture_constitution.md` (Clean Architecture layers, Dependency Rule) are **not** written by this script — they come from the agent commands below. Writing them here would just get overwritten or restructured by those commands, so the script only seeds what nothing else provides.

> **Note**: agent slash commands cannot be run by a bash script. Run them manually after the script (see "After the script").

## Prerequisites

- A project already initialized with Spec Kit:
  ```bash
  specify init . --here
  ```

- The `specify` CLI installed:
  ```bash
  uv tool install specify-cli --from git+https://github.com/github/spec-kit.git
  ```

## Quick start

From the root of a Spec Kit project:

```bash
curl -fsSL https://raw.githubusercontent.com/ThomasGil92/speckit-clean-archi-setup/main/setup-clean-archi-speckit.sh | bash
```

Or locally:

```bash
chmod +x setup-clean-archi-speckit.sh
./setup-clean-archi-speckit.sh
```

## After the script

In your AI agent, run once, in this order:

```
/speckit.architecture-guard.init
/speckit.constitution
```

- `/speckit.architecture-guard.init` writes `architecture_constitution.md` (layer boundaries, business logic placement, blocking violations).
- `/speckit.constitution` populates `constitution.md`'s governance principles from the two installed presets' addenda (TDD/BDD/ATDD discipline from `test-first-governance`, security architecture principles from `architecture-governance`).

For each new project, also fill in the **Tech defaults** section of `constitution.md` once — by hand or with a short constitution prompt.

Then you can start normally:

```
/speckit.specify
/speckit.plan
/speckit.tasks
/speckit.implement
```

The first `/speckit.specify` describes the product.

## Governance file contents

### `constitution.md` (seed, before you run the agent commands)

- Product context — describe the product vision, users, and goals
- Tech defaults — language/runtime, framework, package manager, test framework, linting, persistence

After `/speckit.constitution`, this file also gains the TDD/BDD/ATDD principles from `test-first-governance` and the security architecture principles from `architecture-governance`.

### `architecture_constitution.md` (written entirely by `/speckit.architecture-guard.init`)

Not created by this script — owned end-to-end by the `architecture-guard` extension (layer boundaries, Dependency Rule, business logic placement, blocking violations).

### `coding_standards.md` (general coding conventions)

- Naming, error handling, logging
- API / external interface conventions
- Testing rules, complexity, maintainability

### `quality_gate.md` (definition of done)

- Specification, TDD, code quality, and validation checklists
- Defers architecture checks to the `architecture-guard` extension

## Installed stack

| Component | Type | Role |
|---|---|---|
| `test-first-governance` | Preset | TDD + Gherkin / BDD |
| `architecture-governance` | Preset | Architecture governance |
| `architecture-guard` | Extension | Reviews boundaries, drift, DRY, refactors |

## Why this minimal stack?

Instead of multiplying custom extensions, this relies on already-maintained community components plus a clear constitution.

It's the best trade-off between discipline, simplicity, and maintainability — regardless of the language or stack you use.

## License

MIT
