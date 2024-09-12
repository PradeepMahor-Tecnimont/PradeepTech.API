
Select
    ur.module_id,
    m.module_short_desc,
    ur.role_id,
    r.role_name,
    ur.empno,
    ur.person_id,
    ra.action_id
From
    sec_module_user_roles   ur,
    sec_modules             m,
    sec_roles               r,
    sec_module_role_actions ra
Where
    ur.module_id              = m.module_id
    And ur.role_id            = r.role_id
    And ur.module_role_key_id = ra.module_role_key_id(+);

Select
    Listagg(module_name, '; ') Within
        Group (Order By
            module_name) modules
From
    vu_module_user_role_actions;