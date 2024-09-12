using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.OffBoarding
{
    public static class OffBoardingQueries
    {
        public static string ProfileActions
        {
            get => @"Select
                        role_id,
                        action_id
                    From
                        tcmpl_hr.ofb_vu_user_roles_actions
                    Where
                        empno = :pEmpno";
        }

        public static string GetActions
        {
            get => @" Select
                        action_id,
                        role_id,
                        action_name,
                        action_desc,
                        is_action_for_hod,
                        hod_costcode,
                        checker_action_id,
                        group_name
                    From
                        tcmpl_hr.ofb_role_actions
                    Where
                        action_id = :pActionId";
        }

        public static string InitOffBoardingExitList
        {
            get => @"
                    Select
                        ee.empno,
                        ee.employee_name,
                        ee.grade,
                        ee.parent,
                        ee.dept_name,
                        ee.end_by_date,
                        ee.initiator_remarks,
                        ee.relieving_date,
                        ee.created_by,
                        ee.created_on,
                        tcmpl_hr.ofb_approval_status.overall_approval_status(
                            ee.empno
                        ) overall_approval_status
                    From
                        tcmpl_hr.ofb_vu_emp_exits ee
                    order by ee.relieving_date";
        }

        public static string InitOffBoardingExitContactDetailsList
        {
            get => @"
                    Select
                        empno,
                        employee_name,
                        personid,
                        grade,
                        parent,
                        dept_name,
                        desgcode,
                        desgdesc,
                        doj,
                        dol,
                        relieving_date,
                        resignation_date,
                        mobile_primary,
                        alternate_number,
                        email_id
                    From
                        tcmpl_hr.ofb_vu_emp_exits
                    where relieving_date between :pStartDate and :pEndDate                  
                ";
        }

        public static string GetEmployeeExitDetails
        {
            get => @" Select * from tcmpl_hr.ofb_vu_emp_exits where empno=:pEmpno";
        }


        public static string MakerOffBoardingExitList
        {
            get => @"Select ee.empno,
                            ee.employee_name,
                            ee.grade,
                            ee.parent,
                            ee.dept_name,
                            ee.end_by_date,
                            ee.resignation_date,
                            ee.initiator_remarks,
                            ee.relieving_date,
                            ee.created_by,
                            ee.created_on,
                            tcmpl_hr.ofb_approval_status.get_approval_desc(ee.empno, :pApproverEmpno, :pApproverRoleId) approval_status
                        From tcmpl_hr.OFB_VU_EMP_EXITS ee
                        Where
                            ee.empno In (
                                Select
                                    empno
                                From
                                    tcmpl_hr.ofb_emp_exit_approvals
                                Where
                                    replace(nvl(is_approved,'KO'),'OO','KO') = :pApprovalStatus
                                    And action_id In (
                                        Select
                                            action_id
                                        From
                                            tcmpl_hr.ofb_vu_user_roles_actions
                                        Where
                                            empno = :pApproverEmpno
                                            And role_id = :pApproverRoleId
                                            And action_id Is Not Null
                                    )
                            ) order by ee.relieving_date";
        }

        public static string ApproverOffBoardingExitList
        {
            get => @"Select ee.empno,
                            ee.employee_name,
                            ee.grade,
                            ee.parent,
                            ee.dept_name,
                            ee.end_by_date,
                            ee.initiator_remarks,
                            ee.relieving_date,
                            ee.created_by,
                            ee.created_on,
                            tcmpl_hr.ofb_approval_status.check_child_approvals(
                                empno,
                                :pApproverEmpno,
                                :pActionId
                            ) first_approval_status
                        From tcmpl_hr.OFB_VU_EMP_EXITS ee
                        Where
                            ee.empno In (
                                Select
                                    empno
                                From
                                    tcmpl_hr.ofb_emp_exit_approvals
                                Where
                                    replace(nvl(is_approved,'KO'),'OO','KO') = :pApprovalStatus
                                    And action_id In (
                                        Select
                                            action_id
                                        From
                                            tcmpl_hr.ofb_vu_user_roles_actions
                                        Where
                                            empno = :pApproverEmpno
                                            And role_id = :pApproverRoleId
                                            And action_id Is Not Null
                                    )
                            ) order by ee.relieving_date";
        }

        public static string HoDOffBoardingExitList
        {
            get => @"
                    Select
                        ee.empno,
                        ee.employee_name,
                        ee.grade,
                        ee.parent,
                        ee.dept_name,
                        ee.end_by_date,
                        ee.initiator_remarks,
                        ee.relieving_date,
                        ee.created_by,
                        ee.created_on
                    From
                        tcmpl_hr.ofb_vu_emp_exits ee
                    Where
                        ee.empno In (
                            Select
                                empno
                            From
                                tcmpl_hr.ofb_emp_exit_approvals
                            Where
                                replace(nvl(is_approved,'KO'),'OO','KO') = :pApprovalStatus
                                And action_id In (
                                    Select
                                        action_id
                                    From
                                        tcmpl_hr.ofb_vu_user_roles_actions
                                    Where
                                        empno       = :pApproverEmpno
                                        And role_id = :pApproverRoleid
                                        And action_id Is Not Null
                                )
                                And parent In (
                                    Select
                                        costcode
                                    From
                                        tcmpl_hr.ofb_vu_costmast
                                    Where
                                        hod = :pApproverEmpno
                                )
                        ) order by ee.relieving_date";
        }

        public static string HRManagerOffBoardingExitList
        {
            get => @"
                    Select
                        ee.empno,
                        ee.employee_name,
                        ee.grade,
                        ee.parent,
                        ee.dept_name,
                        ee.end_by_date,
                        ee.initiator_remarks,
                        ee.relieving_date,
                        ee.created_by,
                        ee.created_on,
                        tcmpl_hr.ofb_approval_status.hr_manager_can_approve(ee.empno) hr_manager_can_approve
                    From
                        tcmpl_hr.ofb_vu_emp_exits ee
                    Where
                        ee.empno In (
                            Select
                                empno
                            From
                                tcmpl_hr.ofb_emp_exit_approvals
                            Where
                                replace(nvl(is_approved,'KO'),'OO','KO') = :pApprovalStatus
                                And action_id In (
                                    Select
                                        action_id
                                    From
                                        tcmpl_hr.ofb_vu_user_roles_actions
                                    Where
                                        empno       = :pApproverEmpno
                                        And role_id = :pApproverRoleId
                                        And action_id Is Not Null
                                )
                        ) order by ee.relieving_date";
        }


        public static string GetExitsApprovalDetail
        {
            get => @" Select
                            empno,
                            emp_name,
                            action_id,
                            action_desc,
                            remarks,
                            is_approved,
                            is_approved_desc,
                            approval_date,
                            approved_by,
                            approver_name
                        From
                            tcmpl_hr.ofb_vu_emp_exit_approvals 
    
                        Where
                            empno = :pEmpno 
                            and action_id = :pActionId ";
        }

        public static string GetDescendantExitApprovals
        {
            get => @"Select
                        empno,
                        emp_name,
                        action_id,
                        action_desc,
                        role_id,
                        remarks,
                        is_approved,
                        is_approved_desc,
                        approval_date,
                        approved_by,
                        approver_name
                    From
                        tcmpl_hr.ofb_vu_emp_exit_approvals
                    Where
                        empno = :pOFBEmpno
                        And action_id In (
                            Select
                                action_id
                            From
                                tcmpl_hr.ofb_role_actions
                            Where
                                checker_action_id = :pSecondApproverActionId
                        )";
            }

        public static string GetGroupApprovals
        {
            get => @"   Select
                                 empno,
                                 emp_name,
                                 action_id,
                                 action_desc,
                                 role_id,
                                 remarks,
                                 is_approved,
                                 is_approved_desc,
                                 approval_date,
                                 approved_by,
                                 approver_name
                        From
                           (
                              Select
                                 empno,
                                 emp_name,
                                 action_id,
                                 action_desc,
                                 role_id,
                                 remarks,
                                 is_approved,
                                 is_approved_desc,
                                 approval_date,
                                 approved_by,
                                 approver_name,
                                 checker_action_id
                              From
                                 tcmpl_hr.ofb_vu_emp_exit_approvals
                              Where
                                 empno = :pofbempno
                           )
                        Start
                        With
                           action_id = :pCheckerActionId
                        Connect By
                           Prior action_id = checker_action_id";
        }

        public static string GetDepartmentExitApprovals
        {
            get => @"Select
                        empno,
                        emp_name,
                        action_id,
                        action_desc,
                        role_id,
                        remarks,
                        is_approved,
                        is_approved_desc,
                        approval_date,
                        approved_by,
                        nvl(approver_name, tcmpl_hr.ofb_user.get_emp_name_csv_for_action_id(action_id)) approver_name,
                        group_desc group_name,
                        Lag(group_desc,1,'-') Over(Order By sort_order) As prev_group_name
                    From
                        tcmpl_hr.ofb_vu_emp_exit_approvals
                    Where
                        empno = :pOFBEmpno";
        }


        public static string EmployeeForExitsSelect
        {
            get => @"Select
                            empno || ' - ' || name As text,
                            empno As val
                        From
                            tcmpl_hr.ofb_vu_emplmast
                        Where
                            empno Not In (
                                Select
                                    empno
                                From
                                    tcmpl_hr.ofb_emp_exits
                            )
                            And status = 1 order by empno";
        }

        public static string GetEmployeeContactInfo
        {
            get => @"
                    Select
                        empno,
                        address,
                        mobile_primary,
                        alternate_number,
                        modified_on
                    From
                        tcmpl_hr.ofb_emp_contact_info
                    Where
                        empno = :pEmpno";
        }


        public static  string GetUserRolesActions
        {
            get => @"
                    Select
                        empno,
                        name,
                        parent,
                        action_id,
                        action_name,
                        action_desc,
                        group_name,
                        hod_costcode,
                        is_action_for_hod,
                        role_id,
                        checker_action_id,
                        role_name,
                        role_desc
                    From
                        tcmpl_hr.ofb_vu_user_roles_actions
                    Where
                        action_id is null or
                        action_id <> 'A17' ";
        }
        public static string GetRolesActions
        {
            get => @"
                    Select
                        action_id val,
                        action_desc text
                    From
                        tcmpl_hr.ofb_role_actions
                    Union
                    Select
                        role_id,
                        role_desc
                    From
                        tcmpl_hr.ofb_roles
                    Where
                        role_id Not In (
                            Select
                                role_id
                            From
                                tcmpl_hr.ofb_role_actions
                        )
                        And role_id Not In (
                            'R11'
                        )";
        }


        public static string GetFilesUploaded
        {
            get => @"Select
                        key_id,
                        empno,
                        tcmpl_hr.ofb_user.get_name_from_empno(p_empno => empno)                  employee_name,
                        upload_by_group,
                        upload_by_empno,
                        tcmpl_hr.ofb_user.get_name_from_empno(p_empno => upload_by_empno)        upload_by_employee_name,
                        client_file_name,
                        server_file_name,
                        upload_date
                    From
                        tcmpl_hr.ofb_files
                    Where empno = :pEmpno";
        }


        public static string GetFilesUploadedByGroup
        {
            get => @"Select
                        key_id,
                        empno,
                        tcmpl_hr.ofb_user.get_name_from_empno(p_empno => empno)                  employee_name,
                        upload_by_group,
                        upload_by_empno,
                        tcmpl_hr.ofb_user.get_name_from_empno(p_empno => upload_by_empno)        upload_by_employee_name,
                        client_file_name,
                        server_file_name,
                        upload_date
                    From
                        tcmpl_hr.ofb_files
                    Where empno = :pEmpno
                        and trim(upload_by_group) = trim(:pGroupName)";
        }

        public static string GetFileUploadedByKeyId
        {
            get => @"Select
                        key_id,
                        empno,
                        tcmpl_hr.ofb_user.get_name_from_empno(p_empno => empno)                  employee_name,
                        upload_by_group,
                        upload_by_empno,
                        tcmpl_hr.ofb_user.get_name_from_empno(p_empno => upload_by_empno)        upload_by_employee_name,
                        client_file_name,
                        server_file_name,
                        upload_date
                    From
                        tcmpl_hr.ofb_files
                    Where key_id = :pKeyId";
        }

    }


}
