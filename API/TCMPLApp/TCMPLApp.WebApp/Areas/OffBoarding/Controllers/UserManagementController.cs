using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Repositories.OffBoarding;
using TCMPLApp.Domain.Models;
using TCMPLApp.Domain.Models.OffBoarding;
using TCMPLApp.WebApp.Controllers;
using TCMPLApp.WebApp.Models;

namespace TCMPLApp.WebApp.Areas.OffBoarding.Controllers
{
    [Area("OffBoarding")]
    public class UserManagementController : BaseController
    {
        private readonly IOffBoardingUserManagementRepository _offBoardingUserManagementRepositry;
        private readonly IOffBoardingExitRepository _offBoardingExitRepository;

        public UserManagementController(IOffBoardingUserManagementRepository offBoardingUserManagementRepository, IOffBoardingExitRepository offBoardingExitRepository)
        {
            _offBoardingUserManagementRepositry = offBoardingUserManagementRepository;
            _offBoardingExitRepository = offBoardingExitRepository;
        }

        public IActionResult Index()
        {
            return View();
        }

        public async Task<IActionResult> GetAllUserRolesActions()
        {
            var userRolesActions = await _offBoardingUserManagementRepositry.GetUserRolesActions();
            return PartialView("_UserRolesActionsPartial", userRolesActions);
        }

        public async Task<IActionResult> CreateUserAccess()
        {
            var empList = await _offBoardingExitRepository.GetEmployeeForExitsSelectAsync();

            ViewData["EmployeeList"] = new SelectList(empList, "Val", "Text");

            var rolesActions = await _offBoardingUserManagementRepositry.GetRolesActionsSelectAsync();
            ViewData["RolesActionsList"] = new SelectList(rolesActions, "Val", "Text");

            return PartialView("_UserRolesActionsCreatePartial");

        }

        [HttpPost]
        public async Task<IActionResult> CreateUserAccess(OffBoardingUserAccessCreateViewModel offBoardingUserAccessCreateViewModel)
        {
            var empList = await _offBoardingExitRepository.GetEmployeeForExitsSelectAsync();

            ViewData["EmployeeList"] = new SelectList(empList, "Val", "Text");

            var rolesActions = await _offBoardingUserManagementRepositry.GetRolesActionsSelectAsync();
            ViewData["RolesActionsList"] = new SelectList(rolesActions, "Val", "Text");
            if (!ModelState.IsValid)
            {
                return PartialView("_UserRolesActionsCreatePartial", offBoardingUserAccessCreateViewModel);
            }
            Domain.Models.OffBoarding.OffBoardingAddUserAccess addUserAccess = new Domain.Models.OffBoarding.OffBoardingAddUserAccess
            {
                PEmpno = offBoardingUserAccessCreateViewModel.Empno,
                PRoleActionId = offBoardingUserAccessCreateViewModel.RoleActionId
            };
            var retVal = await _offBoardingUserManagementRepositry.AddUserRolesActions(addUserAccess);

            if (retVal.OutPSuccess == "OK")
            {
                Notify("Success", "Changes succesfully saved", "toaster", notificationType: NotificationType.success);
                return RedirectToAction("CreateUserAccess");
            }
            else
            {
                Notify("Error", retVal.OutPMessage, "toaster", notificationType: NotificationType.error);
                return PartialView("_UserRolesActionsCreatePartial", offBoardingUserAccessCreateViewModel);
            }

        }


        [HttpPost]
        public async Task<IActionResult> RemoveUserAccess(string Empno, string RoleId, string ActionId)
        {
            try
            {
                OffBoardingRemoveUserRoleAction offBoardingRemoveUserRoleAction = new OffBoardingRemoveUserRoleAction
                {
                    PActionId = ActionId,
                    PEmpno = Empno,
                    PRoleId = RoleId,
                    PEntryByEmpno = CurrentUserIdentity.EmpNo
                };
                var retVal = await _offBoardingUserManagementRepositry.RemoveUserRolesActions(offBoardingRemoveUserRoleAction);


                return Json(new { success = retVal.OutPSuccess == "OK", message = retVal.OutPMessage });

            }
            catch (Exception ex)
            {
                //Notify("Error", ex.Message, "toaster", notificationType: NotificationType.error);
                return Json(new
                {
                    success = false,
                    message = ex.Message
                });
            }
        }
    }
}
