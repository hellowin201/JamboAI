package org.dromara.jamboai.payment.risk.api;

import org.dromara.jamboai.payment.risk.domain.JamboaiPaymentRequest;
import org.dromara.jamboai.payment.risk.domain.JamboaiPaymentResult;

public interface JamboaiPaymentGateway {

    JamboaiPaymentResult createPayment(JamboaiPaymentRequest request);
}
