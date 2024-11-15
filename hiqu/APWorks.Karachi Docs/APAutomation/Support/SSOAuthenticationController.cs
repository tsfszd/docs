using System;
using System.Collections.Generic;
using System.Security.Authentication;
using System.Security.Cryptography.X509Certificates;
using System.Threading.Tasks;

using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;

using ITfoxtec.Identity.Saml2;
using ITfoxtec.Identity.Saml2.MvcCore;
using ITfoxtec.Identity.Saml2.Schemas;

using APAutomation.Common.MultiTenantSecurity.Controllers;
using APAutomation.Common.Security.Services;
using APAutomation.Common.Utilities;

namespace APAutomation.Common.Security.Controllers
{
	[AllowAnonymous]
	[Route("SSOAuthentication")]
	public class SSOAuthenticationController : MultiTenantController
	{
		const string relayStateReturnUrl = "ReturnUrl";

		private readonly IUserService _userService;

		public SSOAuthenticationController()
		{
			_userService = new UserService();
		}

		[Route("Login")]
		public IActionResult Login(string returnUrl = null)
		{
			using (LogUtility<SSOAuthenticationController>.Logger.BeginScope($"SSOAuthenticationController.Login(returnUrl:{returnUrl})"))
			{
				IActionResult actionResult = null;

				try
				{
					LogUtility<SSOAuthenticationController>.Logger.LogDebug("before var domain = GetDomain();");
					var domain = GetDomain();

					LogUtility<SSOAuthenticationController>.Logger.LogDebug("domain.SsoType " + domain.SsoType);

					if (String.IsNullOrEmpty(domain.SsoType))
					{
						return Redirect(Url.Content("~/"));
					}

					var binding = new Saml2RedirectBinding();

					binding.SetRelayStateQuery(new Dictionary<string, string> { { relayStateReturnUrl, returnUrl ?? Url.Content("~/") } });

					LogUtility<SSOAuthenticationController>.Logger.LogDebug("before var config = GetConfig();");
					var config = GetConfig(domain);

					LogUtility<SSOAuthenticationController>.Logger.LogDebug("before var saml2Request = new Saml2AuthnRequest(config);");
					var saml2Request = new Saml2AuthnRequest(config);

					LogUtility<SSOAuthenticationController>.Logger.LogDebug("before var actionResult = binding.Bind(saml2Request).ToActionResult();");
					actionResult = binding.Bind(saml2Request).ToActionResult();
				}
				catch (Exception exception)
				{
					returnUrl = "/error?message=" + exception.Message;
					actionResult = Redirect(returnUrl);
				}

				LogUtility<SSOAuthenticationController>.Logger.LogDebug("actionResult.ToString()" + actionResult.ToString());

				return actionResult;
			}
		}

		[Route("acs")]
		public async Task<IActionResult> AssertionConsumerService()
		{
			using (LogUtility<SSOAuthenticationController>.Logger.BeginScope($"SSOAuthenticationController.AssertionConsumerService()"))
			{
				string returnUrl = string.Empty;

				try
				{
					var config = GetConfig();
					var saml2AuthnResponse = new Saml2AuthnResponse(config);

					var binding = new Saml2PostBinding();
					LogUtility<SSOAuthenticationController>.Logger.LogDebug("before: binding.ReadSamlResponse(Request.ToGenericHttpRequest(), saml2AuthnResponse);");
					binding.ReadSamlResponse(Request.ToGenericHttpRequest(), saml2AuthnResponse);

					LogUtility<SSOAuthenticationController>.Logger.LogDebug("before: saml2AuthnResponse.Status != Saml2StatusCodes.Success " + (saml2AuthnResponse.Status != Saml2StatusCodes.Success));

					if (saml2AuthnResponse.Status != Saml2StatusCodes.Success)
					{
						throw new AuthenticationException($"SAML Response status: {saml2AuthnResponse.Status}");
					}

					LogUtility<SSOAuthenticationController>.Logger.LogDebug("saml2AuthnResponse.Status " + saml2AuthnResponse.Status);
					LogUtility<SSOAuthenticationController>.Logger.LogDebug("before binding.Unbind(Request.ToGenericHttpRequest(), saml2AuthnResponse)");
					binding.Unbind(Request.ToGenericHttpRequest(), saml2AuthnResponse);

					LogUtility<SSOAuthenticationController>.Logger.LogDebug("before : await saml2AuthnResponse.CreateSession(HttpContext, claimsTransform: (claimsPrincipal) => ClaimsTransform.Transform(claimsPrincipal));");
					await saml2AuthnResponse.CreateSession(HttpContext, claimsTransform: (claimsPrincipal) => ClaimsTransform.Transform(claimsPrincipal));

					LogUtility<SSOAuthenticationController>.Logger.LogDebug("saml2AuthnResponse.ClaimsIdentity.Name" + saml2AuthnResponse.ClaimsIdentity.Name);

					var email = saml2AuthnResponse.ClaimsIdentity.Name;
					var user = _userService.Authenticate(Client, email, true);

					var relayStateQuery = binding.GetRelayStateQuery();

					returnUrl = relayStateQuery.ContainsKey(relayStateReturnUrl) ? relayStateQuery[relayStateReturnUrl] : Url.Content("~/");
					returnUrl += user != null ? $"login?ssotoken={user.Token}&email={email}" : "loginerror?message=Unauthorized User";
				}
				catch (Exception exception)
				{
					returnUrl = "/error?message=" + exception.Message;
				}

				LogUtility<SSOAuthenticationController>.Logger.LogDebug("returnUrl: " + returnUrl);

				return Redirect(returnUrl);
			}
		}

