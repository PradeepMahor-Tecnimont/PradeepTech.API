using TCMPLApp.DataAccess.Models;
using TCMPLApp.DataAccess.Repositories.Attendance;

using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.DependencyInjection;
using System;
using System.Security.Claims;
using System.Collections.Generic;
using System.Threading.Tasks;
using System.Linq;
using TCMPLApp.Domain.Models;
using TCMPLApp.DataAccess.Repositories.Common;

namespace TCMPLApp.WebApi.Classes
{
    [Authorize]
    public abstract class BaseController<T> : ControllerBase where T : BaseController<T>
    {
        public string IsOk = "OK";
        public string NotOk = "KO";
        private ILogger<T> _logger;
        private UserIdentity _userIdentity;
        private BaseSpTcmPL _baseSpTcmpl;
        private IConfiguration _configuration;

        protected IUserProfileRepository UserProfileRepository => HttpContext.RequestServices.GetService<IUserProfileRepository>();

        protected ILogger<T> Logger => _logger ??= HttpContext?.RequestServices.GetService<ILogger<T>>();
        protected UserIdentity UserIdentity => _userIdentity ??= GetUserIdentityAsync().Result;
        protected BaseSpTcmPL BaseSpTcmPL => _baseSpTcmpl ??= HttpContext?.RequestServices.GetService<BaseSpTcmPL>();
        protected IConfiguration Configuration => _configuration ??= HttpContext?.RequestServices.GetService<IConfiguration>();

        #region User
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


        protected BaseSpTcmPL BaseSpTcmPLGet()
        {
            BaseSpTcmPL.PPersonId = UserIdentity.EmployeeId;
            BaseSpTcmPL.PMetaId = UserIdentity.MetaId;
            BaseSpTcmPL.UIUserId = UserIdentity.UserId;
            return BaseSpTcmPL;
        }

        #endregion
    }

}
