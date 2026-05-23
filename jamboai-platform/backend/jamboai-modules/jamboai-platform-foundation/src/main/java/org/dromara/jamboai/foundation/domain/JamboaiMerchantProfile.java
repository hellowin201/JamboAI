package org.dromara.jamboai.foundation.domain;

import org.dromara.jamboai.common.domain.scope.JamboaiOrgScope;

import java.io.Serializable;

public record JamboaiMerchantProfile(
    JamboaiOrgScope scope,
    String merchantName,
    String countryCode,
    String cityCode,
    String languageCode,
    String currencyCode,
    String settlementMode
) implements Serializable {
}
