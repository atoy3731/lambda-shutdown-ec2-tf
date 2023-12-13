variable "skip_regions" {
  description = "Comma-separated list of regions to skip."
  type        = string
  default     = ""
}

variable "running_tag" {
  description = "Tag to check for values of 'true' for instances to keep running."
  type        = string
  default     = "KeepRunning"
}

variable "cron_schedule" {
  description = "Cron schedule to execute Lambda (in UTC)."
  type        = string
  default     = "0 3 * * ? *" # 10PM EST
}