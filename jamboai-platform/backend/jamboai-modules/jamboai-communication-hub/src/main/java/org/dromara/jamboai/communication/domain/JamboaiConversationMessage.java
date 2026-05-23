package org.dromara.jamboai.communication.domain;

import org.dromara.jamboai.common.domain.scope.JamboaiOrgScope;

import java.io.Serializable;
import java.time.Instant;

public record JamboaiConversationMessage(
    JamboaiOrgScope scope,
    String sessionId,
    String messageId,
    String whatsappMessageId,
    String direction,
    String senderType,
    String contentType,
    String content,
    Instant messageTime
) implements Serializable {
}
