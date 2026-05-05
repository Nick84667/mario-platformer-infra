resource "terraform_data" "copy_kubeconfig_to_jenkins" {
  depends_on = [
    hcloud_server.k3s,
    hcloud_server.jenkins
  ]

  triggers_replace = [
    hcloud_server.k3s.id,
    hcloud_server.jenkins.id
  ]

  provisioner "local-exec" {
    interpreter = [var.local_bash_path, "-lc"]

    command = <<EOT
set -euo pipefail

SSH_KEY="$HOME/.ssh/mario_platformer_lab"
K3S_IP="${hcloud_server.k3s.ipv4_address}"
JENKINS_IP="${hcloud_server.jenkins.ipv4_address}"
TMP_KUBECONFIG="/tmp/${var.project_name}-${var.environment}-kubeconfig-jenkins-private.yaml"

echo "[INFO] Using SSH key: $SSH_KEY"
echo "[INFO] K3s public IP: $K3S_IP"
echo "[INFO] Jenkins public IP: $JENKINS_IP"

echo "[INFO] Waiting for SSH on K3s server..."
for i in $(seq 1 90); do
  if ssh -i "$SSH_KEY" -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@$K3S_IP "echo ok" >/dev/null 2>&1; then
    echo "[INFO] K3s SSH is ready."
    break
  fi

  if [ "$i" -eq 90 ]; then
    echo "[ERROR] Timeout waiting for SSH on K3s server."
    exit 1
  fi

  sleep 10
done

echo "[INFO] Waiting for K3s kubeconfig file..."
for i in $(seq 1 90); do
  if ssh -i "$SSH_KEY" -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@$K3S_IP "test -f /root/kubeconfig-jenkins-private.yaml" >/dev/null 2>&1; then
    echo "[INFO] K3s kubeconfig is ready."
    break
  fi

  if [ "$i" -eq 90 ]; then
    echo "[ERROR] Timeout waiting for /root/kubeconfig-jenkins-private.yaml on K3s server."
    ssh -i "$SSH_KEY" -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@$K3S_IP "cloud-init status --long || true"
    ssh -i "$SSH_KEY" -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@$K3S_IP "tail -n 80 /var/log/provision-k3s.log || true"
    exit 1
  fi

  sleep 10
done

echo "[INFO] Waiting for SSH on Jenkins server..."
for i in $(seq 1 90); do
  if ssh -i "$SSH_KEY" -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@$JENKINS_IP "echo ok" >/dev/null 2>&1; then
    echo "[INFO] Jenkins SSH is ready."
    break
  fi

  if [ "$i" -eq 90 ]; then
    echo "[ERROR] Timeout waiting for SSH on Jenkins server."
    exit 1
  fi

  sleep 10
done

echo "[INFO] Waiting for Jenkins user and kubectl..."
for i in $(seq 1 90); do
  if ssh -i "$SSH_KEY" -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@$JENKINS_IP "id jenkins >/dev/null 2>&1 && command -v kubectl >/dev/null 2>&1" >/dev/null 2>&1; then
    echo "[INFO] Jenkins user and kubectl are ready."
    break
  fi

  if [ "$i" -eq 90 ]; then
    echo "[ERROR] Timeout waiting for Jenkins user and kubectl."
    ssh -i "$SSH_KEY" -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@$JENKINS_IP "cloud-init status --long || true"
    ssh -i "$SSH_KEY" -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@$JENKINS_IP "tail -n 80 /var/log/provision-jenkins.log || true"
    exit 1
  fi

  sleep 10
done

echo "[INFO] Downloading kubeconfig from K3s..."
scp -i "$SSH_KEY" -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@$K3S_IP:/root/kubeconfig-jenkins-private.yaml "$TMP_KUBECONFIG"

echo "[INFO] Uploading kubeconfig to Jenkins..."
scp -i "$SSH_KEY" -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "$TMP_KUBECONFIG" root@$JENKINS_IP:/tmp/kubeconfig-jenkins-private.yaml

echo "[INFO] Installing kubeconfig for Jenkins user..."
ssh -i "$SSH_KEY" -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@$JENKINS_IP "
  install -d -o jenkins -g jenkins -m 700 /var/lib/jenkins/.kube
  install -o jenkins -g jenkins -m 600 /tmp/kubeconfig-jenkins-private.yaml /var/lib/jenkins/.kube/config
  rm -f /tmp/kubeconfig-jenkins-private.yaml
"

echo "[INFO] Testing Jenkins -> K3s private API access..."
ssh -i "$SSH_KEY" -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@$JENKINS_IP "
  sudo -u jenkins kubectl --kubeconfig=/var/lib/jenkins/.kube/config get nodes -o wide
"

rm -f "$TMP_KUBECONFIG"

echo "[INFO] Kubeconfig successfully copied to Jenkins."
EOT
  }
}