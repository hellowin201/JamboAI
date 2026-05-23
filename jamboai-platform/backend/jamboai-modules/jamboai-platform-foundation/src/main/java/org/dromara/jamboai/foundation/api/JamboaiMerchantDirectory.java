package org.dromara.jamboai.foundation.api;

import org.dromara.jamboai.foundation.domain.JamboaiMerchantProfile;

import java.util.Optional;

public interface JamboaiMerchantDirectory {

    Optional<JamboaiMerchantProfile> findActiveMerchant(String tenantId, String merchantId);
}
