resource "hcloud_server" "jenkins" {
  name         = "${var.project_name}-${var.environment}-jenkins"
  image        = "ubuntu-24.04"
  server_type  = var.jenkins_server_type
  location     = var.jenkins_location
  ssh_keys     = [hcloud_ssh_key.admin.id]
  firewall_ids = [hcloud_firewall.base.id]

  user_data = templatefile("${path.module}/cloud-init/jenkins.yaml.tftpl", {
    project_name     = var.project_name
    environment      = var.environment
    node_version     = var.node_version
    k3s_private_ip   = "10.10.1.20"
    sonar_private_ip = "10.10.1.30"
  })

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
  location     = var.k3s_location
  ssh_keys     = [hcloud_ssh_key.admin.id]
  firewall_ids = [hcloud_firewall.base.id]

  user_data = templatefile("${path.module}/cloud-init/k3s.yaml.tftpl", {
    project_name = var.project_name
    environment  = var.environment
    k3s_token    = var.k3s_token
  })

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
  location     = var.sonarqube_location
  ssh_keys     = [hcloud_ssh_key.admin.id]
  firewall_ids = [hcloud_firewall.base.id]

  user_data = templatefile("${path.module}/cloud-init/sonarqube.yaml.tftpl", {
    project_name      = var.project_name
    environment       = var.environment
    sonar_db_password = var.sonar_db_password
  })

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
