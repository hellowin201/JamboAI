package org.dromara.jamboai.communication.api;

import org.dromara.jamboai.communication.domain.JamboaiConversationMessage;

public interface JamboaiWhatsappGateway {

    void sendMerchantReply(JamboaiConversationMessage message);

    void receiveWebhookPayload(String tenantId, String rawPayload);
}
