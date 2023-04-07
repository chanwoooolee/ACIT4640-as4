# This variable block defines the base_cidr_block for the VPC to be created. The default value is 10.0.0.0/16.
variable "base_cidr_block" {
  description = "default cidr block for vpc"
  default     = "10.0.0.0/16"
}
