resource "aws_security_group" "sg_world_wide" {
  name = "sg_22"
  vpc_id = "${aws_vpc.vpc.id}"
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    "Environment" = "${var.environment_tag}"
  }
}