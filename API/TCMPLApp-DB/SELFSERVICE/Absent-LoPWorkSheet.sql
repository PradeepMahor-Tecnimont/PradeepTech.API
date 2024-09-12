/*
Select
    *
From
    ss_absent_detail
Where
    key_id In (
        Select
            key_id
        From
            ss_absent_master
        Where
            ss_absent_master.payslip_yyyymm    = '202110'
            And ss_absent_master.absent_yyyymm = '202109'
    );
    
    select ABSENT_YYYYMM ,
PAYSLIP_YYYYMM ,
MODIFIED_BY,
to_char(MODIFIED_ON ,'dd-Mon-yyyy HH24:mi') mod_on ,
KEY_ID  from ss_absent_master m where m.absent_yyyymm='202109' and m.payslip_yyyymm='202110';;
*/


Select
    d.*,to_char(modified_on, 'dd-Mon-yyyy HH24:mi') det_mod_on,
    (
        Select
            to_char(modified_on, 'dd-Mon-yyyy HH24:mi')
        From
            ss_absent_master m
        Where
            m.absent_yyyymm      = d.absent_yyyymm
            And m.payslip_yyyymm = d.payslip_yyyymm
    ) mast_modi_on
From
    ss_absent_detail d
Where
    d.payslip_yyyymm    = '202110'
    And d.absent_yyyymm = '202109';
    
    update ss_absent_detail d set modified_on = (
        Select
            modified_on
        From
            ss_absent_master m
        Where
            m.absent_yyyymm      = d.absent_yyyymm
            And m.payslip_yyyymm = d.payslip_yyyymm
    )
    Where
    d.payslip_yyyymm    = '202110'
    And d.absent_yyyymm = '202108';



alter trigger SS_TRIG_ABSENT_DETAIL_01 disable ;
alter trigger SS_TRIG_ABSENT_DETAIL_01 enable ;