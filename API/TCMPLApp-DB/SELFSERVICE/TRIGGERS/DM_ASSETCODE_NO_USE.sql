--------------------------------------------------------
--  DDL for Trigger DM_ASSETCODE_NO_USE
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "SELFSERVICE"."DM_ASSETCODE_NO_USE" 
before update of scrap,scrap_date,out_of_service on XDM_ASSETCODE_05DEC16 
referencing old as old new as new 
for each row

begin
  declare
    vTransUID char(11) := DESK.GETDMUID(0);
  begin  
    If nvl(trim(:new.assettype),'xX') in ('PC','IP','TL') then
    /*
      if :new.scrap <> :old.scrap and :new.scrap_date <> :old.scrap_date Then
        if nvl(:new.scrap,0) = 1 Then
            insert into dm_deskallocation_log( DESKID ,ASSETID ,FLAG ,LOG_DATE ,asset_type)
              values ('Scrap',:new.barcode,'S',sysdate,:new.assettype);
        else
            insert into dm_deskallocation_log( DESKID ,ASSETID ,FLAG ,LOG_DATE ,asset_type)
              values ('Scrap',:new.barcode,'I',sysdate,:new.assettype);
        end if;
      elsif :new.out_of_service <> :old.out_of_service then
          if nvl(:new.out_of_service,0) = 1 then
            insert into dm_deskallocation_log( DESKID ,ASSETID ,FLAG ,LOG_DATE ,asset_type)
              values ('NoUse',:new.barcode,'O',sysdate,:new.assettype);
        else
            insert into dm_deskallocation_log( DESKID ,ASSETID ,FLAG ,LOG_DATE ,asset_type)
              values ('NoUse',:new.barcode,'I',sysdate,:new.assettype);
          end if;
      end If;
      */
      if :new.out_of_service <> :old.out_of_service then
        if nvl(:new.out_of_service,0) = 1 then
          insert into dm_asset_out_of_use_log ( barcode, OLD_SCRAP_VAL ,OLD_SCRAP_DATE ,OLD_OUT_OF_SRV ,
                                                NU_SCRAP_VAL ,NU_SCRAP_DATE ,NU_OUT_OF_SRV ,log_date,trans_id,asset_type ) 
                                      values (:new.barcode, :old.scrap,:old.scrap_date,:old.out_of_service,
                                                :new.scrap,:new.scrap_date,:new.out_of_service,SYSDATE+1/1440,vTransUID,:new.assettype);
        else
          insert into dm_asset_out_of_use_log ( barcode, OLD_SCRAP_VAL ,OLD_SCRAP_DATE ,OLD_OUT_OF_SRV ,
                                                NU_SCRAP_VAL ,NU_SCRAP_DATE ,NU_OUT_OF_SRV ,log_date,trans_id, asset_type ) 
                                      values (:new.barcode, :old.scrap,:old.scrap_date,:old.out_of_service,
                                                :new.scrap,:new.scrap_date,:new.out_of_service,SYSDATE-1/1440,vTransUID,:new.assettype);
        end if;
      else
        insert into dm_asset_out_of_use_log ( barcode, OLD_SCRAP_VAL ,OLD_SCRAP_DATE ,OLD_OUT_OF_SRV ,
                                              NU_SCRAP_VAL ,NU_SCRAP_DATE ,NU_OUT_OF_SRV ,log_date,trans_id,asset_type ) 
                                    values (:new.barcode, :old.scrap,:old.scrap_date,:old.out_of_service,
                                              :new.scrap,:new.scrap_date,:new.out_of_service,SYSDATE,vTransUID,:new.assettype);
      end if;
    end if;
  end;
exception
  when others then null;
end;

/
ALTER TRIGGER "SELFSERVICE"."DM_ASSETCODE_NO_USE" ENABLE;
