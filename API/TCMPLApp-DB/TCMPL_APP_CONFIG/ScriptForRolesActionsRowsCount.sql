select count(*) from sec_actions where module_id='M01';
--select * from sec_actions where module_id='M01';

select count(*) from sec_roles;

select count(*) from sec_module_roles where module_id='M01';

select count(*) from sec_module_role_actions where module_id='M01';

select count(*) from sec_module_user_roles where module_id='M01';

--select * from sec_module_user_roles where module_id='M01';

select count(*) from sec_module_users_roles_actions where module_id='M01';