output "control_plane_sec_grp_id" {
    value = aws_security_group.control-plane-sec-grp.id
}

output "worker_node_sec_grp_id" {
    value = aws_security_group.worker-node-sec-grp.id
}
