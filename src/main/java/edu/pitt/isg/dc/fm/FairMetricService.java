package edu.pitt.isg.dc.fm;

import com.google.common.annotations.VisibleForTesting;
import lombok.Builder;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.jsoup.Jsoup;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.util.AbstractMap;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

import static edu.pitt.isg.dc.fm.FairMetricReportStatus.DONE;
import static edu.pitt.isg.dc.fm.FairMetricReportStatus.FAILED;
import static edu.pitt.isg.dc.fm.FairMetricReportStatus.RUNNING;
import static edu.pitt.isg.dc.fm.FairMetricResult.fromJsonMap;
import static edu.pitt.isg.dc.fm.FairMetricResult.newFairMetricResult;
import static edu.pitt.isg.dc.fm.JsonKit.toJson;
import static edu.pitt.isg.dc.fm.JsonKit.toStringObjectMap;
import static java.time.LocalDateTime.now;
import static org.jsoup.Connection.Method.POST;

@Service
@Slf4j
@RequiredArgsConstructor
@Builder
public class FairMetricService {
	public static final String FM_F1A = "FM-F1A";
	public static final String FM_F1B = "FM-F1B";
	public static final String FM_F2 = "FM-F2";
	public static final String FM_F3 = "FM-F3";
	public static final String FM_F4 = "FM-F4";
	public static final String FM_A1_1 = "FM-A1.1";
	public static final String FM_A1_2 = "FM-A1.2";
	public static final String FM_A2 = "FM-A2";
	public static final String FM_I1 = "FM-I1";
	public static final String FM_I2 = "FM-I2";
	public static final String FM_I3 = "FM-I3";
	public static final String FM_R1_1 = "FM-R1.1";
	public static final String FM_R1_2 = "FM-R1.2";

	public static final String SUBJECT = "subject";
	public static final String SPEC = "spec";
	public static final String IDENTIFIER = "identifier";
	public static final String VOCAB_1_URI = "vocab1_uri";
	public static final String VOCAB_2_URI = "vocab2_uri";
	public static final String VOCAB_3_URI = "vocab3_uri";
	public static final String PROV_VOCAB_URI = "prov_vocab_uri";
	public static final String FORMAT = "format";
	public static final String METADATA = "metadata";
	public static final String SEARCH_URI = "search_uri";
	public static final String PROTOCOL_URI = "protocol_uri";
	public static final String DATALICENSE_URI = "datalicense_uri";
	public static final String METADATALICENSE_URI = "metadatalicense_uri";
	public static final String PERSISTENCE_DOC = "persistence_doc";
	private static final String DELIMIT = "\t";

	private final Map<String, String> metricId2Url = initMetricUrls();
	private final MetadataService meta;
	private final FairMetricReportRepo reportRepo;
	private final FairMetricResultRowRepo rowRepo;
	private final FairMetricResultRepo resultRepo;
	private final FairMetricReportErrorRepo errorRepo;

	public FairMetricReport run() {
		final FairMetricReport report = initFairMetricReport();
		try {
			fillResults(report);
		} catch (Exception e){
			report.setStatus(FAILED);
			reportRepo.saveWithTimestamp(report);
			persistException(report, e);
		}
		return report;
	}

	private FairMetricReportError persistException(FairMetricReport report, Exception e) {
		final FairMetricReportError error = new FairMetricReportError();
		error.setReport(report);
		error.setCreated(now());
        error.setMessage(e.getMessage());
        final StringWriter sw = new StringWriter();
        e.printStackTrace(new PrintWriter(sw));
        error.setStackTrace(sw.toString());
		return errorRepo.save(error);
	}

	@Transactional
	void fillResults(FairMetricReport report) {
		final List<FairMetricResultRow> results = report.getResults();
		meta.getAllMetadata(0)
//				.limit(4)
				.map(meta::metadata2fmBody)
				.peek(m -> log.info(m.get("subject")  + " is being assessing..."))
				.map(it -> assessAllMetrics(it.get("subject"), toJson(it)))
				.map(this::saveRow)
				.peek(it -> log.debug(it.getSubject() + " was assessed."))
				.forEach(row -> results.add(row));
		report.setStatus(DONE);
		reportRepo.saveWithTimestamp(report);
        log.info("Saved report.");
	}

