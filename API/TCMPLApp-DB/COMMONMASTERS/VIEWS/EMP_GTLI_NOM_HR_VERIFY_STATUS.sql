--------------------------------------------------------
--  DDL for View EMP_GTLI_NOM_HR_VERIFY_STATUS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "COMMONMASTERS"."EMP_GTLI_NOM_HR_VERIFY_STATUS" ("EMPNO", "NAME", "PARENT", "DOJ", "EMAIL", "HR_VERIFIED", "HR_VEIFIED_DATE", "STATUS", "HR_VERIFIED_STATUS", "FILE_UPLOADED") AS 
  Select
    a.empno,
    b.name,
    b.parent,
    b.doj,
    b.email,
    Case a.hr_verified
        When 'OK' Then
            'Yes'
        Else
            'No'
    End hr_verified,
    modified_on hr_veified_date,
    status,
    Nvl(a.hr_verified, 'KO') hr_verified_status,
    pkg_ed.is_emp_gtli_nom_file_uploaded(a.empno) File_uploaded
From
    emp_gtli_status   a,
    emplmast          b
Where
    a.empno = b.empno
Union
Select
    empno,
    name,
    parent,
    doj,
    email,
    'No',
    Null,
    status,
    'KO',
    pkg_ed.is_emp_gtli_nom_file_uploaded(empno) File_uploaded
From
    emplmast
Where
    empno Not In (
        Select
            empno
        From
            emp_gtli_status
    ) And emptype = 'R'
;
