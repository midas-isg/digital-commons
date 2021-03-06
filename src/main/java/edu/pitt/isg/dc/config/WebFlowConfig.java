package edu.pitt.isg.dc.config;

import java.util.Collections;

import edu.pitt.isg.dc.controller.Interceptor;
import edu.pitt.isg.dc.utils.ReflectionFactory;
import edu.pitt.isg.mdc.dats2_2.*;
import edu.pitt.isg.mdc.v1_0.DiseaseForecasters;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Scope;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.webflow.config.AbstractFlowConfiguration;
import org.springframework.webflow.definition.registry.FlowDefinitionRegistry;
import org.springframework.webflow.engine.builder.support.FlowBuilderServices;
import org.springframework.webflow.executor.FlowExecutor;
import org.springframework.webflow.mvc.builder.MvcViewFactoryCreator;

@Configuration
public class WebFlowConfig extends AbstractFlowConfiguration {

    @Autowired
    private MvcConfiguration mvcConfiguration;

    @Bean
    public FlowDefinitionRegistry flowRegistry() {
        return getFlowDefinitionRegistryBuilder(flowBuilderServices())
                .addFlowLocation("/WEB-INF/flows/control-flow.xml", "add-digital-object")
                .addFlowLocation("/WEB-INF/flows/software-flow.xml", "addSoftware")
                .addFlowLocation("/WEB-INF/flows/dataset-flow.xml", "addDataset")
                .addFlowLocation("/WEB-INF/flows/dataStandard-flow.xml", "addDataStandard")
                .build();
    }

    @Bean
    public FlowExecutor flowExecutor() {
        return getFlowExecutorBuilder(flowRegistry()).build();
    }

    @Bean
    public FlowBuilderServices flowBuilderServices() {
        return getFlowBuilderServicesBuilder().setViewFactoryCreator(mvcViewFactoryCreator()).setDevelopmentMode(true).build();
    }

    @Bean
    public MvcViewFactoryCreator mvcViewFactoryCreator() {
        MvcViewFactoryCreator factoryCreator = new MvcViewFactoryCreator();
        factoryCreator.setViewResolvers(Collections.singletonList(this.mvcConfiguration.getViewResolver()));
        factoryCreator.setUseSpringBeanBinding(true);
        return factoryCreator;
    }

    @Bean
    @Scope("prototype")
    public Dataset dataset() {
        Dataset dataset = null;
        try {
            dataset = (Dataset) ReflectionFactory.create(Dataset.class);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }

//        Dataset dataset = new Dataset();
//        dataset = DatasetFactory.createDatasetForWebFlow(dataset);
        return dataset;
    }

    @Bean
    @Scope("prototype")
    public DiseaseForecasters diseaseForecaster() {
        DiseaseForecasters diseaseForecaster = null;
        try {
            diseaseForecaster = (DiseaseForecasters) ReflectionFactory.create(DiseaseForecasters.class);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }

        return diseaseForecaster;
    }
}