package org.dromara.jamboai.operation.api;

import org.dromara.jamboai.operation.domain.JamboaiOrderDraft;

public interface JamboaiOrderFacade {

    String createPendingOrder(JamboaiOrderDraft draft);
}
