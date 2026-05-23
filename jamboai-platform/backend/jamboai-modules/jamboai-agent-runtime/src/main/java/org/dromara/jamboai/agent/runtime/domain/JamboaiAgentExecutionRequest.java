package org.dromara.jamboai.agent.runtime.domain;

import org.dromara.jamboai.common.domain.scope.JamboaiOrgScope;

import java.io.Serializable;

public record JamboaiAgentExecutionRequest(
    JamboaiOrgScope scope,
    String agentAppId,
    String sessionId,
    String memberMessage,
    boolean humanHandoverAllowed
) implements Serializable {
}
