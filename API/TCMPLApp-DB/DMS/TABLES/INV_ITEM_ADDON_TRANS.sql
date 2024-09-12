--------------------------------------------------------
  --  DDL for Table INV_ITEM_ADDON_TRANS
  --------------------------------------------------------

  Create Table dms.inv_item_addon_trans
   (trans_id Varchar2(10 Byte),
    trans_date Date,
    trans_type Char(3 Byte),
    container_item_type Varchar2(5),
    container_item_id Varchar2(20 Byte),
    addon_item_type Varchar2(5),
    addon_item_id Varchar2(20 Byte),
    modified_by Varchar2(5 Byte)
   );
--------------------------------------------------------
--  DDL for Index INV_ITEM_ADDON_TRANS_PK
--------------------------------------------------------

Create Unique Index dms.inv_item_addon_trans_pk On dms.inv_item_addon_trans (trans_id);
--------------------------------------------------------
--  Constraints for Table INV_ITEM_ADDON_TRANS
--------------------------------------------------------

Alter Table dms.inv_item_addon_trans Modify (trans_date Not Null Enable);
  Alter Table dms.inv_item_addon_trans Modify (modified_by Not Null Enable);
  Alter Table dms.inv_item_addon_trans Modify (addon_item_id Not Null Enable);
  Alter Table dms.inv_item_addon_trans Modify (container_item_type Not Null Enable);
  Alter Table dms.inv_item_addon_trans Modify (addon_item_type Not Null Enable);
  Alter Table dms.inv_item_addon_trans Modify (container_item_id Not Null Enable);
  Alter Table dms.inv_item_addon_trans Modify (trans_type Not Null Enable);
  Alter Table dms.inv_item_addon_trans Add Constraint inv_item_addon_trans_pk Primary Key (trans_id);
  Alter Table dms.inv_item_addon_trans Modify (trans_id Not Null Enable);
--------------------------------------------------------
--  Ref Constraints for Table INV_ITEM_ADDON_TRANS
--------------------------------------------------------

Alter Table dms.inv_item_addon_trans Add Constraint inv_item_addon_trans_fk1 Foreign Key (trans_type)
      References dms.inv_transaction_types (trans_type_id) Enable;