# JamboAI 平台

JamboAI 是面向非洲和东南亚市场的 AI 驱动全托管 WhatsApp 商业服务平台。系统支持国家租户、城市代理、商户和终端用户四层业务结构，支持商户绑定自己的 WhatsApp 号码，支持 AI 辅助会话、商品推荐、支付引导和人工接管。

## 项目结构

```text
jamboai-platform/
  backend/          RuoYi-Vue-Plus + Spring Boot 3.x 后端
  admin-ui/         基于 plus-ui 的平台后台
  merchant-mobile/  Ionic Vue + Capacitor 商户端
  customer-mobile/  Ionic Vue + Capacitor 用户端
  infra/            PostgreSQL 16 + pgvector、Redis、MinIO 等基础设施
  docs/             JamboAI 架构和数据库文档
```

## 后端模块

RuoYi 模块作为框架底座保留。JamboAI 业务代码统一放在 `backend/jamboai-modules` 下：

| 模块 | 职责 |
| --- | --- |
| `jamboai-common-domain` | 共享组织范围、模块名和 Spring Event 契约 |
| `jamboai-platform-foundation` | 国家租户扩展、城市代理、商户、员工、会员和应用权限领域 |
| `jamboai-communication-hub` | WhatsApp 账号、号码、会话、消息、模板和人工接管领域 |
| `jamboai-intelligence-gateway` | LangChain4j 模型供应商、模型路由、提示词和调用日志 |
| `jamboai-agent-runtime` | Agent 能力、工具、模板、商户 Agent 应用和工具执行任务 |
| `jamboai-knowledge-center` | 文档、切片、pgvector 向量和 FAQ |
| `jamboai-operation-center` | 商品、SKU、订单、服务、排期、预约和核销 |
| `jamboai-payment-risk-center` | Flutterwave 支付、钱包、费用、分佣、结算、提现、对账和风控 |
| `jamboai-unified-data-intelligence` | 记忆、反馈、指标和行为数据 |

## 部署域名

| 入口 | 域名 |
| --- | --- |
| 后台管理 API | `https://japi.aged100.com` |
| 后台管理前端 | `https://jui.aged100.com` |
| 用户端 | `https://juser.aged100.com` |
| 商户端 | `https://jmch.aged100.com` |

## 本地启动

1. 启动基础设施：

```bash
cd infra/docker
docker compose up -d
```

2. 打包后端：

```bash
cd backend
mvn -DskipTests package
```

3. 启动后台前端：

```bash
cd admin-ui
npm install
npm run dev
```

4. 启动移动端：

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

## 数据库

PRD 2.3/2.4 schema 存放在 `infra/sql/jamboai_prd_2_3_schema_standardized_full_comments_v2_4.sql`。数据库设计说明文档保存在 `docs/` 下。

schema 遵循 PRD 2.3/2.4 的核心规则：不直接扩展 RuoYi `sys_tenant`。JamboAI 的国家、本地化、币种、时区、默认语言、支付、AI 和合规扩展信息存放在 `biz_base_tenant_ext` 中。

## 架构文档

| 文档 | 用途 |
| --- | --- |
| `docs/architecture/jamboai-overall-architecture.zh-CN.md` | 整体架构、模块职责、多渠道、支付、国际化和数据范围规则 |
| `docs/api/jamboai-api-standard.zh-CN.md` | API 前缀和命名规范 |
| `docs/roadmap/jamboai-phased-roadmap-v2.zh-CN.md` | 阶段 0 到阶段 6 的开发路线图 |
| `docs/development/codex-phase-task-template.zh-CN.md` | 后续 Codex 开发任务检查清单 |
| `docs/architecture/module-boundaries.zh-CN.md` | Maven 模块和 SQL 表边界映射 |
