## Create Scheduled Actions
### Create Scheduled Action-1: Increase capacity during business hours
resource "aws_autoscaling_schedule" "increase_capacity_7am" {
  scheduled_action_name  = "increase-capacity-7am"
  min_size               = 2
  max_size               = 10
  desired_capacity       = 8
  start_time             = "2030-03-30T11:00:00Z" # Time should be provided in UTC Timezone (11am UTC = 7AM EST)
  recurrence             = "00 09 * * *"
  autoscaling_group_name = aws_autoscaling_group.my_asg.id 
}
### Create Scheduled Action-2: Decrease capacity during business hours
resource "aws_autoscaling_schedule" "decrease_capacity_5pm" {
  scheduled_action_name  = "decrease-capacity-5pm"
  min_size               = 2
  max_size               = 10
  desired_capacity       = 2
  start_time             = "2030-03-30T21:00:00Z" # Time should be provided in UTC Timezone (9PM UTC = 5PM EST)
  recurrence             = "00 21 * * *"
  autoscaling_group_name = aws_autoscaling_group.my_asg.id
}
/*Certainly! The recurrence parameter in the scheduled actions is set using a cron expression. Here's what you need to know about the recurrence settings in the provided code:

For the "increase_capacity_7am" action: recurrence = "00 09 * * *" This means it will run at 09:00 UTC every day.

For the "decrease_capacity_5pm" action: recurrence = "00 21 * * *" This means it will run at 21:00 UTC every day.

These cron expressions follow the format: "minute hour day_of_month month day_of_week". The asterisks (*) indicate that the action will occur regardless of the day of the month, month, or day of the week.

This setup ensures that the scaling actions occur daily at the specified times, allowing for consistent capacity management based on expected traffic patterns.

*/

