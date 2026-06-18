# What is this?

This repository has some different modules:

- `/infrastructure` - contains terraform code to deploy a centrally managed database backend for
  mlflow. It mainly creates a PostgreSQL server, that can contain all of the MLFlow databases for
  each project. The reason why it was done like this, is to avoid having a billion different
  servers.
- `/mlflow-image` - `Dockerfile` for mlflow to be used when deploying it to kubernetes. For each new
  version of MLFlow, an image is built (see [azure-pipelines.yaml](./azure-pipelines.yml)) and
  pushed to the shared ECR repository so that it can be pulled from the Hellman K8s cluster.
- `/mlflow-terraform` - contains terraform code to be used by clients to create the necessary aws
  resources in their AWS account to run mlflow in kubernetes. These resources are mainly an S3
  bucket and a role for K8s to assume so that it can access the bucket.

## New versions

There is a GH Actions pipeline that checks for new MLFlow versions daily. Whenever there is a new
version out, a PR will be auto-generated. After the PR is merged, the pipeline is triggered and the
following happens:

- The new version is built into a docker image and pushed
- The backend terraform is run (the one in `/infrastructure`, nothing changes probably)

## Versioning & commits

This repo uses [Conventional Commits](https://www.conventionalcommits.org/) together with
[commitizen](https://commitizen-tools.github.io/commitizen/) to manage the project version, which
lives in [`mlflow-image/pyproject.toml`](./mlflow-image/pyproject.toml). The version is no longer
tied to the MLflow version: any change under `mlflow-image/` bumps it.

### How the version is bumped

When a PR is merged into `master`, the
[`bump-version`](./.github/workflows/bump-version.yml) workflow runs **only if files under
`mlflow-image/` changed**. It uses commitizen to:

1. Determine the next [SemVer](https://semver.org/) version from the conventional commit messages
   since the last tag (`fix:` → patch, `feat:` → minor, `feat!:`/`BREAKING CHANGE:` → major).
2. Update the version in `pyproject.toml` and prepend the changes to [`CHANGELOG.md`](./CHANGELOG.md).
3. Commit (`bump: version X → Y [skip ci]`), tag, and push back to `master`.

The MLflow auto-update PR uses a `feat: update mlflow to <version>` commit so it bumps the version
like any other change.

### Local setup (prek)

Git hooks are managed with [prek](https://prek.j178.dev), a fast drop-in replacement for
pre-commit that reads the same [`.pre-commit-config.yaml`](./.pre-commit-config.yaml). It installs a
`commit-msg` hook that validates every commit message against the Conventional Commits spec.

Install prek and enable the hooks once per clone. The project and its lock file live in
`mlflow-image/`, so pass `--project mlflow-image` to run the `uv` commands from the repo root
(this keeps the working directory at the root, where `.git` and `.pre-commit-config.yaml` live):

```bash
# prek and commitizen are part of the `dev` dependency group
uv sync --project mlflow-image

# Enable the git hooks defined in .pre-commit-config.yaml
uv run --project mlflow-image prek install
```

After that, commits with a non-conventional message are rejected locally. You can also write commits
interactively with `uv run --project mlflow-image cz commit`.

> Alternatively, `cd mlflow-image` first and run the commands without `--project` (`uv sync`,
> `uv run prek install`).

## Known issues

- We may be using an old version of `psycopg2` - check the mlflow pin
- Could be beneficial to upgrade to python 3.9 or 3.10 soon

## Feature backlog

- The k8s manifests are now on the client side. We could use something like kustomize.io to have the bulk of the manifests in this repo, and just a thin file with the needed changes in the client code.

## Releasing

To release (ie. create a new version of the terraform module), just create a new release with the tag "v{version}" (for example v3.0.1). There is no release pipeline or anything like that, the clients refer to the source code directly.
