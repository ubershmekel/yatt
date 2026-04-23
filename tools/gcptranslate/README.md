# Translation Helper Tools

This directory contains Poetry-based helper scripts for maintaining localized
Flutter ARB files and generating lesson markdown.

The scripts use Google Cloud Translate, so run them from an environment with
Google Cloud credentials configured.

## Setup

```bash
# Keep the virtual environment in this directory so the VS Code launch
# configuration can find it.
poetry config virtualenvs.in-project true
poetry install
```

## Common commands

```bash
# Update ARB files from the English template.
poetry run python arb_translate.py

# Generate markdown files for a new lesson level.
poetry run python md_gen.py
```

After updating ARB files, regenerate Flutter localization classes from the app
directory:

```bash
cd ../../yout
flutter gen-l10n
```
