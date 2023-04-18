resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.test-server.id
  allocation_id = "eipalloc-083aadbe2bb30d7b5"
}
resource "aws_instance" "test-server" {
  ami           = "ami-00c39f71452c08778" 
  instance_type = "t2.micro" 
  key_name = "DEMOKEY"
  vpc_security_group_ids= ["sg-0c7aae9017fc5106b"]
  connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = file("./DEMOKEY.pem")
    host     = self.public_ip
  }
  provisioner "remote-exec" {
    inline = [ "echo 'wait to start instance' "]
  }
  tags = {
    Name = "test-server"
  }
 provisioner "local-exec" {

        command = " echo ${aws_instance.test-server.public_ip} > inventory "
 }
 
 provisioner "local-exec" {
 command = "ansible-playbook /var/lib/jenkins/workspace/project-02-banking/test-server/test-bank-playbook.yml "
  } 
}

output "test-server_public_ip" {

  value = aws_eip_association.eip_assoc.public_ip
  
}