resource "aws_instance" "nielsen-docker" {
  count = "${var.instance_count}"

  ami           = "${var.ami}"
  instance_type = "${var.instance}"
  key_name      = "${aws_key_pair.ec2key.key_name}"
  availability_zone = "${var.availability_zone}"
  subnet_id = "${aws_subnet.subnet_public.id}"
  vpc_security_group_ids = [
    "${aws_security_group.sg_world_wide.id}"
  ]


  ebs_block_device {
    device_name           = "/dev/sdg"
    volume_size           = 8
    volume_type           = "gp2"
    delete_on_termination = true
  }

  connection {
    private_key = "${file(var.private_key)}"
    user        = "${var.ansible_user}"
  }

  #user_data = "${file("../templates/install_jenkins.sh")}"

  # Ansible requires Python to be installed on the remote machine as well as the local machine.
  provisioner "remote-exec" {
    inline = ["sudo yum install python -y"]
  }

  # This is where we configure the instance with ansible-playbook
  provisioner "local-exec" {
    command = <<EOT
      sleep 30;
	    >nielsen-docker.ini;
	    echo "[nielsen-docker]" | tee -a nielsen-docker.ini;
	    echo "${aws_instance.nielsen-docker.public_ip} ansible_user=${var.ansible_user} ansible_ssh_private_key_file=${var.private_key}" | tee -a nielsen-docker.ini;
      export ANSIBLE_HOST_KEY_CHECKING=False;
	    ansible-playbook -u ${var.ansible_user} --private-key ${var.private_key} -i nielsen-docker.ini ../../../../ansible/install_docker.yaml
    EOT
  }

  provisioner "local-exec" {
    command = <<EOT
	  ansible-playbook -u ${var.ansible_user} --private-key ${var.private_key} -i nielsen-docker.ini ../../../../ansible/deploy_mongodb_container.yaml
    EOT
  }

  provisioner "local-exec" {
    command = <<EOT
	  ansible-playbook -u ${var.ansible_user} --private-key ${var.private_key} -i nielsen-docker.ini ../../../../ansible/install_python_libraries.yaml
    EOT
  }

  provisioner "local-exec" {
    command = <<EOT
	  ansible-playbook -u ${var.ansible_user} --private-key ${var.private_key} -i nielsen-docker.ini ../../../../ansible/run_twitter_streamer.yaml
    EOT
  }

  provisioner "local-exec" {
    command = <<EOT
	  ansible-playbook -u ${var.ansible_user} --private-key ${var.private_key} -i nielsen-docker.ini ../../../../ansible/deploy_apache_php_container.yaml
    EOT
  }

  tags {
    Name     = "nielsen-docker-${count.index +1 }"
    Location = "oregon"
  }
}