package org.dromara.jamboai.intelligence.gateway.api;

import org.dromara.jamboai.intelligence.gateway.domain.JamboaiModelRoute;
import org.dromara.jamboai.intelligence.gateway.domain.JamboaiModelRouteRequest;

public interface JamboaiModelRouter {

    JamboaiModelRoute route(JamboaiModelRouteRequest request);
}
