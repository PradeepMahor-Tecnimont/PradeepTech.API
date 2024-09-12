--------------------------------------------------------
--  DDL for Package Body PKG_EMP_AD_DETAILS
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "COMMONMASTERS"."PKG_EMP_AD_DETAILS" As

    Procedure update_ad_non_emplmast (
        param_win_uid Varchar2,
        instances_found Number
    ) As
        rec_ad_det   emp_ad_details_temp%rowtype;
        v_count      Number;
    Begin
        Select
            *
        Into rec_ad_det
        From
            emp_ad_details_temp
        Where
            Upper(Trim(win_uid)) = Upper(Trim(param_win_uid));

        Delete From emp_ad_details_non
        Where
            Upper(Trim(win_uid)) = Upper(Trim(param_win_uid));

        Insert Into emp_ad_details_non (
            empno,
            emp_ad_name,
            win_uid,
            email_id,
            group_person_id,
            emp_upn,
            ad_office,
            ad_dn,
            ad_cn,
            ad_metaid
        ) Values (
            instances_found,
            Trim(rec_ad_det.emp_name),
            Upper(Trim(rec_ad_det.win_uid)),
            Trim(rec_ad_det.email_id),
            Trim(rec_ad_det.group_person_id),
            Trim(rec_ad_det.emp_upn),
            Trim(rec_ad_det.ad_office),
            Trim(rec_ad_det.ad_dn),
            Trim(rec_ad_det.ad_cn),
            Trim(rec_ad_det.ad_metaid)
        );

    Exception
        When Others Then
            Null;
    End;
