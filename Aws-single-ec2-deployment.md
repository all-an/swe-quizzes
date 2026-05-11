# AWS Single EC2 Deployment - swe-quizzes

This guide deploys `swe-quizzes` on one low-cost AWS EC2 instance where:

- Spring Boot serves the Angular production dist from `backend/src/main/resources/static`.
- One Spring Boot JAR runs the backend API and the frontend.
- PostgreSQL runs on the same EC2 instance in Docker.
- Nginx runs on the same EC2 instance and forwards traffic to Spring Boot.
- No RDS, load balancer, NAT Gateway, or separate frontend hosting is used.

## 1. Target Architecture

```text
Internet
  |
  v
EC2 instance
  |
  +-- nginx container       public ports 80/443
  +-- spring app container  internal port 8080
  +-- postgres container    internal port 5432
```

Spring Boot serves:

- `/` and Angular routes from the generated Angular files inside the JAR.
- `/api/**` from backend controllers.

## 2. Low-Cost AWS Choices

Use the smallest instance that is comfortable for the app:

| Item | Recommended low-cost choice | Notes |
| --- | --- | --- |
| Region | `us-east-1` or the cheapest region near users | Check current AWS pricing before creating it. |
| Instance | `t4g.small` ARM, 2 vCPU, 2 GB RAM | Lowest practical option for Spring + Postgres + Nginx. |
| Safer instance | `t4g.medium` ARM, 2 vCPU, 4 GB RAM | Better if builds, traffic, or memory usage grow. |
| AMI | Ubuntu Server 24.04 LTS ARM64 | Match the Graviton/t4g architecture. |
| Disk | 20-30 GB gp3 EBS | Start small; increase later if needed. |
| Database | PostgreSQL Docker volume on EC2 | Cheapest, but you own backups. |
| IP | Elastic IP | Avoids changing DNS when the instance restarts. |

Important cost notes:

- Public IPv4 addresses, including Elastic IPs, have an hourly charge on AWS. Keep only the IPs you use.
- Do not create an RDS database, NAT Gateway, Load Balancer, or CloudWatch extras unless you intentionally accept the extra monthly cost.
- Use the AWS Pricing Calculator before launch because EC2, EBS, snapshot, and IPv4 prices can change by region.

Useful references:

- AWS EC2 On-Demand pricing: https://aws.amazon.com/ec2/pricing/on-demand/
- AWS VPC pricing, including public IPv4 pricing: https://aws.amazon.com/vpc/pricing/
- AWS Pricing Calculator: https://calculator.aws/

## 3. Local Prerequisites

Install these on your development machine:

- Java 21
- Maven
- Node 20+ and npm
- SSH access to AWS

From the repo root, verify the project build script exists:

```bash
ls -l build-dist.sh
```

## 4. Build One JAR Locally

From the project root:

```bash
chmod +x build-dist.sh
./build-dist.sh
```

The script does this:

1. Runs `npm ci` in `frontend/`.
2. Runs `npm run build` in `frontend/`.
3. Copies `frontend/dist/frontend/browser/` into `backend/src/main/resources/static/`.
4. Builds the backend JAR with Maven.

The deployable file is:

```text
backend/target/swe-quizzes-0.0.1-SNAPSHOT.jar
```

Quick local check before deploying:

```bash
ls -lh backend/target/swe-quizzes-0.0.1-SNAPSHOT.jar
```

## 5. Create the EC2 Instance

In AWS Console:

1. Open EC2.
2. Launch an instance.
3. Choose Ubuntu Server 24.04 LTS ARM64.
4. Choose `t4g.small` for the lowest practical cost, or `t4g.medium` for more memory.
5. Create or select an SSH key pair.
6. Set storage to 20-30 GB gp3.
7. Create a security group with only these inbound rules:

| Port | Source | Purpose |
| --- | --- | --- |
| 22 | Your IP only | SSH |
| 80 | `0.0.0.0/0`, `::/0` | HTTP and Let's Encrypt challenge |
| 443 | `0.0.0.0/0`, `::/0` | HTTPS |

Do not expose:

- `8080` Spring Boot
- `5432` PostgreSQL

After launch:

1. Allocate an Elastic IP.
2. Associate it with the EC2 instance.
3. If using a domain, create an `A` record pointing to the Elastic IP.

## 6. Install Runtime Software on EC2

SSH into the instance:

```bash
ssh -i ~/.ssh/swe-quizzes.pem ubuntu@YOUR_EC2_PUBLIC_IP
```

Install Docker, Docker Compose, Certbot, and `lsof`:

```bash
sudo apt update
sudo apt -y upgrade
sudo apt -y install docker.io docker-compose-plugin certbot lsof
sudo usermod -aG docker ubuntu
```

Log out and back in so the `docker` group is applied:

```bash
exit
ssh -i ~/.ssh/swe-quizzes.pem ubuntu@YOUR_EC2_PUBLIC_IP
```

Check Docker:

```bash
docker --version
docker compose version
```

## 7. Create the Deployment Folder on EC2

On EC2:

