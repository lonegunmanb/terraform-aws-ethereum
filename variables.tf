## resource placment

variable "vpc_id" {
  type        = string
  description = "ID of VPC to place resources in"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of Subnet IDs to place resources in"
}

## container definitions

variable "image" {
  type        = string
  default     = "ethereum/client-go:stable"
  description = "Name of image to use in container definition"
}

## network

variable "http_api_enabled" {
  type        = bool
  default     = true
  description = "Set to `false` to disable the HTTP JSON RPC API"
}

variable "http_api_port" {
  type        = number
  default     = 8545
  description = "Port to use for HTTP JSON RPC API"
}

variable "ws_api_enabled" {
  type        = bool
  default     = true
  description = "Set to `false` to disable the WebSocket JSON RPC API"
}

variable "ws_api_port" {
  type        = number
  default     = 8546
  description = "Port to use for WebSocket JSON RPC API"
}

variable "p2p_enabled" {
  type        = bool
  default     = true
  description = "Set to `false` to disable P2P discovery"
}

variable "p2p_port" {
  type        = number
  default     = 30303
  description = "Port to use for P2P discovery"
}

## node configuration

variable "volume_size" {
  type        = number
  default     = 30
  description = "Size of EBS volume for node. See https://ethereum.org/en/developers/docs/nodes-and-clients/#requirements for more information"
}

variable "instance_type" {
  type        = string
  default     = "t2.xlarge"
  description = "Instance type of node. See https://ethereum.org/en/developers/docs/nodes-and-clients/#requirements for more informations"
}
