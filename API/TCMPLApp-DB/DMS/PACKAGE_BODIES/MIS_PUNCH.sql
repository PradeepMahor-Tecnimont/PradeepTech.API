--------------------------------------------------------
--  DDL for Package Body MIS_PUNCH
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "MIS_PUNCH" as

  Function get_first_punch_office(param_empno varchar2,param_pdate date) return varchar2 is
    cursor cur_punch is select * from ss_punch where empno=param_empno
      and Trim(pdate) = Trim(param_pdate);
      
    vMach varchar2(30);
    vOffice varchar2(30);
  begin
    -- TODO: Implementation required for procedure MIS_PUNCH.get_first_punch_office
      for c1 in cur_punch   loop
          vMach := c1.mach;
          exit;
      end loop;
      select office into vOffice from ss_swipe_mach_mast where Trim(MACH_NAME) = Trim(vMach);
      Return vOffice;
  Exception
      When Others then Return 'ERR';
  end get_first_punch_office;

end mis_punch;

/
