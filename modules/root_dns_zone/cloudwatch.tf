resource "aws_cloudwatch_metric_alarm" "dnssec_ksks_needing_attention" {
  alarm_name        = "${aws_route53_zone.root_zone.name}-dnssec_ksks_needing_attention"
  alarm_description = "One or more DNSSEC Key Signing Keys require attention in the last 24 hours - See https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/dns-configuring-dnssec-troubleshoot.html"
  namespace         = "AWS/Route53"
  metric_name       = "DNSSECKeySigningKeysNeedingAction"

  dimensions = {
    HostedZoneId = aws_route53_zone.root_zone.zone_id
  }

  statistic           = "Sum"
  comparison_operator = "GreaterThanThreshold"
  threshold           = 0
  period              = 86400
  evaluation_periods  = 1

  alarm_actions = var.alarm_actions
  ok_actions    = var.alarm_actions
}

resource "aws_cloudwatch_metric_alarm" "dnssec_ksk_age" {
  alarm_name        = "${aws_route53_zone.root_zone.name}-dnssec_ksk_age"
  alarm_description = "One or more DNSSEC Key Signing Keys are over ${var.dnssec_ksk_max_age_days} days old"
  namespace         = "AWS/Route53"
  metric_name       = "DNSSECKeySigningKeyAge"

  dimensions = {
    HostedZoneId = aws_route53_zone.root_zone.zone_id
  }

  statistic           = "Maximum"
  comparison_operator = "GreaterThanThreshold"
  threshold           = var.dnssec_ksk_max_age_days * 24 * 60 * 60
  period              = 86400
  evaluation_periods  = 1
  alarm_actions       = var.alarm_actions
  ok_actions          = var.alarm_actions
}

resource "aws_cloudwatch_metric_alarm" "dnssec_internal_failure" {
  alarm_name        = "${aws_route53_zone.root_zone.name}-dnssec_internal_failure"
  alarm_description = "DNSSEC encountered one or more errors in the last 24 hours - See https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/dns-configuring-dnssec-troubleshoot.html"
  namespace         = "AWS/Route53"
  metric_name       = "DNSSECInternalFailure"

  dimensions = {
    HostedZoneId = aws_route53_zone.root_zone.zone_id
  }

  statistic           = "Sum"
  comparison_operator = "GreaterThanThreshold"
  threshold           = 0
  period              = 86400
  evaluation_periods  = 1
  alarm_actions       = var.alarm_actions
  ok_actions          = var.alarm_actions
}
