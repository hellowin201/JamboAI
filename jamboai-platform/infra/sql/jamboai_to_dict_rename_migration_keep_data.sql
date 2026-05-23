-- ============================================================
-- JamboAI 字典表无损改名迁移脚本
-- PostgreSQL 16
--
-- 目标：
-- 将已有数据的 jamboai_* 表无损改名为 dict_* 表。
-- 仅执行：
-- 1. 表名 RENAME
-- 2. 主键约束名 RENAME
-- 3. 外键约束名 RENAME
-- 4. 索引名 RENAME
-- 5. 补充/更新表备注、字段备注
--
-- 不执行：
-- 1. DROP TABLE
-- 2. CREATE TABLE
-- 3. DELETE
-- 4. TRUNCATE
--
-- 涉及表：
-- jamboai_language  -> dict_language
-- jamboai_currency  -> dict_currency
-- jamboai_country   -> dict_country
-- jamboai_city      -> dict_city
-- jamboai_timezone  -> dict_timezone
-- jamboai_industry  -> dict_industry
--
-- 注意：
-- 1. 执行前请先备份数据库。
-- 2. 如果 dict_* 目标表已经存在，本脚本会报错并中止，避免覆盖数据。
-- 3. 如果某些索引/约束不存在，DO 块会自动跳过。
-- ============================================================

BEGIN;

-- ============================================================
-- 0. 安全检查：目标 dict_* 表不能已存在
-- ============================================================

DO $$
BEGIN
    IF to_regclass('public.dict_language') IS NOT NULL THEN
        RAISE EXCEPTION '目标表 public.dict_language 已存在，请先确认是否已迁移，避免覆盖数据';
    END IF;

    IF to_regclass('public.dict_currency') IS NOT NULL THEN
        RAISE EXCEPTION '目标表 public.dict_currency 已存在，请先确认是否已迁移，避免覆盖数据';
    END IF;

    IF to_regclass('public.dict_country') IS NOT NULL THEN
        RAISE EXCEPTION '目标表 public.dict_country 已存在，请先确认是否已迁移，避免覆盖数据';
    END IF;

    IF to_regclass('public.dict_city') IS NOT NULL THEN
        RAISE EXCEPTION '目标表 public.dict_city 已存在，请先确认是否已迁移，避免覆盖数据';
    END IF;

    IF to_regclass('public.dict_timezone') IS NOT NULL THEN
        RAISE EXCEPTION '目标表 public.dict_timezone 已存在，请先确认是否已迁移，避免覆盖数据';
    END IF;

    IF to_regclass('public.dict_industry') IS NOT NULL THEN
        RAISE EXCEPTION '目标表 public.dict_industry 已存在，请先确认是否已迁移，避免覆盖数据';
    END IF;
END $$;

-- ============================================================
-- 1. 表名改名
-- ============================================================

ALTER TABLE public.jamboai_language RENAME TO dict_language;
ALTER TABLE public.jamboai_currency RENAME TO dict_currency;
ALTER TABLE public.jamboai_country RENAME TO dict_country;
ALTER TABLE public.jamboai_city RENAME TO dict_city;
ALTER TABLE public.jamboai_timezone RENAME TO dict_timezone;
ALTER TABLE public.jamboai_industry RENAME TO dict_industry;

-- ============================================================
-- 2. 主键约束改名
-- ============================================================

DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'jamboai_language_pkey') THEN
        ALTER TABLE public.dict_language RENAME CONSTRAINT jamboai_language_pkey TO dict_language_pkey;
    END IF;

    IF EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'jamboai_currency_pkey') THEN
        ALTER TABLE public.dict_currency RENAME CONSTRAINT jamboai_currency_pkey TO dict_currency_pkey;
    END IF;

    IF EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'jamboai_country_pkey') THEN
        ALTER TABLE public.dict_country RENAME CONSTRAINT jamboai_country_pkey TO dict_country_pkey;
    END IF;

    IF EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'jamboai_city_pkey') THEN
        ALTER TABLE public.dict_city RENAME CONSTRAINT jamboai_city_pkey TO dict_city_pkey;
    END IF;

    IF EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'jamboai_timezone_pkey') THEN
        ALTER TABLE public.dict_timezone RENAME CONSTRAINT jamboai_timezone_pkey TO dict_timezone_pkey;
    END IF;

    IF EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'jamboai_industry_pkey') THEN
        ALTER TABLE public.dict_industry RENAME CONSTRAINT jamboai_industry_pkey TO dict_industry_pkey;
    END IF;
END $$;

-- ============================================================
-- 3. 外键约束改名
-- ============================================================

DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_jamboai_city_country') THEN
        ALTER TABLE public.dict_city RENAME CONSTRAINT fk_jamboai_city_country TO fk_dict_city_country;
    END IF;
