#!/usr/bin/env bash
set -o nounset
set -o pipefail
set -o errexit

declare -r gh_user="ohlemacher"
declare -r gh_token="dbd9a1b24133b564320e4fd23e2b30504fbaa55a"
declare -r cc_test_app_dir="cc-test-app-repo"
declare -r cc_test_module_dir="cc-test-module-repo"
export GIT_SSH_COMMAND="ssh -o StrictHostKeyChecking=no"

function info {
    local msg="$1"
    (>&2 echo "===== Info: $msg")  # Subshell avoids interactions with other redirections
}

function die {
    local msg="$1"
    (>&2 echo "!!!!! Fatal: $msg")  # Subshell avoids interactions with other redirections
    exit 1
}

function install_prereqs {
    info "Prereq: None required"
}

function commit_to_branch {
    local -r br="$1"
    pushd "$cc_test_app_dir" > /dev/null
    local -r head="$(git rev-parse HEAD)"

    info "Commit to $br branch. Move HEAD to $head"

    info "+++ Use sed develop to fix fetches in .git/config"
    # This fixes an issue where it was impossible to fetch the $br. Fetch ignored $br.
    # Trying to create the $br resulted in this error:
    # ===== Info: +++ git checkout -b origin/passed_unit_tests
    # fatal: Cannot update paths and switch to branch 'passed_unit_tests' at the same time.
    # Did you intend to checkout 'origin/passed_unit_tests' which can not be resolved as commit?
    #sed -i -- 's?fetch = +refs/heads/develop:refs/remotes/origin/develop?fetch = +refs/heads/*:refs/remotes/origin/*?g' .git/config || die "git config fix failed"
    info "+++ Remove git origin" 
    git remote rm origin               || die "git remote rm origin failed"

    info "+++ Add git origin"
    git remote add origin \
        "git@github.com:$gh_user/cc_test_app.git" \
                                       || die "Cannot add git origin" 

    info "+++ cat .git/config"
    cat .git/config                    || die "cat of git config failed"

    #info "+++ add gh keyscan to known-hosts" # Used 'ssh-keyscan github.com'
    #mkdir "$HOME/.ssh"
    #chmod 700 "$HOME/.ssh"
    #touch "$HOME/.ssh/known_hosts" 
    #chmod 600 "$HOME/.ssh/known_hosts"
    #cat gh.com.keyscan >> "$HOME/.ssh/known_hosts"

    info "+++ configure gh"
    git config user.name "$gh_user"
    #git config github.token "$gh_token"

    info "+++ git remote update"
    #git remote update                  || die "git remote update failed"
    git fetch                          || die "git fetch failed"
    
    info "+++ git fetch origin passed_unit_tests"
    git fetch origin passed_unit_tests || die "git fetch passed_unit_tests failed"

    #info "+++ git remote show origin"
    #git remote show origin             || die "git remote show origin failed"

    info "+++ git checkout -b origin/$br"
    git checkout -b "$br" "origin/$br" || die "git checkout $br failed"

    info "+++ git rebase $head"
    git rebase "$head"                 || die "git rebase HEAD on $br branch failed"

    popd > /dev/null
 
    info "Create local clone"
    rm -rf "${cc_test_app_dir}-passed-unit-tests"
    git clone "$cc_test_app_dir" "${cc_test_app_dir}-passed-unit-tests"
}

declare -r branch="$1"
commit_to_branch "$branch"
