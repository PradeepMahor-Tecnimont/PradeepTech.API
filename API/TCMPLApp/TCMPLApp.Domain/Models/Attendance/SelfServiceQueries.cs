using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.SelfService
{
    public static class SelfServiceQueries
    {
        // Lists
        #region S E L E C T   L I S T S

        public static string CategorySelectList
        {
            get => @"select categoryid DataValueField, categorydesc DataTextField from timecurr.hr_category_master order by categorydesc";
        } 
        
        public static string LeaveTypeSelectList
        {
            get => @"selfservice.iot_select_list_qry.fn_leave_type_list";
        }  public static string ApproverSelectList
        {
            get => @"selfservice.iot_select_list_qry.fn_approvers_list";
        }


        #endregion S E L E C T   L I S T S


        #region Roles & Actions Query
        public static string SelfServiceUserRolesActions
        {
            get => @" select role_id, action_id from tcmpl_app_config.vu_module_user_role_actions where Empno = :pEmpno  and module_id = :pModuleId";
        }
        #endregion



    }

}
