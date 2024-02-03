#!/usr/bin/env bash

set -e

cd "${0%/*}/.."

echo "Running rubocop"
bundle exec rubocop --color --autocorrect

# To run rubocop only on files that are modified (pre-commit)
git ls-files -m | xargs ls -1 2>/dev/null | grep '\.rb$' | xargs bundle exec rubocop --color --autocorrect

## To run rubocop only on files that are modified (pre-push)
#git diff-tree -r --no-commit-id --name-only @\{u\} head | xargs bundle exec rubocop --color --autocorrect
