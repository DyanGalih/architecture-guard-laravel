# Contributing to Architecture Guard — Laravel Adapter

Thank you for your interest in contributing!

## Repository Structure

```
extension.yml          ← Extension manifest
commands/              ← Spec Kit command definitions (single source of truth)
scripts/               ← Verification scripts
```

## Development Workflow

### Rule Changes

If you want to modify Laravel-specific detection rules:

1. Update `commands/laravel-guidance.md`. The command file is self-contained.
2. Run `./scripts/test-install.sh` to verify consistency.

### Adding Detection Rules

When adding new Laravel-specific detection logic:

1. Check that the rule is **Laravel-specific** and not already covered by the core `architecture-guard`.
2. Add the rule to the appropriate section in `commands/laravel-guidance.md`.
3. Include a code example showing the anti-pattern and the fix.
4. Ensure the rule respects the Constitution as the final authority.

### Testing

```bash
./scripts/test-install.sh
```

## Guidelines

- **Extend, Don't Replace**: This adapter extends core rules — it never duplicates or overrides them.
- **Constitution First**: Every rule must defer to the project's Constitution. If the Constitution allows fat controllers, don't flag them.
- **Laravel Convention Aware**: Don't flag standard Laravel patterns (Facades, helpers, Eloquent) as violations unless the Constitution says so.
- **Examples Required**: Every detection rule should include a ❌ anti-pattern and ✅ correct example.

## Pull Requests

1. Fork the repository.
2. Create your feature branch.
3. Run `./scripts/test-install.sh`.
4. Submit a PR with a clear description.
