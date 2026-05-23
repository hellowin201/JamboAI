package org.dromara.jamboai.agent.runtime.api;

import org.dromara.jamboai.agent.runtime.domain.JamboaiAgentExecutionRequest;
import org.dromara.jamboai.agent.runtime.domain.JamboaiAgentExecutionResult;

public interface JamboaiAgentRuntime {

    JamboaiAgentExecutionResult execute(JamboaiAgentExecutionRequest request);
}
