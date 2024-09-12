--------------------------------------------------------
--  DDL for Package Body USER_PROFILE
--------------------------------------------------------

Create Or Replace Package Body "SELFSERVICE"."USER_PROFILE" As

    Function get_profile(param_empno Varchar2) Return Number As
        vcount Number;
    Begin
        --W A R N I N G
        --X X X X
        --Do not change the sequence of the Select Statements.

        If param_empno = '02320' Then
            --  return c_type_uhrd;
            Null;
        End If;

        --HR
        Select
            Count(empno)
        Into
            vcount
        From
            ss_usermast
        Where
            empno      = Trim(param_empno)
            And active = 1
            And type   = 1;
        If vcount > 0 Then
            Return c_type_uhrd;
        End If;


        --HOD
        Select
            Count(empno)
        Into
            vcount
        From
            ss_emplmast
        Where
            mngr       = Trim(param_empno)
            And status = 1
            And emptype In ('R', 'S', 'C');
        If vcount > 0 Then
            Return c_type_uhod;
        End If;

        --IT USB Manager
        Select
            Count(empno)
        Into
            vcount
        From
            ss_usermast
        Where
            empno      = Trim(param_empno)
            And active = 1
            And type   = 2;
        If vcount > 0 Then
            Return c_type_it_usb_mgr;
        End If;

        --LEAD
        Select
            Count(empno)
        Into
            vcount
        From
            ss_lead_approver
        Where
            parent In
            (
                Select
                    parent
                From
                    ss_emplmast
                Where
                    empno      = Trim(param_empno)
                    And status = 1
            )
            And empno = Trim(param_empno);
        If vcount > 0 Then
            Return c_type_ulead;
        End If;

        --Approver Secretary
        Select
            Count(empno)
        Into
            vcount
        From
            ss_delegate
        Where
            empno = Trim(param_empno);
        If vcount > 0 Then
            Return c_type_usec_appr;
        End If;

        --Secretary
        Select
            Count(empno)
        Into
            vcount
        From
            ss_user_dept_rights
        Where
            empno = Trim(param_empno);
        If vcount > 0 Then
            Return c_type_usec;
        End If;

        --Others
        Return c_type_uothers;
    Exception
        When Others Then
            --Others
            Return c_type_uothers;
    End get_profile;

    Function get_profile_desc(param_profile Number) Return Varchar As
    Begin
        Case
            When param_profile = c_type_uhod Then
                Return 'HOD';
            When param_profile = c_type_uhrd Then
                Return 'HR';
            When param_profile = c_type_ulead Then
                Return 'LEAD';
            When param_profile = c_type_uothers Then
                Return 'Others';
            When param_profile = c_type_usec Then
                Return 'Secretary';
            When param_profile = c_type_usec_appr Then
                Return 'Approver Secretary';
            Else
                Return Null;
        End Case;
    End;

    Function get_user_tcp_ip(param_empno Varchar2) Return Varchar2 As
        usertype Number;
        vretval  Varchar2(30);
    Begin
        usertype := get_profile(param_empno);
        vretval  := 'Test';
        If usertype = c_type_uhrd Then
            Select
                tcp_ip
            Into
                vretval
            From
                ss_usermast
            Where
                empno      = Trim(param_empno)
                And active = 1;
            --vRetVal := 'Test';
        Else
            vretval := 'Raj';
        End If;
        Return vretval;
    Exception
        When Others Then
            Return Null;
    End;

    Function type_hod Return Number As
    Begin
        Return c_type_uhod;
    End type_hod;

    Function type_hrd Return Number As
    Begin

        Return c_type_uhrd;
    End type_hrd;

    Function type_sec Return Number As
    Begin

        Return c_type_usec;
    End type_sec;

    Function type_lead Return Number As
    Begin

        Return c_type_ulead;
    End type_lead;

    Function type_others Return Number As
    Begin

        Return c_type_uothers;
    End type_others;

    Function type_notloggedin Return Number As
    Begin

        Return c_type_notloggedin;
    End type_notloggedin;

    Function type_sec_appr Return Number As
    Begin

        Return c_type_usec_appr;
    End type_sec_appr;


End user_profile;
/