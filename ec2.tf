// WireGuard EC2 Instance
resource "aws_instance" "this" {
  ami           = "ami-04f5097681773b989" // Ubuntu ap-southeast-2
  instance_type = "t2.micro"
  key_name      = aws_key_pair.cloudbuild-ec2-key-pair.key_name

  subnet_id = aws_subnet.cloudbuild-vpc-subnet-1.id
  vpc_security_group_ids = [ aws_security_group.cloudbuild-nsg.id ]

  associate_public_ip_address = true

  tags = {
    Name = "cloudbuild-webserver"
  }

  user_data = file("./webserver-setup.sh")
}

// The keypair to be used for SSH
resource "tls_private_key" "tls-key-pair" {
    algorithm = "RSA"
    rsa_bits = 4096
}

resource "aws_key_pair" "cloudbuild-ec2-key-pair" {
    key_name = "cloudbuild-ec2-key-pair"
    public_key = tls_private_key.tls-key-pair.public_key_openssh
}

resource "local_file" "cloudbuild-ec2-key-pair-private" {
    content = trimspace(tls_private_key.tls-key-pair.private_key_pem)
    filename = "${path.module}/cloudbuild.pem"
}