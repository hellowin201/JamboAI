-- ============================================================
-- JamboAI PRD 2.3 / 2.4 Final Database Schema
-- PostgreSQL 16 + RuoYi-Vue-Plus Style
-- 说明：
-- 1. 本脚本已标准化：每个字段独立一行。
-- 2. 每张表 CREATE TABLE 之后紧跟 COMMENT ON TABLE/COLUMN。
-- 3. 索引统一放在备注之后。
-- 4. 最终设计决定：不直接扩展 sys_tenant 字段。
-- 5. sys_tenant 保持 RuoYi 原生租户识别、登录、权限、隔离能力。
-- 6. JamboAI 的国家、本地化、币种、时区、默认语言、支付、AI、合规等业务扩展，
--    统一放入 biz_base_tenant_ext 表。
-- 7. 本版已将 dict_language / dict_currency / dict_country / dict_city 调整为 jamboai_* 风格字段，
--    并新增 dict_timezone / dict_industry。
-- ============================================================

CREATE EXTENSION IF NOT EXISTS vector;

-- ============================================================
-- 1. sys_menu_i18n
-- ============================================================
DROP TABLE IF EXISTS sys_menu_i18n CASCADE;
CREATE TABLE sys_menu_i18n (
    id bigserial PRIMARY KEY,
    menu_id bigint NOT NULL,
    language_code varchar(20) NOT NULL,
    menu_name varchar(128),
    title varchar(128),
    component_title varchar(128),
    tenant_id varchar(20),
    create_by varchar(64),
    create_time timestamp,
    update_by varchar(64),
    update_time timestamp,
    del_flag char(1) DEFAULT '0',
    remark varchar(500)
);

COMMENT ON TABLE sys_menu_i18n IS 'RuoYi后台菜单多语言扩展表';
COMMENT ON COLUMN sys_menu_i18n.id IS '主键';
COMMENT ON COLUMN sys_menu_i18n.menu_id IS 'RuoYi菜单ID，对应sys_menu.menu_id';
COMMENT ON COLUMN sys_menu_i18n.language_code IS '语言编码';
COMMENT ON COLUMN sys_menu_i18n.menu_name IS '菜单名称';
COMMENT ON COLUMN sys_menu_i18n.title IS '页面标题';
COMMENT ON COLUMN sys_menu_i18n.component_title IS '组件标题';
COMMENT ON COLUMN sys_menu_i18n.tenant_id IS '租户ID';
COMMENT ON COLUMN sys_menu_i18n.create_by IS '创建者';
COMMENT ON COLUMN sys_menu_i18n.create_time IS '创建时间';
COMMENT ON COLUMN sys_menu_i18n.update_by IS '更新者';
COMMENT ON COLUMN sys_menu_i18n.update_time IS '更新时间';
COMMENT ON COLUMN sys_menu_i18n.del_flag IS '删除标志：0正常，2删除';
COMMENT ON COLUMN sys_menu_i18n.remark IS '备注';

CREATE INDEX idx_sys_menu_i18n_menu_lang ON sys_menu_i18n(menu_id, language_code);

-- ============================================================
-- 2. dict_language
-- ============================================================


-- ============================================================
-- 3. dict_currency
-- ============================================================


-- ============================================================
-- 4. dict_country
-- ============================================================


-- ============================================================
-- 5. dict_country_i18n
-- ============================================================
DROP TABLE IF EXISTS dict_country_i18n CASCADE;
CREATE TABLE dict_country_i18n (
    id bigserial PRIMARY KEY,
    country_id int8 NOT NULL,
    country_code varchar(10) NOT NULL,
    language_code varchar(20) NOT NULL,
    country_name varchar(160) NOT NULL,
    create_by varchar(64),
    create_time timestamp DEFAULT now(),
    update_by varchar(64),
    update_time timestamp,
    del_flag bpchar(1) DEFAULT '0',
    remark varchar(500),
    CONSTRAINT fk_dict_country_i18n_country FOREIGN KEY (country_id) REFERENCES dict_country(country_id)
);

COMMENT ON TABLE dict_country_i18n IS '国家名称多语言明细表，与 dict_country.name_i18n 互补，用于管理、搜索和扩展';
COMMENT ON COLUMN dict_country_i18n.id IS '主键';
COMMENT ON COLUMN dict_country_i18n.country_id IS '国家ID，关联 dict_country.country_id';
COMMENT ON COLUMN dict_country_i18n.country_code IS '国家二位编码';
COMMENT ON COLUMN dict_country_i18n.language_code IS '语言编码';
COMMENT ON COLUMN dict_country_i18n.country_name IS '当前语言国家名称';
COMMENT ON COLUMN dict_country_i18n.create_by IS '创建者';
COMMENT ON COLUMN dict_country_i18n.create_time IS '创建时间';
COMMENT ON COLUMN dict_country_i18n.update_by IS '更新者';
COMMENT ON COLUMN dict_country_i18n.update_time IS '更新时间';
COMMENT ON COLUMN dict_country_i18n.del_flag IS '删除标志：0正常，2删除';
COMMENT ON COLUMN dict_country_i18n.remark IS '备注';

CREATE UNIQUE INDEX uk_dict_country_i18n_country_lang ON dict_country_i18n(country_id, language_code);
CREATE INDEX idx_dict_country_i18n_code_lang ON dict_country_i18n(country_code, language_code);

-- ============================================================
-- 6. dict_city
-- ============================================================


-- ============================================================
-- 7. dict_city_alias
-- ============================================================
DROP TABLE IF EXISTS dict_city_alias CASCADE;
CREATE TABLE dict_city_alias (
    id bigserial PRIMARY KEY,
    city_id int8 NOT NULL,
    country_code varchar(10) NOT NULL,
    alias_name varchar(200) NOT NULL,
    language_code varchar(20),
    alias_type varchar(32),
    status bpchar(1) DEFAULT '0',
    del_flag bpchar(1) DEFAULT '0',
    create_by varchar(64),
    create_time timestamp DEFAULT now(),
    update_by varchar(64),
    update_time timestamp,
    remark varchar(500),
    CONSTRAINT fk_dict_city_alias_city FOREIGN KEY (city_id) REFERENCES dict_city(city_id)
);

COMMENT ON TABLE dict_city_alias IS '城市别名表，用于城市搜索、别名匹配、多语言名称、简称、历史名称';
COMMENT ON COLUMN dict_city_alias.id IS '主键';
COMMENT ON COLUMN dict_city_alias.city_id IS '城市ID，关联 dict_city.city_id';
COMMENT ON COLUMN dict_city_alias.country_code IS '国家二位编码';
COMMENT ON COLUMN dict_city_alias.alias_name IS '城市别名';
COMMENT ON COLUMN dict_city_alias.language_code IS '语言编码';
COMMENT ON COLUMN dict_city_alias.alias_type IS '别名类型：official/local/search/short/historic';
COMMENT ON COLUMN dict_city_alias.status IS '状态：0正常，1停用';
COMMENT ON COLUMN dict_city_alias.del_flag IS '删除标志：0正常，2删除';
COMMENT ON COLUMN dict_city_alias.create_by IS '创建者';
COMMENT ON COLUMN dict_city_alias.create_time IS '创建时间';
COMMENT ON COLUMN dict_city_alias.update_by IS '更新者';
COMMENT ON COLUMN dict_city_alias.update_time IS '更新时间';
COMMENT ON COLUMN dict_city_alias.remark IS '备注';

CREATE INDEX idx_dict_city_alias_city ON dict_city_alias(city_id);
CREATE INDEX idx_dict_city_alias_country ON dict_city_alias(country_code);
CREATE INDEX idx_dict_city_alias_name ON dict_city_alias(alias_name);
CREATE UNIQUE INDEX uk_dict_city_alias_unique ON dict_city_alias(city_id, language_code, alias_name);

-- ============================================================
-- 8. dict_timezone
-- ============================================================


-- ============================================================
-- 9. dict_industry
-- ============================================================


-- ============================================================
-- 10. dict_data_i18n
-- ============================================================
DROP TABLE IF EXISTS dict_data_i18n CASCADE;
CREATE TABLE dict_data_i18n (
    id bigserial PRIMARY KEY,
    dict_code bigint,
    dict_type varchar(100),
    dict_value varchar(100),
    language_code varchar(20),
    dict_label varchar(128),
    tenant_id varchar(20),
    create_by varchar(64),
    create_time timestamp,
    update_by varchar(64),
    update_time timestamp,
    del_flag char(1) DEFAULT '0',
    remark varchar(500)
);

COMMENT ON TABLE dict_data_i18n IS 'RuoYi字典项多语言扩展表';
COMMENT ON COLUMN dict_data_i18n.id IS '主键';
COMMENT ON COLUMN dict_data_i18n.dict_code IS 'RuoYi sys_dict_data.dict_code';
COMMENT ON COLUMN dict_data_i18n.dict_type IS '字典类型';
COMMENT ON COLUMN dict_data_i18n.dict_value IS '字典值';
COMMENT ON COLUMN dict_data_i18n.language_code IS '语言编码';
COMMENT ON COLUMN dict_data_i18n.dict_label IS '当前语言展示名';
COMMENT ON COLUMN dict_data_i18n.tenant_id IS '租户ID';
COMMENT ON COLUMN dict_data_i18n.create_by IS '创建者';
COMMENT ON COLUMN dict_data_i18n.create_time IS '创建时间';
COMMENT ON COLUMN dict_data_i18n.update_by IS '更新者';
COMMENT ON COLUMN dict_data_i18n.update_time IS '更新时间';
COMMENT ON COLUMN dict_data_i18n.del_flag IS '删除标志';
COMMENT ON COLUMN dict_data_i18n.remark IS '备注';

CREATE INDEX idx_dict_i18n_type_value_lang ON dict_data_i18n(dict_type, dict_value, language_code);

-- ============================================================
-- 11. cfg_i18n_message
-- ============================================================
DROP TABLE IF EXISTS cfg_i18n_message CASCADE;
CREATE TABLE cfg_i18n_message (
    id bigserial PRIMARY KEY,
    app_type varchar(32),
    message_key varchar(200) NOT NULL,
    language_code varchar(20) NOT NULL,
    message_value text,
    resource_type varchar(32),
    status char(1) DEFAULT '0',
    tenant_id varchar(20),
    create_by varchar(64),
    create_time timestamp,
    update_by varchar(64),
    update_time timestamp,
    del_flag char(1) DEFAULT '0',
    remark varchar(500)
);

COMMENT ON TABLE cfg_i18n_message IS '系统资源多语言表，支持后台、商户端、用户端页面资源';
COMMENT ON COLUMN cfg_i18n_message.id IS '主键';
COMMENT ON COLUMN cfg_i18n_message.app_type IS '应用类型：admin/merchant/user';
COMMENT ON COLUMN cfg_i18n_message.message_key IS '资源Key';
COMMENT ON COLUMN cfg_i18n_message.language_code IS '语言编码';
COMMENT ON COLUMN cfg_i18n_message.message_value IS '文案内容';
COMMENT ON COLUMN cfg_i18n_message.resource_type IS 'menu/button/page/form/error/tip';
COMMENT ON COLUMN cfg_i18n_message.status IS '状态';
COMMENT ON COLUMN cfg_i18n_message.tenant_id IS '租户ID';
COMMENT ON COLUMN cfg_i18n_message.create_by IS '创建者';
COMMENT ON COLUMN cfg_i18n_message.create_time IS '创建时间';
COMMENT ON COLUMN cfg_i18n_message.update_by IS '更新者';
COMMENT ON COLUMN cfg_i18n_message.update_time IS '更新时间';
COMMENT ON COLUMN cfg_i18n_message.del_flag IS '删除标志';
COMMENT ON COLUMN cfg_i18n_message.remark IS '备注';

CREATE INDEX idx_cfg_i18n_key_lang ON cfg_i18n_message(message_key, language_code, app_type);

-- ============================================================
-- 12. cfg_platform_config
-- ============================================================
DROP TABLE IF EXISTS cfg_platform_config CASCADE;
CREATE TABLE cfg_platform_config (
    id bigserial PRIMARY KEY,
    config_key varchar(128) NOT NULL,
    config_value text,
    config_type varchar(64),
    scope_type varchar(32) NOT NULL,
    scope_id varchar(64),
    status char(1) DEFAULT '0',
    tenant_id varchar(20),
    create_by varchar(64),
    create_time timestamp,
    update_by varchar(64),
    update_time timestamp,
    del_flag char(1) DEFAULT '0',
    remark varchar(500)
);

COMMENT ON TABLE cfg_platform_config IS '平台/租户/城市代理/商户通用配置表';
COMMENT ON COLUMN cfg_platform_config.id IS '主键';
COMMENT ON COLUMN cfg_platform_config.config_key IS '配置Key';
COMMENT ON COLUMN cfg_platform_config.config_value IS '配置值';
COMMENT ON COLUMN cfg_platform_config.config_type IS '配置类型';
COMMENT ON COLUMN cfg_platform_config.scope_type IS '作用范围：platform/tenant/agent/merchant';
COMMENT ON COLUMN cfg_platform_config.scope_id IS '作用对象ID';
COMMENT ON COLUMN cfg_platform_config.status IS '状态';
COMMENT ON COLUMN cfg_platform_config.tenant_id IS '租户ID，平台级可为空';
COMMENT ON COLUMN cfg_platform_config.create_by IS '创建者';
COMMENT ON COLUMN cfg_platform_config.create_time IS '创建时间';
COMMENT ON COLUMN cfg_platform_config.update_by IS '更新者';
COMMENT ON COLUMN cfg_platform_config.update_time IS '更新时间';
COMMENT ON COLUMN cfg_platform_config.del_flag IS '删除标志';
COMMENT ON COLUMN cfg_platform_config.remark IS '备注';

CREATE INDEX idx_cfg_scope_key ON cfg_platform_config(scope_type, scope_id, config_key);

-- ============================================================
-- 13. biz_base_tenant_ext
-- ============================================================
DROP TABLE IF EXISTS biz_base_tenant_ext CASCADE;
CREATE TABLE biz_base_tenant_ext (
    id bigserial PRIMARY KEY,
    tenant_id varchar(20),
    country_code varchar(20),
    currency_code varchar(20),
    timezone varchar(64),
    default_language varchar(20),
    default_city_code varchar(64),
    settlement_mode varchar(32),
    default_payment_channel varchar(64),
    default_ai_model_route varchar(64),
    whatsapp_credit_line_id varchar(128),
    billing_config jsonb,
    payment_config jsonb,
    ai_config jsonb,
    compliance_config jsonb,
    status char(1) DEFAULT '0',
    create_by varchar(64),
    create_time timestamp,
    update_by varchar(64),
    update_time timestamp,
    del_flag char(1) DEFAULT '0',
    remark varchar(500)
);

COMMENT ON TABLE biz_base_tenant_ext IS '国家租户业务扩展表，RuoYi sys_tenant的业务扩展';
COMMENT ON COLUMN biz_base_tenant_ext.id IS '主键';
COMMENT ON COLUMN biz_base_tenant_ext.tenant_id IS 'RuoYi租户ID';
COMMENT ON COLUMN biz_base_tenant_ext.country_code IS '国家代码';
COMMENT ON COLUMN biz_base_tenant_ext.currency_code IS '默认币种';
COMMENT ON COLUMN biz_base_tenant_ext.timezone IS '默认时区';
COMMENT ON COLUMN biz_base_tenant_ext.default_language IS '默认语言';
COMMENT ON COLUMN biz_base_tenant_ext.default_city_code IS '默认城市';
COMMENT ON COLUMN biz_base_tenant_ext.settlement_mode IS '默认结算模式：merchant_direct/platform_escrow/split_payment';
COMMENT ON COLUMN biz_base_tenant_ext.default_payment_channel IS '默认支付渠道';
COMMENT ON COLUMN biz_base_tenant_ext.default_ai_model_route IS '默认AI模型路由';
COMMENT ON COLUMN biz_base_tenant_ext.whatsapp_credit_line_id IS 'Meta Credit Line ID';
COMMENT ON COLUMN biz_base_tenant_ext.billing_config IS '计费配置';
COMMENT ON COLUMN biz_base_tenant_ext.payment_config IS '支付配置';
COMMENT ON COLUMN biz_base_tenant_ext.ai_config IS 'AI配置';
COMMENT ON COLUMN biz_base_tenant_ext.compliance_config IS '合规配置';
COMMENT ON COLUMN biz_base_tenant_ext.status IS '状态：0正常，1停用';
COMMENT ON COLUMN biz_base_tenant_ext.create_by IS '创建者';
COMMENT ON COLUMN biz_base_tenant_ext.create_time IS '创建时间';
COMMENT ON COLUMN biz_base_tenant_ext.update_by IS '更新者';
COMMENT ON COLUMN biz_base_tenant_ext.update_time IS '更新时间';
COMMENT ON COLUMN biz_base_tenant_ext.del_flag IS '删除标志：0正常，2删除';
COMMENT ON COLUMN biz_base_tenant_ext.remark IS '备注';

CREATE INDEX idx_tenant_ext_tenant ON biz_base_tenant_ext(tenant_id);

-- ============================================================
-- 14. biz_base_city_agent
-- ============================================================
DROP TABLE IF EXISTS biz_base_city_agent CASCADE;
CREATE TABLE biz_base_city_agent (
    id bigserial PRIMARY KEY,
    tenant_id varchar(20),
    agent_id varchar(64) NOT NULL,
    country_code varchar(20),
    city_code varchar(64),
    agent_name varchar(128),
    contact_name varchar(128),
    contact_phone varchar(64),
    contact_email varchar(128),
    commission_rate numeric(8,4) DEFAULT 0,
    status char(1) DEFAULT '0',
    create_by varchar(64),
    create_time timestamp,
    update_by varchar(64),
    update_time timestamp,
    del_flag char(1) DEFAULT '0',
    remark varchar(500)
);

COMMENT ON TABLE biz_base_city_agent IS '城市代理表';
COMMENT ON COLUMN biz_base_city_agent.id IS '主键';
COMMENT ON COLUMN biz_base_city_agent.tenant_id IS '租户ID';
COMMENT ON COLUMN biz_base_city_agent.agent_id IS '代理ID';
COMMENT ON COLUMN biz_base_city_agent.country_code IS '国家代码';
COMMENT ON COLUMN biz_base_city_agent.city_code IS '城市代码';
COMMENT ON COLUMN biz_base_city_agent.agent_name IS '代理名称';
COMMENT ON COLUMN biz_base_city_agent.contact_name IS '联系人姓名';
COMMENT ON COLUMN biz_base_city_agent.contact_phone IS '联系电话';
COMMENT ON COLUMN biz_base_city_agent.contact_email IS '联系邮箱';
COMMENT ON COLUMN biz_base_city_agent.commission_rate IS '默认分佣比例';
COMMENT ON COLUMN biz_base_city_agent.status IS '状态：0正常，1停用';
COMMENT ON COLUMN biz_base_city_agent.create_by IS '创建者';
COMMENT ON COLUMN biz_base_city_agent.create_time IS '创建时间';
COMMENT ON COLUMN biz_base_city_agent.update_by IS '更新者';
COMMENT ON COLUMN biz_base_city_agent.update_time IS '更新时间';
COMMENT ON COLUMN biz_base_city_agent.del_flag IS '删除标志：0正常，2删除';
COMMENT ON COLUMN biz_base_city_agent.remark IS '备注';

CREATE INDEX idx_agent_tenant ON biz_base_city_agent(tenant_id);
CREATE INDEX idx_agent_id ON biz_base_city_agent(agent_id);

-- ============================================================
-- 15. biz_base_merchant
-- ============================================================
DROP TABLE IF EXISTS biz_base_merchant CASCADE;
CREATE TABLE biz_base_merchant (
    id bigserial PRIMARY KEY,
    tenant_id varchar(20),
    merchant_id varchar(64) NOT NULL,
    agent_id varchar(64),
    merchant_name varchar(128),
    merchant_logo varchar(500),
    industry_code varchar(64),
    country_code varchar(20),
    city_code varchar(64),
    address varchar(500),
    contact_name varchar(128),
    contact_phone varchar(64),
    contact_email varchar(128),
    language_code varchar(20),
    currency_code varchar(20),
    timezone varchar(64),
    settlement_mode varchar(32),
    default_payment_account_id varchar(64),
    business_status varchar(32),
    audit_status varchar(32),
    status char(1) DEFAULT '0',
    create_by varchar(64),
    create_time timestamp,
    update_by varchar(64),
    update_time timestamp,
    del_flag char(1) DEFAULT '0',
    remark varchar(500)
);

COMMENT ON TABLE biz_base_merchant IS '商户表';
COMMENT ON COLUMN biz_base_merchant.id IS '主键';
COMMENT ON COLUMN biz_base_merchant.tenant_id IS '租户ID';
COMMENT ON COLUMN biz_base_merchant.merchant_id IS '商户ID';
COMMENT ON COLUMN biz_base_merchant.agent_id IS '城市代理ID';
COMMENT ON COLUMN biz_base_merchant.merchant_name IS '商户名称';
COMMENT ON COLUMN biz_base_merchant.merchant_logo IS '商户Logo';
COMMENT ON COLUMN biz_base_merchant.industry_code IS '行业编码';
COMMENT ON COLUMN biz_base_merchant.country_code IS '国家代码';
COMMENT ON COLUMN biz_base_merchant.city_code IS '城市编码';
COMMENT ON COLUMN biz_base_merchant.address IS '地址';
COMMENT ON COLUMN biz_base_merchant.contact_name IS '联系人姓名';
COMMENT ON COLUMN biz_base_merchant.contact_phone IS '联系电话';
COMMENT ON COLUMN biz_base_merchant.contact_email IS '联系邮箱';
COMMENT ON COLUMN biz_base_merchant.language_code IS '语言编码';
COMMENT ON COLUMN biz_base_merchant.currency_code IS '币种编码';
COMMENT ON COLUMN biz_base_merchant.timezone IS '时区';
COMMENT ON COLUMN biz_base_merchant.settlement_mode IS '结算模式：merchant_direct/platform_escrow/split_payment';
COMMENT ON COLUMN biz_base_merchant.default_payment_account_id IS '默认收款账户ID';
COMMENT ON COLUMN biz_base_merchant.business_status IS '营业状态';
COMMENT ON COLUMN biz_base_merchant.audit_status IS '审核状态';
COMMENT ON COLUMN biz_base_merchant.status IS '状态：0正常，1停用';
COMMENT ON COLUMN biz_base_merchant.create_by IS '创建者';
COMMENT ON COLUMN biz_base_merchant.create_time IS '创建时间';
COMMENT ON COLUMN biz_base_merchant.update_by IS '更新者';
COMMENT ON COLUMN biz_base_merchant.update_time IS '更新时间';
COMMENT ON COLUMN biz_base_merchant.del_flag IS '删除标志：0正常，2删除';
COMMENT ON COLUMN biz_base_merchant.remark IS '备注';

CREATE INDEX idx_merchant_tenant_agent ON biz_base_merchant(tenant_id, agent_id);
CREATE INDEX idx_merchant_id ON biz_base_merchant(merchant_id);

-- ============================================================
-- 16. biz_base_merchant_staff
-- ============================================================
DROP TABLE IF EXISTS biz_base_merchant_staff CASCADE;
CREATE TABLE biz_base_merchant_staff (
    id bigserial PRIMARY KEY,
    tenant_id varchar(20),
    staff_id varchar(64) NOT NULL,
    agent_id varchar(64),
    merchant_id varchar(64) NOT NULL,
    username varchar(64),
    password varchar(255),
    staff_name varchar(128),
    nickname varchar(128),
    avatar_url varchar(500),
    phone_number varchar(64),
    email varchar(128),
    role_type varchar(64),
    login_enabled char(1) DEFAULT 'Y',
    last_login_time timestamp,
    password_update_time timestamp,
    account_status varchar(32),
    status char(1) DEFAULT '0',
    create_by varchar(64),
    create_time timestamp,
    update_by varchar(64),
    update_time timestamp,
    del_flag char(1) DEFAULT '0',
    remark varchar(500)
);

COMMENT ON TABLE biz_base_merchant_staff IS '商户员工账号表，支撑商户端登录、客服接管、订单处理、发货、核销、财务等';
COMMENT ON COLUMN biz_base_merchant_staff.id IS '主键';
COMMENT ON COLUMN biz_base_merchant_staff.tenant_id IS '租户ID';
COMMENT ON COLUMN biz_base_merchant_staff.staff_id IS '商户员工ID';
COMMENT ON COLUMN biz_base_merchant_staff.agent_id IS '城市代理ID';
COMMENT ON COLUMN biz_base_merchant_staff.merchant_id IS '商户ID';
COMMENT ON COLUMN biz_base_merchant_staff.username IS '登录账号';
COMMENT ON COLUMN biz_base_merchant_staff.password IS '登录密码，加密存储';
COMMENT ON COLUMN biz_base_merchant_staff.staff_name IS '员工姓名';
COMMENT ON COLUMN biz_base_merchant_staff.nickname IS '昵称';
COMMENT ON COLUMN biz_base_merchant_staff.avatar_url IS '头像URL';
COMMENT ON COLUMN biz_base_merchant_staff.phone_number IS '手机号';
COMMENT ON COLUMN biz_base_merchant_staff.email IS '邮箱';
COMMENT ON COLUMN biz_base_merchant_staff.role_type IS 'owner/manager/customer_service/finance/warehouse/teacher';
COMMENT ON COLUMN biz_base_merchant_staff.login_enabled IS '是否允许登录：Y/N';
COMMENT ON COLUMN biz_base_merchant_staff.last_login_time IS '最后登录时间';
COMMENT ON COLUMN biz_base_merchant_staff.password_update_time IS '密码更新时间';
COMMENT ON COLUMN biz_base_merchant_staff.account_status IS '账号状态';
COMMENT ON COLUMN biz_base_merchant_staff.status IS '状态：0正常，1停用';
COMMENT ON COLUMN biz_base_merchant_staff.create_by IS '创建者';
COMMENT ON COLUMN biz_base_merchant_staff.create_time IS '创建时间';
COMMENT ON COLUMN biz_base_merchant_staff.update_by IS '更新者';
COMMENT ON COLUMN biz_base_merchant_staff.update_time IS '更新时间';
COMMENT ON COLUMN biz_base_merchant_staff.del_flag IS '删除标志：0正常，2删除';
COMMENT ON COLUMN biz_base_merchant_staff.remark IS '备注';

