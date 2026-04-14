# Sigil - Next Steps

## Infrastructure Setup
- [ ] Create a GCP project (or pick an existing one)
- [ ] Set the GCP project ID in `infra/environments/*/terraform.tfvars`
- [ ] Create a GCS bucket `sigil-terraform-state` for Terraform remote state
- [ ] Enable required GCP APIs: Compute Engine, Cloud SQL, VPC
- [ ] Run `terraform init` and `terraform plan` in `infra/environments/dev/`

## Local Development
- [ ] Start the local Postgres: `cd apps/sigil_server && docker compose up -d`
- [ ] Run the server: `cd apps/sigil_server && dart run bin/main.dart --apply-migrations`
- [ ] Run the Flutter app: `cd apps/sigil_flutter && flutter run`
- [ ] Review and rotate default passwords in `apps/sigil_server/config/passwords.yaml`

## CI/CD
- [ ] Create a GitHub repo and push the initial commit
- [ ] Add GitHub Actions secrets: `GCP_PROJECT_ID`, `TF_VAR_db_password`
- [ ] Set up GCP Workload Identity Federation for keyless GitHub Actions auth
- [ ] Add deploy workflows (currently CI only validates, no deploy step)

## Code Quality
- [ ] Add custom lint rules in `packages/sigil_lints/`
- [ ] Wire `sigil_lints` into each package's `analysis_options.yaml`
- [ ] Set up a shared `analysis_options.yaml` at the repo root

## Security
- [ ] Remove `apps/sigil_server/config/passwords.yaml` from version control (use env vars or Secret Manager)
- [ ] Restrict `serverpod_allowed_cidrs` in `infra/modules/network/variables.tf` (currently `0.0.0.0/0`)
- [ ] Set up Cloud SQL Auth Proxy instead of direct private IP access
