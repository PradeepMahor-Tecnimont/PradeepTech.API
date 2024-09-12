--------------------------------------------------------
--  DDL for Package Body RAP_MHRS_PROJ
--------------------------------------------------------

Create Or Replace Package Body "TIMECURR"."RAP_MHRS_PROJ" As

    Procedure get_creation_status_proc(
        p_person_id  Varchar2,
        p_meta_id    Varchar2,
        p_projno     Varchar2,
        p_costcode   Varchar2,
        p_status Out Varchar2,
        p_result Out Varchar2
    ) As
        v_revcdate Number(6);
        v_max_yymm Number(6);
        v_active   Number(1);
    Begin
        Select
            to_number(to_char(revcdate, 'yyyymm')), active
        Into
            v_revcdate, v_active
        From
            projmast
        Where
            projno = Trim(p_projno);
            
        If v_active = 0 Then
            p_result := 'false';
            p_status := 'OK';
            Return;
        End If;
            
        Select
            Max(to_number(yymm))
        Into
            v_max_yymm
        From
            prjcmast
        Where
            costcode   = Trim(p_costcode)
            And projno = Trim(p_projno);

        If v_max_yymm Is Null Then
            p_result := 'true';
        End If;

        If v_revcdate > v_max_yymm Then
            p_result := 'true';
        Else
            p_result := 'false';
        End If;
        p_status := 'OK';
    Exception
        When Others Then
            p_status := 'KO';
            p_result := 'false';
    End get_creation_status_proc;

    Function get_yymm(
        p_person_id  Varchar2,
        p_meta_id    Varchar2,
        p_projno     Varchar2,
        p_costcode   Varchar2
    ) return Sys_Refcursor As
        p_rec Sys_Refcursor;
    Begin
        Open p_rec for
            Select
                ry.yyyy || rm.mm data_value_field,
                ry.yyyy || rm.mm data_text_field
            From
                rap_years                ry, rap_months rm
            Where
                Not Exists
                (
                    Select
                        yymm
                    From
                        prjcmast
                    Where
                        projno       = p_projno
                        And costcode = p_costcode
                        And yymm     = ry.yyyy || rm.mm
                )
                And ry.yyyy || rm.mm >= (
                    Select
                        pros_month
                    From
                        tsconfig
                )
                And ry.yyyy || rm.mm <= (
                    Select
                        to_char(revcdate, 'yyyymm')
                    From
                        projmast
                    Where
                        projno = p_projno
                        And active = 1
                )                
            Order By
                1;
        Return p_rec;
    End get_yymm;

    Function get_expected_yymm(
        p_person_id  Varchar2,
        p_meta_id    Varchar2,
        p_projno     Varchar2,
        p_costcode   Varchar2
    ) return Sys_Refcursor As
        p_rec Sys_Refcursor;
    Begin
        Open p_rec for
            Select
                ry.yyyy || rm.mm data_value_field,
                ry.yyyy || rm.mm data_text_field
            From
                rap_years                ry, rap_months rm
            Where
                Not Exists
                (
                    Select
                        yymm
                    From
                        exptprjc
                    Where
                        projno       = p_projno
                        And costcode = p_costcode
                        And yymm     = ry.yyyy || rm.mm
                )
                And ry.yyyy || rm.mm >= (
                    Select
                        pros_month
                    From
                        tsconfig
                )
            Order By
                1;
        Return p_rec;
    End get_expected_yymm;
    
End rap_mhrs_proj;
/
Grant Execute On "TIMECURR"."RAP_MHRS_PROJ" To tcmpl_app_config
/