Alter Table ss_swipe_mach_mast Add(
office_id Varchar2(1)
);

Update
    ss_swipe_mach_mast
Set
    office_id = substr(Trim(office), -1);
Update
    ss_swipe_mach_mast
Set
    office_id = 'D'
Where
    mach_name = 'D061';

Alter Table ss_swipe_mach_mast Modify(office_id Varchar2(1) Not Null);