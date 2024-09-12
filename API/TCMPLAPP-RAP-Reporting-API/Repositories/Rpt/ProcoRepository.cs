using Microsoft.EntityFrameworkCore;
using Oracle.ManagedDataAccess.Client;
using RapReportingApi.RAPEntityModels;
using RapReportingApi.Repositories.Interfaces;
using System;
using System.Data;

namespace RapReportingApi.Repositories
{
    public class ProcoRepository : IProcoRepository
    {
        public ProcoRepository(RAPDbContext paramDBContext)
        {
            _dbContext = paramDBContext;
        }

        private RAPDbContext _dbContext;

        //cc_post - PROCO
        public object cc_post()
        {
            OracleConnection conn = (OracleConnection)_dbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
                conn.Open();
            OracleCommand cmd = conn.CreateCommand() as OracleCommand;
            string ora_sql = string.Empty;
            DataTable dt = new DataTable();
            ora_sql = " Select * From ( Select assign, desc1, noofempl From cc_post ) " +
                        " Pivot " +
                        " ( " +
                        "     Sum(noofempl) " +
                        "     For desc1 in ('Employee Not Filled' Employee_Not_filled, 'None in CostCode filled' None_in_CostCode_filled, 'Not Posted' Not_Posted) " +
                        "  ) " +
                        " Order By assign ";
            cmd.CommandText = ora_sql;
            cmd.CommandType = CommandType.Text;
            try
            {
                dt.Load(cmd.ExecuteReader());
                return dt;
            }
            catch (Exception)
            {
                throw;
            }
            finally
            {
                dt.Dispose();
                cmd.Dispose();
                if ((conn != null))
                {
                    if (conn.State == ConnectionState.Open)
                        conn.Close();
                }
                _dbContext.Dispose();
            }
        }

        //check_posted - PROCO
        public object check_posted()
        {
            OracleConnection conn = (OracleConnection)_dbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
                conn.Open();
            OracleCommand cmd = conn.CreateCommand() as OracleCommand;
            string ora_sql = string.Empty;
            DataTable dt = new DataTable();
            ora_sql = " Select hod, costcode, name, noofemps " +
                        " From check_posted " +
                        " Order By costcode ";
            cmd.CommandText = ora_sql;
            cmd.CommandType = CommandType.Text;
            try
            {
                dt.Load(cmd.ExecuteReader());
                return dt;
            }
            catch (Exception)
            {
                throw;
            }
            finally
            {
                dt.Dispose();
                cmd.Dispose();
                if ((conn != null))
                {
                    if (conn.State == ConnectionState.Open)
                        conn.Close();
                }
                _dbContext.Dispose();
            }
        }

        //exptjobs - PROCO
        public object exptjobs()
        {
            OracleConnection conn = (OracleConnection)_dbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
                conn.Open();
            OracleCommand cmd = conn.CreateCommand() as OracleCommand;
            string ora_sql = string.Empty;
            DataTable dt = new DataTable();
            ora_sql = " Select projno, name, Case active When 0 Then Null Else active End active, " +
                        " Case activefuture When 0 Then Null Else activefuture End activefuture, newcostcode, tcmno, proj_type " +
                        " From exptjobs " +
                        " Where nvl(active,0) > 0 or nvl(activefuture,0) > 0 " +
                        " Order By projno ";

            cmd.CommandText = ora_sql;
            cmd.CommandType = CommandType.Text;
            try
            {
                dt.Load(cmd.ExecuteReader());
                return dt;
            }
            catch (Exception)
            {
                throw;
            }
            finally
            {
                dt.Dispose();
                cmd.Dispose();
                if ((conn != null))
                {
                    if (conn.State == ConnectionState.Open)
                        conn.Close();
                }
                _dbContext.Dispose();
            }
        }

        //kallo_daily - PROCO
        public object kallo_daily(string yymm)
        {
            OracleConnection conn = (OracleConnection)_dbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
                conn.Open();
            OracleCommand cmd = conn.CreateCommand() as OracleCommand;
            string ora_sql = string.Empty;
            DataTable dt = new DataTable();
            OracleParameter op_yymm = new OracleParameter("p_yymm", OracleDbType.Varchar2, yymm.ToString(), ParameterDirection.Input);
            cmd.Parameters.Add(op_yymm);
            ora_sql = " Select yymm, ts_date, empno, name, parent, assign, projno, wpcode, activity, hours, othours, ot, " +
                        " tothours, area, wk_day, wk_period, wk_week " +
                        " From tm_kallo " +
                        " Where yymm = :p_yymm " +
                        " Order By ts_date, empno ";

