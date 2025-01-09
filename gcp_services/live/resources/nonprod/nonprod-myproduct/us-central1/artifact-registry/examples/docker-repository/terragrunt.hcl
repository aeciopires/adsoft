include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "artifact-registry" {
  path   = find_in_parent_folders("artifact-registry.hcl")
  expose = true
}

locals {}

inputs = {}
