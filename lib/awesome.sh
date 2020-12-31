######################################################################
#<
#
# Function: words org_repos = p6_projen_awesome_projects_collect()
#
#  Returns:
#	words - org_repos
#
#>
######################################################################
p6_projen_awesome_projects_collect() {

    local org_repos
    org_repos="p6m7g8/p6-account-vending-machine \
p6m7g8/p6-barrier \
p6m7g8/p6-namer \
p6m7g8/p6-projen-project-awesome-list \
p6m7g8/awesome-projen \
trexsolutions/smile-jenkins"

    p6_return_words "$org_repos"
}

#     grep github.com "$awesome_readme_path" | grep -Ev 'projen/projen|ohmyzsh/ohmyzsh' | sort -r | while read -r line; do
#       lines+=($line)
#     done
#   for line in $lines[@]; do
#     local org_repo
#     org_repo=$(echo "$line" | sed -e 's,.*github.com/,,' -e 's,/blob/.*,,')
#     Projects+=($org_repo)
#   done >/dev/null
# }