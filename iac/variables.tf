variable "domain_name" {
  description = "The domain name for the ComfyUI service."
  type        = string
}

variable "project_id" {
  description = "The project ID to deploy to."
  type        = string
}

variable "region" {
  description = "The region to deploy to."
  type        = string
  default     = "asia-southeast2"
}

variable "vm_name" {
  description = "The name of the ComfyUI VM."
  type        = string
  default     = "comfyui"
}

variable "zone" {
  description = "The zone to deploy to."
  type        = string
  default     = "asia-southeast2-a"
}
