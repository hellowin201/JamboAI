package org.dromara.jamboai.communication.event;

import org.dromara.jamboai.common.domain.scope.JamboaiOrgScope;

import java.io.Serializable;
import java.time.Instant;

public record JamboaiHandoverRequestedEvent(
    JamboaiOrgScope scope,
    String sessionId,
    String reason,
    Instant requestedAt
) implements Serializable {
}
