# JamboAI API 规范

## 已确认根前缀

所有新的 JamboAI API 使用以下根前缀。

| 前缀 | 客户端 | 含义 |
| --- | --- | --- |
| `/api/sys/**` | `admin-ui` | 平台后台、国家租户后台、城市代理后台，以及 JamboAI 新增的后台管理 API |
| `/api/mch/v1/**` | `merchant-mobile` | 带版本的商户员工 API |
| `/api/usr/v1/**` | `customer-mobile` | 带版本的终端用户 App/H5 API |
| `/api/pub/**` | 公共客户端 | 登录、验证码、租户初始化、公共配置等匿名或半公开 API |
| `/api/whk/**` | 外部服务商 | WhatsApp、支付服务商和未来渠道服务商的 Webhook 回调 |

新的 JamboAI API 不使用 `/api/admin/**`、`/api/merchant/**`、`/api/customer/**`、`/api/open/**` 或 `/api/webhook/**`。

## 资源路径风格

根前缀保持简短，资源名保持清晰。

```text
/api/sys/{module}/{resource}
/api/mch/v1/{module}/{resource}
/api/usr/v1/{module}/{resource}
/api/pub/{module}/{resource}
/api/whk/{provider}/{event}
```

示例：

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

## 模块路径编码

路径第二级使用 SQL 和模块中的稳定缩写。

| 路径编码 | 模块 |
| --- | --- |
| `base` | 平台基础和组织数据 |
| `cmh` | Communication Hub，通信中心 |
| `igw` | Intelligence Gateway，智能网关 |
| `iar` | Agent Runtime，Agent 运行时 |
| `knc` | Knowledge Center，知识中心 |
| `opc` | Operation Center，运营中心 |
| `prc` | Payment & Risk Center，支付与风控中心 |
| `udi` | Unified Data Intelligence，统一数据智能 |
| `sys` | RuoYi 系统管理相关扩展 |

## 认证和 Token 规则

建议按账号主体分离登录入口：

| 客户端 | 登录 API | Token 主体 |
| --- | --- | --- |
| 平台后台 | `/api/pub/auth/sys/login` | `sys_user` |
| 商户员工 | `/api/pub/auth/mch/v1/login` | `biz_base_merchant_staff` |
| 终端用户 | `/api/pub/auth/usr/v1/login` | `biz_base_member` |

登录后，不同客户端调用对应根前缀：

- 平台后台使用 `/api/sys/**`。
- 商户员工使用 `/api/mch/v1/**`。
- 终端用户使用 `/api/usr/v1/**`。

## Webhook 规则

所有外部回调统一使用 `/api/whk/**`。

推荐格式：

```text
/api/whk/{provider}/{product}/{event}
```

示例：

```text
/api/whk/whatsapp/cloud/messages
/api/whk/whatsapp/cloud/status
/api/whk/pay/flutterwave/callback
```

Webhook 处理器必须：

- 在服务商支持时校验签名或校验 token。
- 保存原始请求体和请求头。
- 保证幂等。
- 快速返回服务商兼容响应。
- 对耗时业务处理发布内部事件。

## 响应格式

复用 RuoYi-Vue-Plus 响应风格：

- 成功：`R.ok(data)`。
- 失败：`R.fail(code, message)`。
- 分页：复用 RuoYi 表格/分页响应结构。

移动端 API 默认也使用同一响应 envelope，除非后续有明确理由引入移动端专用格式。

## 权限码风格

后台权限码保持 RuoYi 兼容格式：

```text
{module}:{resource}:{action}
```

示例：

```text
base:merchant:list
base:merchant:add
cmh:session:list
iar:agent:edit
```

商户端权限码增加 `mch` 前缀：

```text
mch:{module}:{resource}:{action}
```

示例：

```text
mch:cmh:session:reply
mch:opc:goods:add
mch:opc:order:confirm
```

用户端 API 主要依靠资源归属校验，不采用菜单权限模式。

## RuoYi 原生 API 说明

RuoYi 自带的原生 API 不需要为了 JamboAI 命名规范而主动迁移。

原因：

- plus-ui 和 RuoYi 后台已有大量页面、权限、路由依赖原生接口。
- 一次性修改原生路径会增加升级和回归风险。
- JamboAI 当前目标是复用 RuoYi，而不是改造 RuoYi 框架本身。

推荐做法：

- RuoYi 原生系统能力保持原路径和原调用方式。
- JamboAI 新增业务 API 统一使用 `/api/sys/**`、`/api/mch/v1/**`、`/api/usr/v1/**`、`/api/pub/**`、`/api/whk/**`。
- 只有当 JamboAI 页面需要对 RuoYi 能力增加业务约束、数据范围或聚合视图时，再新增一个 JamboAI 包装接口。

## 已确认事项

| 事项 | 建议选择 | 原因 |
| --- | --- | --- |
| API 版本号 | 商户端和用户端 API 增加 `/v1`：`/api/mch/v1/**`、`/api/usr/v1/**` | 商户端和用户端是独立客户端，后续可能需要更频繁地做兼容升级 |
| RuoYi 原生 API | 保持原样，除非具体 JamboAI 扩展需要包装接口 | 降低 plus-ui 复用和 RuoYi 升级风险 |
| 登录路径 | 使用 `/api/pub/auth/sys/login`、`/api/pub/auth/mch/v1/login`、`/api/pub/auth/usr/v1/login` | 登录属于公共入口，同时分离账号主体，并给独立客户端登录接口加版本 |
| 服务商回调 | 所有回调统一放到 `/api/whk/**`，包括支付回调 | 统一外部回调安全策略 |
| 开放伙伴 API | 暂时预留 `/api/pub/open/**`，等真实伙伴 API 出现再设计 | 避免过早设计无实际使用场景的公开接口 |
