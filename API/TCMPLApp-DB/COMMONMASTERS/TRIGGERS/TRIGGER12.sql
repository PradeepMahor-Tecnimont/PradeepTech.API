--------------------------------------------------------
--  DDL for Trigger TRIGGER12
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "COMMONMASTERS"."TRIGGER12" before
    insert or update of empno,submitted,modified_on on emp_nomination_status
    referencing
            old as old
            new as new
    for each row
begin
    :new.modified_on   := sysdate;
    if :new.submitted = 'OK' then
        update emp_lock_status
        set
            nom_lock_open =-1
        where
            empno =:new.empno;

        if sql%rowcount = 0 then
            insert into emp_lock_status (
                empno,
                prim_lock_open,
                fmly_lock_open,
                nom_lock_open,
                modified_on,
                login_lock_open,
                adhaar_lock,
                pp_lock
            ) values (
                :new.empno,
                -1,
                -1,
                -1,
                sysdate,
                -1,
                -1,
                -1
            );

        end if;

    end if;

end;

/
ALTER TRIGGER "COMMONMASTERS"."TRIGGER12" ENABLE;
