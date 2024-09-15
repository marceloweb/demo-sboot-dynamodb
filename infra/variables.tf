variable "region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  default     = "test-eks-cluster"
}

variable "node_instance_type" {
  description = "Instance type for the worker nodes"
  default     = "t3.micro"
}

variable "desired_capacity" {
  description = "Desired number of worker nodes"
  default     = 1
}

variable "max_size" {
  description = "Maximum number of worker nodes"
  default     = 1
}

variable "min_size" {
  description = "Minimum number of worker nodes"
  default     = 1
}
