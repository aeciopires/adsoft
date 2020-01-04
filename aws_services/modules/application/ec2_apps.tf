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

# Create Instance Apps
resource "aws_instance" "apps" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.small"
  key_name                    = aws_key_pair.my_key.key_name
  subnet_id                   = aws_subnet.prod_subnet_public1.id
  associate_public_ip_address = true
  #security_groups             = [ aws_security_group.services.name ]
  vpc_security_group_ids      = [ aws_security_group.services.id ]
  user_data                   = file("install_docker_apps.sh")
  availability_zone           = data.aws_availability_zones.available.names[0]

  connection {
    user        = var.aws_instance_user
    private_key = file(var.aws_key_private_path)
  }

  tags = {
    Name = "apps, python, nodejs, test, docker, aws"
  }
}