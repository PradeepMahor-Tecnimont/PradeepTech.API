using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.JOB
{
    public static class JOBQueries
    {
        // Lists
        #region S E L E C T   L I S T S


        //public static string SelectList
        //{
        //    get => @"tcmpl_afc.lc_select_list_qry.";
        //}

        #endregion S E L E C T   L I S T S


        #region Roles & Actions Query
        public static string JOBUserRolesActions
        {
            get => @" select role_id, action_id from tcmpl_app_config.vu_module_user_role_actions where Empno = :pEmpno  and module_id = :pModuleId";
        }
        #endregion
         
    }

}
