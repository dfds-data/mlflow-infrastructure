# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## 1.1.0 (2026-07-07)

### Feat

- update mlflow to 3.14.0
- detach project versioning from mlflow versioning and add commitizen/conventional commit support
- update Python version to 3.13 and add docker build github workflow

### Fix

- Storage should match production, it must have been increased for a reason

## v6.0.0 (2025-08-01)

## v5.0.0 (2025-01-10)

### Fix

- Remove conflicting S3 bucket ACL resource from Terraform configuration

## [4.0.0] - 2022-08-24
### Changed
- BREAKING: Changed from KIAM auth to IRSA. 
  See https://wiki.dfds.cloud/en/teams/devex/operations/guides/kiam-to-irsa-migration.
  KIAM is deprecated and will be removed in the future. We are now using IRSA and ServiceAccounts to assume roles in 
  AWS. 
