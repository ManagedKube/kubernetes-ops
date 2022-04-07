output "mongodbatlas_database_user_list" {
    value = mongodbatlas_database_user.this.*.id
}
