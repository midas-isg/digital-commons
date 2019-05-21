package edu.pitt.isg.dc.fm;

import org.springframework.cache.annotation.Cacheable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

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

    @Query(nativeQuery = true, value="SELECT metric_abbrv, score \n" +
            "from vw_fair_metric_report_summary ")
    List<Object[]> getFairMetricReportSummary();

}
