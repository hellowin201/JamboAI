package org.dromara.jamboai.common.domain.scope;

import java.io.Serializable;

/**
 * Shared four-layer business scope: country tenant, city agent, merchant, member.
 */
public record JamboaiOrgScope(
    String tenantId,
    String agentId,
    String merchantId,
    String memberId
) implements Serializable {

    public boolean isPlatformLevel() {
        return tenantId == null || tenantId.isBlank();
    }

    public boolean hasMerchant() {
        return merchantId != null && !merchantId.isBlank();
    }
}
