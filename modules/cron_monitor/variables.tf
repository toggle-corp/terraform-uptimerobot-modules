variable "name" {
  description = "Monitor name"
  type        = string
}

variable "url" {
  description = "Random string"
  type        = string
  default     = "random"
}

variable "type" {
  description = "Type of the monitor (HTTP, KEYWORD, PING, PORT, HEARTBEAT, DNS). Default: HEARTBEAT"
  type        = string
  default     = "HEARTBEAT"
}

variable "interval" {
  description = "Expected request interval. Default: 1hr (3600)"
  type        = number
  default     = 3600
}

variable "grace_period" {
  description = "Max wait seconds for the request to come before it's consider as not received. Default: 1hr (3600)"
  type        = number
  default     = 3600
}

variable "assigned_alert_contacts" {
  description = "(List of String) Alert contact IDs to assign to the monitor"
  type        = list(string)
}

variable "tags" {
  description = "Tags for the monitor"
  type        = list(string)
}