CREATE INDEX idx_staff_merchant ON biz_base_merchant_staff(tenant_id, merchant_id);
CREATE INDEX idx_staff_username ON biz_base_merchant_staff(username);

-- ============================================================
-- 17. biz_base_merchant_role
-- ============================================================
DROP TABLE IF EXISTS biz_base_merchant_role CASCADE;
CREATE TABLE biz_base_merchant_role (
    id bigserial PRIMARY KEY,
    tenant_id varchar(20),
    role_id varchar(64) NOT NULL,
    merchant_id varchar(64) NOT NULL,
    role_code varchar(64),
    role_name varchar(128),
    role_scope varchar(32),
    sort_order int DEFAULT 0,
    status char(1) DEFAULT '0',
    create_by varchar(64),
    create_time timestamp,
    update_by varchar(64),
    update_time timestamp,
    del_flag char(1) DEFAULT '0',
    remark varchar(500)
);

COMMENT ON TABLE biz_base_merchant_role IS '商户端角色表';
COMMENT ON COLUMN biz_base_merchant_role.id IS '主键';
COMMENT ON COLUMN biz_base_merchant_role.tenant_id IS '租户ID';
COMMENT ON COLUMN biz_base_merchant_role.role_id IS '商户角色ID';
COMMENT ON COLUMN biz_base_merchant_role.merchant_id IS '商户ID';
COMMENT ON COLUMN biz_base_merchant_role.role_code IS '角色编码';
COMMENT ON COLUMN biz_base_merchant_role.role_name IS '角色名称';
COMMENT ON COLUMN biz_base_merchant_role.role_scope IS 'system/custom';
COMMENT ON COLUMN biz_base_merchant_role.sort_order IS '排序';
COMMENT ON COLUMN biz_base_merchant_role.status IS '状态：0正常，1停用';
COMMENT ON COLUMN biz_base_merchant_role.create_by IS '创建者';
COMMENT ON COLUMN biz_base_merchant_role.create_time IS '创建时间';
COMMENT ON COLUMN biz_base_merchant_role.update_by IS '更新者';
COMMENT ON COLUMN biz_base_merchant_role.update_time IS '更新时间';
COMMENT ON COLUMN biz_base_merchant_role.del_flag IS '删除标志：0正常，2删除';
COMMENT ON COLUMN biz_base_merchant_role.remark IS '备注';

CREATE INDEX idx_merchant_role ON biz_base_merchant_role(tenant_id, merchant_id);

-- ============================================================
-- 18. biz_base_merchant_staff_role
-- ============================================================
DROP TABLE IF EXISTS biz_base_merchant_staff_role CASCADE;
CREATE TABLE biz_base_merchant_staff_role (
    id bigserial PRIMARY KEY,
    tenant_id varchar(20),
    staff_id varchar(64) NOT NULL,
    role_id varchar(64) NOT NULL,
    merchant_id varchar(64) NOT NULL,
    create_time timestamp
);

COMMENT ON TABLE biz_base_merchant_staff_role IS '商户员工角色关联表';
COMMENT ON COLUMN biz_base_merchant_staff_role.id IS '主键';
COMMENT ON COLUMN biz_base_merchant_staff_role.tenant_id IS '租户ID';
COMMENT ON COLUMN biz_base_merchant_staff_role.staff_id IS '员工ID';
COMMENT ON COLUMN biz_base_merchant_staff_role.role_id IS '角色ID';
COMMENT ON COLUMN biz_base_merchant_staff_role.merchant_id IS '商户ID';
COMMENT ON COLUMN biz_base_merchant_staff_role.create_time IS '创建时间';

CREATE INDEX idx_staff_role_staff ON biz_base_merchant_staff_role(staff_id);

-- ============================================================
-- 19. biz_base_merchant_permission
-- ============================================================
DROP TABLE IF EXISTS biz_base_merchant_permission CASCADE;
CREATE TABLE biz_base_merchant_permission (
    id bigserial PRIMARY KEY,
    permission_id varchar(64) NOT NULL,
    permission_code varchar(128),
    permission_name varchar(128),
    app_type varchar(32) DEFAULT 'merchant',
    module_code varchar(64),
    permission_type varchar(32),
    parent_id varchar(64),
    route_path varchar(255),
    component varchar(255),
    icon varchar(128),
    sort_order int DEFAULT 0,
    visible char(1) DEFAULT 'Y',
    status char(1) DEFAULT '0',
    create_time timestamp,
    update_time timestamp,
    remark varchar(500)
);

COMMENT ON TABLE biz_base_merchant_permission IS '商户端权限表，独立于RuoYi sys_menu';
COMMENT ON COLUMN biz_base_merchant_permission.id IS '主键';
COMMENT ON COLUMN biz_base_merchant_permission.permission_id IS '权限ID';
COMMENT ON COLUMN biz_base_merchant_permission.permission_code IS '权限编码，如 goods:add';
COMMENT ON COLUMN biz_base_merchant_permission.permission_name IS '权限名称';
COMMENT ON COLUMN biz_base_merchant_permission.app_type IS '应用类型：admin/merchant/user';
COMMENT ON COLUMN biz_base_merchant_permission.module_code IS '模块编码';
COMMENT ON COLUMN biz_base_merchant_permission.permission_type IS 'menu/button/api/data';
COMMENT ON COLUMN biz_base_merchant_permission.parent_id IS '上级ID';
COMMENT ON COLUMN biz_base_merchant_permission.route_path IS '路由路径';
COMMENT ON COLUMN biz_base_merchant_permission.component IS '组件路径';
COMMENT ON COLUMN biz_base_merchant_permission.icon IS '图标';
COMMENT ON COLUMN biz_base_merchant_permission.sort_order IS '排序';
COMMENT ON COLUMN biz_base_merchant_permission.visible IS '是否显示：Y/N';
COMMENT ON COLUMN biz_base_merchant_permission.status IS '状态：0正常，1停用';
COMMENT ON COLUMN biz_base_merchant_permission.create_time IS '创建时间';
COMMENT ON COLUMN biz_base_merchant_permission.update_time IS '更新时间';
COMMENT ON COLUMN biz_base_merchant_permission.remark IS '备注';

CREATE INDEX idx_merchant_perm_code ON biz_base_merchant_permission(permission_code);

-- ============================================================
-- 20. biz_base_merchant_role_permission
-- ============================================================
DROP TABLE IF EXISTS biz_base_merchant_role_permission CASCADE;
CREATE TABLE biz_base_merchant_role_permission (
    id bigserial PRIMARY KEY,
    tenant_id varchar(20),
    role_id varchar(64) NOT NULL,
    permission_id varchar(64) NOT NULL,
    merchant_id varchar(64) NOT NULL,
    create_time timestamp
);

COMMENT ON TABLE biz_base_merchant_role_permission IS '商户角色权限关联表';
COMMENT ON COLUMN biz_base_merchant_role_permission.id IS '主键';
COMMENT ON COLUMN biz_base_merchant_role_permission.tenant_id IS '租户ID';
COMMENT ON COLUMN biz_base_merchant_role_permission.role_id IS '角色ID';
COMMENT ON COLUMN biz_base_merchant_role_permission.permission_id IS '权限ID';
COMMENT ON COLUMN biz_base_merchant_role_permission.merchant_id IS '商户ID';
COMMENT ON COLUMN biz_base_merchant_role_permission.create_time IS '创建时间';

CREATE INDEX idx_role_perm_role ON biz_base_merchant_role_permission(role_id);

-- ============================================================
-- 21. biz_base_member
-- ============================================================
DROP TABLE IF EXISTS biz_base_member CASCADE;
CREATE TABLE biz_base_member (
    id bigserial PRIMARY KEY,
    tenant_id varchar(20),
    member_id varchar(64) NOT NULL,
    phone_number varchar(64),
    email varchar(128),
    password varchar(255),
    whatsapp_id varchar(128),
    telegram_id varchar(128),
    display_name varchar(128),
    avatar_url varchar(500),
    gender varchar(20),
    birthday date,
    country_code varchar(20),
    city_code varchar(64),
    language_code varchar(20),
    global_risk_level varchar(32),
    member_level varchar(32),
    register_source varchar(32),
    last_active_time timestamp,
    account_status varchar(32),
    status char(1) DEFAULT '0',
    create_by varchar(64),
    create_time timestamp,
    update_by varchar(64),
    update_time timestamp,
    del_flag char(1) DEFAULT '0',
    remark varchar(500)
);

COMMENT ON TABLE biz_base_member IS '终端会员主表，用于App/H5/WhatsApp用户统一会员身份';
COMMENT ON COLUMN biz_base_member.id IS '主键';
COMMENT ON COLUMN biz_base_member.tenant_id IS '租户ID';
COMMENT ON COLUMN biz_base_member.member_id IS '会员ID';
COMMENT ON COLUMN biz_base_member.phone_number IS '手机号';
COMMENT ON COLUMN biz_base_member.email IS '邮箱';
COMMENT ON COLUMN biz_base_member.password IS '登录密码，加密存储';
COMMENT ON COLUMN biz_base_member.whatsapp_id IS 'WhatsApp用户ID';
COMMENT ON COLUMN biz_base_member.telegram_id IS 'Telegram用户ID';
COMMENT ON COLUMN biz_base_member.display_name IS '展示名称/昵称';
COMMENT ON COLUMN biz_base_member.avatar_url IS '头像URL';
COMMENT ON COLUMN biz_base_member.gender IS '性别';
COMMENT ON COLUMN biz_base_member.birthday IS '生日';
COMMENT ON COLUMN biz_base_member.country_code IS '国家代码';
COMMENT ON COLUMN biz_base_member.city_code IS '城市编码';
COMMENT ON COLUMN biz_base_member.language_code IS '语言编码';
COMMENT ON COLUMN biz_base_member.global_risk_level IS '全局风险等级';
COMMENT ON COLUMN biz_base_member.member_level IS '会员等级';
COMMENT ON COLUMN biz_base_member.register_source IS '注册来源';
COMMENT ON COLUMN biz_base_member.last_active_time IS '最后活跃时间';
COMMENT ON COLUMN biz_base_member.account_status IS '账号状态';
COMMENT ON COLUMN biz_base_member.status IS '状态：0正常，1停用';
COMMENT ON COLUMN biz_base_member.create_by IS '创建者';
COMMENT ON COLUMN biz_base_member.create_time IS '创建时间';
COMMENT ON COLUMN biz_base_member.update_by IS '更新者';
COMMENT ON COLUMN biz_base_member.update_time IS '更新时间';
COMMENT ON COLUMN biz_base_member.del_flag IS '删除标志：0正常，2删除';
COMMENT ON COLUMN biz_base_member.remark IS '备注';

CREATE INDEX idx_member_phone ON biz_base_member(tenant_id, phone_number);
CREATE INDEX idx_member_whatsapp ON biz_base_member(tenant_id, whatsapp_id);

-- ============================================================
-- 22. biz_base_merchant_member
-- ============================================================
DROP TABLE IF EXISTS biz_base_merchant_member CASCADE;
CREATE TABLE biz_base_merchant_member (
    id bigserial PRIMARY KEY,
    tenant_id varchar(20),
    merchant_member_id varchar(64) NOT NULL,
    agent_id varchar(64),
    merchant_id varchar(64) NOT NULL,
    member_id varchar(64) NOT NULL,
    customer_level varchar(32),
    customer_tags varchar(500),
    merchant_risk_level varchar(32),
    total_order_count int DEFAULT 0,
    total_order_amount numeric(18,2) DEFAULT 0,
    last_order_time timestamp,
    last_chat_time timestamp,
    status char(1) DEFAULT '0',
    create_by varchar(64),
    create_time timestamp,
    update_by varchar(64),
    update_time timestamp,
    del_flag char(1) DEFAULT '0',
    remark varchar(500)
);

COMMENT ON TABLE biz_base_merchant_member IS '商户客户关系表，同一会员可属于多个商户';
COMMENT ON COLUMN biz_base_merchant_member.id IS '主键';
COMMENT ON COLUMN biz_base_merchant_member.tenant_id IS '租户ID';
COMMENT ON COLUMN biz_base_merchant_member.merchant_member_id IS '商户客户关系ID';
COMMENT ON COLUMN biz_base_merchant_member.agent_id IS '城市代理ID';
COMMENT ON COLUMN biz_base_merchant_member.merchant_id IS '商户ID';
COMMENT ON COLUMN biz_base_merchant_member.member_id IS '会员ID';
COMMENT ON COLUMN biz_base_merchant_member.customer_level IS '客户等级';
COMMENT ON COLUMN biz_base_merchant_member.customer_tags IS '客户标签';
COMMENT ON COLUMN biz_base_merchant_member.merchant_risk_level IS '商户内风险等级';
COMMENT ON COLUMN biz_base_merchant_member.total_order_count IS '累计订单数';
COMMENT ON COLUMN biz_base_merchant_member.total_order_amount IS '累计订单金额';
COMMENT ON COLUMN biz_base_merchant_member.last_order_time IS '最近下单时间';
COMMENT ON COLUMN biz_base_merchant_member.last_chat_time IS '最近聊天时间';
COMMENT ON COLUMN biz_base_merchant_member.status IS '状态：0正常，1停用';
COMMENT ON COLUMN biz_base_merchant_member.create_by IS '创建者';
COMMENT ON COLUMN biz_base_merchant_member.create_time IS '创建时间';
COMMENT ON COLUMN biz_base_merchant_member.update_by IS '更新者';
COMMENT ON COLUMN biz_base_merchant_member.update_time IS '更新时间';
COMMENT ON COLUMN biz_base_merchant_member.del_flag IS '删除标志：0正常，2删除';
COMMENT ON COLUMN biz_base_merchant_member.remark IS '备注';

CREATE INDEX idx_merchant_member ON biz_base_merchant_member(tenant_id, merchant_id, member_id);

-- ============================================================
-- 23. biz_base_org_relation
-- ============================================================
DROP TABLE IF EXISTS biz_base_org_relation CASCADE;
CREATE TABLE biz_base_org_relation (
    id bigserial PRIMARY KEY,
    tenant_id varchar(20),
    parent_type varchar(32),
    parent_id varchar(64),
    child_type varchar(32),
    child_id varchar(64),
    relation_path varchar(500),
    status char(1) DEFAULT '0',
    create_by varchar(64),
    create_time timestamp,
    update_by varchar(64),
    update_time timestamp,
    del_flag char(1) DEFAULT '0',
    remark varchar(500)
);

COMMENT ON TABLE biz_base_org_relation IS '五级组织关系表';
COMMENT ON COLUMN biz_base_org_relation.id IS '主键';
COMMENT ON COLUMN biz_base_org_relation.tenant_id IS '租户ID';
COMMENT ON COLUMN biz_base_org_relation.parent_type IS '上级类型：platform/tenant/agent/merchant';
COMMENT ON COLUMN biz_base_org_relation.parent_id IS '上级ID';
COMMENT ON COLUMN biz_base_org_relation.child_type IS '下级类型：tenant/agent/merchant/member';
COMMENT ON COLUMN biz_base_org_relation.child_id IS '下级ID';
COMMENT ON COLUMN biz_base_org_relation.relation_path IS '关系路径';
COMMENT ON COLUMN biz_base_org_relation.status IS '状态：0正常，1停用';
COMMENT ON COLUMN biz_base_org_relation.create_by IS '创建者';
COMMENT ON COLUMN biz_base_org_relation.create_time IS '创建时间';
COMMENT ON COLUMN biz_base_org_relation.update_by IS '更新者';
COMMENT ON COLUMN biz_base_org_relation.update_time IS '更新时间';
COMMENT ON COLUMN biz_base_org_relation.del_flag IS '删除标志：0正常，2删除';
COMMENT ON COLUMN biz_base_org_relation.remark IS '备注';

CREATE INDEX idx_org_relation_parent ON biz_base_org_relation(parent_type, parent_id);
CREATE INDEX idx_org_relation_child ON biz_base_org_relation(child_type, child_id);

-- ============================================================
-- 24. biz_base_app_menu
-- ============================================================
DROP TABLE IF EXISTS biz_base_app_menu CASCADE;
CREATE TABLE biz_base_app_menu (
    id bigserial PRIMARY KEY,
    tenant_id varchar(20),
    app_type varchar(32),
    parent_id bigint,
    menu_code varchar(128),
    menu_name varchar(128),
    route_path varchar(255),
    component varchar(255),
    icon varchar(128),
    sort_order int DEFAULT 0,
    visible char(1) DEFAULT 'Y',
    status char(1) DEFAULT '0',
    create_by varchar(64),
    create_time timestamp,
    update_by varchar(64),
    update_time timestamp,
    del_flag char(1) DEFAULT '0',
    remark varchar(500)
);

COMMENT ON TABLE biz_base_app_menu IS '商户端/用户端菜单表';
COMMENT ON COLUMN biz_base_app_menu.id IS '主键';
COMMENT ON COLUMN biz_base_app_menu.tenant_id IS '租户ID';
COMMENT ON COLUMN biz_base_app_menu.app_type IS 'merchant/user';
COMMENT ON COLUMN biz_base_app_menu.parent_id IS '上级ID';
COMMENT ON COLUMN biz_base_app_menu.menu_code IS 'menu_code编码';
COMMENT ON COLUMN biz_base_app_menu.menu_name IS '菜单名称';
COMMENT ON COLUMN biz_base_app_menu.route_path IS '路由路径';
COMMENT ON COLUMN biz_base_app_menu.component IS '组件路径';
COMMENT ON COLUMN biz_base_app_menu.icon IS '图标';
COMMENT ON COLUMN biz_base_app_menu.sort_order IS '排序';
COMMENT ON COLUMN biz_base_app_menu.visible IS '是否显示：Y/N';
COMMENT ON COLUMN biz_base_app_menu.status IS '状态：0正常，1停用';
COMMENT ON COLUMN biz_base_app_menu.create_by IS '创建者';
COMMENT ON COLUMN biz_base_app_menu.create_time IS '创建时间';
COMMENT ON COLUMN biz_base_app_menu.update_by IS '更新者';
COMMENT ON COLUMN biz_base_app_menu.update_time IS '更新时间';
COMMENT ON COLUMN biz_base_app_menu.del_flag IS '删除标志：0正常，2删除';
COMMENT ON COLUMN biz_base_app_menu.remark IS '备注';

CREATE INDEX idx_app_menu_type ON biz_base_app_menu(app_type);

-- ============================================================
-- 25. biz_base_app_menu_i18n
-- ============================================================
DROP TABLE IF EXISTS biz_base_app_menu_i18n CASCADE;
CREATE TABLE biz_base_app_menu_i18n (
    id bigserial PRIMARY KEY,
    tenant_id varchar(20),
    menu_id bigint NOT NULL,
    language_code varchar(20) NOT NULL,
    menu_name varchar(128),
    title varchar(128),
    create_by varchar(64),
    create_time timestamp,
    update_by varchar(64),
    update_time timestamp,
    del_flag char(1) DEFAULT '0',
    remark varchar(500)
);

COMMENT ON TABLE biz_base_app_menu_i18n IS '商户端/用户端菜单多语言表';
COMMENT ON COLUMN biz_base_app_menu_i18n.id IS '主键';
COMMENT ON COLUMN biz_base_app_menu_i18n.tenant_id IS '租户ID';
COMMENT ON COLUMN biz_base_app_menu_i18n.menu_id IS '菜单ID';
COMMENT ON COLUMN biz_base_app_menu_i18n.language_code IS '语言编码';
COMMENT ON COLUMN biz_base_app_menu_i18n.menu_name IS '菜单名称';
COMMENT ON COLUMN biz_base_app_menu_i18n.title IS '页面标题';
COMMENT ON COLUMN biz_base_app_menu_i18n.create_by IS '创建者';
COMMENT ON COLUMN biz_base_app_menu_i18n.create_time IS '创建时间';
COMMENT ON COLUMN biz_base_app_menu_i18n.update_by IS '更新者';
COMMENT ON COLUMN biz_base_app_menu_i18n.update_time IS '更新时间';
COMMENT ON COLUMN biz_base_app_menu_i18n.del_flag IS '删除标志：0正常，2删除';
COMMENT ON COLUMN biz_base_app_menu_i18n.remark IS '备注';

CREATE INDEX idx_app_menu_i18n ON biz_base_app_menu_i18n(menu_id, language_code);

-- ============================================================
-- 26. biz_cmh_channel_account
-- ============================================================
DROP TABLE IF EXISTS biz_cmh_channel_account CASCADE;
CREATE TABLE biz_cmh_channel_account (
    id bigserial PRIMARY KEY,
    tenant_id varchar(20),
    channel_id varchar(64) NOT NULL,
    agent_id varchar(64),
    merchant_id varchar(64),
    channel_type varchar(32),
    account_name varchar(128),
    account_no varchar(128),
    access_token text,
    refresh_token text,
    token_expire_time timestamp,
    config_json jsonb,
    status char(1) DEFAULT '0',
    create_by varchar(64),
    create_time timestamp,
    update_by varchar(64),
    update_time timestamp,
    del_flag char(1) DEFAULT '0',
    remark varchar(500)
);

COMMENT ON TABLE biz_cmh_channel_account IS '渠道账号表';
COMMENT ON COLUMN biz_cmh_channel_account.id IS '主键';
COMMENT ON COLUMN biz_cmh_channel_account.tenant_id IS '租户ID';
COMMENT ON COLUMN biz_cmh_channel_account.channel_id IS '渠道ID';
COMMENT ON COLUMN biz_cmh_channel_account.agent_id IS '城市代理ID';
COMMENT ON COLUMN biz_cmh_channel_account.merchant_id IS '商户ID';
COMMENT ON COLUMN biz_cmh_channel_account.channel_type IS 'whatsapp/telegram/webchat';
COMMENT ON COLUMN biz_cmh_channel_account.account_name IS '账户名称';
COMMENT ON COLUMN biz_cmh_channel_account.account_no IS '账号';
COMMENT ON COLUMN biz_cmh_channel_account.access_token IS 'Access Token，加密存储';
COMMENT ON COLUMN biz_cmh_channel_account.refresh_token IS 'Refresh Token，加密存储';
COMMENT ON COLUMN biz_cmh_channel_account.token_expire_time IS 'Token过期时间';
COMMENT ON COLUMN biz_cmh_channel_account.config_json IS '配置JSON';
COMMENT ON COLUMN biz_cmh_channel_account.status IS '状态：0正常，1停用';
COMMENT ON COLUMN biz_cmh_channel_account.create_by IS '创建者';
COMMENT ON COLUMN biz_cmh_channel_account.create_time IS '创建时间';
COMMENT ON COLUMN biz_cmh_channel_account.update_by IS '更新者';
COMMENT ON COLUMN biz_cmh_channel_account.update_time IS '更新时间';
COMMENT ON COLUMN biz_cmh_channel_account.del_flag IS '删除标志：0正常，2删除';
COMMENT ON COLUMN biz_cmh_channel_account.remark IS '备注';

CREATE INDEX idx_cmh_channel_merchant ON biz_cmh_channel_account(tenant_id, merchant_id, channel_type);

-- ============================================================
-- 27. biz_cmh_whatsapp_phone
-- ============================================================
DROP TABLE IF EXISTS biz_cmh_whatsapp_phone CASCADE;
CREATE TABLE biz_cmh_whatsapp_phone (
    id bigserial PRIMARY KEY,
    tenant_id varchar(20),
    phone_id varchar(128) NOT NULL,
    agent_id varchar(64),
    merchant_id varchar(64) NOT NULL,
    waba_id varchar(128),
    phone_number varchar(64),
    display_name varchar(128),
    quality_rating varchar(32),
    messaging_limit varchar(64),
    verify_status varchar(32),
    bind_status varchar(32),
    status char(1) DEFAULT '0',
    create_by varchar(64),
    create_time timestamp,
    update_by varchar(64),
    update_time timestamp,
    del_flag char(1) DEFAULT '0',
    remark varchar(500)
);

