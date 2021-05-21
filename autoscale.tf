# Setup launch configuration
resource "aws_launch_configuration" "launch_config" {
    name            = var.launch_configuration_name
    image_id        = var.image_id
    instance_type   = var.instance_type
}

# Setup autoscaling group
resource "aws_autoscaling_group" "autoscaling_group" {
    name                        = var.autoscaling_group_name
    max_size                    = 5
    min_size                    = 2
    health_check_grace_period   = 300
    health_check_type           = "EC2"
    desired_capacity            = 5
    force_delete                = true
    vpc_zone_identifier         = ["${aws_subnet.private_subnet.id}"]
    launch_configuration        = aws_launch_configuration.launch_config.name
    lifecycle {
        create_before_destroy   = true
    }
}

# Setup autoscaling policy
resource "aws_autoscaling_policy" "scaling_up" {
    name                    = var.autoscaling_policy_name
    scaling_adjustment      = 4
    adjustment_type         = "ChangeInCapacity"
    autoscaling_group_name  = var.autoscaling_group_name
    cooldown                = 300
}

# Setup alarm to trigger autoscaling
resource "aws_cloudwatch_metric_alarm" "scaling_up" {
    alarm_name      = "cpu_utilization"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    evaluation_periods = "2"
    metric_name = "CPUUtilization"
    namespace = "AWS/EC2"
    period = "120"
    statistic = "Average"
    threshold = "45"
    dimensions = {
        AutoScalingGroupName = aws_autoscaling_group.autoscaling_group.name
    }

    alarm_description = "This metric monitors ec2 cpu utilization"
    alarm_actions = [aws_autoscaling_policy.scaling_up.arn]
}