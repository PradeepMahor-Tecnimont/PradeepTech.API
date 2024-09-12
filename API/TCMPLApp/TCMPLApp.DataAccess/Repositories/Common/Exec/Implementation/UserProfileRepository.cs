using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models;

using System.Dynamic;

namespace TCMPLApp.DataAccess.Repositories.Common
{
    public class UserProfileRepository : ExecRepository, IUserProfileRepository
    {
        public UserProfileRepository(ExecDBContext execDBContext) : base(execDBContext)
        {
            //D o   N o t   m a k e   a n y   c h a n g e s   t o   t h i s   f i l e 
        }

        public async Task<AppModuleUserAccessModel> UserModuleAccessAsync(AppModuleUserAccessModel appModuleUserAccessModel)
        {
            return await ExecuteProcAsync(appModuleUserAccessModel);
            //D o   N o t   m a k e   a n y   c h a n g e s   t o   t h i s   f i l e 
        }

        public AppModuleUserAccessModel UserModuleAccess(AppModuleUserAccessModel appModuleUserAccessModel)
        {
            return ExecuteProc(appModuleUserAccessModel);
            //D o   N o t   m a k e   a n y   c h a n g e s   t o   t h i s   f i l e 
        }

        public async Task<AppModuleUserDetailsModel> UserDetailsAsync(AppModuleUserDetailsModel appModuleUserDetailsModel)
        {
            return await ExecuteProcAsync(appModuleUserDetailsModel);
            //D o   N o t   m a k e   a n y   c h a n g e s   t o   t h i s   f i l e 
        }

        public AppModuleUserDetailsModel UserDetails(AppModuleUserDetailsModel appModuleUserDetailsModel)
        {
            return ExecuteProc(appModuleUserDetailsModel);
            //D o   N o t   m a k e   a n y   c h a n g e s   t o   t h i s   f i l e 
        }

        public async Task<IEnumerable<ProfileAction>> UserProfileActionsAsync(string module, string empno)
        {
            IEnumerable<ProfileAction> profileAction = Enumerable.Empty<ProfileAction>();
            if (module.ToUpper() == ConstantsHelper.ModuleOffBoarding)
            {
                profileAction = await QueryAsync<ProfileAction>(Domain.Models.OffBoarding.OffBoardingQueries.ProfileActions, new { pEmpno = empno, pModule = module });
            }
            else if (module.ToUpper() == ConstantsHelper.ModuleSWPVaccine)
            {
                profileAction = await QueryAsync<ProfileAction>(Domain.Models.SWPVaccine.SWPVaccineQueries.SWPVaccineUserRolesActions, new { pEmpno = empno, pModuleId = ConstantsHelper.IDModuleSWPVaccine });
            }
            else if (module.ToUpper() == ConstantsHelper.ModuleHRMasters)
            {
                profileAction = await QueryAsync<ProfileAction>(Domain.Models.HRMasters.HRMastersQueries.HRMAstersUserRolesActions, new { pEmpno = empno, pModuleId = ConstantsHelper.IDModuleHRMasters });
            }
            else if (module.ToUpper() == ConstantsHelper.ModuleSelfService)
            {
                profileAction = await QueryAsync<ProfileAction>(Domain.Models.SelfService.SelfServiceQueries.SelfServiceUserRolesActions, new { pEmpno = empno, pModuleId = ConstantsHelper.IDModuleSelfService });
            }
            else if (module.ToUpper() == ConstantsHelper.ModuleSWP)
            {
                profileAction = await QueryAsync<ProfileAction>(Domain.Models.SWP.SWPQueries.SWPUserRolesActions, new { pEmpno = empno, pModuleId = ConstantsHelper.IDModuleSWP });
            }
            else if (module.ToUpper() == ConstantsHelper.ModuleRapReporting)
            {
                profileAction = await QueryAsync<ProfileAction>(Domain.Models.RapReporting.RapReportingQueries.RAPUserRolesActions, new { pEmpno = empno, pModuleId = ConstantsHelper.IDModuleRapReporting });
            }
            //else if (module.ToUpper() == ConstantsHelper.ModuleLC)
            //{
            //    profileAction = await QueryAsync<ProfileAction>(Domain.Models.LC.LCQueries.LCUserRolesActions, new { pEmpno = empno, pModuleId = ConstantsHelper.IDModuleLC });
            //}
            else if (module.ToUpper() == ConstantsHelper.ModuleHSE)
            {
                profileAction = await QueryAsync<ProfileAction>(Domain.Models.HSE.HSEQueries.HSEUserRolesActions, new { pEmpno = empno, pModuleId = ConstantsHelper.IDModuleHSE });
            }
            else if (module.ToUpper() == ConstantsHelper.ModuleJOB)
            {
                profileAction = await QueryAsync<ProfileAction>(Domain.Models.JOB.JOBQueries.JOBUserRolesActions, new { pEmpno = empno, pModuleId = ConstantsHelper.IDModuleJOB });
            }
            else if (module.ToUpper() == ConstantsHelper.ModuleTimesheet)
            {
                profileAction = await QueryAsync<ProfileAction>(Domain.Models.Timesheet.TimesheetQueries.TimesheetUserRolesActions, new { pEmpno = empno, pModuleId = ConstantsHelper.IDModuleTimesheet });
            }
            return profileAction;
            
            //D o   N o t   m a k e   a n y   c h a n g e s   t o   t h i s   f i l e 
        }

        public IEnumerable<ProfileAction> UserProfileActions(string module, string empno)
        {
            IEnumerable<ProfileAction> profileAction = Enumerable.Empty<ProfileAction>();
            if (module.ToUpper() == ConstantsHelper.ModuleOffBoarding)
            {
                profileAction = Query<ProfileAction>(Domain.Models.OffBoarding.OffBoardingQueries.ProfileActions, new { pEmpno = empno, pModule = module });
            }
            else if (module.ToUpper() == ConstantsHelper.ModuleHRMasters)
            {
                profileAction = Query<ProfileAction>(Domain.Models.HRMasters.HRMastersQueries.HRMAstersUserRolesActions, new { pEmpno = empno, pModuleId = ConstantsHelper.IDModuleHRMasters });
            }
            return profileAction;
            //D o   N o t   m a k e   a n y   c h a n g e s   t o   t h i s   f i l e 
        }
    }
}