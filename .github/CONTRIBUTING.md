# Contributing to nf-modules

## Unit tests

Once you've written or updated a module under `modules/CCBR/[module-name]` and
a test workflow under `tests/modules/CCBR/[module-name]`,
then use nf-core tools to automatically create a test YAML file with:

```sh
nf-core modules create-test-yml [module-name] --run-tests --force --no-prompts
```

## Pre-commit hooks

Pre-commit can automatically format your code, check for spelling errors, etc. every time you commit.

Install [pre-commit](https://pre-commit.com/#installation) if you haven't already,
then run `pre-commit install` to install the hooks specified in `.pre-commit-config.yaml`.
Pre-commit will run the hooks every time you commit.

## Changelog

Keep the changelog up to date with all notable changes in `CHANGELOG.md`[^2].

[^2]: changelog guidelines: https://keepachangelog.com/en/1.1.0/

## VS code extensions

If you use VS code, installing [nf-core extension pack](https://marketplace.visualstudio.com/items?itemName=nf-core.nf-core-extensionpack) is recommended.