-- MAP ACTIVE DIRECTORY WIHT EMPLMAST--

    Procedure map_ad_with_emplmast (
        param_success   Out             Varchar2,
        param_message   Out             Varchar2
    ) As

        Cursor cur_ad Is
        Select
            emp_name,
            win_uid,
            email_id,
            group_person_id,
            emp_upn,
            ad_office,
            ad_dn,
            ad_cn,
            ad_metaid,
            ad_mngr_name,
            ad_mngr_metaid,
            ad_mngr_personid
        From
            emp_ad_details_temp;

        Type typ_tab_ad Is
            Table Of cur_ad%rowtype;
        tab_ad        typ_tab_ad;
        row_ad        cur_ad%rowtype;
        v_count       Number;
        v_emp_count   Number;
        v_empno       Char(5);
    Begin
        Update emp_ad_details_temp
        Set
            ad_office = Lpad(ad_office, 5, '0')
        Where
            ad_office <> 'null'
            And Length(Trim(ad_office)) < 5;

        Delete From emp_ad_details_non;

        Commit;
        Open cur_ad;
        Loop
            Fetch cur_ad Bulk Collect Into tab_ad Limit 50;
            For i In 1..tab_ad.count Loop
                Select
                    Count(*)
                Into v_emp_count
                From
                    emplmast
                Where
                    ( Trim(metaid) = Trim(tab_ad(i).ad_metaid)
                      Or empno     = Trim(tab_ad(i).ad_office)
                      Or personid  = Trim(tab_ad(i).group_person_id) )
                    And status   = 1;

                If v_emp_count != 1 Then
                    update_ad_non_emplmast(
                        Trim(tab_ad(i).win_uid),
                        v_emp_count
                    );
                    Continue;
                End If;

                Select
                    empno
                Into v_empno
                From
                    emplmast
                Where
                    ( Trim(metaid) = Trim(tab_ad(i).ad_metaid)
                      Or empno     = Trim(tab_ad(i).ad_office)
                      Or personid  = Trim(tab_ad(i).group_person_id) )
                    And status   = 1;

                Select
                    Count(*)
                Into v_count
                From
                    emp_ad_details
                Where
                    empno = v_empno;

                If v_count = 0 Then
                    Insert Into emp_ad_details (
                        empno,
                        emp_ad_name,
                        win_uid,
                        email_id,
                        group_person_id,
                        emp_upn,
                        ad_office,
                        ad_dn,
                        ad_cn,
                        ad_metaid,
                        ad_mngr_name,
                        ad_mngr_metaid,
                        ad_mngr_personid
                    ) Values (
                        v_empno,
                        Trim(tab_ad(i).emp_name),
                        Upper(Trim(tab_ad(i).win_uid)),
                        Trim(tab_ad(i).email_id),
                        Trim(tab_ad(i).group_person_id),
                        Trim(tab_ad(i).emp_upn),
                        Trim(tab_ad(i).ad_office),
                        Trim(tab_ad(i).ad_dn),
                        Trim(tab_ad(i).ad_cn),
                        Trim(tab_ad(i).ad_metaid),
                        Trim(tab_ad(i).ad_mngr_name),
                        Trim(tab_ad(i).ad_mngr_metaid),
                        Trim(tab_ad(i).ad_mngr_personid)
                    );

                Else
                    Update emp_ad_details
                    Set
                        emp_ad_name = Trim(tab_ad(i).emp_name),
                        win_uid = Upper(Trim(tab_ad(i).win_uid)),
                        email_id = Trim(tab_ad(i).email_id),
                        group_person_id = Trim(tab_ad(i).group_person_id),
                        emp_upn = Trim(tab_ad(i).emp_upn),
                        ad_office = Trim(tab_ad(i).ad_office),
                        ad_dn = Trim(tab_ad(i).ad_dn),
                        ad_cn = Trim(tab_ad(i).ad_cn),
                        ad_metaid = Trim(tab_ad(i).ad_metaid),
                        ad_mngr_name = Trim(tab_ad(i).ad_mngr_name),
                        ad_mngr_metaid = Trim(tab_ad(i).ad_mngr_metaid),
                        ad_mngr_personid = Trim(tab_ad(i).ad_mngr_personid)
                    Where
                        empno = v_empno;

                End If;
            --Update Selfservice.USERIDS

                Begin
                    Select
                        Count(*)
                    Into v_count
                    From
                        selfservice.userids
                    Where
                        empno = v_empno
                        And userid = Upper(Trim(tab_ad(i).win_uid));

                    If v_count = 1 Then
                        Continue;
                    End If;
                    Delete From selfservice.userids
                    Where
                        empno = v_empno
                        Or userid = Upper(Trim(tab_ad(i).win_uid));

                    Commit;
                    Insert Into selfservice.userids (
                        empno,
                        name,
                        userid,
                        datetime,
                        email,
                        domain
                    ) Values (
                        v_empno,
                        Trim(tab_ad(i).emp_name),
                        Upper(Trim(tab_ad(i).win_uid)),
                        Sysdate,
                        Trim(tab_ad(i).email_id),
                        'TICB'
                    );

                Exception
                    When Others Then
                        Null;
                End;

            End Loop;

            Exit When cur_ad%notfound;
        End Loop;

        Commit;
        param_success   := 'OK';
        param_message   := 'Data has been normalized';
    Exception
        When Others Then
            param_success   := 'KO';
            param_message   := 'Err - ' || Sqlcode || ' - ' || Sqlerrm;
    End;
--XXXX---

