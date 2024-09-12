using Microsoft.EntityFrameworkCore;
using Oracle.ManagedDataAccess.Client;
using Oracle.ManagedDataAccess.Types;
using RapReportingApi.RAPEntityModels;
using RapReportingApi.Repositories.Interfaces;
using RapReportingApi.Repositories.Interfaces.Rpt.Cmplx.CC;
using System;
using System.Data;
using System.Linq;

namespace RapReportingApi.Repositories
{
    public class Cha1Sta6Tm02Repository : ICha1Sta6Tm02Repository
    {
        public Cha1Sta6Tm02Repository(RAPDbContext paramDBContext, ICHA01ERepository _CHA01ERepository)
        {
            _dbContext = paramDBContext;
            CHA01ERepository = _CHA01ERepository;
        }

        private RAPDbContext _dbContext;
        private ICHA01ERepository CHA01ERepository;

        //STA6 TM02 ACT01
        public object sta6tm02act01(string costCode, string yymm, string yearmode, string reportMode, string activeyear)
        {
            OracleConnection conn = (OracleConnection)_dbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
                conn.Open();

            OracleDataAdapter da = new OracleDataAdapter();
            DataSet ds = new DataSet();
            DataTable dtSTA6_Data = new DataTable("STA6_Data");
            DataTable dtSTA6_NotSub_Data = new DataTable("STA6_NotSub_Data");
            DataTable dSTA6_Odd_Data = new DataTable("STA6_Odd_Data");
            DataTable dtSTA6_1_Data = new DataTable("STA6_1_Data");
            DataTable dtSTA6_2_Data = new DataTable("STA6_2_Data");
            DataTable dtTM02_Heading = new DataTable("TM02_Heading");
            DataTable dtTM02_Data = new DataTable("TM02_Data");
            DataTable dtTM02_EmpType_Hrs_Data = new DataTable("TM02_EmpType_Hrs_Data");
            DataTable dtTM02_1_EmpType_Hrs_Data = new DataTable("TM02_1_EmpType_Hrs_Data");
            DataTable dtACT01_Heading = new DataTable("ACT01_Heading");
            DataTable dtACT01_Data = new DataTable("ACT01_Data");

