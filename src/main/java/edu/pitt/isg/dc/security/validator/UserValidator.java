package edu.pitt.isg.dc.security.validator;

import edu.pitt.isg.dc.entry.Users;
import edu.pitt.isg.dc.security.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.ValidationUtils;
import org.springframework.validation.Validator;

@Component
public class UserValidator implements Validator {
    @Autowired
    private UserService userService;

    @Override
    public boolean supports(Class<?> aClass) {
        return Users.class.equals(aClass);
    }

    @Override
    public void validate(Object o, Errors errors) {
        Users user = (Users) o;

        ValidationUtils.rejectIfEmptyOrWhitespace(errors, "userId", "NotEmpty");
        ValidationUtils.rejectIfEmptyOrWhitespace(errors, "name", "NotEmpty");
        ValidationUtils.rejectIfEmptyOrWhitespace(errors, "email", "NotEmpty");

        if (user.getUserId().length() < 6 || user.getUserId().length() > 32) {
            errors.rejectValue("userId", "Size.userForm.username");
        }
        if (userService.findByUserId(user.getUserId()) != null) {
            errors.rejectValue("userId", "Duplicate.userForm.username");
        }
        if(userService.findByEmail(user.getEmail()) != null) {
            errors.rejectValue("email", "Duplicate.userForm.email");
        }

        ValidationUtils.rejectIfEmptyOrWhitespace(errors, "password", "NotEmpty");
        if (user.getPassword().length() < 8 || user.getPassword().length() > 32) {
            errors.rejectValue("password", "Size.userForm.password");
        }

        if (!user.getPasswordConfirm().equals(user.getPassword())) {
            errors.rejectValue("passwordConfirm", "Diff.userForm.passwordConfirm");
        }
    }
}