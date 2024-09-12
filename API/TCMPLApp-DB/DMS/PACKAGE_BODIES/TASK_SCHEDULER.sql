Create Or Replace Package Body dms.task_scheduler As
    Procedure sp_daily_update_emp_exclude_moc5 As
    Begin
        pkg_exclude_from_moc5.sp_batch_emp_insert;
    End sp_daily_update_emp_exclude_moc5;

End task_scheduler;
/