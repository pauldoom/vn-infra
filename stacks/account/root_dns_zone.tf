locals {
  # Gross!  See https://github.com/hashicorp/terraform/issues/22405#issuecomment-625619906
  static_dns_records = try(
    var.static_dns_record_file == "" ? tomap(false) : yamldecode(file(var.static_dns_record_file)),
  [])
}
module "root_dns_zone" {
  source         = "../../modules/root_dns_zone"
  region         = var.region
  root_zone      = var.root_zone
  static_records = local.static_dns_records
}
