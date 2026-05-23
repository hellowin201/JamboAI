package org.dromara.jamboai.agent.runtime.domain;

import java.io.Serializable;
import java.util.List;

public record JamboaiAgentExecutionResult(
    String messageId,
    String replyText,
    List<String> toolCallIds,
    boolean handoverRequired
) implements Serializable {
}
