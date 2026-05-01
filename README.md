# 🛡️ Architecture Guard — Laravel Adapter

[![Version](https://img.shields.io/badge/version-1.0.1-22c55e)](extension.yml)
[![Spec Kit](https://img.shields.io/badge/Spec%20Kit-compatible-2563eb)](https://spec-kit.dev)
[![Requires](https://img.shields.io/badge/requires-architecture--guard-8b5cf6)](https://github.com/DyanGalih/spec-kit-architecture-guard)
[![Laravel](https://img.shields.io/badge/Laravel-10.x%20%E2%80%93%2013.x-ef4444)](https://laravel.com/docs/13.x)

## What Is This?

A **framework adapter** for [Architecture Guard](https://github.com/DyanGalih/spec-kit-architecture-guard) that maps generic architecture rules to Laravel-specific conventions.

Architecture Guard reviews your code against generic boundaries (Entry, Validation, Contract, Application, Domain, Data, Integration, Presentation). This adapter tells it what those boundaries look like **in Laravel** — including support for all four [Starter Kit](https://laravel.com/docs/13.x/starter-kits) stacks (React, Vue, Svelte via Inertia.js, and Livewire).

## Why You Need This

Architecture Guard's core rules are framework-agnostic. It knows that "business logic should not live in entry points" — but it doesn't know that in Laravel, the entry point is a **Controller**, the validation boundary is a **Form Request**, and the response shape is an **API Resource**.

Without this adapter, the core extension may:
- Miss that a Controller is doing too much (it doesn't know Laravel controller conventions)
- Not flag raw `$model->toArray()` responses (it doesn't know about API Resources)
- Not detect scattered inline validation (it doesn't know about Form Requests)

With this adapter, the review becomes Laravel-aware:

| Generic Rule | Without Adapter | With Adapter |
| --- | --- | --- |
| "Entry points should not own business logic" | Might miss fat controllers | Flags controllers with business logic, suggests Actions/Services |
| "Input should be validated at the boundary" | Flags missing validation | Also flags inline validation that should be Form Requests |
| "Output shapes should use contracts" | Flags missing contracts | Also flags `->toArray()` that should be API Resources |
| "Data access should use approved abstraction" | Generic check | Also flags complex Eloquent in controllers, suggests scopes or repositories |

## Boundary Mapping Summary

| Generic Boundary | Laravel Equivalent |
| --- | --- |
| Entry | Controllers, Artisan Commands, Jobs, Listeners, Scheduled Tasks |
| Validation | Form Requests, Rule Objects, `$request->validate()` |
| Contract | Form Requests (input), API Resources (output), DTOs, Event classes |
| Application | Actions, Services, Pipelines |
| Domain | Eloquent Models, Policies, Enums, Value Objects, Scopes |
| Data | Eloquent ORM, Repositories, Query Builder, Migrations |
| Integration | HTTP Client, Queue Jobs, Mail, Notifications, Storage, Broadcasting |
| Presentation | Blade, Inertia.js (React / Vue / Svelte), Livewire, API Resources, TypeScript types |

## What It Detects

### Fat Controllers
Controllers with business logic beyond validate → delegate → respond.

### Scattered Validation
Inline validation duplicated across controllers instead of Form Requests.

### Missing API Resources
Raw `->toArray()` or array responses instead of structured API Resources or Inertia data shapes.

### Fat Models
Models containing business workflows, external service calls, or complex boot/observer logic.

### Boundary Leaks
Jobs with HTTP response logic, Listeners with multi-step workflows, Events with behavior, Middleware with business logic.

### Leaking Data to Inertia
Passing `$model->toArray()` directly to `Inertia::render()` — exposes passwords, tokens, and internal fields to frontend JavaScript.

### Fat Livewire Components
Livewire components with multi-step business workflows that should be delegated to Actions or Services.

### Frontend Business Logic
Permission filtering, access control, or business decisions in React/Vue/Svelte page components instead of server-side.

### Unsafe Inertia Shared Data
Sensitive fields (API tokens, internal IDs) in `HandleInertiaRequests::share()` shared globally to every page.

### Pattern Violations
When the Constitution adopts Actions or Repositories, flags code that bypasses them.

## When NOT To Use This

- **Your project isn't Laravel** — use a different adapter or none
- **Simple CRUD app with 5 routes** — the overhead isn't worth it
- **You haven't set up Architecture Guard yet** — install the core extension first
- **Your Constitution doesn't define Laravel conventions** — the adapter checks against your Constitution, so define your rules first

---

## Quick Start

1. Install Architecture Guard (required):
   ```text
   specify extension add architecture-guard
   ```

2. Install this adapter:
   ```text
   specify extension add architecture-guard-laravel
   ```

3. Add Laravel-specific rules to your `CONSTITUTION.md`:
   ```markdown
   ## Laravel Conventions
   - Controllers must be thin: validate → delegate → respond
   - Use Form Requests for validation with more than 3 rules
   - Use API Resources for all JSON and Inertia responses
   - Business logic lives in Actions or Services, not Controllers, Models, or Livewire components
   - Do not pass raw Eloquent models to Inertia::render()
   ```

4. Run architecture review — the adapter activates automatically:
   ```text
   /speckit.architecture-guard.architecture-workflow
   ```

---

## Installation

### From Extension Registry

```text
specify extension add architecture-guard-laravel
```

### From GitHub

```text
specify extension add architecture-guard-laravel --from \
  https://github.com/DyanGalih/architecture-guard-laravel/archive/refs/tags/v1.0.1.zip
```

### Local Development

```text
specify extension add --dev /path/to/architecture-guard-laravel
```

### Verification

```bash
./scripts/test-install.sh
```

---

## Project Structure

```text
architecture-guard-laravel/
├── .gitignore
├── CONTRIBUTING.md
├── LICENSE
├── README.md
├── extension.yml                      ← Extension manifest
├── commands/
│   └── laravel-guidance.md            ← Laravel adapter rules (644 lines, self-contained)
└── scripts/
    └── test-install.sh                ← Smoke tests
```

## Compatibility

- Requires: `architecture-guard` (core extension)
- Compatible with: Laravel 10.x, 11.x, 12.x, 13.x
- Starter Kit stacks: React (Inertia), Vue (Inertia), Svelte (Inertia), Livewire, Blade-only, REST API
- Safe to remove: the core extension works without this adapter

## Non-Goals

This adapter does not:

- Replace the core Architecture Guard rules
- Override the Constitution
- Act as a PHP linter or static analyzer (use Pint, PHPStan, Larastan for that)
- Require any runtime tools or Composer packages
- Block implementation by default

## License

This extension is released under the [MIT License](LICENSE).
