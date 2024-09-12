using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Configuration;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
//using TCMPLApp.WebApp.Lib.Models;
using TCMPLApp.WebApp.Models;
using TCMPLApp.WebApp.Classes;
using TCMPLApp.Domain.Models;
using TCMPLApp.DataAccess.Repositories.Common;
using Microsoft.Extensions.DependencyInjection;
using TCMPLApp.DataAccess.Models;
using Microsoft.Build.Framework;

namespace TCMPLApp.WebApp.Controllers
{
    public class BaseController : Controller
    {



        protected const string IsOk = "OK";
        protected const string NotOk = "KO";

        protected IUserProfileRepository UserProfileRepository => HttpContext.RequestServices.GetService<IUserProfileRepository>();
        protected ILogger Logger => HttpContext.RequestServices.GetService<ILogger>();
        protected UserIdentity CurrentUserIdentity => GetUserIdentityAsync().Result;

        private BaseSpTcmPL _baseSpTcmPL;
        private IConfiguration _configuration;


        protected BaseSpTcmPL BaseSpTcmPL => _baseSpTcmPL ??= HttpContext.RequestServices.GetService<BaseSpTcmPL>();
        protected IConfiguration Configuration => _configuration ??= HttpContext.RequestServices.GetService<IConfiguration>();

        public static string ToTitleCase(string str)
        {
            TextInfo myTI = new CultureInfo("en-US", false).TextInfo;
            return myTI.ToTitleCase(str);
        }

        public void Notify(string Title, string Message, string Provider, NotificationType notificationType)
        {
            var msg = new
            {
                message = Message,
                title = Title,
                icon = notificationType.ToString(),
                type = notificationType.ToString(),
                provider = Provider//GetProvider()
            };

            TempData["Message"] = JsonConvert.SerializeObject(msg);
        }

        protected BaseSpTcmPL BaseSpTcmPLGet()
        {
            BaseSpTcmPL.PPersonId = CurrentUserIdentity.EmployeeId;
            BaseSpTcmPL.PMetaId = CurrentUserIdentity.MetaId;
            BaseSpTcmPL.UIUserId = CurrentUserIdentity.UserId;
            return BaseSpTcmPL;
        }


        private async Task<UserIdentity> GetUserIdentityAsync()
        {


            if (HttpContext?.Items["UserIdentity"] != null)
            {
                return await Task.FromResult((UserIdentity)HttpContext.Items["UserIdentity"]);
            }
            else
            {
                AppModuleUserDetailsModel appModuleUserDetailsModel = new AppModuleUserDetailsModel { PWinUid = User.Identity.Name };
                var userDetails = await UserProfileRepository.UserDetailsAsync(appModuleUserDetailsModel);
                var oUserIdentity = new UserIdentity
                {
                    WinUID = User.Identity.Name,
                    Name = userDetails.OutPEmpName,
                    CostCode = userDetails.OutPCostcode,
                    EmpNo = userDetails.OutPEmpno
                };
                var moduleAccess = await UserProfileRepository.UserModuleAccessAsync(new AppModuleUserAccessModel { PWinUid = User.Identity.Name });
                if (moduleAccess.OutPSuccess == "OK" && string.IsNullOrEmpty(moduleAccess.OutPModulesCsv) == false)
                {
                    oUserIdentity.Modules = moduleAccess.OutPModulesCsv.Split(",");
                }
                return oUserIdentity;
            }
        }
    }
}