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

> **Note on `curl | bash`**: `specify preset add` / `specify extension add` may
> prompt for confirmation (e.g. an "untrusted source" warning). When the
> script runs via `curl | bash`, stdin is the piped script itself, not your
> keyboard, so that prompt gets auto-declined and the preset/extension is
> silently **not** installed. The script detects this — it verifies each
> install afterward and prints a warning with the exact command to re-run
> yourself in an interactive terminal if it didn't go through. Always check
> the summary at the end of the run (or `specify preset list` /
> `specify extension list`) before assuming everything installed.

## After the script

In your AI agent, run once, in this order:

```
/speckit.architecture-guard.init
/speckit.constitution
```

- `/speckit.architecture-guard.init` writes `architecture_constitution.md` (layer boundaries, business logic placement, blocking violations).
- `/speckit.constitution` populates `constitution.md`'s governance principles from the two installed presets' addenda (TDD/BDD/ATDD discipline from `test-first-governance`, security architecture principles from `architecture-governance`).

For each new project, also fill in the **Tech defaults** section of `constitution.md` once — by hand or with a short constitution prompt.

### Per feature: use `architecture-guard`'s own commands, not the plain `speckit.*` ones

Once the extension is installed, don't drive features with the bare
`/speckit.specify` / `/speckit.plan` / `/speckit.tasks` / `/speckit.implement`
commands — `architecture-guard` ships its own `/speckit.architecture-guard.*`
commands that wrap each phase with the governance checks (spec/plan/task
gates against `architecture_constitution.md`, drift and boundary detection,
refactor-task injection). The plain commands still work, but they skip all
of that.

Recommended flow, per feature:

```
/speckit.architecture-guard.governed-spec
/speckit.architecture-guard.governed-delivery
/speckit.architecture-guard.governed-implement
/speckit.architecture-guard.architecture-verify
```

- `/speckit.architecture-guard.governed-spec` — spec + clarify, with architecture/security validation and an auto-fix loop.
- `/speckit.architecture-guard.governed-delivery` — plan → tasks → analyze in one resumable flow; the recommended entry point right after the spec. (`governed-plan` and `governed-tasks` also exist standalone, for rerunning just one of those phases.)
- `/speckit.architecture-guard.governed-implement` — implementation with governance context, followed by a security + architecture review pass.
- `/speckit.architecture-guard.architecture-verify` — final gate: checks all tasks were actually delivered against the plan.

If the feature starts as a rough idea rather than a ready spec, run
`/speckit.architecture-guard.governed-discover` first to shape it before
`governed-spec`.

> **Do the presets still apply with these `governed-*` commands?** Yes.
> `test-first-governance` and `architecture-governance` work by *wrapping*
> the plain `/speckit.specify`, `/speckit.clarify`, `/speckit.plan`,
> `/speckit.tasks`, `/speckit.checklist`, `/speckit.analyze`, and
> `/speckit.implement` commands — their requirements (Gherkin/TDD evidence,
> threat modeling, S-ADRs, etc.) are composed directly into those commands.
> The `governed-*` commands don't reimplement spec/plan/task/implement
> generation — they call those same wrapped commands as steps in their
> orchestration (see `governed-spec.md` calling `/speckit.specify` +
> `/speckit.clarify`, `governed-delivery.md` calling `/speckit.tasks` +
> `/speckit.analyze`, `governed-implement.md` calling `/speckit.implement`).
> So preset requirements still apply automatically at every phase.
> One exception: `governed-implement` falls back to an inline
> implementation if `/speckit.implement` isn't available as a registered
> command — that fallback path skips the preset wrap, so keep an eye on the
> governance summary it prints.

Standalone review commands (not part of the per-feature flow, but useful on demand):

| Command | Use it to... |
|---|---|
| `/speckit.architecture-guard.architecture-workflow` | Run a full end-to-end architecture review (violations, severity, refactor tasks) |
| `/speckit.architecture-guard.architecture-review` | Check alignment after `specify`/`plan`/`implement` |
| `/speckit.architecture-guard.violation-detection` | Focus on a specific drift/boundary problem |
| `/speckit.architecture-guard.refactor-generator` | Turn review findings into non-blocking refactor tasks |
| `/speckit.architecture-guard.architecture-apply` | Inject approved refactor tasks into `plan.md`/`tasks.md` |
| `/speckit.architecture-guard.init-brownfield` | Map an existing codebase before onboarding it (brownfield only) |
| `/speckit.architecture-guard.consolidate-specs` | Refresh the local fallback context cache |

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
