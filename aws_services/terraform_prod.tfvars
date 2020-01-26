#-------------------------
# Override the values default
#-------------------------

# English:
# See the `variables.tf` file for the usage description and the default values of the following variables

aws_zone                     = "us-east-2"
aws_key_name                 = "aws-teste"
aws_key_private_path         = "/home/aws-teste.pem"
aws_key_public_path          = "/home/aws-teste.pub"
s3_bucket_name               = "adsoft-s3"
aws_instance_user            = "ubuntu"
disk_type                    = "gp2"
port_ssh_external            = 2220
port_registry_external       = 5000
port_grafana_external        = 3000
port_loki_external           = 3100
port_prometheus_external     = 9090
port_zabbix_web_external     = 80
port_zabbix_server_external  = 10051
port_apps_python_external_01 = 8001
port_apps_python_external_02 = 8002
port_apps_crud_api           = 9000
port_apps_nodejs             = 8080
port_protocol                = "TCP"
vpc_cidr_block               = "10.0.0.0/16"
address_allowed              = "179.159.238.101/32"
