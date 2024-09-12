--------------------------------------------------------
--  DDL for Package Body PKG_ED
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "COMMONMASTERS"."PKG_ED" As

    Function ed_locked Return Number As
    Begin
        Return n_locked;
    End;

    Function ed_open Return Number As
    Begin
        Return n_open;
    End ed_open;

    Function user_access_type_hr Return Varchar2 As
    Begin
        Return c_user_access_type_hr;
    End user_access_type_hr;

    Function user_access_type_admin Return Varchar2 As
    Begin
        Return c_user_access_type_admin;
    End user_access_type_admin;

    Function rep_srv_nm Return Varchar2 As
    Begin
        Return c_rep_srv_nm;
    End rep_srv_nm;

    Function rep_srv_url Return Varchar2 As
    Begin
        Return c_rep_srv_url;
    End rep_srv_url;

    Function get_emp_gtli_nom_url (
        p_empno Varchar2
    ) Return Varchar2 As
        v_ret_val         Varchar2(1000);
        v_gtli_file_row   emp_scan_file%rowtype;
    Begin
        Select
            *
        Into v_gtli_file_row
        From
            (
                Select
                    *
                From
                    emp_scan_file
                Where
                    empno = p_empno And file_type = 'GT'
                Order By
                    modified_on Desc
            )
        Where
            Rownum = 1;

        Return c_gtli_url || v_gtli_file_row.file_name;
    Exception
        When Others Then
            Return Null;
    End get_emp_gtli_nom_url;

    Function rep_env_id Return Varchar2 As
    Begin
        Return c_rep_env_id;
    End rep_env_id;

    Function const_true Return Number As
    Begin
        Return n_true;
    End;

    Function const_false Return Number As
    Begin
        Return n_false;
    End;

    Function user_can_access (
        param_empno Varchar2
    ) Return Number As
        lcl_count           Number := 0;
        login_lock_status   Number;
        lcl_chk_doj         Number := n_false;
    Begin
        Select
            Count(*)
        Into lcl_count
        From
            emp_user_access
        Where
            empno = param_empno;

        If lcl_count > 0 Then
            Return n_true;
        Else
            Begin
                Select
                    login_lock_open
                Into login_lock_status
                From
                    emp_lock_status
                Where
                    empno = param_empno;

                If login_lock_status = n_open Then
                    Return n_true;
                Else
                    Return n_false;
                End If;
            Exception
                When Others Then
                    Null;
            End;

            Select
                Count(*)
            Into lcl_count
            From
                emplmast
            Where
                empno = param_empno And doj >= Add_Months(Sysdate, - 1) And status = 1;

            If lcl_count > 0 Then
                Return n_true;
            Else
                Return n_false;
            End If;
        End If;

    End;

    Function user_can_edit_other_user (
        param_self_empno Varchar2,
        param_other_empno Varchar2
    ) Return Number As
        lcl_count Number;
    Begin
  --param_other_empno parameter is for future user
        Select
            Count(*)
        Into lcl_count
        From
            emp_user_access
        Where
            empno = param_self_empno;

        If lcl_count > 0 Then
            Return n_true;
        Else
            Return n_false;
        End If;
    End;

    Procedure update_emp_details_phone As

        Cursor c1 Is
        Select
            a.empno,
            a.mobile_res
        From
            emp_details   a,
            emplmast      b
        Where
            a.empno = b.empno And b.status   = 1 And b.emptype  = 'R';-- and a.empno in ('02320','02321') ;

        v_count       Number;
        v_per_telno   Varchar2(56);
    Begin
        For c2 In c1 Loop
          --select dob, doj into v_dob, v_doj from emplmast where empno = c2.empno;
            Begin
                Select
                    Nvl(per_std, ' ') || Nvl(per_telno, ' ')
                Into v_per_telno
                From
                    timecurr.cv_emplmast
                Where
                    empno = c2.empno;

            Exception
                When Others Then
                    Null;
            End;

            Update emp_details
            Set
                p_phone = Trim(v_per_telno),
                p_mobile = Trim(c2.mobile_res)
            Where
                empno = c2.empno;

            Commit;
        End Loop;
    End update_emp_details_phone;

    Function webutil_pp_upload_dir Return Varchar2 As
    Begin
        Return c_webutil_pp_upload_dir;
    End webutil_pp_upload_dir;

    Function webutil_ac_upload_dir Return Varchar2 As
    Begin
        Return c_webutil_ac_upload_dir;
    End webutil_ac_upload_dir;

    Function webutil_gt_upload_dir Return Varchar2 As
    Begin
        Return c_webutil_gt_upload_dir;
    End webutil_gt_upload_dir;

    Function shared_pp_dir Return Varchar2 Is
    Begin
        Return c_shared_pp_dir;
    End;

    Function shared_ac_dir Return Varchar2 Is
    Begin
        Return c_shared_ac_dir;
    End;

    Function get_instructions_url Return Varchar2 Is
    Begin
        Return c_instructions_url;
    End;

    Function is_emp_gtli_nom_file_uploaded (
        p_empno Varchar2
    ) Return Varchar2 As
        v_count Number;
    Begin
        Select
            Count(*)
        Into v_count
        From
            emp_scan_file
        Where
            empno = p_empno And file_type = 'GT';

        If v_count > 0 Then
            Return 'Yes';
        Else
            Return 'No';
        End If;
    End;
    Function gtli_file_upload_size Return number Is
    Begin
        Return c_gtli_file_upload_size;
    End;

End pkg_ed;

/
