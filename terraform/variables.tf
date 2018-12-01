# common
variable "credentials" {default = "./credentials.json"}
variable "project" {default = "cyberagent-239"}
variable "region" {default = "asia-northeast"}
variable "zone" {default = "asia-northeast1-a"}

# GKE
variable "cluster_count" {default = "30"}
variable "cluster_count_tw" {default = "30"}
variable "cluster_name_prefix" {default = "ca-k8s-"}
variable "node_count" {default = "3"}
variable "machine_type" {default = "n1-standard-2"}
variable "username" {default = "admin"}
variable "password" {default = "ItyGdjcgnzh6mieggztq0jiaxoicqk"}
variable "gke_version" {default = "1.11.2-gke.18"}
