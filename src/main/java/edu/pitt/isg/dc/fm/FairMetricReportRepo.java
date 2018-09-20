package edu.pitt.isg.dc.fm;

import org.springframework.cache.annotation.Cacheable;
import org.springframework.data.jpa.repository.JpaRepository;


public interface FairMetricReportRepo extends JpaRepository<FairMetricReport, Long> {
    FairMetricReport findTopByStatusOrderByCreatedDesc(FairMetricReportStatus status);
    @Cacheable("FairMetricReport")
    FairMetricReport findOne(Long id);
}
