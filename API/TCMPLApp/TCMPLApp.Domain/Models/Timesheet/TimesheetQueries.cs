﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.Timesheet
{
    public static class TimesheetQueries
    {        
        #region Roles & Actions Query
        public static string TimesheetUserRolesActions
        {
            get => @" select role_id, action_id from tcmpl_app_config.vu_module_user_role_actions where Empno = :pEmpno  and module_id = :pModuleId";
        }
        #endregion
    }

}
