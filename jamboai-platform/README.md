# JamboAI Platform

JamboAI is an AI-driven, fully managed WhatsApp commerce service platform for Africa and Southeast Asia. It supports country tenants, city agents, merchants and customers, with merchant-owned WhatsApp numbers, AI assisted conversations, product recommendation, payment guidance and human handover.

## Project Layout

```text
jamboai-platform/
  backend/          RuoYi-Vue-Plus + Spring Boot 3.x backend
  admin-ui/         plus-ui based platform admin console
  merchant-mobile/  Ionic Vue + Capacitor merchant app
  customer-mobile/  Ionic Vue + Capacitor customer app
  infra/            PostgreSQL 16 + pgvector, Redis, MinIO local infra
  docs/             JamboAI architecture and database documents
```

## Backend Modules

The RuoYi modules remain as the framework foundation. JamboAI business code is isolated under `backend/jamboai-modules`:

| Module | Responsibility |
| --- | --- |
| `jamboai-common-domain` | shared org scope, module names and Spring Event contract |
| `jamboai-platform-foundation` | country tenant extension, city agent, merchant, staff, member and app permission domains |
| `jamboai-communication-hub` | WhatsApp account, phone, session, message, template and handover domains |
| `jamboai-intelligence-gateway` | LangChain4j model provider, model route, prompt and token/model call logs |
| `jamboai-agent-runtime` | agent capability, tools, templates, merchant agent apps and tool execution tasks |
| `jamboai-knowledge-center` | documents, chunks, pgvector embeddings and FAQ |
| `jamboai-operation-center` | goods, SKU, orders, services, schedules, bookings and verification |
| `jamboai-payment-risk-center` | Flutterwave payment, wallet, fees, commission, settlement, withdraw, reconciliation and risk |
| `jamboai-unified-data-intelligence` | memory, feedback, metrics and behavior |

## Local Start

1. Start infrastructure:

```bash
cd infra/docker
docker compose up -d
```

2. Build backend:

```bash
cd backend
mvn -DskipTests package
```

3. Start admin UI:

```bash
cd admin-ui
npm install
npm run dev
```

4. Start mobile apps:

```bash
cd merchant-mobile
npm install
npm run dev
```

```bash
cd customer-mobile
npm install
npm run dev
```

## Database

The PRD 2.3/2.4 schema is stored at `infra/sql/jamboai_prd_2_3_schema_standardized_full_comments_v2_4.sql`. The database design document is preserved under `docs/`.

The schema follows the core rule from PRD 2.3/2.4: do not extend RuoYi `sys_tenant` directly. JamboAI country, localization, currency, timezone, default language, payment, AI and compliance extensions are stored in `biz_base_tenant_ext`.
