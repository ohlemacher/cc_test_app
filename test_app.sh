#!/usr/bin/env bash
set -o nounset
set -o pipefail
set -o errexit

if [ "$(hostname)" == "pluto.local" ]; then
    echo "Configured for pluto execution"
    declare -r cc_test_app_dir="cc_test_app"
    declare -r cc_test_module_dir="cc_test_module"
else
    declare -r cc_test_app_dir="cc-test-app-repo"
    declare -r cc_test_module_dir="cc-test-module-repo"
fi

function info {
    local msg="$1"
    (>&2 echo "\n=== Info: $msg")  # Subshell avoids interactions with other redirections
}

function die {
    local msg="$1"
    (>&2 echo "\n!!! Fatal: $msg")  # Subshell avoids interactions with other redirections
    exit 1
}

function install_prereqs {
    info "Prereq: Install pytest"
    pip install pytest || die "pip install pytest failed"

    info "Prereq: Install cc_test_module"
    pushd "$cc_test_module_dir" > /dev/null
    pip install -e . || die "pip -e cc-test-module-repo install failed"
    popd > /dev/null
}

function run_unit_tests {
    info "Run unit tests for app.py"
    pushd "$cc_test_app_dir" > /dev/null
    python -m pytest -v test_app.py || die "app.py unit tests failed"
    popd > /dev/null
}

install_prereqs
run_unit_tests

