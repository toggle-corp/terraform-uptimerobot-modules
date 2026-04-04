resource "uptimerobot_monitor" "main" {
  interval     = var.interval
  grace_period = var.grace_period
  assigned_alert_contacts = [
    for id in var.assigned_alert_contacts : {
      alert_contact_id = id
      # NOTE: High threshold is not supported yet
      threshold  = 0,
      recurrence = 0
    }
  ]

  http_method_type = null

  name = var.name
  url  = var.url
  type = var.type
  tags = var.tags
}