END $$;

-- ============================================================
-- 4. 索引改名
-- ============================================================

DO $$
BEGIN
    IF to_regclass('public.uk_jamboai_language_code') IS NOT NULL THEN
        ALTER INDEX public.uk_jamboai_language_code RENAME TO uk_dict_language_code;
    END IF;

    IF to_regclass('public.uk_jamboai_currency_code') IS NOT NULL THEN
        ALTER INDEX public.uk_jamboai_currency_code RENAME TO uk_dict_currency_code;
    END IF;

    IF to_regclass('public.uk_jamboai_country_code') IS NOT NULL THEN
        ALTER INDEX public.uk_jamboai_country_code RENAME TO uk_dict_country_code;
    END IF;

    IF to_regclass('public.idx_jamboai_country_name') IS NOT NULL THEN
        ALTER INDEX public.idx_jamboai_country_name RENAME TO idx_dict_country_name;
    END IF;

    IF to_regclass('public.idx_jamboai_country_region') IS NOT NULL THEN
        ALTER INDEX public.idx_jamboai_country_region RENAME TO idx_dict_country_region;
    END IF;

    IF to_regclass('public.idx_jamboai_city_country') IS NOT NULL THEN
        ALTER INDEX public.idx_jamboai_city_country RENAME TO idx_dict_city_country;
    END IF;

    IF to_regclass('public.idx_jamboai_city_name') IS NOT NULL THEN
        ALTER INDEX public.idx_jamboai_city_name RENAME TO idx_dict_city_name;
    END IF;

    IF to_regclass('public.idx_jamboai_city_state') IS NOT NULL THEN
        ALTER INDEX public.idx_jamboai_city_state RENAME TO idx_dict_city_state;
    END IF;

    IF to_regclass('public.uk_jamboai_timezone_code') IS NOT NULL THEN
        ALTER INDEX public.uk_jamboai_timezone_code RENAME TO uk_dict_timezone_code;
    END IF;

    IF to_regclass('public.uk_jamboai_industry_code') IS NOT NULL THEN
        ALTER INDEX public.uk_jamboai_industry_code RENAME TO uk_dict_industry_code;
    END IF;
END $$;

-- ============================================================
-- 5. 表备注
-- ============================================================

COMMENT ON TABLE public.dict_language IS '平台语言字典表，支持后台、商户端、用户端、AI回复和模板消息的语言配置';
COMMENT ON TABLE public.dict_currency IS '平台货币字典表，支持国家默认币种、支付、钱包、结算、报表展示';
COMMENT ON TABLE public.dict_country IS '全球国家字典表，承载国家、电话区号、首都、货币、时区、区域、坐标、多语言名称等基础信息';
COMMENT ON TABLE public.dict_city IS '全球城市字典表，承载国家、州省、城市名称、中文名、本地名、坐标、时区、人口、多语言名称等信息';
COMMENT ON TABLE public.dict_timezone IS '全球时区字典表，支撑国家默认时区、城市时区、商户营业时间、预约排班等功能';
COMMENT ON TABLE public.dict_industry IS '行业字典表，支撑商户行业分类、AI导购行业Prompt、运营分析和权限配置';

-- ============================================================
-- 6. 字段备注：dict_language
-- ============================================================

COMMENT ON COLUMN public.dict_language.language_id IS '语言ID，建议使用雪花ID或固定初始化ID';
COMMENT ON COLUMN public.dict_language.language_code IS '语言编码，如 en、zh-CN、ja、ko、de、ru、fr、pt、es、ar';
COMMENT ON COLUMN public.dict_language.language_name IS '语言英文名称';
COMMENT ON COLUMN public.dict_language.native_name IS '语言本地名称';
COMMENT ON COLUMN public.dict_language.sort_order IS '排序';
COMMENT ON COLUMN public.dict_language.default_flag IS '是否默认语言：Y/N';
COMMENT ON COLUMN public.dict_language.status IS '状态：0正常，1停用';
COMMENT ON COLUMN public.dict_language.del_flag IS '删除标志：0正常，2删除';
COMMENT ON COLUMN public.dict_language.create_time IS '创建时间';
COMMENT ON COLUMN public.dict_language.update_time IS '更新时间';
COMMENT ON COLUMN public.dict_language.remark IS '备注';
COMMENT ON COLUMN public.dict_language.name_i18n IS '语言名称多语言JSON，如 {"zh-CN":"英语","en":"English"}';

-- ============================================================
-- 7. 字段备注：dict_currency
-- ============================================================