```bash
mkdir -p ~/swe-quizzes/nginx
cd ~/swe-quizzes
```

Create the environment file:

```bash
nano .env
```

Use strong production values:

```env
DB_NAME=swequizzes
DB_USER=swequizzes
DB_PASSWORD=REPLACE_WITH_A_LONG_RANDOM_PASSWORD
```

Do not commit `.env`.

## 8. Create the Production Dockerfile

On EC2, in `~/swe-quizzes`, create `Dockerfile`:

```bash
nano Dockerfile
```

Paste:

```dockerfile
FROM eclipse-temurin:21-jre-alpine

WORKDIR /app

RUN addgroup -S app && adduser -S app -G app

COPY swe-quizzes-0.0.1-SNAPSHOT.jar /app/app.jar

RUN chown -R app:app /app
USER app

EXPOSE 8080

ENTRYPOINT ["java", "-Xms256m", "-Xmx768m", "-jar", "/app/app.jar"]
```

For `t4g.small`, keep memory conservative. If the container is killed for memory, change to `t4g.medium` or reduce `-Xmx768m`.

## 9. Create docker-compose.yml

On EC2, in `~/swe-quizzes`, create `docker-compose.yml`:

```bash
nano docker-compose.yml
```

Paste:

```yaml
services:
  postgres:
    image: postgres:16-alpine
    container_name: swe-quizzes-postgres
    restart: unless-stopped
    environment:
      POSTGRES_DB: ${DB_NAME}
      POSTGRES_USER: ${DB_USER}
      POSTGRES_PASSWORD: ${DB_PASSWORD}
    volumes:
      - postgres_data:/var/lib/postgresql/data
    networks:
      - backend

  app:
    build: .
    container_name: swe-quizzes-app
    restart: unless-stopped
    depends_on:
      - postgres
    environment:
      SPRING_DATASOURCE_URL: jdbc:postgresql://postgres:5432/${DB_NAME}
      SPRING_DATASOURCE_USERNAME: ${DB_USER}
      SPRING_DATASOURCE_PASSWORD: ${DB_PASSWORD}
      SPRING_JPA_SHOW_SQL: "false"
    expose:
      - "8080"
    networks:
      - backend
      - frontend
    healthcheck:
      test: ["CMD-SHELL", "wget -q --spider http://localhost:8080/api/settings/public || exit 1"]
      interval: 30s
      timeout: 5s
      retries: 5
      start_period: 45s

  nginx:
    image: nginx:1.27-alpine
    container_name: swe-quizzes-nginx
    restart: unless-stopped
    depends_on:
      - app
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx/nginx.conf:/etc/nginx/nginx.conf:ro
      - /etc/letsencrypt:/etc/letsencrypt:ro
    networks:
      - frontend

volumes:
  postgres_data:

networks:
  backend:
  frontend:
```

## 10. Create Nginx Config

If you have a domain and want HTTPS, first create the certificate while port 80 is free:

```bash
sudo certbot certonly --standalone -d quiz.example.com
```

Replace `quiz.example.com` with your real domain.

Then create `nginx/nginx.conf`:

```bash
nano nginx/nginx.conf
```

Paste this HTTPS config and replace `quiz.example.com`:

```nginx
events {
    worker_connections 1024;
}

http {
    server {
        listen 80;
        server_name quiz.example.com;

        location / {
            return 301 https://$host$request_uri;
        }
    }

    server {
        listen 443 ssl;
        server_name quiz.example.com;

        ssl_certificate /etc/letsencrypt/live/quiz.example.com/fullchain.pem;
        ssl_certificate_key /etc/letsencrypt/live/quiz.example.com/privkey.pem;

        client_max_body_size 10m;

        location / {
            proxy_pass http://app:8080;
            proxy_http_version 1.1;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }
    }
}
```

If you do not have a domain yet, use temporary HTTP only:

```nginx
events {
    worker_connections 1024;
}

http {
    server {
        listen 80;
        server_name _;

        client_max_body_size 10m;

        location / {
            proxy_pass http://app:8080;
            proxy_http_version 1.1;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }
    }
}
```

The `X-Forwarded-For` header is important because the backend access/session logs use it to store the visitor IP.

Country logging note:

- On a plain EC2 + Nginx deployment, the app will normally store `UNKNOWN` for country.
- If you need country values, put Cloudflare or CloudFront in front of EC2 so a country header such as `CF-IPCountry` or `CloudFront-Viewer-Country` reaches the backend.

## 11. Copy the JAR to EC2

From your local machine, in the project root:

```bash
scp -i ~/.ssh/swe-quizzes.pem \
  backend/target/swe-quizzes-0.0.1-SNAPSHOT.jar \
  ubuntu@YOUR_EC2_PUBLIC_IP:~/swe-quizzes/
```

On EC2, confirm it arrived:

```bash
cd ~/swe-quizzes
ls -lh swe-quizzes-0.0.1-SNAPSHOT.jar
```

## 12. Start the Application

On EC2:

```bash
cd ~/swe-quizzes
docker compose up -d --build
```

