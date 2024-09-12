--------------------------------------------------------
--  DDL for Package Body TPL_UTIL
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "COMMONMASTERS"."TPL_UTIL" As
    Function comma_to_table ( p_list In Varchar2 ) Return typ_str_tab
        Pipelined
    As
        l_string Long := p_list || ',';
        l_comma_index Pls_Integer;
        l_index Pls_Integer := 1;
    Begin
        Loop
            l_comma_index   := instr(l_string, ',', l_index);
            Exit When l_comma_index = 0;
            Pipe Row ( trim(substr(
                l_string, l_index, l_comma_index - l_index
            ) ) );
            l_index         := l_comma_index + 1;
        End Loop;

        return;
    Exception
        when others then return;
    End comma_to_table;

    Function numeric_comma_to_table ( p_list In Varchar2 ) Return typ_num_tab
        Pipelined
    As
        l_string Long := p_list || ',';
        l_comma_index Pls_Integer;
        l_index Pls_Integer := 1;
    Begin
    
        Loop
            l_comma_index   := instr(l_string, ',', l_index);
            Exit When l_comma_index = 0;
            Pipe Row ( trim(substr(
                l_string, l_index, l_comma_index - l_index
            ) ) );
            l_index         := l_comma_index + 1;
        End Loop;

        return;
        
    Exception
        when others then return ;
        
    End numeric_comma_to_table;

End tpl_util;

/

  GRANT EXECUTE ON "COMMONMASTERS"."TPL_UTIL" TO PUBLIC;
