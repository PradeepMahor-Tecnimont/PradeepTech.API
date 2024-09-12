using Microsoft.EntityFrameworkCore;
using Oracle.ManagedDataAccess.Client;
using Oracle.ManagedDataAccess.Types;
using RapReportingApi.RAPEntityModels;
using RapReportingApi.Repositories.Interfaces;
using System;
using System.Data;

namespace RapReportingApi.Repositories
{
    public class BeforePostCCRepository : IBeforePostCCRepository
    {
        public BeforePostCCRepository(RAPDbContext paramDBContext)
        {
            _dbContext = paramDBContext;
        }

        private RAPDbContext _dbContext;

        //public object AuditorReport(string yymm)
        //{
        //    OracleConnection conn = (OracleConnection)_dbContext.Database.GetDbConnection();
        //    if (conn == null || conn.State == ConnectionState.Closed)
        //        conn.Open();
        //    OracleCommand cmd = conn.CreateCommand() as OracleCommand;
        //    string ora_sql = string.Empty;
        //    //DataSet dsAuditor = new DataSet();
        //    DataTable dtAuditor = new DataTable();
        //    //OracleParameter op_result = new OracleParameter("p_result", OracleDbType.Varchar2, 4000, ParameterDirection.Output);
        //    OracleParameter op_yymm = new OracleParameter("p_yymm", OracleDbType.Varchar2, yymm.ToString(), ParameterDirection.Input);
        //    //OracleParameter op_result = new OracleParameter("p_result", OracleDbType.RefCursor, ParameterDirection.Output);
        //    cmd.Parameters.Add(op_yymm);
        //    //cmd.Parameters.Add(op_result);
        //    //cmd.CommandText = "rap_reports.rpt_auditor";
        //    ora_sql = " Select company, tmagrp, emptype, location, yymm, costcode,PARENT, TCM_JOBS ,PROJNO5 as Project_No_5 , " +
        //                "   projno as Project_No_7 , name as Project_Name ,  hours, othours, tothours " +
        //                " from auditor " +
        //                " Where yymm >= :p_yymm ";
        //    cmd.CommandText = ora_sql;
        //    //cmd.CommandType = CommandType.StoredProcedure;
        //    cmd.CommandType = CommandType.Text;
        //    try
        //    {
        //        //OracleDataAdapter daAuditor = new OracleDataAdapter(cmd);
        //        //cmd.ExecuteNonQuery();
        //        //daAuditor.Fill(dsAuditor, "AuditorTable");
        //        //daAuditor.Dispose();
        //        //return dsAuditor.Tables["AuditorTable"];
        //        dtAuditor.Load(cmd.ExecuteReader());
        //        return dtAuditor;
        //    }
        //    catch (Exception ex)
        //    {
        //        throw ex;
        //    }
        //    finally
        //    {
        //        dtAuditor.Dispose();
        //        cmd.Dispose();
        //        if ((conn != null))
        //        {
        //            if (conn.State == ConnectionState.Open)
        //                conn.Close();
        //        }
        //        op_yymm.Dispose();
        //        _dbContext.Dispose();
        //    }

        //    //OracleParameter op_result = new OracleParameter("p_result", OracleDbType.RefCursor, ParameterDirection.Output);
        //    ////OracleParameter op_result = new OracleParameter("p_result", OracleDbType.Varchar2, 4000, ParameterDirection.Output);
        //    //OracleParameter op_yymm = new OracleParameter("p_yymm", OracleDbType.Varchar2, yymm.ToString(), ParameterDirection.Input);
        //    //using (var rapDbContext = new RAPDbContext())
        //    //{
        //    //    try
        //    //    {
        //    //        var ora_sql = "BEGIN rap_reports.rpt_auditor(:p_yymm, :p_result); END;";
        //    //        object[] ora_param = new object[] { op_yymm, op_result };
        //    //        var i_result = rapDbContext.Database.ExecuteSqlRaw(ora_sql, ora_param);
        //    //        return op_result.Value;
        //    //    }
        //    //    catch (Exception ex)
        //    //    {
        //    //        throw ex;
        //    //    }
        //    //    finally
        //    //    {
        //    //        _dbContext.Dispose();
        //    //        op_yymm.Dispose();
        //    //        op_result.Dispose();
        //    //    }
        //    //}
        //}

