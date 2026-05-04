variable "hcloud_token" {
  description = "Hetzner Cloud API token"
  type        = string
  sensitive   = true
}

variable "project_name" {
  description = "Project name prefix"
  type        = string
  default     = "mario-platformer"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "lab"
}

variable "ssh_public_key_path" {
  description = "Local SSH public key path"
  type        = string
  default     = "~/.ssh/mario_platformer_lab.pub"
}

variable "allowed_ssh_cidr" {
  description = "CIDR allowed to SSH into servers"
  type        = string
}

variable "primary_location" {
  description = "Primary Hetzner location"
  type        = string
  default     = "fsn1"
}

variable "secondary_location" {
  description = "Secondary Hetzner location"
  type        = string
  default     = "nbg1"
}

variable "jenkins_server_type" {
  type    = string
  default = "cpx22"
}

variable "k3s_server_type" {
  type    = string
  default = "cpx22"
}

variable "sonarqube_server_type" {
  type    = string
  default = "cpx32"
}
