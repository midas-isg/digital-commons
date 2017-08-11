package edu.pitt.isg.dc.controller;

import com.auth0.Auth0User;
import com.auth0.NonceUtils;
import com.auth0.QueryParamUtils;
import com.auth0.SessionUtils;
import com.auth0.spring.security.mvc.Auth0CallbackHandler;
import com.mangofactory.swagger.annotations.ApiIgnore;
import edu.pitt.isg.dc.utils.UrlAid;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.support.SessionStatus;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.servlet.view.RedirectView;
import org.springframework.web.util.UriComponentsBuilder;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Collections;
import java.util.List;

@ApiIgnore
@Controller
public class Auth0Controller extends Auth0CallbackHandler {
	private static final String ROLES_TOKEN = "roles";
	public static final String ISG_ADMIN_TOKEN = "ISG_ADMIN";
	public static final String MDC_EDITOR_TOKEN = "MDC_EDITOR";

	@RequestMapping(value = "/${auth0.loginRedirectOnFail}", method = RequestMethod.GET)
	public String showLoginPage(
			final HttpServletRequest request,
			final Model model,
			@Value("${auth0.clientId}") final String clientId,
			@Value("${auth0.domain}") final String auth0Domain,
			@Value("${app.servers.midasHub.url}") final String midasHubUrl) {

		final HttpSession session = request.getSession();

		NonceUtils.addNonceToStorage(request);
		String nonce = SessionUtils.getState(request);

		model.addAttribute("callbackUrl", UrlAid.toUrlString(request, "callback"));
		model.addAttribute("state", nonce);
		model.addAttribute("clientId", clientId);
		model.addAttribute("domain", auth0Domain);
		model.addAttribute("ssoLoginUrl", midasHubUrl);
		model.addAttribute("logoutUrl", request.getContextPath() + "/logout");
		Auth0User auth0User = (Auth0User) session.getAttribute("auth0User");
		if (auth0User != null) {
			model.addAttribute("userId", auth0User.getUserId());
		}

		return "login";
	}

	@RequestMapping(value = "/logoutFromAuth0", method = RequestMethod.GET)
	public RedirectView logOut(
			@Value("${auth0.domain}") final String auth0Domain,
			@Value("${auth0.clientId}") final String clientId,
			final HttpServletRequest request,
			final SessionStatus sessionStatus,
			final RedirectAttributes redirectAttributes) {

		sessionStatus.setComplete();
		redirectAttributes.addFlashAttribute("successMsg", Collections.singletonList("You have successfully logged out."));
		final HttpSession session = request.getSession();
		session.invalidate();

		String redirectUrl = UriComponentsBuilder.newInstance()
				.scheme("https")
				.host(auth0Domain)
				.pathSegment("v2", "logout")
				.queryParam("returnTo", UrlAid.toUrlString(request,  "login"))
				.build().toString();
		return new RedirectView(redirectUrl, false);
	}

	@RequestMapping(value = "${auth0.loginRedirectOnSuccess}", method = RequestMethod.GET)
	public String processAuth0Login(
			final HttpServletRequest request,
			final HttpServletResponse response,
			final RedirectAttributes redirectAttributes,
			final Model model) throws IOException {
		final HttpSession session = request.getSession();
		authenticateUserAtAppLevel(session, request);
		Auth0User auth0User = (Auth0User) session.getAttribute("auth0User");
		String email = auth0User.getEmail().toLowerCase();
		String userId = auth0User.getUserId();

		session.setAttribute(HomeController.LOGGED_IN_PROPERTY, true);
		session.setAttribute("userEmail", email);
		session.setAttribute("userId", userId);
		session.setAttribute("userName", auth0User.getName());
		session.setAttribute("userPic", auth0User.getPicture());
//
		return "redirect:/main";

	}

	@RequestMapping(value = "${auth0.loginCallback}", method = RequestMethod.GET)
	protected void callback(final HttpServletRequest req, final HttpServletResponse res)
			throws ServletException, IOException {
		super.handle(req, res);
	}

	@Override
	protected void onSuccess(HttpServletRequest req, HttpServletResponse res)
			throws ServletException, IOException {
		final String externalReturnUrl = getExternalReturnUrl(req);
		if (externalReturnUrl != null) {
			// redirect back to partner site
			res.sendRedirect(externalReturnUrl);
		} else {
			// redirect back to "callback success" location of this app
			res.sendRedirect(req.getContextPath() + this.redirectOnSuccess);
		}
	}

	@Override
	protected void onFailure(HttpServletRequest req, HttpServletResponse res, Exception ex) throws ServletException, IOException {
		ex.printStackTrace();
		final String externalReturnUrl = getExternalReturnUrl(req);
		if (externalReturnUrl != null) {
			// redirect back to partner site
			final String redirectExternalOnFailLocation = externalReturnUrl + "?error=callbackError";
			res.sendRedirect(redirectExternalOnFailLocation);
		} else {
			// redirect back to "callback failure" location of this app
			final String redirectOnFailLocation = req.getContextPath() + this.redirectOnFail;
			res.sendRedirect(redirectOnFailLocation);
		}
	}

	@Override
	protected boolean isValidState(final HttpServletRequest req) {
		final boolean isNonceValid = super.isValidState(req);
		final String externalReturnUrl = getExternalReturnUrl(req);
		final boolean isTrustedExternalReturnUrl = (externalReturnUrl == null) /*||
                ssoConfig.getTrustedExternalReturnUrls().contains(externalReturnUrl)*/;
		return isNonceValid && isTrustedExternalReturnUrl;
	}

	protected String getExternalReturnUrl(final HttpServletRequest req) {
		final String stateFromRequest = req.getParameter("state");
		if (stateFromRequest == null) {
			throw new IllegalStateException("state missing in request");
		}
		return QueryParamUtils.parseFromQueryParams(stateFromRequest, "externalReturnUrl");
	}

	private Auth0User authenticateUserAtAppLevel(HttpSession session, HttpServletRequest req) {
		final Auth0User auth0User = SessionUtils.getAuth0User(req);
		if (auth0User.getAppMetadata() != null) {
			List<String> roles = (List<String>) auth0User.getAppMetadata().get(ROLES_TOKEN);
			if (roles != null && roles.contains(MDC_EDITOR_TOKEN)) {
				session.setAttribute(HomeController.ADMIN_TYPE, MDC_EDITOR_TOKEN);
			}
			if (roles != null && roles.contains(ISG_ADMIN_TOKEN)) {
				session.setAttribute(HomeController.ADMIN_TYPE, ISG_ADMIN_TOKEN);
			}
		}
		session.setAttribute("userId", auth0User.getUserId());
		return auth0User;
	}
}
