package edu.pitt.isg.dc.config;

import java.util.Collections;
import java.util.Formatter;
import java.util.HashSet;
import java.util.Set;

import edu.pitt.isg.dc.validator.CustomDatasetConverter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.binding.convert.converters.Converter;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.binding.convert.ConversionService;
import org.springframework.core.convert.support.DefaultConversionService;
import org.springframework.format.support.FormattingConversionServiceFactoryBean;
import org.springframework.stereotype.Component;
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
        return getFlowDefinitionRegistryBuilder(flowBuilderServices()).addFlowLocation("/WEB-INF/flows/activation-flow.xml", "activationFlow").build();
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

}