            cmd.CommandText = ora_sql;
            cmd.CommandType = CommandType.Text;
            try
            {
                dt.Load(cmd.ExecuteReader());
                return dt;
            }
            catch (Exception)
            {
                throw;
            }
            finally
            {
                dt.Dispose();
                cmd.Dispose();
                op_yymm.Dispose();
                if ((conn != null))
                {
                    if (conn.State == ConnectionState.Open)
                        conn.Close();
                }
                _dbContext.Dispose();
            }
        }

        //projections - PROCO
        public object projections(string yymm)
        {
            OracleConnection conn = (OracleConnection)_dbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
                conn.Open();
            OracleCommand cmd = conn.CreateCommand() as OracleCommand;
            string ora_sql = string.Empty;
            DataTable dt = new DataTable();
            OracleParameter op_yymm = new OracleParameter("p_yymm", OracleDbType.Varchar2, yymm.ToString(), ParameterDirection.Input);
            cmd.Parameters.Add(op_yymm);
            ora_sql = " Select currexpt, phase, costcode, ccdesc, projno, prjdesc, yymm, hours, tmagrp, tcmno, activefuture, proj_type " +
                        " From projections " +
                        " Where yymm >= :p_yymm " +
                        " Order By currexpt, projno ";

            cmd.CommandText = ora_sql;
            cmd.CommandType = CommandType.Text;
            try
            {
                dt.Load(cmd.ExecuteReader());
                return dt;
            }
            catch (Exception)
            {
                throw;
            }
            finally
            {
                dt.Dispose();
                cmd.Dispose();
                op_yymm.Dispose();
                if ((conn != null))
                {
                    if (conn.State == ConnectionState.Open)
                        conn.Close();
                }
                _dbContext.Dispose();
            }
        }

        public object PlanRep4(string yymm)
        {
            OracleConnection conn = (OracleConnection)_dbContext.Database.GetDbConnection();

            if (conn == null || conn.State == ConnectionState.Closed)
                conn.Open();

            OracleCommand cmd = conn.CreateCommand() as OracleCommand;
            string ora_sql = string.Empty;
            DataTable dt = new DataTable();
            OracleParameter op_yymm = new OracleParameter("p_yymm", OracleDbType.Varchar2, yymm.ToString(), ParameterDirection.Input);
            cmd.Parameters.Add(op_yymm);

            //ora_sql = @"
            //     SELECT
            //        PROJMAST.PROJNO,
            //        PRJCMAST.COSTCODE, PRJCMAST.YYMM, PRJCMAST.HOURS
            //    FROM
            //        PROJMAST PROJMAST,      PRJCMAST PRJCMAST
            //    WHERE
            //        PROJMAST.PROJNO = PRJCMAST.PROJNO
            //        AND PRJCMAST.yymm > :p_yymm
            //         order by  PRJCMAST.yymm ,  PRJCMAST.COSTCODE
            //            ";

            ora_sql = @"
                     Select
                    projmast.projno,
                    prjcmast.costcode,
                    prjcmast.yymm,
                    prjcmast.hours,
                    projmast.name    project_name,
                    projmast.newCOstcode tma_grp
                From
                    projmast projmast, prjcmast prjcmast
                Where
                    projmast.projno = prjcmast.projno
                    And prjcmast.yymm > :p_yymm
                Order By
                    prjcmast.yymm,
                    prjcmast.costcode
                        ";
            cmd.CommandText = ora_sql;
            cmd.CommandType = CommandType.Text;
            try
            {
                dt.Load(cmd.ExecuteReader());
                return dt;
            }
            catch (Exception)
            {
                throw;
            }
            finally
            {
                if ((conn != null))
                {
                    if (conn.State == ConnectionState.Open)
                        conn.Close();
                }
                op_yymm.Dispose();
            }
        }

        public object PlanRep5(string yymm)
        {
            OracleConnection conn = (OracleConnection)_dbContext.Database.GetDbConnection();

            if (conn == null || conn.State == ConnectionState.Closed)
                conn.Open();

