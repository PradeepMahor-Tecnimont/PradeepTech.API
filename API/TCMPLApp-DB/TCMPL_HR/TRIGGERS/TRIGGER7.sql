Create Or Replace Trigger "TCMPL_HR"."TRIGGER7"
Before Insert Or Update Of empno, desk_no, mail_id, phone_off, fax, voip, mobile_res, phone_res, mobile_off, r_add_1, pan,
passport_no, issue_date, expiry_date, passport_issued_at, blood_group, domain_login, user_update, surname, name, father_name,
p_add_1, f_add_1, ref_person_name, ref_person_phone, location, punch_card_status, dob, father_occupation, insr_details,
co_bus, pick_up_point, r_pincode, p_pincode, f_pincode, marital_status, religion, include_dad_husb_name, no_dad_husb_in_name
On emp_details
Referencing Old As old New As new
For Each Row
Begin
    :new.modified_on := sysdate;
End;