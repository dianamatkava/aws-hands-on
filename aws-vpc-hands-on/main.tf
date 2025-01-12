provider "aws" {
  region = "eu-central-1"
}

module "network" {
  source = "./network"
}

module "compute" {
  source = "./compute"
}