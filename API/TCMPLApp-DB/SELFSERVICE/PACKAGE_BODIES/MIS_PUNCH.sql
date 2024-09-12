--------------------------------------------------------
--  DDL for Package Body MIS_PUNCH
--------------------------------------------------------

Create Or Replace Package Body "SELFSERVICE"."MIS_PUNCH" As

    Function get_first_punch_office(
        param_empno Varchar2,
        param_pdate Date
    ) Return Varchar2 Is
        /*
            Cursor cur_punch Is
                Select
                    *
                From
                    ss_punch
                Where
                    empno           = param_empno
                    And Trim(pdate) = Trim(param_pdate);
*/
        vmach   Varchar2(30);
        voffice Varchar2(30);
    Begin

        Select
                Max(mach) Keep (Dense_Rank First Order By
                hh, mm)
        Into
            vmach
        From
            ss_punch
        Where
            empno     = param_empno
            And pdate = param_pdate;
  
        /*      
              For c1 In cur_punch
              Loop
                  vmach := c1.mach;
                  Exit;
              End Loop;
              */
        Select
            office
        Into
            voffice
        From
            ss_swipe_mach_mast
        Where
            Trim(mach_name) = Trim(vmach);
        Return voffice;
    Exception
        When Others Then
            Return 'ERR';
    End get_first_punch_office;

End mis_punch;
/