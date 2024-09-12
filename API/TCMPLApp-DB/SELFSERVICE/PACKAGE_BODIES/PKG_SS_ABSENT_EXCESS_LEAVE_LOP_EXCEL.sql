--------------------------------------------------------
--  DDL for Package PKG_SS_ABSENT_EXCESS_LEAVE_LOP_EXCEL
--------------------------------------------------------

Create Or Replace Package Body selfservice.pkg_ss_absent_excess_leave_lop_excel As

    Procedure prc_validate_empno(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_empno            Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_persons Number;
        v_empno   ss_emplmast.empno%Type;
    Begin
        If p_empno Is Null Then
            p_message_type := not_ok;
            p_message_text := 'Empno should be of 5 characters';
            Return;
        End If;
        
        If length(p_empno) != 5 Then
            p_message_type := not_ok;
            p_message_text := 'Empno should be of 5 characters';
            Return;
        End If;

        Select empno
          Into v_empno
          From ss_emplmast
         Where status = 1
           And empno = Trim(p_empno);

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'Empno not found';
            Return;
    End;

    Procedure prc_validate_yyyymm(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_yyyymm           Date,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_yyyymm           Varchar2(6);
        v_invalid_flag     Char(2) := ok;
    Begin
        If p_yyyymm Is Null Then
            p_message_type := not_ok;
            p_message_text := 'Invalid month';
            Return;        
        End If;               
        
        Select To_Char(p_yyyymm, 'YYYYMM') Into v_yyyymm From dual;
        
        If To_Number(to_char(p_yyyymm, 'YYYYMM')) > To_Number(to_char(sysdate, 'YYYYMM')) Then
            p_message_type := not_ok;
            p_message_text := 'Invalid month';
            Return;
        End If;
    
        /*v_yyyymm       := To_Number(nvl(p_yyyymm, '190001'));

        If v_yyyymm < 0 Or length(v_yyyymm) != 6 Or instr(v_yyyymm, '.') > 0 Or To_Number(substr(v_yyyymm, 5, 2)) = 0 Or To_Number(
        substr(v_yyyymm, 5, 2)) > 12 Or v_yyyymm > To_Number(to_char(sysdate, 'YYYYMM')) Then
            p_message_type := not_ok;
            p_message_text := 'Invalid month';
            Return;
        End If;*/

        p_message_type := ok;
        p_message_text := 'Success';

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'Invalid leave';
            Return;
    End;

    Procedure prc_validate_leave(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_leave            Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_leave            Number;
        v_leave_length     Number;
        v_decimal_position Number;
        v_number_part      Number;
        v_decimal_part     Number;
        v_invalid_flag     Char(2) := ok;
    Begin
        v_leave            := To_Number(nvl(p_leave, '0'));
        If v_leave < 0 Then
            p_message_type := not_ok;
            p_message_text := 'Invalid leave';
            Return;
        Elsif v_leave = 0 Then
            p_message_type := ok;
            p_message_text := 'Success';
            Return;
        End If;

        v_leave_length     := length(v_leave);
        v_decimal_position := instr(v_leave, '.');
        If v_decimal_position > 0 Then
            v_number_part  := substr(v_leave, 1, v_decimal_position - 1);
            v_decimal_part := substr(v_leave, v_decimal_position + 1, v_leave_length - v_decimal_position);

            If length(v_number_part) > 3 Or length(v_decimal_part) > 3 Then
                v_invalid_flag := not_ok;
            End If;
        Else
            v_number_part := v_leave;
            If length(v_number_part) > 3 Then
                v_invalid_flag := not_ok;
            End If;
        End If;

        If v_invalid_flag = not_ok Then
            p_message_type := not_ok;
            p_message_text := 'Invalid leave';
            Return;
        Else
            p_message_type := ok;
            p_message_text := 'Success';
        End If;
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'Invalid leave';
            Return;
    End;

    Procedure prc_delete_lop_errors(
        p_person_id         Varchar2,
        p_meta_id           Varchar2,

        p_message_type Out  Varchar2,
        p_message_text Out  Varchar2
    ) As
    Begin
        tcmpl_app_config.pkg_process_excel_import_errors.sp_delete_errors(
            p_person_id         => p_person_id,
            p_meta_id           => p_meta_id,

            p_message_type      => p_message_type,
            p_message_text      => p_message_text
        );
    End;

    Procedure prc_insert_lop_errors(
        p_person_id         Varchar2,
        p_meta_id           Varchar2,

        p_id                Number,
        p_section           Varchar2,
        p_excel_row_number  Number,
        p_field_name        Varchar2,
        p_error_type        Number,
        p_error_type_string Varchar2,
        p_message           Varchar2,

        p_message_type Out  Varchar2,
        p_message_text Out  Varchar2
    ) As
    Begin
        tcmpl_app_config.pkg_process_excel_import_errors.sp_insert_errors(
            p_person_id         => p_person_id,
            p_meta_id           => p_meta_id,

            p_id                => p_id,
            p_section           => p_section,
            p_excel_row_number  => p_excel_row_number,
            p_field_name        => p_field_name,
            p_error_type        => p_error_type,
            p_error_type_string => p_error_type_string,
            p_message           => p_message,

            p_message_type      => p_message_type,
            p_message_text      => p_message_text
        );
    End;

    Procedure prc_insert_pl_cl_co_lop(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_payslip_yyyymm   Varchar2,
        p_adj_type         Varchar2,
        p_empno            Varchar2,
        p_lop_yyyymm       Varchar2,
        p_leave_type       Varchar2,
        p_lop              Number,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno  Varchar2(5);
        v_db_cr  Char(1);
        v_app_no ss_absent_excess_leave_lop.app_no%Type;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        If p_adj_type = 'LP' Then
            v_db_cr := 'C';
        Elsif p_adj_type = 'DR' Then
            v_db_cr := 'D';
        End If;

        v_app_no       := upper(trim(p_empno)) || '_' || p_leave_type || '_' || v_db_cr || '_' || p_lop_yyyymm || '_' || p_payslip_yyyymm || '_' || dbms_random.string('X', 8);

        Insert Into ss_absent_excess_leave_lop (
            key_id,
            app_no,
            empno,
            lop_yyyymm,
            payslip_yyyymm,
            leavetype,
            db_cr,
            adj_type,
            lop,
            modified_by,
            modified_on)
        Values(
            dbms_random.string('X', 8),
            v_app_no,
            upper(Trim(p_empno)),
            p_lop_yyyymm,
            p_payslip_yyyymm,
            p_leave_type,
            v_db_cr,
            p_adj_type,
            p_lop,
            v_empno,
            sysdate);

        pkg_ss_absent_excess_leave_lop.sp_insert_ss_leave_ledg(
            p_person_id    => p_person_id,
            p_meta_id      => p_meta_id,

            p_app_no       => v_app_no,

            p_message_type => p_message_type,
            p_message_text => p_message_text
        );

        p_message_type := ok;
        p_message_text := 'Success';
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure prc_insert_lop(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_payslip_yyyymm   Varchar2,
        p_adj_type         Varchar2,
        p_empno            Varchar2,
        p_lop_yyyymm       Varchar2,
        p_lop_pl           Number Default Null,
        p_lop_cl           Number Default Null,
        p_lop_co           Number Default Null,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno      Varchar2(5);
        v_leave_type Char(2);
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        If Nvl(p_lop_pl,0) > 0 Then
            v_leave_type := 'PL';

            prc_insert_pl_cl_co_lop(
                p_person_id      => p_person_id,
                p_meta_id        => p_meta_id,

                p_payslip_yyyymm => p_payslip_yyyymm,
                p_adj_type       => p_adj_type,
                p_empno          => p_empno,
                p_lop_yyyymm     => p_lop_yyyymm,
                p_leave_type     => v_leave_type,
                p_lop            => p_lop_pl,

                p_message_type   => p_message_type,
                p_message_text   => p_message_text
            );
        End If;

        If Nvl(p_lop_cl,0) > 0 Then
            v_leave_type := 'CL';

            prc_insert_pl_cl_co_lop(
                p_person_id      => p_person_id,
                p_meta_id        => p_meta_id,

                p_payslip_yyyymm => p_payslip_yyyymm,
                p_adj_type       => p_adj_type,
                p_empno          => p_empno,
                p_lop_yyyymm     => p_lop_yyyymm,
                p_leave_type     => v_leave_type,
                p_lop            => p_lop_cl,

                p_message_type   => p_message_type,
                p_message_text   => p_message_text
            );
        End If;

        If Nvl(p_lop_co,0) > 0 Then
            v_leave_type := 'CO';

            prc_insert_pl_cl_co_lop(
                p_person_id      => p_person_id,
                p_meta_id        => p_meta_id,

                p_payslip_yyyymm => p_payslip_yyyymm,
                p_adj_type       => p_adj_type,
                p_empno          => p_empno,
                p_lop_yyyymm     => p_lop_yyyymm,
                p_leave_type     => v_leave_type,
                p_lop            => p_lop_co,

                p_message_type   => p_message_type,
                p_message_text   => p_message_text
            );
        End If;

        p_message_type := ok;
        p_message_text := 'Success';
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure prc_update_lop(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_payslip_yyyymm   Varchar2,
        p_adj_type         Varchar2,
        p_empno            Varchar2,
        p_lop_yyyymm       Varchar2,
        p_lop_pl           Number Default Null,
        p_lop_cl           Number Default Null,
        p_lop_co           Number Default Null,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno      Varchar2(5);
        v_app_no     ss_absent_excess_leave_lop.app_no%Type;
        v_lop        ss_absent_excess_leave_lop.lop%Type;
        v_leave_type Char(2);
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        
        v_leave_type := 'PL';
        Begin
            Select app_no, lop
              Into v_app_no, v_lop
              From ss_absent_excess_leave_lop
             Where payslip_yyyymm = Trim(p_payslip_yyyymm)
               And lop_yyyymm = Trim(p_lop_yyyymm)
               And adj_type = p_adj_type
               And leavetype = v_leave_type
               And empno = Trim(p_empno);

            If Nvl(v_lop,0) <> Nvl(p_lop_pl,0) Then
                If Nvl(v_lop,0) > 0 Then
                    pkg_ss_absent_excess_leave_lop.sp_delete_ss_leave_ledg(
                        p_person_id    => p_person_id,
                        p_meta_id      => p_meta_id,

                        p_app_no       => v_app_no,

                        p_message_type => p_message_type,
                        p_message_text => p_message_text
                    );
                End If;
                
                If Nvl(p_lop_pl,0) > 0 Then
                    prc_insert_pl_cl_co_lop(
                        p_person_id      => p_person_id,
                        p_meta_id        => p_meta_id,

                        p_payslip_yyyymm => p_payslip_yyyymm,
                        p_adj_type       => p_adj_type,
                        p_empno          => p_empno,
                        p_lop_yyyymm     => p_lop_yyyymm,
                        p_leave_type     => v_leave_type,
                        p_lop            => p_lop_pl,

                        p_message_type   => p_message_type,
                        p_message_text   => p_message_text
                    );
                End If;
            End If;
        Exception
            When Others Then
                If Nvl(p_lop_pl,0) > 0 Then
                    prc_insert_pl_cl_co_lop(
                        p_person_id      => p_person_id,
                        p_meta_id        => p_meta_id,

                        p_payslip_yyyymm => p_payslip_yyyymm,
                        p_adj_type       => p_adj_type,
                        p_empno          => p_empno,
                        p_lop_yyyymm     => p_lop_yyyymm,
                        p_leave_type     => v_leave_type,
                        p_lop            => p_lop_pl,

                        p_message_type   => p_message_type,
                        p_message_text   => p_message_text
                    );
                End If;
        End;        
        
        v_leave_type := 'CL';
        Begin
            Select app_no, lop
              Into v_app_no, v_lop
              From ss_absent_excess_leave_lop
             Where payslip_yyyymm = Trim(p_payslip_yyyymm)
               And lop_yyyymm = Trim(p_lop_yyyymm)
               And adj_type = p_adj_type
               And leavetype = v_leave_type
               And empno = Trim(p_empno);
            
            If Nvl(v_lop,0) <> Nvl(p_lop_cl,0) Then             
                If Nvl(v_lop,0) > 0 Then
                    pkg_ss_absent_excess_leave_lop.sp_delete_ss_leave_ledg(
                        p_person_id    => p_person_id,
                        p_meta_id      => p_meta_id,

                        p_app_no       => v_app_no,

                        p_message_type => p_message_type,
                        p_message_text => p_message_text
                    );
                End If;
                
                If Nvl(p_lop_cl,0) > 0 Then
                    prc_insert_pl_cl_co_lop(
                        p_person_id      => p_person_id,
                        p_meta_id        => p_meta_id,

                        p_payslip_yyyymm => p_payslip_yyyymm,
                        p_adj_type       => p_adj_type,
                        p_empno          => p_empno,
                        p_lop_yyyymm     => p_lop_yyyymm,
                        p_leave_type     => v_leave_type,
                        p_lop            => p_lop_cl,

                        p_message_type   => p_message_type,
                        p_message_text   => p_message_text
                    );
                End If;
            End If;
        Exception
            When Others Then
                If Nvl(p_lop_cl,0) > 0 Then
                    prc_insert_pl_cl_co_lop(
                        p_person_id      => p_person_id,
                        p_meta_id        => p_meta_id,

                        p_payslip_yyyymm => p_payslip_yyyymm,
                        p_adj_type       => p_adj_type,
                        p_empno          => p_empno,
                        p_lop_yyyymm     => p_lop_yyyymm,
                        p_leave_type     => v_leave_type,
                        p_lop            => p_lop_cl,

                        p_message_type   => p_message_type,
                        p_message_text   => p_message_text
                    );
                End If;
        End;

        v_leave_type := 'CO';
        Begin
            Select app_no, lop
              Into v_app_no, v_lop
              From ss_absent_excess_leave_lop
             Where payslip_yyyymm = Trim(p_payslip_yyyymm)
               And lop_yyyymm = Trim(p_lop_yyyymm)
               And adj_type = p_adj_type
               And leavetype = v_leave_type
               And empno = Trim(p_empno);

            If Nvl(v_lop,0) <> Nvl(p_lop_co,0) Then             
                If Nvl(v_lop,0) > 0 Then
                    pkg_ss_absent_excess_leave_lop.sp_delete_ss_leave_ledg(
                        p_person_id    => p_person_id,
                        p_meta_id      => p_meta_id,

                        p_app_no       => v_app_no,

                        p_message_type => p_message_type,
                        p_message_text => p_message_text
                    );
                End If;
                
                If Nvl(p_lop_co,0) > 0 Then
                    prc_insert_pl_cl_co_lop(
                        p_person_id      => p_person_id,
                        p_meta_id        => p_meta_id,

                        p_payslip_yyyymm => p_payslip_yyyymm,
                        p_adj_type       => p_adj_type,
                        p_empno          => p_empno,
                        p_lop_yyyymm     => p_lop_yyyymm,
                        p_leave_type     => v_leave_type,
                        p_lop            => p_lop_co,

                        p_message_type   => p_message_type,
                        p_message_text   => p_message_text
                    );
                End If;
            End If;
        Exception
            When Others Then
                If Nvl(p_lop_co,0) > 0 Then
                    prc_insert_pl_cl_co_lop(
                        p_person_id      => p_person_id,
                        p_meta_id        => p_meta_id,

                        p_payslip_yyyymm => p_payslip_yyyymm,
                        p_adj_type       => p_adj_type,
                        p_empno          => p_empno,
                        p_lop_yyyymm     => p_lop_yyyymm,
                        p_leave_type     => v_leave_type,
                        p_lop            => p_lop_co,

                        p_message_type   => p_message_type,
                        p_message_text   => p_message_text
                    );
                End If;
        End;

        p_message_type := ok;
        p_message_text := 'Success';
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure sp_import_lop(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_payslip_yyyymm   Varchar2,
        p_adj_type         Varchar2,
        p_lop_json         Blob,
        p_lop_errors   Out Sys_Refcursor,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_err_num       Number;
        v_xl_row_number Number := 0;
        is_error_in_row Boolean;
        v_count         Number;

        Cursor cur_json Is
            Select jt.*
              From Json_Table(p_lop_json Format Json, '$[*]'
                       Columns (
                           empno      Varchar2(5) Path '$.Empno',
                           lop_yyyymm Date        Path '$.LopYYYYMM',
                           lop_pl     Number      Path '$.PL',
                           lop_cl     Number      Path '$.CL',
                           lop_co     Number      Path '$.CO'
                       )
                   ) As jt;

    Begin
        v_err_num    := 0;

        If Not (p_adj_type = 'LP' Or p_adj_type = 'DR') Then
            p_message_type := not_ok;
            p_message_text := 'Adjustment leave type should be Debit (Salary paid) Or Credit (Loss of pay)';
            Return;
        End If;
        
        --Payslip Yyyymm    
        pkg_ss_absent_excess_leave_lop_qry.sp_validate_payslip_yyyymm(
            p_person_id    => p_person_id,
            p_meta_id      => p_meta_id,

            p_yyyymm       => Trim(p_payslip_yyyymm),

            p_message_type => p_message_type,
            p_message_text => p_message_text
        );
        If p_message_type = not_ok Then
            p_message_type := not_ok;
            p_message_text := 'Invalid / locked salary month';
            Return;
        End If;

         prc_delete_lop_errors(
            p_person_id         => p_person_id,
            p_meta_id           => p_meta_id,

            p_message_type      => p_message_type,
            p_message_text      => p_message_text
        );

        For c1 In cur_json
        Loop
            is_error_in_row := False;
            v_xl_row_number := v_xl_row_number + 1;
            
            --Empno    
            prc_validate_empno(
                p_person_id    => p_person_id,
                p_meta_id      => p_meta_id,

                p_empno        => upper(Trim(c1.empno)),

                p_message_type => p_message_type,
                p_message_text => p_message_text
            );
            If p_message_type = not_ok Then
                v_err_num       := v_err_num + 1;
                is_error_in_row := True;

                prc_insert_lop_errors(
                    p_person_id         => p_person_id,
                    p_meta_id           => p_meta_id,

                    p_id                => v_err_num,
                    p_section           => '',
                    p_excel_row_number  => v_xl_row_number,
                    p_field_name        => 'Empno',
                    p_error_type        => 0,
                    p_error_type_string => 'Critical',
                    p_message           => 'Invalid Empno',

                    p_message_type      => p_message_type,
                    p_message_text      => p_message_text
                );
            End If;
            
            --LOP Yyyymm    
            prc_validate_yyyymm(
                p_person_id    => p_person_id,
                p_meta_id      => p_meta_id,

                p_yyyymm       => c1.lop_yyyymm,

                p_message_type => p_message_type,
                p_message_text => p_message_text
            );
            If p_message_type = not_ok Then
                v_err_num       := v_err_num + 1;
                is_error_in_row := True;

                prc_insert_lop_errors(
                    p_person_id         => p_person_id,
                    p_meta_id           => p_meta_id,

                    p_id                => v_err_num,
                    p_section           => '',
                    p_excel_row_number  => v_xl_row_number,
                    p_field_name        => 'LopYYYYMM',
                    p_error_type        => 0,
                    p_error_type_string => 'Critical',
                    p_message           => 'Invalid LOP Month',

                    p_message_type      => p_message_type,
                    p_message_text      => p_message_text
                );
            End If;                       
            
            --LOP PL 
            prc_validate_leave(
                p_person_id    => p_person_id,
                p_meta_id      => p_meta_id,

                p_leave        => Trim(c1.lop_pl),

                p_message_type => p_message_type,
                p_message_text => p_message_text
            );
            If p_message_type = not_ok Then
                v_err_num       := v_err_num + 1;
                is_error_in_row := True;

                prc_insert_lop_errors(
                    p_person_id         => p_person_id,
                    p_meta_id           => p_meta_id,

                    p_id                => v_err_num,
                    p_section           => '',
                    p_excel_row_number  => v_xl_row_number,
                    p_field_name        => 'PL',
                    p_error_type        => 0,
                    p_error_type_string => 'Critical',
                    p_message           => 'Invalid PL',

                    p_message_type      => p_message_type,
                    p_message_text      => p_message_text
                );
            End If;
            
            --LOP CL 
            prc_validate_leave(
                p_person_id    => p_person_id,
                p_meta_id      => p_meta_id,

                p_leave        => Trim(c1.lop_cl),

                p_message_type => p_message_type,
                p_message_text => p_message_text
            );
            If p_message_type = not_ok Then
                v_err_num       := v_err_num + 1;
                is_error_in_row := True;

                prc_insert_lop_errors(
                    p_person_id         => p_person_id,
                    p_meta_id           => p_meta_id,

                    p_id                => v_err_num,
                    p_section           => '',
                    p_excel_row_number  => v_xl_row_number,
                    p_field_name        => 'CL',
                    p_error_type        => 0,
                    p_error_type_string => 'Critical',
                    p_message           => 'Invalid CL',

                    p_message_type      => p_message_type,
                    p_message_text      => p_message_text
                );
            End If;
            
            --LOP CO 
            prc_validate_leave(
                p_person_id    => p_person_id,
                p_meta_id      => p_meta_id,

                p_leave        => Trim(c1.lop_co),

                p_message_type => p_message_type,
                p_message_text => p_message_text
            );
            If p_message_type = not_ok Then
                v_err_num       := v_err_num + 1;
                is_error_in_row := True;

                prc_insert_lop_errors(
                    p_person_id         => p_person_id,
                    p_meta_id           => p_meta_id,

                    p_id                => v_err_num,
                    p_section           => '',
                    p_excel_row_number  => v_xl_row_number,
                    p_field_name        => 'CO',
                    p_error_type        => 0,
                    p_error_type_string => 'Critical',
                    p_message           => 'Invalid CO',

                    p_message_type      => p_message_type,
                    p_message_text      => p_message_text
                );
            End If;

            If Nvl(c1.lop_pl,0) = 0 And Nvl(c1.lop_cl,0) = 0 And Nvl(c1.lop_co,0) = 0 Then
                v_err_num       := v_err_num + 1;
                is_error_in_row := True;

                prc_insert_lop_errors(
                    p_person_id         => p_person_id,
                    p_meta_id           => p_meta_id,

                    p_id                => v_err_num,
                    p_section           => '',
                    p_excel_row_number  => v_xl_row_number,
                    p_field_name        => 'Empno',
                    p_error_type        => 0,
                    p_error_type_string => 'Critical',
                    p_message           => 'Invalid leave',

                    p_message_type      => p_message_type,
                    p_message_text      => p_message_text
                );
            End If;

            If is_error_in_row = false Then
                Select Count(*)
                  Into v_count
                  From ss_absent_excess_leave_lop
                 Where payslip_yyyymm = Trim(p_payslip_yyyymm)
                   And lop_yyyymm = To_Char(c1.lop_yyyymm,'YYYYMM')
                   And adj_type = p_adj_type
                   And empno = Trim(c1.empno);

                If v_count = 0 Then
                    prc_insert_lop(
                        p_person_id      => p_person_id,
                        p_meta_id        => p_meta_id,

                        p_payslip_yyyymm => p_payslip_yyyymm,
                        p_adj_type       => p_adj_type,
                        p_empno          => c1.empno,
                        p_lop_yyyymm     => To_Char(c1.lop_yyyymm,'YYYYMM'),
                        p_lop_pl         => c1.lop_pl,
                        p_lop_cl         => c1.lop_cl,
                        p_lop_co         => c1.lop_co,

                        p_message_type   => p_message_type,
                        p_message_text   => p_message_text
                    );
                Else
                    prc_update_lop(
                        p_person_id      => p_person_id,
                        p_meta_id        => p_meta_id,

                        p_payslip_yyyymm => p_payslip_yyyymm,
                        p_adj_type       => p_adj_type,
                        p_empno          => c1.empno,
                        p_lop_yyyymm     => To_Char(c1.lop_yyyymm,'YYYYMM'),
                        p_lop_pl         => c1.lop_pl,
                        p_lop_cl         => c1.lop_cl,
                        p_lop_co         => c1.lop_co,

                        p_message_type   => p_message_type,
                        p_message_text   => p_message_text
                    );
                End If;
            End If;
        End Loop;

        If v_err_num != 0 Then
            p_message_type := not_ok;
            p_message_text := 'Not all records were imported.';

        Else
            p_message_type := ok;
            p_message_text := 'File imported successfully.';
        End If;

        p_lop_errors := tcmpl_app_config.pkg_process_excel_import_errors.fn_read_error_list(p_person_id => p_person_id,
                                                                                            p_meta_id   => p_meta_id);

        Commit;

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := sqlcode || ' - ' || sqlerrm;
    End sp_import_lop;

End pkg_ss_absent_excess_leave_lop_excel;