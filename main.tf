terraform {
  required_providers {
    gitlab = {
      source = "terraform-providers/gitlab"
    }
  }
}

provider "gitlab" {
  base_url = "https://gitlab.sikademo.com/api/v4/"
  token    = "yJVPZVTsZ-p7ZQe1c9P1"
}

locals {
  example_vars = {
    FOO = "Hello"
    BAR = "World"
  }
  example_masked_vars = {
    SECRET = "thisissecret"
  }
  example_ondrejsika_vars = {
    HELLO = "ahoj"
  }
  example_ondrejsika_file_vars = {
    README = file("./README.md")
  }
}

data "gitlab_group" "example" {
  full_path = "example"
}

resource "gitlab_group_variable" "example" {
  for_each = local.example_vars

  group             = data.gitlab_group.example.id
  key               = each.key
  value             = each.value
  protected         = false
  masked            = false
  environment_scope = "*"
}

resource "gitlab_group_variable" "example_masked" {
  for_each = local.example_masked_vars

  group             = data.gitlab_group.example.id
  key               = each.key
  value             = each.value
  protected         = false
  masked            = true
  environment_scope = "*"
}


data "gitlab_project" "example_ondrejsika" {
  id = "example/ondrejsika"
}

resource "gitlab_project_variable" "example_ondrejsika" {
  for_each = local.example_ondrejsika_vars

  project           = data.gitlab_project.example_ondrejsika.id
  key               = each.key
  value             = each.value
  protected         = false
  masked            = false
  environment_scope = "*"
}

resource "gitlab_project_variable" "example_ondrejsika_file" {
  for_each = local.example_ondrejsika_file_vars

  project           = data.gitlab_project.example_ondrejsika.id
  key               = each.key
  value             = each.value
  protected         = false
  masked            = false
  variable_type     = "file"
  environment_scope = "*"
}