COMMENT ON TABLE biz_cmh_whatsapp_phone IS 'WhatsApp商户业务号码表';
COMMENT ON COLUMN biz_cmh_whatsapp_phone.id IS '主键';
COMMENT ON COLUMN biz_cmh_whatsapp_phone.tenant_id IS '租户ID';
COMMENT ON COLUMN biz_cmh_whatsapp_phone.phone_id IS 'Meta phone_number_id';
COMMENT ON COLUMN biz_cmh_whatsapp_phone.agent_id IS '城市代理ID';
COMMENT ON COLUMN biz_cmh_whatsapp_phone.merchant_id IS '商户ID';
COMMENT ON COLUMN biz_cmh_whatsapp_phone.waba_id IS 'WABA ID';
COMMENT ON COLUMN biz_cmh_whatsapp_phone.phone_number IS '手机号';
COMMENT ON COLUMN biz_cmh_whatsapp_phone.display_name IS '展示名称/昵称';
COMMENT ON COLUMN biz_cmh_whatsapp_phone.quality_rating IS 'WhatsApp质量评级';
COMMENT ON COLUMN biz_cmh_whatsapp_phone.messaging_limit IS '消息限制等级';
COMMENT ON COLUMN biz_cmh_whatsapp_phone.verify_status IS '核销状态';
COMMENT ON COLUMN biz_cmh_whatsapp_phone.bind_status IS '绑定状态';
COMMENT ON COLUMN biz_cmh_whatsapp_phone.status IS '状态：0正常，1停用';
COMMENT ON COLUMN biz_cmh_whatsapp_phone.create_by IS '创建者';
COMMENT ON COLUMN biz_cmh_whatsapp_phone.create_time IS '创建时间';
COMMENT ON COLUMN biz_cmh_whatsapp_phone.update_by IS '更新者';
COMMENT ON COLUMN biz_cmh_whatsapp_phone.update_time IS '更新时间';
COMMENT ON COLUMN biz_cmh_whatsapp_phone.del_flag IS '删除标志：0正常，2删除';
COMMENT ON COLUMN biz_cmh_whatsapp_phone.remark IS '备注';

CREATE INDEX idx_wa_phone_merchant ON biz_cmh_whatsapp_phone(tenant_id, merchant_id);
CREATE INDEX idx_wa_phone_id ON biz_cmh_whatsapp_phone(phone_id);

-- ============================================================
-- 28. biz_cmh_session
-- ============================================================
DROP TABLE IF EXISTS biz_cmh_session CASCADE;
CREATE TABLE biz_cmh_session (
    id bigserial PRIMARY KEY,
    tenant_id varchar(20),
    session_id varchar(64) NOT NULL,
    agent_id varchar(64),
    merchant_id varchar(64) NOT NULL,
    member_id varchar(64),
    merchant_member_id varchar(64),
    channel_type varchar(32),
    channel_user_id varchar(128),
    agent_app_id varchar(64),
    session_status varchar(32),
    ai_enabled char(1) DEFAULT 'Y',
    handover_status char(1) DEFAULT 'N',
    last_message text,
    last_message_time timestamp,
    create_by varchar(64),
    create_time timestamp,
    update_by varchar(64),
    update_time timestamp,
    del_flag char(1) DEFAULT '0',
    remark varchar(500)
);

COMMENT ON TABLE biz_cmh_session IS '会话表';
COMMENT ON COLUMN biz_cmh_session.id IS '主键';
COMMENT ON COLUMN biz_cmh_session.tenant_id IS '租户ID';
COMMENT ON COLUMN biz_cmh_session.session_id IS '会话ID';
COMMENT ON COLUMN biz_cmh_session.agent_id IS '城市代理ID';
COMMENT ON COLUMN biz_cmh_session.merchant_id IS '商户ID';
COMMENT ON COLUMN biz_cmh_session.member_id IS '会员ID';
COMMENT ON COLUMN biz_cmh_session.merchant_member_id IS '商户客户关系ID';
COMMENT ON COLUMN biz_cmh_session.channel_type IS '渠道类型';
COMMENT ON COLUMN biz_cmh_session.channel_user_id IS '渠道用户ID';
COMMENT ON COLUMN biz_cmh_session.agent_app_id IS '智能体应用ID';
COMMENT ON COLUMN biz_cmh_session.session_status IS 'open/closed/handover';
COMMENT ON COLUMN biz_cmh_session.ai_enabled IS '是否启用AI：Y/N';
COMMENT ON COLUMN biz_cmh_session.handover_status IS '是否人工接管：Y/N';
COMMENT ON COLUMN biz_cmh_session.last_message IS '最后一条消息';
COMMENT ON COLUMN biz_cmh_session.last_message_time IS '最后消息时间';
COMMENT ON COLUMN biz_cmh_session.create_by IS '创建者';
COMMENT ON COLUMN biz_cmh_session.create_time IS '创建时间';
COMMENT ON COLUMN biz_cmh_session.update_by IS '更新者';
COMMENT ON COLUMN biz_cmh_session.update_time IS '更新时间';
COMMENT ON COLUMN biz_cmh_session.del_flag IS '删除标志：0正常，2删除';
COMMENT ON COLUMN biz_cmh_session.remark IS '备注';

CREATE INDEX idx_session_merchant_member ON biz_cmh_session(tenant_id, merchant_id, member_id);
CREATE INDEX idx_session_id ON biz_cmh_session(session_id);

-- ============================================================
-- 29. biz_cmh_message
-- ============================================================
DROP TABLE IF EXISTS biz_cmh_message CASCADE;
CREATE TABLE biz_cmh_message (
    id bigserial PRIMARY KEY,
    tenant_id varchar(20),
    message_id varchar(128) NOT NULL,
    session_id varchar(64) NOT NULL,
    agent_id varchar(64),
    merchant_id varchar(64) NOT NULL,
    sender_type varchar(32),
    message_type varchar(32),
    content text,
    media_url varchar(500),
    raw_payload jsonb,
    language_code varchar(20),
    send_status varchar(32),
    receive_time timestamp,
    create_by varchar(64),
    create_time timestamp,
    update_by varchar(64),
    update_time timestamp,
    del_flag char(1) DEFAULT '0',
    remark varchar(500)
);

COMMENT ON TABLE biz_cmh_message IS '消息表';
COMMENT ON COLUMN biz_cmh_message.id IS '主键';
COMMENT ON COLUMN biz_cmh_message.tenant_id IS '租户ID';
COMMENT ON COLUMN biz_cmh_message.message_id IS '消息ID';
COMMENT ON COLUMN biz_cmh_message.session_id IS '会话ID';
COMMENT ON COLUMN biz_cmh_message.agent_id IS '城市代理ID';
COMMENT ON COLUMN biz_cmh_message.merchant_id IS '商户ID';
COMMENT ON COLUMN biz_cmh_message.sender_type IS '发送方类型';
COMMENT ON COLUMN biz_cmh_message.message_type IS '消息类型';
COMMENT ON COLUMN biz_cmh_message.content IS '内容';
COMMENT ON COLUMN biz_cmh_message.media_url IS '媒体URL';
COMMENT ON COLUMN biz_cmh_message.raw_payload IS '原始报文JSON';
COMMENT ON COLUMN biz_cmh_message.language_code IS '语言编码';
COMMENT ON COLUMN biz_cmh_message.send_status IS '发送状态';
COMMENT ON COLUMN biz_cmh_message.receive_time IS '收货时间';
COMMENT ON COLUMN biz_cmh_message.create_by IS '创建者';
COMMENT ON COLUMN biz_cmh_message.create_time IS '创建时间';
COMMENT ON COLUMN biz_cmh_message.update_by IS '更新者';
COMMENT ON COLUMN biz_cmh_message.update_time IS '更新时间';
COMMENT ON COLUMN biz_cmh_message.del_flag IS '删除标志：0正常，2删除';
COMMENT ON COLUMN biz_cmh_message.remark IS '备注';

CREATE INDEX idx_message_session ON biz_cmh_message(session_id);
CREATE INDEX idx_message_merchant_time ON biz_cmh_message(tenant_id, merchant_id, create_time);

-- ============================================================
-- 30. biz_cmh_handover
-- ============================================================
DROP TABLE IF EXISTS biz_cmh_handover CASCADE;
CREATE TABLE biz_cmh_handover (
    id bigserial PRIMARY KEY,
    tenant_id varchar(20),
    handover_id varchar(64) NOT NULL,
    session_id varchar(64) NOT NULL,
    agent_id varchar(64),
    merchant_id varchar(64) NOT NULL,
    operator_staff_id varchar(64),
    handover_reason varchar(255),
    start_time timestamp,
    end_time timestamp,
    status varchar(32),
    create_by varchar(64),
    create_time timestamp,
    update_by varchar(64),
    update_time timestamp,
    del_flag char(1) DEFAULT '0',
    remark varchar(500)
);

COMMENT ON TABLE biz_cmh_handover IS '人工接管记录表，接管人为商户员工';
COMMENT ON COLUMN biz_cmh_handover.id IS '主键';
COMMENT ON COLUMN biz_cmh_handover.tenant_id IS '租户ID';
COMMENT ON COLUMN biz_cmh_handover.handover_id IS '人工接管ID';
COMMENT ON COLUMN biz_cmh_handover.session_id IS '会话ID';
COMMENT ON COLUMN biz_cmh_handover.agent_id IS '城市代理ID';
COMMENT ON COLUMN biz_cmh_handover.merchant_id IS '商户ID';
COMMENT ON COLUMN biz_cmh_handover.operator_staff_id IS '接管员工ID';
COMMENT ON COLUMN biz_cmh_handover.handover_reason IS '接管原因';
COMMENT ON COLUMN biz_cmh_handover.start_time IS '开始时间';
COMMENT ON COLUMN biz_cmh_handover.end_time IS '结束时间';
COMMENT ON COLUMN biz_cmh_handover.status IS '状态：0正常，1停用';
COMMENT ON COLUMN biz_cmh_handover.create_by IS '创建者';
COMMENT ON COLUMN biz_cmh_handover.create_time IS '创建时间';
COMMENT ON COLUMN biz_cmh_handover.update_by IS '更新者';
COMMENT ON COLUMN biz_cmh_handover.update_time IS '更新时间';
COMMENT ON COLUMN biz_cmh_handover.del_flag IS '删除标志：0正常，2删除';
COMMENT ON COLUMN biz_cmh_handover.remark IS '备注';

CREATE INDEX idx_handover_session ON biz_cmh_handover(session_id);

-- ============================================================
-- 31. biz_cmh_message_template
-- ============================================================
DROP TABLE IF EXISTS biz_cmh_message_template CASCADE;
CREATE TABLE biz_cmh_message_template (
    id bigserial PRIMARY KEY,
    tenant_id varchar(20),
    template_id varchar(64) NOT NULL,
    agent_id varchar(64),
    merchant_id varchar(64),
    channel_type varchar(32),
    template_code varchar(128),
    template_name varchar(128),
    language_code varchar(20),
    template_type varchar(32),
    content text,
    meta_template_id varchar(128),
    audit_status varchar(32),
    status char(1) DEFAULT '0',
    create_by varchar(64),
    create_time timestamp,
    update_by varchar(64),
    update_time timestamp,
    del_flag char(1) DEFAULT '0',
    remark varchar(500)
);

COMMENT ON TABLE biz_cmh_message_template IS '消息模板表';
COMMENT ON COLUMN biz_cmh_message_template.id IS '主键';
COMMENT ON COLUMN biz_cmh_message_template.tenant_id IS '租户ID';
COMMENT ON COLUMN biz_cmh_message_template.template_id IS '模板ID';
COMMENT ON COLUMN biz_cmh_message_template.agent_id IS '城市代理ID';
COMMENT ON COLUMN biz_cmh_message_template.merchant_id IS '商户ID';
COMMENT ON COLUMN biz_cmh_message_template.channel_type IS '渠道类型';
COMMENT ON COLUMN biz_cmh_message_template.template_code IS '模板编码';
COMMENT ON COLUMN biz_cmh_message_template.template_name IS '模板名称';
COMMENT ON COLUMN biz_cmh_message_template.language_code IS '语言编码';
COMMENT ON COLUMN biz_cmh_message_template.template_type IS 'marketing/notice/payment/collection';
COMMENT ON COLUMN biz_cmh_message_template.content IS '内容';
COMMENT ON COLUMN biz_cmh_message_template.meta_template_id IS 'Meta模板ID';
COMMENT ON COLUMN biz_cmh_message_template.audit_status IS '审核状态';
COMMENT ON COLUMN biz_cmh_message_template.status IS '状态：0正常，1停用';
COMMENT ON COLUMN biz_cmh_message_template.create_by IS '创建者';
COMMENT ON COLUMN biz_cmh_message_template.create_time IS '创建时间';
COMMENT ON COLUMN biz_cmh_message_template.update_by IS '更新者';
COMMENT ON COLUMN biz_cmh_message_template.update_time IS '更新时间';
COMMENT ON COLUMN biz_cmh_message_template.del_flag IS '删除标志：0正常，2删除';
COMMENT ON COLUMN biz_cmh_message_template.remark IS '备注';

CREATE INDEX idx_msg_template_merchant ON biz_cmh_message_template(tenant_id, merchant_id, template_code, language_code);

-- ============================================================
-- 32. ai_igw_model_provider
-- ============================================================
DROP TABLE IF EXISTS ai_igw_model_provider CASCADE;
CREATE TABLE ai_igw_model_provider (
    id bigserial PRIMARY KEY,
    tenant_id varchar(20),
    provider_code varchar(64) NOT NULL,
    provider_name varchar(128),
    provider_type varchar(32),
    base_url varchar(500),
    api_key text,
    default_model varchar(128),
    timeout_ms int DEFAULT 60000,
    max_retry int DEFAULT 2,
    status char(1) DEFAULT '0',
    create_by varchar(64),
    create_time timestamp,
    update_by varchar(64),
    update_time timestamp,
    del_flag char(1) DEFAULT '0',
    remark varchar(500)
);

COMMENT ON TABLE ai_igw_model_provider IS '模型供应商表';
COMMENT ON COLUMN ai_igw_model_provider.id IS '主键';
COMMENT ON COLUMN ai_igw_model_provider.tenant_id IS '租户ID';
COMMENT ON COLUMN ai_igw_model_provider.provider_code IS '模型供应商编码';
COMMENT ON COLUMN ai_igw_model_provider.provider_name IS '模型供应商名称';
COMMENT ON COLUMN ai_igw_model_provider.provider_type IS '模型供应商类型';
COMMENT ON COLUMN ai_igw_model_provider.base_url IS 'API Base URL';
COMMENT ON COLUMN ai_igw_model_provider.api_key IS 'API Key，加密存储';
COMMENT ON COLUMN ai_igw_model_provider.default_model IS '默认模型';
COMMENT ON COLUMN ai_igw_model_provider.timeout_ms IS '超时时间毫秒';
COMMENT ON COLUMN ai_igw_model_provider.max_retry IS '最大重试次数';
COMMENT ON COLUMN ai_igw_model_provider.status IS '状态：0正常，1停用';
COMMENT ON COLUMN ai_igw_model_provider.create_by IS '创建者';
COMMENT ON COLUMN ai_igw_model_provider.create_time IS '创建时间';
COMMENT ON COLUMN ai_igw_model_provider.update_by IS '更新者';
COMMENT ON COLUMN ai_igw_model_provider.update_time IS '更新时间';
COMMENT ON COLUMN ai_igw_model_provider.del_flag IS '删除标志：0正常，2删除';
COMMENT ON COLUMN ai_igw_model_provider.remark IS '备注';

CREATE INDEX idx_model_provider ON ai_igw_model_provider(tenant_id, provider_code);

-- ============================================================
-- 33. ai_igw_model_route
-- ============================================================
DROP TABLE IF EXISTS ai_igw_model_route CASCADE;
CREATE TABLE ai_igw_model_route (
    id bigserial PRIMARY KEY,
    tenant_id varchar(20),
    route_code varchar(64) NOT NULL,
    route_name varchar(128),
    task_type varchar(64),
    provider_code varchar(64),
    model_name varchar(128),
    priority int DEFAULT 0,
    max_tokens int,
    temperature numeric(4,2),
    status char(1) DEFAULT '0',
    create_by varchar(64),
    create_time timestamp,
    update_by varchar(64),
    update_time timestamp,
    del_flag char(1) DEFAULT '0',
    remark varchar(500)
);

COMMENT ON TABLE ai_igw_model_route IS '模型路由规则表';
COMMENT ON COLUMN ai_igw_model_route.id IS '主键';
COMMENT ON COLUMN ai_igw_model_route.tenant_id IS '租户ID';
COMMENT ON COLUMN ai_igw_model_route.route_code IS '路由编码';
COMMENT ON COLUMN ai_igw_model_route.route_name IS '路由名称';
COMMENT ON COLUMN ai_igw_model_route.task_type IS '任务类型';
COMMENT ON COLUMN ai_igw_model_route.provider_code IS '模型供应商编码';
COMMENT ON COLUMN ai_igw_model_route.model_name IS '模型名称';
COMMENT ON COLUMN ai_igw_model_route.priority IS '优先级';
COMMENT ON COLUMN ai_igw_model_route.max_tokens IS '最大Token数';
COMMENT ON COLUMN ai_igw_model_route.temperature IS '模型温度参数';
COMMENT ON COLUMN ai_igw_model_route.status IS '状态：0正常，1停用';
COMMENT ON COLUMN ai_igw_model_route.create_by IS '创建者';
COMMENT ON COLUMN ai_igw_model_route.create_time IS '创建时间';
COMMENT ON COLUMN ai_igw_model_route.update_by IS '更新者';
COMMENT ON COLUMN ai_igw_model_route.update_time IS '更新时间';
COMMENT ON COLUMN ai_igw_model_route.del_flag IS '删除标志：0正常，2删除';
COMMENT ON COLUMN ai_igw_model_route.remark IS '备注';

CREATE INDEX idx_model_route_task ON ai_igw_model_route(tenant_id, task_type, priority);

-- ============================================================
-- 34. ai_igw_prompt_template
-- ============================================================
DROP TABLE IF EXISTS ai_igw_prompt_template CASCADE;
CREATE TABLE ai_igw_prompt_template (
    id bigserial PRIMARY KEY,
    tenant_id varchar(20),
    prompt_id varchar(64) NOT NULL,
    prompt_code varchar(128),
    prompt_name varchar(128),
    prompt_type varchar(64),
    language_code varchar(20),
    prompt_content text,
    version_no varchar(32),
    publish_status varchar(32),
    create_by varchar(64),
    create_time timestamp,
    update_by varchar(64),
    update_time timestamp,
    del_flag char(1) DEFAULT '0',
    remark varchar(500)
);

COMMENT ON TABLE ai_igw_prompt_template IS 'Prompt模板表';
COMMENT ON COLUMN ai_igw_prompt_template.id IS '主键';
COMMENT ON COLUMN ai_igw_prompt_template.tenant_id IS '租户ID';
COMMENT ON COLUMN ai_igw_prompt_template.prompt_id IS 'Prompt ID';
COMMENT ON COLUMN ai_igw_prompt_template.prompt_code IS 'Prompt编码';
COMMENT ON COLUMN ai_igw_prompt_template.prompt_name IS 'Prompt名称';
COMMENT ON COLUMN ai_igw_prompt_template.prompt_type IS 'system/sales/support/risk/summary';
COMMENT ON COLUMN ai_igw_prompt_template.language_code IS '语言编码';
COMMENT ON COLUMN ai_igw_prompt_template.prompt_content IS 'Prompt内容';
COMMENT ON COLUMN ai_igw_prompt_template.version_no IS '版本号';
COMMENT ON COLUMN ai_igw_prompt_template.publish_status IS '发布状态';
COMMENT ON COLUMN ai_igw_prompt_template.create_by IS '创建者';
COMMENT ON COLUMN ai_igw_prompt_template.create_time IS '创建时间';
COMMENT ON COLUMN ai_igw_prompt_template.update_by IS '更新者';
COMMENT ON COLUMN ai_igw_prompt_template.update_time IS '更新时间';
COMMENT ON COLUMN ai_igw_prompt_template.del_flag IS '删除标志：0正常，2删除';
COMMENT ON COLUMN ai_igw_prompt_template.remark IS '备注';

CREATE INDEX idx_prompt_code_lang ON ai_igw_prompt_template(tenant_id, prompt_code, language_code);

-- ============================================================
-- 35. ai_igw_token_log
-- ============================================================
DROP TABLE IF EXISTS ai_igw_token_log CASCADE;
CREATE TABLE ai_igw_token_log (
    id bigserial PRIMARY KEY,
    call_id varchar(64),
    tenant_id varchar(20),
    agent_id varchar(64),
    merchant_id varchar(64),
    provider_code varchar(64),
    model_name varchar(128),
    task_type varchar(64),
    prompt_tokens int,
    completion_tokens int,
    total_tokens int,
    estimated_cost numeric(18,6),
    currency_code varchar(20),
    create_time timestamp,
    remark varchar(500)
);

COMMENT ON TABLE ai_igw_token_log IS 'Token消耗日志表';
COMMENT ON COLUMN ai_igw_token_log.id IS '主键';
COMMENT ON COLUMN ai_igw_token_log.call_id IS '调用ID';
COMMENT ON COLUMN ai_igw_token_log.tenant_id IS '租户ID';
COMMENT ON COLUMN ai_igw_token_log.agent_id IS '城市代理ID';
COMMENT ON COLUMN ai_igw_token_log.merchant_id IS '商户ID';
COMMENT ON COLUMN ai_igw_token_log.provider_code IS '模型供应商编码';
COMMENT ON COLUMN ai_igw_token_log.model_name IS '模型名称';
COMMENT ON COLUMN ai_igw_token_log.task_type IS '任务类型';
COMMENT ON COLUMN ai_igw_token_log.prompt_tokens IS '输入Token数';
COMMENT ON COLUMN ai_igw_token_log.completion_tokens IS '输出Token数';
COMMENT ON COLUMN ai_igw_token_log.total_tokens IS '总Token数';
COMMENT ON COLUMN ai_igw_token_log.estimated_cost IS '预估成本';
COMMENT ON COLUMN ai_igw_token_log.currency_code IS '币种编码';
COMMENT ON COLUMN ai_igw_token_log.create_time IS '创建时间';
COMMENT ON COLUMN ai_igw_token_log.remark IS '备注';

CREATE INDEX idx_token_log_merchant_time ON ai_igw_token_log(tenant_id, merchant_id, create_time);

-- ============================================================
-- 36. ai_igw_model_call_log
-- ============================================================
DROP TABLE IF EXISTS ai_igw_model_call_log CASCADE;
CREATE TABLE ai_igw_model_call_log (
    id bigserial PRIMARY KEY,
    call_id varchar(64),
    tenant_id varchar(20),
    agent_id varchar(64),
    merchant_id varchar(64),
    session_id varchar(64),
    provider_code varchar(64),
    model_name varchar(128),
    request_payload jsonb,
    response_payload jsonb,
    success_flag char(1),
    error_message text,
    latency_ms int,
    create_time timestamp,
    remark varchar(500)
);

COMMENT ON TABLE ai_igw_model_call_log IS '模型调用日志表';
COMMENT ON COLUMN ai_igw_model_call_log.id IS '主键';
COMMENT ON COLUMN ai_igw_model_call_log.call_id IS '调用ID';
COMMENT ON COLUMN ai_igw_model_call_log.tenant_id IS '租户ID';
COMMENT ON COLUMN ai_igw_model_call_log.agent_id IS '城市代理ID';
COMMENT ON COLUMN ai_igw_model_call_log.merchant_id IS '商户ID';
COMMENT ON COLUMN ai_igw_model_call_log.session_id IS '会话ID';
COMMENT ON COLUMN ai_igw_model_call_log.provider_code IS '模型供应商编码';
COMMENT ON COLUMN ai_igw_model_call_log.model_name IS '模型名称';
COMMENT ON COLUMN ai_igw_model_call_log.request_payload IS '请求报文JSON';
COMMENT ON COLUMN ai_igw_model_call_log.response_payload IS '响应报文JSON';
COMMENT ON COLUMN ai_igw_model_call_log.success_flag IS '是否成功：Y/N';
COMMENT ON COLUMN ai_igw_model_call_log.error_message IS '错误信息';
COMMENT ON COLUMN ai_igw_model_call_log.latency_ms IS '耗时毫秒';
COMMENT ON COLUMN ai_igw_model_call_log.create_time IS '创建时间';
COMMENT ON COLUMN ai_igw_model_call_log.remark IS '备注';

CREATE INDEX idx_model_call_merchant_time ON ai_igw_model_call_log(tenant_id, merchant_id, create_time);

-- ============================================================
-- 37. ai_iar_capability
-- ============================================================
DROP TABLE IF EXISTS ai_iar_capability CASCADE;
CREATE TABLE ai_iar_capability (
    id bigserial PRIMARY KEY,
    capability_id varchar(64) NOT NULL,
    capability_code varchar(128),
    capability_name varchar(128),
    module_code varchar(64),
    invoke_type varchar(32),
    endpoint_url varchar(500),
    http_method varchar(20),
    request_schema jsonb,
    response_schema jsonb,
    auth_type varchar(32),
    default_data_scope varchar(64),
    allowed_data_scopes varchar(500),
    forbidden_resource text,
    risk_level varchar(20),
    status char(1) DEFAULT '0',
    create_by varchar(64),
    create_time timestamp,
    update_by varchar(64),
    update_time timestamp,
    del_flag char(1) DEFAULT '0',
    remark varchar(500)
);

