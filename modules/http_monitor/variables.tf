variable "name" {
  description = "Monitor name"
  type        = string
}

variable "type" {
  description = "Type of the monitor (HTTP, KEYWORD, PING, PORT, HEARTBEAT, DNS). Default: HTTP"
  type        = string
  default     = "HTTP"
}

variable "url" {
  description = "URL to monitor"
  type        = string
}

variable "interval" {
  description = "Monitoring interval in seconds. Default: 300"
  type        = number
  default     = 300
}

variable "ssl_expiration_reminder" {
  description = "Enable SSL expiration reminders. Default: true"
  type        = bool
  default     = true
}

variable "follow_redirections" {
  description = "Follow HTTP redirects. Default: true"
  type        = bool
  default     = true
}

variable "timeout" {
  description = "Request timeout in seconds. Default: 30"
  type        = number
  default     = 30
}

variable "auth_type" {
  description = "The authentication type (HTTP_BASIC, NONE). Default: NONE"
  type        = string
  default     = "NONE"
}

variable "domain_expiration_reminder" {
  description = "Whether to enable domain expiration reminders. Default: true"
  type        = bool
  default     = true
}

variable "http_method_type" {
  description = "The HTTP method type (HEAD, GET, POST, PUT, PATCH, DELETE, OPTIONS). Default: HEAD"
  type        = string
  default     = "HEAD"
}

variable "success_http_response_codes" {
  description = "The expected HTTP response codes. Default: 2xx, 3xx"
  type        = list(string)
  default     = ["2xx", "3xx"]
}

variable "assigned_alert_contacts" {
  description = "(List of String) Alert contact IDs to assign to the monitor"
  type        = list(string)
}

variable "custom_http_headers" {
  description = "(List of String) Alert contact IDs to assign to the monitor"
  type        = map(string)
  default     = null
}

variable "tags" {
  description = "Tags for the monitor"
  type        = list(string)
}
