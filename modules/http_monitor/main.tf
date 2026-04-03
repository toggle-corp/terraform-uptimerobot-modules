resource "uptimerobot_monitor" "main" {
  interval                    = var.interval
  ssl_expiration_reminder     = var.ssl_expiration_reminder
  check_ssl_errors            = true
  follow_redirections         = var.follow_redirections
  auth_type                   = var.auth_type
  domain_expiration_reminder  = var.domain_expiration_reminder
  http_method_type            = var.http_method_type
  success_http_response_codes = var.success_http_response_codes
  assigned_alert_contacts = [
    for id in var.assigned_alert_contacts : {
      alert_contact_id = id
      threshold        = 3    # Send after 3m
      recurrence       = 2880 # repeat every 2 days
    }
  ]

  name                = var.name
  type                = var.type
  url                 = var.url
  custom_http_headers = var.custom_http_headers
  tags                = var.tags

  # XXX: This shows changes even if there are no changes
  timeout = var.timeout
}
