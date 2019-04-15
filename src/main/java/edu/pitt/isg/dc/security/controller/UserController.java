package edu.pitt.isg.dc.security.controller;

import edu.pitt.isg.dc.entry.Users;
import edu.pitt.isg.dc.security.service.EmailService;
import edu.pitt.isg.dc.security.service.SecurityService;
import edu.pitt.isg.dc.security.service.UserService;
import edu.pitt.isg.dc.security.validator.PasswordValidator;
import edu.pitt.isg.dc.security.validator.UserValidator;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.web.authentication.logout.SecurityContextLogoutHandler;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.MissingServletRequestParameterException;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.Map;
import java.util.UUID;

import static edu.pitt.isg.dc.controller.Interceptor.ifLoggedIn;


@Controller
public class UserController {
    @Autowired
    private UserService userService;

    @Autowired
    private SecurityService securityService;

    @Autowired
    private UserValidator userValidator;

    @Autowired
    private PasswordValidator passwordValidator;

    @Autowired
    private EmailService emailService;

    @GetMapping("/registration")
    public String registration(Model model) {
        model.addAttribute("userForm", new Users());

        return "registration";
    }

    @PostMapping("/registration")
    public String registration(@ModelAttribute("userForm") Users userForm, BindingResult bindingResult) {
        userValidator.validate(userForm, bindingResult);

        if (bindingResult.hasErrors()) {
            return "registration";
        }

        userService.save(userForm);

        securityService.autoLogin(userForm.getUserId(), userForm.getPasswordConfirm());

        return "redirect:/main";
    }

    @GetMapping("/login")
    public String login(HttpSession session, Model model, String error, String logout) {
        if (ifLoggedIn(session)) {
            return "redirect:/main";
        }

        if (error != null)
            model.addAttribute("error", "Your username and password is invalid.");

        if (logout != null)
            model.addAttribute("message", "You have been logged out successfully.");

        return "login";
    }

    @GetMapping("/logout")
    public String logout(HttpServletRequest request, HttpServletResponse response) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth != null) {
            new SecurityContextLogoutHandler().logout(request, response, auth);
        }
        return "redirect:/main";
    }

    @GetMapping(value = "/forgot")
    public String displayForgotPasswordPage() {
        return "forgotPassword";
    }

    // Process form submission from forgotPassword page
    @PostMapping(value = "/forgot")
    public String processForgotPasswordForm(Model model, @RequestParam("email") String userEmail, HttpServletRequest request) throws MalformedURLException {

        // Lookup user in database by e-mail
        Users user = userService.findByEmail(userEmail);

        if (user == null) {
            model.addAttribute("errorMessage", "We didn't find an account for that e-mail address.");
        } else {

            // Generate random 36-character string token for reset password
            user.setResetToken(UUID.randomUUID().toString());

            // Save token to database
            userService.save(user);

            URL requestURL = new URL(request.getRequestURL().toString());
            String port = requestURL.getPort() == -1 ? "" : ":" + requestURL.getPort();
            String appUrl = requestURL.getProtocol() + "://" + requestURL.getHost() + port + request.getContextPath();

            // Email message
            SimpleMailMessage passwordResetEmail = new SimpleMailMessage();
            passwordResetEmail.setFrom("support@demo.com");
            passwordResetEmail.setTo(user.getEmail());
            passwordResetEmail.setSubject("Password Reset Request");
            passwordResetEmail.setText("To reset your password, click the link below:\n" + appUrl
                    + "/reset?token=" + user.getResetToken());

            emailService.sendEmail(passwordResetEmail);

            // Add success message to view
            model.addAttribute("successMessage", "A password reset link has been sent to " + userEmail);
        }

        return "forgotPassword";
    }

    // Display form to reset password
    @GetMapping(value = "/reset")
    public String displayResetPasswordPage(Model model, @RequestParam("token") String token) {

        Users user = userService.findByResetToken(token);
        user.setPassword("");
        model.addAttribute("resetForm", user);

        if (user != null) { // Token found in DB
            model.addAttribute("resetToken", token);
        } else { // Token not found in DB
            model.addAttribute("errorMessage", "Oops!  This is an invalid password reset link.");
        }

        return "resetPassword";
    }

    // Process reset password form
    @PostMapping(value = "/reset")
    public String setNewPassword(@ModelAttribute("resetForm") Users resetForm, BindingResult bindingResult, Model modelAndView, @RequestParam Map<String, String> requestParams, RedirectAttributes redir) {

        // Find the user associated with the reset token
        Users resetUser = userService.findByResetToken(requestParams.get("resetToken"));

        // This should always be non-null but we check just in case
        if (resetUser != null) {
            passwordValidator.validate(resetForm, bindingResult);

            if (bindingResult.hasErrors()) {
                modelAndView.addAttribute("resetToken", requestParams.get("resetToken"));
                return "resetPassword";
            }

            // Set new password
            resetUser.setPassword(resetForm.getPassword());

            // Set the reset token to null so it cannot be used again
            resetUser.setResetToken(null);

            // Save user
            userService.save(resetUser);

            redir.addFlashAttribute("successMessage", "You have successfully reset your password.  You may now login.");

            return "redirect:/login";

        } else {
            modelAndView.addAttribute("errorMessage", "Oops!  This is an invalid password reset link.");
            return "resetPassword";
        }
    }

    // Going to reset page without a token redirects to login page
    @ExceptionHandler(MissingServletRequestParameterException.class)
    public String handleMissingParams(MissingServletRequestParameterException ex) {
        return "redirect:/login";
    }
}