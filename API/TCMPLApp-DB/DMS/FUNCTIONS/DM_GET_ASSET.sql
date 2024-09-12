--------------------------------------------------------
--  DDL for Function DM_GET_ASSET
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "DM_GET_ASSET" (
    param_assets       In Varchar2,/*Comma Separated Assets Lists (eg. 'IT073IP000328,IT084MO001641,IT085NB000079,TICB/PR/00108')*/
    param_asset_type   In Varchar2,    /*MO / PC / TL / PR */
    param_asset_num    In Number/* (1 / 2 )Eg 1 - First Monitor / 2 - Second Monitor */
) Return Varchar2 As
    v_find_count   Number;
    v_prev_pos     Number;
    v_curr_pos     Number;
    v_next_pos     Number;
    v_asset        Varchar2 (30);
    v_loop_cntr number;
    v_asset_type varchar2(2);
    v_asset_list varchar2(400);
Begin
    if param_assets is null then return null; end if;
    v_asset_list := param_assets || ',';
    v_prev_pos := 1;
    v_curr_pos := 0;
    v_find_count := 0;
    Loop
        v_loop_cntr := nvl(v_loop_cntr,0) + 1;
        v_curr_pos := instr (v_asset_list, ',', v_prev_pos);
        If v_curr_pos = 0 Then
            Return Null;
        End If;
        v_asset := null;
        v_asset := substr (v_asset_list, v_prev_pos, v_curr_pos - v_prev_pos);
        v_asset_type := substr (v_asset, 6, 2);
        if param_asset_type = 'PC' And v_asset_type In ( 'PC', 'NB' ) Then
            v_find_count := v_find_count + 1;
        ElsIf  ( param_asset_type = 'TL'  And v_asset_type In ( 'IP', 'TL','T/' ) ) Then
            v_find_count := v_find_count + 1;
        ElsIf param_asset_type = v_asset_type  Then 
            v_find_count := v_find_count + 1;
        End If;
        If v_find_count = param_asset_num Then
            Return v_asset;
        End If;
        v_prev_pos := v_curr_pos + 1;
        v_curr_pos := 0;
        if v_loop_cntr = 10 then
            return 'ERRRRRR';
        end if;
        
    End Loop;
Exception
  when others then return 'ExERRRR';
End dm_get_asset;

/
