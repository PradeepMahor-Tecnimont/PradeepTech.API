--Grant Select On hr_grade_master To tcmpl_hr; --From TimeCurr

Create Or Replace Force Editionable View tcmpl_hr.vu_grademast (
    "GRADE_ID",
    "GRADE_DESC"
) As
    Select
        grade_id, grade_desc
    From
        timecurr.hr_grade_master;