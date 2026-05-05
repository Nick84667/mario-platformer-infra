output "jenkins_public_ip" {
  value = hcloud_server.jenkins.ipv4_address
}

output "jenkins_private_ip" {
  value = "10.10.1.10"
}

output "k3s_public_ip" {
  value = hcloud_server.k3s.ipv4_address
}

output "k3s_private_ip" {
  value = "10.10.1.20"
}

output "sonarqube_public_ip" {
  value = hcloud_server.sonarqube.ipv4_address
}

output "sonarqube_private_ip" {
  value = "10.10.1.30"
}

output "ssh_command_jenkins" {
  value = "ssh -i ~/.ssh/mario_platformer_lab root@${hcloud_server.jenkins.ipv4_address}"
}

output "ssh_command_k3s" {
  value = "ssh -i ~/.ssh/mario_platformer_lab root@${hcloud_server.k3s.ipv4_address}"
}

output "ssh_command_sonarqube" {
  value = "ssh -i ~/.ssh/mario_platformer_lab root@${hcloud_server.sonarqube.ipv4_address}"
}

output "jenkins_url" {
  value = "http://${hcloud_server.jenkins.ipv4_address}:8080"
}

output "sonarqube_url" {
  value = "http://${hcloud_server.sonarqube.ipv4_address}:9000"
}

output "k3s_api_private_url" {
  value = "https://10.10.1.20:6443"
}

output "jenkins_kubeconfig_path" {
  value = "/var/lib/jenkins/.kube/config"
}

