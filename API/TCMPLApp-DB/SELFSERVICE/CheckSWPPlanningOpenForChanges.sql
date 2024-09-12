----connect to selfservice
Select
    *
From
    swp_config_weeks
Order By
    start_date;

---
Select
    *
From
    swp_smart_attendance_plan
Where
    attendance_date >=
    (
        Select
            start_date
        From
            swp_config_weeks
        Where
            planning_flag = 2
    );

---
Select
    *
From
    swp_flags
Where
    flag_id = 'F004';


-----connect to tcmpl_app_config    
select * from app_mail_queue;

select * from app_task_scheduler_log order by run_date;