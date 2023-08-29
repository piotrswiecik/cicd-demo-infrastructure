resource "local_file" "ansible_inventory" {
  content = templatefile("inventory.tftpl", {
    controller_ip_addr     = aws_instance.jenkins_controller.public_ip
    agent_ip_addrs         = [for instance in aws_instance.jenkins_agent : instance.public_ip]
    sonar_ip_addr          = aws_instance.sonarqube.public_ip
    controller_ssh_keyfile = local_file.jenkins_controller_key.filename
    agent_ssh_keyfile      = local_file.jenkins_agent_key.filename
    sonar_ssh_keyfile      = local_file.sonarqube_key.filename
  })
  filename        = format("%s/%s", abspath(path.root), "inventory")
  file_permission = "0600"
}