Check containers:

```bash
docker compose ps
```

Check logs:

```bash
docker compose logs -f app
```

Open the app:

- HTTPS with domain: `https://quiz.example.com`
- Temporary HTTP: `http://YOUR_EC2_PUBLIC_IP`

## 13. Verify the Deployment

On EC2:

```bash
curl -I http://localhost
curl -I http://localhost/api/settings/public
```

From your local machine:

```bash
curl -I https://quiz.example.com
curl https://quiz.example.com/api/settings/public
```

Expected result:

- The first URL loads Angular.
- `/api/settings/public` returns JSON from Spring Boot.
- Public quizzes are available without login.
- Register/login/admin/custom quizzes work through the same domain.

## 14. Redeploy a New Version

On your local machine:

```bash
./build-dist.sh
scp -i ~/.ssh/swe-quizzes.pem \
  backend/target/swe-quizzes-0.0.1-SNAPSHOT.jar \
  ubuntu@YOUR_EC2_PUBLIC_IP:~/swe-quizzes/
```

On EC2:

```bash
cd ~/swe-quizzes
docker compose up -d --build app
docker compose restart nginx
docker compose logs -f app
```

This keeps the PostgreSQL Docker volume intact.

## 15. Backup PostgreSQL

Create a backup folder:

```bash
mkdir -p ~/swe-quizzes/backups
cd ~/swe-quizzes
```

Run a manual backup:

```bash
DB_USER=$(grep '^DB_USER=' .env | cut -d= -f2-)
DB_NAME=$(grep '^DB_NAME=' .env | cut -d= -f2-)
docker compose exec -T postgres pg_dump -U "$DB_USER" "$DB_NAME" > "backups/swequizzes-$(date +%F-%H%M).sql"
```

Restore a backup:

```bash
DB_USER=$(grep '^DB_USER=' .env | cut -d= -f2-)
DB_NAME=$(grep '^DB_NAME=' .env | cut -d= -f2-)
docker compose exec -T postgres psql -U "$DB_USER" "$DB_NAME" < backups/YOUR_BACKUP_FILE.sql
```

For production, schedule backups with cron and copy them to S3 or another machine.

## 16. Certificate Renewal

Test renewal. Stop Nginx first because the certificate was created with Certbot standalone:

```bash
cd ~/swe-quizzes
docker compose stop nginx
sudo certbot renew --dry-run
docker compose start nginx
```

Renew certificates with the standalone Certbot plugin. Stop Nginx first so Certbot can use port 80:

```bash
cd ~/swe-quizzes
docker compose stop nginx
sudo certbot renew
docker compose start nginx
```

Certbot usually installs a system timer automatically. Check it with:

```bash
systemctl list-timers | grep certbot
```

## 17. Useful Operations

View all logs:

```bash
cd ~/swe-quizzes
docker compose logs -f
```

Restart only the app:

```bash
cd ~/swe-quizzes
docker compose restart app
```

Restart everything:

```bash
cd ~/swe-quizzes
docker compose restart
```

Stop everything:

```bash
cd ~/swe-quizzes
docker compose down
```

Kill any local process using port 8080 on the server:

```bash
kill $(lsof -ti tcp:8080)
```

Check disk usage:

```bash
df -h
docker system df
```

Clean unused Docker build cache and old images:

```bash
docker system prune -f
```

## 18. Troubleshooting

App container exits immediately:

```bash
docker compose logs app
```

Common causes:

- Wrong database password in `.env`.
- PostgreSQL is still starting.
- JAR file name does not match `swe-quizzes-0.0.1-SNAPSHOT.jar`.
- The JAR was copied before running `./build-dist.sh`.

Nginx returns `502 Bad Gateway`:

```bash
docker compose ps
docker compose logs app
docker compose logs nginx
```

Common causes:

- App container is not healthy yet.
- App failed to connect to PostgreSQL.
- Nginx config uses the wrong upstream name. It must proxy to `http://app:8080`.

HTTPS certificate fails:

- Confirm DNS points to the EC2 Elastic IP.
- Confirm security group allows inbound port 80.
- Stop anything using port 80 before running `certbot certonly --standalone`.

Database data disappeared:

- Confirm you used the named Docker volume `postgres_data`.
- Do not run `docker compose down -v` unless you intentionally want to delete the database volume.

Memory problems on `t4g.small`:

- Lower Java heap in the Dockerfile, for example `-Xmx512m`.
- Stop unused services.
- Move to `t4g.medium`.

## 19. Final Production Checklist

- `./build-dist.sh` builds successfully locally.
- `backend/target/swe-quizzes-0.0.1-SNAPSHOT.jar` was copied to EC2.
- EC2 security group exposes only 22, 80, and 443.
- Ports 8080 and 5432 are not public.
- `.env` uses a strong database password.
- Nginx forwards `X-Forwarded-For`.
- Domain points to the Elastic IP.
- HTTPS certificate is installed and renews.
- PostgreSQL backups are scheduled.
- Public system quizzes work without login.
- Register/login/admin/my quizzes flows work after deployment.
