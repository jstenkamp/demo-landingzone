terraform {
  required_version = ">= 0.12"
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.3.0"
    }
    tfe = {
        version = "~> 0.58.1"
    }
  }
}