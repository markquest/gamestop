#Create security groups for master node

resource "aws_security_group" "control-plane-sec-grp" {
    description = "Enable master node ports; 6443:kubeapi, 2379-2380 :etcd, 10250:kubelet, 10259:kube-scheudler, 10257 :kube-controller-manager"
    vpc_id = var.vpc_id

    ingress {
        description = "kubernetes api server"
        from_port = 6443
        to_port = 6443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "etcd"
        from_port = 2379
        to_port = 2380
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "kubelet-api"
        from_port = 10250
        to_port = 10250
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "kube-scheduler"
        from_port = 10259
        to_port = 10259
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "kube-controller"
        from_port = 10257
        to_port = 10257
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    
    
    ingress {
      protocol = "tcp"
      from_port = 22
      to_port = 22
      cidr_blocks = ["0.0.0.0/0"]
    }
    
    egress{
      protocol = "-1"
      from_port = 0
      to_port = 0
      cidr_blocks = ["0.0.0.0/0"]
    }

}


#Create security groups for worker node

resource "aws_security_group" "worker-node-sec-grp" {
    description = "Enable worker node ports;  10250:kubelet, 30000-32767:nodeport services"
    vpc_id = var.vpc_id

    ingress {
        description = "kubelet api"
        from_port = 10250
        to_port = 10250
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "nodeport services"
        from_port = 30000
        to_port = 32767
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    
    ingress {
      protocol = "tcp"
      from_port = 22
      to_port = 22
      cidr_blocks = ["0.0.0.0/0"]
    }

    egress{
      protocol = "-1"
      from_port = 0
      to_port = 0
      cidr_blocks = ["0.0.0.0/0"]
    }
}

