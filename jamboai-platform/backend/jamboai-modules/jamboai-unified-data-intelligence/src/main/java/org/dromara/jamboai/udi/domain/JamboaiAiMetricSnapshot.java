package org.dromara.jamboai.udi.domain;

import org.dromara.jamboai.common.domain.scope.JamboaiOrgScope;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDate;

public record JamboaiAiMetricSnapshot(
    JamboaiOrgScope scope,
    String agentAppId,
    LocalDate metricDate,
    int conversationCount,
    int aiReplyCount,
    int handoverCount,
    BigDecimal tokenCost
) implements Serializable {
}
