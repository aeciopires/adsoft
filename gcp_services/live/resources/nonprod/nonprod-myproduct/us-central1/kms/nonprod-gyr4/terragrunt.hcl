include "root" {
  path   = find_in_parent_folders("root.hcl")
}

include "kms" {
  path   = find_in_parent_folders("kms.hcl")
  expose = true
}

inputs = {}
