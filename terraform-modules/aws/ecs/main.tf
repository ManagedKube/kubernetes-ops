resource "aws_ecs_service" "mongo" {
  name            = var.ecs_name
  cluster         = aws_ecs_cluster.foo.id
  task_definition = aws_ecs_task_definition.mongo.arn
  desired_count   = var.desired_count
  iam_role        = aws_iam_role.foo.arn
  depends_on      = [aws_iam_role_policy.foo]
  launch_type     = var.launch_type

  ordered_placement_strategy = var.ordered_placement_strategy

  load_balancer {
    target_group_arn = aws_lb_target_group.foo.arn
    container_name   = "mongo"
    container_port   = 8080
  }

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [us-west-2a, us-west-2b]"
  }
}

resource "aws_ecs_cluster" "foo" {
  name = "white-hart"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}