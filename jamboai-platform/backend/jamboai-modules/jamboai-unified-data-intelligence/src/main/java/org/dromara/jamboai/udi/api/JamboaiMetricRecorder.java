package org.dromara.jamboai.udi.api;

import org.dromara.jamboai.udi.domain.JamboaiAiMetricSnapshot;

public interface JamboaiMetricRecorder {

    void recordDailySnapshot(JamboaiAiMetricSnapshot snapshot);
}
