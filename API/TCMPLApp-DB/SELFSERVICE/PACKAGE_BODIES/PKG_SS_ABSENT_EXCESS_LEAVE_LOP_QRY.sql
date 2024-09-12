Create Or Replace Package Body selfservice.pkg_ss_absent_excess_leave_lop_qry As

    Function fn_absent_excess_leaves(
        p_person_id         Varchar2,
        p_meta_id           Varchar2,

        p_yyyymm            Varchar2,
        
        p_generic_search    Varchar2 Default Null,

        p_row_number        Number,
        p_page_length       Number
    ) Return Sys_Refcursor As
        c Sys_Refcursor;

    Begin
        If p_yyyymm Is Null Then
            Return Null;
        End If;    
        
        Open c For Select *
                     From (
                       Select key_id,
                              app_no,
                              empno,
                              get_emp_name(empno)                         As emp_name,
                              lop_yyyymm,
                              payslip_yyyymm,
                              leavetype,
                              adj_type,
                              db_cr,
                              lop,
                              modified_on,
                              modified_by || ' - ' || get_emp_name(modified_by) As modified_by,
                              Row_Number() Over(Order By empno Desc)      row_number,
                              Count(*) Over()                             total_row
                         From ss_absent_excess_leave_lop                         
                         Where upper(empno) Like '%' || upper(Trim(p_generic_search)) || '%'
                            And payslip_yyyymm = Trim(p_yyyymm)
                   )
                    Where row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End fn_absent_excess_leaves;

    Procedure sp_validate_payslip_yyyymm(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_yyyymm           Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_is_open ss_absent_payslip_period.is_open%Type;
    Begin
        Select is_open
          Into v_is_open
          From ss_absent_payslip_period
         Where is_open = ok
           And period = Trim(p_yyyymm);

        p_message_type := ok;
        p_message_text := 'Success';

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'Invalid month';
            Return;
    End sp_validate_payslip_yyyymm;
    
    Procedure sp_get_last_salary_month(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        
        p_yyyymm       Out Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As        
    Begin
        Select 
            period
        Into 
            p_yyyymm 
        From
            (Select 
                period           
             From 
                ss_absent_payslip_period
             Order By 
                period Desc)
        Where rownum = 1;

        p_message_type := ok;
        p_message_text := 'Success';

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'Invalid month';
            Return;
    End sp_get_last_salary_month;
    
    Procedure sp_get_salary_month_status(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_yyyymm           Varchar2,
        p_status       Out Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As        
    Begin
        Select is_open
          Into p_status
          From ss_absent_payslip_period
         Where period = Trim(p_yyyymm);        

        p_message_type := ok;
        p_message_text := 'Success';

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'Invalid month';
            Return;
    End sp_get_salary_month_status;

End pkg_ss_absent_excess_leave_lop_qry;
/