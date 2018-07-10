package edu.pitt.isg.dc.validator;

import org.springframework.core.convert.converter.Converter;

public class CustomDatasetConverter implements Converter<String, String> {
    @Override
    public String convert(String source) {
        return source.trim();
    }
}
