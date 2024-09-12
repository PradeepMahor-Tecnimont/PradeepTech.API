--------------------------------------------------------
--  DDL for Package Body PKG_SHIFT
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."PKG_SHIFT" As

    Procedure create_like (
        param_from_shift      Varchar2,
        param_to_shift        Varchar2,
        param_to_shift_desc   Varchar2,
        param_success         Out   Varchar2,
        param_message         Out   Varchar2
    ) As

        v_count           Number;
        v_to_shift        Varchar2(2);
        v_from_shift      Varchar2(2);
        v_to_shift_desc   Varchar2(60);
        v_start_tran      Varchar2(10);
    Begin
        v_start_tran      := dbms_random.string('X', 10);
        param_success     := 'KO';
        param_message     := 'Initialization';
        If length(trim(param_to_shift)) <> 2 Then
            param_success   := 'KO';
            param_message   := 'Err - Target Shift Code length should be 2 characters.';
            return;
        End If;

        If length(Trim(param_to_shift_desc)) Not Between 1 And 60 Then
            param_success   := 'KO';
            param_message   := 'Err - Target Shift Description length should be between 1 and 60 characters.';
            return;
        End If;

        v_from_shift      := upper(substr(param_from_shift, 1, 2));
        v_to_shift        := upper(trim(param_to_shift));
        v_to_shift_desc   := param_to_shift_desc;
        --
        Select
            Count(*)
        Into v_count
        From
            ss_shiftmast
        Where
            shiftcode = v_from_shift;

        If v_count = 0 Then
            param_success   := 'KO';
            param_message   := 'Err - Source Shift not found.';
            return;
        End If;

        Select
            Count(*)
        Into v_count
        From
            ss_shiftmast
        Where
            shiftcode = v_to_shift;

        If v_count > 0 Then
            param_success   := 'KO';
            param_message   := 'Err - Target Shift already exists.';
            return;
        End If;
        --

        Savepoint start_tran;

        --
        Insert Into ss_shiftmast (
            shiftcode,
            shiftdesc,
            timein_hh,
            timein_mn,
            timeout_hh,
            timeout_mn,
            shift4allowance,
            lunch_mn,
            ot_applicable
        )
            Select
                v_to_shift,
                v_to_shift_desc,
                timein_hh,
                timein_mn,
                timeout_hh,
                timeout_mn,
                shift4allowance,
                lunch_mn,
                ot_applicable
            From
                ss_shiftmast
            Where
                shiftcode = v_from_shift;

        Insert Into ss_lunchmast (
            shiftcode,
            parent,
            starthh,
            startmn,
            endhh,
            endmn
        )
            Select
                v_to_shift,
                parent,
                starthh,
                startmn,
                endhh,
                endmn
            From
                ss_lunchmast
            Where
                shiftcode = v_from_shift;

        Insert Into ss_halfdaymast (
            shiftcode,
            parent,
            hday1_starthh,
            hday1_startmm,
            hday1_endhh,
            hday1_endmm,
            hday2_starthh,
            hday2_startmm,
            hday2_endhh,
            hday2_endmm
        )
            Select
                v_to_shift,
                parent,
                hday1_starthh,
                hday1_startmm,
                hday1_endhh,
                hday1_endmm,
                hday2_starthh,
                hday2_startmm,
                hday2_endhh,
                hday2_endmm
            From
                ss_halfdaymast
            Where
                shiftcode = v_from_shift;

        Commit;
        param_success     := 'OK';
        param_message     := 'Shift created successfully.';
    Exception
        When Others Then
            Rollback To save_tran;
            param_success   := 'KO';
            param_message   := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End create_like;

End pkg_shift;


/
