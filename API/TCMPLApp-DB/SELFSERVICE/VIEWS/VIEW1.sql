--------------------------------------------------------
--  DDL for View VIEW1
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."VIEW1" ("YYYYMM", "ENTRYBY", "PAYSLIP_PERIOD", "ENTRY_DATE", "LOCK_STATUS") AS 
  Select
    a.period As yyyymm,
    a.modified_by || ' - ' || b.name entryby,
    To_Char(To_Date(a.period, 'yyyymm'), 'Mon-yyyy') payslip_period,
    To_Char(a.modified_on, 'dd-Mon-yyyy') entry_date,
    Case Nvl(is_open, 'KO')
        When 'OK' Then
            'Open'
        Else
            'Closed'
    End lock_status
From
    ss_absent_payslip_period   a,
    ss_emplmast                b
Where
    a.modified_by = b.empno
Order By
    a.period Desc
;
