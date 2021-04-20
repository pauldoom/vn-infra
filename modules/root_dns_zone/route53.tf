resource "aws_route53_zone" "root_zone" {
  name = replace(var.root_zone, "/\\.?$/", ".")
}

# resource "aws_route53_record" "static_rrs" {
#   for_each = { for n in flatten([
#     for entry in flatten([local.records, var.prod_records]) : [
#       for r in entry.record_set : {
#         type    = entry.type,
#         name    = r.name,
#         ttl     = r.ttl,
#         records = r.records
#       }
#     ]
#   ]) : n.name == "" ? "${n.type}_main" : "${n.type}_${trimsuffix(n.name, ".")}" => n }

#   name    = join("", [each.value.name, var.domain])
#   type    = each.value.type
#   ttl     = each.value.ttl
#   records = each.value.records
#   zone_id = aws_route53_zone.primary.zone_id
# }

output "root_zone_id" {
  description = "Root Zone ID"
  value       = aws_route53_zone.root_zone.zone_id
}

output "root_zone_nameservers" {
  description = "Root zone NS servers"
  value = aws_route53_zone.root_zone.name_servers
}
