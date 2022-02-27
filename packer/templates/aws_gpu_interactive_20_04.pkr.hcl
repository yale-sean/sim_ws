# If you don't set a default, then you will need to provide the variable
# at run time using the command line, or set it in the environment. For more
# information about the various options for setting variables, see the template
# [reference documentation](https://www.packer.io/docs/templates)
variable "ami_name" {
  type    = string
  default = "sean-interactive-20-04"
}

locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

variable "region" {
  type    = string
  default = "us-east-1"
}

# source blocks configure your builder plugins; your source is then used inside
# build blocks to create resources. A build block runs provisioners and
# post-processors on an instance created by the source.
source "amazon-ebs" "sean-interactive" {
  ami_name           = "Sean Interactive 20.04 ${local.timestamp}"
  instance_type      = "g4dn.xlarge"
  region             = "${var.region}"
  vpc_id             = "vpc-01916136e3c9d5a4d"
  subnet_id          = "subnet-00a6ae5ab97a03325"
  source_ami         = "ami-04cc2b0ad9e30a9c8"
  # tag your security group with "sean" to attach it automatically
  #security_group_filter {
  #  filters = {
  #    "tag:Class" = "sean"
  #  }
  #}
  ssh_username = "ubuntu"
  iam_instance_profile = "S3InstanceReadOnly"
}

# a build block invokes sources and runs provisioning steps on them.
build {
  sources = ["source.amazon-ebs.sean-interactive"]

  provisioner "shell" {
    script = "./packer/scripts/interactive.sh"
    expect_disconnect = true
  }
}
