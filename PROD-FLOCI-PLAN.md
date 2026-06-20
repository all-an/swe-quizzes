# Plan — Run swe-quizzes on AWS via Floci (separated frontend/backend)

Goal: replace the Render deployment (single Spring Boot jar serving a bundled
Angular dist) with a production-shaped topology running on **AWS emulated by Floci**.
Frontend and backend are deployed and accessed **separately**, via Floci URLs.

## Target architecture

```
Browser
  │
  ├─ http://swe-quizzes-frontend.s3-website.localhost.floci.io:4566   ← Angular static site (S3)
  │        │  (JS calls absolute API URL)
  │        ▼
  └─ http://localhost:8081  ──►  ALB (ELBv2 listener :8081)
                                   │  rule /api/* → target group
                                   ▼
                                 ECS service (Fargate) → Spring Boot container (:8080)
                                   │  SPRING_DATASOURCE_URL
                                   ▼
                                 RDS PostgreSQL 16 (Flyway runs V1–V8 on boot)
```

Three AWS services replace Render: **S3** (frontend), **ECS + ECR + ALB** (backend),
**RDS** (Postgres). All provisioned by **Terraform** pointed at `http://localhost:4566`.

## The one real app-code problem to solve

The Angular app calls the API with **relative paths**
(`this.http.post('/api/auth/login', …)` across `auth.service.ts`,
`settings.service.ts`, `quiz.service.ts`). That only works today because Spring Boot
serves the frontend from the same origin. Once the frontend lives on its own S3 URL,
those calls resolve against the S3 host and 404.

So "separated" requires two changes:

1. **Frontend:** introduce an API base URL and prefix every call with it.
2. **Backend:** add CORS to allow the S3 website origin (today there is no CORS
   config — `WebConfig.java` only serves static files).

## Changes by area

### 1. Frontend (Angular)
- Add `src/environments/environment.ts` (dev: `apiUrl: ''`, so `/api` keeps working
  with `proxy.conf.json`) and `environment.prod.ts`
  (`apiUrl: 'http://localhost:8081'` — the ALB).
- Wire `fileReplacements` in `angular.json` for the production configuration, and set
  an `outputPath`.
- Centralize the base URL: a small `API_BASE` token / `ApiService`, or update the 3
  services to use `` `${environment.apiUrl}/api/...` `` (~3 files).
- `npm run build` → static bundle uploaded to S3. **No Dockerfile for the frontend.**

### 2. Backend (Spring Boot)
- **Externalize the datasource** — `application.properties` currently hardcodes
  `localhost:5432`. Switch to env-driven: `spring.datasource.url=${SPRING_DATASOURCE_URL}`,
  username/password likewise (Spring already maps `SPRING_DATASOURCE_*` env vars, so
  possibly no file change is needed — confirm and keep a local default).
- **Add CORS config** allowing the S3 website origin for `/api/**`.
- Leave `WebConfig.java` as-is or trim static-serving (harmless once no static files
  are bundled). The build **stops copying Angular into `resources/static`** — backend
  is API-only now.
- New **`backend/Dockerfile`** (replaces `Dockerfile.render`): runtime image on 8080.

### 3. Infra (Terraform) — new `infra/` dir
- `provider.tf`: AWS provider with `endpoints {}` all → `http://localhost:4566`, fake
  creds, `s3_use_path_style`, skip credential/metadata validation (LocalStack-style).
- `s3.tf`: bucket + `aws_s3_bucket_website_configuration` (public-read site).
- `ecr.tf`: repository for the backend image.
- `rds.tf`: `aws_db_instance` Postgres 16, db `swequizzes`.
- `ecs.tf`: cluster, task definition (image from ECR, env vars incl.
  `SPRING_DATASOURCE_URL` → RDS endpoint), service.
- `alb.tf`: load balancer, target group, listener on `:8081`, rule
  `/api/* → backend`.
- `outputs.tf`: prints the frontend URL and ALB URL.

### 4. Floci compose
- Add the **ALB listener port** and any ECS-exposed ports to `floci-compose.yml` port
  mappings (Floci runs in a container, so listener sockets must be published — the ELB
  docs call this out). `7001-7099` (RDS proxy) and `4566` are already exposed.

### 5. Orchestration script — `deploy-floci.sh`
Order: `terraform apply` → `mvn package` → `docker build` backend →
`docker push` to Floci ECR → force ECS new deployment → `ng build` frontend →
`aws s3 sync` to the bucket → print URLs.

