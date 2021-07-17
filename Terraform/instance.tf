data "aws_ami" "amazon-2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
  owners = ["amazon"]
}

resource "aws_instance" "server" {
  depends_on = [
    aws_db_instance.acg-db,
    aws_elasticache_cluster.acg-redis
  ]

  ami                         = data.aws_ami.amazon-2.id
  associate_public_ip_address = true
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.keypair.key_name
  subnet_id                   = aws_subnet.public.id
  user_data                   = file("user-data.sh")
  vpc_security_group_ids      = [aws_security_group.public-sg.id]

  provisioner "file" {
    source      = "user-data.sh"
    destination = "/tmp/user-data.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/user-data.sh",
      "sudo /tmp/user-data.sh",
    ]
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = tls_private_key.key.private_key_pem
    host        = self.public_ip
  }
}


resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "keypair" {
  key_name_prefix = var.username
  public_key      = tls_private_key.key.public_key_openssh
}

output "server_public_ip" {
  value = aws_instance.server.public_ip
}


