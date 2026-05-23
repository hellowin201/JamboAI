package org.dromara.jamboai.common.domain.module;

/**
 * JamboAI PRD 2.3/2.4 aligned bounded contexts.
 */
public enum JamboaiModule {

    PLATFORM_FOUNDATION("Platform Foundation"),
    COMMUNICATION_HUB("Communication Hub"),
    INTELLIGENCE_GATEWAY("Intelligence Gateway"),
    AGENT_RUNTIME("Intelligence Agent Runtime"),
    KNOWLEDGE_CENTER("Knowledge Center"),
    OPERATION_CENTER("Operation Center"),
    PAYMENT_RISK_CENTER("Payment & Risk Center"),
    UNIFIED_DATA_INTELLIGENCE("Unified Data Intelligence");

    private final String displayName;

    JamboaiModule(String displayName) {
        this.displayName = displayName;
    }

    public String displayName() {
        return displayName;
    }
}
