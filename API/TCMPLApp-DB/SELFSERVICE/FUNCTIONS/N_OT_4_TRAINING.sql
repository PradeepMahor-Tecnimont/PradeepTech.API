--------------------------------------------------------
--  DDL for Function N_OT_4_TRAINING
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."N_OT_4_TRAINING" 
(  PARAM_EMPNO IN VARCHAR2  , PARAM_DATE IN DATE  ) 
RETURN Number AS 
  v_mast_ot Number;
  v_det_ot number;
  vTrain_Attended Number;
  vTrainNo Char(5);
  --const_yes constant number := 1;
  --const_no constant number := 0;


BEGIN
return ss.ss_true;
/*
  Begin
    SELECT dflag_t, otflag_t, tr_no INTO  vTrain_Attended, v_det_ot , vTrainNo FROM ss_training_list_4_ot
      WHERE empno = trim(param_empno) AND trdate_t  = param_date;
  Exception
    When Others then
      return ss.ss_true;
  End;
       SELECT COUNT(*) INTO v_mast_ot FROM ss_training_mast_4_ot
        WHERE tr_no = vTrainNo AND ot_appl   = 'Y';

        --OT Applicable in Master = 'Y'
        IF v_mast_ot > 0 Then
            IF nvl(v_det_ot,ss.ss_true) = ss.ss_true Then
              Return ss.ss_true;
            Else
              Return ss.ss_false;
            End If;
        Else--OT Applicable in Master = 'N'
            IF nvl(vTrain_Attended,ss.ss_false) = ss.ss_false And nvl(v_det_ot,ss.ss_false) = ss.ss_true Then
              Return ss.ss_true;
            Else
              Return ss.ss_false;
            End If;
        End If;
        */
END N_OT_4_TRAINING;

/
