Set Sqlformat Insert;

Select
    *
From
    sec_modules
Where
    module_id = '&module_id';

Select
    *
From
    sec_actions_master
Where
    action_id In (
        Select
            action_id
        From
            sec_module_role_actions
        Where
            module_id = '&module_id'
    );
--Actions
--------
Select
    *
From
    sec_actions
Where
    action_id In (
        Select
            action_id
        From
            sec_module_role_actions
        Where
            module_id = '&module_id'
    )
    And module_id = '&module_id';

--Roles
------
Select
    *
From
    sec_roles
Where
    role_id In(
        Select
            role_id
        From
            sec_module_roles
        Where
            module_id = '&module_id'
    )
    And role_id <> 'R000';

--Module Roles
--
Select
    *
From
    sec_module_roles
Where
    module_id = '&module_id'
    And role_id <> 'R000';

--Module Roles Actions
----------------------
Select
    *
From
    sec_module_role_actions
Where
    module_id = '&module_id'
    And role_id <> 'R000';