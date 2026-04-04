#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export SCRIPT_DIR

function release_custom_hook {
    # shellcheck disable=SC2154
    echo "No custom hook for: \"${version_tag}\""
}

export -f release_custom_hook
export START_COMMIT=afbefbf7b3a1e3288f2319674e465908b541755f
export RELEASE_CUSTOM_HOOK=release_custom_hook
export REPO_NAME=toggle-corp/terraform-uptimerobot-modules
export DEFAULT_BRANCH=main
export VERSION_TAG_PREFIX_MODE=require

export GIT_CLIFF__REMOTE__GITHUB__OWNER=toggle-corp
export GIT_CLIFF__REMOTE__GITHUB__REPO=terraform-uptimerobot-modules

# Forward the argument - used for pre-fill version
"$SCRIPT_DIR/fugit/scripts/release.sh" "${@:-}"
