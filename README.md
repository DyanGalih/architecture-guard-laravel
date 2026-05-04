# 🐘 Laravel Architecture Adapter (DEPRECATED)

> **NOTICE**: This extension is now **DEPRECATED**. Its functionality has been consolidated into the core **[Architecture Guard](https://github.com/DyanGalih/spec-kit-architecture-guard)** extension as a built-in framework preset.

> Please uninstall this extension and use the core extension's built-in Laravel preset instead.

[![Status](https://img.shields.io/badge/status-deprecated-ef4444)](extension.yml)
[![Architecture Guard](https://img.shields.io/badge/Requires-architecture--guard-2563eb)](https://github.com/DyanGalih/spec-kit-architecture-guard)
[![Laravel](https://img.shields.io/badge/Laravel-11.x%20--%2013.x-f05340)](https://laravel.com)
[![License: MIT](https://img.shields.io/badge/License-MIT-f59e0b)](LICENSE)

---

## Migration Guide

1.  **Uninstall this extension**:
    ```text
    specify extension remove architecture-guard-laravel
    ```
2.  **Ensure core Architecture Guard is installed**:
    ```text
    specify extension add architecture-guard
    ```
3.  **Run Initialization**:
    ```text
    /speckit.architecture-guard.init
    ```
4.  **Select Laravel Preset**: When prompted for your technology stack, select **Laravel**.
5.  **Enjoy Background Governance**: The core extension will now automatically apply Laravel-specific rules using its built-in adapter.

---

## Role in the Suite (Legacy)

This extension used to be a separate adapter. It is now a **Built-in Preset** within the core Architecture Guard engine.

---

## License

This extension is released under the [MIT License](LICENSE).
