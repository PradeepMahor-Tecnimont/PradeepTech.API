select distinct A.SERIAL_NO as Lc_Serial_No,
       LC_ACTION_QRY.fn_Get_COMPANY(A.COMPANY_CODE) as Company,
       LC_ACTION_QRY.fn_Get_Project(A.projno) as Project,
       LC_ACTION_QRY.fn_Get_Bank(E.Issuing_Bank) as Issuing_Bank,
       LC_ACTION_QRY.fn_Get_Bank(E.Discounting_Bank) as Discounting_Bank,
       LC_ACTION_QRY.fn_Get_Bank(E.Advising_Bank) as Advising_Bank,

       'LC not yet issued (Under discussion list)' as LC_not_yet_issued,
       LC_ACTION_QRY.fn_Get_Currency(A.CURRENCY_KEY_ID) as Currency,
       LC_ACTION_QRY.fn_Get_LC_AMOUNT(A.LC_Key_Id) as Amount_in_currency,
       LC_ACTION_QRY.fn_Get_AMOUNT_IN_INR(A.LC_Key_Id) as Equivalent_amount_in_INR,

       to_char(A.LC_CL_MOD_ON, 'dd-Mon-yyyy') as Date_of_opening_LC,
       'Expiry date (final)' as Expiry_date_final,
       E.NO_OF_DAYS as Usance,
       to_char(E.payment_date_est, 'dd-Mon-yyyy') as LC_pay_Due_Date_Theoritical,
       LC_ACTION_QRY.fn_Get_Vendor(A.VENDOR_KEY_ID) as Beneficiary,
       LC_ACTION_QRY.fn_Get_PO(A.LC_KEY_ID) as PO_NO,
       to_char(F.acceptance_date, 'dd-Mon-yyyy') as LC_ACCEPTANCE_DATE,
       to_char(F.payment_date_act, 'dd-Mon-yyyy') as LC_pay_Due_Dateper_acceptance,
       (A.LC_CL_ACTUAL_AMOUNT + A.LC_CL_OTHER_CHARGES) as Amount_repaid_to_the_bank,

       LC_ACTION_QRY.fn_Get_COMMISSION_RATE(A.LC_KEY_ID) as COMMISSION_RATE,
       LC_ACTION_QRY.fn_Get_Days(A.LC_KEY_ID) as Days,
       'Commission Charged' as Commission_Charged,
       'ILC SFMS Handling Charges' as ILC_SFMS_Handling,
       'Total charges till LC issuance' as Total_charges_issuance,
       'Discounting rate' as Disctng_rate,
       'Discounting charges (formula)' as Disctng_charges_formula,
       'Discounting handling commission' as Disctng_handling_commission,
       LC_ACTION_QRY.fn_Get_TOTAL_LC_charges(A.LC_KEY_ID) as TOTAL_LC_charges
  from Afc_Lc_Main A, Afc_Lc_Banks E, afc_lc_acceptance F
 where F.lc_key_id = A.Lc_Key_Id
   and E.Lc_Key_Id = A.Lc_Key_Id;