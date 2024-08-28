# Create a Null Resource and Provisioners
resource "null_resource" "name" {
  depends_on = [module.ec2_public]
  # Connection Block for Provisioners to connect to EC2 Instance
  connection {
    type     = "ssh"
    host     = aws_eip.bastion_eip.public_ip    
    user     = "ec2-user"
    password = ""
    private_key = file("private-key/terraform-key.pem")
  }  

## File Provisioner: Copies the terraform-key.pem file to /tmp/terraform-key.pem
  provisioner "file" {
    source      = "private-key/terraform-key.pem"
    destination = "/tmp/terraform-key.pem"
  }
## Remote Exec Provisioner: Using remote-exec provisioner fix the private key permissions on Bastion Host
  provisioner "remote-exec" {
    inline = [
      "sudo chmod 400 /tmp/terraform-key.pem"
    ]
  }
## Local Exec Provisioner:  local-exec provisioner (Creation-Time Provisioner - Triggered during Create Resource)
  provisioner "local-exec" {
    command = "echo VPC created on `date` and VPC ID: ${module.vpc.vpc_id} >> creation-time-vpc-id.txt"
    working_dir = "local-exec-output-files/"
    #on_failure = continue
  }
## Local Exec Provisioner:  local-exec provisioner (Destroy-Time Provisioner - Triggered during deletion of Resource)
/*  provisioner "local-exec" {
    command = "echo Destroy time prov `date` >> destroy-time-prov.txt"
    working_dir = "local-exec-output-files/"
    when = destroy
    #on_failure = continue
  }  
  */

}

# Creation Time Provisioners - By default they are created during resource creations (terraform apply)
# Destory Time Provisioners - Will be executed during "terraform destroy" command (when = destroy)
/*
Certainly! I'd be happy to discuss the content of the file "c9-nullresource-provisioners.tf" in the terraform project. This file defines a null_resource with several provisioners:

It creates a null_resource named "name" that depends on the "ec2_public" module.

It sets up a connection block for SSH access to the EC2 instance using the bastion host's Elastic IP.

It includes a file provisioner that copies a private key file to the EC2 instance.

A remote-exec provisioner is used to set the correct permissions on the copied private key.

A local-exec provisioner is defined to run a command locally that logs the VPC creation time and ID.

There's a commented-out local-exec provisioner for destroy-time actions.

This setup allows for various actions to be performed during resource creation and potentially during destruction, demonstrating the flexibility of Terraform's provisioners. The null_resource is often used as a way to run provisioners without being directly associated with a specific resource.*/