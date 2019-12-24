# Font:
# https://www.terraform.io/docs/providers/aws/index.html
# http://blog.aeciopires.com/conhecendo-o-terraform/
# https://blog.gruntwork.io/an-introduction-to-terraform-f17df9c6d180
# https://aws.amazon.com/blogs/apn/terraform-beyond-the-basics-with-aws/
# https://read.acloud.guru/building-a-highly-scalable-resilient-rest-api-with-terraform-go-and-aws-94377b90fd24
# https://terraformbook.com
# http://www.steamhaus.co.uk/wp-content/uploads/2017/03/Infrastructure-as-Code.pdf
# https://www.guug.de/veranstaltungen/ffg2016/slides/Martin%20Sch%C3%BCtte%20-%20Terraform,%20Config%20Management%20for%20Cloud%20Services.pdf
# https://github.com/salizzar/terraform-aws-docker/
#------------------------------------------------

# Create Instance 1
resource "aws_instance" "registry" {
  count                       = 1
  instance_type               = var.machine_type
  ami                         = var.operating_system
  key_name                    = aws_key_pair.my_key.key_name
  associate_public_ip_address = true
  security_groups             = [ aws_security_group.instance.name ]
  
  connection {
    type        = var.aws_connection_type
    user        = var.aws_instance_user
    private_key = file(var.aws_key_path)
    host        = aws_instance.registry.*.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo curl -fsSL https://get.docker.com -o get-docker.sh",
      "sudo sh get-docker.sh",
      "sudo usermod -aG docker ubuntu"
    ]
  }

  tags = {
    Name = "registry, terraform, test, docker, aws"
  }
}

resource "aws_key_pair" "my_key"{
  key_name    = "my_key"
  public_key  = file("/home/deo/aws-teste.pub")
}

# Create Security Group
resource "aws_security_group" "instance" {
  name        = "terraform_security_group"
  description = "AWS security group for terraform"
  
  ingress {
    from_port   = var.port_ssh_external
    to_port     = var.port_ssh_external
    protocol    = var.port_protocol
    cidr_blocks = ["179.159.236.149/32"]
  }

  ingress {
    from_port   = var.port_http_external
    to_port     = var.port_http_external
    protocol    = var.port_protocol
    cidr_blocks = ["179.159.236.149/32"]     # any source
  }

  egress {
      from_port   = 0               # any port
      to_port     = 0               # any port
      protocol    = "-1"            # any protocol
      cidr_blocks = ["0.0.0.0/0"]   # any destination
    }

  tags = {
    Name = "registry, terraform, test, docker, aws"
  }
}
