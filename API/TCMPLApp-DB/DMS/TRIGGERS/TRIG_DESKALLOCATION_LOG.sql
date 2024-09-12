--------------------------------------------------------
--  DDL for Trigger TRIG_DESKALLOCATION_LOG
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "TRIG_DESKALLOCATION_LOG" 
AFTER INSERT OR DELETE ON "DM_DESKALLOCATION_08SEP20" 
REFERENCING OLD AS OLD NEW AS NEW 
for each row
  --asset_type varchar2(2);
BEGIN
  declare
    v_asset_type varchar2(2);
    v_test Number(1);
    vTransUID char(11) := DESK.GETDMUID(0);
  begin
    begin
      if inserting then
        select assettype into v_asset_type from dm_assetcode where trim(barcode) = trim(:new.assetid);
      elsif deleting then
        select assettype into v_asset_type from dm_assetcode where trim(barcode) = trim(:old.assetid);
      end if;
    exception
      when others then null;
    end;    
      if inserting then      
        INSERT INTO DM_DESKALLOCATION_LOG(DESKID, ASSETID,FLAG,LOG_DATE,asset_type,trans_id) 
          VALUES(:new.deskid, :new.assetid,'I',sysdate,nvl(v_asset_type,'XX'),vTransUID);
      elsif deleting then
        INSERT INTO DM_DESKALLOCATION_LOG(DESKID, ASSETID,FLAG,LOG_DATE,asset_type,trans_id) 
          VALUES(:old.deskid, :old.assetid,'D',sysdate,nvl(v_asset_type,'XX'),vTransUID);
      end if;
    
  end;
END;
/
ALTER TRIGGER "TRIG_DESKALLOCATION_LOG" ENABLE;
