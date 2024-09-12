using DocumentFormat.OpenXml.Drawing.Charts;
using DocumentFormat.OpenXml.Office2013.Drawing.ChartStyle;
using Microsoft.EntityFrameworkCore;
using Oracle.ManagedDataAccess.Client;
using Oracle.ManagedDataAccess.Types;
using RapReportingApi.RAPEntityModels;
using RapReportingApi.Repositories.Interfaces.Rpt;
using System;
using System.Data;

namespace RapReportingApi.Repositories.Rpt
{
    public class AfterPostAFCRepository : IAfterPostAFCRepository
    {
        public AfterPostAFCRepository(RAPDbContext paramDBContext)
        {
            _dbContext = paramDBContext;
        }

        private RAPDbContext _dbContext;

        //    public object AuditorOld(string yymm)
        //    { //yymm >= stryearstart
        //        OracleConnection conn = (OracleConnection)_dbContext.Database.GetDbConnection();
        //        if (conn == null || conn.State == ConnectionState.Closed)
        //            conn.Open();
        //        OracleCommand cmd = conn.CreateCommand() as OracleCommand;
        //        string ora_sql = string.Empty;
        //        DataTable dt = new DataTable();
        //        OracleParameter op_yymm = new OracleParameter("p_yymm", OracleDbType.Varchar2, yymm.ToString(), ParameterDirection.Input);
        //        cmd.Parameters.Add(op_yymm);
        //        ora_sql = @"
        //        SELECT
        //            AUDITOR.COMPANY, AUDITOR.TMAGRP, AUDITOR.EMPTYPE,
        //AUDITOR.LOCATION, AUDITOR.YYMM, AUDITOR.COSTCODE, AUDITOR.PROJNO,
        //AUDITOR.NAME Projname, AUDITOR.HOURS, AUDITOR.OTHOURS, AUDITOR.TOTHOURS,
        //            AUDITOR.parent
        //        FROM

        // AUDITOR where AUDITOR.YYMM >=:p_yymm

        // "; cmd.CommandText = ora_sql; cmd.CommandType = CommandType.Text; try {
        // dt.Load(cmd.ExecuteReader()); return dt; } catch (Exception ex) { throw ex; } finally {
        // dt.Dispose(); cmd.Dispose(); if ((conn != null)) { if (conn.State ==
        // ConnectionState.Open) conn.Close(); } _dbContext.Dispose(); } }

        public object Auditor(string yymm, string activeyear)
        {
            DataSet ds = new DataSet();
            OracleConnection conn = (OracleConnection)_dbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
                conn.Open();

            OracleParameter op_activeyear = new OracleParameter("p_activeyear", OracleDbType.Varchar2, activeyear, ParameterDirection.Input);
            OracleParameter op_yymm = new OracleParameter("p_yymm", OracleDbType.Varchar2, yymm.ToString(), ParameterDirection.Input);
            OracleParameter op_rec = new OracleParameter("p_rec", OracleDbType.RefCursor, ParameterDirection.Output);

            try
            {
                var sql = "BEGIN RAP_REPORTS_AFC.rpt_auditor(:p_activeyear, :p_yymm, :p_rec); END;";
                object[] ora_param = new object[] { op_activeyear, op_yymm, op_rec };
                var i_result = _dbContext.Database.ExecuteSqlRaw(sql, ora_param);
                OracleRefCursor cur_audit = (OracleRefCursor)op_rec.Value;
                OracleDataAdapter da = new OracleDataAdapter();
                da.TableMappings.Add("Table", "audit");

                da.Fill(ds, "audit", cur_audit);
                da.Dispose();
                return ds.Tables["audit"];
            }
            catch (Exception e)
            {
                return new { Result = "ERROR", Message = e.Message.ToString() };
            }
            finally
            {
                if ((conn != null))
                {
                    if (conn.State == ConnectionState.Open)
                        conn.Close();
                }
                op_activeyear.Dispose();
                op_yymm.Dispose();
                op_rec.Dispose();
            }
        }

        //public object Finance_TS(string yymm)
        //{
        //    OracleConnection conn = (OracleConnection)_dbContext.Database.GetDbConnection();
        //    if (conn == null || conn.State == ConnectionState.Closed)
        //        conn.Open();
        //    OracleCommand cmd = conn.CreateCommand() as OracleCommand;
        //    string ora_sql = string.Empty;
        //    OracleParameter op_yymm = new OracleParameter("p_yymm", OracleDbType.Varchar2, yymm.ToString(), ParameterDirection.Input);
        //    cmd.Parameters.Add(op_yymm);

