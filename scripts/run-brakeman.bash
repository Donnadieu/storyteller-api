#!/usr/bin/env bash

set -e

cd "${0%/*}/.."

echo "Running brakeman"
bundle exec brakeman --color -o /dev/stdout -o .brakeman/output.html
