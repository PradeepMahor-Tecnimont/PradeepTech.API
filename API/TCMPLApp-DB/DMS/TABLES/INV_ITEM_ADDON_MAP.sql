--------------------------------------------------------
  --  DDL for Table INV_ITEM_ADDON_MAP
  --------------------------------------------------------

  Create Table dms.inv_item_addon_map
   (
    fk_trans_id Varchar2(10 Byte),
    container_item_type Varchar2(5),
    container_item_id Varchar2(20 Byte),
    addon_item_type Varchar2(5),
    addon_item_id Varchar2(20 Byte)
   );
--------------------------------------------------------
--  DDL for Index INV_ITEM_ADDON_MAP_PK
--------------------------------------------------------

Create Unique Index dms.inv_item_addon_map_pk On dms.inv_item_addon_map (fk_trans_id);
--------------------------------------------------------
--  Constraints for Table INV_ITEM_ADDON_MAP
--------------------------------------------------------

Alter Table dms.inv_item_addon_map Add Constraint inv_item_addon_map_pk Primary Key (fk_trans_id);
  Alter Table dms.inv_item_addon_map Modify (fk_trans_id Not Null Enable);
--------------------------------------------------------
--  Ref Constraints for Table INV_ITEM_ADDON_MAP
--------------------------------------------------------

Alter Table dms.inv_item_addon_map Add Constraint inv_item_addon_map_fk1 Foreign Key (fk_trans_id)
      References dms.inv_item_addon_trans (trans_id) Enable;