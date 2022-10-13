# --- compute/main.tf ---

resource "openstack_networking_secgroup_v2" "security_group" {
  name        = "${var.project}-${var.environment}-secgroup"
  description = "Managed by Terraform!"
}

# Allow ICMP from University network
resource "openstack_networking_secgroup_rule_v2" "security_group_rule_university_icmp" {
  description       = "Managed by Terraform!"
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "icmp"
  remote_ip_prefix  = local.university.network.cidr
  security_group_id = openstack_networking_secgroup_v2.security_group.id
}

# Allow UDP from University network
resource "openstack_networking_secgroup_rule_v2" "security_group_rule_university_udp" {
  description       = "Managed by Terraform!"
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "udp"
  remote_ip_prefix  = local.university.network.cidr
  security_group_id = openstack_networking_secgroup_v2.security_group.id
}

# Allow TCP from University network
resource "openstack_networking_secgroup_rule_v2" "security_group_rule_university_tcp" {
  description       = "Managed by Terraform!"
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  remote_ip_prefix  = local.university.network.cidr
  security_group_id = openstack_networking_secgroup_v2.security_group.id
}

# Allow ICMP from your public IP address
resource "openstack_networking_secgroup_rule_v2" "security_group_rule_icmp" {
  description       = "Managed by Terraform!"
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "icmp"
  remote_ip_prefix  = var.remote_ip_prefix
  security_group_id = openstack_networking_secgroup_v2.security_group.id
}

# Allow UDP from your public IP address
resource "openstack_networking_secgroup_rule_v2" "security_group_rule_udp" {
  description       = "Managed by Terraform!"
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "udp"
  remote_ip_prefix  = var.remote_ip_prefix
  security_group_id = openstack_networking_secgroup_v2.security_group.id
}

# Allow ALL TCP from your public IP address
resource "openstack_networking_secgroup_rule_v2" "security_group_rule_tcp" {
  description       = "Managed by Terraform!"
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  remote_ip_prefix  = var.remote_ip_prefix
  security_group_id = openstack_networking_secgroup_v2.security_group.id
}

# Create Virtual Machine
resource "openstack_compute_instance_v2" "instance" {
  name            = "${var.project}-${var.environment}-instance"
  image_id        = local.image.ubuntu.id
  flavor_id       = var.flavor_id
  key_pair        = var.key_pair_name
  security_groups = [openstack_networking_secgroup_v2.security_group.name]

  user_data = file(var.script_file_path)

  network {
    name = var.network_name
  }
}