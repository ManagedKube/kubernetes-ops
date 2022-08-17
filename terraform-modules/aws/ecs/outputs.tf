output "cluster_name" {
    value = aws_ecs_service.mongo.name
}

output "cluster_arn" {
    value = aws_ecs_service.mongo.arn
}