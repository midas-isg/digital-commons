package edu.pitt.isg.dc.digital;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

@Component
public class DigitalRunner implements CommandLineRunner {
    private static final Logger log = LoggerFactory.getLogger(DigitalRunner.class);
    @Autowired
    private DigitalRepository digitalRepository;
    @Autowired
    private TypeRepository typeRepository;


    @Override
    public void run(String... args) throws Exception {
        loadDigitalObjectsIfNotExist();
        logDigitalObjects();
        logDigitalTypes();
    }

    private void logDigitalTypes() {
        log("All Digital Types:");
        log("-------------------------------");
        for (Type aff : typeRepository.findAll()) {
            log(aff.toString());
        }
        log("");
    }

    private void loadDigitalObjectsIfNotExist() {
        if (digitalRepository.count() <= 0)
            loadAffiliations();
    }

    private void logDigitalObjects() {
        log("All Digital Objects:");
        log("-------------------------------");
        for (Digital aff : digitalRepository.findAll()) {
            log(aff.toString());
        }
        log("");
    }

    private void log(String text) {
        log.info(text);
    }

    private void loadAffiliations() {
        Type software = new Type("software", null);
        typeRepository.save(software);
        typeRepository.save(new Type("web-app", software));
        Type ws = new Type("web-service", software);
        typeRepository.save(ws);

        digitalRepository.save(new Digital("LS", ws));
    }
}
