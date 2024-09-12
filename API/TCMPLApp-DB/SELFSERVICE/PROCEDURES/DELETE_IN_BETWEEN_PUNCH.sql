--------------------------------------------------------
--  DDL for Procedure DELETE_IN_BETWEEN_PUNCH
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SELFSERVICE"."DELETE_IN_BETWEEN_PUNCH" (
    param_empno   In Varchar2,
    param_pdate   In Date
) As

    getinpunch       Constant Number := 0;
    getoutpunch      Constant Number := 1;
    vinpunch         Number;
    voutpunch        Number;
    vinhh            Number;
    vinmn            Number;
    vouthh           Number;
    voutmn           Number;
    vinrow           ss_punch%rowtype;
    voutrow          ss_punch%rowtype;
    v_first_row_id   Rowid;
    v_last_row_id    Rowid;
Begin
    If param_empno Is Null Or param_pdate Is Null Then
        return;
    End If;
/*
  Select dd,empno,falseflag,hh,mach,mm,mon,pdate,ss,yyyy  from ss_punch 
    where empno = paramEmpNo and pdate = paramPDate 
    order by hh,mm,ss,mach;
  */
    Select Rowid
    Into
        v_first_row_id
    From (
            Select a.rowid,
                   a.*
            From ss_punch a
            Where empno   = param_empno
                And pdate   = param_pdate
            Order By hh, mm, ss
        )
    Where Rownum = 1;

    Select Rowid
    Into
        v_last_row_id
    From (
            Select a.rowid,
                   a.*
            From ss_punch a
            Where empno   = param_empno
                And pdate   = param_pdate
            Order By
                hh Desc,
                mm Desc,
                ss Desc
        )
    Where Rownum = 1;

  /*
  vInPunch := FirstLastPunch(paramEMPNO,paramPDATE, GetInPunch);
  vOutPunch := FirstLastPunch(paramEMPNO,paramPDATE, GetOutPunch);
  vInHH := Floor(vInPunch / 60);
  vInMN := MOD(vInPunch, 60);
  vOutHH := Floor(vOutPunch / 60);
  vOutMN := Mod(vOutPunch , 60); 
  */

    Delete From ss_punch Where Rowid Not In (
                v_first_row_id, v_last_row_id
            )
        And empno   = param_empno
        And pdate   = param_pdate;

    --and hh <> vInHH and mm <> vInMn And hh <> vOutHH and mm <> vOutMn;

  --Update ss_punch set falseflag = 0 Where empno = paramEMPNO and pDate = paramPDate 
    --and hh <> vInHH and mm <> vInMn And hh <> vOutHH and mm <> vOutMn;

    Commit;
Exception
    When no_data_found Then
        Null;
End delete_in_between_punch;


/
