variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-1"
}

variable "aws_profile" {
  description = "AWS user profile"
  type        = string
  default     = "awsadmin"
}

variable "aws_vpc_cidr" {
    description = "CIDR for VPC"
    type        = string
    default     = "10.0.0.0/16"
}

variable "aws_vpc_instance_tenancy" {
    description = "Type of instance tenancy for VPC"
    type        = string
    default     = "default"
}

variable "environment_vpc_dev" {
    description = "Name for VPC environment development"
    type        = string
    default     = "vpc_dev"
}

variable "environment_dev" {
    description = "Environment developemnt"
    type        = string
    default     = "development"
}

variable "environment_igw_dev" {
    description = "Internet gateway for development"
    type        = string
    default     = "igw_vpc_dev"
}

variable "availability_zones" {
    description = "Availiability zones for singapore region"
    type        = list(string)
    default     = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"] 
}

variable "cidr_public_subnet" {
    description = "CIDR for public subnet"
    type        = string
    default     = "10.0.0.0/24"
}

variable "cidr_private_subnet" {
    description = "CIDR for private subnet"
    type        = string
    default     = "10.0.1.0/24" 
}

variable "launch_configuration_name" {
    description = "Name of launch configuration for autoscaling"
    type        = string
    default     = "launch_config"
}

variable "autoscaling_group_name" {
    description = "Name of autoscaling group"
    type        = string
    default     = "autoscaling"
}

variable "instance_type" {
    description = "Type of instance"
    type        = string
    default     = "t2.medium"
}

variable "image_id" {
    description = "ID of image ubuntu 20.04 LTS"
    type        = string
    default     = "ami-0d058fe428540cd89"
}

variable "autoscaling_policy_name" {
    description = "Name of autoscaling policy"
    type        = string
    default     = "autoscaling_policy"
}