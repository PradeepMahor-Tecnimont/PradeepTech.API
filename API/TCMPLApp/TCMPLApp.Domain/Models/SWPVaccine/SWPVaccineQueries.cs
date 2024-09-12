using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.SWPVaccine
{
    public static class SWPVaccineQueries
    {
        public static string GetEmployeeDetails { get => @" Select
                                                        a.empno,
                                                        a.name,
                                                        a.parent,
                                                        b.name   As costname,
                                                        b.sapcc  As sapcc,
                                                        a.assign,
                                                        e.name   assignname,
                                                        e.sapcc  As sapccassign,
                                                        a.emptype,
                                                        a.grade,
                                                        a.desgcode,
                                                        c.desg   As desgname,
                                                        a.doj,
                                                        b.hod,
                                                        selfservice.get_emp_name(
                                                            b.hod
                                                        ) As hodname,
                                                        b.secretary,
                                                        selfservice.get_emp_name(
                                                            b.secretary
                                                        ) As sec_name,
                                                        a.grade,
                                                        d.card_rfid,
                                                        a.personid,
                                                        a.metaid,
                                                        selfservice.get_emp_name(
                                                            a.mngr
                                                        ) mngr_name,
                                                        To_Char(Nvl(d.card_rfid, 0), Lpad('X', Length(To_Char(Nvl(d.card_rfid, 0))), 'X')) hexa_card_rfid
                                                    From
                                                        SELFSERVICE.ss_emplmast              a,
                                                        SELFSERVICE.ss_costmast              b,
                                                        SELFSERVICE.ss_costmast              e,
                                                        SELFSERVICE.ss_desgmast              c,
                                                        SELFSERVICE.ss_emplmast_supplement   d
                                                    Where
                                                        a.parent = b.costcode
                                                        And a.assign    = e.costcode
                                                        And a.desgcode  = c.desgcode
                                                        And a.empno     = :emp
                                                        And a.empno     = d.empno (+) "; }

        public static string GetEmployeeTrainings { get => @"Select
                                                                t.empno,
                                                                e.name   employee_name,
                                                                e.parent,
                                                                c.name   dept_desc,
                                                                e.grade,
                                                                e.emptype,
                                                                t.security,
                                                                t.sharepoint16,
                                                                t.onedrive365,
                                                                t.teams,
                                                                t.planner
                                                            From
                                                                SELFSERVICE.swp_emp_training   t,
                                                                SELFSERVICE.ss_emplmast        e,
                                                                SELFSERVICE.ss_costmast        c
                                                            Where
                                                                t.empno = e.empno
                                                                And e.parent  = c.costcode
                                                                And e.status  = 1"; }
    
        public static string HoDSWPPendingApprovals { get => @"Select
                                                                        *
                                                                    From
                                                                        SELFSERVICE.swp_vu_emp_response
                                                                    Where
                                                                        empno In (
                                                                            Select
                                                                                empno
                                                                            From
                                                                                SELFSERVICE.ss_emplmast
                                                                            Where
                                                                                parent In (
                                                                                    Select
                                                                                        costcode
                                                                                    From
                                                                                        SELFSERVICE.ss_costmast
                                                                                    Where
                                                                                        hod = SELFSERVICE.swp_users.get_empno_from_win_uid(
                                                                                            :param_win_uid
                                                                                        )
                                                                                )
                                                                        )"; }

        #region Roles & Actions Query
        public static string SWPVaccineUserRolesActions
        {
            get => @" select role_id, action_id from tcmpl_app_config.vu_module_user_role_actions where Empno = :pEmpno  and module_id = :pModuleId";
        }
        #endregion


    }
}
