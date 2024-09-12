--------------------------------------------------------
--  File created - Saturday-April-09-2022   
--------------------------------------------------------
---------------------------
--Changed PACKAGE
--PKG_ABSENT_TS
---------------------------
CREATE OR REPLACE PACKAGE "SELFSERVICE"."PKG_ABSENT_TS" As
    Procedure generate_nu_list_4_all_emp (
        param_absent_yyyymm    Varchar2,
        param_payslip_yyyymm   Varchar2,
        param_requester        Varchar2,
        param_success          Out                    Varchar2,
        param_message          Out                    Varchar2
    );

    Procedure pop_timesheet_leave_data (
        param_yyyymm    Varchar2,
        param_success   Out             Varchar2,
        param_message   Out             Varchar2
    );

    Procedure update_no_mail_list (
        param_absent_yyyymm        Varchar2,
        param_payslip_yyyymm       Varchar2,
        param_emp_list_4_no_mail   Varchar2,
        param_requester            Varchar2,
        param_success              Out                        Varchar2,
        param_message              Out                        Varchar2
    );

    Function get_lop (
        param_empno Varchar2,
        param_pdate Date
    ) Return Number;

    Procedure regenerate_list_4_one_emp (
        param_absent_yyyymm    Varchar2,
        param_payslip_yyyymm   Varchar2,
        param_empno            Varchar2,
        param_requester        Varchar2,
        param_success          Out                    Varchar2,
        param_message          Out                    Varchar2
    );

    Procedure set_lop_4_emp (
        param_empno            Varchar2,
        param_absent_yyyymm    Varchar2,
        param_payslip_yyyymm   Varchar2,
        param_lop_val          Varchar2,
        param_requester        Varchar2,
        param_success          Out                    Varchar2,
        param_message          Out                    Varchar2
    );

    Procedure reset_emp_lop (
        param_absent_yyyymm    Varchar2,
        param_payslip_yyyymm   Varchar2,
        param_empno            Varchar2,
        param_requester        Varchar2,
        param_success          Out                    Varchar2,
        param_message          Out                    Varchar2
    );

    Procedure delete_user_lop (
        param_empno            Varchar2,
        param_payslip_yyyymm   Varchar2,
        param_absent_yyyymm    Varchar2,
        param_requester        Varchar2,
        param_success          Out                    Varchar2,
        param_message          Out                    Varchar2
    );

    Function is_emp_absent (
        param_empno   In            Varchar2,
        param_date    In            Date
    ) Return Number;

    Procedure refresh_absent_list (
        param_absent_yyyymm    Varchar2,
        param_payslip_yyyymm   Varchar2,
        param_requester        Varchar2,
        param_success          Out                    Varchar2,
        param_message          Out                    Varchar2
    );

    Procedure reverse_lop_4_emp (
        param_empno            Varchar2,
        param_payslip_yyyymm   Varchar2,
        param_lop_val          Varchar2,
        param_requester        Varchar2,
        param_success          Out                    Varchar2,
        param_message          Out                    Varchar2
    );


    Procedure send_absent_email(
        p_payslip_yyyymm Varchar2,
        p_absent_yyyymm  Varchar2,
        p_success Out    Varchar2,
        p_message Out    Varchar2
    ) ;

    c_absent_mail_sub Varchar2(100) := 'SELFSERVICE : Leave Applications / on duty applications are pending for the month of !@MONTH@!';

    c_absent_mail_body varchar2(2000) := '<div>
<p>Please check your TimeSheet for the month of <strong><span style=''background-color: #ffff00;''>!@MONTH@!</span> </strong>and submit your <span style=''background-color: #ffff00;''><strong>Leave / On duty /on Deputation application/s </strong></span>which have not yet been submitted.</p>
<p>You are requested to do the needful at the earliest.</p>
<p>This mail has been generated based upon your LEAVE HOURS booked in TimeSheet for the month of <strong><span style=''background-color: #ffff00;''>!@MONTH@!</span> </strong></p>
<p><strong>For any queries please email at <a href=''mailto:A.Kotian@tecnimont.in''>A.Kotian@tecnimont.in</a></strong></p>
<p><strong>Or call on Teams</strong></p>
<div>
<p>Regards,</p>
<p> </p>
<p><strong>A. B. Kotian</strong></p>
<p><strong>HR Dept</strong></p>
<p>Tecnimont Private Limited</p>
<p>(Formerly Tecnimont ICB Pvt Ltd)</p>
<p>Tecnimont House, Chincholi Bunder, 504, Link Road, Malad (W),</p>
<p>Mumbai 400064 - India</p>
<p>P +91 22 6694 5631 - F +91 22 6694 5599</p>
<p><a href=''mailto:a.kotian@tecnimont.in''>a.kotian@tecnimont.in</a></p>
</div>
</div>';

End pkg_absent_ts;
/
