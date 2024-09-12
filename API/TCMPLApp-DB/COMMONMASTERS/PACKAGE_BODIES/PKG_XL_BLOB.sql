--------------------------------------------------------
--  DDL for Package Body PKG_XL_BLOB
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "COMMONMASTERS"."PKG_XL_BLOB" As

    Procedure populate_table ( param_id Number, param_success out varchar2, param_message out varchar2 )
        As
    Begin
        Insert Into xl_blob_data ( key_id,sheet_nr,sheet_name,row_nr,col_nr,cell,cell_type,string_val,number_val,date_val,formula ) Select param_id
,sheet_nr,sheet_name,row_nr,col_nr,cell,cell_type,string_val,number_val,date_val,formula From
            Table ( xlsx_read.read(get_blob(param_id) ) );
        If sql%rowcount > 0 Then
            Commit;
        Else
            param_success := 'KO';
            param_message := 'No Records found in Uploaded excel id - ' || param_id;
        End If;
        param_success := 'OK';
    exception
        when others then
            param_success := 'KO';
            param_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End populate_table;

End pkg_xl_blob;

/

  GRANT EXECUTE ON "COMMONMASTERS"."PKG_XL_BLOB" TO PUBLIC;