            OracleParameter op_activeyear = new OracleParameter("p_activeyear", OracleDbType.Varchar2, activeyear.ToString(), ParameterDirection.Input);
            OracleParameter op_yymm = new OracleParameter("p_yymm", OracleDbType.Varchar2, yymm.ToString(), ParameterDirection.Input);
            OracleParameter op_yearmode = new OracleParameter("p_yearmode", OracleDbType.Varchar2, yearmode.ToString(), ParameterDirection.Input);
            OracleParameter op_costcode = new OracleParameter("p_costcode", OracleDbType.Varchar2, costCode.ToString(), ParameterDirection.Input);
            OracleParameter op_reportmode = new OracleParameter("p_reportmode", OracleDbType.Varchar2, reportMode, ParameterDirection.Input);
            OracleParameter op_sta6 = new OracleParameter("p_sta6", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_sta6_not_submitted = new OracleParameter("p_sta6_not_submitted", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_sta6_odd = new OracleParameter("p_sta6_odd", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_sta6_1 = new OracleParameter("p_sta6_1", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_sta6_2 = new OracleParameter("p_sta6_2", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_cols_tm02 = new OracleParameter("p_cols_tm02", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_tm02 = new OracleParameter("p_tm02", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_tm02_emptype_hrs = new OracleParameter("p_tm02_emptype_hrs", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_tm02_1_emptype_hrs = new OracleParameter("p_tm02_1_emptype_hrs", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_cols_act01 = new OracleParameter("p_cols_act01", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_act01 = new OracleParameter("p_act01", OracleDbType.RefCursor, ParameterDirection.Output);

            int i = 0;
            try
            {
                var ora_sql = "BEGIN rap_reports_b.rpt_cha1sta6tm02(:p_activeyear, " +
                                                                     " :p_yymm, " +
                                                                     " :p_yearmode, " +
                                                                     " :p_costcode, " +
                                                                     " :p_reportmode, " +
                                                                     " :p_sta6, " +
                                                                     " :p_sta6_not_submitted, " +
                                                                     " :p_sta6_odd, " +
                                                                     " :p_sta6_1, " +
                                                                     " :p_sta6_2," +
                                                                     " :p_cols_tm02, " +
                                                                     " :p_tm02, " +
                                                                     " :p_tm02_emptype_hrs, " +
                                                                     " :p_tm02_1_emptype_hrs, " +
                                                                     " :p_cols_act01, " +
                                                                     " :p_act01); END; ";

                object[] ora_param = new object[] { op_activeyear, op_yymm, op_yearmode, op_costcode, op_reportmode, op_sta6, op_sta6_not_submitted, op_sta6_odd, op_sta6_1, op_sta6_2,
                                                    op_cols_tm02, op_tm02, op_tm02_emptype_hrs, op_tm02_1_emptype_hrs, op_cols_act01, op_act01  };
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

                da.Fill(dtTM02_Heading, (OracleRefCursor)op_cols_tm02.Value);
                ds.Tables.Add(dtTM02_Heading);
                da.Fill(dtTM02_Data, (OracleRefCursor)op_tm02.Value);
                ds.Tables.Add(dtTM02_Data);
                da.Fill(dtTM02_EmpType_Hrs_Data, (OracleRefCursor)op_tm02_emptype_hrs.Value);
                ds.Tables.Add(dtTM02_EmpType_Hrs_Data);
                da.Fill(dtTM02_1_EmpType_Hrs_Data, (OracleRefCursor)op_tm02_1_emptype_hrs.Value);
                ds.Tables.Add(dtTM02_1_EmpType_Hrs_Data);

                da.Fill(dtACT01_Heading, (OracleRefCursor)op_cols_act01.Value);
                ds.Tables.Add(dtACT01_Heading);
                da.Fill(dtACT01_Data, (OracleRefCursor)op_act01.Value);
                ds.Tables.Add(dtACT01_Data);

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
                dtTM02_Heading.Dispose();
                dtTM02_Data.Dispose();
                dtTM02_EmpType_Hrs_Data.Dispose();
                dtTM02_1_EmpType_Hrs_Data.Dispose();
                dtACT01_Heading.Dispose();
                dtACT01_Data.Dispose();
                ds.Dispose();
                da.Dispose();
                op_activeyear.Dispose();
                op_yymm.Dispose();
                op_yearmode.Dispose();
                op_costcode.Dispose();
                op_reportmode.Dispose();
                op_sta6.Dispose();
                op_sta6_not_submitted.Dispose();
                op_sta6_odd.Dispose();
                op_sta6_1.Dispose();
                op_sta6_2.Dispose();
                op_cols_tm02.Dispose();
                op_tm02.Dispose();
                op_tm02_emptype_hrs.Dispose();
                op_tm02_1_emptype_hrs.Dispose();
                op_cols_act01.Dispose();
                op_act01.Dispose();
                if ((conn != null))
                {
                    if (conn.State == ConnectionState.Open)
                        conn.Close();
                }
            }
        }

        //CHA1
        public object CHA01EData(string costcode, string yymm, string yearmode, string reportMode, string activeyear)
        {
            DataSet ds = new DataSet();
            try
            {
                ds = (DataSet)CHA01ERepository.CHA01EData(costcode, yymm, yearmode, reportMode, activeyear);
                return ds;
            }
            catch (Exception)
            {
                throw;
            }
            finally
            {
                ds.Dispose();
            }
        }

        //GET COST CODES FOR CHA1STA6TM02 ALL DEPTS DOWNLOAD BY PROCO
        public object getRptCostcodes()
        {
            OracleConnection conn = (OracleConnection)_dbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
                conn.Open();

            OracleCommand cmd = null;
            DataSet ds = new DataSet();
            try
            {
                cmd = new OracleCommand("rap_reports_b.get_rpt_costcodes", conn);
                cmd.CommandType = System.Data.CommandType.StoredProcedure;
                cmd.Parameters.Clear();

                cmd.Parameters.Add("p_result", OracleDbType.RefCursor, ParameterDirection.Output);
                OracleDataAdapter da = new OracleDataAdapter(cmd);
                cmd.ExecuteNonQuery();
                da.Fill(ds, "CostcodeTable");
                da.Dispose();
                return ds.Tables["CostcodeTable"];
            }
            catch (Exception ex)
            {
                return new { Result = "ERROR", Message = ex.Message };
            }
            finally
            {
                if ((conn != null))
                {
                    if (conn.State == ConnectionState.Open)
                        conn.Close();
                }
                ds.Dispose();
                cmd.Parameters.Clear();
                cmd.Dispose();
                _dbContext.Dispose();
            }
        }

        public object insertRptProcess(string keyid, string userid, string yyyy, string yymm, string yearmode, string category, string reporttype, string simul, string reportid)
        {
            OracleConnection conn = (OracleConnection)_dbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
                conn.Open();

            OracleParameter op_keyid = new OracleParameter("p_keyid", OracleDbType.Varchar2, keyid.ToString(), ParameterDirection.Input);
            OracleParameter op_report = new OracleParameter("p_report", OracleDbType.Varchar2, reportid.ToString(), ParameterDirection.Input);
            OracleParameter op_user = new OracleParameter("p_user", OracleDbType.Varchar2, userid.ToString(), ParameterDirection.Input);
            OracleParameter op_yyyy = new OracleParameter("p_yyyy", OracleDbType.Varchar2, yyyy.ToString(), ParameterDirection.Input);
            OracleParameter op_yymm = new OracleParameter("p_yymm", OracleDbType.Varchar2, yymm.ToString(), ParameterDirection.Input);
            OracleParameter op_yearmode = new OracleParameter("p_yearmode", OracleDbType.Varchar2, yearmode.ToString(), ParameterDirection.Input);
            OracleParameter op_category = new OracleParameter("p_category", OracleDbType.Varchar2, category, ParameterDirection.Input);
            OracleParameter op_reporttype = new OracleParameter("p_reporttype", OracleDbType.Varchar2, reporttype, ParameterDirection.Input);
            OracleParameter op_simul = new OracleParameter("p_simul", OracleDbType.Varchar2, simul, ParameterDirection.Input);
            OracleParameter op_msg = new OracleParameter("p_msg", OracleDbType.Varchar2, 4000, "", ParameterDirection.Output);

            try
            {
                var sql = "BEGIN rap_reports_gen.update_rpt_process(:p_keyid, :p_report, :p_user, :p_yyyy, :p_yymm, :p_yearmode, :p_category, :p_reporttype, :p_simul, :p_msg); END;";
                object[] ora_param = new object[] { op_keyid, op_report, op_user, op_yyyy, op_yymm, op_yearmode, op_category, op_reporttype, op_simul, op_msg };
                var i_result = _dbContext.Database.ExecuteSqlRaw(sql, ora_param);
                return op_msg.Value;
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
                op_keyid.Dispose();
                op_report.Dispose();
                op_user.Dispose();
                op_yyyy.Dispose();
                op_yymm.Dispose();
                op_yearmode.Dispose();
                op_category.Dispose();
                op_reporttype.Dispose();
                op_simul.Dispose();
                op_msg.Dispose();
                _dbContext.Dispose();
            }
        }

        public object discardRptProcess(string keyid, string userid)
        {
            OracleConnection conn = (OracleConnection)_dbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
                conn.Open();

            OracleParameter op_keyid = new OracleParameter("p_keyid", OracleDbType.Varchar2, keyid.ToString(), ParameterDirection.Input);
            OracleParameter op_user = new OracleParameter("p_user", OracleDbType.Varchar2, userid.ToString(), ParameterDirection.Input);
            OracleParameter op_msg = new OracleParameter("p_msg", OracleDbType.Varchar2, 4000, "", ParameterDirection.Output);

            try
            {
                var sql = "BEGIN rap_reports_gen.delete_rpt_process(:p_keyid, :p_user, :p_msg); END;";
                object[] ora_param = new object[] { op_keyid, op_user, op_msg };
                var i_result = _dbContext.Database.ExecuteSqlRaw(sql, ora_param);
                return op_msg.Value;
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
                op_keyid.Dispose();
                op_user.Dispose();
                op_msg.Dispose();
                _dbContext.Dispose();
            }
        }

        public object reportProcessStatus(string reportid, string userid, string yyyy, string yymm, string yearmode, string category, string reporttype)
        {
            OracleConnection conn = (OracleConnection)_dbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
                conn.Open();

            OracleParameter op_reportid = new OracleParameter("p_reportid", OracleDbType.Varchar2, reportid.ToString(), ParameterDirection.Input);
            OracleParameter op_user = new OracleParameter("p_user", OracleDbType.Varchar2, userid.ToString(), ParameterDirection.Input);
            OracleParameter op_yyyy = new OracleParameter("p_yyyy", OracleDbType.Varchar2, yyyy.ToString(), ParameterDirection.Input);
            OracleParameter op_yearmode = new OracleParameter("p_yearmode", OracleDbType.Varchar2, yearmode.ToString(), ParameterDirection.Input);
            OracleParameter op_yymm = new OracleParameter("p_yymm", OracleDbType.Varchar2, yymm.ToString(), ParameterDirection.Input);
            OracleParameter op_category = new OracleParameter("p_category", OracleDbType.Varchar2, category ?? "-", ParameterDirection.Input);
            OracleParameter op_reporttype = new OracleParameter("p_reporttype", OracleDbType.Varchar2, reporttype, ParameterDirection.Input);
            OracleParameter op_msg = new OracleParameter("p_msg", OracleDbType.Varchar2, 4000, "", ParameterDirection.Output);

            try
            {
                var sql = "BEGIN rap_reports.get_report_status(:p_reportid, :p_user, :p_yyyy, :p_yearmode, :p_yymm, :p_category, :p_reporttype, :p_msg); END;";
                object[] ora_param = new object[] { op_reportid, op_user, op_yyyy, op_yearmode, op_yymm, op_category, op_reporttype, op_msg };
                var i_result = _dbContext.Database.ExecuteSqlRaw(sql, ora_param);
                return op_msg.Value;
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
                op_reportid.Dispose();
                op_user.Dispose();
                op_yyyy.Dispose();
                op_yymm.Dispose();
                op_yearmode.Dispose();
                op_category.Dispose();
                op_reporttype.Dispose();
                op_msg.Dispose();
                _dbContext.Dispose();
            }
        }

        public object reportProcessKeyid(string reportid, string userid, string yyyy, string yymm, string yearmode, string category, string reporttype)
        {
            OracleConnection conn = (OracleConnection)_dbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
                conn.Open();

            OracleParameter op_reportid = new OracleParameter("p_reportid", OracleDbType.Varchar2, reportid.ToString(), ParameterDirection.Input);
            OracleParameter op_user = new OracleParameter("p_user", OracleDbType.Varchar2, userid.ToString(), ParameterDirection.Input);
            OracleParameter op_yyyy = new OracleParameter("p_yyyy", OracleDbType.Varchar2, yyyy.ToString(), ParameterDirection.Input);
            OracleParameter op_yearmode = new OracleParameter("p_yearmode", OracleDbType.Varchar2, yearmode.ToString(), ParameterDirection.Input);
            OracleParameter op_yymm = new OracleParameter("p_yymm", OracleDbType.Varchar2, yymm.ToString(), ParameterDirection.Input);
            OracleParameter op_category = new OracleParameter("p_category", OracleDbType.Varchar2, category, ParameterDirection.Input);
            OracleParameter op_reporttype = new OracleParameter("p_reporttype", OracleDbType.Varchar2, reporttype, ParameterDirection.Input);
            OracleParameter op_keyid = new OracleParameter("p_keyid", OracleDbType.Varchar2, 20, "", ParameterDirection.Output);

            try
            {
                var sql = "BEGIN rap_reports.get_report_keyid(:p_reportid, :p_user, :p_yyyy, :p_yearmode, :p_yymm, :p_category, :p_reporttype, :p_keyid); END;";
                object[] ora_param = new object[] { op_reportid, op_user, op_yyyy, op_yearmode, op_yymm, op_category, op_reporttype, op_keyid };
                var i_result = _dbContext.Database.ExecuteSqlRaw(sql, ora_param);
                return op_keyid.Value;
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
                op_reportid.Dispose();
                op_user.Dispose();
                op_yyyy.Dispose();
                op_yymm.Dispose();
                op_yearmode.Dispose();
                op_category.Dispose();
                op_reporttype.Dispose();
                op_keyid.Dispose();
                _dbContext.Dispose();
            }
        }

        //GET MAIL DETAILS
        public object getRptMailDetails(string keyid, string status)
        {
            OracleConnection conn = (OracleConnection)_dbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
                conn.Open();

            DataTable dt = new DataTable();
            OracleParameter op_keyid = new OracleParameter("p_keyid", OracleDbType.Varchar2, keyid.ToString(), ParameterDirection.Input);
            OracleParameter op_status = new OracleParameter("p_status", OracleDbType.Varchar2, status.ToString(), ParameterDirection.Input);
            OracleParameter op_result = new OracleParameter("p_result", OracleDbType.RefCursor, ParameterDirection.Output);
            try
            {
                var sql = "BEGIN rap_reports_gen.get_mail_details(:p_keyid, :p_status, :p_result); END;";
                object[] ora_param = new object[] { op_keyid, op_status, op_result };
                var i_result = _dbContext.Database.ExecuteSqlRaw(sql, ora_param);
                OracleRefCursor cur_results = (OracleRefCursor)op_result.Value;
                OracleDataAdapter da = new OracleDataAdapter();
                da.Fill(dt, cur_results);
                da.Dispose();
                return dt;
            }
            catch (Exception ex)
            {
                return new { Result = "ERROR", Message = ex.Message };
            }
            finally
            {
                if ((conn != null))
                {
                    if (conn.State == ConnectionState.Open)
                        conn.Close();
                }
                op_keyid.Dispose();
                op_status.Dispose();
                op_result.Dispose();
                dt.Dispose();
                _dbContext.Dispose();
            }
        }

        public object getRptProcessList(string userid, string yyyy, string yymm, string yearmode, string reportid)
        {
            OracleConnection conn = (OracleConnection)_dbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
                conn.Open();

            DataSet ds = new DataSet();
            OracleParameter op_report = new OracleParameter("p_report", OracleDbType.Varchar2, reportid.ToString(), ParameterDirection.Input);
            OracleParameter op_yyyy = new OracleParameter("p_yyyy", OracleDbType.Varchar2, yyyy.ToString(), ParameterDirection.Input);
            OracleParameter op_yearmode = new OracleParameter("p_yearmode", OracleDbType.Varchar2, yearmode.ToString(), ParameterDirection.Input);
            OracleParameter op_yymm = new OracleParameter("p_yymm", OracleDbType.Varchar2, yymm.ToString(), ParameterDirection.Input);
            OracleParameter op_user = new OracleParameter("p_user", OracleDbType.Varchar2, userid.ToString(), ParameterDirection.Input);
            OracleParameter op_result = new OracleParameter("p_result", OracleDbType.RefCursor, ParameterDirection.Output);

            try
            {
                var sql = "BEGIN rap_reports_gen.get_rpt_process_list(:p_report, :p_yyyy, :p_yearmode, :p_yymm, :p_user, :p_result); END;";
                object[] ora_param = new object[] { op_report, op_yyyy, op_yearmode, op_yymm, op_user, op_result };
                var i_result = _dbContext.Database.ExecuteSqlRaw(sql, ora_param);
                OracleRefCursor cur_results = (OracleRefCursor)op_result.Value;
                OracleDataAdapter da = new OracleDataAdapter();
                da.TableMappings.Add("Table", "resultsTable");
                da.Fill(ds, "resultsTable", cur_results);
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
                op_report.Dispose();
                op_yyyy.Dispose();
                op_yearmode.Dispose();
                op_yymm.Dispose();
                op_user.Dispose();
                op_result.Dispose();
                ds.Dispose();
                _dbContext.Dispose();
            }
        }

        public object getList4WorkerProcess()
        {
            OracleConnection conn = (OracleConnection)_dbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
                conn.Open();

            DataTable dt = new DataTable();
            OracleParameter op_result = new OracleParameter("p_result", OracleDbType.RefCursor, ParameterDirection.Output);

            try
            {
                var sql = "BEGIN rap_reports.get_list_4_worker_process(:p_result); END;";
                object[] ora_param = new object[] { op_result };
                var i_result = _dbContext.Database.ExecuteSqlRaw(sql, ora_param);
                OracleRefCursor cur_results = (OracleRefCursor)op_result.Value;
                OracleDataAdapter da = new OracleDataAdapter();
                da.Fill(dt, cur_results);
                da.Dispose();
                return dt;
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
                op_result.Dispose();
                dt.Dispose();
                _dbContext.Dispose();
            }
        }

        public object addProcessQueue(string empno, string moduleid, string processid, string processdesc, string parameterFilter)
        {
            OracleConnection conn = (OracleConnection)_dbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
                conn.Open();

            var mail_to = "";

            OracleParameter op_empno = new OracleParameter("p_empno", OracleDbType.Varchar2, empno, ParameterDirection.Input);
            OracleParameter op_module_id = new OracleParameter("p_module_id", OracleDbType.Varchar2, moduleid, ParameterDirection.Input);
            OracleParameter op_process_id = new OracleParameter("p_process_id", OracleDbType.Varchar2, processid, ParameterDirection.Input);
            OracleParameter op_process_desc = new OracleParameter("p_process_desc", OracleDbType.Varchar2, processdesc, ParameterDirection.Input);
            OracleParameter op_parameter_json = new OracleParameter("p_parameter_json", OracleDbType.Varchar2, parameterFilter, ParameterDirection.Input);
            OracleParameter op_mail_to = new OracleParameter("p_mail_to", OracleDbType.Varchar2, mail_to.ToString(), ParameterDirection.Input);
            OracleParameter op_mail_cc = new OracleParameter("p_mail_cc", OracleDbType.Varchar2, null, ParameterDirection.Input);
            OracleParameter op_key_id = new OracleParameter("p_key_id", OracleDbType.Varchar2, 8, "", ParameterDirection.Output);
            OracleParameter op_message_type = new OracleParameter("p_message_type", OracleDbType.Varchar2, 2, "", ParameterDirection.Output);
            OracleParameter op_message_text = new OracleParameter("p_message_text", OracleDbType.Varchar2, 4000, "", ParameterDirection.Output);

            try
            {
                var sql = "BEGIN tcmpl_app_config.pkg_app_process_queue.sp_process_add(:p_empno, :p_module_id, :p_process_id, :p_process_desc, :p_parameter_json, :p_mail_to, :p_mail_cc, :p_key_id, :p_message_type, :p_message_text); END;";
                object[] ora_param = new object[] { op_empno, op_module_id, op_process_id, op_process_desc, op_parameter_json, op_mail_to, op_mail_cc, op_key_id, op_message_type, op_message_text };
                var i_result = _dbContext.Database.ExecuteSqlRaw(sql, ora_param);
                return op_message_type.Value + "-" + op_key_id.Value + "-" + op_message_text;
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

                op_empno.Dispose();
                op_module_id.Dispose();
                op_process_id.Dispose();
                op_process_desc.Dispose();
                op_parameter_json.Dispose();
                op_mail_to.Dispose();
                op_key_id.Dispose();
                op_message_type.Dispose();
                op_message_text.Dispose();
                _dbContext.Dispose();
            }
        }
    }
}