-- INSERT TO TEMP DB

    Procedure insert_2_temp_tab (
        param_text Varchar2
    ) As

        v_emp_name           Varchar2(150);
        v_win_uid            Varchar2(100);
        v_email_id           Varchar2(150);
        v_group_person_id    Varchar2(150);
        v_emp_upn            Varchar2(150);
        v_ad_office          Varchar2(50);
        v_ad_dn              Varchar2(500);
        v_ad_cn              Varchar2(500);
        v_ad_metaid          Varchar2(500);
        v_ad_mngr_nm         Varchar2(500);
        v_ad_mngr_metaid     Varchar2(500);
        v_ad_mngr_personid   Varchar2(500);
        v_text               Varchar2(4000);
    Begin
        --v_text := replace(param_text, '"', '');
        v_text               := Replace(param_text, ',,', ',"null",');
        v_text               := Replace(v_text, ',,', ',"null",');
        v_text               := Replace(v_text, ',,', ',"null",');
        If Substr(v_text, -1, 1) = ',' Then
            v_text := v_text || '"null"';
        End If;

        v_text               := Replace(v_text, '","', '|');
        Select
            Regexp_Substr(v_text, '[^|"]+', 1, 1) As emp_name,
            Substr(Regexp_Substr(v_text, '[^|"]+', 1, 2), 1, 100) As win_uid,
            Substr(Regexp_Substr(v_text, '[^|"]+', 1, 3), 1, 150) As email_id,
            Regexp_Substr(v_text, '[^|"]+', 1, 4) As person_id,
            Regexp_Substr(v_text, '[^|"]+', 1, 5) As emp_upn,
            Substr(Regexp_Substr(v_text, '[^|"]+', 1, 6), 1, 50) As ad_office,
            Regexp_Substr(v_text, '[^|"]+', 1, 7) As ad_dn,
            Regexp_Substr(v_text, '[^|"]+', 1, 8) As ad_cn,
            Regexp_Substr(v_text, '[^|"]+', 1, 9) As ad_metaid,
            Regexp_Substr(v_text, '[^|"]+', 1, 10) As ad_manager_name,
            Regexp_Substr(v_text, '[^|"]+', 1, 11) As ad_manager_metaid,
            Regexp_Substr(v_text, '[^|"]+', 1, 12) As ad_manager_person_id
        Into
            v_emp_name,
            v_win_uid,
            v_email_id,
            v_group_person_id,
            v_emp_upn,
            v_ad_office,
            v_ad_dn,
            v_ad_cn,
            v_ad_metaid,
            v_ad_mngr_nm,
            v_ad_mngr_metaid,
            v_ad_mngr_personid
        From
            dual;

        v_emp_name           := Replace(v_emp_name, '"', '');
        v_win_uid            := Replace(v_win_uid, '"', '');
        v_email_id           := Replace(v_email_id, '"', '');
        v_group_person_id    := Replace(v_group_person_id, '"', '');
        v_emp_upn            := Replace(v_emp_upn, '"', '');
        v_ad_office          := Replace(v_ad_office, '"', '');
        v_ad_dn              := Replace(v_ad_dn, '"', '');
        v_ad_cn              := Replace(v_ad_cn, '"', '');
        v_ad_metaid          := Replace(v_ad_metaid, '"', '');
        v_ad_mngr_nm         := Replace(v_ad_mngr_nm, '"', '');
        v_ad_mngr_metaid     := Replace(v_ad_mngr_metaid, '"', '');
        v_ad_mngr_personid   := Replace(v_ad_mngr_personid, '"', '');
        Insert Into emp_ad_details_temp (
            emp_name,
            win_uid,
            email_id,
            group_person_id,
            emp_upn,
            ad_office,
            ad_dn,
            ad_cn,
            ad_metaid,
            ad_mngr_name,
            ad_mngr_metaid,
            ad_mngr_personid
        ) Values (
            v_emp_name,
            v_win_uid,
            v_email_id,
            v_group_person_id,
            v_emp_upn,
            v_ad_office,
            v_ad_dn,
            v_ad_cn,
            v_ad_metaid,
            v_ad_mngr_nm,
            v_ad_mngr_metaid,
            v_ad_mngr_personid
        );

        Commit;
    End;
--XXXX--

