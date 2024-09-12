--------------------------------------------------------
--  DDL for Procedure PROC_DM_ACTION
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "PROC_DM_ACTION" 
  ( p_assetid in varchar2,
    p_user in varchar2,
    p_sdesk in varchar2,
    p_target_asset in varchar2,
    p_action number,
    p_remark varchar2,
    p_msg_type out number,
    p_msg out varchar2
  ) as 
  
  vTransUID char(11);
  vPCname varchar2(20);
  vEmployees varchar2(50);
  vUsername varchar2(50);
  cursor cur_pcuser is select empno from dm_usermaster 
    where upper(trim(deskid)) = upper(trim(p_sdesk));
  vOutofservice_Flag Number(1);
  vAssetType varchar2(2);
  
begin
  vPCname := dm_getpcname(p_assetid); 
  vTransUID := desk.GetDMUid(1);
  
    begin
        select outofservice_flag into vOutofservice_Flag from dm_action_type
          where typeid = p_action;
        
        select upper(trim(assettype)) into vAssetType from dm_assetcode 
          where upper(trim(barcode)) = upper(trim(p_assetid));
    exception
        when others then null;
    end;
  -- Insert into action transaction --
    if length(p_sdesk) > 0 then
      vEmployees := desk.GetEmployees(p_sdesk);
    else
      vEmployees := null;
    end if;
    insert into dm_action_trans(actiontransid,assetid,sourcedesk,targetasset,action_type,
      remarks,action_date,action_by,source_emp)
    values(vTransUID,p_assetid,p_sdesk,p_target_asset,p_action,p_remark,sysdate,p_user,vEmployees);
    commit;
  -- Out of service --
  if vOutofservice_Flag = 1 then
      -- Remove 'p_assetid' from desk allocation --
        delete from dm_deskallocation where deskid = p_sdesk and 
          assetid = p_assetid;
        commit;
      -- Remove login rights for 'p_assetid' --
        for c2 in cur_pcuser loop
            vUsername := '';
            vUsername := dm_getuser(c2.empno);
            begin
                insert into dm_pending_pc_lock(empno,tdate,pcname,loginid,add_in_pc,deskid)
                values(c2.empno,sysdate,vPCname,vUsername,-1,p_sdesk);            
                commit;
            exception
                when others then null;
            end;
        end loop;        
      if length(p_target_asset) > 0 then           
        -- Add 'p_target_asset' to desk allocation --
          insert into dm_deskallocation(deskid,assetid)
            values(p_sdesk,p_target_asset);
          commit;
          if vAssetType = 'PC' or vAssetType = 'NB' Then
            -- Add login rights to 'p_target_asset' --            
              for c3 in cur_pcuser loop              
                begin
                    insert into dm_loginright(trans_id,trans_date,to_desk,to_machine,empno)
                    values('Action module',sysdate,p_sdesk,vPCname,c3.empno);                  
                    commit;
                exception
                    when others then null;
                end;
              end loop; 
          end if;
      end if;
      -- Asset master update --
        /*update dm_assetcode set out_of_service = 1,
          outofservice_type = p_action
          where upper(trim(barcode)) = upper(trim(p_assetid));*/
        update ams.dm_asset_mast set out_of_service = 1,
          outofservice_type = p_action
          where upper(trim(barcode)) = upper(trim(p_assetid));        
        commit;
        
  else
    -- Asset master update --
      update ams.dm_asset_mast set out_of_service = 0,
        outofservice_type = p_action
        where upper(trim(barcode)) = upper(trim(p_assetid));
      /*update dm_assetcode set out_of_service = 0,
        outofservice_type = p_action
        where upper(trim(barcode)) = upper(trim(p_assetid));*/
      commit;
  
  end if;
  p_msg_type := 1;
  p_msg := 'Sucessfully Updated';
exception
  when others then
    p_msg_type := -1;
    p_msg := 'Error - ' || sqlcode || sqlerrm;
    
end proc_dm_action;

/
