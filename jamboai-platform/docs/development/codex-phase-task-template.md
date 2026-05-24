# Codex Phase Task Template

Use this template for every JamboAI development task. The goal is to keep Codex implementation aligned with the architecture, SQL schema and phase roadmap.

## Required Inputs

Before starting a task, identify:

- Phase number and phase name.
- Target client: `admin-ui`, `merchant-mobile`, `customer-mobile`, backend or infra.
- Target API root: `/api/sys`, `/api/mch`, `/api/usr`, `/api/pub` or `/api/whk`.
- Target module: `base`, `cmh`, `igw`, `iar`, `knc`, `opc`, `prc` or `udi`.
- SQL tables involved.
- Account subject: `sys_user`, `biz_base_merchant_staff` or `biz_base_member`.
- Data scope fields required.
- Whether the task needs mock, sandbox or production adapter behavior.

## Implementation Order

1. Read the relevant SQL table comments and existing module boundaries.
2. Check whether RuoYi-Vue-Plus already provides the capability.
3. Add or update backend domain, mapper, service, controller and DTOs.
4. Add permission codes and menu records when the API is admin or merchant managed.
5. Add frontend API client functions.
6. Add frontend pages or mobile views.
7. Add validation, data scope checks and idempotency where required.
8. Add focused tests or at least build verification.
9. Update phase notes when behavior or API decisions change.

## API Rules

- New platform admin APIs use `/api/sys/**`.
- New merchant APIs use `/api/mch/**`.
- New customer APIs use `/api/usr/**`.
- Public login/bootstrap APIs use `/api/pub/**`.
- External provider callbacks use `/api/whk/**`.
- Do not introduce `/api/admin/**`, `/api/merchant/**`, `/api/customer/**`, `/api/open/**` or `/api/webhook/**`.

## Backend Rules

- Use `org.dromara.jamboai.*` for JamboAI packages.
- Keep business modules low-coupled. Cross-module calls should go through service interfaces or domain events.
- Do not put merchant staff into `sys_user`.
- Do not put end users into `sys_user`.
- Do not call provider SDKs directly from domain services.
- Do not let AI tools directly update persistence tables.
- Do not update payment or wallet balances without ledger records.

## Frontend Rules

- `admin-ui` should follow plus-ui and RuoYi UI patterns.
- `merchant-mobile` has priority over `customer-mobile`.
- `customer-mobile` is an independent App/H5 entry and must not be modeled as a WhatsApp-only supplement.
- Use i18n keys for visible text that belongs to reusable navigation, menus, statuses or errors.
- Arabic support must consider RTL layout.

## Acceptance Checklist

Each task should finish with:

- Backend builds when backend code changed.
- Target frontend builds when frontend code changed.
- API paths follow the confirmed prefix standard.
- Permission codes are documented or seeded.
- Data scope is enforced.
- Mock/sandbox behavior is available for external integrations.
- No unrelated RuoYi framework changes.

## Commit Guidance

Use focused commits:

```text
feat(base): add merchant staff login foundation
feat(cmh): add whatsapp mock inbound webhook
feat(opc): add merchant goods management
feat(iar): add agent tool execution log
docs(roadmap): update phase 2 acceptance notes
```