        //Monthly Jobwise Manhours - Table

        public object AuditorReport(string yymm, string yearmode, string activeyear)
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
                var sql = "BEGIN RAP_REPORTS_AFC.rpt_auditor(:p_activeyear, :p_yymm, :p_yearmode, :p_rec); END;";
                object[] ora_param = new object[] { op_activeyear, op_yymm, op_yearmode, op_rec };
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
                op_yearmode.Dispose();
                op_rec.Dispose();
            }
        }

        public object MJMReport(string yymm, string costcode)
        {
            OracleConnection conn = (OracleConnection)_dbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
                conn.Open();
            OracleCommand cmd = conn.CreateCommand() as OracleCommand;
            string ora_sql = string.Empty;
            DataTable dtMJM = new DataTable();
            OracleParameter op_yymm = new OracleParameter("p_yymm", OracleDbType.Varchar2, yymm.ToString(), ParameterDirection.Input);
            OracleParameter op_costcode = new OracleParameter("p_costcode", OracleDbType.Varchar2, costcode.ToString(), ParameterDirection.Input);
            cmd.Parameters.Add(op_yymm);
            cmd.Parameters.Add(op_costcode);
            ora_sql = " Select b.yymm, b.assign, c.name assignname,  b.projno,  a.name projname, nvl(b.nhrs,0) + nvl(b.ohrs,0) tothrs " +
                        " From projmast a, jobwise b, costmast c " +
                        " where a.projno = b.projno and  b.assign = c.costcode " +
                        " and b.yymm = :p_yymm and b.assign = :p_costcode " +
                        " order by b.yymm asc, b.projno asc ";
            cmd.CommandText = ora_sql;
            cmd.CommandType = CommandType.Text;
            try
            {
                dtMJM.Load(cmd.ExecuteReader());
                return dtMJM;
            }
            catch (Exception)
            {
                throw;
            }
            finally
            {
                dtMJM.Dispose();
                cmd.Dispose();
                if ((conn != null))
                {
                    if (conn.State == ConnectionState.Open)
                        conn.Close();
                }
                op_costcode.Dispose();
                op_yymm.Dispose();
                _dbContext.Dispose();
            }
        }

        //Monthly Jobwise Activity Manhours - Table
        public object MJAMReport(string yymm, string costcode)
        {
            OracleConnection conn = (OracleConnection)_dbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
                conn.Open();
            OracleCommand cmd = conn.CreateCommand() as OracleCommand;
            string ora_sql = string.Empty;
            DataTable dtMJAM = new DataTable();
            OracleParameter op_yymm = new OracleParameter("p_yymm", OracleDbType.Varchar2, yymm.ToString(), ParameterDirection.Input);
            OracleParameter op_costcode = new OracleParameter("p_costcode", OracleDbType.Varchar2, costcode.ToString(), ParameterDirection.Input);
            cmd.Parameters.Add(op_yymm);
            cmd.Parameters.Add(op_costcode);
            ora_sql = " select a.yymm, a.assign, a.projno, b.name projname, a.activity, c.name actname, nvl(a.nhrs,0) + nvl(a.ohrs,0) tothrs " +
                        " from jobwise a, projmast b, act_mast c  " +
                        " where (a.activity = c.activity and a.assign = c.costcode) and a.projno = b.projno " +
                        " and a.yymm = :p_yymm and a.assign = :p_costcode " +
                        " order by a.yymm asc, a.projno asc, a.activity asc ";
            cmd.CommandText = ora_sql;
            cmd.CommandType = CommandType.Text;
            try
            {
                dtMJAM.Load(cmd.ExecuteReader());
                return dtMJAM;
            }
            catch (Exception)
            {
                throw;
            }
            finally
            {
                dtMJAM.Dispose();
                cmd.Dispose();
                if ((conn != null))
                {
                    if (conn.State == ConnectionState.Open)
                        conn.Close();
                }
                op_yymm.Dispose();
                op_costcode.Dispose();
                _dbContext.Dispose();
            }
        }

        //Manhours of costcentre - STA6
        public object DUPLSTA6ReportOld(string yymm, string costcode)
        {
            OracleConnection conn = (OracleConnection)_dbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
                conn.Open();
            OracleCommand cmd = conn.CreateCommand() as OracleCommand;
            string ora_sql = string.Empty;
            DataTable dtDUPLSTA6 = new DataTable();
            OracleParameter op_yymm = new OracleParameter("p_yymm", OracleDbType.Varchar2, yymm.ToString(), ParameterDirection.Input);
            OracleParameter op_costcode = new OracleParameter("p_costcode", OracleDbType.Varchar2, costcode.ToString(), ParameterDirection.Input);
            cmd.Parameters.Add(op_yymm);
            cmd.Parameters.Add(op_costcode);
            ora_sql = " Select a.yymm, a.assign, a.empno, initcap(b.name) empname, a.projno, a.activity, a.nhrs, a.ohrs " +
                        " from jobwise a, emplmast b " +
                        " where a.empno =  b.empno and a.yymm = :p_yymm and  a.assign = :p_costcode " +
                        " order by a.empno asc ";
            cmd.CommandText = ora_sql;
            cmd.CommandType = CommandType.Text;
            try
            {
                dtDUPLSTA6.Load(cmd.ExecuteReader());
                return dtDUPLSTA6;
            }
            catch (Exception)
            {
                throw;
            }
            finally
            {
                dtDUPLSTA6.Dispose();
                cmd.Dispose();
                if ((conn != null))
                {
                    if (conn.State == ConnectionState.Open)
                        conn.Close();
                }
                op_yymm.Dispose();
                op_costcode.Dispose();
                _dbContext.Dispose();
            }
        }

        //Manhours of costcentre - STA6
        public object DUPLSTA6Report(string yymm, string costcode)
        {
            OracleConnection conn = (OracleConnection)_dbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
                conn.Open();

            OracleCommand cmd = conn.CreateCommand() as OracleCommand;
            OracleDataAdapter da = new OracleDataAdapter();
            DataSet ds = new DataSet();
            DataTable dtSTA6_Data = new DataTable("STA6_Data");
            DataTable dtSTA6_NotSub_Data = new DataTable("STA6_NotSub_Data");
            DataTable dSTA6_Odd_Data = new DataTable("STA6_Odd_Data");
            DataTable dtSTA6_1_Data = new DataTable("STA6_1_Data");
            DataTable dtSTA6_2_Data = new DataTable("STA6_2_Data");
            DataTable dtSTA6_Costcode = new DataTable("STA6_CostCode");

            OracleParameter op_yymm = new OracleParameter("p_yymm", OracleDbType.Varchar2, yymm.ToString(), ParameterDirection.Input);
            OracleParameter op_costcode = new OracleParameter("p_costcode", OracleDbType.Varchar2, costcode.ToString(), ParameterDirection.Input);
            OracleParameter op_sta6 = new OracleParameter("p_sta6", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_sta6_not_submitted = new OracleParameter("p_sta6_not_submitted", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_sta6_odd = new OracleParameter("p_sta6_odd", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_sta6_1 = new OracleParameter("p_sta6_1", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_sta6_2 = new OracleParameter("p_sta6_2", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_costcodes = new OracleParameter("p_costcode", OracleDbType.Varchar2, costcode.ToString(), ParameterDirection.Input);

            int i = 0;
            try
            {
                cmd.CommandText = "SELECT c.name ccName, e.name emplName FROM costmast c, emplmast e WHERE c.hod = e.empno AND c.costcode = :p_costcode";
                cmd.Parameters.Add(op_costcodes);
                cmd.CommandType = CommandType.Text;
                dtSTA6_Costcode.Load(cmd.ExecuteReader());
                ds.Tables.Add(dtSTA6_Costcode);

                var ora_sql = "BEGIN rap_dupl_sta6.rpt_dupl_sta6(:p_yymm, " +
                                                               " :p_costcode, " +
                                                               " :p_sta6, " +
                                                               " :p_sta6_not_submitted, " +
                                                               " :p_sta6_odd, " +
                                                               " :p_sta6_1, " +
                                                               " :p_sta6_2); END; ";

                object[] ora_param = new object[] { op_yymm, op_costcode, op_sta6, op_sta6_not_submitted, op_sta6_odd, op_sta6_1, op_sta6_2 };
                var i_result = _dbContext.Database.ExecuteSqlRaw(ora_sql, ora_param);

                da.Fill(dtSTA6_Data, (OracleRefCursor)op_sta6.Value);
                foreach (DataRow dr in dtSTA6_Data.Rows)
                {
                    if (!String.IsNullOrEmpty(dr["calcEmpno"].ToString()))
                    {
                        i++;
                        dr["srno"] = i;
                    }
                }
                ds.Tables.Add(dtSTA6_Data);

                da.Fill(dtSTA6_NotSub_Data, (OracleRefCursor)op_sta6_not_submitted.Value);
                foreach (DataRow dr in dtSTA6_NotSub_Data.Rows)
                {
                    if (!String.IsNullOrEmpty(dr["empno"].ToString()))
                    {
                        i++;
                        dr["srno"] = i;
                    }
                }
                ds.Tables.Add(dtSTA6_NotSub_Data);

                da.Fill(dSTA6_Odd_Data, (OracleRefCursor)op_sta6_odd.Value);
                foreach (DataRow dr in dSTA6_Odd_Data.Rows)
                {
                    if (!String.IsNullOrEmpty(dr["empno"].ToString()))
                    {
                        i++;
                        dr["srno"] = i;
                    }
                }
                ds.Tables.Add(dSTA6_Odd_Data);

                i = 0;
                da.Fill(dtSTA6_1_Data, (OracleRefCursor)op_sta6_1.Value);
                foreach (DataRow dr in dtSTA6_1_Data.Rows)
                {
                    if (!String.IsNullOrEmpty(dr["calcEmpno"].ToString()))
                    {
                        i++;
                        dr["srno"] = i;
                    }
                }
                ds.Tables.Add(dtSTA6_1_Data);

                i = 0;
                da.Fill(dtSTA6_2_Data, (OracleRefCursor)op_sta6_2.Value);
                foreach (DataRow dr in dtSTA6_2_Data.Rows)
                {
                    if (!String.IsNullOrEmpty(dr["calcEmpno"].ToString()))
                    {
                        i++;
                        dr["srno"] = i;
                    }
                }
                ds.Tables.Add(dtSTA6_2_Data);

                return ds;
            }
            catch (Exception)
            {
                throw;
            }
            finally
            {
                dtSTA6_Data.Dispose();
                dtSTA6_NotSub_Data.Dispose();
                dSTA6_Odd_Data.Dispose();
                dtSTA6_1_Data.Dispose();
                dtSTA6_2_Data.Dispose();
                ds.Dispose();
                da.Dispose();
                op_yymm.Dispose();
                op_costcode.Dispose();
                op_sta6.Dispose();
                op_sta6_not_submitted.Dispose();
                op_sta6_odd.Dispose();
                op_sta6_1.Dispose();
                op_sta6_2.Dispose();
                op_costcodes.Dispose();
                if ((conn != null))
                {
                    if (conn.State == ConnectionState.Open)
                        conn.Close();
                }
            }
        }

        //Timesheet Status
        public object CCPOSTDETReport(string costcode)
        {
            OracleConnection conn = (OracleConnection)_dbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
                conn.Open();
            OracleCommand cmd = conn.CreateCommand() as OracleCommand;
            string ora_sql = string.Empty;
            DataTable dtCCPOSTDET = new DataTable();
            OracleParameter op_costcode = new OracleParameter("p_costcode", OracleDbType.Varchar2, costcode.ToString(), ParameterDirection.Input);
            OracleParameter op_costcode_o = new OracleParameter("p_costcode", OracleDbType.Varchar2, costcode.ToString(), ParameterDirection.Input);
            cmd.Parameters.Add(op_costcode);
            cmd.Parameters.Add(op_costcode_o);
            ora_sql = " Select emptype, assign, costname, hod, desc1, empno, initcap(name) empname, dol ";
            ora_sql = ora_sql + " from cc_post_det ";
            if (costcode != "0214")
            {
                ora_sql = ora_sql + " where assign = :p_costcode ";
            }

            ora_sql = ora_sql + " Union All ";
            ora_sql = ora_sql + " Select emptype, assign, costname, hod, desc1, empno, initcap(name) empname, dol ";
            ora_sql = ora_sql + " from cc_post_det_o ";
            ora_sql = ora_sql + " Where desc1 != 'POSTED' ";
            if (costcode != "0214")
            {
                ora_sql = ora_sql + " And assign = :p_costcode ";
            }

            ora_sql = ora_sql + " order by 2,6 ";
            cmd.CommandText = ora_sql;
            cmd.CommandType = CommandType.Text;
            try
            {
                dtCCPOSTDET.Load(cmd.ExecuteReader());
                return dtCCPOSTDET;
            }
            catch (Exception)
            {
                throw;
            }
            finally
            {
                dtCCPOSTDET.Dispose();
                cmd.Dispose();

                if ((conn != null))
                {
                    if (conn.State == ConnectionState.Open)
                        conn.Close();
                }
                op_costcode.Dispose();
                op_costcode_o.Dispose();
                _dbContext.Dispose();
            }
        }

        //Monthly Jobwise Employee  Manhours - Table
        public object MJEAMReport(string yymm, string costcode)
        {
            OracleConnection conn = (OracleConnection)_dbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
                conn.Open();
            OracleCommand cmd = conn.CreateCommand() as OracleCommand;
            string ora_sql = string.Empty;
            DataTable dtMJEAM = new DataTable();
            OracleParameter op_yymm = new OracleParameter("p_yymm", OracleDbType.Varchar2, yymm.ToString(), ParameterDirection.Input);
            OracleParameter op_costcode = new OracleParameter("p_costcode", OracleDbType.Varchar2, costcode.ToString(), ParameterDirection.Input);
            cmd.Parameters.Add(op_yymm);
            cmd.Parameters.Add(op_costcode);
            ora_sql = " SELECT	    PROJMAST.NAME projname,	    JOBWISE.YYMM, JOBWISE.ASSIGN, JOBWISE.PROJNO, JOBWISE.EMPNO ,	    EMPLMAST.NAME Employee	, JOBWISE.ACTIVITY,  JOBWISE.OHRS , JOBWISE.NHRS" +
                        " FROM	    PROJMAST PROJMAST,    JOBWISE JOBWISE,      EMPLMAST EMPLMAST     " +
                        "  WHERE	    PROJMAST.PROJNO = JOBWISE.PROJNO AND JOBWISE.EMPNO = EMPLMAST.EMPNO   " +
                        "  and JOBWISE.yymm = :p_yymm and JOBWISE.ASSIGN = :p_costcode " +
                        "  ORDER BY	    JOBWISE.YYMM ASC,	    JOBWISE.PROJNO ASC,	    JOBWISE.EMPNO ASC	 ";
            cmd.CommandText = ora_sql;
            cmd.CommandType = CommandType.Text;
            try
            {
                dtMJEAM.Load(cmd.ExecuteReader());
                return dtMJEAM;
            }
            catch (Exception)
            {
                throw;
            }
            finally
            {
                dtMJEAM.Dispose();
                cmd.Dispose();
                if ((conn != null))
                {
                    if (conn.State == ConnectionState.Open)
                        conn.Close();
                }
                op_yymm.Dispose();
                op_costcode.Dispose();
                _dbContext.Dispose();
            }
        }

        public object MHrsExceedReport(string yymm, string costcode)
        {
            OracleConnection conn = (OracleConnection)_dbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
                conn.Open();
            OracleCommand cmd = conn.CreateCommand() as OracleCommand;
            string ora_sql = string.Empty;
            DataTable dtCostCode = new DataTable();
            OracleParameter op_costcode = new OracleParameter("p_costcode", OracleDbType.Varchar2, costcode.ToString(), ParameterDirection.Input);
            OracleParameter op_yymm = new OracleParameter("p_yymm", OracleDbType.Varchar2, yymm.ToString(), ParameterDirection.Input);
            cmd.Parameters.Add(op_costcode);
            cmd.Parameters.Add(op_yymm);

            ora_sql = " Select yymm, empno, name, assign, projno, actual, othours, tot " +
                        " From hours_dailyot_final " +
                        " Where assign = :p_costcode " +
                        " And yymm = :p_yymm " +
                        " Order By empno ";
            cmd.CommandText = ora_sql;
            cmd.CommandType = CommandType.Text;
            try
            {
                dtCostCode.Load(cmd.ExecuteReader());
                return dtCostCode;
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
                dtCostCode.Dispose();
                op_yymm.Dispose();
                op_costcode.Dispose();
                _dbContext.Dispose();
            }
        }

        public object LeaveReport(string yymm, string costcode)
        {
            OracleConnection conn = (OracleConnection)_dbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
                conn.Open();
            OracleCommand cmd = conn.CreateCommand() as OracleCommand;
            string ora_sql = string.Empty;
            DataTable dtCostCode = new DataTable();
            OracleParameter op_yymm = new OracleParameter("p_yymm", OracleDbType.Varchar2, yymm.ToString(), ParameterDirection.Input);
            OracleParameter op_costcode = new OracleParameter("p_costcode", OracleDbType.Varchar2, costcode.ToString(), ParameterDirection.Input);
            cmd.Parameters.Add(op_yymm);
            cmd.Parameters.Add(op_costcode);

            ora_sql = " Select t.yymm, t.empno, e.name, t.wpcode, e.parent , t.assign, t.projno, t.d1, t.d2, t.d3, t.d4, t.d5, t.d6, t.d7, t.d8, t.d9, t.d10, " +
                        " t.d11, t.d12, t.d13, t.d14, t.d15, t.d16, t.d17, t.d18, t.d19, t.d20, t.d21, t.d22, t.d23, t.d24, t.d25, t.d26, " +
                        " t.d27, t.d28, t.d29, t.d30, t.d31 , t.total " +
                        " From time_daily t, emplmast e " +
                        " Where t.yymm = :p_yymm And t.assign = :p_costcode " +
                        " And Substr(t.projno,1,5) In ('11114', '22224','22225', '33334', 'E1114', 'E2224', 'E3334') " +
                        " And t.empno = e.empno " +
                        " Order By t.empno ";
            //" Order By t.yymm, t.assign, t.empno "; Original

            cmd.CommandText = ora_sql;
            cmd.CommandType = CommandType.Text;
            try
            {
                dtCostCode.Load(cmd.ExecuteReader());
                return dtCostCode;
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
                dtCostCode.Dispose();
                op_yymm.Dispose();
                op_costcode.Dispose();
                _dbContext.Dispose();
            }
        }

        public object OddTimesheetReport(string yymm, string costcode)
        {
            OracleConnection conn = (OracleConnection)_dbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
                conn.Open();
            OracleCommand cmd = conn.CreateCommand() as OracleCommand;
            string ora_sql = string.Empty;
            DataTable dtCostCode = new DataTable();
            OracleParameter op_yymm = new OracleParameter("p_yymm", OracleDbType.Varchar2, yymm.ToString(), ParameterDirection.Input);
            OracleParameter op_costcode = new OracleParameter("p_costcode", OracleDbType.Varchar2, costcode.ToString(), ParameterDirection.Input);
            cmd.Parameters.Add(op_yymm);
            cmd.Parameters.Add(op_costcode);

            ora_sql = " Select parent, yymm, empno, name, assign, projno, wpcode, activity, total " +
                        " From odd_timesheet " +
                        " Where yymm = :p_yymm And assign = :p_costcode " +
                        " Order By parent, empno ";
            cmd.CommandText = ora_sql;
            cmd.CommandType = CommandType.Text;
            try
            {
                dtCostCode.Load(cmd.ExecuteReader());
                return dtCostCode;
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
                dtCostCode.Dispose();
                op_yymm.Dispose();
                op_costcode.Dispose();
                _dbContext.Dispose();
            }
        }

        public object NotPostedTimesheetReport(string yymm, string costcode)
        {
            OracleConnection conn = (OracleConnection)_dbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
                conn.Open();
            OracleCommand cmd = conn.CreateCommand() as OracleCommand;
            string ora_sql = string.Empty;
            DataTable dtCostCode = new DataTable();
            cmd.Parameters.Add("p_costcode", OracleDbType.Varchar2).Value = costcode.Trim().ToString();
            cmd.Parameters.Add("p_yymm", OracleDbType.Varchar2).Value = yymm.Trim().ToString();

            ora_sql = " Select yymm, empno, name, parent, assign, " +
                        " Case Nvl(locked,0) When 1 Then 'Yes' Else 'No' End locked, " +
                        " Case Nvl(approved,0) When 1 Then 'Yes' Else 'No' End approved, " +
                        " Case Nvl(posted,0) When 1 Then 'Yes' Else 'No' End posted, " +
                        " tot_nhr, tot_ohr, company, remark " +
                        " From not_posted " +
                        " Where assign = :p_costcode " +
                        " And yymm = :p_yymm " +
                        " Order By parent, empno ";
            cmd.CommandText = ora_sql;
            cmd.CommandType = CommandType.Text;
            try
            {
                dtCostCode.Load(cmd.ExecuteReader());
                return dtCostCode;
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
                dtCostCode.Dispose();
                _dbContext.Dispose();
            }
        }

        public object MJM_All_RptDownload(string yymm, string costcode)
        {
            OracleConnection conn = (OracleConnection)_dbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
                conn.Open();
            OracleCommand cmd = conn.CreateCommand() as OracleCommand;
            string ora_sql = string.Empty;
            DataTable dtMJEAM = new DataTable();
            OracleParameter op_yymm = new OracleParameter("p_yymm", OracleDbType.Varchar2, yymm.ToString(), ParameterDirection.Input);
            OracleParameter op_costcode = new OracleParameter("p_costcode", OracleDbType.Varchar2, costcode.ToString(), ParameterDirection.Input);
            cmd.Parameters.Add(op_yymm);
            cmd.Parameters.Add(op_costcode);
            //ora_sql = $@"
            //            select b.yymm, b.assign ,c.name assign_name, b.assign ||' - '|| c.name assign_detail,
            //                  b.projno ,a.name  project_name , b.projno ||' - '|| a.name  project_detail,
            //                  b.EMPNO empno, e.name employee_name ,b.EMPNO ||' - '|| e.name employee_detail ,
            //                  b.ACTIVITY ,
            //                  (select distinct trim(act.name)
            //                           from ACT_MAST act
            //                           where act.activity = b.ACTIVITY
            //                              and act.COSTCODE= b.assign
            //                              ) ACTIVITY_name,
            //                  (select distinct trim(act.activity) ||' - '||  trim(act.Name)
            //                           from ACT_MAST act where act.activity = b.ACTIVITY
            //                           and act.COSTCODE= b.assign ) ACTIVITY_Details,
            //                     b.WPCODE
            //                  , nvl(b.nhrs, 0) nhrs , nvl(b.ohrs, 0) ohrs
            //                  , nvl(b.nhrs, 0) + nvl(b.ohrs, 0) totalhrs
            //              from projmast a, jobwise_wp b, costmast c , emplmast e
            //            where a.projno = b.projno
            //               and b.empno = e.empno
            //               and b.assign = c.costcode
            //               and b.yymm = :p_yymm
            //               and b.assign = :p_costcode
            //            order by b.yymm asc, b.projno asc
            //    ";
            ora_sql = $@"
                        SELECT distinct  * from (  
                             SELECT
                                b.yymm,
                                b.assign,
                                c.name                          assign_name,
                                b.assign || ' - ' || c.name     assign_detail,
                                b.projno                        projno,
                                a.name                          project_name,
                                b.projno || ' - ' || a.name     project_detail,
                                b.empno                         empno,
                                e.name                          employee_name,
                                b.empno || ' - ' || e.name      employee_detail,
                                b.activity,
                                ( SELECT DISTINCT TRIM(act.name) FROM act_mast act
                                    WHERE act.activity = b.activity
                                    AND act.costcode = b.assign )  activity_name,
                                ( SELECT DISTINCT TRIM(act.activity) || ' - ' || TRIM(act.name)
                                    FROM act_mast act 
                                    WHERE act.activity = b.activity 
                                    AND act.costcode = b.assign
                                )                               activity_details,
                                b.wpcode,
                                nvl(b.nhrs, 0)                  nhrs,
                                nvl(b.ohrs, 0)                  ohrs,
                                nvl(b.nhrs, 0) + nvl(b.ohrs, 0) totalhrs
                            FROM
                                projmast   a,
                                jobwise_wp b,
                                costmast   c,
                                emplmast   e
                            WHERE
                                    a.projno = b.projno
                                AND b.empno = e.empno
                                AND b.assign = c.costcode
                                AND b.yymm = :p_yymm
                                AND b.assign = :p_costcode
  
                            Union

                            SELECT
                                ts_osc_mhrs_master.yymm          yymm,
                                ts_osc_mhrs_master.assign        assign,
                                c.name                           assign_name,
                                ts_osc_mhrs_master.assign || ' - ' || c.name                        assign_detail,
                                ts_osc_mhrs_detail.projno        projno,
                                a.name                           project_name,
                                ts_osc_mhrs_detail.projno || ' - ' || a.name                        project_detail,
                                ts_osc_mhrs_master.empno         empno,
                                e.name                           employee_name,
                                ts_osc_mhrs_master.empno || ' - ' || e.name                        employee_detail,
                                ts_osc_mhrs_detail.activity      activity,
                                ( SELECT DISTINCT TRIM(act.name) FROM act_mast act 
                                    WHERE act.activity = ts_osc_mhrs_detail.activity
                                        AND act.costcode = ts_osc_mhrs_master.assign )             activity_name,
                                ( SELECT DISTINCT TRIM(act.activity) || ' - ' || TRIM(act.name) 
                                        FROM act_mast act 
                                        WHERE act.activity = ts_osc_mhrs_detail.activity
                                        AND act.costcode = ts_osc_mhrs_master.assign )             activity_details,
                                ts_osc_mhrs_detail.wpcode        wpcode,
                                nvl(ts_osc_mhrs_detail.hours, 0) nhrs,
                                ( 0 )                            ohrs,
                                nvl(ts_osc_mhrs_detail.hours, 0) totalhrs
                            FROM
                                ts_osc_mhrs_master ts_osc_mhrs_master,
                                projmast           a,
                                ts_osc_mhrs_detail ts_osc_mhrs_detail,
                                costmast           c,
                                emplmast           e
                            WHERE
                                 ts_osc_mhrs_detail.projno =     a.projno
                                AND ts_osc_mhrs_master.empno =   e.empno
                                AND ts_osc_mhrs_master.assign =  c.costcode
                                AND ts_osc_mhrs_master.oscm_id = ts_osc_mhrs_detail.oscm_id
                                AND ts_osc_mhrs_detail.projno =  a.projno
                                AND ts_osc_mhrs_master.yymm =   :p_yymm
                                AND ts_osc_mhrs_master.assign = :p_costcode
                             ) ORDER BY    yymm ASC,   projno ASC 
                ";
            cmd.CommandText = ora_sql;
            cmd.CommandType = CommandType.Text;
            try
            {
                dtMJEAM.Load(cmd.ExecuteReader());
                return dtMJEAM;
            }
            catch (Exception)
            {
                throw;
            }
            finally
            {
                dtMJEAM.Dispose();
                cmd.Dispose();
                if ((conn != null))
                {
                    if (conn.State == ConnectionState.Open)
                        conn.Close();
                }
                op_yymm.Dispose();
                op_costcode.Dispose();
                _dbContext.Dispose();
            }
        }
    }
}