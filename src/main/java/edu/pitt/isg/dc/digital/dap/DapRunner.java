package edu.pitt.isg.dc.digital.dap;

import com.fasterxml.jackson.databind.MappingIterator;
import com.fasterxml.jackson.dataformat.csv.CsvMapper;
import com.fasterxml.jackson.dataformat.csv.CsvSchema;
import edu.pitt.isg.dc.digital.Digital;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import java.io.FileInputStream;
import java.io.InputStream;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.stream.Stream;
import java.util.stream.StreamSupport;

@Component
public class DapRunner implements CommandLineRunner {
    private static final Logger log = LoggerFactory.getLogger(DapRunner.class);
    @Autowired
    private DapRepository dapRepository;

    @Override
    public void run(String... args) throws Exception {
        loadDapsIfNotExist();
        logDaps();
    }

    private void loadDapsIfNotExist() {
        if (dapRepository.count() <= 0)
            loadDaps();
    }

    private void logDaps() {
        log("All Data-Augmented Publications:");
        log("-------------------------------");
        for (Digital dap : dapRepository.findAll()) {
            log(dap.toString());
        }
        log("");
    }

    private void log(String text) {
        log.info(text);
    }

    private void loadDaps() {
        try {
            loadDataAugmentedPublications();
        } catch (Exception e){
            log.warn("Couldn't load Data-Augmented Publications!", e);
        }
    }

    private Stream<DapForm> toDapFormStream(InputStream is) throws Exception{
        final CsvSchema bootstrapSchema = CsvSchema.emptySchema().withHeader();
        MappingIterator<DapForm> it = new CsvMapper()
                .readerFor(DapForm.class)
                .with(bootstrapSchema)
                .readValues(is);
        Iterable<DapForm> iterable = () -> it;
        return StreamSupport.stream(iterable.spliterator(), false);
    }

    private void loadDataAugmentedPublications() throws Exception {
        final Path path = Paths.get("src/main/resources/data/DataAugmentedPublications.csv");
        log.info("Loading data from " + path.toAbsolutePath());
        toDapFormStream(new FileInputStream(path.toFile())).forEach(this::loadDapForm);
    }

    private void loadDapForm(DapForm dapForm) {
        final DataAugmentedPublication dap = toDataAugmentedPublication(dapForm);
        log.debug("Loaded " + dap);
        dapRepository.save(dap);
    }

    private DataAugmentedPublication toDataAugmentedPublication(DapForm form) {
        final DataAugmentedPublication dap = new DataAugmentedPublication();
        final String paperDoi = form.getPaperDoi();
        dap.setPaper(findPaper(paperDoi));
        dap.setName(form.getName());
        dap.setUrl(form.getUrl());
        dap.setTypeText(form.getTypeText());
        dap.setAuthorsText(form.getAuthorsText());
        dap.setPublicationDateText(form.getPublicationDateText());
        dap.setDoi(form.getDoi());
        dap.setJournal(form.getJournal());
        return dap;
    }

    private DataAugmentedPublication findPaper(String doi) {
        if (doi == null || doi.isEmpty())
            return null;
        final List<DataAugmentedPublication> papers = dapRepository.findAllByDoi(doi);
        if (! papers.isEmpty()){
            return papers.get(0);
        }
        return null;
    }
}
