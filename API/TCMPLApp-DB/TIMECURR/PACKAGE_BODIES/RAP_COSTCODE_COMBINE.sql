Create Or Replace Package Body "TIMECURR"."RAP_COSTCODE_COMBINE" As

    Function get_group_costcode(
        p_costcode Varchar2
    ) Return Varchar2 Is
        v_costcode rap_costcode_group.costcode%Type;
    Begin
        Select
            cg.costcode
        Into
            v_costcode
        From
            rap_costcode_group           cg,
            rap_costcode_group_costcodes cgc
        Where
            cg.group_id      = cgc.group_id
            And cgc.costcode = Trim(p_costcode);

        Return v_costcode;

    End get_group_costcode;

    Function get_costcode_code(
        p_empno Varchar2
    ) Return Varchar2 Is
        v_code rap_costcode_group_costcodes.code%Type;
    Begin

        Select
            cgc.code
        Into
            v_code
        From
            rap_costcode_group_costcodes               cgc, emplmast e
        Where
            cgc.costcode = e.assign
            And e.empno  = Trim(p_empno);

        Return v_code;

    End get_costcode_code;

    Function get_orderby_costcode(
        p_group_costcode Varchar2,
        p_orderby        Number
    ) Return Varchar2 Is
        v_costcode rap_costcode_group.costcode%Type;
    Begin
        Select
            cgc.costcode
        Into
            v_costcode
        From
            rap_costcode_group           cg,
            rap_costcode_group_costcodes cgc
        Where
            cg.group_id     = cgc.group_id
            And cgc.orderby = p_orderby
            And cg.costcode = Trim(p_group_costcode);

    End get_orderby_costcode;

    Function get_sap_costcode(
        p_costcode Varchar2
    ) Return Varchar2 Is
        v_sapcc costmast.sapcc%Type;
    Begin
        Select
            sapcc
        Into
            v_sapcc
        From
            costmast
        Where
            costcode = Trim(p_costcode);

        Return v_sapcc;

    End get_sap_costcode;

    Function get_empcount(p_costcode In Varchar2,
                          p_reportmode  Varchar2) Return Number As
        v_empcount Number;
    Begin
        If p_reportmode = 'COMBINED' Then
            Select
                Sum(changed_nemps)
            Into
                v_empcount
            From
                (
                    Select
                        Case nvl(changed_nemps, 0)
                            When 0 Then
                                nvl(noofemps, 0)
                            Else
                                nvl(changed_nemps, 0)
                        End changed_nemps
                    From
                        costmast
                    Where
                        costcode In (
                            Select
                                cgc.costcode
                            From
                                rap_costcode_group           cg,
                                rap_costcode_group_costcodes cgc
                            Where
                                cg.group_id     = cgc.group_id
                                And cg.costcode = Trim(p_costcode)
                        )
                );
        Else
            Select
                Case Sum(nvl(changed_nemps, 0))
                    When 0 Then
                        Sum(nvl(noofemps, 0))
                    Else
                        Sum(nvl(changed_nemps, 0))
                End
            Into
                v_empcount
            From
                costmast
            Where
                costcode = p_costcode;
        End If;
        Return v_empcount;
    End get_empcount;

End rap_costcode_combine;
/
Grant Execute On "TIMECURR"."RAP_COSTCODE_COMBINE" To "TCMPL_APP_CONFIG";