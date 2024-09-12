
create or replace view tcmpl_hr.ofb_vu_emp_exits as
Select
    ee.empno,
    emp.personid,
    emp.name     employee_name,
    emp.grade,
    ee.parent,
    c.name       dept_name,
    ee.end_by_date,
    ee.relieving_date,
    ee.RESIGNATION_DATE,
    emp.doj,
    emp.dol,
    ee.remarks   initiator_remarks,
    ee.address,
    ee.mobile_primary,
    ee.alternate_number,
    ee.email_id,
    ee.created_by,
    ee.created_on,
    ee.modified_by,
    ee.modified_on,
    emp.desgcode ,
    d.desg,
    d.desg desgdesc,
    pkg_ofb_approval.fn_is_approval_complete(ee.empno) approval_status
From
    tcmpl_hr.ofb_emp_exits     ee,
    tcmpl_hr.ofb_vu_emplmast   emp,
    tcmpl_hr.ofb_vu_costmast   c,
    tcmpl_hr.ofb_vu_desgmast d
Where
    ee.empno = emp.empno
    and emp.desgcode = d.desgcode(+)
    And ee.parent = c.costcode