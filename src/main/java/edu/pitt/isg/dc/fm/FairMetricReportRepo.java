package edu.pitt.isg.dc.fm;

import org.springframework.cache.annotation.Cacheable;
import org.springframework.data.jpa.repository.JpaRepository;

import static java.time.LocalDateTime.now;


public interface FairMetricReportRepo extends JpaRepository<FairMetricReport, Long> {
    FairMetricReport getFirstByStatusOrderByCreatedDesc(FairMetricReportStatus status);

    @Cacheable("FairMetricReport")
    default FairMetricReport peep(long id) {
        return getOne(id);
    }

    default FairMetricReport saveWithTimestamp(FairMetricReport entity) {
        entity.setUpdated(now());
        return save(entity);
    }
}
