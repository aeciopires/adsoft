locals {
  account_vars   = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  region_vars    = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  region         = local.region_vars.locals.region
  env_short_name = local.account_vars.locals.env_short_name
  default_tags   = local.account_vars.locals.default_tags
  project_id     = local.account_vars.locals.project_id
  instance_name  = "${basename(get_terragrunt_dir())}"
}

terraform {
  source = "tfr:///GoogleCloudPlatform/sql-db/google//modules/postgresql?version=25.0.2"
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {

  project_id           = local.project_id
  region               = local.region
  name                 = local.instance_name
  db_name              = "test"
  db_charset           = "UTF8"
  db_collation         = "en_US.UTF8"
  random_instance_name = false
  database_version     = "POSTGRES_17"

  # Master configurations
  tier                            = "db-custom-2-8192"
  disk_autoresize                 = true
  disk_autoresize_limit           = 0
  disk_size                       = 100
  disk_type                       = "PD_SSD"
  zone                            = "${local.region}-a"
  availability_type               = "REGIONAL"
  maintenance_window_day          = 7     # Sunday
  maintenance_window_hour         = 23    # GMT-3 => 8 AM
  maintenance_window_update_track = "stable"

  deletion_protection         = false
  deletion_protection_enabled = false

  database_flags = []

  user_labels = local.default_tags

  ip_configuration = {
    ipv4_enabled       = true
    require_ssl        = false
    ssl_mode           = "ENCRYPTED_ONLY"
    private_network    = null
    allocated_ip_range = null
    authorized_networks = []
  }

  backup_configuration = {
    enabled                        = true
    start_time                     = "23:00"   # GMT-3 => 8 PM
    location                       = "us"
    point_in_time_recovery_enabled = true
    transaction_log_retention_days = 7
    retained_backups               = 7
    retention_unit                 = "COUNT"
  }

  # Uncomment this lines if you want to create read replicas
  #read_replica_name_suffix = ""
  #read_replicas = [
  #  {
  #     name                  = "0"
  #     zone                  = "us-central1-a"
  #     availability_type     = "REGIONAL"
  #     tier                  = "db-custom-1-3840"
  #     ip_configuration      = local.read_replica_ip_configuration
  #     database_flags        = [{ name = "autovacuum", value = "off" }]
  #     disk_autoresize       = null
  #     disk_autoresize_limit = null
  #     disk_size             = null
  #     disk_type             = "PD_SSD"
  #     user_labels           = local.default_tags
  #     encryption_key_name   = null
  #  },
  #]

  /*
     ATTENTION!!! By default, will be create postgres user with random password.
     This user and pass can't be use in application, only for administrative purposes.
     If need, the password of the postgres user can be changed in web console of GCP.
  */
}