### 6. Docs / cleanup
- Update `FLOCI-README.md` (or new `PROD-FLOCI.md`) with the deploy steps and URLs.
- Retire Render artifacts: `Dockerfile.render`, `build-dist.sh`, `render-deploy.md`,
  and the `Dockerfile.render` reference in `PROD-DIST.md` (confirm before deleting).

## Honest risks / things to validate first (spikes)

1. **ALB → ECS target wiring.** Floci's ELB docs emphasize **EC2 *instance* targets**
   ("resolved through EC2 instance private addresses"); ECS-Fargate auto-registration
   into an ALB target group (IP targets) may be partial.
   **Mitigation/spike:** verify the ECS service registers with the target group; if
   not, fall back to either (a) backend on EC2 instead of Fargate (instance targets,
   well-supported), or (b) skip the ALB and expose the ECS task port directly. Prove
   this with a tiny nginx task before wiring the real backend.
2. **RDS readiness timing** — backend must wait for RDS; add a healthcheck/retry so
   Flyway does not fail on first boot.
3. **S3 website endpoint host resolution** — `*.localhost.floci.io` resolves to
   `127.0.0.1` per the docs, so the browser URL works without `/etc/hosts` edits.
   Confirm the exact website-endpoint form.

## Deliverables when approved

New: `infra/*.tf`, `backend/Dockerfile`, `frontend/src/environments/*.ts`,
`deploy-floci.sh`, updated `angular.json`, `floci-compose.yml`, the 3 Angular services
+ CORS config, updated docs.

Removed (with approval): `Dockerfile.render`, `build-dist.sh`, `render-deploy.md`.

## Roadmap

Mark items `[x]` as they are completed.

### Phase 0 — Spike & setup
- [ ] Floci running via `docker compose -f floci-compose.yml up` (healthy on :4566)
- [ ] AWS CLI configured against Floci (endpoint + dummy creds verified)
- [ ] Terraform installed and provider pointed at `http://localhost:4566`
- [ ] **Spike:** ALB → ECS target wiring proven with a throwaway nginx task
- [ ] Topology decision locked (Fargate+ALB, or fallback EC2 / direct port)

### Phase 1 — Frontend (Angular) ✅
- [x] Add `environment.ts` (dev) and `environment.prod.ts` (`apiUrl` → ALB)
- [x] Wire `fileReplacements` + `outputPath` (`dist/frontend`) in `angular.json`
- [x] Replace relative `/api` calls with `${apiUrl}/api/...` in the 3 services
- [x] `npm run build` produces a clean static bundle (ALB URL baked into prod, tests 19/19 green)

### Phase 2 — Backend (Spring Boot)
- [ ] Externalize datasource via `SPRING_DATASOURCE_*` env vars (local default kept)
- [ ] Add CORS config allowing the S3 website origin for `/api/**`
- [ ] Stop bundling Angular into `resources/static` (API-only build)
- [ ] New `backend/Dockerfile` (listens on 8080), image builds locally

### Phase 3 — Infra (Terraform `infra/`)
- [ ] `provider.tf` — endpoints → Floci, path-style S3, skip validations
- [ ] `s3.tf` — bucket + website configuration
- [ ] `ecr.tf` — backend image repository
- [ ] `rds.tf` — Postgres 16 instance (db `swequizzes`)
- [ ] `ecs.tf` — cluster, task definition, service (datasource env → RDS)
- [ ] `alb.tf` — load balancer, target group, listener :8081, `/api/*` rule
- [ ] `outputs.tf` — frontend URL + ALB URL
- [ ] `terraform apply` succeeds end-to-end

### Phase 4 — Wiring & deploy
- [ ] Expose ALB/ECS ports in `floci-compose.yml`
- [ ] `deploy-floci.sh` orchestrates apply → build → push → deploy → sync
- [ ] Backend reachable through the ALB (`/api/...` returns data)
- [ ] RDS readiness/retry handled (Flyway V1–V8 apply cleanly)
- [ ] Frontend served from S3 website URL, talks to backend successfully
- [ ] Full end-to-end smoke test (login, load quizzes) passes

### Phase 5 — Docs & cleanup
- [ ] Update `FLOCI-README.md` / `PROD-FLOCI.md` with deploy steps + URLs
- [ ] Remove Render artifacts (`Dockerfile.render`, `build-dist.sh`, `render-deploy.md`)
- [ ] Update `PROD-DIST.md` / `README.md` references to Render

## Open questions

- **Spike first?** Recommend validating risk #1 (ALB→ECS) with a throwaway nginx task
  before committing to the full ECS+ALB wiring — it is the only part that could force a
  topology change (Fargate→EC2).
- **Render cleanup** — delete `Dockerfile.render`, `build-dist.sh`, and
  `render-deploy.md`, or keep them for now?
