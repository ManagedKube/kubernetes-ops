output "trust_anchor_arn" {
    value = aws_rolesanywhere_trust_anchor.trust_anchor[*].arn
}

output "trust_anchor_id" {
    value = aws_rolesanywhere_trust_anchor.trust_anchor[*].id
}

output "profile_arn" {
    value = aws_rolesanywhere_profile.profile[*].arn
}

output "profile_id" {
    value = aws_rolesanywhere_profile.profile[*].id
}