###### Target Tracking Scaling Policies ######
# TTS - Scaling Policy-1: Based on CPU Utilization
# Define Autoscaling Policies and Associate them to Autoscaling Group
resource "aws_autoscaling_policy" "avg_cpu_policy_greater_than_xx" {
  name                   = "avg-cpu-policy-greater-than-xx"
  policy_type = "TargetTrackingScaling" # Important Note: The policy type, either "SimpleScaling", "StepScaling" or "TargetTrackingScaling". If this value isn't provided, AWS will default to "SimpleScaling."    
  autoscaling_group_name = aws_autoscaling_group.my_asg.id 
  estimated_instance_warmup = 180 # defaults to ASG default cooldown 300 seconds if not set
  # CPU Utilization is above 50
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 50.0
  }  
 
}

# TTS - Scaling Policy-2: Based on ALB Target Requests
resource "aws_autoscaling_policy" "alb_target_requests_greater_than_yy" {
  name                   = "alb-target-requests-greater-than-yy"
  policy_type = "TargetTrackingScaling" # Important Note: The policy type, either "SimpleScaling", "StepScaling" or "TargetTrackingScaling". If this value isn't provided, AWS will default to "SimpleScaling."    
  autoscaling_group_name = aws_autoscaling_group.my_asg.id 
  estimated_instance_warmup = 120 # defaults to ASG default cooldown 300 seconds if not set  
  # Number of requests > 10 completed per target in an Application Load Balancer target group.
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ALBRequestCountPerTarget"
      
      # Change-2: ALB Module upgraded to 9.4.0 
      #resource_label =  "${module.alb.lb_arn_suffix}/${module.alb.target_group_arn_suffixes[0]}"    
      resource_label =  "${module.alb.arn_suffix}/${module.alb.target_groups["mytg1"].arn_suffix}"  # UPDATED 
    }  
    target_value = 10.0
  }    
}

# Updated 
output "asg_build_resource_label" {
  value =  "${module.alb.arn_suffix}/${module.alb.target_groups["mytg1"].arn_suffix}"  
}
/*Yes, I can provide information about the file c13-06-autoscaling-ttsp.tf in the terraform-on-aws-ec2 project. This file contains Terraform configurations for setting up Target Tracking Scaling Policies (TTSP) for an Auto Scaling Group (ASG) in AWS.

The file defines two auto scaling policies:

A policy based on CPU utilization (avg_cpu_policy_greater_than_xx):

It uses the "TargetTrackingScaling" policy type.
It targets an average CPU utilization of 50%.
The estimated instance warmup time is set to 180 seconds.
A policy based on ALB target requests (alb_target_requests_greater_than_yy):

It also uses the "TargetTrackingScaling" policy type.
It targets 10 requests per target in the Application Load Balancer target group.
The estimated instance warmup time is set to 120 seconds.
The file also includes an updated resource label for the ALB target group, which is used in the second policy and output as "asg_build_resource_label".

This configuration allows the Auto Scaling Group to automatically adjust the number of EC2 instances based on CPU utilization and ALB request count, helping to maintain performance and manage costs efficiently.

This means that the Auto Scaling group will automatically add or remove EC2 instances to maintain an average CPU utilization as close to 50% as possible. If the utilization goes above 50%, it will add instances, and if it drops significantly below 50%, it may remove instances, always aiming to keep the metric close to the target value.





Claude 3.5 Sonnet
The '/' in the resource_label is a separator used to combine two distinct parts of the label:

The ALB's ARN suffix: ${module.alb.arn_suffix}
The target group's ARN suffix: ${module.alb.target_groups["mytg1"].arn_suffix}
This forward slash (/) is used to create a hierarchical structure in the resource label, effectively indicating that the target group is a sub-resource of the ALB. This format is required by AWS to uniquely identify the specific ALB target group for which the auto scaling policy should track request counts.

The resulting label might look something like this in practice: app/my-load-balancer/1234567890/target-group/my-targets/abcdef123456

This format allows AWS to precisely locate and monitor the correct resources for the auto scaling policy.*/