        // DataTable dt = new DataTable(); ora_sql = @" SELECT FINANCE_TS.EMPTYPE, FINANCE_TS.EMPNO,
        // FINANCE_TS.NAME, FINANCE_TS.PROJNO, FINANCE_TS.PROJNO5 , FINANCE_TS.PROJNAME
        // ,FINANCE_TS.TCMNO, FINANCE_TS.TMAGROUP, FINANCE_TS.YYMM, FINANCE_TS.COSTCODE,
        // FINANCE_TS.HOURS, FINANCE_TS.OTHOURS, (FINANCE_TS.HOURS + FINANCE_TS.OTHOURS) TotalHOURS
        // ,FINANCE_TS.parent FROM FINANCE_TS where FINANCE_TS.YYMM >= :p_yymm order by
        // FINANCE_TS.YYMM desc ";

        //    cmd.CommandText = ora_sql;
        //    cmd.CommandType = CommandType.Text;
        //    try
        //    {
        //        dt.Load(cmd.ExecuteReader());
        //        return dt;
        //    }
        //    catch (Exception ex)
        //    {
        //        throw ex;
        //    }
        //    finally
        //    {
        //        dt.Dispose();
        //        cmd.Dispose();
        //        if ((conn != null))
        //        {
        //            if (conn.State == ConnectionState.Open)
        //                conn.Close();
        //        }
        //        _dbContext.Dispose();
        //    }
        //}

        public object Finance_TS(string yymm, string yearmode, string activeyear)
        {
            DataSet ds = new DataSet();
            OracleConnection conn = (OracleConnection)_dbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
                conn.Open();

            OracleParameter op_activeyear = new OracleParameter("p_activeyear", OracleDbType.Varchar2, activeyear, ParameterDirection.Input);
            OracleParameter op_yymm = new OracleParameter("p_yymm", OracleDbType.Varchar2, yymm.ToString(), ParameterDirection.Input);
            OracleParameter op_yearmode = new OracleParameter("p_yearmode", OracleDbType.Varchar2, yearmode.ToString(), ParameterDirection.Input);
            OracleParameter op_rec = new OracleParameter("p_rec", OracleDbType.RefCursor, ParameterDirection.Output);

            try
            {
                var sql = "BEGIN RAP_REPORTS_AFC.rpt_finance_ts(:p_activeyear, :p_yymm, :p_yearmode, :p_rec); END;";
                object[] ora_param = new object[] { op_activeyear, op_yymm, op_yearmode, op_rec };
                var i_result = _dbContext.Database.ExecuteSqlRaw(sql, ora_param);
                OracleRefCursor oraRefCursor = (OracleRefCursor)op_rec.Value;
                OracleDataAdapter da = new OracleDataAdapter();
                da.TableMappings.Add("Table", "finance");

                da.Fill(ds, "finance", oraRefCursor);
                da.Dispose();
                return ds.Tables["finance"];
            }
            catch (Exception e)
            {
                return new { Result = "ERROR", Message = e.Message.ToString() };
            }
            finally
            {
                if ((conn != null))
                {
                    if (conn.State == ConnectionState.Open)
                        conn.Close();
                }
                op_activeyear.Dispose();
                op_yymm.Dispose();
                op_yearmode.Dispose();
                op_rec.Dispose();
            }
        }

        public object JOB_PROJ_PH_LIST(string yymm)
        {
            OracleConnection conn = (OracleConnection)_dbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
                conn.Open();
            OracleCommand cmd = conn.CreateCommand() as OracleCommand;
            string ora_sql = string.Empty;
            System.Data.DataTable dt = new System.Data.DataTable();
            //ora_sql = @"
            //    SELECT
            //        projno,
            //        phase_select,
            //        tmagrp,
            //        name,
            //        tcmno,
            //        job_open_date,
            //        REVCDATE,
            //        cdate,
            //        client,
            //        clientname,
            //        t_location,
            //        industry

