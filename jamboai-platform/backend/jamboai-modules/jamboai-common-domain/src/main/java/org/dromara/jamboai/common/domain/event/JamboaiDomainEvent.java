package org.dromara.jamboai.common.domain.event;

import org.dromara.jamboai.common.domain.module.JamboaiModule;
import org.dromara.jamboai.common.domain.scope.JamboaiOrgScope;

import java.io.Serializable;
import java.time.Instant;
import java.util.Map;

/**
 * Spring Event contract. The implementation can be replaced by MQ without
 * changing producer module APIs.
 */
public record JamboaiDomainEvent(
    String eventId,
    JamboaiModule sourceModule,
    String eventType,
    JamboaiOrgScope scope,
    Map<String, Object> payload,
    Instant occurredAt
) implements Serializable {

    public static JamboaiDomainEvent now(
        String eventId,
        JamboaiModule sourceModule,
        String eventType,
        JamboaiOrgScope scope,
        Map<String, Object> payload
    ) {
        return new JamboaiDomainEvent(eventId, sourceModule, eventType, scope, payload, Instant.now());
    }
}
