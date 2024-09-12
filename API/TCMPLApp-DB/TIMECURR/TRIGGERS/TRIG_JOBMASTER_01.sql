Create Or Replace Trigger timecurr.trig_jobmaster_01
Before Update Of revision
On jobmaster
Referencing Old As old New As new
For Each Row
Begin
    If nvl(:old.revision, 0) = nvl(:new.revision, 0) Then
        Return;
    End If;
    Insert Into jobmaster_log(
        actual_closing_date,
        business_line,
        client_name,
        closing_date_rev1,
        company,
        consortium_group,
        country,
        expected_closing_date,
        form_date,
        invoicing_grp_company,
        job_mode_status,
        job_open_date,
        loc,
        location,
        loi_contract_date,
        loi_contract_no,
        phase,
        plant_progress_no,
        plant_type,
        projno,
        revision,
        scope_of_work,
        short_desc,
        sub_business_line,
        tcmno,
        type_of_job,
        approved_vpdir,
        approved_dirop,
        approved_amfi,
        appdt_vpdir,
        appdt_dirop,
        appdt_amfi,
        appdt_pm,
        dirvp_empno,
        dirop_empno,
        amfi_empno,
        PM_EMPNO,
        is_legacy,
        form_mode
    )

    Values
    (
        :old.actual_closing_date,
        :old.business_line,
        :old.client_name,
        :old.closing_date_rev1,
        :old.company,
        :old.consortium_group,
        :old.country,
        :old.expected_closing_date,
        :old.form_date,
        :old.invoicing_grp_company,
        :old.job_mode_status,
        :old.job_open_date,
        :old.loc,
        :old.location,
        :old.loi_contract_date,
        :old.loi_contract_no,
        :old.phase,
        :old.plant_progress_no,
        :old.plant_type,
        :old.projno,
        :old.revision,
        :old.scope_of_work,
        :old.short_desc,
        :old.sub_business_line,
        :old.tcmno,
        :old.type_of_job,
        :old.approved_vpdir,
        :old.approved_dirop,
        :old.approved_amfi,
        :old.appdt_vpdir,
        :old.appdt_dirop,
        :old.appdt_amfi,
        :old.appdt_pm,
        :old.dirvp_empno,
        :old.dirop_empno,
        :old.amfi_empno,
        :old.PM_EMPNO,
        :old.is_legacy,
        :old.form_mode
    );
Exception
    When Others Then
        Null;
End;