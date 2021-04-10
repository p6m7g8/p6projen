# shellcheck shell=bash

######################################################################
#<
#
# Function: words projects = p6_projen_awesome_collect()
#
#  Returns:
#	words - projects
#
#  Depends:	 p6_echo
#  Environment:	 P6_DFZ_SRC_P6M7G8_DIR
#>
######################################################################
p6_projen_awesome_collect() {

    local projects
    projects=$(p6_file_display "$P6_DFZ_SRC_P6M7G8_DIR/p6projen/conf/projects")

    p6_return_words "$projects"
}

######################################################################
#<
#
# Function: p6_projen_awesome_clones([parallel=8])
#
#  Args:
#	OPTIONAL parallel - [8]
#
#  Depends:	 p6_dir p6_run
#  Environment:	 P6_DFZ_DATA_DIR
#>
######################################################################
p6_projen_awesome_clones() {
    local parallel="${1:-8}"

    local dir="$P6_DFZ_DATA_DIR/src/github.com/projens"
    p6_dir_mk "$dir"

    local projects=$(p6_projen_awesome_collect)

    p6_run_parallel "0" "$parallel" "$projects" "p6_github_util_repo_clone_or_pull" "" "$dir"
}

######################################################################
#<
#
# Function: p6_projen_awesome_foreach(code)
#
#  Args:
#	code -
#
#  Depends:	 p6_echo p6_run
#  Environment:	 P6_DFZ_DATA_DIR
#>
######################################################################
p6_projen_awesome_foreach() {
    local code="$1"

    local projects=$(p6_projen_awesome_collect)
    local dir="$P6_DFZ_DATA_DIR/src/github.com/projens"

    for project in $(echo "$projects"); do
        (
            cd "$dir/$project" || exit
            p6_run_code "$code"
        )
    done
}

######################################################################
#<
#
# Function: p6_projen_awesome_version()
#
#  Depends:	 p6_echo p6_node
#>
######################################################################
p6_projen_awesome_version() {

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
# Function: p6_projen_awesome_cdk_version()
#
#>
######################################################################
p6_projen_awesome_cdk_version() {

    grep cdkVersion .projenrc.js
}

######################################################################
#<
#
# Function: p6_projen_awesome_pkg()
#
#  Depends:	 p6_echo p6_node
#>
######################################################################
p6_projen_awesome_pkg() {

    if p6_node_yarn_is; then
        p6_echo "yarn"
    elif p6_node_npm_is; then
        p6_echo "npm"
    else
        p6_echo "idk"
    fi
}

######################################################################
#<
#
# Function: p6_projen_awesome_type()
#
#>
######################################################################
p6_projen_awesome_type() {

    grep -o "new .*({" .projenrc.js | awk '{print $2}' | sed -e 's/({//'
}

######################################################################
#<
#
# Function: p6_projen_awesome_branch()
#
#  Depends:	 p6_git
#>
######################################################################
p6_projen_awesome_branch() {

    grep defaultReleaseBranch: .projenrc.js | sed -e 's/.*://'
}

######################################################################
#<
#
# Function: p6_projen_awesome_diff()
#
#  Depends:	 p6_git
#>
######################################################################
p6_projen_awesome_diff() {

    p6_git_p6_diff
}

######################################################################
#<
#
# Function: p6_projen_awesome_synthesize()
#
#  Depends:	 p6_git
#>
######################################################################
p6_projen_awesome_synthesize() {

    npx projen
}

######################################################################
#<
#
# Function: p6_projen_awesome_build()
#
#  Depends:	 p6_git
#>
######################################################################
p6_projen_awesome_build() {

    npx projen build
}

######################################################################
#<
#
# Function: p6_projen_awesome_upgrade()
#
#  Depends:	 p6_git
#>
######################################################################
p6_projen_awesome_upgrade() {

    npx projen projen:upgrade
}

######################################################################
#<
#
# Function: p6_projen_awesome_submit()
#
#  Depends:	 p6_git p6_github
#>
######################################################################
p6_projen_awesome_submit() {

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
# Function: p6__pad(str, length)
#
#  Args:
#	str -
#	length -
#
#  Environment:	 MP6
#>
######################################################################
p6__pad() {
    local str="$1"
    local length="$2"

    perl -MP6::Util -e "print P6::Util::rprint($length, \"$str\")"
}
