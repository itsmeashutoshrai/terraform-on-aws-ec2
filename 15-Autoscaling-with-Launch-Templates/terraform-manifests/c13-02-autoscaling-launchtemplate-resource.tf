# Launch Template Resource
resource "aws_launch_template" "my_launch_template" {
  name = "my-launch-template"
  description = "My Launch template"
  image_id = data.aws_ami.amzlinux2.id
  instance_type = var.instance_type

  vpc_security_group_ids = [ module.private_sg.security_group_id ]
  key_name = var.instance_keypair
  user_data = filebase64("${path.module}/app1-install.sh")
  ebs_optimized = true  #EBS optimization is enabled.
  #default_version = 1 
  update_default_version = true #The Launch Template is set to update its default version automatically.
  #An EBS volume is configured with a 20GB size, set to be deleted on instance termination.
  # They are called "block" devices because they support reading and writing data in fixed-size blocks.
  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      #volume_size = 10      
      volume_size = 20 # LT Update Testing - Version 2 of LT              
      delete_on_termination = true
      volume_type = "gp2" # default  is gp2 
    }
   }
  monitoring {
    enabled = true
  }
  #Instances launched from this template will be tagged with the name "myasg".   
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "myasg"
    }
  }  
  
}
/*
#In AWS, block devices typically refer to:

Instance store volumes: These are physically attached to the host computer where the EC2 instance runs. They provide temporary block-level storage.

EBS (Elastic Block Store) volumes: These are network-attached storage devices that persist independently from the life of an instance.

EBS optimization provides dedicated throughput between Amazon EC2 and Amazon EBS, which can significantly improve the performance of EBS volumes. By setting this to true, you're ensuring that the EC2 instances launched by your Auto Scaling group will have optimized EBS performance.This is a good practice when you need consistent and predictable storage performance for your applications, especially those that are I/O intensive.
*/
