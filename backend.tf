terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "jj-hcp"

    workspaces {
      name = "tfc-aws-nginx"
    }
  }
}
