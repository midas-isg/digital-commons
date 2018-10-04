package edu.pitt.isg.dc.validator;

import org.apache.commons.lang.StringUtils;
import org.springframework.binding.message.MessageBuilder;
import org.springframework.binding.message.MessageContext;

import java.lang.reflect.Field;
import java.util.List;

public class WebFlowReflectionValidator extends  ReflectionValidator {

    @Override
    public void validate(Class<?> clazz, Object object, boolean rootIsRequired, String breadcrumb, Field rootField, List<ValidatorError> errors) throws FatalReflectionValidatorException {
        super.validate(clazz, object, rootIsRequired, breadcrumb, rootField, errors);

    }

    @Override
    public <T> void validateList(List<T> list, boolean listIsAllowedToBeEmpty, String breadcrumb, Field field, List<ValidatorError> errors) throws FatalReflectionValidatorException {
        super.validateList(list, listIsAllowedToBeEmpty, breadcrumb, field, errors);
    }

    @Override
    public Object cleanse(Class<?> clazz, Object object, boolean setEmptyToNull, boolean convertLists) throws FatalReflectionValidatorException {
        return super.cleanse(clazz, object, setEmptyToNull, convertLists);
    }

    public static void addValidationErrorToMessageContext(List<ValidatorError> errors, MessageContext messageContext) {
        for(ValidatorError error : errors) {
            //Replaces String like '->distributions->0->access->alternateIdentifiers->1->identifier' with 'distributions[0].access.alternateIdentifiers[1].identifier'
            String path = error.getPath().replace("->", ".").replaceAll("^\\.", "").replaceAll("(\\d+)", "\\[$0\\]").replaceAll(".\\[", "\\[");
            path = path.replace("(root).", "");
            String message;
            if(error.getExpectedClass().getSimpleName().contains("List") || error.getExpectedClass().getSimpleName().contains("String")) {
                String[] pathArray = path.substring(path.lastIndexOf(".")+1).split("(?=[A-Z])");

                message = StringUtils.capitalize(String.join(" ", pathArray)) + " is required";
            } else {
                message = error.getExpectedClass().getSimpleName() + " is required";
            }
            messageContext.addMessage(new MessageBuilder().error().source(
                    path).defaultText(message).build());
        }
    }



}
