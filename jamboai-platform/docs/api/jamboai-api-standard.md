# JamboAI API Standard

## Confirmed Root Prefixes

Use the following API root prefixes for all new JamboAI APIs.

| Prefix | Client | Meaning |
| --- | --- | --- |
| `/api/sys/**` | `admin-ui` | Platform admin, tenant admin, city agent admin and RuoYi-compatible management APIs |
| `/api/mch/v1/**` | `merchant-mobile` | Versioned merchant staff APIs |
| `/api/usr/v1/**` | `customer-mobile` | Versioned end user App/H5 APIs |
| `/api/pub/**` | Public clients | Public, anonymous or semi-public APIs, including login, captcha, tenant bootstrap and public config |
| `/api/whk/**` | External providers | Webhooks from WhatsApp, payment providers and future channel providers |

Do not use `/api/admin/**`, `/api/merchant/**`, `/api/customer/**`, `/api/open/**` or `/api/webhook/**` for new JamboAI APIs.

## Recommended Resource Style

Use short root prefixes, then keep resource names clear.

```text
/api/sys/{module}/{resource}
/api/mch/v1/{module}/{resource}
/api/usr/v1/{module}/{resource}
/api/pub/{module}/{resource}
/api/whk/{provider}/{event}
```

Examples:

```text
GET    /api/sys/base/merchants
POST   /api/sys/base/merchants
GET    /api/mch/v1/cmh/sessions
POST   /api/mch/v1/cmh/sessions/{sessionId}/messages
GET    /api/usr/v1/opc/goods
POST   /api/usr/v1/opc/orders
POST   /api/pub/auth/mch/v1/login
POST   /api/pub/auth/usr/v1/login
POST   /api/whk/whatsapp/cloud/messages
POST   /api/whk/pay/flutterwave/callback
```

## Module Path Codes

Use the existing SQL/module abbreviations in path level 2. They are short and stable.

| Path code | Module |
| --- | --- |
| `base` | Platform foundation and organization data |
| `cmh` | Communication Hub |
| `igw` | Intelligence Gateway |
| `iar` | Agent Runtime |
| `knc` | Knowledge Center |
| `opc` | Operation Center |
| `prc` | Payment & Risk Center |
| `udi` | Unified Data Intelligence |
| `sys` | RuoYi system management APIs retained under platform admin |

## Auth and Token Rules

Recommended token separation:

| Client | Login API | Token subject |
| --- | --- | --- |
| Platform admin | `/api/pub/auth/sys/login` | `sys_user` |
| Merchant staff | `/api/pub/auth/mch/v1/login` | `biz_base_merchant_staff` |
| End user | `/api/pub/auth/usr/v1/login` | `biz_base_member` |

After login, authenticated business APIs use the matching root prefix:

- Platform admin uses `/api/sys/**`.
- Merchant staff uses `/api/mch/v1/**`.
- End user uses `/api/usr/v1/**`.

## Webhook Rules

All external callbacks use `/api/whk/**`.

Recommended format:

```text
/api/whk/{provider}/{product}/{event}
```

Examples:

```text
/api/whk/whatsapp/cloud/messages
/api/whk/whatsapp/cloud/status
/api/whk/pay/flutterwave/callback
```

Webhook handlers must:

- Verify signatures or provider tokens when the provider supports it.
- Store raw request body and headers in callback or message logs.
- Be idempotent.
- Return provider-compatible responses quickly.
- Publish internal events for slow business processing.

## Response Format

Reuse the RuoYi-Vue-Plus response style for backend consistency:

- Success: `R.ok(data)`.
- Failure: `R.fail(code, message)`.
- Paged data: RuoYi table/page response style.

For mobile APIs, keep the same envelope unless there is a strong reason to introduce a mobile-only format.

## Permission Code Style

Admin permission codes keep the RuoYi-compatible format:

```text
{module}:{resource}:{action}
```

Examples:

```text
base:merchant:list
base:merchant:add
cmh:session:list
iar:agent:edit
```

Merchant permission codes should be prefixed:

```text
mch:{module}:{resource}:{action}
```

Examples:

```text
mch:cmh:session:reply
mch:opc:goods:add
mch:opc:order:confirm
```

End user APIs generally rely on ownership checks instead of menu permissions.

## Confirmed Decisions

The following API decisions have been confirmed for Phase 1 implementation:

| Item | Recommended choice | Reason |
| --- | --- | --- |
| API versioning | Add `/v1` to merchant and customer APIs: `/api/mch/v1/**`, `/api/usr/v1/**` | Merchant and customer clients are independent apps and may need frequent compatibility updates |
| RuoYi native APIs | Keep original RuoYi framework APIs unchanged unless a concrete JamboAI extension requires a wrapper | Reduces risk when reusing plus-ui and RuoYi internals |
| Login path | Use `/api/pub/auth/sys/login`, `/api/pub/auth/mch/v1/login`, `/api/pub/auth/usr/v1/login` | Keeps login public, separates account subjects and versions independent clients |
| Provider callbacks | Put all provider callbacks under `/api/whk/**`, including payment callbacks | One external callback security policy |
| Open partner API | Reserve `/api/pub/open/**` until partner API is truly needed | Avoid designing unused public API too early |
