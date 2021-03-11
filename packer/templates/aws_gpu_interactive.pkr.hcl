# If you don't set a default, then you will need to provide the variable
# at run time using the command line, or set it in the environment. For more
# information about the various options for setting variables, see the template
# [reference documentation](https://www.packer.io/docs/templates)
variable "ami_name" {
  type    = string
  default = "sean-interactive"
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
  ami_name           = "Sean Interactive ${local.timestamp}"
  instance_type      = "g4dn.2xlarge"
  region             = "${var.region}"
  vpc_id             = "vpc-0b977615e423f1ca9"
  subnet_id          = "subnet-09bebe1cd9f0d8c98"
  source_ami_filter {
    filters = {
      name                = "offer-nv-ubuntu-18-lts-vGaming-445.47.03-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["679593333241"]
  }
  # tag your security group with "sean" to attach it automatically
  #security_group_filter {
  #  filters = {
  #    "tag:Class" = "sean"
  #  }
  #}
  ssh_username = "ubuntu"
}

# a build block invokes sources and runs provisioning steps on them.
build {
  sources = ["source.amazon-ebs.sean-interactive"]

  provisioner "shell" {
    script = "./packer/scripts/interactive.sh"
    expect_disconnect = true
  }
}