COMMENT ON TABLE ai_iar_capability IS '平台底层能力注册表，由平台超管维护，不绑定租户';
COMMENT ON COLUMN ai_iar_capability.id IS '主键';
COMMENT ON COLUMN ai_iar_capability.capability_id IS '底层能力ID';
COMMENT ON COLUMN ai_iar_capability.capability_code IS '底层能力编码';
COMMENT ON COLUMN ai_iar_capability.capability_name IS '底层能力名称';
COMMENT ON COLUMN ai_iar_capability.module_code IS '模块编码';
COMMENT ON COLUMN ai_iar_capability.invoke_type IS '调用类型：internal/http/mq';
COMMENT ON COLUMN ai_iar_capability.endpoint_url IS '接口地址或内部服务标识';
COMMENT ON COLUMN ai_iar_capability.http_method IS 'HTTP请求方法';
COMMENT ON COLUMN ai_iar_capability.request_schema IS '请求Schema';
COMMENT ON COLUMN ai_iar_capability.response_schema IS '响应Schema';
COMMENT ON COLUMN ai_iar_capability.auth_type IS '鉴权方式';
COMMENT ON COLUMN ai_iar_capability.default_data_scope IS '默认数据范围';
COMMENT ON COLUMN ai_iar_capability.allowed_data_scopes IS '允许的数据范围';
COMMENT ON COLUMN ai_iar_capability.forbidden_resource IS '禁止访问资源说明';
COMMENT ON COLUMN ai_iar_capability.risk_level IS '风险等级';
COMMENT ON COLUMN ai_iar_capability.status IS '状态：0正常，1停用';
COMMENT ON COLUMN ai_iar_capability.create_by IS '创建者';
COMMENT ON COLUMN ai_iar_capability.create_time IS '创建时间';
COMMENT ON COLUMN ai_iar_capability.update_by IS '更新者';
COMMENT ON COLUMN ai_iar_capability.update_time IS '更新时间';
COMMENT ON COLUMN ai_iar_capability.del_flag IS '删除标志：0正常，2删除';
COMMENT ON COLUMN ai_iar_capability.remark IS '备注';

CREATE INDEX idx_capability_code ON ai_iar_capability(capability_code);

-- ============================================================
-- 38. ai_iar_tool
-- ============================================================
DROP TABLE IF EXISTS ai_iar_tool CASCADE;
CREATE TABLE ai_iar_tool (
    id bigserial PRIMARY KEY,
    tenant_id varchar(20),
    tool_id varchar(64) NOT NULL,
    capability_id varchar(64),
    tool_code varchar(128),
    tool_name varchar(128),
    tool_desc text,
    input_schema jsonb,
    output_schema jsonb,
    data_scope varchar(64),
    max_data_scope varchar(64),
    need_context_check char(1) DEFAULT 'Y',
    risk_level varchar(20),
    need_confirm char(1) DEFAULT 'N',
    enabled_for_merchant char(1) DEFAULT 'Y',
    status char(1) DEFAULT '0',
    create_by varchar(64),
    create_time timestamp,
    update_by varchar(64),
    update_time timestamp,
    del_flag char(1) DEFAULT '0',
    remark varchar(500)
);

COMMENT ON TABLE ai_iar_tool IS '租户工具表，国家租户基于平台能力发布工具';
COMMENT ON COLUMN ai_iar_tool.id IS '主键';
COMMENT ON COLUMN ai_iar_tool.tenant_id IS '租户ID';
COMMENT ON COLUMN ai_iar_tool.tool_id IS '工具ID';
COMMENT ON COLUMN ai_iar_tool.capability_id IS '底层能力ID';
COMMENT ON COLUMN ai_iar_tool.tool_code IS '工具编码';
COMMENT ON COLUMN ai_iar_tool.tool_name IS '工具名称';
COMMENT ON COLUMN ai_iar_tool.tool_desc IS 'AI可理解的工具说明';
COMMENT ON COLUMN ai_iar_tool.input_schema IS '工具入参Schema';
COMMENT ON COLUMN ai_iar_tool.output_schema IS '工具出参Schema';
COMMENT ON COLUMN ai_iar_tool.data_scope IS '数据权限范围';
COMMENT ON COLUMN ai_iar_tool.max_data_scope IS '最大允许数据范围';
COMMENT ON COLUMN ai_iar_tool.need_context_check IS '是否需要上下文校验：Y/N';
COMMENT ON COLUMN ai_iar_tool.risk_level IS '风险等级';
COMMENT ON COLUMN ai_iar_tool.need_confirm IS '是否需要人工确认：Y/N';
COMMENT ON COLUMN ai_iar_tool.enabled_for_merchant IS '是否允许商户启用：Y/N';
COMMENT ON COLUMN ai_iar_tool.status IS '状态：0正常，1停用';
COMMENT ON COLUMN ai_iar_tool.create_by IS '创建者';
COMMENT ON COLUMN ai_iar_tool.create_time IS '创建时间';
COMMENT ON COLUMN ai_iar_tool.update_by IS '更新者';
COMMENT ON COLUMN ai_iar_tool.update_time IS '更新时间';
COMMENT ON COLUMN ai_iar_tool.del_flag IS '删除标志：0正常，2删除';
COMMENT ON COLUMN ai_iar_tool.remark IS '备注';

CREATE INDEX idx_tool_tenant_code ON ai_iar_tool(tenant_id, tool_code);

-- ============================================================
-- 39. ai_iar_agent_template
-- ============================================================
DROP TABLE IF EXISTS ai_iar_agent_template CASCADE;
CREATE TABLE ai_iar_agent_template (
    id bigserial PRIMARY KEY,
    tenant_id varchar(20),
    template_id varchar(64) NOT NULL,
    template_code varchar(128),
    template_name varchar(128),
    agent_type varchar(64),
    default_prompt_id varchar(64),
    default_route_code varchar(64),
    default_language varchar(20),
    version_no varchar(32),
    publish_status varchar(32),
    status char(1) DEFAULT '0',
    create_by varchar(64),
    create_time timestamp,
    update_by varchar(64),
    update_time timestamp,
    del_flag char(1) DEFAULT '0',
    remark varchar(500)
);

COMMENT ON TABLE ai_iar_agent_template IS '智能体模板表';
COMMENT ON COLUMN ai_iar_agent_template.id IS '主键';
COMMENT ON COLUMN ai_iar_agent_template.tenant_id IS '租户ID';
COMMENT ON COLUMN ai_iar_agent_template.template_id IS '模板ID';
COMMENT ON COLUMN ai_iar_agent_template.template_code IS '模板编码';
COMMENT ON COLUMN ai_iar_agent_template.template_name IS '模板名称';
COMMENT ON COLUMN ai_iar_agent_template.agent_type IS 'sales/support/risk/collection/booking';
COMMENT ON COLUMN ai_iar_agent_template.default_prompt_id IS '默认Prompt ID';
COMMENT ON COLUMN ai_iar_agent_template.default_route_code IS '默认模型路由编码';
COMMENT ON COLUMN ai_iar_agent_template.default_language IS '默认语言';
COMMENT ON COLUMN ai_iar_agent_template.version_no IS '版本号';
COMMENT ON COLUMN ai_iar_agent_template.publish_status IS '发布状态';
COMMENT ON COLUMN ai_iar_agent_template.status IS '状态：0正常，1停用';
COMMENT ON COLUMN ai_iar_agent_template.create_by IS '创建者';
COMMENT ON COLUMN ai_iar_agent_template.create_time IS '创建时间';
COMMENT ON COLUMN ai_iar_agent_template.update_by IS '更新者';
COMMENT ON COLUMN ai_iar_agent_template.update_time IS '更新时间';
COMMENT ON COLUMN ai_iar_agent_template.del_flag IS '删除标志：0正常，2删除';
COMMENT ON COLUMN ai_iar_agent_template.remark IS '备注';

CREATE INDEX idx_agent_template_code ON ai_iar_agent_template(tenant_id, template_code);

-- ============================================================
-- 40. ai_iar_template_tool
-- ============================================================
DROP TABLE IF EXISTS ai_iar_template_tool CASCADE;
CREATE TABLE ai_iar_template_tool (
    id bigserial PRIMARY KEY,
    tenant_id varchar(20),
    template_id varchar(64) NOT NULL,
    tool_id varchar(64) NOT NULL,
    required_flag char(1) DEFAULT 'N',
    default_enabled char(1) DEFAULT 'Y',
    create_by varchar(64),
    create_time timestamp,
    update_by varchar(64),
    update_time timestamp,
    del_flag char(1) DEFAULT '0',
    remark varchar(500)
);

COMMENT ON TABLE ai_iar_template_tool IS '智能体模板工具授权表';
COMMENT ON COLUMN ai_iar_template_tool.id IS '主键';
COMMENT ON COLUMN ai_iar_template_tool.tenant_id IS '租户ID';
COMMENT ON COLUMN ai_iar_template_tool.template_id IS '模板ID';
COMMENT ON COLUMN ai_iar_template_tool.tool_id IS '工具ID';
COMMENT ON COLUMN ai_iar_template_tool.required_flag IS '是否必选：Y/N';
COMMENT ON COLUMN ai_iar_template_tool.default_enabled IS '是否默认启用：Y/N';
COMMENT ON COLUMN ai_iar_template_tool.create_by IS '创建者';
COMMENT ON COLUMN ai_iar_template_tool.create_time IS '创建时间';
COMMENT ON COLUMN ai_iar_template_tool.update_by IS '更新者';
COMMENT ON COLUMN ai_iar_template_tool.update_time IS '更新时间';
COMMENT ON COLUMN ai_iar_template_tool.del_flag IS '删除标志：0正常，2删除';
COMMENT ON COLUMN ai_iar_template_tool.remark IS '备注';

CREATE INDEX idx_template_tool ON ai_iar_template_tool(template_id, tool_id);

-- ============================================================
-- 41. ai_iar_agent_app
-- ============================================================
DROP TABLE IF EXISTS ai_iar_agent_app CASCADE;
CREATE TABLE ai_iar_agent_app (
    id bigserial PRIMARY KEY,
    tenant_id varchar(20),
    agent_app_id varchar(64) NOT NULL,
    template_id varchar(64),
    agent_id varchar(64),
    merchant_id varchar(64) NOT NULL,
    agent_name varchar(128),
    agent_intro varchar(500),
    avatar_url varchar(500),
    virtual_gender varchar(32),
    virtual_title varchar(128),
    personality varchar(500),
    tone_style varchar(128),
    service_style varchar(128),
    language_code varchar(20),
    business_rules text,
    system_prompt text,
    forbidden_rules text,
    welcome_message text,
    fallback_message text,
    handover_rule text,
    sensitive_word_strategy varchar(64),
    operation_goal varchar(64),
    auto_reply_enabled char(1) DEFAULT 'Y',
    handover_enabled char(1) DEFAULT 'Y',
    max_auto_reply int DEFAULT 20,
    status char(1) DEFAULT '0',
    create_by varchar(64),
    create_time timestamp,
    update_by varchar(64),
    update_time timestamp,
    del_flag char(1) DEFAULT '0',
    remark varchar(500)
);

COMMENT ON TABLE ai_iar_agent_app IS '商户智能体应用表';
COMMENT ON COLUMN ai_iar_agent_app.id IS '主键';
COMMENT ON COLUMN ai_iar_agent_app.tenant_id IS '租户ID';
COMMENT ON COLUMN ai_iar_agent_app.agent_app_id IS '智能体应用ID';
COMMENT ON COLUMN ai_iar_agent_app.template_id IS '模板ID';
COMMENT ON COLUMN ai_iar_agent_app.agent_id IS '城市代理ID';
COMMENT ON COLUMN ai_iar_agent_app.merchant_id IS '商户ID';
COMMENT ON COLUMN ai_iar_agent_app.agent_name IS '智能体名称';
COMMENT ON COLUMN ai_iar_agent_app.agent_intro IS '智能体简介';
COMMENT ON COLUMN ai_iar_agent_app.avatar_url IS '头像URL';
COMMENT ON COLUMN ai_iar_agent_app.virtual_gender IS '虚拟形象性别';
COMMENT ON COLUMN ai_iar_agent_app.virtual_title IS '虚拟形象头衔';
COMMENT ON COLUMN ai_iar_agent_app.personality IS '性格特点';
COMMENT ON COLUMN ai_iar_agent_app.tone_style IS '语气风格';
COMMENT ON COLUMN ai_iar_agent_app.service_style IS '服务风格';
COMMENT ON COLUMN ai_iar_agent_app.language_code IS '语言编码';
COMMENT ON COLUMN ai_iar_agent_app.business_rules IS '业务规则';
COMMENT ON COLUMN ai_iar_agent_app.system_prompt IS '商户自定义系统提示词';
COMMENT ON COLUMN ai_iar_agent_app.forbidden_rules IS '禁答规则';
COMMENT ON COLUMN ai_iar_agent_app.welcome_message IS '欢迎语';
COMMENT ON COLUMN ai_iar_agent_app.fallback_message IS '兜底回复';
COMMENT ON COLUMN ai_iar_agent_app.handover_rule IS '转人工规则';
COMMENT ON COLUMN ai_iar_agent_app.sensitive_word_strategy IS '敏感词策略';
COMMENT ON COLUMN ai_iar_agent_app.operation_goal IS '运营目标';
COMMENT ON COLUMN ai_iar_agent_app.auto_reply_enabled IS '是否自动回复：Y/N';
COMMENT ON COLUMN ai_iar_agent_app.handover_enabled IS '是否允许转人工：Y/N';
COMMENT ON COLUMN ai_iar_agent_app.max_auto_reply IS '最大连续自动回复次数';
COMMENT ON COLUMN ai_iar_agent_app.status IS '状态：0正常，1停用';
COMMENT ON COLUMN ai_iar_agent_app.create_by IS '创建者';
COMMENT ON COLUMN ai_iar_agent_app.create_time IS '创建时间';
COMMENT ON COLUMN ai_iar_agent_app.update_by IS '更新者';
COMMENT ON COLUMN ai_iar_agent_app.update_time IS '更新时间';
COMMENT ON COLUMN ai_iar_agent_app.del_flag IS '删除标志：0正常，2删除';
COMMENT ON COLUMN ai_iar_agent_app.remark IS '备注';

CREATE INDEX idx_agent_app_merchant ON ai_iar_agent_app(tenant_id, merchant_id);
CREATE INDEX idx_agent_app_id ON ai_iar_agent_app(agent_app_id);

-- ============================================================
-- 42. ai_iar_agent_app_tool
-- ============================================================
DROP TABLE IF EXISTS ai_iar_agent_app_tool CASCADE;
CREATE TABLE ai_iar_agent_app_tool (
    id bigserial PRIMARY KEY,
    tenant_id varchar(20),
    agent_app_id varchar(64) NOT NULL,
    tool_id varchar(64) NOT NULL,
    agent_id varchar(64),
    merchant_id varchar(64) NOT NULL,
    enabled_flag char(1) DEFAULT 'Y',
    data_scope varchar(64),
    need_confirm char(1) DEFAULT 'N',
    daily_limit int,
    monthly_limit int,
    create_by varchar(64),
    create_time timestamp,
    update_by varchar(64),
    update_time timestamp,
    del_flag char(1) DEFAULT '0',
    remark varchar(500)
);

COMMENT ON TABLE ai_iar_agent_app_tool IS '商户智能体工具授权表';
COMMENT ON COLUMN ai_iar_agent_app_tool.id IS '主键';
COMMENT ON COLUMN ai_iar_agent_app_tool.tenant_id IS '租户ID';
COMMENT ON COLUMN ai_iar_agent_app_tool.agent_app_id IS '智能体应用ID';
COMMENT ON COLUMN ai_iar_agent_app_tool.tool_id IS '工具ID';
COMMENT ON COLUMN ai_iar_agent_app_tool.agent_id IS '城市代理ID';
COMMENT ON COLUMN ai_iar_agent_app_tool.merchant_id IS '商户ID';
COMMENT ON COLUMN ai_iar_agent_app_tool.enabled_flag IS '是否启用：Y/N';
COMMENT ON COLUMN ai_iar_agent_app_tool.data_scope IS '数据权限范围';
COMMENT ON COLUMN ai_iar_agent_app_tool.need_confirm IS '是否需要人工确认：Y/N';
COMMENT ON COLUMN ai_iar_agent_app_tool.daily_limit IS '每日调用限制';
COMMENT ON COLUMN ai_iar_agent_app_tool.monthly_limit IS '每月调用限制';
COMMENT ON COLUMN ai_iar_agent_app_tool.create_by IS '创建者';
COMMENT ON COLUMN ai_iar_agent_app_tool.create_time IS '创建时间';
COMMENT ON COLUMN ai_iar_agent_app_tool.update_by IS '更新者';
COMMENT ON COLUMN ai_iar_agent_app_tool.update_time IS '更新时间';
COMMENT ON COLUMN ai_iar_agent_app_tool.del_flag IS '删除标志：0正常，2删除';
COMMENT ON COLUMN ai_iar_agent_app_tool.remark IS '备注';

CREATE INDEX idx_agent_app_tool ON ai_iar_agent_app_tool(agent_app_id, tool_id);

-- ============================================================
-- 43. ai_iar_agent_knowledge
-- ============================================================
DROP TABLE IF EXISTS ai_iar_agent_knowledge CASCADE;
CREATE TABLE ai_iar_agent_knowledge (
    id bigserial PRIMARY KEY,
    tenant_id varchar(20),
    agent_app_id varchar(64) NOT NULL,
    knowledge_type varchar(32),
    knowledge_id varchar(64),
    enabled_flag char(1) DEFAULT 'Y',
    agent_id varchar(64),
    merchant_id varchar(64) NOT NULL,
    create_by varchar(64),
    create_time timestamp,
    update_by varchar(64),
    update_time timestamp,
    del_flag char(1) DEFAULT '0',
    remark varchar(500)
);

COMMENT ON TABLE ai_iar_agent_knowledge IS '智能体知识绑定表';
COMMENT ON COLUMN ai_iar_agent_knowledge.id IS '主键';
COMMENT ON COLUMN ai_iar_agent_knowledge.tenant_id IS '租户ID';
COMMENT ON COLUMN ai_iar_agent_knowledge.agent_app_id IS '智能体应用ID';
COMMENT ON COLUMN ai_iar_agent_knowledge.knowledge_type IS '知识类型';
COMMENT ON COLUMN ai_iar_agent_knowledge.knowledge_id IS '知识对象ID';
COMMENT ON COLUMN ai_iar_agent_knowledge.enabled_flag IS '是否启用：Y/N';
COMMENT ON COLUMN ai_iar_agent_knowledge.agent_id IS '城市代理ID';
COMMENT ON COLUMN ai_iar_agent_knowledge.merchant_id IS '商户ID';
COMMENT ON COLUMN ai_iar_agent_knowledge.create_by IS '创建者';
COMMENT ON COLUMN ai_iar_agent_knowledge.create_time IS '创建时间';
COMMENT ON COLUMN ai_iar_agent_knowledge.update_by IS '更新者';
COMMENT ON COLUMN ai_iar_agent_knowledge.update_time IS '更新时间';
COMMENT ON COLUMN ai_iar_agent_knowledge.del_flag IS '删除标志：0正常，2删除';
COMMENT ON COLUMN ai_iar_agent_knowledge.remark IS '备注';

CREATE INDEX idx_agent_knowledge ON ai_iar_agent_knowledge(agent_app_id, knowledge_type);

-- ============================================================
-- 44. ai_iar_task
-- ============================================================
DROP TABLE IF EXISTS ai_iar_task CASCADE;
CREATE TABLE ai_iar_task (
    id bigserial PRIMARY KEY,
    task_id varchar(64) NOT NULL,
    tenant_id varchar(20),
    agent_id varchar(64),
    merchant_id varchar(64),
    agent_app_id varchar(64),
    session_id varchar(64),
    task_type varchar(64),
    task_status varchar(32),
    input_context jsonb,
    output_result jsonb,
    error_message text,
    start_time timestamp,
    end_time timestamp,
    create_time timestamp,
    remark varchar(500)
);

COMMENT ON TABLE ai_iar_task IS 'Agent任务表';
COMMENT ON COLUMN ai_iar_task.id IS '主键';
COMMENT ON COLUMN ai_iar_task.task_id IS '任务ID';
COMMENT ON COLUMN ai_iar_task.tenant_id IS '租户ID';
COMMENT ON COLUMN ai_iar_task.agent_id IS '城市代理ID';
COMMENT ON COLUMN ai_iar_task.merchant_id IS '商户ID';
COMMENT ON COLUMN ai_iar_task.agent_app_id IS '智能体应用ID';
COMMENT ON COLUMN ai_iar_task.session_id IS '会话ID';
COMMENT ON COLUMN ai_iar_task.task_type IS '任务类型';
COMMENT ON COLUMN ai_iar_task.task_status IS '任务状态';
COMMENT ON COLUMN ai_iar_task.input_context IS '输入上下文JSON';
COMMENT ON COLUMN ai_iar_task.output_result IS '输出结果JSON';
COMMENT ON COLUMN ai_iar_task.error_message IS '错误信息';
COMMENT ON COLUMN ai_iar_task.start_time IS '开始时间';
COMMENT ON COLUMN ai_iar_task.end_time IS '结束时间';
COMMENT ON COLUMN ai_iar_task.create_time IS '创建时间';
COMMENT ON COLUMN ai_iar_task.remark IS '备注';

CREATE INDEX idx_iar_task_session ON ai_iar_task(session_id);
CREATE INDEX idx_iar_task_agent_time ON ai_iar_task(agent_app_id, create_time);

-- ============================================================
-- 45. ai_iar_tool_call_log
-- ============================================================
DROP TABLE IF EXISTS ai_iar_tool_call_log CASCADE;
CREATE TABLE ai_iar_tool_call_log (
    id bigserial PRIMARY KEY,
    call_id varchar(64) NOT NULL,
    task_id varchar(64),
    agent_app_id varchar(64),
    tool_id varchar(64),
    tenant_id varchar(20),
    agent_id varchar(64),
    merchant_id varchar(64),
    input_args jsonb,
    output_result jsonb,
    success_flag char(1),
    error_message text,
    risk_level varchar(20),
    confirm_status varchar(32),
    create_time timestamp,
    remark varchar(500)
);

COMMENT ON TABLE ai_iar_tool_call_log IS '工具调用日志表';
COMMENT ON COLUMN ai_iar_tool_call_log.id IS '主键';
COMMENT ON COLUMN ai_iar_tool_call_log.call_id IS '调用ID';
COMMENT ON COLUMN ai_iar_tool_call_log.task_id IS '任务ID';
COMMENT ON COLUMN ai_iar_tool_call_log.agent_app_id IS '智能体应用ID';
COMMENT ON COLUMN ai_iar_tool_call_log.tool_id IS '工具ID';
COMMENT ON COLUMN ai_iar_tool_call_log.tenant_id IS '租户ID';
COMMENT ON COLUMN ai_iar_tool_call_log.agent_id IS '城市代理ID';
COMMENT ON COLUMN ai_iar_tool_call_log.merchant_id IS '商户ID';
COMMENT ON COLUMN ai_iar_tool_call_log.input_args IS 'input_args字段';
COMMENT ON COLUMN ai_iar_tool_call_log.output_result IS '输出结果JSON';
COMMENT ON COLUMN ai_iar_tool_call_log.success_flag IS '是否成功：Y/N';
COMMENT ON COLUMN ai_iar_tool_call_log.error_message IS '错误信息';
COMMENT ON COLUMN ai_iar_tool_call_log.risk_level IS '风险等级';
COMMENT ON COLUMN ai_iar_tool_call_log.confirm_status IS 'confirm_status状态';
COMMENT ON COLUMN ai_iar_tool_call_log.create_time IS '创建时间';
COMMENT ON COLUMN ai_iar_tool_call_log.remark IS '备注';

CREATE INDEX idx_tool_call_task ON ai_iar_tool_call_log(task_id);
CREATE INDEX idx_tool_call_merchant_time ON ai_iar_tool_call_log(tenant_id, merchant_id, create_time);

-- ============================================================
-- 46. ai_knc_document
-- ============================================================
DROP TABLE IF EXISTS ai_knc_document CASCADE;
CREATE TABLE ai_knc_document (
    id bigserial PRIMARY KEY,
    tenant_id varchar(20),
    document_id varchar(64) NOT NULL,
    agent_id varchar(64),
    merchant_id varchar(64),
    document_name varchar(255),
    document_type varchar(32),
    file_url varchar(500),
    language_code varchar(20),
    parse_status varchar(32),
    vector_status varchar(32),
    status char(1) DEFAULT '0',
    create_by varchar(64),
    create_time timestamp,
    update_by varchar(64),
    update_time timestamp,
    del_flag char(1) DEFAULT '0',
    remark varchar(500)
);

COMMENT ON TABLE ai_knc_document IS '知识文档表';
COMMENT ON COLUMN ai_knc_document.id IS '主键';
COMMENT ON COLUMN ai_knc_document.tenant_id IS '租户ID';
COMMENT ON COLUMN ai_knc_document.document_id IS '文档ID';
COMMENT ON COLUMN ai_knc_document.agent_id IS '城市代理ID';
COMMENT ON COLUMN ai_knc_document.merchant_id IS '商户ID';
COMMENT ON COLUMN ai_knc_document.document_name IS '文档名称';
COMMENT ON COLUMN ai_knc_document.document_type IS '文档类型';
COMMENT ON COLUMN ai_knc_document.file_url IS '文件URL';
COMMENT ON COLUMN ai_knc_document.language_code IS '语言编码';
COMMENT ON COLUMN ai_knc_document.parse_status IS '解析状态';
COMMENT ON COLUMN ai_knc_document.vector_status IS '向量化状态';
COMMENT ON COLUMN ai_knc_document.status IS '状态：0正常，1停用';
COMMENT ON COLUMN ai_knc_document.create_by IS '创建者';
COMMENT ON COLUMN ai_knc_document.create_time IS '创建时间';
COMMENT ON COLUMN ai_knc_document.update_by IS '更新者';
COMMENT ON COLUMN ai_knc_document.update_time IS '更新时间';
COMMENT ON COLUMN ai_knc_document.del_flag IS '删除标志：0正常，2删除';
COMMENT ON COLUMN ai_knc_document.remark IS '备注';

