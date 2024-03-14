# Playground to test out some GitHub repo automation

The provider seems well-maintained. I'm curious about how well this is working
nowadays... and decisions the team have made about how to deal with the various
conflict scenarios when trying to use Terraform to manage resources that live
in git repos.  Let's break things!

Gonna start just testing terraform that manages resources within this same
repo. Mostly just to see right away how well the provider handles
tightly-managed `github_repository_file` resources in a situation where the
surrounding repo floats around.  Wonder what it'll do with caching local
clones during an apply...

---

Ok, first test of basic functionality worked fine.

- auth using `gh auth login`
- create repo
- create file in repo


---

Next test worked fine with the repo self-reference...

- auth using `gh auth login`
- point data source to existing repo (use just `name` for personal org'd repos,
  not `full_name`)
- create file in repo

Next I'm gonna move HEAD around independently of the commit involving the new
file (by writing this note).

ok, that worked out just fine.

Next up, let's try some stuff with the same files to see if it respects that
`overwrite` option.

---

Same scenario... made an out-of-band change to a managed file.

`plan` seems to want to undo the change:

```
mmm-4b4a:~/.../github-provider-playground/terraform/configfiles (main) $ terraform plan -var-file configfiles.tfvars 
data.github_repository.playground: Reading...
data.github_repository.playground: Read complete after 1s [id=github-provider-playground]
github_repository_file.managed_config_file: Refreshing state... [id=github-provider-playground/targets/this/is/a_managed_config_file.yml]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  ~ update in-place

Terraform will perform the following actions:

  # github_repository_file.managed_config_file will be updated in-place
  ~ resource "github_repository_file" "managed_config_file" {
      ~ content             = <<-EOT
            some sort of content goes here
            with more content here
            and another line of stuff here
          - 
          - this'll be a line that hopefully gets overwritten by terraform
        EOT
        id                  = "github-provider-playground/targets/this/is/a_managed_config_file.yml"
        # (10 unchanged attributes hidden)
    }

Plan: 0 to add, 1 to change, 0 to destroy.
```
which is perfect.

Apply committed things as expected without any drama.

---

You can see the progress of most of these tests in commit history of this repo.

