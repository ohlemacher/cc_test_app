#!/usr/bin/env bash
set -o nounset
set -o pipefail
set -o errexit

function die {
    local msg=“$1”
    (>&2 echo Fatal: “$msg”)  # Subshell avoids interactions with other redirections
    exit 1
}

function prereqs {
	pip install pytest || die "prereqs failed"
}

function run_unit_tests {
	python -m pytest -v cc-test-app-repo/test_app.py || die "unit tests failed"
}

prereqs
run_unit_tests

