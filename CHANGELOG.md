# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [4.0.0] - 2022-08-24
### Changed
- BREAKING: Changed from KIAM auth to IRSA. 
  See https://wiki.dfds.cloud/en/teams/devex/operations/guides/kiam-to-irsa-migration.
  KIAM is deprecated and will be removed in the future. We are now using IRSA and ServiceAccounts to assume roles in 
  AWS. 
