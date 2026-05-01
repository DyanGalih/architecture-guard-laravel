# 🐘 Laravel Architecture Adapter

> Laravel-specific architectural rules and best practices for Architecture Guard.

[![Version](https://img.shields.io/badge/version-1.1.5-22c55e)](extension.yml)
[![Architecture Guard](https://img.shields.io/badge/Requires-architecture--guard-2563eb)](https://github.com/DyanGalih/spec-kit-architecture-guard)
[![Laravel](https://img.shields.io/badge/Laravel-11.x%20--%2013.x-f05340)](https://laravel.com)
[![License: MIT](https://img.shields.io/badge/License-MIT-f59e0b)](LICENSE)

## Role in the Suite

This extension is an **Adapter**. It does not run its own workflow; it provides the **Laravel-specific domain knowledge** that the core Architecture Guard engine uses to validate your project.

| System | Role | Provided Knowledge |
| --- | --- | --- |
| **`architecture-guard`** | **The Engine** | Lifecycle, Commands, Drift Detection logic. |
| **`architecture-guard-laravel`** | **The Brain** | Laravel conventions, FormRequests, API Resources, Eloquent rules. |

---

## Command Options: Laravel Focus Mapping

When running core commands like `/speckit.architecture-guard.architecture-review`, you can use **Focus Areas** to target specific Laravel primitives:

| Focus Area | Laravel Primitives Targeted |
| --- | --- |
| **`db`** | Eloquent Models, Scopes, Migrations, Query Builder, and Repositories. |
| **`api`** | API Resources, Form Requests, Routing Contracts, and JSON serialization. |
| **`async`** | Queued Jobs, Event Listeners, Broadcasting Channels, and Horizon config. |
| **`general`** | Full cross-boundary review (e.g., Controller → Service → Model). |

### Example Enterprise Commands:

**Deep Eloquent & Migration Audit:**
```text
/speckit.architecture-guard.architecture-review db
```

**API Contract & Validation Check:**
```text
/speckit.architecture-guard.architecture-review api
```

---

## Role in the Suite

This extension is an **Adapter**. It does not run its own workflow; it provides the **Laravel-specific domain knowledge** that the core Architecture Guard engine uses to validate your project.

| System | Role | Provided Knowledge |
| --- | --- | --- |
| **`architecture-guard`** | **The Engine** | Lifecycle, Commands, Drift Detection logic. |
| **`architecture-guard-laravel`** | **The Brain** | Laravel conventions, FormRequests, API Resources, Eloquent rules. |

---

## Recommended Setup Flow

| Milestone | Recommended Command | Phase Integration | Purpose |
| --- | --- | --- | --- |
| **Milestone: Inject** | `init` | Once at setup | **Inject Laravel-specific rules** into your `architecture_constitution.md`. |
| **Milestone: Review** | `architecture-workflow` | Anytime | Core engine runs, using the Laravel rules you injected. |

---

## Usage: The Zero-Config Workflow

Once installed and initialized, this extension operates **automatically in the background**. 

- **Do not** call this adapter's commands for your daily reviews.
- **Do** call the core **Architecture Guard** commands (e.g., `/speckit.architecture-guard.architecture-workflow`).

The core engine will detect this adapter and automatically apply the Laravel-specific rules to your project.

---

## Synergy: Laravel Boost (MCP)

Architecture Guard runs significantly better when paired with a Laravel-aware MCP server like **Laravel Boost**.

- **High-Definition Evidence**: Instead of "guessing" relationships, the AI can query your app's actual routes, bindings, and models in real-time.
- **Tailored Initialization**: Running `/init` with an active MCP allows the AI to "audit" your project first and write a constitution that matches your existing patterns (Inertia, Livewire, etc.).

## The Knowledge Loop

By combining these tools, you create a self-improving development environment:

1.  **Inspect (Laravel Boost)**: Use the MCP to find real-time architectural truths and edge cases.
2.  **Capture (Memory Hub)**: Persist "Durable Lessons" discovered via MCP into `docs/memory/` to avoid repeating mistakes.
3.  **Govern (Architecture Guard)**: Codify repeated patterns into the **Architecture Constitution** to reduce the need for future exploration.

> **Result**: Better context, fewer tokens, and zero architectural drift.

---

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
When your `architecture_constitution.md` adopts Actions or Repositories, flags code that bypasses them.

## When NOT To Use This

- **Your project isn't Laravel** — use a different adapter or none
- **Simple CRUD app with 5 routes** — the overhead isn't worth it
- **You haven't set up Architecture Guard yet** — install the core extension first
- **Your project hasn't initialized architecture rules** — use the `init` command to add Laravel-specific rules to your `architecture_constitution.md`.

---

## Quick Start

1. Install Architecture Guard (required):
   ```text
   specify extension add architecture-guard
   ```

    ```text
    specify extension add architecture-guard-laravel
    ```

3. Initialize Laravel architecture rules in your `architecture_constitution.md`:
    ```text
    /speckit.architecture-guard-laravel.init
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
  https://github.com/DyanGalih/architecture-guard-laravel/archive/refs/tags/v1.1.5.zip
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
- Override your project's technical constitution
- Act as a PHP linter or static analyzer (use Pint, PHPStan, Larastan for that)
- Require any runtime tools or Composer packages
- Block implementation by default

## License

This extension is released under the [MIT License](LICENSE).
