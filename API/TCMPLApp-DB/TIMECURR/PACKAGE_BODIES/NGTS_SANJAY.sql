--------------------------------------------------------
--  DDL for Package Body NGTS_SANJAY
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "TIMECURR"."NGTS_SANJAY" As

    Function update_time_mast Return Number As
        nresult Number;
    Begin
        Update time_mast
        Set
            mastkeyid = dbms_random.string('X', 8);
        
        --Select update_time_daily Into nResult From dual;
        --Select update_time_ot Into nResult From dual;
        --COMMIT;
        Return 1;
    End update_time_mast;

    Function update_time_daily Return Number As
        Cursor cur_mast Is
        Select
            mastkeyid,
            yymm,
            empno,
            parent,
            assign
        From
            time_mast;

    Begin
        For c1 In cur_mast Loop
            Update time_daily
            Set
                mastkeyid = c1.mastkeyid
            Where
                    yymm = c1.yymm
                And empno = c1.empno
                And parent = c1.parent
                And assign = c1.assign;

        End Loop;

        Update time_daily
        Set
            dailykeyid = dbms_random.string('X', 8);

        Return 1;
    End update_time_daily;

    Function update_time_ot Return Number As
        Cursor cur_mast Is
        Select
            mastkeyid,
            yymm,
            empno,
            parent,
            assign
        From
            time_mast;

    Begin
        For c1 In cur_mast Loop
            Update time_ot
            Set
                mastkeyid = c1.mastkeyid
            Where
                    yymm = c1.yymm
                And empno = c1.empno
                And parent = c1.parent
                And assign = c1.assign;

        End Loop;

        Update time_ot
        Set
            otkeyid = dbms_random.string('X', 8);

        Return 1;
    End update_time_ot;

    Procedure x As
        nresult Number;
    Begin
        nresult := update_time_mast;
        nresult := update_time_daily;
        nresult := update_time_ot;
        Commit;
    End;

    Procedure insert_emplmast_graduation (
        p_empno      Varchar2,
        p_graduation Varchar2
    ) As
    Begin
        Delete From hr_emplast_address_graduation
        Where
            hr_emplast_address_graduation.graduation_id Not In (
                Select
                    regexp_substr(p_graduation, '[^,]+', 1, level) graduation_id
                From
                    dual
                Connect By
                    regexp_substr(p_graduation, '[^,]+', 1, level) Is Not Null
            )
            And hr_emplast_address_graduation.empno = Trim(p_empno);

        Insert Into hr_emplast_address_graduation
            With graduation_list As (
                Select
                    regexp_substr(p_graduation, '[^,]+', 1, level) graduation_id
                From
                    dual
                Connect By
                    regexp_substr(p_graduation, '[^,]+', 1, level) Is Not Null
            )
            Select
                p_empno,
                graduation_list.graduation_id
            From
                graduation_list
            Where
                graduation_list.graduation_id Not In (
                    Select
                        graduation_id
                    From
                        hr_emplast_address_graduation
                    Where
                        empno = Trim(p_empno)
                );

    End;

End ngts_sanjay;

/
