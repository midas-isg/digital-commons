package edu.pitt.isg.dc.digital.software;

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
import java.util.stream.Stream;
import java.util.stream.StreamSupport;

@Component
public class SoftwareRunner implements CommandLineRunner {
    private static final Logger log = LoggerFactory.getLogger(SoftwareRunner.class);
    @Autowired
    private SoftwareRepository repository;

    @Override
    public void run(String... args) throws Exception {
        loadSoftwareLotIfNotExist();
        logSoftwareLot();
    }

    private void loadSoftwareLotIfNotExist() {
        if (repository.count() <= 0)
            loadSoftwareLot();
    }

    private void logSoftwareLot() {
        log("All Software:");
        log("-------------------------------");
        for (Digital dap : repository.findAll()) {
            log(dap.toString());
        }
        log("");
    }

    private void log(String text) {
        log.info(text);
    }

    private void loadSoftwareLot() {
        try {
            loadSoftwareLotFromCsv();
            //loadDummySoftware();
        } catch (Exception e){
            log.warn("Couldn't load Software!", e);
        }
    }

    private void loadDummySoftware() {
        final Software software = new Software();
        software.setDoi("doi");
        repository.save(software);
    }

    private Stream<Software> toSoftwareStream(InputStream is) throws Exception{
        final CsvSchema bootstrapSchema = CsvSchema.emptySchema().withHeader();
        MappingIterator<Software> it = new CsvMapper()
                .readerFor(Software.class)
                .with(bootstrapSchema)
                .readValues(is);
        Iterable<Software> iterable = () -> it;
        return StreamSupport.stream(iterable.spliterator(), false);
    }

    private void loadSoftwareLotFromCsv() throws Exception {
        final Path path = Paths.get("src/main/resources/data/Software.csv");
        log.info("Loading data from " + path.toAbsolutePath());
        toSoftwareStream(new FileInputStream(path.toFile())).forEach(this::loadDapForm);
    }

    private void loadDapForm(Software item) {
        log.debug("Loaded " + item);
        repository.save(item);
    }
}