-- MORMALIZE BOLB TO ROWS --

    Procedure normalize_blob_2_rows (
        param_key_id    Varchar2,
        param_success   Out             Varchar2,
        param_message   Out             Varchar2
    ) As

        l_str1        Varchar2(4000);
        l_str2        Varchar2(4000);
        l_leftover    Varchar2(4000);
        l_chunksize   Number := 3000;
        l_offset      Number := 1;
        l_linebreak   Varchar2(2) := Chr(13) || Chr(10);
        l_length      Number;
        v_blob        Blob;
        l_row         Varchar2(1000);
    Begin
        --empty import_punch tble
        Delete From emp_ad_details_temp;
        --

        Select
            file_binary_content
        Into v_blob
        From
            emp_blob
        Where
            blob_key_id = param_key_id;

        l_length        := dbms_lob.getlength(v_blob);
        dbms_output.put_line(l_length);
        While l_offset < l_length Loop
            l_str1       := l_leftover || utl_raw.cast_to_varchar2(dbms_lob.Substr(
                v_blob,
                l_chunksize,
                l_offset
            ));

            l_leftover   := Null;
            l_str2       := l_str1;
            While l_str2 Is Not Null Loop If Instr(l_str2, l_linebreak) <= 0 Then
                l_leftover   := l_str2;
                l_str2       := Null;
            Else
                l_row    := ( Substr(l_str2, 1, Instr(l_str2, l_linebreak) - 1) );

                --Insert into table

                --Pipe Row ( l_row );

                insert_2_temp_tab(l_row);
                --
                l_str2   := Substr(l_str2, Instr(l_str2, l_linebreak) + 2);
            End If;
            End Loop;

            l_offset     := l_offset + l_chunksize;
        End Loop;

        If l_leftover Is Not Null Then
            l_row := Substr(l_leftover, 1, 1000);
                           --Insert into table
            insert_2_temp_tab(l_row);
                --

            --Pipe Row ( l_row );
            --dbms_output.put_line(l_leftover);
        End If;

        param_success   := 'OK';
        param_message   := 'Blob normalized to rows';
        return;
    Exception
        When Others Then
            param_success   := 'KO';
            param_message   := 'Err - ' || Sqlcode || ' - ' || Sqlerrm;
    End;
--XXXX--

--

    Procedure normalize_blob_async (
        param_key_id    Varchar2,
        param_success   Out             Varchar2,
        param_message   Out             Varchar2
    ) As
        v_job_name Varchar2(30);
    Begin
        v_job_name := 'UPDATE_EMP_AD_DETAILS_' || param_key_id;
        dbms_scheduler.create_job(
            job_name              => v_job_name,
            job_type              => 'STORED_PROCEDURE',
            job_action            => 'pkg_emp_ad_details.normalize_blob',
            number_of_arguments   => 1,
            enabled               => false,
            comments              => 'to update Emploee Active Directory Details in DB'
        );

        dbms_scheduler.set_job_argument_value(
            job_name            => v_job_name,
            argument_position   => 1,
            argument_value      => param_key_id
        );

        dbms_scheduler.enable(v_job_name);
    End;
--XXXX--

-- UPLOAD BLOB--

    Procedure upload_blob (
        param_blob        Blob,
        param_file_name   Varchar2,
        param_success     Out               Varchar2,
        param_message     Out               Varchar2
    ) Is

        v_key_id   Varchar2(5);
        v_count    Number;
        ex_custom Exception;
        Pragma exception_init ( ex_custom, -20001 );
    Begin
        v_key_id        := dbms_random.string('X', 5);
        param_success   := 'OK';
        Delete From emp_blob
        Where
            modified_on < Trunc(Sysdate - 1);

        Commit;
        Insert Into emp_blob (
            blob_key_id,
            modified_on,
            file_binary_content,
            file_type,
            file_name
        ) Values (
            v_key_id,
            Sysdate,
            param_blob,
            'EMP_AD_DETAILS',
            param_file_name
        );

        Commit;
        normalize_blob_async(
            v_key_id,
            param_success,
            param_message
        );
        If param_success = 'KO' Then
            return;
        End If;
        param_success   := 'OK';
        param_message   := 'File Upload & Normalization has been scheduled.';
    Exception
        When Others Then
            param_success   := 'KO';
            param_message   := 'Err - ' || Sqlcode || ' - ' || Sqlerrm;
    End;
--XXXX--

--

    Procedure normalize_blob (
        param_key_id Varchar2
    ) As
        v_success   Varchar2(10);
        v_message   Varchar2(3000);
    Begin
        normalize_blob_2_rows(
            param_key_id,
            v_success,
            v_message
        );
        If v_success = 'KO' Then
            return;
        End If;
        map_ad_with_emplmast(
            v_success,
            v_message
        );
        If v_success = 'KO' Then
            return;
        End If;
    End;

End pkg_emp_ad_details;

/