COMMENT ON COLUMN public.dict_currency.currency_id IS '货币ID，建议使用雪花ID或固定初始化ID';
COMMENT ON COLUMN public.dict_currency.currency_code IS '货币编码，如 USD、UGX、KES、CNY';
COMMENT ON COLUMN public.dict_currency.currency_name IS '货币英文名称';
COMMENT ON COLUMN public.dict_currency.currency_symbol IS '货币符号，如 $、USh、¥';
COMMENT ON COLUMN public.dict_currency.sort_order IS '排序';
COMMENT ON COLUMN public.dict_currency.default_flag IS '是否默认货币：Y/N';
COMMENT ON COLUMN public.dict_currency.status IS '状态：0正常，1停用';
COMMENT ON COLUMN public.dict_currency.del_flag IS '删除标志：0正常，2删除';
COMMENT ON COLUMN public.dict_currency.create_time IS '创建时间';
COMMENT ON COLUMN public.dict_currency.update_time IS '更新时间';
COMMENT ON COLUMN public.dict_currency.remark IS '备注';
COMMENT ON COLUMN public.dict_currency.name_i18n IS '货币名称多语言JSON';

-- ============================================================
-- 8. 字段备注：dict_country
-- ============================================================

COMMENT ON COLUMN public.dict_country.country_id IS '国家ID，建议使用雪花ID或固定初始化ID';
COMMENT ON COLUMN public.dict_country.country_code IS '国家二位编码 ISO Alpha-2，如 UG、CN、US';
COMMENT ON COLUMN public.dict_country.country_name IS '国家英文名称';
COMMENT ON COLUMN public.dict_country.country_name_zh IS '国家中文名称';
COMMENT ON COLUMN public.dict_country.iso3 IS '国家三位编码 ISO Alpha-3';
COMMENT ON COLUMN public.dict_country.numeric_code IS '国家数字编码 ISO Numeric';
COMMENT ON COLUMN public.dict_country.phone_code IS '国际电话区号';
COMMENT ON COLUMN public.dict_country.capital IS '首都名称';
COMMENT ON COLUMN public.dict_country.native_name IS '国家本地名称';
COMMENT ON COLUMN public.dict_country.currency IS '默认货币编码';
COMMENT ON COLUMN public.dict_country.currency_name IS '默认货币名称';
COMMENT ON COLUMN public.dict_country.currency_symbol IS '默认货币符号';
COMMENT ON COLUMN public.dict_country.timezone IS '默认时区';
COMMENT ON COLUMN public.dict_country.region_name IS '大洲/区域名称，如 Africa、Asia';
COMMENT ON COLUMN public.dict_country.subregion_name IS '子区域名称，如 Eastern Africa';
COMMENT ON COLUMN public.dict_country.latitude IS '国家中心纬度';
COMMENT ON COLUMN public.dict_country.longitude IS '国家中心经度';
COMMENT ON COLUMN public.dict_country.emoji IS '国家旗帜Emoji';
COMMENT ON COLUMN public.dict_country.status IS '状态：0正常，1停用';
COMMENT ON COLUMN public.dict_country.del_flag IS '删除标志：0正常，2删除';
COMMENT ON COLUMN public.dict_country.create_dept IS '创建部门ID';
COMMENT ON COLUMN public.dict_country.create_by IS '创建者ID';
COMMENT ON COLUMN public.dict_country.create_time IS '创建时间';
COMMENT ON COLUMN public.dict_country.update_by IS '更新者ID';
COMMENT ON COLUMN public.dict_country.update_time IS '更新时间';
COMMENT ON COLUMN public.dict_country.remark IS '备注';
COMMENT ON COLUMN public.dict_country.default_language IS '国家默认语言编码';
COMMENT ON COLUMN public.dict_country.official_languages IS '官方语言编码集合，逗号分隔';
COMMENT ON COLUMN public.dict_country.name_i18n IS '国家名称多语言翻译JSON';

-- ============================================================
-- 9. 字段备注：dict_city
-- ============================================================

