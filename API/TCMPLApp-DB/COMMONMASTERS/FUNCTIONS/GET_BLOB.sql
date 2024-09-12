--------------------------------------------------------
--  DDL for Function GET_BLOB
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "COMMONMASTERS"."GET_BLOB" ( param_id Number ) Return Blob Is
        v_blob Blob;
    Begin
        Select
            blob_field
        Into
            v_blob
        From
            xl_blob
        Where
            key_id = param_id;

        Return v_blob;
    Exception
        When Others Then
            Return null;
    End get_blob;

/
