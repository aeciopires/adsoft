include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "postgresql" {
  path   = find_in_parent_folders("postgresql.hcl")
  expose = true
}

locals {
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  region_vars  = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  region       = local.region_vars.locals.region
}

inputs = {
  
  tier                            = "db-custom-2-8192"
  disk_size                       = 100
  disk_type                       = "PD_SSD"
  zone                            = "${local.region}-b"
  availability_type               = "REGIONAL"
  maintenance_window_day          = 1 # Monday
  maintenance_window_hour         = 9 # GMT-3 => 6 AM
  maintenance_window_update_track = "stable"
  deletion_protection             = true
  deletion_protection_enabled     = true

  database_flags = [
    { name = "cloudsql.iam_authentication", value = "on" },
    { name = "max_connections", value = 250 },
    { name = "track_activity_query_size", value = 4096 },
    { name = "pg_stat_statements.track", value = "all" },
    { name = "pg_stat_statements.max", value = 10000 },
    { name = "pg_stat_statements.track_utility", value = "off" },
    { name = "track_io_timing", value = "on" },
  ]

  ip_configuration = {
    ipv4_enabled       = true
    require_ssl        = false
    ssl_mode           = "ENCRYPTED_ONLY"
    private_network    = null
    allocated_ip_range = null
    authorized_networks = [
      {
        name  = "Home" # CHANGE_HERE
        value = "X.X.X.X/32" # CHANGE_HERE
      },
    ]
  }

  backup_configuration = {
    enabled                        = true
    start_time                     = "09:00" # GMT-3 => 6 AM
    location                       = "us"
    point_in_time_recovery_enabled = true
    transaction_log_retention_days = 7
    retained_backups               = 7
    retention_unit                 = "COUNT"
  }

  /*
     ATTENTION!!! By default, will be create postgres user with random password.
     This user and pass can't be use in application, only for administrative purposes.
     If need, the password of the postgres user can be changed in web console of GCP.
  */
}
