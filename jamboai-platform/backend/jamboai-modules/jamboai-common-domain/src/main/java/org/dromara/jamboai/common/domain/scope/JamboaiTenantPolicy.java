package org.dromara.jamboai.common.domain.scope;

/**
 * Names central data isolation rules used by controllers, services and mappers.
 */
public final class JamboaiTenantPolicy {

    public static final String TENANT_ID = "tenant_id";
    public static final String AGENT_ID = "agent_id";
    public static final String MERCHANT_ID = "merchant_id";
    public static final String MEMBER_ID = "member_id";

    private JamboaiTenantPolicy() {
    }
}
