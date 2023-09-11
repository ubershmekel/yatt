# How to run

```
# make sure we get a .venv folder so we can use the standard
# vs code launch.json configuration
poetry config virtualenvs.in-project true

# get dependencies
poetry install

# update arb files from app_en.arb
poetry run python arb_translate.py

# generate md files for a new level
poetry run python md_gen.py
```