            OracleCommand cmd = conn.CreateCommand() as OracleCommand;
            string ora_sql = string.Empty;
            DataTable dt = new DataTable();
            OracleParameter op_yymm = new OracleParameter("p_yymm", OracleDbType.Varchar2, yymm.ToString(), ParameterDirection.Input);
            cmd.Parameters.Add(op_yymm);

            ora_sql = @"
                     SELECT
                        EXPTJOBS.PROJNO, EXPTJOBS.NAME, EXPTJOBS.ACTIVE, EXPTJOBS.ACTIVEFUTURE,
                        EXPTPRJC.COSTCODE, EXPTPRJC.YYMM, EXPTPRJC.HOURS
                    FROM
                        EXPTJOBS EXPTJOBS,  EXPTPRJC EXPTPRJC
                    WHERE
                        EXPTJOBS.PROJNO = EXPTPRJC.PROJNO AND
                        (EXPTJOBS.ACTIVE = 1 OR
                        EXPTJOBS.ACTIVEFUTURE = 1)
                        AND EXPTPRJC.yymm > :p_yymm

                    order by  EXPTPRJC.yymm ,  EXPTPRJC.COSTCODE ";
            cmd.CommandText = ora_sql;
            cmd.CommandType = CommandType.Text;
            try
            {
                dt.Load(cmd.ExecuteReader());
                return dt;
            }
            catch (Exception)
            {
                throw;
            }
            finally
            {
                if ((conn != null))
                {
                    if (conn.State == ConnectionState.Open)
                        conn.Close();
                }
                op_yymm.Dispose();
            }
        }

        public object PROCO_TS_ACT(string yymm)
        {
            OracleConnection conn = (OracleConnection)_dbContext.Database.GetDbConnection();

            if (conn == null || conn.State == ConnectionState.Closed)
                conn.Open();

            OracleCommand cmd = conn.CreateCommand() as OracleCommand;
            string ora_sql = string.Empty;
            DataTable dt = new DataTable();
            OracleParameter op_yymm = new OracleParameter("p_yymm", OracleDbType.Varchar2, yymm.ToString(), ParameterDirection.Input);
            cmd.Parameters.Add(op_yymm);

            ora_sql = @"
            SELECT
                PROCO_TS_ACT.EMPTYPE, PROCO_TS_ACT.EMPNO, PROCO_TS_ACT.NAME empname, PROCO_TS_ACT.PROJNO, PROCO_TS_ACT.YYMM, PROCO_TS_ACT.COSTCODE,
                PROCO_TS_ACT.ACTIVITY, PROCO_TS_ACT.HOURS, PROCO_TS_ACT.OTHOURS, PROCO_TS_ACT.TOTHOURS
            FROM
                PROCO_TS_ACT PROCO_TS_ACT
              WHERE    PROCO_TS_ACT.yymm = :p_yymm
                        ";
            cmd.CommandText = ora_sql;
            cmd.CommandType = CommandType.Text;
            try
            {
                dt.Load(cmd.ExecuteReader());
                return dt;
            }
            catch (Exception)
            {
                throw;
            }
            finally
            {
                if ((conn != null))
                {
                    if (conn.State == ConnectionState.Open)
                        conn.Close();
                }
                op_yymm.Dispose();
            }
        }

        public object DATEWISE_TS(string ProjNo, string Yymm)
        {
            OracleConnection conn = (OracleConnection)_dbContext.Database.GetDbConnection();

            if (conn == null || conn.State == ConnectionState.Closed)
                conn.Open();

            OracleCommand cmd = conn.CreateCommand() as OracleCommand;
            string ora_sql = string.Empty;
            DataTable dt = new DataTable();
            OracleParameter op_ProjNo = new OracleParameter("p_ProjNo", OracleDbType.Varchar2, ProjNo.ToString(), ParameterDirection.Input);

            OracleParameter op_yymm = new OracleParameter("p_yymm", OracleDbType.Varchar2, Yymm.ToString(), ParameterDirection.Input);
            cmd.Parameters.Add(op_ProjNo);
            cmd.Parameters.Add(op_yymm);
            ora_sql = @"
            select YYMM ,EMPNO ,PARENT ,ASSIGN ,TS_DATE ,PROJNO ,
                WPCODE ,ACTIVITY ,HOURS ,OTHOURS
                from datewise_ts
                where SUBSTR(Projno,0,5) = SUBSTR(:p_ProjNo,0,5)
                and Yymm=:p_yymm
                        ";
            cmd.CommandText = ora_sql;
            cmd.CommandType = CommandType.Text;
            try
            {
                dt.Load(cmd.ExecuteReader());
                return dt;
            }
            catch (Exception)
            {
                throw;
            }
            finally
            {
                if ((conn != null))
                {
                    if (conn.State == ConnectionState.Open)
                        conn.Close();
                }
                op_yymm.Dispose();
            }
        }