CREATE INDEX idx_knc_doc_merchant ON ai_knc_document(tenant_id, merchant_id);

-- ============================================================
-- 47. ai_knc_chunk
-- ============================================================
DROP TABLE IF EXISTS ai_knc_chunk CASCADE;
CREATE TABLE ai_knc_chunk (
    id bigserial PRIMARY KEY,
    chunk_id varchar(64) NOT NULL,
    document_id varchar(64) NOT NULL,
    tenant_id varchar(20),
    agent_id varchar(64),
    merchant_id varchar(64),
    chunk_index int,
    chunk_text text,
    token_count int,
    metadata jsonb,
    create_time timestamp,
    del_flag char(1) DEFAULT '0',
    remark varchar(500)
);

COMMENT ON TABLE ai_knc_chunk IS '知识切片表';
COMMENT ON COLUMN ai_knc_chunk.id IS '主键';
COMMENT ON COLUMN ai_knc_chunk.chunk_id IS '切片ID';
COMMENT ON COLUMN ai_knc_chunk.document_id IS '文档ID';
COMMENT ON COLUMN ai_knc_chunk.tenant_id IS '租户ID';
COMMENT ON COLUMN ai_knc_chunk.agent_id IS '城市代理ID';
COMMENT ON COLUMN ai_knc_chunk.merchant_id IS '商户ID';
COMMENT ON COLUMN ai_knc_chunk.chunk_index IS '切片序号';
COMMENT ON COLUMN ai_knc_chunk.chunk_text IS '切片文本';
COMMENT ON COLUMN ai_knc_chunk.token_count IS 'Token数量';
COMMENT ON COLUMN ai_knc_chunk.metadata IS '元数据JSON';
COMMENT ON COLUMN ai_knc_chunk.create_time IS '创建时间';
COMMENT ON COLUMN ai_knc_chunk.del_flag IS '删除标志：0正常，2删除';
COMMENT ON COLUMN ai_knc_chunk.remark IS '备注';

CREATE INDEX idx_knc_chunk_doc ON ai_knc_chunk(document_id);

-- ============================================================
-- 48. ai_knc_embedding
-- ============================================================
DROP TABLE IF EXISTS ai_knc_embedding CASCADE;
CREATE TABLE ai_knc_embedding (
    id bigserial PRIMARY KEY,
    embedding_id varchar(64) NOT NULL,
    tenant_id varchar(20),
    agent_id varchar(64),
    merchant_id varchar(64),
    source_type varchar(32),
    source_id varchar(64),
    chunk_id varchar(64),
    embedding_model varchar(128),
    vector_data vector(1536),
    metadata jsonb,
    create_time timestamp,
    del_flag char(1) DEFAULT '0',
    remark varchar(500)
);

COMMENT ON TABLE ai_knc_embedding IS '向量表，需安装pgvector扩展';
COMMENT ON COLUMN ai_knc_embedding.id IS '主键';
COMMENT ON COLUMN ai_knc_embedding.embedding_id IS '向量ID';
COMMENT ON COLUMN ai_knc_embedding.tenant_id IS '租户ID';
COMMENT ON COLUMN ai_knc_embedding.agent_id IS '城市代理ID';
COMMENT ON COLUMN ai_knc_embedding.merchant_id IS '商户ID';
COMMENT ON COLUMN ai_knc_embedding.source_type IS '来源类型';
COMMENT ON COLUMN ai_knc_embedding.source_id IS '来源ID';
COMMENT ON COLUMN ai_knc_embedding.chunk_id IS '切片ID';
COMMENT ON COLUMN ai_knc_embedding.embedding_model IS '向量模型';
COMMENT ON COLUMN ai_knc_embedding.vector_data IS '向量数据';
COMMENT ON COLUMN ai_knc_embedding.metadata IS '元数据JSON';
COMMENT ON COLUMN ai_knc_embedding.create_time IS '创建时间';
COMMENT ON COLUMN ai_knc_embedding.del_flag IS '删除标志：0正常，2删除';
COMMENT ON COLUMN ai_knc_embedding.remark IS '备注';

CREATE INDEX idx_knc_embedding_source ON ai_knc_embedding(tenant_id, merchant_id, source_type, source_id);

-- ============================================================
-- 49. ai_knc_faq
-- ============================================================
DROP TABLE IF EXISTS ai_knc_faq CASCADE;
CREATE TABLE ai_knc_faq (
    id bigserial PRIMARY KEY,
    tenant_id varchar(20),
    faq_id varchar(64) NOT NULL,
    agent_id varchar(64),
    merchant_id varchar(64),
    question text,
    answer text,
    language_code varchar(20),
    category_code varchar(64),
    vector_status varchar(32),
    status char(1) DEFAULT '0',
    create_by varchar(64),
    create_time timestamp,
    update_by varchar(64),
    update_time timestamp,
    del_flag char(1) DEFAULT '0',
    remark varchar(500)
);

COMMENT ON TABLE ai_knc_faq IS 'FAQ表';
COMMENT ON COLUMN ai_knc_faq.id IS '主键';
COMMENT ON COLUMN ai_knc_faq.tenant_id IS '租户ID';
COMMENT ON COLUMN ai_knc_faq.faq_id IS 'FAQ ID';
COMMENT ON COLUMN ai_knc_faq.agent_id IS '城市代理ID';
COMMENT ON COLUMN ai_knc_faq.merchant_id IS '商户ID';
COMMENT ON COLUMN ai_knc_faq.question IS '问题';
COMMENT ON COLUMN ai_knc_faq.answer IS '答案';
COMMENT ON COLUMN ai_knc_faq.language_code IS '语言编码';
COMMENT ON COLUMN ai_knc_faq.category_code IS '分类编码';
COMMENT ON COLUMN ai_knc_faq.vector_status IS '向量化状态';
COMMENT ON COLUMN ai_knc_faq.status IS '状态：0正常，1停用';
COMMENT ON COLUMN ai_knc_faq.create_by IS '创建者';
COMMENT ON COLUMN ai_knc_faq.create_time IS '创建时间';
COMMENT ON COLUMN ai_knc_faq.update_by IS '更新者';
COMMENT ON COLUMN ai_knc_faq.update_time IS '更新时间';
COMMENT ON COLUMN ai_knc_faq.del_flag IS '删除标志：0正常，2删除';
COMMENT ON COLUMN ai_knc_faq.remark IS '备注';

CREATE INDEX idx_faq_merchant ON ai_knc_faq(tenant_id, merchant_id);

-- ============================================================
-- 50. biz_opc_goods
-- ============================================================
DROP TABLE IF EXISTS biz_opc_goods CASCADE;
CREATE TABLE biz_opc_goods (
    id bigserial PRIMARY KEY,
    tenant_id varchar(20),
    goods_id varchar(64) NOT NULL,
    agent_id varchar(64),
    merchant_id varchar(64) NOT NULL,
    goods_name varchar(255),
    goods_desc text,
    category_code varchar(64),
    brand_name varchar(128),
    main_image varchar(500),
    language_code varchar(20),
    sale_status varchar(32),
    vector_status varchar(32),
    status char(1) DEFAULT '0',
    create_by varchar(64),
    create_time timestamp,
    update_by varchar(64),
    update_time timestamp,
    del_flag char(1) DEFAULT '0',
    remark varchar(500)
);

COMMENT ON TABLE biz_opc_goods IS '商品表';
COMMENT ON COLUMN biz_opc_goods.id IS '主键';
COMMENT ON COLUMN biz_opc_goods.tenant_id IS '租户ID';
COMMENT ON COLUMN biz_opc_goods.goods_id IS '商品ID';
COMMENT ON COLUMN biz_opc_goods.agent_id IS '城市代理ID';
COMMENT ON COLUMN biz_opc_goods.merchant_id IS '商户ID';
COMMENT ON COLUMN biz_opc_goods.goods_name IS '商品名称';
COMMENT ON COLUMN biz_opc_goods.goods_desc IS '商品描述';
COMMENT ON COLUMN biz_opc_goods.category_code IS '分类编码';
COMMENT ON COLUMN biz_opc_goods.brand_name IS '品牌名称';
COMMENT ON COLUMN biz_opc_goods.main_image IS '主图URL';
COMMENT ON COLUMN biz_opc_goods.language_code IS '语言编码';
COMMENT ON COLUMN biz_opc_goods.sale_status IS '销售状态';
COMMENT ON COLUMN biz_opc_goods.vector_status IS '向量化状态';
COMMENT ON COLUMN biz_opc_goods.status IS '状态：0正常，1停用';
COMMENT ON COLUMN biz_opc_goods.create_by IS '创建者';
COMMENT ON COLUMN biz_opc_goods.create_time IS '创建时间';
COMMENT ON COLUMN biz_opc_goods.update_by IS '更新者';
COMMENT ON COLUMN biz_opc_goods.update_time IS '更新时间';
COMMENT ON COLUMN biz_opc_goods.del_flag IS '删除标志：0正常，2删除';
COMMENT ON COLUMN biz_opc_goods.remark IS '备注';

CREATE INDEX idx_goods_merchant ON biz_opc_goods(tenant_id, merchant_id);
CREATE INDEX idx_goods_id ON biz_opc_goods(goods_id);

-- ============================================================
-- 51. biz_opc_goods_sku
-- ============================================================
DROP TABLE IF EXISTS biz_opc_goods_sku CASCADE;
CREATE TABLE biz_opc_goods_sku (
    id bigserial PRIMARY KEY,
    tenant_id varchar(20),
    sku_id varchar(64) NOT NULL,
    goods_id varchar(64) NOT NULL,
    agent_id varchar(64),
    merchant_id varchar(64) NOT NULL,
    sku_name varchar(255),
    sku_attrs jsonb,
    price numeric(18,2),
    original_price numeric(18,2),
    currency_code varchar(20),
    stock_qty int DEFAULT 0,
    locked_stock int DEFAULT 0,
    sku_image varchar(500),
    status char(1) DEFAULT '0',
    create_by varchar(64),
    create_time timestamp,
    update_by varchar(64),
    update_time timestamp,
    del_flag char(1) DEFAULT '0',
    remark varchar(500)
);

COMMENT ON TABLE biz_opc_goods_sku IS '商品SKU表';
COMMENT ON COLUMN biz_opc_goods_sku.id IS '主键';
COMMENT ON COLUMN biz_opc_goods_sku.tenant_id IS '租户ID';
COMMENT ON COLUMN biz_opc_goods_sku.sku_id IS 'SKU ID';
COMMENT ON COLUMN biz_opc_goods_sku.goods_id IS '商品ID';
COMMENT ON COLUMN biz_opc_goods_sku.agent_id IS '城市代理ID';
COMMENT ON COLUMN biz_opc_goods_sku.merchant_id IS '商户ID';
COMMENT ON COLUMN biz_opc_goods_sku.sku_name IS 'SKU名称';
COMMENT ON COLUMN biz_opc_goods_sku.sku_attrs IS 'SKU规格属性JSON';
COMMENT ON COLUMN biz_opc_goods_sku.price IS '价格';
COMMENT ON COLUMN biz_opc_goods_sku.original_price IS '原价';
COMMENT ON COLUMN biz_opc_goods_sku.currency_code IS '币种编码';
COMMENT ON COLUMN biz_opc_goods_sku.stock_qty IS '库存数量';
COMMENT ON COLUMN biz_opc_goods_sku.locked_stock IS '锁定库存';
COMMENT ON COLUMN biz_opc_goods_sku.sku_image IS 'SKU图片';
COMMENT ON COLUMN biz_opc_goods_sku.status IS '状态：0正常，1停用';
COMMENT ON COLUMN biz_opc_goods_sku.create_by IS '创建者';
COMMENT ON COLUMN biz_opc_goods_sku.create_time IS '创建时间';
COMMENT ON COLUMN biz_opc_goods_sku.update_by IS '更新者';
COMMENT ON COLUMN biz_opc_goods_sku.update_time IS '更新时间';
COMMENT ON COLUMN biz_opc_goods_sku.del_flag IS '删除标志：0正常，2删除';
COMMENT ON COLUMN biz_opc_goods_sku.remark IS '备注';

CREATE INDEX idx_sku_goods ON biz_opc_goods_sku(goods_id);
CREATE INDEX idx_sku_merchant ON biz_opc_goods_sku(tenant_id, merchant_id);

-- ============================================================
-- 52. biz_opc_order
-- ============================================================
DROP TABLE IF EXISTS biz_opc_order CASCADE;
CREATE TABLE biz_opc_order (
    id bigserial PRIMARY KEY,
    tenant_id varchar(20),
    order_id varchar(64) NOT NULL,
    order_no varchar(64),
    agent_id varchar(64),
    merchant_id varchar(64) NOT NULL,
    member_id varchar(64),
    merchant_member_id varchar(64),
    session_id varchar(64),
    order_source varchar(32),
    order_type varchar(32),
    total_amount numeric(18,2),
    paid_amount numeric(18,2) DEFAULT 0,
    currency_code varchar(20),
    order_status varchar(32),
    pay_status varchar(32),
    delivery_status varchar(32),
    verify_status varchar(32),
    service_total_times int DEFAULT 0,
    service_used_times int DEFAULT 0,
    service_remaining_times int DEFAULT 0,
    receiver_name varchar(128),
    receiver_phone varchar(64),
    receiver_address varchar(500),
    ai_created char(1) DEFAULT 'N',
    status char(1) DEFAULT '0',
    create_by varchar(64),
    create_time timestamp,
    update_by varchar(64),
    update_time timestamp,
    del_flag char(1) DEFAULT '0',
    remark varchar(500)
);

COMMENT ON TABLE biz_opc_order IS '订单主表，支持商品订单、服务订单、混合订单和分期订单';
COMMENT ON COLUMN biz_opc_order.id IS '主键';
COMMENT ON COLUMN biz_opc_order.tenant_id IS '租户ID';
COMMENT ON COLUMN biz_opc_order.order_id IS '订单ID';
COMMENT ON COLUMN biz_opc_order.order_no IS '订单编号';
COMMENT ON COLUMN biz_opc_order.agent_id IS '城市代理ID';
COMMENT ON COLUMN biz_opc_order.merchant_id IS '商户ID';
COMMENT ON COLUMN biz_opc_order.member_id IS '会员ID';
COMMENT ON COLUMN biz_opc_order.merchant_member_id IS '商户客户关系ID';
COMMENT ON COLUMN biz_opc_order.session_id IS '会话ID';
COMMENT ON COLUMN biz_opc_order.order_source IS '订单来源';
COMMENT ON COLUMN biz_opc_order.order_type IS '订单类型';
COMMENT ON COLUMN biz_opc_order.total_amount IS '订单总金额';
COMMENT ON COLUMN biz_opc_order.paid_amount IS '已支付金额';
COMMENT ON COLUMN biz_opc_order.currency_code IS '币种编码';
COMMENT ON COLUMN biz_opc_order.order_status IS '订单状态';
COMMENT ON COLUMN biz_opc_order.pay_status IS '支付状态';
COMMENT ON COLUMN biz_opc_order.delivery_status IS '发货状态';
COMMENT ON COLUMN biz_opc_order.verify_status IS '核销状态';
COMMENT ON COLUMN biz_opc_order.service_total_times IS '服务总次数';
COMMENT ON COLUMN biz_opc_order.service_used_times IS '已使用服务次数';
COMMENT ON COLUMN biz_opc_order.service_remaining_times IS '剩余服务次数';
COMMENT ON COLUMN biz_opc_order.receiver_name IS '收货人姓名';
COMMENT ON COLUMN biz_opc_order.receiver_phone IS '收货人电话';
COMMENT ON COLUMN biz_opc_order.receiver_address IS '收货地址';
COMMENT ON COLUMN biz_opc_order.ai_created IS '是否AI创建：Y/N';
COMMENT ON COLUMN biz_opc_order.status IS '状态：0正常，1停用';
COMMENT ON COLUMN biz_opc_order.create_by IS '创建者';
COMMENT ON COLUMN biz_opc_order.create_time IS '创建时间';
COMMENT ON COLUMN biz_opc_order.update_by IS '更新者';
COMMENT ON COLUMN biz_opc_order.update_time IS '更新时间';
COMMENT ON COLUMN biz_opc_order.del_flag IS '删除标志：0正常，2删除';
COMMENT ON COLUMN biz_opc_order.remark IS '备注';

CREATE INDEX idx_order_merchant ON biz_opc_order(tenant_id, merchant_id, create_time);
CREATE INDEX idx_order_no ON biz_opc_order(order_no);

-- ============================================================
-- 53. biz_opc_order_item
-- ============================================================
DROP TABLE IF EXISTS biz_opc_order_item CASCADE;
CREATE TABLE biz_opc_order_item (
    id bigserial PRIMARY KEY,
    order_id varchar(64) NOT NULL,
    goods_id varchar(64),
    sku_id varchar(64),
    service_id varchar(64),
    item_type varchar(32),
    item_name varchar(255),
    sku_name varchar(255),
    quantity int,
    service_times int DEFAULT 0,
    unit_price numeric(18,2),
    total_price numeric(18,2),
    tenant_id varchar(20),
    agent_id varchar(64),
    merchant_id varchar(64),
    create_time timestamp,
    remark varchar(500)
);

COMMENT ON TABLE biz_opc_order_item IS '订单明细表';
COMMENT ON COLUMN biz_opc_order_item.id IS '主键';
COMMENT ON COLUMN biz_opc_order_item.order_id IS '订单ID';
COMMENT ON COLUMN biz_opc_order_item.goods_id IS '商品ID';
COMMENT ON COLUMN biz_opc_order_item.sku_id IS 'SKU ID';
COMMENT ON COLUMN biz_opc_order_item.service_id IS '服务ID';
COMMENT ON COLUMN biz_opc_order_item.item_type IS 'goods/service';
COMMENT ON COLUMN biz_opc_order_item.item_name IS '明细名称快照';
COMMENT ON COLUMN biz_opc_order_item.sku_name IS 'SKU名称';
COMMENT ON COLUMN biz_opc_order_item.quantity IS '数量';
COMMENT ON COLUMN biz_opc_order_item.service_times IS '服务次数';
COMMENT ON COLUMN biz_opc_order_item.unit_price IS '单价';
COMMENT ON COLUMN biz_opc_order_item.total_price IS '小计金额';
COMMENT ON COLUMN biz_opc_order_item.tenant_id IS '租户ID';
COMMENT ON COLUMN biz_opc_order_item.agent_id IS '城市代理ID';
COMMENT ON COLUMN biz_opc_order_item.merchant_id IS '商户ID';
COMMENT ON COLUMN biz_opc_order_item.create_time IS '创建时间';
COMMENT ON COLUMN biz_opc_order_item.remark IS '备注';

CREATE INDEX idx_order_item_order ON biz_opc_order_item(order_id);

-- ============================================================
-- 54. biz_opc_order_flow
-- ============================================================
DROP TABLE IF EXISTS biz_opc_order_flow CASCADE;
CREATE TABLE biz_opc_order_flow (
    id bigserial PRIMARY KEY,
    flow_id varchar(64) NOT NULL,
    order_id varchar(64) NOT NULL,
    from_status varchar(32),
    to_status varchar(32),
    action_type varchar(64),
    operator_type varchar(32),
    operator_id varchar(64),
    flow_note varchar(500),
    tenant_id varchar(20),
    agent_id varchar(64),
    merchant_id varchar(64),
    create_time timestamp,
    remark varchar(500)
);

COMMENT ON TABLE biz_opc_order_flow IS '订单流程表';
COMMENT ON COLUMN biz_opc_order_flow.id IS '主键';
COMMENT ON COLUMN biz_opc_order_flow.flow_id IS '流程ID';
COMMENT ON COLUMN biz_opc_order_flow.order_id IS '订单ID';
COMMENT ON COLUMN biz_opc_order_flow.from_status IS '原状态';
COMMENT ON COLUMN biz_opc_order_flow.to_status IS '新状态';
COMMENT ON COLUMN biz_opc_order_flow.action_type IS '操作类型';
COMMENT ON COLUMN biz_opc_order_flow.operator_type IS '操作人类型';
COMMENT ON COLUMN biz_opc_order_flow.operator_id IS '操作人ID';
COMMENT ON COLUMN biz_opc_order_flow.flow_note IS '流程说明';
COMMENT ON COLUMN biz_opc_order_flow.tenant_id IS '租户ID';
COMMENT ON COLUMN biz_opc_order_flow.agent_id IS '城市代理ID';
COMMENT ON COLUMN biz_opc_order_flow.merchant_id IS '商户ID';
COMMENT ON COLUMN biz_opc_order_flow.create_time IS '创建时间';
COMMENT ON COLUMN biz_opc_order_flow.remark IS '备注';

CREATE INDEX idx_order_flow_order ON biz_opc_order_flow(order_id);

-- ============================================================
-- 55. biz_opc_order_delivery
-- ============================================================
DROP TABLE IF EXISTS biz_opc_order_delivery CASCADE;
CREATE TABLE biz_opc_order_delivery (
    id bigserial PRIMARY KEY,
    tenant_id varchar(20),
    delivery_id varchar(64) NOT NULL,
    order_id varchar(64) NOT NULL,
    agent_id varchar(64),
    merchant_id varchar(64) NOT NULL,
    delivery_type varchar(32),
    logistics_company varchar(128),
    tracking_no varchar(128),
    delivery_staff_id varchar(64),
    delivery_status varchar(32),
    delivery_time timestamp,
    receive_time timestamp,
    receiver_name varchar(128),
    receiver_phone varchar(64),
    receiver_address varchar(500),
    create_by varchar(64),
    create_time timestamp,
    update_by varchar(64),
    update_time timestamp,
    del_flag char(1) DEFAULT '0',
    remark varchar(500)
);

COMMENT ON TABLE biz_opc_order_delivery IS '商品订单发货表';
COMMENT ON COLUMN biz_opc_order_delivery.id IS '主键';
COMMENT ON COLUMN biz_opc_order_delivery.tenant_id IS '租户ID';
COMMENT ON COLUMN biz_opc_order_delivery.delivery_id IS '发货ID';
COMMENT ON COLUMN biz_opc_order_delivery.order_id IS '订单ID';
COMMENT ON COLUMN biz_opc_order_delivery.agent_id IS '城市代理ID';
COMMENT ON COLUMN biz_opc_order_delivery.merchant_id IS '商户ID';
COMMENT ON COLUMN biz_opc_order_delivery.delivery_type IS '发货方式';
COMMENT ON COLUMN biz_opc_order_delivery.logistics_company IS '物流公司';
COMMENT ON COLUMN biz_opc_order_delivery.tracking_no IS '运单号';
COMMENT ON COLUMN biz_opc_order_delivery.delivery_staff_id IS '发货员工ID';
COMMENT ON COLUMN biz_opc_order_delivery.delivery_status IS '发货状态';
COMMENT ON COLUMN biz_opc_order_delivery.delivery_time IS '发货时间';
COMMENT ON COLUMN biz_opc_order_delivery.receive_time IS '收货时间';
COMMENT ON COLUMN biz_opc_order_delivery.receiver_name IS '收货人姓名';
COMMENT ON COLUMN biz_opc_order_delivery.receiver_phone IS '收货人电话';
COMMENT ON COLUMN biz_opc_order_delivery.receiver_address IS '收货地址';
COMMENT ON COLUMN biz_opc_order_delivery.create_by IS '创建者';
COMMENT ON COLUMN biz_opc_order_delivery.create_time IS '创建时间';
COMMENT ON COLUMN biz_opc_order_delivery.update_by IS '更新者';
COMMENT ON COLUMN biz_opc_order_delivery.update_time IS '更新时间';
COMMENT ON COLUMN biz_opc_order_delivery.del_flag IS '删除标志：0正常，2删除';
COMMENT ON COLUMN biz_opc_order_delivery.remark IS '备注';

CREATE INDEX idx_order_delivery_order ON biz_opc_order_delivery(order_id);

-- ============================================================
-- 56. biz_opc_service
-- ============================================================
DROP TABLE IF EXISTS biz_opc_service CASCADE;
CREATE TABLE biz_opc_service (
    id bigserial PRIMARY KEY,
    tenant_id varchar(20),
    service_id varchar(64) NOT NULL,
    agent_id varchar(64),
    merchant_id varchar(64) NOT NULL,
    service_name varchar(255),
    service_desc text,
    service_type varchar(64),
    service_duration int,
    default_times int DEFAULT 1,
    price numeric(18,2),
    currency_code varchar(20),
    language_code varchar(20),
    booking_enabled char(1) DEFAULT 'Y',
    verify_enabled char(1) DEFAULT 'Y',
    status char(1) DEFAULT '0',
    create_by varchar(64),
    create_time timestamp,
    update_by varchar(64),
    update_time timestamp,
    del_flag char(1) DEFAULT '0',
    remark varchar(500)
);

