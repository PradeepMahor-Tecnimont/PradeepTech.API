
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "DMS"."DM_ASSETCODE" ("BARCODE", "PONUM", "PODATE", "GRNUM", "INVOICENUM", "INVOICE_DATE", "ASSETKEY", "ASSETTYPE", "PRINTFLAG", "SERIALNUM", "MODEL", "MAKE", "COMPNAME", "WARRANTY_END", "SAP_ASSETCODE", "SCRAP", "SCRAP_DATE", "OUT_OF_SERVICE", "OUTOFSERVICE_TYPE", "TO_BE_SCRAP", "BARCODE_OLD", "SUB_ASSET_TYPE") AS 
  With
    asset_type_tab As (
        Select
            sub_asset_type sub_asset_type1, item_type_code , it.item_type_key_id 
        From
            inv_item_ams_asset_mapping ams_map,
            inv_item_types             it
        Where
            ams_map.item_type_key_id = it.item_type_key_id
    )
Select
    b.barcode,
    a.sap_po_no         ponum,
    a.sap_po_date       podate,
    a.gr_id             grnum,
    a.vend_inv_num      invoicenum,
    a.vend_inv_date     invoice_date,
    /*
    Case
        When substr(Trim(b.barcode), 6, 2) = 'TL' Then
            'IP'
        Else
            substr(Trim(b.barcode), 6, 2)
    End                 assettype,*/    
    c.item_type_key_id  ASSETKEY,
    c.item_type_code    assettype,
    a.bar_code_printed  printflag,
    a.mfg_sr_no         serialnum,
    a.asset_model       model,
    a.asset_make        make,
    Case
        When a.sub_asset_type = 'IT0PC' Then
            a.asset_name
        When a.sub_asset_type = 'IT0NB' Then
            a.asset_name
        Else
            Null
    End                 compname,
    a.warranty_end_date warranty_end,
    a.sap_asset_code    sap_assetcode,
    (
        Select
            Count(a.disposal_date)
        From
            ams.as_disposal_mast   a,
            ams.as_disposal_detail b
        Where
            a.disposal_id  = b.disposal_id
            And
            b.ams_asset_id = Trim(a.ams_asset_id)
    )                   scrap,
    (
        Select
            a.disposal_date
        From
            ams.as_disposal_mast   a,
            ams.as_disposal_detail b
        Where
            a.disposal_id  = b.disposal_id
            And
            b.ams_asset_id = Trim(a.ams_asset_id)
    )                   scrap_date,
    b.out_of_service,
    b.outofservice_type,
    b.to_be_scrap,
    b.barcode_old,
    a.sub_asset_type
From
    ams.as_asset_mast a,
    ams.dm_asset_mast b,
    asset_type_tab    c
Where
    Trim(a.ams_asset_id) = Trim(b.barcode)
    And a.sub_asset_type = c.sub_asset_type1(+)
Order By
    b.barcode;


  GRANT SELECT ON "DMS"."DM_ASSETCODE" TO "SELFSERVICE";
