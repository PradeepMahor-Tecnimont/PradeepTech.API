--------------------------------------------------------
--  DDL for Package Body RAP_OT
--------------------------------------------------------

Create Or Replace Package Body "TIMECURR"."RAP_OT" As
   
   Function get_yymm(
        p_person_id  Varchar2,
        p_meta_id    Varchar2,
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
                        otmast
                    Where
                        costcode = p_costcode
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
    End get_yymm;
End rap_ot;

Grant Execute On "TIMECURR"."RAP_OT" To tcmpl_app_config
/