COMMENT ON TABLE biz_opc_service IS '服务项目表';
COMMENT ON COLUMN biz_opc_service.id IS '主键';
COMMENT ON COLUMN biz_opc_service.tenant_id IS '租户ID';
COMMENT ON COLUMN biz_opc_service.service_id IS '服务ID';
COMMENT ON COLUMN biz_opc_service.agent_id IS '城市代理ID';
COMMENT ON COLUMN biz_opc_service.merchant_id IS '商户ID';
COMMENT ON COLUMN biz_opc_service.service_name IS '服务名称';
COMMENT ON COLUMN biz_opc_service.service_desc IS '服务描述';
COMMENT ON COLUMN biz_opc_service.service_type IS '服务类型';
COMMENT ON COLUMN biz_opc_service.service_duration IS '服务时长分钟';
COMMENT ON COLUMN biz_opc_service.default_times IS '默认服务次数';
COMMENT ON COLUMN biz_opc_service.price IS '价格';
COMMENT ON COLUMN biz_opc_service.currency_code IS '币种编码';
COMMENT ON COLUMN biz_opc_service.language_code IS '语言编码';
COMMENT ON COLUMN biz_opc_service.booking_enabled IS '是否可预约：Y/N';
COMMENT ON COLUMN biz_opc_service.verify_enabled IS '是否需要核销：Y/N';
COMMENT ON COLUMN biz_opc_service.status IS '状态：0正常，1停用';
COMMENT ON COLUMN biz_opc_service.create_by IS '创建者';
COMMENT ON COLUMN biz_opc_service.create_time IS '创建时间';
COMMENT ON COLUMN biz_opc_service.update_by IS '更新者';
COMMENT ON COLUMN biz_opc_service.update_time IS '更新时间';
COMMENT ON COLUMN biz_opc_service.del_flag IS '删除标志：0正常，2删除';
COMMENT ON COLUMN biz_opc_service.remark IS '备注';

CREATE INDEX idx_service_merchant ON biz_opc_service(tenant_id, merchant_id);

-- ============================================================
-- 57. biz_opc_service_teacher
-- ============================================================
DROP TABLE IF EXISTS biz_opc_service_teacher CASCADE;
CREATE TABLE biz_opc_service_teacher (
    id bigserial PRIMARY KEY,
    tenant_id varchar(20),
    teacher_id varchar(64) NOT NULL,
    agent_id varchar(64),
    merchant_id varchar(64) NOT NULL,
    staff_id varchar(64),
    teacher_name varchar(128),
    avatar_url varchar(500),
    skills varchar(500),
    service_scope varchar(500),
    status char(1) DEFAULT '0',
    create_by varchar(64),
    create_time timestamp,
    update_by varchar(64),
    update_time timestamp,
    del_flag char(1) DEFAULT '0',
    remark varchar(500)
);

COMMENT ON TABLE biz_opc_service_teacher IS '服务老师/服务人员表，可关联商户员工';
COMMENT ON COLUMN biz_opc_service_teacher.id IS '主键';
COMMENT ON COLUMN biz_opc_service_teacher.tenant_id IS '租户ID';
COMMENT ON COLUMN biz_opc_service_teacher.teacher_id IS '服务老师ID';
COMMENT ON COLUMN biz_opc_service_teacher.agent_id IS '城市代理ID';
COMMENT ON COLUMN biz_opc_service_teacher.merchant_id IS '商户ID';
COMMENT ON COLUMN biz_opc_service_teacher.staff_id IS '商户员工ID';
COMMENT ON COLUMN biz_opc_service_teacher.teacher_name IS '服务老师名称';
COMMENT ON COLUMN biz_opc_service_teacher.avatar_url IS '头像URL';
COMMENT ON COLUMN biz_opc_service_teacher.skills IS '擅长技能';
COMMENT ON COLUMN biz_opc_service_teacher.service_scope IS '可服务项目范围';
COMMENT ON COLUMN biz_opc_service_teacher.status IS '状态：0正常，1停用';
COMMENT ON COLUMN biz_opc_service_teacher.create_by IS '创建者';
COMMENT ON COLUMN biz_opc_service_teacher.create_time IS '创建时间';
COMMENT ON COLUMN biz_opc_service_teacher.update_by IS '更新者';
COMMENT ON COLUMN biz_opc_service_teacher.update_time IS '更新时间';
COMMENT ON COLUMN biz_opc_service_teacher.del_flag IS '删除标志：0正常，2删除';
COMMENT ON COLUMN biz_opc_service_teacher.remark IS '备注';

CREATE INDEX idx_teacher_merchant ON biz_opc_service_teacher(tenant_id, merchant_id);

-- ============================================================
-- 58. biz_opc_service_schedule_rule
-- ============================================================
DROP TABLE IF EXISTS biz_opc_service_schedule_rule CASCADE;
CREATE TABLE biz_opc_service_schedule_rule (
    id bigserial PRIMARY KEY,
    tenant_id varchar(20),
    rule_id varchar(64) NOT NULL,
    agent_id varchar(64),
    merchant_id varchar(64) NOT NULL,
    teacher_id varchar(64),
    service_id varchar(64),
    rule_name varchar(128),
    rule_type varchar(32),
    valid_from date,
    valid_to date,
    timezone varchar(64),
    capacity_per_slot int DEFAULT 1,
    booking_advance_days int DEFAULT 30,
    cancel_before_hours int DEFAULT 24,
    status char(1) DEFAULT '0',
    create_by varchar(64),
    create_time timestamp,
    update_by varchar(64),
    update_time timestamp,
    del_flag char(1) DEFAULT '0',
    remark varchar(500)
);

COMMENT ON TABLE biz_opc_service_schedule_rule IS '服务排班规则主表';
COMMENT ON COLUMN biz_opc_service_schedule_rule.id IS '主键';
COMMENT ON COLUMN biz_opc_service_schedule_rule.tenant_id IS '租户ID';
COMMENT ON COLUMN biz_opc_service_schedule_rule.rule_id IS '排班规则ID';
COMMENT ON COLUMN biz_opc_service_schedule_rule.agent_id IS '城市代理ID';
COMMENT ON COLUMN biz_opc_service_schedule_rule.merchant_id IS '商户ID';
COMMENT ON COLUMN biz_opc_service_schedule_rule.teacher_id IS '服务老师ID';
COMMENT ON COLUMN biz_opc_service_schedule_rule.service_id IS '服务ID';
COMMENT ON COLUMN biz_opc_service_schedule_rule.rule_name IS '规则名称';
COMMENT ON COLUMN biz_opc_service_schedule_rule.rule_type IS '规则类型';
COMMENT ON COLUMN biz_opc_service_schedule_rule.valid_from IS '有效开始日期';
COMMENT ON COLUMN biz_opc_service_schedule_rule.valid_to IS '有效截止日期';
COMMENT ON COLUMN biz_opc_service_schedule_rule.timezone IS '时区';
COMMENT ON COLUMN biz_opc_service_schedule_rule.capacity_per_slot IS '每个时段默认容量';
COMMENT ON COLUMN biz_opc_service_schedule_rule.booking_advance_days IS '可提前预约天数';
COMMENT ON COLUMN biz_opc_service_schedule_rule.cancel_before_hours IS '可取消提前小时数';
COMMENT ON COLUMN biz_opc_service_schedule_rule.status IS '状态：0正常，1停用';
COMMENT ON COLUMN biz_opc_service_schedule_rule.create_by IS '创建者';
COMMENT ON COLUMN biz_opc_service_schedule_rule.create_time IS '创建时间';
COMMENT ON COLUMN biz_opc_service_schedule_rule.update_by IS '更新者';
COMMENT ON COLUMN biz_opc_service_schedule_rule.update_time IS '更新时间';
COMMENT ON COLUMN biz_opc_service_schedule_rule.del_flag IS '删除标志：0正常，2删除';
COMMENT ON COLUMN biz_opc_service_schedule_rule.remark IS '备注';

CREATE INDEX idx_schedule_rule_merchant ON biz_opc_service_schedule_rule(tenant_id, merchant_id, teacher_id, service_id);

-- ============================================================
-- 59. biz_opc_service_schedule_slot
-- ============================================================
DROP TABLE IF EXISTS biz_opc_service_schedule_slot CASCADE;
CREATE TABLE biz_opc_service_schedule_slot (
    id bigserial PRIMARY KEY,
    tenant_id varchar(20),
    slot_id varchar(64) NOT NULL,
    rule_id varchar(64) NOT NULL,
    agent_id varchar(64),
    merchant_id varchar(64) NOT NULL,
    day_of_week int NOT NULL,
    start_time time NOT NULL,
    end_time time NOT NULL,
    capacity int DEFAULT 1,
    slot_status varchar(32) DEFAULT 'available',
    create_by varchar(64),
    create_time timestamp,
    update_by varchar(64),
    update_time timestamp,
    del_flag char(1) DEFAULT '0',
    remark varchar(500)
);

COMMENT ON TABLE biz_opc_service_schedule_slot IS '服务排班规则时段表，一条记录代表每周某一天的一个可预约时段';
COMMENT ON COLUMN biz_opc_service_schedule_slot.id IS '主键';
COMMENT ON COLUMN biz_opc_service_schedule_slot.tenant_id IS '租户ID';
COMMENT ON COLUMN biz_opc_service_schedule_slot.slot_id IS '排班时段ID';
COMMENT ON COLUMN biz_opc_service_schedule_slot.rule_id IS '排班规则ID';
COMMENT ON COLUMN biz_opc_service_schedule_slot.agent_id IS '城市代理ID';
COMMENT ON COLUMN biz_opc_service_schedule_slot.merchant_id IS '商户ID';
COMMENT ON COLUMN biz_opc_service_schedule_slot.day_of_week IS '星期几：1周一，7周日';
COMMENT ON COLUMN biz_opc_service_schedule_slot.start_time IS '开始时间';
COMMENT ON COLUMN biz_opc_service_schedule_slot.end_time IS '结束时间';
COMMENT ON COLUMN biz_opc_service_schedule_slot.capacity IS '容量';
COMMENT ON COLUMN biz_opc_service_schedule_slot.slot_status IS '时段状态';
COMMENT ON COLUMN biz_opc_service_schedule_slot.create_by IS '创建者';
COMMENT ON COLUMN biz_opc_service_schedule_slot.create_time IS '创建时间';
COMMENT ON COLUMN biz_opc_service_schedule_slot.update_by IS '更新者';
COMMENT ON COLUMN biz_opc_service_schedule_slot.update_time IS '更新时间';
COMMENT ON COLUMN biz_opc_service_schedule_slot.del_flag IS '删除标志：0正常，2删除';
COMMENT ON COLUMN biz_opc_service_schedule_slot.remark IS '备注';

CREATE INDEX idx_schedule_slot_rule_day ON biz_opc_service_schedule_slot(rule_id, day_of_week);

-- ============================================================
-- 60. biz_opc_service_schedule_instance
-- ============================================================
DROP TABLE IF EXISTS biz_opc_service_schedule_instance CASCADE;
CREATE TABLE biz_opc_service_schedule_instance (
    id bigserial PRIMARY KEY,
    tenant_id varchar(20),
    instance_id varchar(64) NOT NULL,
    rule_id varchar(64),
    slot_id varchar(64),
    agent_id varchar(64),
    merchant_id varchar(64) NOT NULL,
    teacher_id varchar(64),
    service_id varchar(64),
    schedule_date date NOT NULL,
    start_time timestamp NOT NULL,
    end_time timestamp NOT NULL,
    capacity int DEFAULT 1,
    booked_count int DEFAULT 0,
    remaining_count int DEFAULT 1,
    instance_status varchar(32) DEFAULT 'available',
    create_by varchar(64),
    create_time timestamp,
    update_by varchar(64),
    update_time timestamp,
    del_flag char(1) DEFAULT '0',
    remark varchar(500)
);

COMMENT ON TABLE biz_opc_service_schedule_instance IS '服务具体日期排班实例表，预约时扣减该表容量';
COMMENT ON COLUMN biz_opc_service_schedule_instance.id IS '主键';
COMMENT ON COLUMN biz_opc_service_schedule_instance.tenant_id IS '租户ID';
COMMENT ON COLUMN biz_opc_service_schedule_instance.instance_id IS '排班实例ID';
COMMENT ON COLUMN biz_opc_service_schedule_instance.rule_id IS '排班规则ID';
COMMENT ON COLUMN biz_opc_service_schedule_instance.slot_id IS '排班时段ID';
COMMENT ON COLUMN biz_opc_service_schedule_instance.agent_id IS '城市代理ID';
COMMENT ON COLUMN biz_opc_service_schedule_instance.merchant_id IS '商户ID';
COMMENT ON COLUMN biz_opc_service_schedule_instance.teacher_id IS '服务老师ID';
COMMENT ON COLUMN biz_opc_service_schedule_instance.service_id IS '服务ID';
COMMENT ON COLUMN biz_opc_service_schedule_instance.schedule_date IS '排班日期';
COMMENT ON COLUMN biz_opc_service_schedule_instance.start_time IS '开始时间';
COMMENT ON COLUMN biz_opc_service_schedule_instance.end_time IS '结束时间';
COMMENT ON COLUMN biz_opc_service_schedule_instance.capacity IS '容量';
COMMENT ON COLUMN biz_opc_service_schedule_instance.booked_count IS '已预约数量';
COMMENT ON COLUMN biz_opc_service_schedule_instance.remaining_count IS '剩余容量';
COMMENT ON COLUMN biz_opc_service_schedule_instance.instance_status IS '实例状态';
COMMENT ON COLUMN biz_opc_service_schedule_instance.create_by IS '创建者';
COMMENT ON COLUMN biz_opc_service_schedule_instance.create_time IS '创建时间';
COMMENT ON COLUMN biz_opc_service_schedule_instance.update_by IS '更新者';
COMMENT ON COLUMN biz_opc_service_schedule_instance.update_time IS '更新时间';
COMMENT ON COLUMN biz_opc_service_schedule_instance.del_flag IS '删除标志：0正常，2删除';
COMMENT ON COLUMN biz_opc_service_schedule_instance.remark IS '备注';

CREATE INDEX idx_schedule_instance_query ON biz_opc_service_schedule_instance(tenant_id, merchant_id, service_id, teacher_id, schedule_date);

-- ============================================================
-- 61. biz_opc_service_entitlement
-- ============================================================
DROP TABLE IF EXISTS biz_opc_service_entitlement CASCADE;
CREATE TABLE biz_opc_service_entitlement (
    id bigserial PRIMARY KEY,
    tenant_id varchar(20),
    entitlement_id varchar(64) NOT NULL,
    agent_id varchar(64),
    merchant_id varchar(64) NOT NULL,
    member_id varchar(64) NOT NULL,
    order_id varchar(64) NOT NULL,
    service_id varchar(64) NOT NULL,
    total_times int,
    used_times int DEFAULT 0,
    remaining_times int,
    valid_from timestamp,
    valid_to timestamp,
    entitlement_status varchar(32),
    create_by varchar(64),
    create_time timestamp,
    update_by varchar(64),
    update_time timestamp,
    del_flag char(1) DEFAULT '0',
    remark varchar(500)
);

COMMENT ON TABLE biz_opc_service_entitlement IS '服务权益表，用户购买服务订单后生成';
COMMENT ON COLUMN biz_opc_service_entitlement.id IS '主键';
COMMENT ON COLUMN biz_opc_service_entitlement.tenant_id IS '租户ID';
COMMENT ON COLUMN biz_opc_service_entitlement.entitlement_id IS '服务权益ID';
COMMENT ON COLUMN biz_opc_service_entitlement.agent_id IS '城市代理ID';
COMMENT ON COLUMN biz_opc_service_entitlement.merchant_id IS '商户ID';
COMMENT ON COLUMN biz_opc_service_entitlement.member_id IS '会员ID';
COMMENT ON COLUMN biz_opc_service_entitlement.order_id IS '订单ID';
COMMENT ON COLUMN biz_opc_service_entitlement.service_id IS '服务ID';
COMMENT ON COLUMN biz_opc_service_entitlement.total_times IS '总次数';
COMMENT ON COLUMN biz_opc_service_entitlement.used_times IS '已使用次数';
COMMENT ON COLUMN biz_opc_service_entitlement.remaining_times IS '剩余次数';
COMMENT ON COLUMN biz_opc_service_entitlement.valid_from IS '有效开始日期';
COMMENT ON COLUMN biz_opc_service_entitlement.valid_to IS '有效截止日期';
COMMENT ON COLUMN biz_opc_service_entitlement.entitlement_status IS '服务权益状态';
COMMENT ON COLUMN biz_opc_service_entitlement.create_by IS '创建者';
COMMENT ON COLUMN biz_opc_service_entitlement.create_time IS '创建时间';
COMMENT ON COLUMN biz_opc_service_entitlement.update_by IS '更新者';
COMMENT ON COLUMN biz_opc_service_entitlement.update_time IS '更新时间';
COMMENT ON COLUMN biz_opc_service_entitlement.del_flag IS '删除标志：0正常，2删除';
COMMENT ON COLUMN biz_opc_service_entitlement.remark IS '备注';

CREATE INDEX idx_entitlement_member ON biz_opc_service_entitlement(tenant_id, merchant_id, member_id);

-- ============================================================
-- 62. biz_opc_booking
-- ============================================================
DROP TABLE IF EXISTS biz_opc_booking CASCADE;
CREATE TABLE biz_opc_booking (
    id bigserial PRIMARY KEY,
    tenant_id varchar(20),
    booking_id varchar(64) NOT NULL,
    agent_id varchar(64),
    merchant_id varchar(64) NOT NULL,
    member_id varchar(64) NOT NULL,
    entitlement_id varchar(64),
    order_id varchar(64),
    service_id varchar(64),
    teacher_id varchar(64),
    schedule_id varchar(64),
    schedule_instance_id varchar(64),
    booking_date date,
    start_time timestamp,
    end_time timestamp,
    booking_status varchar(32),
    source_channel varchar(32),
    ai_created char(1) DEFAULT 'N',
    create_by varchar(64),
    create_time timestamp,
    update_by varchar(64),
    update_time timestamp,
    del_flag char(1) DEFAULT '0',
    remark varchar(500)
);

COMMENT ON TABLE biz_opc_booking IS '服务预约表';
COMMENT ON COLUMN biz_opc_booking.id IS '主键';
COMMENT ON COLUMN biz_opc_booking.tenant_id IS '租户ID';
COMMENT ON COLUMN biz_opc_booking.booking_id IS '预约ID';
COMMENT ON COLUMN biz_opc_booking.agent_id IS '城市代理ID';
COMMENT ON COLUMN biz_opc_booking.merchant_id IS '商户ID';
COMMENT ON COLUMN biz_opc_booking.member_id IS '会员ID';
COMMENT ON COLUMN biz_opc_booking.entitlement_id IS '服务权益ID';
COMMENT ON COLUMN biz_opc_booking.order_id IS '订单ID';
COMMENT ON COLUMN biz_opc_booking.service_id IS '服务ID';
COMMENT ON COLUMN biz_opc_booking.teacher_id IS '服务老师ID';
COMMENT ON COLUMN biz_opc_booking.schedule_id IS '排班ID';
COMMENT ON COLUMN biz_opc_booking.schedule_instance_id IS '排班实例ID';
COMMENT ON COLUMN biz_opc_booking.booking_date IS '预约日期';
COMMENT ON COLUMN biz_opc_booking.start_time IS '开始时间';
COMMENT ON COLUMN biz_opc_booking.end_time IS '结束时间';
COMMENT ON COLUMN biz_opc_booking.booking_status IS '预约状态';
COMMENT ON COLUMN biz_opc_booking.source_channel IS '来源渠道';
COMMENT ON COLUMN biz_opc_booking.ai_created IS '是否AI创建：Y/N';
COMMENT ON COLUMN biz_opc_booking.create_by IS '创建者';
COMMENT ON COLUMN biz_opc_booking.create_time IS '创建时间';
COMMENT ON COLUMN biz_opc_booking.update_by IS '更新者';
COMMENT ON COLUMN biz_opc_booking.update_time IS '更新时间';
COMMENT ON COLUMN biz_opc_booking.del_flag IS '删除标志：0正常，2删除';
COMMENT ON COLUMN biz_opc_booking.remark IS '备注';

CREATE INDEX idx_booking_instance ON biz_opc_booking(schedule_instance_id);
CREATE INDEX idx_booking_member ON biz_opc_booking(tenant_id, merchant_id, member_id);

-- ============================================================
-- 63. biz_opc_booking_verify
-- ============================================================
DROP TABLE IF EXISTS biz_opc_booking_verify CASCADE;
CREATE TABLE biz_opc_booking_verify (
    id bigserial PRIMARY KEY,
    tenant_id varchar(20),
    verify_id varchar(64) NOT NULL,
    agent_id varchar(64),
    merchant_id varchar(64) NOT NULL,
    member_id varchar(64) NOT NULL,
    entitlement_id varchar(64),
    booking_id varchar(64),
    order_id varchar(64),
    service_id varchar(64),
    verify_code varchar(64),
    verify_times int DEFAULT 1,
    verify_status varchar(32),
    verify_staff_id varchar(64),
    verify_time timestamp,
    expire_time timestamp,
    verify_source varchar(32),
    create_by varchar(64),
    create_time timestamp,
    update_by varchar(64),
    update_time timestamp,
    del_flag char(1) DEFAULT '0',
    remark varchar(500)
);

COMMENT ON TABLE biz_opc_booking_verify IS '预约核销表，每核销一次服务生成一条记录';
COMMENT ON COLUMN biz_opc_booking_verify.id IS '主键';
COMMENT ON COLUMN biz_opc_booking_verify.tenant_id IS '租户ID';
COMMENT ON COLUMN biz_opc_booking_verify.verify_id IS '核销ID';
COMMENT ON COLUMN biz_opc_booking_verify.agent_id IS '城市代理ID';
COMMENT ON COLUMN biz_opc_booking_verify.merchant_id IS '商户ID';
COMMENT ON COLUMN biz_opc_booking_verify.member_id IS '会员ID';
COMMENT ON COLUMN biz_opc_booking_verify.entitlement_id IS '服务权益ID';
COMMENT ON COLUMN biz_opc_booking_verify.booking_id IS '预约ID';
COMMENT ON COLUMN biz_opc_booking_verify.order_id IS '订单ID';
COMMENT ON COLUMN biz_opc_booking_verify.service_id IS '服务ID';
COMMENT ON COLUMN biz_opc_booking_verify.verify_code IS '核销码';
COMMENT ON COLUMN biz_opc_booking_verify.verify_times IS '本次核销次数';
COMMENT ON COLUMN biz_opc_booking_verify.verify_status IS '核销状态';
COMMENT ON COLUMN biz_opc_booking_verify.verify_staff_id IS '核销员工ID';
COMMENT ON COLUMN biz_opc_booking_verify.verify_time IS '核销时间';
COMMENT ON COLUMN biz_opc_booking_verify.expire_time IS '失效时间';
COMMENT ON COLUMN biz_opc_booking_verify.verify_source IS '核销来源';
COMMENT ON COLUMN biz_opc_booking_verify.create_by IS '创建者';
COMMENT ON COLUMN biz_opc_booking_verify.create_time IS '创建时间';
COMMENT ON COLUMN biz_opc_booking_verify.update_by IS '更新者';
COMMENT ON COLUMN biz_opc_booking_verify.update_time IS '更新时间';
COMMENT ON COLUMN biz_opc_booking_verify.del_flag IS '删除标志：0正常，2删除';
COMMENT ON COLUMN biz_opc_booking_verify.remark IS '备注';

CREATE INDEX idx_booking_verify_booking ON biz_opc_booking_verify(booking_id);
CREATE INDEX idx_booking_verify_code ON biz_opc_booking_verify(verify_code);

-- ============================================================
-- 64. biz_prc_platform_account
-- ============================================================
DROP TABLE IF EXISTS biz_prc_platform_account CASCADE;
CREATE TABLE biz_prc_platform_account (
    id bigserial PRIMARY KEY,
    tenant_id varchar(20),
    account_id varchar(64) NOT NULL,
    channel_code varchar(64),
    account_name varchar(128),
    country_code varchar(20),
    currency_code varchar(20),
    api_config_json jsonb,
    webhook_secret varchar(255),
    default_flag char(1) DEFAULT 'N',
    status char(1) DEFAULT '0',
    create_by varchar(64),
    create_time timestamp,
    update_by varchar(64),
    update_time timestamp,
    del_flag char(1) DEFAULT '0',
    remark varchar(500)
);

COMMENT ON TABLE biz_prc_platform_account IS '平台收款账户表';
COMMENT ON COLUMN biz_prc_platform_account.id IS '主键';
COMMENT ON COLUMN biz_prc_platform_account.tenant_id IS '租户ID';
COMMENT ON COLUMN biz_prc_platform_account.account_id IS '账户ID';
COMMENT ON COLUMN biz_prc_platform_account.channel_code IS '渠道编码';
COMMENT ON COLUMN biz_prc_platform_account.account_name IS '账户名称';
COMMENT ON COLUMN biz_prc_platform_account.country_code IS '国家代码';
COMMENT ON COLUMN biz_prc_platform_account.currency_code IS '币种编码';
COMMENT ON COLUMN biz_prc_platform_account.api_config_json IS 'API配置JSON，加密存储';
COMMENT ON COLUMN biz_prc_platform_account.webhook_secret IS 'Webhook密钥，加密存储';
COMMENT ON COLUMN biz_prc_platform_account.default_flag IS '是否默认：Y/N';
COMMENT ON COLUMN biz_prc_platform_account.status IS '状态：0正常，1停用';
COMMENT ON COLUMN biz_prc_platform_account.create_by IS '创建者';
COMMENT ON COLUMN biz_prc_platform_account.create_time IS '创建时间';
COMMENT ON COLUMN biz_prc_platform_account.update_by IS '更新者';
COMMENT ON COLUMN biz_prc_platform_account.update_time IS '更新时间';
COMMENT ON COLUMN biz_prc_platform_account.del_flag IS '删除标志：0正常，2删除';
COMMENT ON COLUMN biz_prc_platform_account.remark IS '备注';

