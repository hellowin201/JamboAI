package org.dromara.jamboai.payment.risk.domain;

import java.io.Serializable;

public record JamboaiPaymentResult(
    String transactionId,
    String externalTransactionId,
    String paymentUrl,
    String paymentStatus
) implements Serializable {
}
