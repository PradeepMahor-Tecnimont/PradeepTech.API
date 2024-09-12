Create Or Replace Package Body pkg_replace_sensitive_data As

    Procedure sp_replace_sensitive_data(
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
    Begin
        If commonmasters.pkg_environment.is_development = 'OK' Or commonmasters.pkg_environment.is_staging = 'OK' Then
            For i In (
                Select
                    hem.empno,
                    hem.dob,
                    hem.doj,
                    hem.metaid,
                    hem.personid,
                    heo.itno,
                    heo.bankcode,
                    heo.acctno,
                    heo.gratutityno,
                    heo.aadharno,
                    heo.pfno,
                    heo.superannuationno,
                    heo.uanno,
                    heo.pensionno
                From
                    hr_emplmast_organization heo,
                    hr_emplmast_main         hem
                Where
                    heo.empno      = hem.empno
                    And (hem.doj > To_Date('01-01-2018', 'dd-mm-yyyy') Or
                        hem.status = 1)
            )
            Loop
                Update
                    emplmast
                Set
                    dob = i.dob,
                    doj = i.doj,
                    metaid = i.metaid,
                    personid = i.personid,
                    itno = i.itno,
                    bankcode = i.bankcode,
                    acctno = i.acctno,
                    gratutityno = i.gratutityno,
                    aadharno = i.aadharno,
                    pfno = i.pfno,
                    superannuationno = i.superannuationno,
                    uanno = i.uanno,
                    pensionno = i.pensionno
                Where
                    empno = i.empno;
            End Loop;
        End If;
        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_replace_sensitive_data;

End pkg_replace_sensitive_data;
