resource "aws_route53_zone" "root_zone" {
  name = replace(var.root_zone, "/\\.?$/", ".")
}
resource "aws_route53_record" "static_records" {
  for_each = { for r in var.static_records :
    join(":", [lower(r.type), r.name]) => r
  }

  name    = each.value.name == "" ? var.root_zone : join(".", [each.value.name, var.root_zone])
  type    = upper(each.value.type)
  ttl     = each.value.ttl == null ? "300" : each.value.ttl
  records = each.value.records
  zone_id = aws_route53_zone.root_zone.zone_id
}

output "root_zone_id" {
  description = "Root Zone ID"
  value       = aws_route53_zone.root_zone.zone_id
}

output "root_zone_nameservers" {
  description = "Root zone NS servers"
  value       = aws_route53_zone.root_zone.name_servers
}