		[Route("Logout")]
		public async Task<IActionResult> Logout()
		{
			using (LogUtility<SSOAuthenticationController>.Logger.BeginScope($"SSOAuthenticationController.Logout()"))
			{
				IActionResult actionResult = null;

				try
				{
					LogUtility<SSOAuthenticationController>.Logger.LogDebug("Logout");

					var config = GetConfig();
					Saml2StatusCodes status;
					var requestBinding = new Saml2RedirectBinding();
					var logoutRequest = new Saml2LogoutRequest(config, User);
					try
					{
						requestBinding.Unbind(Request.ToGenericHttpRequest(), logoutRequest);
						status = Saml2StatusCodes.Success;
						await logoutRequest.DeleteSession(HttpContext);
					}
					catch (Exception exc)
					{
						// log exception
						LogUtility<SSOAuthenticationController>.Logger.LogDebug("SingleLogout error: " + exc.ToString());
						status = Saml2StatusCodes.RequestDenied;
					}

					var responsebinding = new Saml2RedirectBinding();
					responsebinding.RelayState = requestBinding?.RelayState;
					var saml2LogoutResponse = new Saml2LogoutResponse(config)
					{
						InResponseToAsString = logoutRequest.IdAsString,
						Status = status,
					};
					actionResult = responsebinding.Bind(saml2LogoutResponse).ToActionResult();

				}
				catch (Exception exception)
				{
					var returnUrl = "/error?message=" + exception.Message;
					actionResult = Redirect(returnUrl);
				}

				return actionResult;
			}
		}

		[Route("LoggedOut")]
		public IActionResult LoggedOut()
		{
			using (LogUtility<SSOAuthenticationController>.Logger.BeginScope($"SSOAuthenticationController.LoggedOut()"))
			{
				var config = GetConfig();

				var binding = new Saml2RedirectBinding();
				binding.Unbind(Request.ToGenericHttpRequest(), new Saml2LogoutResponse(config));

				return Redirect(Url.Content("~/"));
			}
		}

		private Saml2Configuration GetConfig(DocumentModel.DTO.EntDomain domain = null)
		{
			LogUtility<SSOAuthenticationController>.Logger.LogDebug("GetConfig");

			if (domain == null)
			{
				domain = GetDomain();
			}
			var config = new Saml2Configuration();

			X509Certificate2 x509Certificate2 = null;
			try
			{
				var rawData = Convert.FromBase64String(domain.SigningAuthorityCertificate);
				x509Certificate2 = new X509Certificate2(rawData);
			}
			catch (Exception exception)
			{
				throw new Exception("Invalid Certificate " + exception.Message);
			}

			config.Issuer = $"https://{Request.Host}/";
			LogUtility<SSOAuthenticationController>.Logger.LogDebug("config.Issuer " + config.Issuer);
			LogUtility<SSOAuthenticationController>.Logger.LogDebug("domain.SsoLoginUrl " + domain.SsoLoginUrl);
			LogUtility<SSOAuthenticationController>.Logger.LogDebug("domain.SsoLogoutUrl " + domain.SsoLogoutUrl);

			config.AllowedAudienceUris.Add(config.Issuer);
			config.SingleSignOnDestination = new Uri(domain.SsoLoginUrl);
			config.SingleLogoutDestination = new Uri(domain.SsoLogoutUrl);
			config.SignatureValidationCertificates.Add(x509Certificate2);

			return config;
		}
	}
}
