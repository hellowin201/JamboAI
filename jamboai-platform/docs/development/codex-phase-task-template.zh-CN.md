# Codex 阶段任务模板

每个 JamboAI 开发任务都使用本模板。目标是让 Codex 实现始终对齐架构、SQL schema 和阶段路线图。

## 必要输入

开始任务前先明确：

- 阶段编号和阶段名称。
- 目标客户端：`admin-ui`、`merchant-mobile`、`customer-mobile`、后端或基础设施。
- 目标 API 根前缀：`/api/sys`、`/api/mch/v1`、`/api/usr/v1`、`/api/pub` 或 `/api/whk`。
- 目标模块：`base`、`cmh`、`igw`、`iar`、`knc`、`opc`、`prc` 或 `udi`。
- 涉及的 SQL 表。
- 账号主体：`sys_user`、`biz_base_merchant_staff` 或 `biz_base_member`。
- 必须校验的数据范围字段。
- 是否需要 mock、sandbox 或 production 适配器行为。

## 实现顺序

1. 阅读相关 SQL 表注释和现有模块边界。
2. 检查 RuoYi-Vue-Plus 是否已经提供该能力。
3. 新增或更新后端 domain、mapper、service、controller 和 DTO。
4. 当 API 属于后台或商户端管理能力时，补充权限码和菜单记录。
5. 增加前端 API client 函数。
6. 增加前端页面或移动端视图。
7. 增加校验、数据范围检查和必要的幂等处理。
8. 增加聚焦测试，至少完成构建验证。
9. 当行为或 API 决策变化时，更新阶段说明。

## API 规则

- 新的平台后台 API 使用 `/api/sys/**`。
- 新的商户端 API 使用 `/api/mch/v1/**`。
- 新的用户端 API 使用 `/api/usr/v1/**`。
- 公共登录和初始化 API 使用 `/api/pub/**`。
- 外部服务商回调使用 `/api/whk/**`。
- 不引入 `/api/admin/**`、`/api/merchant/**`、`/api/customer/**`、`/api/open/**` 或 `/api/webhook/**`。
- RuoYi 原生 API 保持原样，除非某个 JamboAI 业务场景明确需要包装接口。

## 后端规则

- JamboAI 包名使用 `org.dromara.jamboai.*`。
- 保持业务模块低耦合。跨模块调用应通过服务接口或领域事件。
- 不把商户员工放入 `sys_user`。
- 不把终端用户放入 `sys_user`。
- 领域服务不直接调用服务商 SDK。
- AI 工具不直接更新持久化表。
- 没有账本记录时，不更新支付或钱包余额。

## 前端规则

- `admin-ui` 遵循 plus-ui 和 RuoYi UI 模式。
- `merchant-mobile` 优先级高于 `customer-mobile`。
- `customer-mobile` 是独立 App/H5 入口，不能建模成 WhatsApp 的附属入口。
- 可复用导航、菜单、状态和错误提示必须使用 i18n key。
- 阿拉伯语支持需要考虑 RTL 布局。

## 验收清单

每个任务完成时应满足：

- 修改后端代码时，后端构建通过。
- 修改前端代码时，目标前端构建通过。
- API 路径符合已确认前缀规范。
- 权限码已记录或已初始化。
- 数据范围已强制校验。
- 外部集成具备 mock/sandbox 行为。
- 没有无关的 RuoYi 框架改动。

## 提交建议

使用聚焦提交：

```text
feat(base): add merchant staff login foundation
feat(cmh): add whatsapp mock inbound webhook
feat(opc): add merchant goods management
feat(iar): add agent tool execution log
docs(roadmap): update phase 2 acceptance notes
```
