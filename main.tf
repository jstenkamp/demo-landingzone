provider "tfe" {
  hostname = var.tfc_host
  token    = var.tfc_token
}

provider "github" {
  token = var.github_token
}


### GITHUB ###

#Repo

resource "github_repository" "demo" {
  name        = "tfc-mondoo-01"
  description = "LZ for mondoo-01"
  visibility = "public"
  auto_init = true
}

#Secrets

resource "github_actions_secret" "tfc_token" {
  repository       = github_repository.demo.name
  secret_name      = "TFC_TOKEN"
  plaintext_value  = var.tfc_token
}

resource "github_actions_secret" "tfc_oauth_token" {
  repository       = github_repository.demo.name
  secret_name      = "TFC_OAUTH_TOKEN"
  plaintext_value  = var.oauth_token_id
}

resource "github_actions_secret" "mondoo_token" {
  repository       = github_repository.demo.name
  secret_name      = "MONDOO_CONFIG_BASE64"
  plaintext_value  = var.mondoo_token
}


#Workflow


resource "github_repository_file" "workflow" {
  repository          = github_repository.demo.name
  branch              = "main"
  file                = ".github/workflows/flow1.yml"
  content             = file("${path.root}/actions/flow1.yml")
  commit_message      = "Managed by Terraform"
  commit_author       = "Terraform User"
  commit_email        = "terraform@example.com"
  overwrite_on_create = true
}



#### WORKSPACE ###

resource "tfe_workspace" "demo" {
  name         = "tfc-mondoo-01"
  organization = var.tfc_org
  #tag_names    = ["test", "app"]
  vcs_repo {
    identifier = github_repository.demo.full_name
    oauth_token_id = var.oauth_token_id
  }
  allow_destroy_plan = true
  auto_apply = false
  global_remote_state = true 
  queue_all_runs = true  
  terraform_version = "1.9.6" 
}

# resource "tfe_variable" "aws_region-10" {
#   key          = "aws_region"
#   value        = var.aws_region
#   category     = "terraform"
#   workspace_id = tfe_workspace.stm-10-foundation.id
#   description  = "AWS Region to be used"
# }