COMMENT ON COLUMN public.dict_city.city_id IS '城市ID，建议优先使用 GeoNames ID 或雪花ID';
COMMENT ON COLUMN public.dict_city.country_id IS '国家ID，关联 dict_country.country_id';
COMMENT ON COLUMN public.dict_city.country_code IS '国家二位编码';
COMMENT ON COLUMN public.dict_city.country_name IS '国家名称快照';
COMMENT ON COLUMN public.dict_city.state_id IS '州/省ID，可选';
COMMENT ON COLUMN public.dict_city.state_code IS '州/省编码';
COMMENT ON COLUMN public.dict_city.state_name IS '州/省名称';
COMMENT ON COLUMN public.dict_city.city_name IS '城市英文/默认名称';
COMMENT ON COLUMN public.dict_city.city_name_zh IS '城市中文名称';
COMMENT ON COLUMN public.dict_city.native_name IS '城市本地名称';
COMMENT ON COLUMN public.dict_city.latitude IS '纬度';
COMMENT ON COLUMN public.dict_city.longitude IS '经度';
COMMENT ON COLUMN public.dict_city.timezone IS '城市时区';
COMMENT ON COLUMN public.dict_city.population IS '人口数量';
COMMENT ON COLUMN public.dict_city.status IS '状态：0正常，1停用';
COMMENT ON COLUMN public.dict_city.del_flag IS '删除标志：0正常，2删除';
COMMENT ON COLUMN public.dict_city.create_dept IS '创建部门ID';
COMMENT ON COLUMN public.dict_city.create_by IS '创建者ID';
COMMENT ON COLUMN public.dict_city.create_time IS '创建时间';
COMMENT ON COLUMN public.dict_city.update_by IS '更新者ID';
COMMENT ON COLUMN public.dict_city.update_time IS '更新时间';
COMMENT ON COLUMN public.dict_city.remark IS '备注';
COMMENT ON COLUMN public.dict_city.name_i18n IS '城市名称多语言JSON';

-- ============================================================
-- 10. 字段备注：dict_timezone
-- ============================================================

COMMENT ON COLUMN public.dict_timezone.timezone_id IS '时区ID，建议使用雪花ID或固定初始化ID';
COMMENT ON COLUMN public.dict_timezone.timezone_code IS 'IANA时区编码，如 Africa/Kampala、Asia/Shanghai';
COMMENT ON COLUMN public.dict_timezone.timezone_name IS '时区名称';
COMMENT ON COLUMN public.dict_timezone.utc_offset IS 'UTC偏移，如 UTC+03:00';
COMMENT ON COLUMN public.dict_timezone.sort_order IS '排序';
COMMENT ON COLUMN public.dict_timezone.default_flag IS '是否默认：Y/N';
COMMENT ON COLUMN public.dict_timezone.status IS '状态：0正常，1停用';
COMMENT ON COLUMN public.dict_timezone.del_flag IS '删除标志：0正常，2删除';
COMMENT ON COLUMN public.dict_timezone.create_time IS '创建时间';
COMMENT ON COLUMN public.dict_timezone.update_time IS '更新时间';
COMMENT ON COLUMN public.dict_timezone.remark IS '备注';
COMMENT ON COLUMN public.dict_timezone.name_i18n IS '时区名称多语言JSON';

-- ============================================================
-- 11. 字段备注：dict_industry
-- ============================================================

COMMENT ON COLUMN public.dict_industry.industry_id IS '行业ID，建议使用雪花ID或固定初始化ID';
COMMENT ON COLUMN public.dict_industry.industry_code IS '行业编码，如 electronics、beauty、education';
COMMENT ON COLUMN public.dict_industry.industry_name IS '行业英文/默认名称';
COMMENT ON COLUMN public.dict_industry.sort_order IS '排序';
COMMENT ON COLUMN public.dict_industry.default_flag IS '是否默认：Y/N';
COMMENT ON COLUMN public.dict_industry.status IS '状态：0正常，1停用';
COMMENT ON COLUMN public.dict_industry.del_flag IS '删除标志：0正常，2删除';
COMMENT ON COLUMN public.dict_industry.create_time IS '创建时间';
COMMENT ON COLUMN public.dict_industry.update_time IS '更新时间';
COMMENT ON COLUMN public.dict_industry.remark IS '备注';
COMMENT ON COLUMN public.dict_industry.name_i18n IS '行业名称多语言JSON';

-- ============================================================
-- 12. 迁移后检查
-- ============================================================

SELECT 'dict_language' AS table_name, COUNT(*) AS row_count FROM public.dict_language
UNION ALL
SELECT 'dict_currency', COUNT(*) FROM public.dict_currency
UNION ALL
SELECT 'dict_country', COUNT(*) FROM public.dict_country
UNION ALL
SELECT 'dict_city', COUNT(*) FROM public.dict_city
UNION ALL
SELECT 'dict_timezone', COUNT(*) FROM public.dict_timezone
UNION ALL
SELECT 'dict_industry', COUNT(*) FROM public.dict_industry;

COMMIT;

-- ============================================================
-- 说明：
-- 1. 本脚本为无损改名迁移脚本，不会删除 jamboai_* 表中的数据。
-- 2. 执行后原 jamboai_* 表名会变为 dict_*。
-- 3. 如果业务代码仍引用 jamboai_*，请同步修改代码、Mapper、实体类、菜单配置。
-- 4. 如需临时兼容旧代码，可在迁移后创建 VIEW，例如：
--    CREATE VIEW public.jamboai_country AS SELECT * FROM public.dict_country;
-- ============================================================
