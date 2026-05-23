package org.dromara.jamboai.intelligence.gateway.domain;

import org.dromara.jamboai.common.domain.scope.JamboaiOrgScope;

import java.io.Serializable;

public record JamboaiModelRouteRequest(
    JamboaiOrgScope scope,
    String businessScene,
    String languageCode,
    Integer maxTokens,
    String riskLevel
) implements Serializable {
}
