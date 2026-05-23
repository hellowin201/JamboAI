package org.dromara.jamboai.operation.domain;

import org.dromara.jamboai.common.domain.scope.JamboaiOrgScope;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.List;

public record JamboaiOrderDraft(
    JamboaiOrgScope scope,
    String sourceSessionId,
    String currencyCode,
    BigDecimal totalAmount,
    List<String> itemIds
) implements Serializable {
}
