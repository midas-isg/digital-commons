package edu.pitt.isg.dc.fm;

import lombok.Data;

import javax.persistence.Column;
import javax.persistence.Convert;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import java.time.LocalDateTime;

import static javax.persistence.GenerationType.SEQUENCE;

@Entity
@Data
public class FairMetricReportError {
    @Id
    @GeneratedValue(strategy = SEQUENCE, generator = "generator")
    @SequenceGenerator(name="generator", sequenceName = "fair_metric_report_error_seq")
    private Long id;
    @Convert(converter = LocalDateTimeConverter.class)
    private LocalDateTime created;
    @OneToOne
    private FairMetricReport report;
    private String message;
    @Column(length = 10_485_760)
    private String stackTrace;

}
