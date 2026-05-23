package org.dromara.jamboai.payment.risk.domain;

import org.dromara.jamboai.common.domain.scope.JamboaiOrgScope;

import java.io.Serializable;
import java.math.BigDecimal;

public record JamboaiPaymentRequest(
    JamboaiOrgScope scope,
    String orderId,
    String channelCode,
    String paymentMethod,
    BigDecimal amount,
    String currencyCode
) implements Serializable {
}
