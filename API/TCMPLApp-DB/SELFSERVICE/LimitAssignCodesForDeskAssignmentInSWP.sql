alter table swp_exclude_assign add(is_site_code number(1));

update swp_exclude_assign set is_site_code = 1;
commit;

insert into swp_exclude_assign(assign,is_site_code) select 
costcode,0 from ss_costmast where noofemps > 0
and costcode not in (select assign from swp_exclude_assign where is_site_code=1)
;

commit;

delete from swp_exclude_assign where assign in (
'0237',
'0247',
'0257'
);