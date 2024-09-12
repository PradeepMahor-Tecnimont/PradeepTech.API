using Microsoft.EntityFrameworkCore;
using Oracle.ManagedDataAccess.Client;
using Oracle.ManagedDataAccess.Types;
using RapReportingApi.RAPEntityModels;
using RapReportingApi.Repositories.Interfaces.Rpt.Cmplx.CC;
using System;
using System.Data;

namespace RapReportingApi.Repositories.Rpt.Cmplx.CC
{
    public class CHA01ERepository : ICHA01ERepository
    {
        private RAPDbContext _dbContext;

        public CHA01ERepository(RAPDbContext paramDBContext)
        {
            _dbContext = paramDBContext;
        }

        public object CHA01EData(string costcode, string yymm, string yearmode, string reportMode, string activeyear)
        {
            DataSet ds = new DataSet();
            OracleConnection conn = (OracleConnection)_dbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
                conn.Open();

            OracleParameter op_activeyear = new OracleParameter("p_activeyear", OracleDbType.Varchar2, activeyear.ToString(), ParameterDirection.Input);
            OracleParameter op_yymm = new OracleParameter("p_yymm", OracleDbType.Varchar2, yymm.ToString(), ParameterDirection.Input);
            OracleParameter op_costcode = new OracleParameter("p_costcode", OracleDbType.Varchar2, costcode.ToString(), ParameterDirection.Input);
            OracleParameter op_reportmode = new OracleParameter("p_reportmode", OracleDbType.Varchar2, reportMode.ToString(), ParameterDirection.Input);
            OracleParameter op_cols = new OracleParameter("p_cols", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_gen = new OracleParameter("p_gen", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_gen_other = new OracleParameter("p_gen_other", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_alldata = new OracleParameter("p_alldata", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_ot = new OracleParameter("p_ot", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_project = new OracleParameter("p_project", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_future = new OracleParameter("p_future", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_subcont = new OracleParameter("p_subcont", OracleDbType.RefCursor, ParameterDirection.Output);

            try
            {
                var sql = "BEGIN rap_cha1e_combine.rpt_cha1_expt(:p_activeyear, :p_yymm, :p_costcode, :p_reportmode, :p_cols, :p_gen, :p_gen_other, :p_alldata, :p_ot, :p_project, :p_future, :p_subcont); END;";
                object[] ora_param = new object[] { op_activeyear, op_yymm, op_costcode, op_reportmode, op_cols, op_gen, op_gen_other, op_alldata, op_ot, op_project, op_future, op_subcont };
                var i_result = _dbContext.Database.ExecuteSqlRaw(sql, ora_param);
                OracleRefCursor cur_cols = (OracleRefCursor)op_cols.Value;
                OracleRefCursor cur_gen = (OracleRefCursor)op_gen.Value;
                OracleRefCursor cur_gen_other = (OracleRefCursor)op_gen_other.Value;
                OracleRefCursor cur_alldata = (OracleRefCursor)op_alldata.Value;
                OracleRefCursor cur_ot = (OracleRefCursor)op_ot.Value;
                OracleRefCursor cur_project = (OracleRefCursor)op_project.Value;
                OracleRefCursor cur_future = (OracleRefCursor)op_future.Value;
                OracleRefCursor cur_subcontract = (OracleRefCursor)op_subcont.Value;
                OracleDataAdapter da = new OracleDataAdapter();
                da.TableMappings.Add("Table", "colsTable");
                da.TableMappings.Add("Table1", "genTable");
                da.TableMappings.Add("Table2", "genOtherTable");
                da.TableMappings.Add("Table3", "alldataTable");
                da.TableMappings.Add("Table4", "otTable");
                da.TableMappings.Add("Table5", "projectTable");
                da.TableMappings.Add("Table6", "futureTable");
                da.TableMappings.Add("Table7", "subcontractTable");
                da.Fill(ds, "colsTable", cur_cols);
                da.Fill(ds, "genTable", cur_gen);
                da.Fill(ds, "genOtherTable", cur_gen_other);
                da.Fill(ds, "alldataTable", cur_alldata);
                da.Fill(ds, "otTable", cur_ot);
                da.Fill(ds, "projectTable", cur_project);
                da.Fill(ds, "futureTable", cur_future);
                da.Fill(ds, "subcontractTable", cur_subcontract);
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
                op_activeyear.Dispose();
                op_yymm.Dispose();
                op_costcode.Dispose();
                op_cols.Dispose();
                op_gen.Dispose();
                op_alldata.Dispose();
                op_ot.Dispose();
                op_project.Dispose();
                op_future.Dispose();
                op_subcont.Dispose();
                op_reportmode.Dispose();
            }
        }

        public object CHA01ESimData(string costcode, string yymm, string yearmode, string simul, string reportMode, string activeYear)
        {
            DataSet ds = new DataSet();
            OracleConnection conn = (OracleConnection)_dbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
                conn.Open();

            OracleParameter op_yyyy = new OracleParameter("p_yyyy", OracleDbType.Varchar2, activeYear.ToString(), ParameterDirection.Input);
            OracleParameter op_yymm = new OracleParameter("p_yymm", OracleDbType.Varchar2, yymm.ToString(), ParameterDirection.Input);
            OracleParameter op_costcode = new OracleParameter("p_costcode", OracleDbType.Varchar2, costcode.ToString(), ParameterDirection.Input);
            OracleParameter op_simul = new OracleParameter("p_simul", OracleDbType.Varchar2, simul.ToString(), ParameterDirection.Input);
            OracleParameter op_reportmode = new OracleParameter("p_reportmode", OracleDbType.Varchar2, reportMode.ToString(), ParameterDirection.Input);            
            OracleParameter op_cols = new OracleParameter("p_cols", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_gen = new OracleParameter("p_gen", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_gen_other = new OracleParameter("p_gen_other", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_alldata = new OracleParameter("p_alldata", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_ot = new OracleParameter("p_ot", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_project = new OracleParameter("p_project", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_future = new OracleParameter("p_future", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_subcont = new OracleParameter("p_subcont", OracleDbType.RefCursor, ParameterDirection.Output);

            try
            {
                var sql = "BEGIN rap_cha1e_simul_combine.rpt_cha1_expt_simul(:p_yyyy, :p_yymm, :p_costcode, :p_simul, :p_reportmode, :p_cols, :p_gen, :p_gen_other, :p_alldata, :p_ot, :p_project, :p_future, :p_subcont); END;";
                object[] ora_param = new object[] { op_yyyy, op_yymm, op_costcode, op_simul, op_reportmode, op_cols, op_gen, op_gen_other, op_alldata, op_ot, op_project, op_future, op_subcont };
                var i_result = _dbContext.Database.ExecuteSqlRaw(sql, ora_param);
                OracleRefCursor cur_cols = (OracleRefCursor)op_cols.Value;
                OracleRefCursor cur_gen = (OracleRefCursor)op_gen.Value;
                OracleRefCursor cur_gen_other = (OracleRefCursor)op_gen_other.Value;
                OracleRefCursor cur_alldata = (OracleRefCursor)op_alldata.Value;
                OracleRefCursor cur_ot = (OracleRefCursor)op_ot.Value;
                OracleRefCursor cur_project = (OracleRefCursor)op_project.Value;
                OracleRefCursor cur_future = (OracleRefCursor)op_future.Value;
                OracleRefCursor cur_subcontract = (OracleRefCursor)op_subcont.Value;
                OracleDataAdapter da = new OracleDataAdapter();
                da.TableMappings.Add("Table", "colsTable");
                da.TableMappings.Add("Table1", "genTable");
                da.TableMappings.Add("Table2", "genOtherTable");
                da.TableMappings.Add("Table3", "alldataTable");
                da.TableMappings.Add("Table4", "otTable");
                da.TableMappings.Add("Table5", "projectTable");
                da.TableMappings.Add("Table6", "futureTable");
                da.TableMappings.Add("Table7", "subcontractTable");
                da.Fill(ds, "colsTable", cur_cols);
                da.Fill(ds, "genTable", cur_gen);
                da.Fill(ds, "genOtherTable", cur_gen_other);
                da.Fill(ds, "alldataTable", cur_alldata);
                da.Fill(ds, "otTable", cur_ot);
                da.Fill(ds, "projectTable", cur_project);
                da.Fill(ds, "futureTable", cur_future);
                da.Fill(ds, "subcontractTable", cur_subcontract);
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
                op_yyyy.Dispose();
                op_yymm.Dispose();
                op_costcode.Dispose();
                op_cols.Dispose();
                op_gen.Dispose();
                op_gen_other.Dispose();
                op_alldata.Dispose();
                op_ot.Dispose();
                op_project.Dispose();
                op_future.Dispose();
                op_subcont.Dispose();
                op_reportmode.Dispose();
            }
        }

        public object getCha1Costcodes()
        {
            OracleConnection conn = (OracleConnection)_dbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
                conn.Open();

            OracleCommand cmd = null;
            DataSet ds = new DataSet();
            try
            {
                cmd = new OracleCommand("rap_reports.cha1_costcodes", conn);
                cmd.CommandType = System.Data.CommandType.StoredProcedure;
                cmd.Parameters.Clear();

                cmd.Parameters.Add("p_results", OracleDbType.RefCursor, ParameterDirection.Output);
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
            }
        }

        public object getCha1Processlist(string yyyy, string userid)
        {
            OracleConnection conn = (OracleConnection)_dbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
                conn.Open();

            DataSet ds = new DataSet();
            OracleParameter op_yyyy = new OracleParameter("p_yyyy", OracleDbType.Varchar2, yyyy.ToString(), ParameterDirection.Input);
            OracleParameter op_user = new OracleParameter("p_user", OracleDbType.Varchar2, userid.ToString(), ParameterDirection.Input);
            OracleParameter op_results = new OracleParameter("p_results", OracleDbType.RefCursor, ParameterDirection.Output);

            try
            {
                var sql = "BEGIN rap_reports.get_cha1_process_list(:p_yyyy, :p_user, :p_results); END;";
                object[] ora_param = new object[] { op_yyyy, op_user, op_results };
                var i_result = _dbContext.Database.ExecuteSqlRaw(sql, ora_param);
                OracleRefCursor cur_results = (OracleRefCursor)op_results.Value;
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
                op_yyyy.Dispose();
                op_user.Dispose();
                op_results.Dispose();
            }
        }

        public object insertCha1Process(string keyid, string userid, string yyyy, string yymm)
        {
            OracleConnection conn = (OracleConnection)_dbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
                conn.Open();

            OracleParameter op_keyid = new OracleParameter("p_keyid", OracleDbType.Varchar2, keyid.ToString(), ParameterDirection.Input);
            OracleParameter op_user = new OracleParameter("p_user", OracleDbType.Varchar2, userid.ToString(), ParameterDirection.Input);
            OracleParameter op_yyyy = new OracleParameter("p_yyyy", OracleDbType.Varchar2, yyyy.ToString(), ParameterDirection.Input);
            OracleParameter op_yymm = new OracleParameter("p_yymm", OracleDbType.Varchar2, yymm.ToString(), ParameterDirection.Input);
            OracleParameter op_msg = new OracleParameter("p_msg", OracleDbType.Varchar2, 4000, "", ParameterDirection.Output);

            try
            {
                var sql = "BEGIN rap_reports.update_cha1_process(:p_keyid, :p_user, :p_yyyy, :p_yymm, :p_msg); END;";
                object[] ora_param = new object[] { op_keyid, op_user, op_yyyy, op_yymm, op_msg };
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
                op_yyyy.Dispose();
                op_yymm.Dispose();
                op_msg.Dispose();
            }
        }
    }
}