package edu.pitt.isg.dc.validator;

import java.lang.reflect.Field;
import java.util.List;

public class WebFlowReflectionValidator extends  ReflectionValidator {

    @Override
    public void validate(Class<?> clazz, Object object, boolean rootIsRequired, String breadcrumb, Field rootField, List<ValidatorError> errors) throws Exception {
        super.validate(clazz, object, rootIsRequired, breadcrumb, rootField, errors);

        
    }



}
