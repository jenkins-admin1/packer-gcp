variable "project_id" {
  type    = string
  default = "prj-dev-app1-1729"
}

variable "zone" {
  type    = string
  default = "us-central1-a"
}

variable "disk-size" {
  type    = number
  default = 400
}

variable "dry_run" {
  type    = bool
  default = false
}

variable "app_short_name" {
  type    = string
  default = "app1"
}

variable "install_script_url" {
  type    = string
  default = "https://go.microsoft.com/fwlink/?linkid=2114707"
}

locals {
    instance_name = "vm-packer-${uuidv4()}"
    packerstarttime = formatdate("YYYY-MM-DD-h'h'mm'ss's", timestamp ())
    source_image = "windows-server-2019-dc-v20200813"
    #source_image_family = "windows-2019-datacenter"
    image_family = "${local.source_image_family}-app1"
    image_name = "${local.image_family}-${local.packerstarttime}"
}

source "googlecompute" "packer-image" {
  project_id  = var.project_id
  use_internal_ip = true
  omit_external_ip = true
  enable_secure_boot = true
  #source_image_name  = local.source_image_family
  source_image = local.source_image
  image_family = local.image_family
  zone = var.zone
  disk_size = var.disk_size
  machine_type = "e2-medium"
  communicator ="winrm"
  skip_create_image = var.dry_run
  instance_name = local.instance_name
  image_name = local.image_name
  image_labels = {
    "ami":local.image_family,
    "app_short_name":var.app_short_name
  }
  labels ={
    "app_short_name":var.app_short_name
  }
  tags = ["packer"]
  metadata ={
    windows-startup-script-ps1 = <<-EOT
    EOT
  }
}

build {
  sources = ["source.googlecompute.packer-image"]

  provisioner "shell" {
    inline = [
      "curl -L '${var.install_script_url}' -o office.exe",
      "Start-Process -Wait .\\office.exe /configure install.xml",
      "del office.exe install.xml"
    ]
  }
}
