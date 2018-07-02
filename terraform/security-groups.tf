resource "aws_security_group" "allow-out" {
  name        = "allow-out"
  description = "All egress traffic"

  egress {
    from_port   = 0             #All Ports
    to_port     = 0             #All Ports
    protocol    = "-1"          #All Protocol
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "allow-ssh" {
  name        = "allow-ssh"
  description = "Allow SSH from everywhere"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "k8s-master" {
  name        = "k8s-master"
  description = "Ingress traffic required for k8s master nodes"

  ingress {
    description = "K8s API Server Port"
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ETCD Server Client Ports"
    from_port   = 2379
    to_port     = 2380
    protocol    = "tcp"
    self        = "true"
  }

  ingress {
    description = "Kubelet API Port"
    from_port   = 10250
    to_port     = 10250
    protocol    = "tcp"
    self        = "true"
  }

  ingress {
    description = "Kube-scheduler"
    from_port   = 10251
    to_port     = 10251
    protocol    = "tcp"
    self        = "true"
  }

  ingress {
    description = "kube-controller-manager"
    from_port   = 10252
    to_port     = 10252
    protocol    = "tcp"
    self        = "true"
  }

  ingress {
    description = "Read-only kubelet API"
    from_port   = 10255
    to_port     = 10255
    protocol    = "tcp"
    self        = "true"
  }
}

resource "aws_security_group" "k8s-worker" {
  name        = "k8s-worker"
  description = "K8s work nodes security group"

  ingress {
    description     = "Kubelet API"
    from_port       = 10250
    to_port         = 10250
    protocol        = "tcp"
    security_groups = ["${aws_security_group.k8s-master.id}"]
  }

  ingress {
    description     = "Read-only Kubelet API"
    from_port       = 10255
    to_port         = 10255
    protocol        = "tcp"
    security_groups = ["${aws_security_group.k8s-master.id}"]
  }

  ingress {
    description = "NodePort Services"
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
