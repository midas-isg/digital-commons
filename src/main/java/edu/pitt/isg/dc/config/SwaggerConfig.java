package edu.pitt.isg.dc.config;

import com.google.common.base.Predicates;
import com.mangofactory.swagger.configuration.SpringSwaggerConfig;
import com.mangofactory.swagger.models.dto.ApiInfo;
import com.mangofactory.swagger.plugin.EnableSwagger;
import com.mangofactory.swagger.plugin.SwaggerSpringMvcPlugin;
import com.wordnik.swagger.annotations.Api;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.web.BasicErrorController;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.DefaultServletHandlerConfigurer;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurerAdapter;

import static org.ajar.swaggermvcui.SwaggerSpringMvcUi.WEB_JAR_RESOURCE_LOCATION;

@Configuration
@Api(value = "/pet", description = "Operations about pets")
@ComponentScan(basePackages = "edu.pitt.isg.dc.controller")
@EnableSwagger
public class SwaggerConfig extends WebMvcConfigurerAdapter {

    private SpringSwaggerConfig springSwaggerConfig;

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler(new String[]{"css/", "images/", "lib/", "swagger-ui.js", "resources/swagger-ui.js"})
                .addResourceLocations(WEB_JAR_RESOURCE_LOCATION).setCachePeriod(0);
    }

  /*  @Bean
    public InternalResourceViewResolver getInternalResourceViewResolver() {
        InternalResourceViewResolver resolver = new InternalResourceViewResolver();
        resolver.setPrefix(WEB_JAR_VIEW_RESOLVER_PREFIX);
        resolver.setSuffix(WEB_JAR_VIEW_RESOLVER_SUFFIX);
        return resolver;
    }*/


    @Bean
    public SwaggerSpringMvcPlugin customImplementation(){

        return new SwaggerSpringMvcPlugin(this.springSwaggerConfig)
                .apiInfo(apiInfo()).includePatterns("/api/.*?"); // assuming the API lives at something like http://myapp/api
    }

    @Override
    public void configureDefaultServletHandling(DefaultServletHandlerConfigurer configurer) {
        configurer.enable();
    }

    @SuppressWarnings("SpringJavaAutowiringInspection")
    @Autowired
    public void setSpringSwaggerConfig(SpringSwaggerConfig springSwaggerConfig) {
        this.springSwaggerConfig = springSwaggerConfig;
    }
/*
    @Bean
    public Docket demoApi() {
        return new Docket(DocumentationType.SWAGGER_2)//<3>
                .select()//<4>
                .apis(RequestHandlerSelectors.any())//<5>
                .paths(Predicates.not(PathSelectors.regex('/error.*')))//<6>
                .build()
    }*/


    protected ApiInfo apiInfo() {


      //  String contextForSite = configProperties.getProperty("contextPathForSite");
        ApiInfo apiInfo = new ApiInfo(
                "MIDAS Digital Commons API",
                "This API allows a user to retrieve an object's DOI (digital object identifier) and it's associated information (both data and metadata) from the MDC. ",
                /*contextForSite+*/"/main#about",
                "jdl50@pitt.edu",
                null,
                null
        );
        return apiInfo;
    }
}