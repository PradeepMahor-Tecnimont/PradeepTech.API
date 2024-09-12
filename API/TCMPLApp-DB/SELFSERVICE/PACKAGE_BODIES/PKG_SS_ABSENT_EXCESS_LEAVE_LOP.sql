--------------------------------------------------------
--  DDL for Package Body PKG_SS_ABSENT_EXCESS_LEAVE_LOP
--------------------------------------------------------

Create Or Replace Package Body selfservice.pkg_ss_absent_excess_leave_lop As

    Procedure prc_delete_absent_excess_leaves(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_key_id           Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno          Varchar2(5);
        v_message_type   Number := 0;
        v_payslip_yyyymm ss_absent_excess_leave_lop.payslip_yyyymm%Type;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select payslip_yyyymm
          Into v_payslip_yyyymm
          From ss_absent_excess_leave_lop
         Where key_id = Trim(p_key_id);

        pkg_ss_absent_excess_leave_lop_qry.sp_validate_payslip_yyyymm(
            p_person_id    => p_person_id,
            p_meta_id      => p_meta_id,

            p_yyyymm       => v_payslip_yyyymm,

            p_message_type => p_message_type,
            p_message_text => p_message_text
        );

        If p_message_type = ok Then
            Delete From ss_absent_excess_leave_lop
             Where key_id = p_key_id;

            If (Sql%rowcount > 0) Then
                p_message_type := 'OK';
                p_message_text := 'Procedure executed successfully.';
            Else
                p_message_type := 'KO';
                p_message_text := 'Procedure not executed.';
            End If;
        Else
            p_message_type := p_message_type;
            p_message_text := p_message_text;
        End If;
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;

    End prc_delete_absent_excess_leaves;

    Procedure sp_delete_ss_leave_ledg(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_app_no           Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno          Varchar2(5);
        v_message_type   Number := 0;
        v_payslip_yyyymm ss_absent_excess_leave_lop.payslip_yyyymm%Type;
        v_key_id         ss_absent_excess_leave_lop.key_id%Type;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select payslip_yyyymm, key_id
          Into v_payslip_yyyymm, v_key_id
          From ss_absent_excess_leave_lop
         Where app_no = Trim(p_app_no);

        pkg_ss_absent_excess_leave_lop_qry.sp_validate_payslip_yyyymm(
            p_person_id    => p_person_id,
            p_meta_id      => p_meta_id,

            p_yyyymm       => v_payslip_yyyymm,

            p_message_type => p_message_type,
            p_message_text => p_message_text
        );
        If p_message_type = ok Then
            Delete From ss_leaveledg
             Where app_no = Trim(p_app_no);

            prc_delete_absent_excess_leaves(
                p_person_id    => p_person_id,
                p_meta_id      => p_meta_id,

                p_key_id       => v_key_id,

                p_message_type => p_message_type,
                p_message_text => p_message_text
            );

            p_message_type := p_message_type;
            p_message_text := p_message_text;
        Else
            p_message_type := p_message_type;
            p_message_text := p_message_text;
        End If;
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;

    End sp_delete_ss_leave_ledg;

    Procedure sp_insert_ss_leave_ledg(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_app_no           Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno_by          Varchar2(5);
        v_leavetype         ss_leaveledg.leavetype%Type;
        v_description       ss_leaveledg.description%Type;
        v_empno_for         ss_leaveledg.empno%Type;
        v_leaveperiod       ss_leaveledg.leaveperiod%Type;
        v_db_cr             ss_leaveledg.db_cr%Type;
        v_tabletag          ss_leaveledg.tabletag%Type;
        v_bdate             ss_leaveledg.bdate%Type;
        v_adj_type          ss_leaveledg.adj_type%Type;
        v_payslip_yyyymm    ss_absent_excess_leave_lop.payslip_yyyymm%type;
    Begin
        v_empno_by        := get_empno_from_meta_id(p_meta_id);
        If v_empno_by = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select leavetype,
               Case db_cr
                   When 'D' Then
                       'Salary paid of ' || to_char(To_Date(lop_yyyymm || '01', 'YYYYMMDD'), 'Mon YYYY') || ' in ' || to_char(
                       To_Date(payslip_yyyymm || '01', 'YYYYMMDD'), 'Mon YYYY')
                   Else                       
                       'Loss of pay for ' || to_char(To_Date(lop_yyyymm || '01', 'YYYYMMDD'), 'Mon YYYY') || ' in ' || to_char(
                       To_Date(payslip_yyyymm || '01', 'YYYYMMDD'), 'Mon YYYY')
               End,
               empno,
               Case db_cr
                   When 'D' Then
                       round(lop * -8, 1)
                   Else
                       round(lop * 8, 1)
               End,
               db_cr,
               -1,
               last_day(To_Date(lop_yyyymm || '01', 'YYYYMMDD')),
               adj_type,
               payslip_yyyymm
          Into v_leavetype,
               v_description,
               v_empno_for,
               v_leaveperiod,
               v_db_cr,
               v_tabletag,
               v_bdate,
               v_adj_type,
               v_payslip_yyyymm
          From ss_absent_excess_leave_lop
         Where app_no = Trim(p_app_no);

        Insert Into ss_leaveledg
        (
            app_no,
            app_date,
            leavetype,
            description,
            empno,
            leaveperiod,
            db_cr,
            tabletag,
            bdate,
            adj_type
        )
        Values
        (
            p_app_no,
            last_day(To_Date(v_payslip_yyyymm || '01', 'YYYYMMDD')),
            v_leavetype,
            v_description,
            v_empno_for,
            v_leaveperiod,
            v_db_cr,
            v_tabletag,
            v_bdate,
            v_adj_type
        );

        If Sql%rowcount > 0 Then
            p_message_type := ok;
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := not_ok;
            p_message_text := 'Procedure not executed.';
        End If;

        p_message_type := p_message_type;
        p_message_text := p_message_text;
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;

    End sp_insert_ss_leave_ledg;

    Procedure sp_rollback_ss_leave_ledg(
        p_person_id             Varchar2,
        p_meta_id               Varchar2,

        p_yyyymm                Varchar2,

        p_message_type      Out Varchar2,
        p_message_text      Out Varchar2
    ) As                
        v_empno          Varchar2(5);        
    Begin    
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        
        If p_yyyymm Is Null Then
            p_message_type := not_ok;
            p_message_text := 'Invalid month';
            Return;
        End If;

        pkg_ss_absent_excess_leave_lop_qry.sp_validate_payslip_yyyymm(
            p_person_id    => p_person_id,
            p_meta_id      => p_meta_id,

            p_yyyymm       => p_yyyymm,

            p_message_type => p_message_type,
            p_message_text => p_message_text
        );
        If p_message_type = ok Then                
            Delete From ss_leaveledg
                Where app_no In (Select 
                                    app_no 
                                  From 
                                    ss_absent_excess_leave_lop 
                                  Where 
                                    payslip_yyyymm = Trim(p_yyyymm));

            Delete From ss_absent_excess_leave_lop
             Where payslip_yyyymm = Trim(p_yyyymm);            
             
            p_message_type := 'OK';
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := p_message_type;
            p_message_text := p_message_text;          
            Return;
        End If;
    Exception
        When Others Then
            Rollback;
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;

    End sp_rollback_ss_leave_ledg;

End pkg_ss_absent_excess_leave_lop;
/