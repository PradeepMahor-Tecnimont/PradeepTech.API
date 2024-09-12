--------------------------------------------------------
--  DDL for View SWP_VU_EMP_VACCINE_DATE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."SWP_VU_EMP_VACCINE_DATE" ("EMPNO", "NAME", "PARENT", "GRADE", "VACCINE_TYPE", "JAB1_DATE", "FIRST_JAB_SPONSOR", "JAB2_DATE", "SECOND_JAB_SPONSOR", "CAN_EDIT", "MODIFIED_ON") AS 
  Select
        d.empno,
        e.name,
        e.parent,
        e.grade,
        d.vaccine_type,
        d.jab1_date,
        Case nvl(d.is_jab1_by_office, 'KO')
            When 'OK' Then
                'Office'
            When 'KO' Then
                'Self'
        End first_jab_sponsor,
        d.jab2_date,
        Case d.is_jab2_by_office
            When 'OK' Then
                'Office'
            When 'KO' Then
                'Self'
            Else
                ''
        End second_jab_sponsor,
        Case
            When d.jab2_date Is Null Then
                'OK'
            Else
                'KO'
        End can_edit,
        d.modified_on
    From
        swp_vaccine_dates d,
        ss_emplmast       e
    Where
        d.empno      = e.empno
        And e.status = 1
;
  GRANT SELECT ON "SELFSERVICE"."SWP_VU_EMP_VACCINE_DATE" TO "TCMPL_APP_CONFIG";
