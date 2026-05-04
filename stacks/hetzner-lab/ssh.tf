resource "hcloud_ssh_key" "admin" {
  name       = "${var.project_name}-${var.environment}-ssh-key"
  public_key = file(pathexpand(var.ssh_public_key_path))
}
