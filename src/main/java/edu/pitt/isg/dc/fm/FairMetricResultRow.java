package edu.pitt.isg.dc.fm;

import lombok.Data;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToMany;
import javax.persistence.OrderBy;
import javax.persistence.SequenceGenerator;
import java.util.List;

import static javax.persistence.FetchType.LAZY;
import static javax.persistence.GenerationType.SEQUENCE;

@Entity
@Data
public class FairMetricResultRow {
    @Id
    @GeneratedValue(strategy = SEQUENCE, generator = "generator")
    @SequenceGenerator(name="generator", sequenceName = "fair_metric_result_row_seq")
    private Long id;
    private String subject;
    @Column(length = 10_485_760)
    private String submittedPayload;
    @OneToMany(
            fetch = LAZY,
            cascade = CascadeType.ALL,
            orphanRemoval = true
    )
    @JoinColumn(name = "row_id")
    @OrderBy("id ASC")
    private List<FairMetricResult> results;
}