	public FairMetricReport currentReport() {
		return readFromCache(reportRepo.getFirstByStatusOrderByCreatedDesc(DONE).getId());
	}

	private FairMetricReport readFromCache(long id) {
		return reportRepo.peep(id);
	}

	public FairMetricReport runningReport() {
		return reportRepo.getFirstByStatusOrderByCreatedDesc(RUNNING);
	}

	@Transactional
	FairMetricReport initFairMetricReport() {
		final FairMetricReport report = new FairMetricReport();
		report.setResults(new ArrayList<>());
		report.setCreated(now());
		report.setStatus(RUNNING);
		reportRepo.saveWithTimestamp(report);
		return report;
	}

	private FairMetricResultRow saveRow(Map.Entry<String, List<FairMetricResult>> entry) {
		final List<FairMetricResult> results = entry.getValue();

		final FairMetricResultRow row = new FairMetricResultRow();
		final String key = entry.getKey();
		final String[] tokens = key.split(DELIMIT);
		row.setSubject(tokens[0]);
		row.setSubmittedPayload(tokens[1]);
		row.setResults(results);
//        resultRepo.save(results);
        rowRepo.save(row);
		return row;
	}

	private static String text(Set<Map.Entry<String,FairMetricResult>> set) {
		return set.stream()
				.map(Map.Entry::getValue)
				.map(FairMetricResult::getHasValue)
				.collect(Collectors.joining(";"));
	}

	@VisibleForTesting
	Map<String, FairMetricResult> assessAllMetrics(String body) {
		final Map<String, FairMetricResult> metricId2result = new LinkedHashMap<>();
		metricId2Url.forEach((k, v) -> metricId2result.put(k, assess(body, v)));
		return metricId2result;
	}

	private Map.Entry<String, List<FairMetricResult>> assessAllMetrics(String dataId, String body) {
		final List<FairMetricResult> results = new ArrayList<>();
		metricId2Url.forEach((k, v) -> results.add(assess(body, v)));
		return new AbstractMap.SimpleEntry<>(dataId + DELIMIT + body, results);
	}

	@VisibleForTesting
	FairMetricResult assessMetric(String metricId, String body) {
		final FairMetricResult result = assess(body, metricId2Url.get(metricId));
        log.debug(result + "");
		return result;
	}

	private Map<String, String> initMetricUrls() {
		final Map<String, String> map = new LinkedHashMap<>();
		final String prefixUrl = "http://linkeddata.systems/cgi-bin/fair_metrics/Metrics/";
		map.put(FM_F1A, prefixUrl + "metric_unique_identifier");
		map.put(FM_F1B, prefixUrl + "metric_identifier_persistence");
		map.put(FM_F2, prefixUrl + "metric_machine_readable_metadata");
		map.put(FM_F3, prefixUrl + "metric_identifier_in_metadata");
		map.put(FM_F4, prefixUrl + "metric_searchable_index");
		map.put(FM_A1_1, prefixUrl + "metric_access_protocol");
		map.put(FM_A1_2, prefixUrl + "metric_access_authorization");
		map.put(FM_A2, prefixUrl + "metric_metadata_longevity");
		map.put(FM_I1, prefixUrl + "metric_knowledge_language");
		map.put(FM_I2, prefixUrl + "metric_fair_vocabularies");
		map.put(FM_I3, prefixUrl + "metric_has_linkset");
		map.put(FM_R1_1, prefixUrl + "metric_accessible_license");
		map.put(FM_R1_2, prefixUrl + "metric_detailed_provenance_A");
		return map;
	}

	private FairMetricResult assess(String body, String url) {
		try {
			return post(body, url);
		} catch (Exception e){
			final FairMetricResult result = newFairMetricResult(url, e.getMessage(), "Failed:" + url, Arrays.toString(e.getStackTrace()), null);
			return result;
		}
	}

	private FairMetricResult post(String body, String url) throws IOException {
		String json = Jsoup.connect(url).timeout(60_000).ignoreContentType(true)
				.method(POST)
				.header("Content-Type", "application/json")
				.requestBody(body)
				.execute()
				.body();
		Map<String, Object> map = toStringObjectMap(json);
		final FairMetricResult result = fromJsonMap(map);
		return result;
	}
}
