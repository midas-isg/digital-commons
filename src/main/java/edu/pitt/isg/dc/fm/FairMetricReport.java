package edu.pitt.isg.dc.fm;

import lombok.Data;

import javax.persistence.CascadeType;
import javax.persistence.Convert;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToMany;
import javax.persistence.OrderBy;
import javax.persistence.SequenceGenerator;
import java.time.LocalDateTime;
import java.util.List;

import static javax.persistence.GenerationType.SEQUENCE;

@Entity
@Data
public class FairMetricReport {
    @Id
    @GeneratedValue(strategy = SEQUENCE, generator = "generator")
    @SequenceGenerator(name="generator", sequenceName = "fair_metric_report_seq")
    private Long id;
    @Convert(converter = LocalDateTimeConverter.class)
    private LocalDateTime created;
    @OneToMany(
            cascade = CascadeType.ALL,
            orphanRemoval = true
    )
    @JoinColumn(name = "report_id")
    @OrderBy("id ASC")
    private List<FairMetricResultRow> results;
}
