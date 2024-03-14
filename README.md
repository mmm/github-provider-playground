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

