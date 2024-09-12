using System.DirectoryServices;
using System.DirectoryServices.AccountManagement;
using TCMPLApp.Domain.Models;

namespace TCMPLApp.WebApi.Middleware
{
    public class UserIdentityMiddleware
    {
        private readonly RequestDelegate _next;
        private static readonly string[] SkipMetaIds = { "-4E66BA1ED95ED6541B8", "-4E4D98651F9E0E1A8E7", "-42E18833E5B567B3BFB", "-499A8E26377BC3ECECE", "-41F9A1D98FBE637DE18", "-4A0BBFFFCE942B691C7" };
        public UserIdentityMiddleware(RequestDelegate next)
        {
            _next = next;
        }

        public async Task Invoke(HttpContext context, UserIdentity userIdentity)
        {
            context.Items["isMobile"] = false;

            if (!context.User.Identity.Name?.ToLower().StartsWith("tecnimont") ?? false)
            {
#pragma warning disable CA1416 // Validate platform compatibility
                using (var principalContext = new PrincipalContext(ContextType.Domain))
                {
                    var principal = UserPrincipal.FindByIdentity(principalContext, context.User.Identity.Name);


                    var extensionAttribute13 = ((DirectoryEntry)principal.GetUnderlyingObject())
                                                .Properties["extensionAttribute13"]?.Value as string;

                    userIdentity.EmployeeId = extensionAttribute13;

                    var extensionAttribute2 = ((DirectoryEntry)principal.GetUnderlyingObject())
                                                .Properties["extensionAttribute2"]?.Value as string;

                    userIdentity.MetaId = extensionAttribute2;

                }
#pragma warning restore CA1416 // Validate platform compatibility
            }
            //context.Items["UserIdentity"] = await Helper.GetUserIdentityAsync(context, userProfileRepository);

            var area = context.GetRouteData()?.Values["area"]?.ToString().ToUpper();

            AppModuleUserDetailsModel appModuleUserDetailsModel = new AppModuleUserDetailsModel
            {
                PWinUid = context.User.Identity.Name
            };

            context.Items["UserIdentity"] = userIdentity;


            await _next.Invoke(context);
        }
    }
}