            // FROM job_proj_ph_list ";
            ora_sql = @"
                    Select
                        a.projno, a.phase_select, a.tmagrp, b.name, b.tcmno, c.job_open_date,
                        c.client, d.name clientname, 
                        Case 
                            When c.t_location is null then iot_jobs_general.get_country_name(c.country) 
                            Else c.t_location
                        End t_location, 
                        Case 
                            When e.name is null Then iot_jobs_general.get_plant_type_name(c.plant_type)
                            Else e.name
                        End industry,           
                        b.revcdate, b.cdate
                    From
                        job_proj_phase             a, projmast b, jobmaster c, clntmast d, job_industry e
                    Where
                        a.projno || a.phase_select = b.projno
                        And a.projno               = c.projno
                        And c.client               = d.client(+)
                        And c.industry             = e.industry(+) 
                    Order By a.projno, a.phase_select ";

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

        public object AuditorSubcontractorWiseList(string yymm, string yearmode, string activeyear)
        {
            DataSet ds = new DataSet();
            OracleConnection conn = (OracleConnection)_dbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
                conn.Open();

            OracleParameter op_activeyear = new OracleParameter("p_activeyear", OracleDbType.Varchar2, activeyear, ParameterDirection.Input);
            OracleParameter op_yymm = new OracleParameter("p_yymm", OracleDbType.Varchar2, yymm.ToString(), ParameterDirection.Input);
            OracleParameter op_yearmode = new OracleParameter("p_yearmode", OracleDbType.Varchar2, yearmode.ToString(), ParameterDirection.Input);
            OracleParameter op_rec = new OracleParameter("p_rec", OracleDbType.RefCursor, ParameterDirection.Output);

            try
            {
                var sql = "BEGIN RAP_REPORTS_AFC.rpt_proj_emp_typ_upd(:p_activeyear, :p_yymm, :p_yearmode, :p_rec); END;";
                object[] ora_param = new object[] { op_activeyear, op_yymm, op_yearmode, op_rec };
                var i_result = _dbContext.Database.ExecuteSqlRaw(sql, ora_param);
                OracleRefCursor cur_subcontractor = (OracleRefCursor)op_rec.Value;
                OracleDataAdapter da = new OracleDataAdapter();
                da.TableMappings.Add("Table", "subcontractor");

                da.Fill(ds, "subcontractor", cur_subcontractor);
                da.Dispose();
                return ds.Tables["subcontractor"];
            }
            catch (Exception e)
            {
                return new { Result = "ERROR", Message = e.Message.ToString() };
            }
            finally
            {
                if ((conn != null))
                {
                    if (conn.State == ConnectionState.Open)
                        conn.Close();
                }
                op_activeyear.Dispose();
                op_yymm.Dispose();
                op_yearmode.Dispose();
                op_rec.Dispose();
            }
        }

        public object CovidManhrsDistributionReport(string yymm, string costcode, string projno)
        {
            OracleConnection conn = (OracleConnection)_dbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
                conn.Open();
            OracleCommand cmd = conn.CreateCommand() as OracleCommand;
            string ora_sql = string.Empty;
            System.Data.DataTable dt = new System.Data.DataTable();
            /*
            OracleParameter op_yymm = new OracleParameter("p_yymm", OracleDbType.Varchar2, yymm, ParameterDirection.Input);
            OracleParameter op_costcode = new OracleParameter("p_costcode", OracleDbType.Varchar2, costcode, ParameterDirection.Input);
            OracleParameter op_projno = new OracleParameter("p_projno", OracleDbType.Varchar2, projno, ParameterDirection.Input);

            cmd.Parameters.Add(op_yymm);
            cmd.Parameters.Add(op_costcode);
            cmd.Parameters.Add(op_projno);
            */
            ora_sql = @"
                        select a.tmagrp, a.yymm, a.emptype, a.empno, a.name Emp_Name,
                               a.costcode, SUBSTR(a.projid, 0, 5) Proj_No5,
                               a.projid Proj_No, a.projdesc proj_desc,
                               a.otherhrs other_hrs, a.othersum other_sum,
                               a.covidhrs covid_hrs, (a.othersum + a.covidhrs )Total,a.distribution
                          from emp_covid_distribution_prj_det a

                            ";

            //ora_sql += "  where a.yymm = :p_yymm   and a.COSTCODE = :p_costcode  and a.projid = :p_projno";

