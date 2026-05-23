package org.dromara.jamboai.intelligence.gateway.domain;

import java.io.Serializable;

public record JamboaiModelRoute(
    String providerCode,
    String modelName,
    String routeCode,
    String promptTemplateCode
) implements Serializable {
}
