resource "hcloud_firewall" "base" {
  name = "${var.project_name}-${var.environment}-base-fw"

  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "22"
    source_ips = [var.allowed_ssh_cidr]
  }

  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "8080"
    source_ips = [var.allowed_ssh_cidr]
  }

  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "9000"
    source_ips = [var.allowed_ssh_cidr]
  }

  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "80"
    source_ips = ["0.0.0.0/0", "::/0"]
  }

  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "443"
    source_ips = ["0.0.0.0/0", "::/0"]
  }
}