            ora_sql += " order by a.yymm, a.empno, a.projid";

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
                cmd.Dispose();
                dt.Dispose();
                //op_costcode.Dispose();
                //op_projno.Dispose();
                //op_yymm.Dispose();
                _dbContext.Dispose();
            }
        }

        public object ManhourExportToSAPList(string yymm, string reporttype, string costcode, string projno, string emptype)
        {
            DataSet ds = new DataSet();
            OracleConnection conn = (OracleConnection)_dbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
                conn.Open();
            OracleParameter op_yymm = new OracleParameter("p_yymm", OracleDbType.Varchar2, yymm, ParameterDirection.Input);
            OracleParameter op_reporttype = new OracleParameter("p_reporttype", OracleDbType.Varchar2, reporttype, ParameterDirection.Input);
            OracleParameter op_costcode = new OracleParameter("p_costcode", OracleDbType.Varchar2, costcode, ParameterDirection.Input);
            OracleParameter op_projno = new OracleParameter("p_projno", OracleDbType.Varchar2, projno, ParameterDirection.Input);
            OracleParameter op_emptype = new OracleParameter("p_emptype", OracleDbType.Varchar2, emptype, ParameterDirection.Input);
            OracleParameter op_all = new OracleParameter("p_all", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_all_neg = new OracleParameter("p_all_neg", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_dept = new OracleParameter("p_dept", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_dept_neg = new OracleParameter("p_dept_neg", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_custom = new OracleParameter("p_custom", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_custom_ng = new OracleParameter("p_custom_ng", OracleDbType.RefCursor, ParameterDirection.Output);

            try
            {
                var sql = "BEGIN RAP_REPORTS_AFC.rpt_manhour_export_to_sap(:p_yymm, :p_reporttype, :p_costcode, :p_projno, :p_emptype, :p_all, :p_all_neg, :p_dept, :p_dept_neg, :p_custom, :p_custom_ng); END;";
                object[] ora_param = new object[] { op_yymm, op_reporttype, op_costcode, op_projno, op_emptype, op_all, op_all_neg, op_dept, op_dept_neg, op_custom, op_custom_ng };
                var i_result = _dbContext.Database.ExecuteSqlRaw(sql, ora_param);
                OracleRefCursor cur_all = (OracleRefCursor)op_all.Value;
                OracleRefCursor cur_all_neg = (OracleRefCursor)op_all_neg.Value;
                OracleRefCursor cur_dept = (OracleRefCursor)op_dept.Value;
                OracleRefCursor cur_dept_neg = (OracleRefCursor)op_dept_neg.Value;
                OracleRefCursor cur_custom = (OracleRefCursor)op_custom.Value;
                OracleRefCursor cur_custom_ng = (OracleRefCursor)op_custom_ng.Value;
                OracleDataAdapter da = new OracleDataAdapter();

                da.TableMappings.Add("TabAll", "all");
                da.TableMappings.Add("TabAllNeg", "all_neg");
                da.TableMappings.Add("TabDept", "dept");
                da.TableMappings.Add("TabDeptNeg", "dept_neg");

                if (!string.IsNullOrEmpty(costcode) || !string.IsNullOrEmpty(projno))
                {
                    da.TableMappings.Add("TabCustom", "custom");
                    da.TableMappings.Add("TabCustomNeg", "custom_ng");
                }

                da.Fill(ds, "TabAll", cur_all);
                da.Fill(ds, "TabAllNeg", cur_all_neg);
                da.Fill(ds, "TabDept", cur_dept);
                da.Fill(ds, "TabDeptNeg", cur_dept_neg);                               

                if (!string.IsNullOrEmpty(costcode) || !string.IsNullOrEmpty(projno))
                {                    
                    da.Fill(ds, "TabCustom", cur_custom);
                    da.Fill(ds, "TabCustomNeg", cur_custom_ng);
                }

                da.Dispose();
                return ds;
            }
            catch (Exception e)
            {
                return new { Result = "ERROR", Message = e.Message.ToString() };
            }
            finally
            {
                if ((conn != null))
                {
                    if (conn.State == ConnectionState.Open)
                        conn.Close();
                }
                op_yymm.Dispose();
                op_reporttype.Dispose();
                op_costcode.Dispose();
                op_projno.Dispose();
                op_emptype.Dispose();
            }
        }
    }
}