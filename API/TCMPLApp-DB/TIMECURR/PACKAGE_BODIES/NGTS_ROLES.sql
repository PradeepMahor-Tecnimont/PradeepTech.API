--------------------------------------------------------
--  DDL for Package Body NGTS_ROLES
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "TIMECURR"."NGTS_ROLES" as

  /*procedure ngts_getroles(p_resultlist out sys_refcursor) as
      v_stmt varchar2(1000) := null;
    begin
      v_stmt := 'select roleid, roledesc from ngts_role_mast ';
      v_stmt := v_stmt || ' order by roledesc ';
      open p_resultlist for v_stmt;  
  end ngts_getroles;*/
  procedure ngts_deptrole_summary(p_deptno in varchar2, p_resultlist out sys_refcursor) as
      v_stmt varchar2(1000) := null;
    begin
      --v_stmt := 'select deptno, empno, name, ngts_roles.ngts_gethodrole(deptno, empno) defrole, ';
      --v_stmt := v_stmt || ' listagg(roleid, '', '') within group (order by roleid) "Roles" ';
      --v_stmt := v_stmt || ' from (select a.deptno, a.empno, initcap(b.name) name, c.roleid ';
      --v_stmt := v_stmt || ' from ngts_user_dept_roles a, emplmast b, ngts_role_mast c ';
      --v_stmt := v_stmt || ' where a.roleid = c.roleid and a.empno = b.empno ';
      --v_stmt := v_stmt || ' and a.deptno = ''' || p_deptno || ''') group by deptno, empno, name ';
      --v_stmt := v_stmt || ' order by empno ';
      v_stmt := ' select deptno, empno, name, max(defRole) defRole, max(Roles) Roles from ';
      v_stmt := v_stmt || ' (select a.costcode deptno, a.hod empno, initcap(b.name) name, ''R4'' defRole, '''' Roles  ';
      v_stmt := v_stmt || ' from costmast a, emplmast b ';
      v_stmt := v_stmt || ' where a.hod = b.empno and costcode = ''' || p_deptno || '''  ';
      v_stmt := v_stmt || ' union  ';
      v_stmt := v_stmt || ' select deptno, empno, name, '''' defRole, listagg(roleid, '', '') within group (order by roleid) Roles  ';
      v_stmt := v_stmt || ' from (select a.deptno, a.empno, initcap(b.name) name, a.roleid   ';
      v_stmt := v_stmt || ' from ngts_user_dept_roles a, emplmast b  ';
      v_stmt := v_stmt || ' where a.empno = b.empno  ';
      v_stmt := v_stmt || ' and a.deptno = ''' || p_deptno || ''') group by deptno, empno, name)  ';
      v_stmt := v_stmt || ' group by deptno, empno, name  ';
      v_stmt := v_stmt || ' order by empno '; 
      open p_resultlist for v_stmt;
  end ngts_deptrole_summary;
  
  procedure ngts_deptrole_save(p_deptno in varchar2, p_empno in varchar2, p_roleid in varchar2, p_msg out varchar2) as
      vExists number := 0;
    begin
      select count(*) into vExists from ngts_user_dept_roles
        where deptno = p_deptno and empno = p_empno and roleid = p_roleid;
      if vExists = 0 then
        insert into ngts_user_dept_roles(deptno, empno, roleid)
          values(p_deptno, p_empno, p_roleid);
        p_msg := 'Done';
      else
        p_msg := 'Record already exists';
      end if;
    exception
      when others then     
        p_msg := 'Err - ' || sqlcode || ' - ' || sqlerrm;
  end ngts_deptrole_save;
  
  procedure ngts_deptrole_delete(p_deptno in varchar2, p_empno in varchar2, p_roleid in varchar2, p_msg out varchar2) as
      vExists number := 0;
    begin
      select count(*) into vExists from ngts_user_dept_roles
        where deptno = p_deptno and empno = p_empno and roleid = p_roleid;
      if vExists = 1 then
        delete from ngts_user_dept_roles
          where deptno = p_deptno and empno = p_empno and roleid = p_roleid;             
      end if;
      p_msg := 'Done';
    exception
      when others then     
        p_msg := 'Err - ' || sqlcode || ' - ' || sqlerrm;
  end ngts_deptrole_delete;
  
  procedure ngts_projrole_summary(p_projno in varchar2, p_resultlist out sys_refcursor) as
      v_stmt varchar2(1000) := null;
    begin
      --v_stmt := 'select projno, empno, name, ngts_roles.ngts_getpmrole(projno, empno) defrole, ';
      --v_stmt := v_stmt || ' listagg(roledesc, '', '') within group (order by roledesc) "Roles" ';
      --v_stmt := v_stmt || ' from (select a.projno, a.empno, initcap(b.name) name, c.roledesc ';
      --v_stmt := v_stmt || ' from ngts_user_project_roles a, emplmast b, ngts_role_mast c ';
      --v_stmt := v_stmt || ' where a.roleid = c.roleid and a.empno = b.empno ';
      --v_stmt := v_stmt || ' and a.projno = ''' || p_projno || ''') group by projno, empno, name ';
      --v_stmt := v_stmt || ' order by empno ';
      v_stmt := ' select substr(a.projno,1,5) projno, a.prjmngr empno, initcap(b.name) name, ''R3'' defRole, '''' Roles  ';
      v_stmt := v_stmt || ' from projmast a, emplmast b ';
      v_stmt := v_stmt || ' where a.prjmngr = b.empno and substr(a.projno,1,5) = ''' || p_projno || ''' ';
      v_stmt := v_stmt || ' group by substr(a.projno,1,5), a.prjmngr, b.name  ';
      v_stmt := v_stmt || ' union ';
      v_stmt := v_stmt || ' select projno, empno, name, '''' defRole, listagg(roleid, '', '') within group (order by roleid) "Roles"  ';
      v_stmt := v_stmt || ' from (select a.projno, a.empno, initcap(b.name) name, a.roleid ';
      v_stmt := v_stmt || ' from ngts_user_project_roles a, emplmast b ';
      v_stmt := v_stmt || ' where a.empno = b.empno and a.projno = ''' || p_projno || ''') group by projno, empno, name ';
      v_stmt := v_stmt || ' order by empno ';
      open p_resultlist for v_stmt;  
  end ngts_projrole_summary;
  
  procedure ngts_projrole_save(p_projno in varchar2, p_empno in varchar2, p_roleid in varchar2, p_msg out varchar2) as
      vExists number := 0;
    begin
      select count(*) into vExists from ngts_user_project_roles
        where projno = p_projno and empno = p_empno and roleid = p_roleid;
      if vExists = 0 then
        insert into ngts_user_project_roles(projno, empno, roleid)
          values(p_projno, p_empno, p_roleid);
        p_msg := 'Done';
      else
        p_msg := 'Record already exists';
      end if;
    exception
      when others then     
        p_msg := 'Err - ' || sqlcode || ' - ' || sqlerrm;
  end ngts_projrole_save;
  
  procedure ngts_projrole_delete(p_projno in varchar2, p_empno in varchar2, p_roleid in varchar2, p_msg out varchar2) as
      vExists number := 0;
    begin
      select count(*) into vExists from ngts_user_project_roles
        where projno = p_projno and empno = p_empno and roleid = p_roleid;
      if vExists = 1 then
        delete from ngts_user_project_roles
          where projno = p_projno and empno = p_empno and roleid = p_roleid;             
      end if;
      p_msg := 'Done';
    exception
      when others then     
        p_msg := 'Err - ' || sqlcode || ' - ' || sqlerrm;
  end ngts_projrole_delete;
  
  /*function ngts_gethodrole(p_deptno in varchar2, p_empno in varchar2) return varchar2 as
      v_defaultrole varchar2(10) := '';
    begin
      select 'R4' into v_defaultrole from costmast
        where costcode = p_deptno and hod = p_empno;
      return v_defaultrole;
  end ngts_gethodrole;
  
  function ngts_getpmrole(p_projno in varchar2, p_empno in varchar2) return varchar2 as
      v_defaultrole varchar2(10) := '';
    begin
      select 'R3' into v_defaultrole from projmast
        where substr(projno,1,5) = p_projno and prjmngr = p_empno;
      return v_defaultrole;
  end ngts_getpmrole;*/
  
   /* Added By Pradeep (Request By Deven Sir 20 March 2020) */  
    Function get_list Return typ_tab_role
        Pipelined
      --procedure get_list
    Is

        Cursor c1 Is
        Select
            roleid,
            roledesc
          From
            ngts_role_mast order by roleid;

        Cursor cur_child_roles (
            cp_role_id Varchar2
        ) Is
        Select
            roleid,
            roledesc,
            mngr,
            level,
            sys_connect_by_path(roleid, ',') level_path
          From
            ngts_role_mast
         Where
            Connect_By_Isleaf = 1
        Start With
            roleid = cp_role_id
        Connect By
            Prior roleid = mngr;

        Type typ_tab_child_roles Is
            Table Of cur_child_roles%rowtype;
        tab_child_roles  typ_tab_child_roles;
        rec_role         typ_rec_role;
    Begin
        For c2 In c1 Loop
            rec_role := Null;
            For rec_child_role In cur_child_roles(c2.roleid) Loop
                rec_role.role_id        := c2.roleid;
                rec_role.role_desc      := c2.roledesc;
                rec_role.child_roles    := rec_role.child_roles
                                        || ','
                                        ||  rec_child_role.level_path  ;
                rec_role.child_roles := replace(rec_role.child_roles ,','||c2.roleid,'');
                rec_role.child_roles := rec_role.child_roles ||','||c2.roleid;
            End Loop;
            rec_role.child_roles := replace(rec_role.child_roles ,',,',',');
            rec_role.child_roles := trim (both ',' from rec_role.child_roles );
            Pipe Row ( rec_role );
        End Loop;
    End get_list;
    
     PROCEDURE func_Return_Role_List (p_List   OUT   SYS_REFCURSOR) AS            
        v_stmt   VARCHAR2(1000) := NULL;
    BEGIN     
           v_stmt := ' select role_id as "id" , Role_desc as "name" , Child_roles as "childRoles" from table(ngts_roles.get_list) ';                    
           
        OPEN p_List FOR v_stmt;           
  END func_Return_Role_List;
    
   /*---------------------------------------------------------*/
  
end ngts_roles;

/
