resource "aws_instance" "k8s-masters" {
  count           = "3"                                                                                                                 #We need at least 3 nodes to build a HA K8s cluster
  ami             = "ami-4bf3d731"                                                                                                      #Centos 7
  instance_type   = "t2.medium"                                                                                                         # K8s requires  2 CPUs + 2GBs per node
  key_name        = "admin"                                                                                                             # SSH Public Key such that I can login
  vpc_security_group_ids = ["${aws_security_group.allow-ssh.id}", "${aws_security_group.k8s-master.id}", "${aws_security_group.allow-out.id}"]

  root_block_device {
    delete_on_termination = "true"
  }
}
