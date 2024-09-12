--------------------------------------------------------
--  DDL for Package RAP_EXCEL
--------------------------------------------------------

create or replace Package Body            "TIMECURR"."RAP_EXCEL" As
     Procedure import_mhrs_proj_current_jobs(
        p_person_id              Varchar2,
        p_meta_id                Varchar2,
        p_costcode               Varchar2,
        p_projno                 Varchar2,
        p_projections            typ_tab_string,
        p_projections_errors Out typ_tab_string,
        p_message_type       Out Varchar2,
        p_message_text       Out Varchar2
    ) As
        v_costcode          prjcmast.costcode%type;
        v_projno            prjcmast.projno%type;
        v_yymm              prjcmast.yymm%type;
        v_hours             prjcmast.hours%type;

        v_valid_proj_cntr    Number := 0;
        tab_valid_projections typ_tab_projections;
        v_rec_projection      rec_projection;
        v_err_num           Number;
        is_error_in_row     Boolean;
        v_count             Number;
        v_reason            Varchar2(30);
        v_msg_text          Varchar2(200);
        v_msg_type          Varchar2(10);
        v_hour              prjcmast.hours%type;
        v_hour_decimal      Number;
        v_hour_decimal_len  Number;
    Begin
        v_err_num := 0;
        For i In 1..p_projections.count
        Loop
            is_error_in_row := false;
            With
                csv As (
                    Select
                        p_projections(i) str
                    From
                        dual
                )
            Select
                Trim(regexp_substr(str, '(.*?)(\~!~|$)', 1, 1, Null, 1))                       costcode,
                Trim(regexp_substr(str, '(.*?)(\~!~|$)', 1, 2, Null, 1))                       projno,
                Trim(regexp_substr(str, '(.*?)(\~!~|$)', 1, 3, Null, 1))                       yymm,
                Trim(regexp_substr(str, '(.*?)(\~!~|$)', 1, 4, Null, 1))                       hours
            Into
                v_costcode,
                v_projno,
                v_yymm,
                v_hours
            From
                csv; 

            --costcode            
            If p_costcode != v_costcode Then
                v_err_num       := v_err_num + 1;
                p_projections_errors(v_err_num) :=
                    v_err_num || '~!~' ||   --ID
                    '' || '~!~' ||          --Section
                    i || '~!~' ||           --XL row number
                    'Costcode' || '~!~' ||   --FieldName
                    '0' || '~!~' ||         --ErrorType
                    'Critical' || '~!~' ||  --ErrorTypeString
                    'Costcode does not match';    --Message
                is_error_in_row := true;
            End If;

            --projno            
            If p_projno != v_projno Then
                v_err_num       := v_err_num + 1;
                p_projections_errors(v_err_num) :=
                    v_err_num || '~!~' ||   --ID
                    '' || '~!~' ||          --Section
                    i || '~!~' ||           --XL row number
                    'Projno' || '~!~' ||   --FieldName
                    '0' || '~!~' ||         --ErrorType
                    'Critical' || '~!~' ||  --ErrorTypeString
                    'Projno does not match';    --Message
                is_error_in_row := true;
            End If;

            --yymm
            Select
                Count(*)
            Into
                v_count
            From
                prjcmast
            Where
                yymm = v_yymm
                And projno = p_projno
                And costcode = p_costcode
                And yymm >= (select pros_month from tsconfig);
            If v_count = 0 Then
                v_err_num       := v_err_num + 1;
                p_projections_errors(v_err_num) :=
                    v_err_num || '~!~' ||   --ID
                    '' || '~!~' ||          --Section
                    i || '~!~' ||           --XL row number
                    'Yymm' || '~!~' ||    --FieldName
                    '0' || '~!~' ||         --ErrorType
                    'Critical' || '~!~' ||  --ErrorTypeString
                    'Yymm not found / before processing month';     --Message
                is_error_in_row := true;
            End If;

            --hours
            Begin
                v_hour := to_number(v_hours);

                if v_hour < 0 or v_hour is null then
                    v_err_num       := v_err_num + 1;
                    p_projections_errors(v_err_num) :=
                        v_err_num || '~!~' ||   --ID
                        '' || '~!~' ||          --Section
                        i || '~!~' ||           --XL row number
                        'Hours' || '~!~' ||  --FieldName
                        '0' || '~!~' ||         --ErrorType
                        'Critical' || '~!~' ||  --ErrorTypeString
                        'Invalid hours';   --Message
                    is_error_in_row := true;
                end if;

                --scale 2
                v_hour_decimal := instr(v_hour,'.');
                if v_hour_decimal > 0 then
                    v_hour_decimal_len := substr(v_hour, v_hour_decimal+1);
                    if Length(v_hour_decimal_len) > 2 then
                        v_err_num       := v_err_num + 1;
                        p_projections_errors(v_err_num) :=
                            v_err_num || '~!~' ||   --ID
                            '' || '~!~' ||          --Section
                            i || '~!~' ||           --XL row number
                            'Hours' || '~!~' ||  --FieldName
                            '0' || '~!~' ||         --ErrorType
                            'Critical' || '~!~' ||  --ErrorTypeString
                            'Hours - only 2 decimals allowed';   --Message
                        is_error_in_row := true; 
                    end if;
                end if;

                --precision
               if v_hour_decimal > 11 or (v_hour_decimal = 0 and length(v_hours) >10) then
                    v_err_num       := v_err_num + 1;
                    p_projections_errors(v_err_num) :=
                        v_err_num || '~!~' ||   --ID
                        '' || '~!~' ||          --Section
                        i || '~!~' ||           --XL row number
                        'Hours' || '~!~' ||  --FieldName
                        '0' || '~!~' ||         --ErrorType
                        'Critical' || '~!~' ||  --ErrorTypeString
                        'Hours - only max. 10 number length allowed';   --Message
                    is_error_in_row := true; 
               end if;

            Exception
                When Others then                   
                    v_err_num       := v_err_num + 1;
                    p_projections_errors(v_err_num) :=
                        v_err_num || '~!~' ||   --ID
                        '' || '~!~' ||          --Section
                        i || '~!~' ||           --XL row number
                        'Hours' || '~!~' ||  --FieldName
                        '0' || '~!~' ||         --ErrorType
                        'Critical' || '~!~' ||  --ErrorTypeString
                        'Invalid hours';   --Message
                    is_error_in_row := true;                    
            End;

            If is_error_in_row = false Then
                v_valid_proj_cntr := nvl(v_valid_proj_cntr, 0) + 1;

                tab_valid_projections(v_valid_proj_cntr).costcode := v_costcode;
                tab_valid_projections(v_valid_proj_cntr).projno := v_projno;
                tab_valid_projections(v_valid_proj_cntr).yymm := v_yymm;
                tab_valid_projections(v_valid_proj_cntr).hours := v_hours;
            End If;
        End Loop;

        If v_err_num != 0 Then
            p_message_type := 'OO';
            p_message_text := 'Not all records were imported.';
            Return;
        End If;

        For i In 1..v_valid_proj_cntr
        Loop            
            Update
                prjcmast
            Set
                hours = tab_valid_projections(i).hours
            Where
                yymm = tab_valid_projections(i).yymm
                And projno = tab_valid_projections(i).projno
                And costcode = tab_valid_projections(i).costcode;            
        End Loop;
        Commit;

        If v_err_num != 0 Then
            p_message_type := 'OO';
            p_message_text := 'Not all records were imported.';

        Else
            p_message_type := 'OK';
            p_message_text := 'File imported successfully.';
        End If;
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := sqlcode || ' - ' || sqlerrm;
    End import_mhrs_proj_current_jobs;

    Procedure import_mhrs_proj_expected_jobs(
        p_person_id              Varchar2,
        p_meta_id                Varchar2,
        p_costcode               Varchar2,
        p_projno                 Varchar2,
        p_projections            typ_tab_string,
        p_projections_errors Out typ_tab_string,
        p_message_type       Out Varchar2,
        p_message_text       Out Varchar2
    ) As
        v_costcode          exptprjc.costcode%type;
        v_projno            exptprjc.projno%type;
        v_yymm              exptprjc.yymm%type;
        v_hours             exptprjc.hours%type;

        v_valid_proj_cntr    Number := 0;
        tab_valid_projections typ_tab_projections;
        v_rec_projection      rec_projection;
        v_err_num           Number;
        is_error_in_row     Boolean;
        v_count             Number;
        v_reason            Varchar2(30);
        v_msg_text          Varchar2(200);
        v_msg_type          Varchar2(10);
        v_hour              exptprjc.hours%type;
        v_hour_decimal      Number;
        v_hour_decimal_len  Number;
    Begin
        v_err_num := 0;
        For i In 1..p_projections.count
        Loop
            is_error_in_row := false;
            With
                csv As (
                    Select
                        p_projections(i) str
                    From
                        dual
                )
            Select
                Trim(regexp_substr(str, '(.*?)(\~!~|$)', 1, 1, Null, 1))                       costcode,
                Trim(regexp_substr(str, '(.*?)(\~!~|$)', 1, 2, Null, 1))                       projno,
                Trim(regexp_substr(str, '(.*?)(\~!~|$)', 1, 3, Null, 1))                       yymm,
                Trim(regexp_substr(str, '(.*?)(\~!~|$)', 1, 4, Null, 1))                       hours
            Into
                v_costcode,
                v_projno,
                v_yymm,
                v_hours
            From
                csv; 

            --costcode            
            If p_costcode != v_costcode Then
                v_err_num       := v_err_num + 1;
                p_projections_errors(v_err_num) :=
                    v_err_num || '~!~' ||   --ID
                    '' || '~!~' ||          --Section
                    i || '~!~' ||           --XL row number
                    'Costcode' || '~!~' ||   --FieldName
                    '0' || '~!~' ||         --ErrorType
                    'Critical' || '~!~' ||  --ErrorTypeString
                    'Costcode does not match';    --Message
                is_error_in_row := true;
            End If;
            
            --projno            
            If p_projno != v_projno Then
                v_err_num       := v_err_num + 1;
                p_projections_errors(v_err_num) :=
                    v_err_num || '~!~' ||   --ID
                    '' || '~!~' ||          --Section
                    i || '~!~' ||           --XL row number
                    'Projno' || '~!~' ||   --FieldName
                    '0' || '~!~' ||         --ErrorType
                    'Critical' || '~!~' ||  --ErrorTypeString
                    'Projno does not match';    --Message
                is_error_in_row := true;
            End If;
            
            --yymm
            Select
                Count(*)
            Into
                v_count
            From
                exptprjc
            Where
                yymm = v_yymm
                And projno = p_projno
                And costcode = p_costcode
                And yymm >= (select pros_month from tsconfig);
            If v_count = 0 Then
                v_err_num       := v_err_num + 1;
                p_projections_errors(v_err_num) :=
                    v_err_num || '~!~' ||   --ID
                    '' || '~!~' ||          --Section
                    i || '~!~' ||           --XL row number
                    'Yymm' || '~!~' ||    --FieldName
                    '0' || '~!~' ||         --ErrorType
                    'Critical' || '~!~' ||  --ErrorTypeString
                    'Yymm not found / before processing month';     --Message
                is_error_in_row := true;
            End If;

            --hours
            Begin
                v_hour := to_number(v_hours);
                
                if v_hour < 0 or v_hour is null then
                    v_err_num       := v_err_num + 1;
                    p_projections_errors(v_err_num) :=
                        v_err_num || '~!~' ||   --ID
                        '' || '~!~' ||          --Section
                        i || '~!~' ||           --XL row number
                        'Hours' || '~!~' ||  --FieldName
                        '0' || '~!~' ||         --ErrorType
                        'Critical' || '~!~' ||  --ErrorTypeString
                        'Invalid hours';   --Message
                    is_error_in_row := true;
                end if;
                
                --scale 2
                v_hour_decimal := instr(v_hour,'.');
                if v_hour_decimal > 0 then
                    v_hour_decimal_len := substr(v_hour, v_hour_decimal+1);
                    if Length(v_hour_decimal_len) > 2 then
                        v_err_num       := v_err_num + 1;
                        p_projections_errors(v_err_num) :=
                            v_err_num || '~!~' ||   --ID
                            '' || '~!~' ||          --Section
                            i || '~!~' ||           --XL row number
                            'Hours' || '~!~' ||  --FieldName
                            '0' || '~!~' ||         --ErrorType
                            'Critical' || '~!~' ||  --ErrorTypeString
                            'Hours - only 2 decimals allowed';   --Message
                        is_error_in_row := true; 
                    end if;
                end if;
                
                --precision
               if v_hour_decimal > 11 or (v_hour_decimal = 0 and length(v_hours) >10) then
                    v_err_num       := v_err_num + 1;
                    p_projections_errors(v_err_num) :=
                        v_err_num || '~!~' ||   --ID
                        '' || '~!~' ||          --Section
                        i || '~!~' ||           --XL row number
                        'Hours' || '~!~' ||  --FieldName
                        '0' || '~!~' ||         --ErrorType
                        'Critical' || '~!~' ||  --ErrorTypeString
                        'Hours - only max. 10 number length allowed';   --Message
                    is_error_in_row := true; 
               end if;
                        
            Exception
                When Others then                   
                    v_err_num       := v_err_num + 1;
                    p_projections_errors(v_err_num) :=
                        v_err_num || '~!~' ||   --ID
                        '' || '~!~' ||          --Section
                        i || '~!~' ||           --XL row number
                        'Hours' || '~!~' ||  --FieldName
                        '0' || '~!~' ||         --ErrorType
                        'Critical' || '~!~' ||  --ErrorTypeString
                        'Invalid hours';   --Message
                    is_error_in_row := true;                    
            End;
            
            If is_error_in_row = false Then
                v_valid_proj_cntr := nvl(v_valid_proj_cntr, 0) + 1;

                tab_valid_projections(v_valid_proj_cntr).costcode := v_costcode;
                tab_valid_projections(v_valid_proj_cntr).projno := v_projno;
                tab_valid_projections(v_valid_proj_cntr).yymm := v_yymm;
                tab_valid_projections(v_valid_proj_cntr).hours := v_hours;
            End If;
        End Loop;
        
        If v_err_num != 0 Then
            p_message_type := 'OO';
            p_message_text := 'Not all records were imported.';
            Return;
        End If;

        For i In 1..v_valid_proj_cntr
        Loop            
            Update
                exptprjc
            Set
                hours = tab_valid_projections(i).hours
            Where
                yymm = tab_valid_projections(i).yymm
                And projno = tab_valid_projections(i).projno
                And costcode = tab_valid_projections(i).costcode;            
        End Loop;
        Commit;
        
        If v_err_num != 0 Then
            p_message_type := 'OO';
            p_message_text := 'Not all records were imported.';

        Else
            p_message_type := 'OK';
            p_message_text := 'File imported successfully.';
        End If;
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := sqlcode || ' - ' || sqlerrm;
    End import_mhrs_proj_expected_jobs;
    
    Procedure import_overtime_update(
        p_person_id            Varchar2,
        p_meta_id              Varchar2,
        p_costcode             Varchar2,
        p_overtimes            typ_tab_string,
        p_overtimes_errors Out typ_tab_string,
        p_message_type     Out Varchar2,
        p_message_text     Out Varchar2
    ) As
        v_costcode            otmast.costcode%Type;
        v_yymm                otmast.yymm%Type;
        v_ots                 otmast.ot%Type;

        v_valid_overtime_cntr Number := 0;
        tab_valid_overtimes   typ_tab_overtimes;
        v_rec_overtime        rec_overtime;
        v_err_num             Number;
        is_error_in_row       Boolean;
        v_count               Number;
        v_reason              Varchar2(30);
        v_msg_text            Varchar2(200);
        v_msg_type            Varchar2(10);
        v_ot                  otmast.ot%Type;
    Begin
        v_err_num := 0;
        For i In 1..p_overtimes.count
        Loop
            is_error_in_row := false;
            With
                csv As (
                    Select
                        p_overtimes(i) str
                    From
                        dual
                )
            Select
                Trim(regexp_substr(str, '(.*?)(\~!~|$)', 1, 1, Null, 1)) costcode,
                Trim(regexp_substr(str, '(.*?)(\~!~|$)', 1, 2, Null, 1)) yymm,
                Trim(regexp_substr(str, '(.*?)(\~!~|$)', 1, 3, Null, 1)) ot
            Into
                v_costcode,
                v_yymm,
                v_ots
            From
                csv; 

            --costcode            
            If p_costcode != v_costcode Then
                v_err_num       := v_err_num + 1;
                p_overtimes_errors(v_err_num) :=
                    v_err_num || '~!~' ||
       --ID
                    '' || '~!~' ||
              --Section
                    i || '~!~' ||
               --XL row number
                    'Costcode' || '~!~' ||
       --FieldName
                    '0' || '~!~' ||
             --ErrorType
                    'Critical' || '~!~' ||
      --ErrorTypeString
                    'Costcode does not match';
        --Message
                is_error_in_row := true;
            End If;
            
            --yymm
            Select
                Count(*)
            Into
                v_count
            From
                otmast
            Where
                yymm         = v_yymm
                And costcode = p_costcode
                And yymm >= (
                    Select
                        pros_month
                    From
                        tsconfig
                );
            If v_count = 0 Then
                v_err_num       := v_err_num + 1;
                p_overtimes_errors(v_err_num) :=
                    v_err_num || '~!~' ||
       --ID
                    '' || '~!~' ||
              --Section
                    i || '~!~' ||
               --XL row number
                    'Yymm' || '~!~' ||
        --FieldName
                    '0' || '~!~' ||
             --ErrorType
                    'Critical' || '~!~' ||
      --ErrorTypeString
                    'Yymm not found / before processing month';
         --Message
                is_error_in_row := true;
            End If;

            --ot
            Begin
                v_ot := to_number(v_ots);

                If v_ot < 1 Or v_ot > 100 Or v_ot Is Null Then
                    v_err_num       := v_err_num + 1;
                    p_overtimes_errors(v_err_num) :=
                        v_err_num || '~!~' ||
       --ID
                        '' || '~!~' ||
              --Section
                        i || '~!~' ||
               --XL row number
                        'OT' || '~!~' ||
      --FieldName
                        '0' || '~!~' ||
             --ErrorType
                        'Critical' || '~!~' ||
      --ErrorTypeString
                        'Invalid OT';
       --Message
                    is_error_in_row := true;
                End If;

            Exception
                When Others Then
                    v_err_num       := v_err_num + 1;
                    p_overtimes_errors(v_err_num) :=
                        v_err_num || '~!~' ||
       --ID
                        '' || '~!~' ||
              --Section
                        i || '~!~' ||
               --XL row number
                        'OT' || '~!~' ||
      --FieldName
                        '0' || '~!~' ||
             --ErrorType
                        'Critical' || '~!~' ||
      --ErrorTypeString
                        'Invalid OT';
       --Message
                    is_error_in_row := true;
            End;

            If is_error_in_row = false Then
                v_valid_overtime_cntr                               := nvl(v_valid_overtime_cntr, 0) + 1;

                tab_valid_overtimes(v_valid_overtime_cntr).costcode := v_costcode;
                tab_valid_overtimes(v_valid_overtime_cntr).yymm     := v_yymm;
                tab_valid_overtimes(v_valid_overtime_cntr).ot       := v_ots;
            End If;
        End Loop;

        If v_err_num != 0 Then
            p_message_type := 'OO';
            p_message_text := 'Not all records were imported.';
            Return;
        End If;

        For i In 1..v_valid_overtime_cntr
        Loop
            Update
                otmast
            Set
                ot = tab_valid_overtimes(i).ot
            Where
                yymm         = tab_valid_overtimes(i).yymm
                And costcode = tab_valid_overtimes(i).costcode;
        End Loop;
        Commit;

        If v_err_num != 0 Then
            p_message_type := 'OO';
            p_message_text := 'Not all records were imported.';

        Else
            p_message_type := 'OK';
            p_message_text := 'File imported successfully.';
        End If;
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := sqlcode || ' - ' || sqlerrm;
    End import_overtime_update;
        
    Procedure import_mhrs_proj_exp_job_proco(
        p_person_id              Varchar2,
        p_meta_id                Varchar2,
        p_projections            typ_tab_string,
        p_projections_errors Out typ_tab_string,
        p_message_type       Out Varchar2,
        p_message_text       Out Varchar2
    ) As
        v_costcode            exptprjc.costcode%Type;
        v_projno              exptprjc.projno%Type;
        v_yymm                exptprjc.yymm%Type;
        v_hours               exptprjc.hours%Type;
        n_count               Number;
        n_yymm                Number;
        
        v_valid_proj_cntr     Number := 0;
        tab_valid_projections typ_tab_projections;
        v_rec_projection      rec_projection;
        v_err_num             Number;
        is_error_in_row       Boolean;
        v_count               Number;
        v_msg_text            Varchar2(200);
        v_msg_type            Varchar2(10);
        v_hour                exptprjc.hours%Type;
        v_hour_decimal        Number;
        v_hour_decimal_len    Number;
    Begin
        v_err_num := 0;
        For i In 1..p_projections.count
        Loop
            is_error_in_row := false;
            With
                csv As (
                    Select
                        p_projections(i) str
                    From
                        dual
                )
            Select
                Trim(regexp_substr(str, '(.*?)(\~!~|$)', 1, 1, Null, 1)) costcode,
                Trim(regexp_substr(str, '(.*?)(\~!~|$)', 1, 2, Null, 1)) projno,
                Trim(regexp_substr(str, '(.*?)(\~!~|$)', 1, 3, Null, 1)) yymm,
                Trim(regexp_substr(str, '(.*?)(\~!~|$)', 1, 4, Null, 1)) hours
            Into
                v_costcode,
                v_projno,
                v_yymm,
                v_hours
            From
                csv; 

            --costcode           
            Select
                Count(costcode)
            Into
                n_count
            From
                costmast
            Where
                costcode   = v_costcode
                And (costcode Like '02%' Or costcode Like '0D%')
                And active = 1;
            If n_count = 0 Then
                v_err_num       := v_err_num + 1;
                p_projections_errors(v_err_num) :=
                    v_err_num || '~!~' ||
       --ID
                    '' || '~!~' ||
              --Section
                    i || '~!~' ||
               --XL row number
                    'Costcode' || '~!~' ||
       --FieldName
                    '0' || '~!~' ||
             --ErrorType
                    'Critical' || '~!~' ||
      --ErrorTypeString
                    'Cost code does not match';
        --Message
                is_error_in_row := true;
            End If;
            
            --projno   
            Select
                Count(projno)
            Into
                n_count
            From
                exptjobs
            Where
                projno     = v_projno
                And (nvl(active,0) = 1 Or nvl(activefuture,0) = 1);
            If n_count = 0 Then
                v_err_num       := v_err_num + 1;
                p_projections_errors(v_err_num) :=
                    v_err_num || '~!~' ||
       --ID
                    '' || '~!~' ||
              --Section
                    i || '~!~' ||
               --XL row number
                    'Projno' || '~!~' ||
       --FieldName
                    '0' || '~!~' ||
             --ErrorType
                    'Critical' || '~!~' ||
      --ErrorTypeString
                    'Project does not match';
        --Message
                is_error_in_row := true;
            End If;
            
            --yymm
            Begin
                Select
                    round(to_number(v_yymm),0)
                Into
                    n_yymm
                From
                    dual;
                If n_yymm <= 0 Or length(n_yymm) != 6 Or substr(n_yymm, 5, 2) > 12 Or Instr(v_yymm,'.') != 0 Then
                    v_err_num := v_err_num + 1;
                    p_projections_errors(v_err_num) :=
                        v_err_num || '~!~' ||
       --ID
                        '' || '~!~' ||
              --Section
                        i || '~!~' ||
               --XL row number
                        'Yymm' || '~!~' ||
        --FieldName
                        '0' || '~!~' ||
             --ErrorType
                        'Critical' || '~!~' ||
      --ErrorTypeString
                        'Yymm not valid';
         --Message
                    is_error_in_row := true;
                End If;
            Exception
                When Others Then
                    v_err_num := v_err_num + 1;
                    p_projections_errors(v_err_num) :=
                        v_err_num || '~!~' ||
       --ID
                        '' || '~!~' ||
              --Section
                        i || '~!~' ||
               --XL row number
                        'Yymm' || '~!~' ||
        --FieldName
                        '0' || '~!~' ||
             --ErrorType
                        'Critical' || '~!~' ||
      --ErrorTypeString
                        'Yymm not valid';
         --Message
                        is_error_in_row := true;
            End;

            Select
                Count(*)
            Into
                v_count
            From
                tsconfig
            Where
                pros_month <= v_yymm;
            If v_count = 0 Then
                v_err_num       := v_err_num + 1;
                p_projections_errors(v_err_num) :=
                    v_err_num || '~!~' ||
       --ID
                    '' || '~!~' ||
              --Section
                    i || '~!~' ||
               --XL row number
                    'Yymm' || '~!~' ||
        --FieldName
                    '0' || '~!~' ||
             --ErrorType
                    'Critical' || '~!~' ||
      --ErrorTypeString
                    'Yymm not found / before processing month';
         --Message
                is_error_in_row := true;
            End If;

            --hours
            Begin
                v_hour         := to_number(v_hours);

                If v_hour < 0 Or v_hour Is Null Then
                    v_err_num       := v_err_num + 1;
                    p_projections_errors(v_err_num) :=
                        v_err_num || '~!~' ||
       --ID
                        '' || '~!~' ||
              --Section
                        i || '~!~' ||
               --XL row number
                        'Hours' || '~!~' ||
      --FieldName
                        '0' || '~!~' ||
             --ErrorType
                        'Critical' || '~!~' ||
      --ErrorTypeString
                        'Invalid hours';
       --Message
                    is_error_in_row := true;
                End If;
                
                --scale 2
                v_hour_decimal := instr(v_hour, '.');
                If v_hour_decimal > 0 Then
                    v_hour_decimal_len := substr(v_hour, v_hour_decimal + 1);
                    If length(v_hour_decimal_len) > 2 Then
                        v_err_num       := v_err_num + 1;
                        p_projections_errors(v_err_num) :=
                            v_err_num || '~!~' ||
       --ID
                            '' || '~!~' ||
              --Section
                            i || '~!~' ||
               --XL row number
                            'Hours' || '~!~' ||
      --FieldName
                            '0' || '~!~' ||
             --ErrorType
                            'Critical' || '~!~' ||
      --ErrorTypeString
                            'Hours - only 2 decimals allowed';
       --Message
                        is_error_in_row := true;
                    End If;
                End If;
                
                --precision
                If v_hour_decimal > 11 Or (v_hour_decimal = 0 And length(v_hours) > 10) Then
                    v_err_num       := v_err_num + 1;
                    p_projections_errors(v_err_num) :=
                        v_err_num || '~!~' ||
       --ID
                        '' || '~!~' ||
              --Section
                        i || '~!~' ||
               --XL row number
                        'Hours' || '~!~' ||
      --FieldName
                        '0' || '~!~' ||
             --ErrorType
                        'Critical' || '~!~' ||
      --ErrorTypeString
                        'Hours - only max. 10 number length allowed';
       --Message
                    is_error_in_row := true;
                End If;

            Exception
                When Others Then
                    v_err_num       := v_err_num + 1;
                    p_projections_errors(v_err_num) :=
                        v_err_num || '~!~' ||
       --ID
                        '' || '~!~' ||
              --Section
                        i || '~!~' ||
               --XL row number
                        'Hours' || '~!~' ||
      --FieldName
                        '0' || '~!~' ||
             --ErrorType
                        'Critical' || '~!~' ||
      --ErrorTypeString
                        'Invalid hours';
       --Message
                    is_error_in_row := true;
            End;

            If is_error_in_row = false Then
                v_valid_proj_cntr                                 := nvl(v_valid_proj_cntr, 0) + 1;

                tab_valid_projections(v_valid_proj_cntr).costcode := v_costcode;
                tab_valid_projections(v_valid_proj_cntr).projno   := v_projno;
                tab_valid_projections(v_valid_proj_cntr).yymm     := v_yymm;
                tab_valid_projections(v_valid_proj_cntr).hours    := v_hours;
            End If;
        End Loop;

        If v_err_num != 0 Then
            p_message_type := 'OO';
            p_message_text := 'Not all records were imported.';
            Return;
        End If;

        For i In 1..v_valid_proj_cntr
        Loop
            Select
                Count(costcode)
            Into
                n_count
            From
                exptprjc
            Where
                yymm         = tab_valid_projections(i).yymm
                And projno   = tab_valid_projections(i).projno
                And costcode = tab_valid_projections(i).costcode;
            If n_count = 0 Then
                Insert Into exptprjc(costcode, projno, yymm, hours)
                Values(tab_valid_projections(i).costcode,
                    tab_valid_projections(i).projno, tab_valid_projections(i).yymm, tab_valid_projections(i).hours);
            Else
                Update
                    exptprjc
                Set
                    hours = tab_valid_projections(i).hours
                Where
                    yymm         = tab_valid_projections(i).yymm
                    And projno   = tab_valid_projections(i).projno
                    And costcode = tab_valid_projections(i).costcode;
            End If;
        End Loop;
        Commit;

        If v_err_num != 0 Then
            p_message_type := 'OO';
            p_message_text := 'Not all records were imported.';

        Else
            p_message_type := 'OK';
            p_message_text := 'File imported successfully.';
        End If;
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := sqlcode || ' - ' || sqlerrm;
    End import_mhrs_proj_exp_job_proco;
End RAP_EXCEL;