        public object TS_ACT_COVID(string Yymm)
        {
            OracleConnection conn = (OracleConnection)_dbContext.Database.GetDbConnection();

            if (conn == null || conn.State == ConnectionState.Closed)
                conn.Open();

            OracleCommand cmd = conn.CreateCommand() as OracleCommand;
            string ora_sql = string.Empty;
            DataTable dt = new DataTable();

            OracleParameter op_yymm = new OracleParameter("p_yymm", OracleDbType.Varchar2, Yymm.ToString(), ParameterDirection.Input);
            cmd.Parameters.Add(op_yymm);
            ora_sql = @"
           SELECT
        Emptype ,Empno ,Name ,Yymm ,Costcode ,Projno ,Activity ,Actdesc ,
        Hours ,Othours  ,( Hours + Othours) Total_Hours
        FROM Ts_Act_Covid
        WHERE Yymm= :p_yymm
                        ";
            cmd.CommandText = ora_sql;
            cmd.CommandType = CommandType.Text;
            try
            {
                dt.Load(cmd.ExecuteReader());
                return dt;
            }
            catch (Exception)
            {
                throw;
            }
            finally
            {
                if ((conn != null))
                {
                    if (conn.State == ConnectionState.Open)
                        conn.Close();
                }
                op_yymm.Dispose();
            }
        }

        //Employees / Manhours who have not posted their Timesheets
        public object empl_mhrs_not_posted(string yymm)
        {
            OracleConnection conn = (OracleConnection)_dbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
                conn.Open();

            OracleDataAdapter da = new OracleDataAdapter();

            OracleCommand cmd_Employees = conn.CreateCommand() as OracleCommand;
            OracleCommand cmd_Manhours = conn.CreateCommand() as OracleCommand;

            string ora_sql_employees = string.Empty;
            string ora_sql_manhours = string.Empty;

            DataSet ds = new DataSet();
            DataTable dtEmployees = new DataTable("dtEmployees");
            DataTable dtManHours = new DataTable("dtManHours");

            OracleParameter op_yymm_employees = new OracleParameter("p_yymm", OracleDbType.Varchar2, yymm.ToString(), ParameterDirection.Input);
            OracleParameter op_yymm_manhours = new OracleParameter("p_yymm", OracleDbType.Varchar2, yymm.ToString(), ParameterDirection.Input);
            cmd_Employees.Parameters.Add(op_yymm_employees);
            cmd_Manhours.Parameters.Add(op_yymm_manhours);

            ora_sql_employees = @"SELECT DISTINCT
                                    p.empno,
                                    e.name,
                                    p.assign,
                                    c.name AssignDesc
                                FROM
                                    postingdata  p,
                                    emplmast     e,
                                    costmast     c
                                WHERE
                                        p.yymm = :p_yymm
                                    AND p.empno = e.empno
                                    AND p.assign = c.costcode
                                    AND NOT EXISTS (
                                        SELECT
                                            t.yymm,
                                            t.empno,
                                            t.projno,
                                            t.costcode,
                                            t.wpcode,
                                            t.activity,
                                            t.grp
                                        FROM
                                            timetran t
                                        WHERE
                                                t.yymm = p.yymm
                                            AND t.empno = p.empno
                                            AND t.projno = p.projno
                                            AND t.costcode = p.assign
                                            AND t.wpcode = p.wpcode
                                            AND t.activity = p.activity
                                            AND t.grp = p.grp
                                    )

                                UNION ALL

