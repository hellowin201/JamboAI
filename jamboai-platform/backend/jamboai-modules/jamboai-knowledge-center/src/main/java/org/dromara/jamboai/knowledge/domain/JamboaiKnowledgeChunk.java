package org.dromara.jamboai.knowledge.domain;

import org.dromara.jamboai.common.domain.scope.JamboaiOrgScope;

import java.io.Serializable;
import java.util.Map;

public record JamboaiKnowledgeChunk(
    JamboaiOrgScope scope,
    String documentId,
    String chunkId,
    String content,
    Map<String, Object> metadata
) implements Serializable {
}
