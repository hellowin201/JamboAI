package org.dromara.jamboai.knowledge.api;

import org.dromara.jamboai.common.domain.scope.JamboaiOrgScope;
import org.dromara.jamboai.knowledge.domain.JamboaiKnowledgeChunk;

import java.util.List;

public interface JamboaiKnowledgeSearch {

    List<JamboaiKnowledgeChunk> similaritySearch(JamboaiOrgScope scope, String query, int limit);
}
