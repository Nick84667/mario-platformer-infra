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

variable "k3s_token" {
  description = "Shared token used by K3s."
  type        = string
  sensitive   = true
}

variable "sonar_db_password" {
  description = "Password for SonarQube PostgreSQL database."
  type        = string
  sensitive   = true
}

variable "node_version" {
  description = "Node.js major version installed on Jenkins."
  type        = string
  default     = "20"
}

variable "ssh_private_key_path" {
  description = "Local SSH private key path used by Terraform post-provisioning steps"
  type        = string
  default     = "~/.ssh/mario_platformer_lab"
}

variable "jenkins_location" {
  description = "Hetzner location for Jenkins server"
  type        = string
  default     = "fsn1"
}

variable "k3s_location" {
  description = "Hetzner location for K3s server"
  type        = string
  default     = "nbg1"
}

variable "sonarqube_location" {
  description = "Hetzner location for SonarQube server"
  type        = string
  default     = "hel1"
}

variable "local_bash_path" {
  description = "Local Windows path to Git Bash executable used by Terraform local-exec"
  type        = string
}
