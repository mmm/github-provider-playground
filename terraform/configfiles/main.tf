#
# Copyright 2024 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#
# first test... created a new repo
#
# resource "github_repository" "playground" {
#   name      = "github-provider-test0"
#   description = "My awesome codebase"
#   visibility = "public"
#   auto_init = true
# }

#
# subsequent tests just pointed to the current repo as its own data source
#
data "github_repository" "playground" {
  name      = "github-provider-playground"
}

resource "github_repository_file" "managed_config_file" {
  #repository          = github_repository.playground.name
  repository          = data.github_repository.playground.name
  branch              = "main"
  file                = "targets/this/is/a_managed_config_file.yml"
  content             = <<-EOT
    some sort of content goes here
    with more content here
    and another line of stuff here
    EOT
  commit_message      = "Managed by Terraform"
  commit_author       = var.git_user_name
  commit_email        = var.git_user_email
  overwrite_on_create = true
}


# now get the content from a template just like:
#
#resource "google_storage_bucket_object" "startup_script" {
#  #name   = "provision.sh"
#  name  = "terraform/vertex-ai-workbenches/provision.sh"
#  #source = "/images/nature/garden-tiger-moth.jpg"
#  content = templatefile("provision.sh.tmpl", {
#    home_ip = data.terraform_remote_state.storage.outputs.storage-node-ip-address,
#    tools_ip = data.terraform_remote_state.storage.outputs.storage-node-ip-address,
#  })
#  bucket = var.state_bucket
#}
