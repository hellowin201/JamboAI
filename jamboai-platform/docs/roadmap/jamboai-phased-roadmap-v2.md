# JamboAI Phased Roadmap V2

## Planning Rule

This roadmap replaces the earlier linear six-phase split. The new plan keeps Phase 0, then organizes the remaining work around business slices that Codex can implement and verify incrementally.

RuoYi-Vue-Plus existing features should be reused whenever possible. Do not rebuild system user, role, menu, dictionary, OSS, log, monitor or code generation features unless JamboAI needs an extension point.

## Phase 0: Engineering Baseline

Goal: make the codebase stable for modular development.

Scope:

- Use the latest 83-table SQL as the only schema baseline.
- Keep all JamboAI business code under `org.dromara.jamboai.*`.
- Keep Maven module names, frontend project names and documents using `jamboai`.
- Confirm API roots: `/api/sys/**`, `/api/mch/**`, `/api/usr/**`, `/api/pub/**`, `/api/whk/**`.
- Establish business context: `tenant_id`, `agent_id`, `merchant_id`, `staff_id`, `member_id`, `channel_type`.
- Establish adapter interfaces for WhatsApp, payment and model providers.
- Establish mock/sandbox/production environment switch rules.
- Seed the 10 supported languages.
- Keep build verification for backend, admin UI, merchant mobile and customer mobile.

Acceptance:

- Backend builds successfully.
- Admin UI builds successfully.
- Merchant mobile builds successfully.
- Customer mobile builds successfully.
- Schema table count is 83 in `infra/sql`.
- Architecture and API documents are present in `docs`.

## Phase 1: Foundation, Organization, RBAC and I18n

Goal: make platform management and merchant identity usable.

Backend scope:

- Country tenant extension.
- City agent.
- Merchant.
- Merchant staff.
- Merchant role and permission.
- Member base profile.
- Merchant-member relation.
- Dictionary, country, city, currency, timezone, industry and language data.
- I18n message framework.
- Platform config framework for AI, channel, payment and file settings.

Frontend scope:

- `admin-ui`: tenant extension, city agent, merchant, staff, member and dictionary pages.
- `merchant-mobile`: merchant staff login, profile, role-aware shell and home page.
- `customer-mobile`: basic user login/register shell only when required for shared auth infrastructure.

RuoYi reuse:

- Reuse `sys_user`, `sys_role`, `sys_menu`, `sys_dept`, `sys_tenant`, `sys_dict`, `sys_config`, `sys_oss`, logs and permissions.
- Extend instead of rewriting RuoYi tenant and menu logic.

Acceptance:

- Platform admin can create tenant extension, city agent and merchant.
- Merchant staff can log in independently from `sys_user`.
- Merchant staff data is scoped by merchant.
- Admin menu and core app menu labels support the 10 configured languages.

## Phase 2: Merchant-First Communication MVP

Goal: let merchants receive, view and reply to conversations.

Backend scope:

- Channel account.
- WhatsApp phone.
- WhatsApp mock/sandbox/production configuration.
- WhatsApp webhook receive and verification.
- Session.
- Message.
- Handover.
- Message template.
- Spring Event processing for inbound messages.

Frontend scope:

- `admin-ui`: channel account, WhatsApp phone, webhook log and message log pages.
- `merchant-mobile`: session list, message view, unread state, manual reply and handover notice.
- `customer-mobile`: only basic customer entry shell if needed.

Acceptance:

- A mock WhatsApp inbound message creates or updates a session.
- Merchant mobile can see the session and reply.
- Handover from AI/bot mode to manual mode is visible to merchant staff.
- Webhook processing is idempotent.

## Phase 3: Goods, Services and Order MVP

Goal: make conversations connect to real commerce data.

Backend scope:

- Goods.
- SKU.
- Service.
- Service schedule basics.
- Order.
- Order item.
- Order flow.
- Booking and verification basics where needed.
- Mock payment intent placeholder only.

Frontend scope:

- `admin-ui`: goods, services and order oversight pages.
- `merchant-mobile`: goods management, service management and order management.
- `customer-mobile`: goods browsing, order creation and order detail.

AI preparation:

- Create business service interfaces that future AI tools can call:
  - search goods.
  - recommend goods.
  - create order draft.
  - query order.
  - query service schedule.

Acceptance:

- Merchant can create goods or services.
- Customer App/H5 can browse and create an order.
- Merchant can manage the order.
- WhatsApp session can be associated with order draft context.

## Phase 4: AI Agent and Knowledge MVP

Goal: make AI useful in customer service and commerce guidance.

Backend scope:

- Model provider.
- Model route.
- Prompt template.
- Model call log.
- Token log.
- Agent capability.
- Agent tool.
- Agent template.
- Merchant agent app.
- Agent task.
- Tool call log.
- Knowledge document, chunk, embedding and FAQ.

Frontend scope:

- `admin-ui`: model provider, route, prompt, agent template, tools and call logs.
- `merchant-mobile`: AI switch, agent app config, FAQ/knowledge basics and AI handover status.
- `customer-mobile`: AI-assisted customer conversation where applicable.

Tool rules:

- AI must call controlled tools, not repositories or mappers.
- Tool calls must check tenant, merchant, channel and user scope.
- High-risk actions must require confirmation.

Acceptance:

- Merchant can enable a configured AI agent.
- AI can answer from FAQ/knowledge.
- AI can call tools to search goods and create order drafts.
- Low-confidence or unsupported requests can transfer to manual service.

## Phase 5: Payment and Transaction Closure

Goal: make orders payable through configurable payment providers.

Backend scope:

- Payment channel.
- Platform account.
- Merchant payment account.
- Payment transaction.
- Payment callback log.
- Flutterwave adapter with mock/sandbox/production modes.
- Payment link creation.
- Order payment status event processing.
- Basic risk validation.

Frontend scope:

- `admin-ui`: payment channel, platform account, callback log and transaction pages.
- `merchant-mobile`: merchant payment account, payment status and order payment view.
- `customer-mobile`: payment link entry and payment result page.

Acceptance:

- Mock payment can complete an order end to end.
- Flutterwave sandbox/production configuration can be changed without code changes.
- Duplicate callbacks do not duplicate payment success.
- Order payment status is updated through payment domain events.

## Phase 6: Finance, Risk and Unified Data Intelligence

Goal: move from MVP to an operable commerce platform.

Backend scope:

- Wallet.
- Wallet ledger.
- Fee rule.
- Fee ledger.
- Commission ledger.
- Settlement.
- Withdraw.
- Reconciliation bill and detail.
- Risk score.
- Blacklist.
- UDI memory, feedback, metrics and behavior.

Frontend scope:

- `admin-ui`: settlement, withdraw, reconciliation, risk, behavior and metrics dashboards.
- `merchant-mobile`: balance, settlement, withdraw and business metrics.
- `customer-mobile`: feedback and personal behavior-driven recommendations where applicable.

Execution note:

Phase 6 is large. In implementation, split it into:

- Phase 6A: wallet, ledger, fee, commission, settlement, withdraw and reconciliation.
- Phase 6B: risk, memory, feedback, metrics, behavior and analytics dashboards.

Acceptance:

- Money movement has ledger records.
- Platform can calculate fees and commissions.
- Merchant can view settlement and withdraw status.
- Operators can see conversion, AI hit rate, handover rate, payment rate and order metrics.