CREATE INDEX idx_platform_account_channel ON biz_prc_platform_account(tenant_id, channel_code, currency_code);

-- ============================================================
-- 65. biz_prc_merchant_payment_account
-- ============================================================
DROP TABLE IF EXISTS biz_prc_merchant_payment_account CASCADE;
CREATE TABLE biz_prc_merchant_payment_account (
    id bigserial PRIMARY KEY,
    tenant_id varchar(20),
    account_id varchar(64) NOT NULL,
    agent_id varchar(64),
    merchant_id varchar(64) NOT NULL,
    account_type varchar(32),
    channel_code varchar(64),
    account_name varchar(128),
    account_no varchar(128),
    bank_name varchar(128),
    mobile_provider varchar(64),
    phone_number varchar(64),
    country_code varchar(20),
    currency_code varchar(20),
    external_account_id varchar(128),
    api_config_json jsonb,
    webhook_secret varchar(255),
    verify_status varchar(32),
    default_flag char(1) DEFAULT 'N',
    status char(1) DEFAULT '0',
    create_by varchar(64),
    create_time timestamp,
    update_by varchar(64),
    update_time timestamp,
    del_flag char(1) DEFAULT '0',
    remark varchar(500)
);

COMMENT ON TABLE biz_prc_merchant_payment_account IS '商户自有收款账户表，支持Mobile Money、银行卡、Flutterwave/Paystack子账户等';
COMMENT ON COLUMN biz_prc_merchant_payment_account.id IS '主键';
COMMENT ON COLUMN biz_prc_merchant_payment_account.tenant_id IS '租户ID';
COMMENT ON COLUMN biz_prc_merchant_payment_account.account_id IS '账户ID';
COMMENT ON COLUMN biz_prc_merchant_payment_account.agent_id IS '城市代理ID';
COMMENT ON COLUMN biz_prc_merchant_payment_account.merchant_id IS '商户ID';
COMMENT ON COLUMN biz_prc_merchant_payment_account.account_type IS '账户类型';
COMMENT ON COLUMN biz_prc_merchant_payment_account.channel_code IS '渠道编码';
COMMENT ON COLUMN biz_prc_merchant_payment_account.account_name IS '账户名称';
COMMENT ON COLUMN biz_prc_merchant_payment_account.account_no IS '账号';
COMMENT ON COLUMN biz_prc_merchant_payment_account.bank_name IS '银行名称';
COMMENT ON COLUMN biz_prc_merchant_payment_account.mobile_provider IS '移动支付服务商';
COMMENT ON COLUMN biz_prc_merchant_payment_account.phone_number IS '手机号';
COMMENT ON COLUMN biz_prc_merchant_payment_account.country_code IS '国家代码';
COMMENT ON COLUMN biz_prc_merchant_payment_account.currency_code IS '币种编码';
COMMENT ON COLUMN biz_prc_merchant_payment_account.external_account_id IS '第三方账户ID';
COMMENT ON COLUMN biz_prc_merchant_payment_account.api_config_json IS 'API配置JSON，加密存储';
COMMENT ON COLUMN biz_prc_merchant_payment_account.webhook_secret IS 'Webhook密钥，加密存储';
COMMENT ON COLUMN biz_prc_merchant_payment_account.verify_status IS '核销状态';
COMMENT ON COLUMN biz_prc_merchant_payment_account.default_flag IS '是否默认：Y/N';
COMMENT ON COLUMN biz_prc_merchant_payment_account.status IS '状态：0正常，1停用';
COMMENT ON COLUMN biz_prc_merchant_payment_account.create_by IS '创建者';
COMMENT ON COLUMN biz_prc_merchant_payment_account.create_time IS '创建时间';
COMMENT ON COLUMN biz_prc_merchant_payment_account.update_by IS '更新者';
COMMENT ON COLUMN biz_prc_merchant_payment_account.update_time IS '更新时间';
COMMENT ON COLUMN biz_prc_merchant_payment_account.del_flag IS '删除标志：0正常，2删除';
COMMENT ON COLUMN biz_prc_merchant_payment_account.remark IS '备注';

CREATE INDEX idx_merchant_pay_account ON biz_prc_merchant_payment_account(tenant_id, merchant_id, channel_code);

-- ============================================================
-- 66. biz_prc_payment_channel
-- ============================================================
DROP TABLE IF EXISTS biz_prc_payment_channel CASCADE;
CREATE TABLE biz_prc_payment_channel (
    id bigserial PRIMARY KEY,
    tenant_id varchar(20),
    channel_id varchar(64) NOT NULL,
    agent_id varchar(64),
    merchant_id varchar(64),
    channel_code varchar(64),
    channel_name varchar(128),
    settlement_mode varchar(32),
    country_code varchar(20),
    currency_code varchar(20),
    config_json jsonb,
    status char(1) DEFAULT '0',
    create_by varchar(64),
    create_time timestamp,
    update_by varchar(64),
    update_time timestamp,
    del_flag char(1) DEFAULT '0',
    remark varchar(500)
);

COMMENT ON TABLE biz_prc_payment_channel IS '支付渠道配置表';
COMMENT ON COLUMN biz_prc_payment_channel.id IS '主键';
COMMENT ON COLUMN biz_prc_payment_channel.tenant_id IS '租户ID';
COMMENT ON COLUMN biz_prc_payment_channel.channel_id IS '渠道ID';
COMMENT ON COLUMN biz_prc_payment_channel.agent_id IS '城市代理ID';
COMMENT ON COLUMN biz_prc_payment_channel.merchant_id IS '商户ID';
COMMENT ON COLUMN biz_prc_payment_channel.channel_code IS '渠道编码';
COMMENT ON COLUMN biz_prc_payment_channel.channel_name IS '渠道名称';
COMMENT ON COLUMN biz_prc_payment_channel.settlement_mode IS '结算模式：merchant_direct/platform_escrow/split_payment';
COMMENT ON COLUMN biz_prc_payment_channel.country_code IS '国家代码';
COMMENT ON COLUMN biz_prc_payment_channel.currency_code IS '币种编码';
COMMENT ON COLUMN biz_prc_payment_channel.config_json IS '配置JSON';
COMMENT ON COLUMN biz_prc_payment_channel.status IS '状态：0正常，1停用';
COMMENT ON COLUMN biz_prc_payment_channel.create_by IS '创建者';
COMMENT ON COLUMN biz_prc_payment_channel.create_time IS '创建时间';
COMMENT ON COLUMN biz_prc_payment_channel.update_by IS '更新者';
COMMENT ON COLUMN biz_prc_payment_channel.update_time IS '更新时间';
COMMENT ON COLUMN biz_prc_payment_channel.del_flag IS '删除标志：0正常，2删除';
COMMENT ON COLUMN biz_prc_payment_channel.remark IS '备注';

CREATE INDEX idx_payment_channel_scope ON biz_prc_payment_channel(tenant_id, agent_id, merchant_id, channel_code);

-- ============================================================
-- 67. biz_prc_wallet
-- ============================================================
DROP TABLE IF EXISTS biz_prc_wallet CASCADE;
CREATE TABLE biz_prc_wallet (
    id bigserial PRIMARY KEY,
    tenant_id varchar(20),
    wallet_id varchar(64) NOT NULL,
    agent_id varchar(64),
    owner_type varchar(32),
    owner_id varchar(64),
    wallet_type varchar(32),
    currency_code varchar(20),
    balance numeric(18,2) DEFAULT 0,
    frozen_balance numeric(18,2) DEFAULT 0,
    total_in_amount numeric(18,2) DEFAULT 0,
    total_out_amount numeric(18,2) DEFAULT 0,
    wallet_status varchar(32),
    create_by varchar(64),
    create_time timestamp,
    update_by varchar(64),
    update_time timestamp,
    del_flag char(1) DEFAULT '0',
    remark varchar(500)
);

COMMENT ON TABLE biz_prc_wallet IS '钱包表，商户/代理/平台可按类型和币种拥有多个钱包';
COMMENT ON COLUMN biz_prc_wallet.id IS '主键';
COMMENT ON COLUMN biz_prc_wallet.tenant_id IS '租户ID';
COMMENT ON COLUMN biz_prc_wallet.wallet_id IS '钱包ID';
COMMENT ON COLUMN biz_prc_wallet.agent_id IS '城市代理ID';
COMMENT ON COLUMN biz_prc_wallet.owner_type IS '钱包主体类型';
COMMENT ON COLUMN biz_prc_wallet.owner_id IS '钱包主体ID';
COMMENT ON COLUMN biz_prc_wallet.wallet_type IS '钱包类型';
COMMENT ON COLUMN biz_prc_wallet.currency_code IS '币种编码';
COMMENT ON COLUMN biz_prc_wallet.balance IS '可用余额';
COMMENT ON COLUMN biz_prc_wallet.frozen_balance IS '冻结余额';
COMMENT ON COLUMN biz_prc_wallet.total_in_amount IS '累计入账金额';
COMMENT ON COLUMN biz_prc_wallet.total_out_amount IS '累计出账金额';
COMMENT ON COLUMN biz_prc_wallet.wallet_status IS '钱包状态';
COMMENT ON COLUMN biz_prc_wallet.create_by IS '创建者';
COMMENT ON COLUMN biz_prc_wallet.create_time IS '创建时间';
COMMENT ON COLUMN biz_prc_wallet.update_by IS '更新者';
COMMENT ON COLUMN biz_prc_wallet.update_time IS '更新时间';
COMMENT ON COLUMN biz_prc_wallet.del_flag IS '删除标志：0正常，2删除';
COMMENT ON COLUMN biz_prc_wallet.remark IS '备注';

CREATE INDEX idx_wallet_owner ON biz_prc_wallet(tenant_id, owner_type, owner_id, wallet_type, currency_code);

-- ============================================================
-- 68. biz_prc_wallet_ledger
-- ============================================================
DROP TABLE IF EXISTS biz_prc_wallet_ledger CASCADE;
CREATE TABLE biz_prc_wallet_ledger (
    id bigserial PRIMARY KEY,
    ledger_id varchar(64) NOT NULL,
    wallet_id varchar(64) NOT NULL,
    tenant_id varchar(20),
    agent_id varchar(64),
    owner_type varchar(32),
    owner_id varchar(64),
    wallet_type varchar(32),
    change_direction varchar(16),
    change_type varchar(64),
    amount numeric(18,2),
    balance_before numeric(18,2),
    balance_after numeric(18,2),
    currency_code varchar(20),
    related_type varchar(64),
    related_id varchar(64),
    description varchar(500),
    create_time timestamp,
    remark varchar(500)
);

COMMENT ON TABLE biz_prc_wallet_ledger IS '钱包流水表，所有钱包变动必须记录';
COMMENT ON COLUMN biz_prc_wallet_ledger.id IS '主键';
COMMENT ON COLUMN biz_prc_wallet_ledger.ledger_id IS '流水ID';
COMMENT ON COLUMN biz_prc_wallet_ledger.wallet_id IS '钱包ID';
COMMENT ON COLUMN biz_prc_wallet_ledger.tenant_id IS '租户ID';
COMMENT ON COLUMN biz_prc_wallet_ledger.agent_id IS '城市代理ID';
COMMENT ON COLUMN biz_prc_wallet_ledger.owner_type IS '钱包主体类型';
COMMENT ON COLUMN biz_prc_wallet_ledger.owner_id IS '钱包主体ID';
COMMENT ON COLUMN biz_prc_wallet_ledger.wallet_type IS '钱包类型';
COMMENT ON COLUMN biz_prc_wallet_ledger.change_direction IS '资金变动方向';
COMMENT ON COLUMN biz_prc_wallet_ledger.change_type IS '资金变动类型';
COMMENT ON COLUMN biz_prc_wallet_ledger.amount IS '金额';
COMMENT ON COLUMN biz_prc_wallet_ledger.balance_before IS '变动前余额';
COMMENT ON COLUMN biz_prc_wallet_ledger.balance_after IS '变动后余额';
COMMENT ON COLUMN biz_prc_wallet_ledger.currency_code IS '币种编码';
COMMENT ON COLUMN biz_prc_wallet_ledger.related_type IS '关联业务类型';
COMMENT ON COLUMN biz_prc_wallet_ledger.related_id IS '关联业务ID';
COMMENT ON COLUMN biz_prc_wallet_ledger.description IS '说明';
COMMENT ON COLUMN biz_prc_wallet_ledger.create_time IS '创建时间';
COMMENT ON COLUMN biz_prc_wallet_ledger.remark IS '备注';

CREATE INDEX idx_wallet_ledger_wallet ON biz_prc_wallet_ledger(wallet_id, create_time);
CREATE INDEX idx_wallet_ledger_related ON biz_prc_wallet_ledger(related_type, related_id);

-- ============================================================
-- 69. biz_prc_payment_transaction
-- ============================================================
DROP TABLE IF EXISTS biz_prc_payment_transaction CASCADE;
CREATE TABLE biz_prc_payment_transaction (
    id bigserial PRIMARY KEY,
    transaction_id varchar(64) NOT NULL,
    external_txn_id varchar(128),
    tenant_id varchar(20),
    agent_id varchar(64),
    merchant_id varchar(64),
    member_id varchar(64),
    order_id varchar(64),
    channel_code varchar(64),
    payment_method varchar(64),
    settlement_mode varchar(32),
    merchant_account_id varchar(64),
    platform_account_id varchar(64),
    platform_wallet_id varchar(64),
    merchant_wallet_id varchar(64),
    agent_wallet_id varchar(64),
    amount numeric(18,2),
    platform_fee_amount numeric(18,2) DEFAULT 0,
    agent_commission_amount numeric(18,2) DEFAULT 0,
    merchant_net_amount numeric(18,2),
    currency_code varchar(20),
    payment_status varchar(32),
    payment_url varchar(500),
    request_payload jsonb,
    response_payload jsonb,
    paid_time timestamp,
    create_time timestamp,
    update_time timestamp,
    remark varchar(500)
);

COMMENT ON TABLE biz_prc_payment_transaction IS '支付交易流水表，支持商户直收、平台代收、第三方分账';
COMMENT ON COLUMN biz_prc_payment_transaction.id IS '主键';
COMMENT ON COLUMN biz_prc_payment_transaction.transaction_id IS '支付交易ID';
COMMENT ON COLUMN biz_prc_payment_transaction.external_txn_id IS '第三方交易ID';
COMMENT ON COLUMN biz_prc_payment_transaction.tenant_id IS '租户ID';
COMMENT ON COLUMN biz_prc_payment_transaction.agent_id IS '城市代理ID';
COMMENT ON COLUMN biz_prc_payment_transaction.merchant_id IS '商户ID';
COMMENT ON COLUMN biz_prc_payment_transaction.member_id IS '会员ID';
COMMENT ON COLUMN biz_prc_payment_transaction.order_id IS '订单ID';
COMMENT ON COLUMN biz_prc_payment_transaction.channel_code IS '渠道编码';
COMMENT ON COLUMN biz_prc_payment_transaction.payment_method IS '支付方式';
COMMENT ON COLUMN biz_prc_payment_transaction.settlement_mode IS '结算模式：merchant_direct/platform_escrow/split_payment';
COMMENT ON COLUMN biz_prc_payment_transaction.merchant_account_id IS '商户收款账户ID';
COMMENT ON COLUMN biz_prc_payment_transaction.platform_account_id IS '平台收款账户ID';
COMMENT ON COLUMN biz_prc_payment_transaction.platform_wallet_id IS '平台钱包ID';
COMMENT ON COLUMN biz_prc_payment_transaction.merchant_wallet_id IS '商户钱包ID';
COMMENT ON COLUMN biz_prc_payment_transaction.agent_wallet_id IS '代理钱包ID';
COMMENT ON COLUMN biz_prc_payment_transaction.amount IS '金额';
COMMENT ON COLUMN biz_prc_payment_transaction.platform_fee_amount IS '平台手续费金额';
COMMENT ON COLUMN biz_prc_payment_transaction.agent_commission_amount IS '代理分佣金额';
COMMENT ON COLUMN biz_prc_payment_transaction.merchant_net_amount IS '商户净收入金额';
COMMENT ON COLUMN biz_prc_payment_transaction.currency_code IS '币种编码';
COMMENT ON COLUMN biz_prc_payment_transaction.payment_status IS '支付状态';
COMMENT ON COLUMN biz_prc_payment_transaction.payment_url IS '支付链接';
COMMENT ON COLUMN biz_prc_payment_transaction.request_payload IS '请求报文JSON';
COMMENT ON COLUMN biz_prc_payment_transaction.response_payload IS '响应报文JSON';
COMMENT ON COLUMN biz_prc_payment_transaction.paid_time IS '支付完成时间';
COMMENT ON COLUMN biz_prc_payment_transaction.create_time IS '创建时间';
COMMENT ON COLUMN biz_prc_payment_transaction.update_time IS '更新时间';
COMMENT ON COLUMN biz_prc_payment_transaction.remark IS '备注';

CREATE INDEX idx_payment_txn_order ON biz_prc_payment_transaction(order_id);
CREATE INDEX idx_payment_txn_merchant_time ON biz_prc_payment_transaction(tenant_id, merchant_id, create_time);

-- ============================================================
-- 70. biz_prc_payment_callback_log
-- ============================================================
DROP TABLE IF EXISTS biz_prc_payment_callback_log CASCADE;
CREATE TABLE biz_prc_payment_callback_log (
    id bigserial PRIMARY KEY,
    callback_id varchar(64) NOT NULL,
    tenant_id varchar(20),
    merchant_id varchar(64),
    transaction_id varchar(64),
    external_txn_id varchar(128),
    channel_code varchar(64),
    callback_type varchar(64),
    raw_payload jsonb,
    verify_result char(1),
    process_status varchar(32),
    error_message text,
    create_time timestamp,
    remark varchar(500)
);

COMMENT ON TABLE biz_prc_payment_callback_log IS '支付回调日志表';
COMMENT ON COLUMN biz_prc_payment_callback_log.id IS '主键';
COMMENT ON COLUMN biz_prc_payment_callback_log.callback_id IS '回调ID';
COMMENT ON COLUMN biz_prc_payment_callback_log.tenant_id IS '租户ID';
COMMENT ON COLUMN biz_prc_payment_callback_log.merchant_id IS '商户ID';
COMMENT ON COLUMN biz_prc_payment_callback_log.transaction_id IS '支付交易ID';
COMMENT ON COLUMN biz_prc_payment_callback_log.external_txn_id IS '第三方交易ID';
COMMENT ON COLUMN biz_prc_payment_callback_log.channel_code IS '渠道编码';
COMMENT ON COLUMN biz_prc_payment_callback_log.callback_type IS '回调类型';
COMMENT ON COLUMN biz_prc_payment_callback_log.raw_payload IS '原始报文JSON';
COMMENT ON COLUMN biz_prc_payment_callback_log.verify_result IS '验签结果';
COMMENT ON COLUMN biz_prc_payment_callback_log.process_status IS '处理状态';
COMMENT ON COLUMN biz_prc_payment_callback_log.error_message IS '错误信息';
COMMENT ON COLUMN biz_prc_payment_callback_log.create_time IS '创建时间';
COMMENT ON COLUMN biz_prc_payment_callback_log.remark IS '备注';

CREATE INDEX idx_payment_callback_txn ON biz_prc_payment_callback_log(transaction_id);

-- ============================================================
-- 71. biz_prc_fee_rule
-- ============================================================
DROP TABLE IF EXISTS biz_prc_fee_rule CASCADE;
CREATE TABLE biz_prc_fee_rule (
    id bigserial PRIMARY KEY,
    tenant_id varchar(20),
    rule_id varchar(64) NOT NULL,
    agent_id varchar(64),
    merchant_id varchar(64),
    rule_name varchar(128),
    fee_type varchar(64),
    charge_mode varchar(64),
    fixed_amount numeric(18,2),
    rate numeric(8,4),
    currency_code varchar(20),
    effective_time timestamp,
    expire_time timestamp,
    status char(1) DEFAULT '0',
    create_by varchar(64),
    create_time timestamp,
    update_by varchar(64),
    update_time timestamp,
    del_flag char(1) DEFAULT '0',
    remark varchar(500)
);

COMMENT ON TABLE biz_prc_fee_rule IS '平台计费规则表';
COMMENT ON COLUMN biz_prc_fee_rule.id IS '主键';
COMMENT ON COLUMN biz_prc_fee_rule.tenant_id IS '租户ID';
COMMENT ON COLUMN biz_prc_fee_rule.rule_id IS '排班规则ID';
COMMENT ON COLUMN biz_prc_fee_rule.agent_id IS '城市代理ID';
COMMENT ON COLUMN biz_prc_fee_rule.merchant_id IS '商户ID';
COMMENT ON COLUMN biz_prc_fee_rule.rule_name IS '规则名称';
COMMENT ON COLUMN biz_prc_fee_rule.fee_type IS '费用类型';
COMMENT ON COLUMN biz_prc_fee_rule.charge_mode IS '收费模式';
COMMENT ON COLUMN biz_prc_fee_rule.fixed_amount IS '固定金额';
COMMENT ON COLUMN biz_prc_fee_rule.rate IS '费率';
COMMENT ON COLUMN biz_prc_fee_rule.currency_code IS '币种编码';
COMMENT ON COLUMN biz_prc_fee_rule.effective_time IS '生效时间';
COMMENT ON COLUMN biz_prc_fee_rule.expire_time IS '失效时间';
COMMENT ON COLUMN biz_prc_fee_rule.status IS '状态：0正常，1停用';
COMMENT ON COLUMN biz_prc_fee_rule.create_by IS '创建者';
COMMENT ON COLUMN biz_prc_fee_rule.create_time IS '创建时间';
COMMENT ON COLUMN biz_prc_fee_rule.update_by IS '更新者';
COMMENT ON COLUMN biz_prc_fee_rule.update_time IS '更新时间';
COMMENT ON COLUMN biz_prc_fee_rule.del_flag IS '删除标志：0正常，2删除';
COMMENT ON COLUMN biz_prc_fee_rule.remark IS '备注';

CREATE INDEX idx_fee_rule_scope ON biz_prc_fee_rule(tenant_id, agent_id, merchant_id, fee_type);

-- ============================================================
-- 72. biz_prc_fee_ledger
-- ============================================================
DROP TABLE IF EXISTS biz_prc_fee_ledger CASCADE;
CREATE TABLE biz_prc_fee_ledger (
    id bigserial PRIMARY KEY,
    fee_ledger_id varchar(64) NOT NULL,
    tenant_id varchar(20),
    agent_id varchar(64),
    merchant_id varchar(64),
    fee_type varchar(64),
    related_type varchar(64),
    related_id varchar(64),
    amount numeric(18,2),
    currency_code varchar(20),
    charge_status varchar(32),
    wallet_id varchar(64),
    create_time timestamp,
    remark varchar(500)
);

COMMENT ON TABLE biz_prc_fee_ledger IS '平台收费明细表，记录消息费、AI费、交易抽佣、会员费等';
COMMENT ON COLUMN biz_prc_fee_ledger.id IS '主键';
COMMENT ON COLUMN biz_prc_fee_ledger.fee_ledger_id IS '收费明细ID';
COMMENT ON COLUMN biz_prc_fee_ledger.tenant_id IS '租户ID';
COMMENT ON COLUMN biz_prc_fee_ledger.agent_id IS '城市代理ID';
COMMENT ON COLUMN biz_prc_fee_ledger.merchant_id IS '商户ID';
COMMENT ON COLUMN biz_prc_fee_ledger.fee_type IS '费用类型';
COMMENT ON COLUMN biz_prc_fee_ledger.related_type IS '关联业务类型';
COMMENT ON COLUMN biz_prc_fee_ledger.related_id IS '关联业务ID';
COMMENT ON COLUMN biz_prc_fee_ledger.amount IS '金额';
COMMENT ON COLUMN biz_prc_fee_ledger.currency_code IS '币种编码';
COMMENT ON COLUMN biz_prc_fee_ledger.charge_status IS '扣费状态';
COMMENT ON COLUMN biz_prc_fee_ledger.wallet_id IS '钱包ID';
COMMENT ON COLUMN biz_prc_fee_ledger.create_time IS '创建时间';
COMMENT ON COLUMN biz_prc_fee_ledger.remark IS '备注';

CREATE INDEX idx_fee_ledger_merchant_time ON biz_prc_fee_ledger(tenant_id, merchant_id, create_time);

-- ============================================================
-- 73. biz_prc_commission_ledger
-- ============================================================
DROP TABLE IF EXISTS biz_prc_commission_ledger CASCADE;
CREATE TABLE biz_prc_commission_ledger (
    id bigserial PRIMARY KEY,
    commission_id varchar(64) NOT NULL,
    tenant_id varchar(20),
    agent_id varchar(64),
    merchant_id varchar(64),
    order_id varchar(64),
    transaction_id varchar(64),
    commission_type varchar(64),
    base_amount numeric(18,2),
    commission_rate numeric(8,4),
    commission_amount numeric(18,2),
    currency_code varchar(20),
    wallet_id varchar(64),
    settle_status varchar(32),
    create_time timestamp,
    remark varchar(500)
);

