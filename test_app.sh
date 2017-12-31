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
    (>&2 echo Info: "$msg")  # Subshell avoids interactions with other redirections
}

function die {
    local msg="$1"
    (>&2 echo Fatal: "$msg")  # Subshell avoids interactions with other redirections
    exit 1
}

function prereqs {
    pip install pytest || die "pip install pytest failed"

    if [ "$(hostname)" != "pluto.local" ]; then
        echo "find $cc_test_module_dir..."
        find / -name "$cc_test_module_dir"
    fi

    pushd "$cc_test_module_dir" > /dev/null
    pip install -e . || die "pip -e cc-test-module-repo install failed"
    popd > /dev/null
}

function run_unit_tests {
    pushd "$cc_test_app_dir" > /dev/null
    python -m pytest -v test_app.py || die "app.py unit tests failed"
    popd > /dev/null
}

prereqs
run_unit_tests

