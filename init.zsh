######################################################################
#<
#
# Function: p6df::modules::p6projen::deps()
#
#>
######################################################################
p6df::modules::p6projen::deps() {
  ModuleDeps=(
    p6m7g8/p6common
  )
}

######################################################################
#<
#
# Function: p6df::modules::p6projen::init()
#
#>
######################################################################
p6df::modules::p6projen::init() {

  local dir="$P6_DFZ_SRC_DIR/p6m7g8/p6projen"
  p6_bootstrap "$dir"
}