                                Select
                                    tomm.empno, e.name, tomm.assign, c.name AssignDesc
                                From
                                    ts_osc_mhrs_master tomm,
                                    emplmast           e,
                                    costmast           c
                                Where
                                    tomm.empno      = e.empno
                                    And tomm.assign = c.costcode
                                    And tomm.yymm   = :p_yymm
                                    And Not Exists (
                                        Select
                                            t.yymm,
                                            t.empno,
                                            t.projno,
                                            t.costcode,
                                            t.wpcode,
                                            t.activity,
                                            t.grp
                                        From
                                            timetran           t,
                                            ts_osc_mhrs_detail tomd
                                        Where
                                            t.yymm           = tomm.yymm
                                            And t.empno      = tomm.empno
                                            And t.projno     = tomd.projno
                                            And t.costcode   = tomm.assign
                                            And t.wpcode     = tomd.wpcode
                                            And t.activity   = tomd.activity
                                            And tomd.oscm_id = tomm.oscm_id
                                            And t.grp        = c.tma_grp
                                    )
                                
                                ORDER BY 3,1
                                ";
            cmd_Employees.CommandText = ora_sql_employees;
            cmd_Employees.CommandType = CommandType.Text;

            ora_sql_manhours = @"SELECT
                                    p.parent,
                                    p.assign,
                                    p.grp,
                                    p.company,
                                    p.projno,
                                    j.name projname,
                                    p.empno,
                                    e.name,
                                    p.wpcode,
                                    p.activity,
                                    p.nhrs,
                                    p.ohrs
                                FROM
                                    postingdata  p,
                                    emplmast     e,
                                    projmast     j
                                WHERE
                                        p.yymm = :p_yymm
                                    AND p.empno = e.empno
                                    AND p.projno = j.projno
                                    AND NOT EXISTS (
                                        SELECT
                                            t.yymm,
                                            t.empno,
                                            t.projno,
                                            t.costcode,
                                            t.wpcode,
                                            t.activity,
                                            t.grp
                                        FROM
                                            timetran t
                                        WHERE
                                                t.yymm = p.yymm
                                            AND t.empno = p.empno
                                            AND t.projno = p.projno
                                            AND t.costcode = p.assign
                                            AND t.wpcode = p.wpcode
                                            AND t.activity = p.activity
                                            AND t.grp = p.grp
                                    )

                                UNION ALL

                                Select
                                    tomm.parent,
                                    tomm.assign,
                                    c.tma_grp,
                                    'TICB',
                                    tomd.projno,
                                    p.name     projname,
                                    tomm.empno,
                                    e.name,
                                    tomd.wpcode,
                                    tomd.activity,
                                    tomd.hours nhrs,
                                    0          ohrs
                                From
                                    ts_osc_mhrs_master tomm,
                                    ts_osc_mhrs_detail tomd,
                                    emplmast           e,
                                    projmast           p,
                                    costmast           c
                                Where
                                    tomm.yymm        = :p_yymm
                                    And tomm.oscm_id = tomd.oscm_id
                                    And tomm.empno   = e.empno
                                    And tomd.projno  = p.projno
                                    And tomm.assign  = c.costcode
                                    And Not Exists (
                                        Select
                                            t.yymm,
                                            t.empno,
                                            t.projno,
                                            t.costcode,
                                            t.wpcode,
                                            t.activity,
                                            t.grp
                                        From
                                            timetran t
                                        Where
                                            t.yymm         = tomm.yymm
                                            And t.empno    = tomm.empno
                                            And t.projno   = tomd.projno
                                            And t.costcode = tomm.assign
                                            And t.wpcode   = tomd.wpcode
                                            And t.activity = tomd.activity
                                            And t.grp      = c.tma_grp
                                    )

                                ORDER BY
                                    7,
                                    2
                                ";
            cmd_Manhours.CommandText = ora_sql_manhours;
            cmd_Manhours.CommandType = CommandType.Text;

            try
            {
                dtEmployees.Load(cmd_Employees.ExecuteReader());
                ds.Tables.Add(dtEmployees);
                dtManHours.Load(cmd_Manhours.ExecuteReader());
                ds.Tables.Add(dtManHours);
                return ds;
            }
            catch (Exception)
            {
                throw;
            }
            finally
            {
                dtEmployees.Dispose();
                dtManHours.Dispose();
                ds.Dispose();
                cmd_Employees.Dispose();
                cmd_Manhours.Dispose();
                da.Dispose();
                op_yymm_employees.Dispose();
                op_yymm_manhours.Dispose();
                if ((conn != null))
                {
                    if (conn.State == ConnectionState.Open)
                        conn.Close();
                }
                _dbContext.Dispose();
            }
        }
    }
}