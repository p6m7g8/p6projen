# shellcheck shell=bash

######################################################################
#<
#
# Function: p6_projen_util_version()
#
#>
#/ XXX: npx projen --version is the right way to do this
#/ XXX: but it assumes its built and its SLOW
######################################################################
p6_projen_util_version() {

    if p6_node_yarn_is; then
        grep "^projen@" yarn.lock
    elif p6_node_npm_is; then
        grep "^projen@" package-lock.json | head -1
    else
        p6_echo "idk"
    fi
}

######################################################################
#<
#
# Function: p6_projen_util_diff()
#
#>
######################################################################
p6_projen_util_diff() {

    p6_git_p6_diff
}

######################################################################
#<
#
# Function: p6_projen_util_synthesize()
#
#>
######################################################################
p6_projen_util_synthesize() {

    npx projen
}

######################################################################
#<
#
# Function: p6_projen_util_build()
#
#>
######################################################################
p6_projen_util_build() {

    npx projen build
}

######################################################################
#<
#
# Function: p6_projen_util_upgrade()
#
#>
######################################################################
p6_projen_util_upgrade() {

    npx projen projen:upgrade
}

######################################################################
#<
#
# Function: p6_projen_util_submit()
#
#>
######################################################################
p6_projen_util_submit() {

    local before
    before=$(p6_git_p6_diff package.json | grep '"projen":' | awk '{ print $3 }' | sed -e 's,[^^0-9.],,g' | head -1)
    local after
    after=$(p6_git_p6_diff package.json | grep '"projen":' | awk '{ print $3 }' | sed -e 's,[^^0-9.],,g' | tail -1)

    p6_git_p6_add_all
    p6_github_gh_pr_submit "chore(deps): bumps projen from $before to $after"
}

######################################################################
#<
#
# Function: p6_projen_util_foreach(projects, code, [threads=1])
#
#  Args:
#	projects -
#	code -
#	OPTIONAL threads - [1]
#
#>
######################################################################
p6_projen_util_foreach() {
    local projects="$1"
    local code="$2"
    local threads="${3:-1}"

    if p6_string_eq "1" "$threads"; then
        local project
        for project in $(echo "$projects"); do
            local org
            org=$(echo "$project" | cut -f 1 -d /)

            local dir
            dir="$P6_DFZ_SRC_DIR/$project"

            local prefix
            prefix=$(p6__pad "$project" 40)

            case $code in
            *versions*) echo -n "$prefix" ;;
            *) echo "$prefix" ;;
            esac

            case $code in
            *upgrade*)
                rm -rf "$dir"
                gh repo clone "$project" "$dir"
                ;;
            esac

            (
                cd "$dir" || exit
                p6_run_code "$code"
            )
        done
    fi
}

######################################################################
#<
#
# Function: p6__pad(str, length)
#
#  Args:
#	str -
#	length -
#
#>
######################################################################
p6__pad() {
    local str="$1"
    local length="$2"

    perl -MP6::Util -e "print P6::Util::rprint($length, \"$str\")"
}
