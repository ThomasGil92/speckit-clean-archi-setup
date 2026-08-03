# Spec Kit – Clean Architecture + TDD Setup

One-shot script to quickly set up a **Spec Kit** project with a minimal stack focused on **Clean Architecture** and **TDD**, language-agnostic.

## What the script does

1. Installs the presets:
   - `test-first-governance` (TDD + Gherkin / BDD)
   - `architecture-governance`
2. Installs the extension:
   - `architecture-guard` (boundary review, drift, DRY…)
3. Writes four governance files under `.specify/memory/`:
   - `constitution.md` → general principles (TDD, Gherkin, quality) + product context + Tech defaults
   - `architecture_constitution.md` → Clean Architecture rules (layers + Dependency Rule)
   - `coding_standards.md` → naming, error handling, logging, API conventions, testing, complexity
   - `quality_gate.md` → the checklist a feature must pass before being considered done

   Architecture boundary enforcement (forbidden dependencies, drift detection, mechanical verification) is intentionally left to the `architecture-guard` extension rather than duplicated in these files.

> **Note**: the agent command `/speckit.architecture-guard.init` cannot be run by a bash script. It must be run manually in your agent after the script.

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

In your AI agent, run once:

```
/speckit.architecture-guard.init
```

For each new project, fill in the **Tech defaults** section once — by hand or with a short constitution prompt.

Then you can start normally:

```
/speckit.specify
/speckit.plan
/speckit.tasks
/speckit.implement
```

The first `/speckit.specify` describes the product.

## Constitution contents

### `constitution.md` (general principles)

- TDD is mandatory (RED → GREEN → REFACTOR)
- Gherkin for every user-facing behavior
- No business logic in outer layers
- Small, focused modules
- Quality gates must be respected (architecture-guard)

### `architecture_constitution.md` (Clean Architecture)

- Dependency Rule: dependencies only point inward
- Mandatory layers:
  - `domain/`
  - `application/`
  - `infrastructure/`
  - `presentation/` (or `interfaces/`)
- Applies to backend, frontend, and any other runtime — no language lock-in
- Property tests recommended for domain invariants

### Tech defaults (filled in once per project)

- Language / runtime, primary framework, package manager
- Test framework, linting / formatting
- Persistence and other project-wide conventions

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
