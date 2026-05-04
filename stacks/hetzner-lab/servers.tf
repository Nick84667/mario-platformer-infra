resource "hcloud_server" "jenkins" {
  name         = "${var.project_name}-${var.environment}-jenkins"
  image        = "ubuntu-24.04"
  server_type  = var.jenkins_server_type
  location     = var.primary_location
  ssh_keys     = [hcloud_ssh_key.admin.id]
  firewall_ids = [hcloud_firewall.base.id]

  labels = {
    project     = var.project_name
    environment = var.environment
    role        = "jenkins"
  }

  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }

  network {
    network_id = hcloud_network.main.id
    ip         = "10.10.1.10"
  }

  depends_on = [hcloud_network_subnet.main]
}

resource "hcloud_server" "k3s" {
  name         = "${var.project_name}-${var.environment}-k3s"
  image        = "ubuntu-24.04"
  server_type  = var.k3s_server_type
  location     = var.primary_location
  ssh_keys     = [hcloud_ssh_key.admin.id]
  firewall_ids = [hcloud_firewall.base.id]

  labels = {
    project     = var.project_name
    environment = var.environment
    role        = "k3s"
  }

  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }

  network {
    network_id = hcloud_network.main.id
    ip         = "10.10.1.20"
  }

  depends_on = [hcloud_network_subnet.main]
}

resource "hcloud_server" "sonarqube" {
  name         = "${var.project_name}-${var.environment}-sonarqube"
  image        = "ubuntu-24.04"
  server_type  = var.sonarqube_server_type
  location     = var.secondary_location
  ssh_keys     = [hcloud_ssh_key.admin.id]
  firewall_ids = [hcloud_firewall.base.id]

  labels = {
    project     = var.project_name
    environment = var.environment
    role        = "sonarqube"
  }

  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }

  network {
    network_id = hcloud_network.main.id
    ip         = "10.10.1.30"
  }

  depends_on = [hcloud_network_subnet.main]
}
