--------------------------------------------------------
--  DDL for Package Body EMP_GEN_INFO_VALIDATE
--------------------------------------------------------
Create Or Replace Package Body tcmpl_hr.emp_gen_info_validate As
    Procedure get_lock_status(
        p_person_id              Varchar2,
        p_meta_id                Varchar2,

        p_empno                  Varchar2 Default Null,

        p_is_primary_open    Out Varchar2,
        p_is_nomination_open Out Varchar2,
        p_is_mediclaim_open  Out Varchar2,
        p_is_aadhaar_open    Out Varchar2,
        p_is_passport_open   Out Varchar2,
        p_is_gtli_open       Out Varchar2,
        p_is_secondary_open  Out Varchar2,

        p_message_type       Out Varchar2,
        p_message_text       Out Varchar2
    ) As
        rec_emp_lock_status  emp_lock_status%rowtype;
        v_for_empno          Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        If p_empno Is Null Then
            v_for_empno := get_empno_from_meta_id(p_meta_id);
            If v_for_empno = 'ERRRR' Then
                Raise e_employee_not_found;
                Return;
            End If;
        Else
            v_for_empno := p_empno;
        End If;
        p_is_primary_open    := 'KO';
        p_is_nomination_open := 'KO';
        p_is_mediclaim_open  := 'KO';
        p_is_aadhaar_open    := 'KO';
        p_is_passport_open   := 'KO';
        p_is_gtli_open       := 'KO';
        p_message_type       := 'KO';
        p_message_text       := 'INIT';

        Begin
            Select
                *
            Into
                rec_emp_lock_status
            From
                emp_lock_status
            Where
                empno = v_for_empno;

            p_is_primary_open    := Case
                                        When rec_emp_lock_status.prim_lock_open = 1 Then
                                            ok
                                        Else
                                            not_ok
                                    End;
            p_is_nomination_open := Case
                                        When rec_emp_lock_status.nom_lock_open = 1 Then
                                            ok
                                        Else
                                            not_ok
                                    End;
            p_is_mediclaim_open  := Case
                                        When rec_emp_lock_status.fmly_lock_open = 1 Then
                                            ok
                                        Else
                                            not_ok
                                    End;
            p_is_aadhaar_open    := Case
                                        When rec_emp_lock_status.adhaar_lock = 1 Then
                                            ok
                                        Else
                                            not_ok
                                    End;
            p_is_passport_open   := Case
                                        When rec_emp_lock_status.pp_lock = 1 Then
                                            ok
                                        Else
                                            not_ok
                                    End;
            p_is_gtli_open       := Case
                                        When rec_emp_lock_status.gtli_lock = 1 Then
                                            ok
                                        Else
                                            not_ok
                                    End;

            p_is_secondary_open  := Case
                                        When rec_emp_lock_status.secondary_lock = 1 Then
                                            ok
                                        Else
                                            not_ok
                                    End;

        Exception

            When Others Then
                Null;
        End;
        p_message_type       := ok;
        p_message_text       := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure get_gtli_descripancy(
        p_empno              Varchar2,
        p_descripancy    Out Varchar2,
        p_can_print_gtli Out Varchar2,
        p_message_type   Out Varchar2,
        p_message_text   Out Varchar2

    ) As
        v_pcnt_age Number;
        v_count    Number;
    Begin

        Select
            Count(*)
        Into
            v_count
        From
            emp_gtli
        Where
            empno = p_empno;

        If v_count = 0 Then
            p_descripancy := ' GTLI record not found';

        Else
            Select
                Sum(share_pcnt),
                Count(*)
            Into
                v_pcnt_age,
                v_count
            From
                emp_gtli
            Where
                empno = p_empno;

            If nvl(v_pcnt_age, 0) <> 100 Then
                p_descripancy    := 'GTLI share percentage is not 100%.';
                p_can_print_gtli := not_ok;
            Else
                p_can_print_gtli := ok;
            End If;
            If v_count > 5 Then
                p_descripancy := p_descripancy || ' Only 5 family members are eligible for GTLI.';
            End If;

            If nvl(v_pcnt_age, 0) = 100 And v_count Between 1 And 5 Then
                Select
                    Count(*)
                Into
                    v_count
                From
                    emp_scan_file
                Where
                    empno         = p_empno
                    And file_type = 'GT';
                If v_count = 0 Then
                    p_descripancy := 'Please print, sign and upload signed copy of GTLI nomination.';
                End If;
            End If;
        End If;

        p_message_type := ok;
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure get_aadhaar_descripancy(
        p_empno            Varchar2,
        p_descripancy  Out Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2

    ) As
        v_pcnt_age Number;
        v_count    Number;
    Begin

        Select
            Count(*)
        Into
            v_count
        From
            emp_adhaar
        Where
            empno = p_empno;
        If v_count = 0 Then
            p_descripancy := 'Aadhaar details not updated.';

        Else

            Select
                Count(*)
            Into
                v_count
            From
                emp_adhaar
            Where
                empno           = p_empno
                And has_aadhaar = ok;
            If v_count > 0 Then
                Select
                    Count(*)
                Into
                    v_count
                From
                    emp_scan_file
                Where
                    empno         = p_empno
                    And file_type = 'AC';
                If v_count = 0 Then
                    p_descripancy := 'Aadhaar copy not uploaded.';
                End If;

            End If;
        End If;

        p_message_type := ok;
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure get_passport_descripancy(
        p_empno            Varchar2,
        p_descripancy  Out Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2

    ) As
        v_pcnt_age Number;
        v_count    Number;
    Begin

        Select
            Count(*)
        Into
            v_count
        From
            emp_passport
        Where
            empno = p_empno;
        If v_count = 0 Then
            p_descripancy := 'Passport details not updated.';

        Else

            Select
                Count(*)
            Into
                v_count
            From
                emp_passport
            Where
                empno            = p_empno
                And has_passport = ok;
            If v_count > 0 Then
                Select
                    Count(*)
                Into
                    v_count
                From
                    emp_scan_file
                Where
                    empno         = p_empno
                    And file_type = 'PP';
                If v_count = 0 Then
                    p_descripancy := 'Passport copy not uploaded.';
                End If;

            End If;
        End If;

        p_message_type := ok;
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure get_mediclaim_descripancy(
        p_empno            Varchar2,
        p_descripancy  Out Varchar2,
        p_can_mediclaim_add Out Varchar2,
        p_can_mediclaim_edit Out Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2

    ) As
        v_pcnt_age Number;
        v_count    Number;
    Begin
 
        p_can_mediclaim_add  := ok;
        p_can_mediclaim_edit := ok;
        
        /*
         Select
            Count(*)
        Into
            v_count
        From
            vu_emplmast
        Where
            empno = p_empno and married = 'N';
        If v_count = 1 Then
          
            p_can_mediclaim_add := not_ok;
            p_can_mediclaim_edit := not_ok;
            
            p_descripancy  := 'Because your marital status is unmarried, you are unable to add dependents.';
            p_message_type := ok;            
            p_message_text := 'Procedure executed successfully.';
            
            Return;
        
        End If;   
        
        */
   
        Select
            Count(*)
        Into
            v_count
        From
            emp_family
        Where
            empno = p_empno;
        If v_count = 0 Then
            p_descripancy  := 'Mediclaim details not updated.';
            p_message_type := ok;
            p_message_text := 'Procedure executed successfully.';
            Return;
        Elsif v_count > 4 Then
            p_descripancy := p_descripancy || ' -  Only 4 family members are eligible for mediclaim.';
        End If;

        Select
            Count(*)
        Into
            v_count
        From
            emp_family
        Where
            empno        = p_empno
            And relation = 5; -- Self

        If v_count = 0 Then
            p_descripancy := 'Self record not found for mediclaim.';
        End If;

        --children of 25 years of age
        Select
            Count(*)
        Into
            v_count
        From
            emp_family
        Where
            empno = p_empno
            And relation In (3, 4)
            And dob < add_months(sysdate, -300);

        If v_count > 0 Then
            p_descripancy := p_descripancy || ' -  Children of age 25 years or more are not eligible for mediclaim.';
        End If;

        p_message_type := ok;
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure get_descripancy(

        p_person_id             Varchar2,
        p_meta_id               Varchar2,

        p_empno                 Varchar2 Default Null,

        p_primary_status    Out Varchar2,
        p_primary_text      Out Varchar2,
        p_nomination_status Out Varchar2,
        p_nomination_text   Out Varchar2,
        p_gratuity_status   Out Varchar2,
        p_gratuity_text     Out Varchar2,

        p_sup_annu_status   Out Varchar2,
        p_sup_annu_text     Out Varchar2,

        p_epf_status        Out Varchar2,
        p_epf_text          Out Varchar2,
        p_epsa_status       Out Varchar2,
        p_epsa_text         Out Varchar2,
        p_epsm_status       Out Varchar2,
        p_epsm_text         Out Varchar2,
        p_mediclaim_status  Out Varchar2,
        p_mediclaim_text    Out Varchar2,
        p_can_mediclaim_add Out Varchar2,
        p_can_mediclaim_edit Out Varchar2,
        p_pp_aa_status      Out Varchar2,
        p_pp_aa_text        Out Varchar2,
        p_aa_status         Out Varchar2,
        p_aa_text           Out Varchar2,
        p_gtli_status       Out Varchar2,
        p_gtli_text         Out Varchar2,
        p_can_print_gtli    Out Varchar2,

        p_message_type      Out Varchar2,
        p_message_text      Out Varchar2
    )
    As
        v_for_empno          Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        v_pcnt_age           Number;
        v_count              Number;
        v_message_type       Varchar2(2);
        v_message_text       Varchar2(1000);
    Begin

        If p_empno Is Null Then
            v_for_empno := get_empno_from_meta_id(p_meta_id);
            If v_for_empno = 'ERRRR' Then
                Raise e_employee_not_found;
                Return;
            End If;
        Else
            v_for_empno := p_empno;
        End If;

        p_primary_status   := ok;
        p_primary_text     := '';
        --

        Select
            Count(*)
        Into
            v_count
        From
            emp_details
        Where
            empno = v_for_empno;
        If v_count = 0 Then
            p_primary_status := not_ok;
            p_primary_text   := 'Primary / Secondary...!!';
        Else
            p_primary_status := ok;
            p_primary_text   := '';

        End If;
        
        --Gratuity
        Select
            Sum(share_pcnt)
        Into
            v_pcnt_age
        From
            emp_gratuity
        Where
            empno = v_for_empno;
        If v_pcnt_age <> 100 Or (v_pcnt_age Is Null) Then
            p_gratuity_status   := not_ok;
            p_gratuity_text     := 'Gratuity share percentage is not 100%.';

            p_nomination_status := not_ok;
            p_nomination_text   := 'Nomination ..!!';

        Else
            p_gratuity_status := ok;
            p_gratuity_text   := '';

        End If;
        --
        
        -- sup_annuation
        Select
            Sum(share_pcnt)
        Into
            v_pcnt_age
        From
            emp_sup_annuation
        Where
            empno = v_for_empno;
        If v_pcnt_age <> 100 Or (v_pcnt_age Is Null) Then
            p_sup_annu_status   := not_ok;
            p_sup_annu_text     := 'Supper annuation share percentage is not 100%.';

            p_nomination_status := not_ok;
            p_nomination_text   := 'Nomination ..!!';

        Else
            p_sup_annu_status := ok;
            p_sup_annu_text   := '';

        End If;
        --
        -- EPF status
        Select
            Sum(share_pcnt)
        Into
            v_pcnt_age
        From
            emp_epf
        Where
            empno = v_for_empno;

        If v_pcnt_age <> 100 Or (v_pcnt_age Is Null) Then
            p_epf_status        := not_ok;
            p_epf_text          := 'EPF share percentage is not 100%.';

            p_nomination_status := not_ok;
            p_nomination_text   := 'Nomination ..!!';
        Else
            p_epf_status := ok;
            p_epf_text   := '';

        End If;

        --
        -- EPF status
        Select
            Sum(share_pcnt)
        Into
            v_pcnt_age
        From
            emp_epf
        Where
            empno = v_for_empno;

        If v_pcnt_age <> 100 Or (v_pcnt_age Is Null) Then
            p_epf_text          := 'EPF share percentage is not 100%.';
            p_epf_status        := not_ok;

            p_nomination_status := not_ok;
            p_nomination_text   := 'Nomination ..!!';
        Else
            p_epf_status := ok;
            p_epf_text   := '';

        End If;

        --
        -- Employee Pension Fund status - ALL

        Select
            Count(*)
        Into
            v_count
        From
            emp_eps_4_all
        Where
            empno = v_for_empno;

        If v_count = 0 Then
            p_epsa_text   := 'Employee Pension Fund - ALL record not found';
            p_epsa_status := not_ok;
        Else
            p_epsa_status := ok;
            p_epsa_text   := '';

        End If;

        --
        -- Employee Pension Fund status - For Married

        Select
            Count(*)
        Into
            v_count
        From
            emp_eps_4_married
        Where
            empno = v_for_empno;

        If v_count = 0 Then
            p_epsm_text   := 'Employee Pension Fund - For Married record not found .';
            p_epsm_status := not_ok;
        Else

            p_epsm_status := ok;
            p_epsm_text   := '';

        End If;

        --
        -- Mediclaim
        get_mediclaim_descripancy(
            p_empno             => v_for_empno,
            p_descripancy       => p_mediclaim_text,
            p_can_mediclaim_add => p_can_mediclaim_add,
            p_can_mediclaim_edit => p_can_mediclaim_edit,
            p_message_type => v_message_type,
            p_message_text => v_message_text
        );

        If p_message_type = not_ok Then
            p_mediclaim_text := v_message_text;
        End If;

        p_mediclaim_status := Case
                                  When (Trim(p_mediclaim_text)) Is Null Then
                                      ok
                                  Else
                                      not_ok
                              End;

        -- Aadhaar
        get_aadhaar_descripancy(
            p_empno        => v_for_empno,
            p_descripancy  => p_aa_text,
            p_message_type => v_message_type,
            p_message_text => v_message_text
        );

        If p_message_type = not_ok Then
            p_aa_text := v_message_text;
        End If;

        p_aa_status        := Case
                                  When (Trim(p_aa_text)) Is Null Then
                                      ok
                                  Else
                                      not_ok
                              End;

        -- Passport
        get_passport_descripancy(
            p_empno        => v_for_empno,
            p_descripancy  => p_pp_aa_text,
            p_message_type => v_message_type,
            p_message_text => v_message_text
        );

        If p_message_type = not_ok Then
            p_pp_aa_text := v_message_text;
        End If;

        p_pp_aa_status     := Case
                                  When (Trim(p_pp_aa_text)) Is Null Then
                                      ok
                                  Else
                                      not_ok
                              End;

        -- GTLI
        get_gtli_descripancy(
            p_empno          => v_for_empno,
            p_descripancy    => p_gtli_text,
            p_can_print_gtli => p_can_print_gtli,
            p_message_type   => v_message_type,
            p_message_text   => v_message_text
        );

        If p_message_type = not_ok Then
            p_gtli_text := v_message_text;
        End If;

        p_gtli_status      := Case
                                  When Trim(p_gtli_text) Is Null Then
                                      ok
                                  Else
                                      not_ok
                              End;

        p_message_type     := ok;
        p_message_text     := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End;
    --
End;