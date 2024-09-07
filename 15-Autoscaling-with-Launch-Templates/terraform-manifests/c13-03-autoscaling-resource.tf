# Autoscaling Group Resource
resource "aws_autoscaling_group" "my_asg" {
  name_prefix = "myasg-"
  desired_capacity = 2
  max_size = 10
  min_size = 2
  #List of subnet IDs to launch resources in. Subnets automatically determine which availability zones the group will reside.
  vpc_zone_identifier = module.vpc.private_subnets
  
  # Change-1: ALB Module upgraded to 9.4.0 
  #Set of aws_alb_target_group ARNs, for use with Application or Network Load Balancing. 
  #target_group_arns = module.alb.target_group_arns 
  target_group_arns = [module.alb.target_groups["mytg1"].arn] # UPDATED 
  
  health_check_type = "EC2"
  #health_check_grace_period = 300 # default is 300 seconds
  launch_template {
    id = aws_launch_template.my_launch_template.id 
    version = aws_launch_template.my_launch_template.latest_version
  }
  /*Instance Refresh #If this block is configured, start an Instance Refresh when this Auto Scaling Group is updated
  A refresh is started when any of the following Auto Scaling Group properties change: launch_configuration, launch_template, mixed_instances_policy. Additional properties can be specified in the triggers property of instance_refresh
  A refresh will not start when version = "$Latest" is configured in the launch_template block. To trigger the instance refresh when a launch template is changed, configure version to use the latest_version attribute of the aws_launch_template resource.*/
  instance_refresh {
    strategy = "Rolling" #Strategy to use for instance refresh. The only allowed value is Rolling
    preferences {
      # instance_warmup = 300 # Number of seconds until a newly launched instance is configured and ready to use.Default behavior is to use the Auto Scaling Groups health check grace period value
      min_healthy_percentage = 50            
    }
    triggers = [ "desired_capacity" ] # You can add any argument from ASG here, if those has changes, ASG Instance Refresh will trigger   
  }
  tag {
    key                 = "Owners"
    value               = "Web-Team"
    propagate_at_launch = true
  }
}