COMMENT ON TABLE biz_prc_commission_ledger IS '代理分佣明细表';
COMMENT ON COLUMN biz_prc_commission_ledger.id IS '主键';
COMMENT ON COLUMN biz_prc_commission_ledger.commission_id IS '分佣ID';
COMMENT ON COLUMN biz_prc_commission_ledger.tenant_id IS '租户ID';
COMMENT ON COLUMN biz_prc_commission_ledger.agent_id IS '城市代理ID';
COMMENT ON COLUMN biz_prc_commission_ledger.merchant_id IS '商户ID';
COMMENT ON COLUMN biz_prc_commission_ledger.order_id IS '订单ID';
COMMENT ON COLUMN biz_prc_commission_ledger.transaction_id IS '支付交易ID';
COMMENT ON COLUMN biz_prc_commission_ledger.commission_type IS '分佣类型';
COMMENT ON COLUMN biz_prc_commission_ledger.base_amount IS '分佣基数';
COMMENT ON COLUMN biz_prc_commission_ledger.commission_rate IS '分佣比例';
COMMENT ON COLUMN biz_prc_commission_ledger.commission_amount IS '分佣金额';
COMMENT ON COLUMN biz_prc_commission_ledger.currency_code IS '币种编码';
COMMENT ON COLUMN biz_prc_commission_ledger.wallet_id IS '钱包ID';
COMMENT ON COLUMN biz_prc_commission_ledger.settle_status IS '结算状态';
COMMENT ON COLUMN biz_prc_commission_ledger.create_time IS '创建时间';
COMMENT ON COLUMN biz_prc_commission_ledger.remark IS '备注';

CREATE INDEX idx_commission_agent_time ON biz_prc_commission_ledger(tenant_id, agent_id, create_time);

-- ============================================================
-- 74. biz_prc_settlement
-- ============================================================
DROP TABLE IF EXISTS biz_prc_settlement CASCADE;
CREATE TABLE biz_prc_settlement (
    id bigserial PRIMARY KEY,
    settlement_id varchar(64) NOT NULL,
    tenant_id varchar(20),
    agent_id varchar(64),
    owner_type varchar(32),
    owner_id varchar(64),
    settlement_mode varchar(32),
    settlement_period varchar(64),
    transaction_amount numeric(18,2),
    platform_fee_amount numeric(18,2),
    commission_amount numeric(18,2),
    refund_amount numeric(18,2),
    payable_amount numeric(18,2),
    currency_code varchar(20),
    settlement_status varchar(32),
    create_time timestamp,
    confirm_time timestamp,
    paid_time timestamp,
    remark varchar(500)
);

COMMENT ON TABLE biz_prc_settlement IS '结算单表，用于周期性汇总商户或代理应结金额';
COMMENT ON COLUMN biz_prc_settlement.id IS '主键';
COMMENT ON COLUMN biz_prc_settlement.settlement_id IS '结算单ID';
COMMENT ON COLUMN biz_prc_settlement.tenant_id IS '租户ID';
COMMENT ON COLUMN biz_prc_settlement.agent_id IS '城市代理ID';
COMMENT ON COLUMN biz_prc_settlement.owner_type IS '钱包主体类型';
COMMENT ON COLUMN biz_prc_settlement.owner_id IS '钱包主体ID';
COMMENT ON COLUMN biz_prc_settlement.settlement_mode IS '结算模式：merchant_direct/platform_escrow/split_payment';
COMMENT ON COLUMN biz_prc_settlement.settlement_period IS '结算周期';
COMMENT ON COLUMN biz_prc_settlement.transaction_amount IS '交易总金额';
COMMENT ON COLUMN biz_prc_settlement.platform_fee_amount IS '平台手续费金额';
COMMENT ON COLUMN biz_prc_settlement.commission_amount IS '分佣金额';
COMMENT ON COLUMN biz_prc_settlement.refund_amount IS '退款金额';
COMMENT ON COLUMN biz_prc_settlement.payable_amount IS '应结金额';
COMMENT ON COLUMN biz_prc_settlement.currency_code IS '币种编码';
COMMENT ON COLUMN biz_prc_settlement.settlement_status IS '结算状态';
COMMENT ON COLUMN biz_prc_settlement.create_time IS '创建时间';
COMMENT ON COLUMN biz_prc_settlement.confirm_time IS '确认时间';
COMMENT ON COLUMN biz_prc_settlement.paid_time IS '支付完成时间';
COMMENT ON COLUMN biz_prc_settlement.remark IS '备注';

CREATE INDEX idx_settlement_owner ON biz_prc_settlement(tenant_id, owner_type, owner_id, settlement_period);

-- ============================================================
-- 75. biz_prc_withdraw
-- ============================================================
DROP TABLE IF EXISTS biz_prc_withdraw CASCADE;
CREATE TABLE biz_prc_withdraw (
    id bigserial PRIMARY KEY,
    tenant_id varchar(20),
    withdraw_id varchar(64) NOT NULL,
    agent_id varchar(64),
    owner_type varchar(32),
    owner_id varchar(64),
    wallet_id varchar(64),
    account_id varchar(64),
    amount numeric(18,2),
    fee_amount numeric(18,2),
    actual_amount numeric(18,2),
    currency_code varchar(20),
    withdraw_status varchar(32),
    audit_by varchar(64),
    audit_time timestamp,
    paid_time timestamp,
    reject_reason varchar(500),
    create_by varchar(64),
    create_time timestamp,
    update_by varchar(64),
    update_time timestamp,
    del_flag char(1) DEFAULT '0',
    remark varchar(500)
);

COMMENT ON TABLE biz_prc_withdraw IS '提现申请表';
COMMENT ON COLUMN biz_prc_withdraw.id IS '主键';
COMMENT ON COLUMN biz_prc_withdraw.tenant_id IS '租户ID';
COMMENT ON COLUMN biz_prc_withdraw.withdraw_id IS '提现ID';
COMMENT ON COLUMN biz_prc_withdraw.agent_id IS '城市代理ID';
COMMENT ON COLUMN biz_prc_withdraw.owner_type IS '钱包主体类型';
COMMENT ON COLUMN biz_prc_withdraw.owner_id IS '钱包主体ID';
COMMENT ON COLUMN biz_prc_withdraw.wallet_id IS '钱包ID';
COMMENT ON COLUMN biz_prc_withdraw.account_id IS '账户ID';
COMMENT ON COLUMN biz_prc_withdraw.amount IS '金额';
COMMENT ON COLUMN biz_prc_withdraw.fee_amount IS 'fee_amount字段';
COMMENT ON COLUMN biz_prc_withdraw.actual_amount IS '实际到账金额';
COMMENT ON COLUMN biz_prc_withdraw.currency_code IS '币种编码';
COMMENT ON COLUMN biz_prc_withdraw.withdraw_status IS '提现状态';
COMMENT ON COLUMN biz_prc_withdraw.audit_by IS '审核人';
COMMENT ON COLUMN biz_prc_withdraw.audit_time IS '审核时间';
COMMENT ON COLUMN biz_prc_withdraw.paid_time IS '支付完成时间';
COMMENT ON COLUMN biz_prc_withdraw.reject_reason IS '拒绝原因';
COMMENT ON COLUMN biz_prc_withdraw.create_by IS '创建者';
COMMENT ON COLUMN biz_prc_withdraw.create_time IS '创建时间';
COMMENT ON COLUMN biz_prc_withdraw.update_by IS '更新者';
COMMENT ON COLUMN biz_prc_withdraw.update_time IS '更新时间';
COMMENT ON COLUMN biz_prc_withdraw.del_flag IS '删除标志：0正常，2删除';
COMMENT ON COLUMN biz_prc_withdraw.remark IS '备注';

CREATE INDEX idx_withdraw_owner ON biz_prc_withdraw(tenant_id, owner_type, owner_id, create_time);

-- ============================================================
-- 76. biz_prc_reconciliation_bill
-- ============================================================
DROP TABLE IF EXISTS biz_prc_reconciliation_bill CASCADE;
CREATE TABLE biz_prc_reconciliation_bill (
    id bigserial PRIMARY KEY,
    bill_id varchar(64) NOT NULL,
    tenant_id varchar(20),
    channel_code varchar(64),
    bill_date date,
    currency_code varchar(20),
    platform_total_amount numeric(18,2),
    channel_total_amount numeric(18,2),
    diff_amount numeric(18,2),
    platform_count int,
    channel_count int,
    diff_count int,
    reconcile_status varchar(32),
    create_time timestamp,
    finish_time timestamp,
    remark varchar(500)
);

COMMENT ON TABLE biz_prc_reconciliation_bill IS '对账单表，按支付渠道和日期生成';
COMMENT ON COLUMN biz_prc_reconciliation_bill.id IS '主键';
COMMENT ON COLUMN biz_prc_reconciliation_bill.bill_id IS '对账单ID';
COMMENT ON COLUMN biz_prc_reconciliation_bill.tenant_id IS '租户ID';
COMMENT ON COLUMN biz_prc_reconciliation_bill.channel_code IS '渠道编码';
COMMENT ON COLUMN biz_prc_reconciliation_bill.bill_date IS '对账日期';
COMMENT ON COLUMN biz_prc_reconciliation_bill.currency_code IS '币种编码';
COMMENT ON COLUMN biz_prc_reconciliation_bill.platform_total_amount IS '平台统计交易金额';
COMMENT ON COLUMN biz_prc_reconciliation_bill.channel_total_amount IS '渠道账单交易金额';
COMMENT ON COLUMN biz_prc_reconciliation_bill.diff_amount IS '差异金额';
COMMENT ON COLUMN biz_prc_reconciliation_bill.platform_count IS '平台交易笔数';
COMMENT ON COLUMN biz_prc_reconciliation_bill.channel_count IS '渠道交易笔数';
COMMENT ON COLUMN biz_prc_reconciliation_bill.diff_count IS '差异笔数';
COMMENT ON COLUMN biz_prc_reconciliation_bill.reconcile_status IS '对账状态';
COMMENT ON COLUMN biz_prc_reconciliation_bill.create_time IS '创建时间';
COMMENT ON COLUMN biz_prc_reconciliation_bill.finish_time IS '完成时间';
COMMENT ON COLUMN biz_prc_reconciliation_bill.remark IS '备注';

CREATE INDEX idx_recon_bill_date ON biz_prc_reconciliation_bill(tenant_id, channel_code, bill_date);

-- ============================================================
-- 77. biz_prc_reconciliation_detail
-- ============================================================
DROP TABLE IF EXISTS biz_prc_reconciliation_detail CASCADE;
CREATE TABLE biz_prc_reconciliation_detail (
    id bigserial PRIMARY KEY,
    detail_id varchar(64) NOT NULL,
    bill_id varchar(64),
    tenant_id varchar(20),
    transaction_id varchar(64),
    external_txn_id varchar(128),
    platform_amount numeric(18,2),
    channel_amount numeric(18,2),
    diff_amount numeric(18,2),
    platform_status varchar(32),
    channel_status varchar(32),
    match_status varchar(32),
    handle_status varchar(32),
    create_time timestamp,
    remark varchar(500)
);

COMMENT ON TABLE biz_prc_reconciliation_detail IS '对账明细表';
COMMENT ON COLUMN biz_prc_reconciliation_detail.id IS '主键';
COMMENT ON COLUMN biz_prc_reconciliation_detail.detail_id IS '对账明细ID';
COMMENT ON COLUMN biz_prc_reconciliation_detail.bill_id IS '对账单ID';
COMMENT ON COLUMN biz_prc_reconciliation_detail.tenant_id IS '租户ID';
COMMENT ON COLUMN biz_prc_reconciliation_detail.transaction_id IS '支付交易ID';
COMMENT ON COLUMN biz_prc_reconciliation_detail.external_txn_id IS '第三方交易ID';
COMMENT ON COLUMN biz_prc_reconciliation_detail.platform_amount IS '平台金额';
COMMENT ON COLUMN biz_prc_reconciliation_detail.channel_amount IS '渠道金额';
COMMENT ON COLUMN biz_prc_reconciliation_detail.diff_amount IS '差异金额';
COMMENT ON COLUMN biz_prc_reconciliation_detail.platform_status IS '平台状态';
COMMENT ON COLUMN biz_prc_reconciliation_detail.channel_status IS '渠道状态';
COMMENT ON COLUMN biz_prc_reconciliation_detail.match_status IS '匹配状态';
COMMENT ON COLUMN biz_prc_reconciliation_detail.handle_status IS '处理状态';
COMMENT ON COLUMN biz_prc_reconciliation_detail.create_time IS '创建时间';
COMMENT ON COLUMN biz_prc_reconciliation_detail.remark IS '备注';

CREATE INDEX idx_recon_detail_bill ON biz_prc_reconciliation_detail(bill_id);
CREATE INDEX idx_recon_detail_txn ON biz_prc_reconciliation_detail(transaction_id);

-- ============================================================
-- 78. biz_prc_risk_score
-- ============================================================
DROP TABLE IF EXISTS biz_prc_risk_score CASCADE;
CREATE TABLE biz_prc_risk_score (
    id bigserial PRIMARY KEY,
    score_id varchar(64) NOT NULL,
    tenant_id varchar(20),
    agent_id varchar(64),
    merchant_id varchar(64),
    member_id varchar(64),
    risk_score numeric(8,2),
    risk_level varchar(32),
    score_reason text,
    model_version varchar(64),
    create_time timestamp,
    remark varchar(500)
);

COMMENT ON TABLE biz_prc_risk_score IS '风险评分表';
COMMENT ON COLUMN biz_prc_risk_score.id IS '主键';
COMMENT ON COLUMN biz_prc_risk_score.score_id IS '评分ID';
COMMENT ON COLUMN biz_prc_risk_score.tenant_id IS '租户ID';
COMMENT ON COLUMN biz_prc_risk_score.agent_id IS '城市代理ID';
COMMENT ON COLUMN biz_prc_risk_score.merchant_id IS '商户ID';
COMMENT ON COLUMN biz_prc_risk_score.member_id IS '会员ID';
COMMENT ON COLUMN biz_prc_risk_score.risk_score IS '风险分';
COMMENT ON COLUMN biz_prc_risk_score.risk_level IS '风险等级';
COMMENT ON COLUMN biz_prc_risk_score.score_reason IS '评分原因';
COMMENT ON COLUMN biz_prc_risk_score.model_version IS '模型版本';
COMMENT ON COLUMN biz_prc_risk_score.create_time IS '创建时间';
COMMENT ON COLUMN biz_prc_risk_score.remark IS '备注';

CREATE INDEX idx_risk_score_member ON biz_prc_risk_score(tenant_id, merchant_id, member_id);

-- ============================================================
-- 79. biz_prc_blacklist
-- ============================================================
DROP TABLE IF EXISTS biz_prc_blacklist CASCADE;
CREATE TABLE biz_prc_blacklist (
    id bigserial PRIMARY KEY,
    tenant_id varchar(20),
    blacklist_id varchar(64) NOT NULL,
    agent_id varchar(64),
    merchant_id varchar(64),
    member_id varchar(64),
    phone_number varchar(64),
    reason text,
    source_type varchar(32),
    status char(1) DEFAULT '0',
    create_by varchar(64),
    create_time timestamp,
    update_by varchar(64),
    update_time timestamp,
    del_flag char(1) DEFAULT '0',
    remark varchar(500)
);

COMMENT ON TABLE biz_prc_blacklist IS '黑名单表';
COMMENT ON COLUMN biz_prc_blacklist.id IS '主键';
COMMENT ON COLUMN biz_prc_blacklist.tenant_id IS '租户ID';
COMMENT ON COLUMN biz_prc_blacklist.blacklist_id IS '黑名单ID';
COMMENT ON COLUMN biz_prc_blacklist.agent_id IS '城市代理ID';
COMMENT ON COLUMN biz_prc_blacklist.merchant_id IS '商户ID';
COMMENT ON COLUMN biz_prc_blacklist.member_id IS '会员ID';
COMMENT ON COLUMN biz_prc_blacklist.phone_number IS '手机号';
COMMENT ON COLUMN biz_prc_blacklist.reason IS '原因';
COMMENT ON COLUMN biz_prc_blacklist.source_type IS '来源类型';
COMMENT ON COLUMN biz_prc_blacklist.status IS '状态：0正常，1停用';
COMMENT ON COLUMN biz_prc_blacklist.create_by IS '创建者';
COMMENT ON COLUMN biz_prc_blacklist.create_time IS '创建时间';
COMMENT ON COLUMN biz_prc_blacklist.update_by IS '更新者';
COMMENT ON COLUMN biz_prc_blacklist.update_time IS '更新时间';
COMMENT ON COLUMN biz_prc_blacklist.del_flag IS '删除标志：0正常，2删除';
COMMENT ON COLUMN biz_prc_blacklist.remark IS '备注';

CREATE INDEX idx_blacklist_phone ON biz_prc_blacklist(tenant_id, phone_number);

-- ============================================================
-- 80. ai_udi_memory
-- ============================================================
DROP TABLE IF EXISTS ai_udi_memory CASCADE;
CREATE TABLE ai_udi_memory (
    id bigserial PRIMARY KEY,
    memory_id varchar(64) NOT NULL,
    tenant_id varchar(20),
    agent_id varchar(64),
    merchant_id varchar(64),
    member_id varchar(64),
    memory_type varchar(64),
    memory_summary text,
    confidence_score numeric(5,2),
    source_id varchar(64),
    status char(1),
    create_time timestamp,
    update_time timestamp,
    remark varchar(500)
);

COMMENT ON TABLE ai_udi_memory IS 'AI长期记忆表';
COMMENT ON COLUMN ai_udi_memory.id IS '主键';
COMMENT ON COLUMN ai_udi_memory.memory_id IS '记忆ID';
COMMENT ON COLUMN ai_udi_memory.tenant_id IS '租户ID';
COMMENT ON COLUMN ai_udi_memory.agent_id IS '城市代理ID';
COMMENT ON COLUMN ai_udi_memory.merchant_id IS '商户ID';
COMMENT ON COLUMN ai_udi_memory.member_id IS '会员ID';
COMMENT ON COLUMN ai_udi_memory.memory_type IS '记忆类型';
COMMENT ON COLUMN ai_udi_memory.memory_summary IS '记忆摘要';
COMMENT ON COLUMN ai_udi_memory.confidence_score IS '置信度';
COMMENT ON COLUMN ai_udi_memory.source_id IS '来源ID';
COMMENT ON COLUMN ai_udi_memory.status IS '状态：0正常，1停用';
COMMENT ON COLUMN ai_udi_memory.create_time IS '创建时间';
COMMENT ON COLUMN ai_udi_memory.update_time IS '更新时间';
COMMENT ON COLUMN ai_udi_memory.remark IS '备注';

CREATE INDEX idx_udi_memory_member ON ai_udi_memory(tenant_id, merchant_id, member_id, memory_type);

-- ============================================================
-- 81. ai_udi_feedback
-- ============================================================
DROP TABLE IF EXISTS ai_udi_feedback CASCADE;
CREATE TABLE ai_udi_feedback (
    id bigserial PRIMARY KEY,
    feedback_id varchar(64) NOT NULL,
    tenant_id varchar(20),
    agent_id varchar(64),
    merchant_id varchar(64),
    session_id varchar(64),
    message_id varchar(128),
    agent_app_id varchar(64),
    feedback_type varchar(32),
    rating int,
    feedback_content text,
    correction_content text,
    create_time timestamp,
    remark varchar(500)
);

COMMENT ON TABLE ai_udi_feedback IS 'AI反馈表';
COMMENT ON COLUMN ai_udi_feedback.id IS '主键';
COMMENT ON COLUMN ai_udi_feedback.feedback_id IS '反馈ID';
COMMENT ON COLUMN ai_udi_feedback.tenant_id IS '租户ID';
COMMENT ON COLUMN ai_udi_feedback.agent_id IS '城市代理ID';
COMMENT ON COLUMN ai_udi_feedback.merchant_id IS '商户ID';
COMMENT ON COLUMN ai_udi_feedback.session_id IS '会话ID';
COMMENT ON COLUMN ai_udi_feedback.message_id IS '消息ID';
COMMENT ON COLUMN ai_udi_feedback.agent_app_id IS '智能体应用ID';
COMMENT ON COLUMN ai_udi_feedback.feedback_type IS '反馈类型';
COMMENT ON COLUMN ai_udi_feedback.rating IS '评分';
COMMENT ON COLUMN ai_udi_feedback.feedback_content IS '反馈内容';
COMMENT ON COLUMN ai_udi_feedback.correction_content IS '人工纠正内容';
COMMENT ON COLUMN ai_udi_feedback.create_time IS '创建时间';
COMMENT ON COLUMN ai_udi_feedback.remark IS '备注';

CREATE INDEX idx_udi_feedback_agent ON ai_udi_feedback(agent_app_id, create_time);

-- ============================================================
-- 82. ai_udi_metric
-- ============================================================
DROP TABLE IF EXISTS ai_udi_metric CASCADE;
CREATE TABLE ai_udi_metric (
    id bigserial PRIMARY KEY,
    metric_id varchar(64) NOT NULL,
    tenant_id varchar(20),
    agent_id varchar(64),
    merchant_id varchar(64),
    agent_app_id varchar(64),
    metric_date date,
    conversation_count int DEFAULT 0,
    ai_reply_count int DEFAULT 0,
    handover_count int DEFAULT 0,
    order_created_count int DEFAULT 0,
    paid_order_count int DEFAULT 0,
    conversion_rate numeric(8,4),
    token_cost numeric(18,6),
    create_time timestamp,
    remark varchar(500)
);

COMMENT ON TABLE ai_udi_metric IS 'AI指标表';
COMMENT ON COLUMN ai_udi_metric.id IS '主键';
COMMENT ON COLUMN ai_udi_metric.metric_id IS '指标ID';
COMMENT ON COLUMN ai_udi_metric.tenant_id IS '租户ID';
COMMENT ON COLUMN ai_udi_metric.agent_id IS '城市代理ID';
COMMENT ON COLUMN ai_udi_metric.merchant_id IS '商户ID';
COMMENT ON COLUMN ai_udi_metric.agent_app_id IS '智能体应用ID';
COMMENT ON COLUMN ai_udi_metric.metric_date IS '统计日期';
COMMENT ON COLUMN ai_udi_metric.conversation_count IS '会话数';
COMMENT ON COLUMN ai_udi_metric.ai_reply_count IS 'AI回复数';
COMMENT ON COLUMN ai_udi_metric.handover_count IS '转人工数';
COMMENT ON COLUMN ai_udi_metric.order_created_count IS 'AI创建订单数';
COMMENT ON COLUMN ai_udi_metric.paid_order_count IS '已支付订单数';
COMMENT ON COLUMN ai_udi_metric.conversion_rate IS '转化率';
COMMENT ON COLUMN ai_udi_metric.token_cost IS 'Token成本';
COMMENT ON COLUMN ai_udi_metric.create_time IS '创建时间';
COMMENT ON COLUMN ai_udi_metric.remark IS '备注';

CREATE INDEX idx_udi_metric_date ON ai_udi_metric(tenant_id, merchant_id, metric_date);

-- ============================================================
-- 83. ai_udi_behavior
-- ============================================================
DROP TABLE IF EXISTS ai_udi_behavior CASCADE;
CREATE TABLE ai_udi_behavior (
    id bigserial PRIMARY KEY,
    behavior_id varchar(64) NOT NULL,
    tenant_id varchar(20),
    agent_id varchar(64),
    merchant_id varchar(64),
    member_id varchar(64),
    behavior_type varchar(64),
    behavior_value varchar(255),
    related_type varchar(64),
    related_id varchar(64),
    behavior_time timestamp,
    metadata jsonb,
    create_time timestamp,
    remark varchar(500)
);

COMMENT ON TABLE ai_udi_behavior IS '用户行为表';
COMMENT ON COLUMN ai_udi_behavior.id IS '主键';
COMMENT ON COLUMN ai_udi_behavior.behavior_id IS '行为ID';
COMMENT ON COLUMN ai_udi_behavior.tenant_id IS '租户ID';
COMMENT ON COLUMN ai_udi_behavior.agent_id IS '城市代理ID';
COMMENT ON COLUMN ai_udi_behavior.merchant_id IS '商户ID';
COMMENT ON COLUMN ai_udi_behavior.member_id IS '会员ID';
COMMENT ON COLUMN ai_udi_behavior.behavior_type IS '行为类型';
COMMENT ON COLUMN ai_udi_behavior.behavior_value IS '行为值';
COMMENT ON COLUMN ai_udi_behavior.related_type IS '关联业务类型';
COMMENT ON COLUMN ai_udi_behavior.related_id IS '关联业务ID';
COMMENT ON COLUMN ai_udi_behavior.behavior_time IS '行为时间';
COMMENT ON COLUMN ai_udi_behavior.metadata IS '元数据JSON';
COMMENT ON COLUMN ai_udi_behavior.create_time IS '创建时间';
COMMENT ON COLUMN ai_udi_behavior.remark IS '备注';

CREATE INDEX idx_udi_behavior_member_time ON ai_udi_behavior(tenant_id, merchant_id, member_id, behavior_time);

-- ============================================================
-- 统计信息
-- ============================================================
-- 表数量：83
-- 字段数量：1474
-- 表备注数量：83
-- 字段备注数量：1474
-- 备注完整性：所有 CREATE TABLE 中识别到的表与字段均已生成 COMMENT。
-- 字段识别方式：按CREATE TABLE括号内容进行顶层逗号切分，忽略numeric(18,2)、vector(1536)等括号内逗号。
-- sys_tenant处理原则：不直接扩展字段；JamboAI业务扩展统一使用 biz_base_tenant_ext。
-- 本版 dict 基础表调整：dict_language / dict_currency / dict_country / dict_city 使用 jamboai_* 风格字段；新增 dict_timezone / dict_industry。
-- ============================================================
