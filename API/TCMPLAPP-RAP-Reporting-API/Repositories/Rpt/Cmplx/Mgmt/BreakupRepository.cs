using Microsoft.EntityFrameworkCore;
using Oracle.ManagedDataAccess.Client;
using Oracle.ManagedDataAccess.Types;
using RapReportingApi.RAPEntityModels;
using RapReportingApi.Repositories.Interfaces.Rpt.Cmplx.Mgmt;
using System;
using System.Data;

namespace RapReportingApi.Repositories.Rpt.Cmplx.Mgmt
{
    public class BreakupRepository : IBreakupRepository
    {
        private RAPDbContext _dbContext;

        public BreakupRepository(RAPDbContext paramDBContext)
        {
            _dbContext = paramDBContext;
        }

        public object GetTMAGroup()
        {
            OracleConnection conn = (OracleConnection)_dbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
                conn.Open();
            DataSet ds = new DataSet();

            string sql = string.Empty;
            DataTable dt = new DataTable();
            OracleCommand cmd = conn.CreateCommand() as OracleCommand;

            sql = " select * from job_tmagroup order by tmagroup, tmagroupdesc ";

            cmd.CommandText = sql;
            cmd.CommandType = CommandType.Text;

            try
            {
                OracleDataAdapter da = new OracleDataAdapter(cmd);
                da.Fill(ds, "tmagroupTable");
                da.Dispose();
                return ds;
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
            }
        }

        public object GetBreakupData(string yymm, string category, string yearmode)
        {
            DataSet ds = new DataSet();
            OracleConnection conn = (OracleConnection)_dbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
                conn.Open();

            OracleParameter op_yymm = new OracleParameter("p_yymm", OracleDbType.Varchar2, yymm.ToString(), ParameterDirection.Input);
            OracleParameter op_category = new OracleParameter("p_category", OracleDbType.Varchar2, category.ToString(), ParameterDirection.Input);
            OracleParameter op_yearmode = new OracleParameter("p_yearmode", OracleDbType.Varchar2, yearmode.ToString(), ParameterDirection.Input);
            OracleParameter op_colsMnth = new OracleParameter("p_cols_mnth", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_colsPeriod = new OracleParameter("p_cols_period", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_mnthresults = new OracleParameter("p_mnthresults", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_yearresults = new OracleParameter("p_yearresults", OracleDbType.RefCursor, ParameterDirection.Output);

            try
            {
                var sql = "BEGIN rap_reports_c.rpt_breakup(:p_yymm, :p_category, :p_yearmode, :p_cols_mnth, :p_cols_period, :p_mnthresults, :p_yearresults); END;";
                object[] ora_param = new object[] { op_yymm, op_category, op_yearmode, op_colsMnth, op_colsPeriod, op_mnthresults, op_yearresults };
                var i_result = _dbContext.Database.ExecuteSqlRaw(sql, ora_param);
                OracleRefCursor cur_colsMnth = (OracleRefCursor)op_colsMnth.Value;
                OracleRefCursor cur_colsPeriod = (OracleRefCursor)op_colsPeriod.Value;
                OracleRefCursor cur_mnthresults = (OracleRefCursor)op_mnthresults.Value;
                OracleRefCursor cur_yearresults = (OracleRefCursor)op_yearresults.Value;
                OracleDataAdapter da = new OracleDataAdapter();
                da.TableMappings.Add("Table", "colsMnthTable");
                da.TableMappings.Add("Table1", "colsPeriodTable");
                da.TableMappings.Add("Table2", "mnthTable");
                da.TableMappings.Add("Table3", "periodTable");
                da.Fill(ds, "colsMnthTable", cur_colsMnth);
                da.Fill(ds, "colsPeriodTable", cur_colsPeriod);
                da.Fill(ds, "mnthTable", cur_mnthresults);
                da.Fill(ds, "periodTable", cur_yearresults);
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
                op_category.Dispose();
                op_yearmode.Dispose();
                op_colsMnth.Dispose();
                op_colsPeriod.Dispose();
                op_mnthresults.Dispose();
                op_yearresults.Dispose();
            }
        }

        public object GetPlantEnggCostcodeList(string yymm)
        {
            OracleConnection conn = (OracleConnection)_dbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
                conn.Open();
            DataSet ds = new DataSet();

            string sql = string.Empty;
            DataTable dt = new DataTable();
            OracleCommand cmd = conn.CreateCommand() as OracleCommand;

            sql = " select distinct costcode, name from plantengg " +
                  " where yymm >= to_char(add_months(to_date( " + yymm + ", 'yyyymm'), -14), 'yyyymm') and yymm <=  " + yymm + " " +
                  " order by costcode";

            cmd.CommandText = sql;
            cmd.CommandType = CommandType.Text;

            try
            {
                OracleDataAdapter da = new OracleDataAdapter(cmd);
                da.Fill(ds, "costcodeTable");
                da.Dispose();
                return ds;
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
            }
        }

        public object GetPlantEnggData(string costcode, string yymm)
        {
            OracleConnection conn = (OracleConnection)_dbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
                conn.Open();

            DataSet ds = new DataSet();

            OracleParameter op_costcode = new OracleParameter("p_costcode", OracleDbType.Varchar2, costcode.ToString(), ParameterDirection.Input);
            OracleParameter op_yymm = new OracleParameter("p_yymm", OracleDbType.Varchar2, yymm.ToString(), ParameterDirection.Input);
            OracleParameter op_cols = new OracleParameter("p_cols", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_results = new OracleParameter("p_results", OracleDbType.RefCursor, ParameterDirection.Output);

            var sql = "BEGIN rap_reports_c.rpt_plantengg(:p_costcode, :p_yymm, :p_cols, :p_results); END;";
            object[] ora_param = new object[] { op_costcode, op_yymm, op_cols, op_results };
            var i_result = _dbContext.Database.ExecuteSqlRaw(sql, ora_param);
            OracleRefCursor cur_cols = (OracleRefCursor)op_cols.Value;
            OracleRefCursor cur_results = (OracleRefCursor)op_results.Value;

            try
            {
                OracleDataAdapter da = new OracleDataAdapter();
                da.TableMappings.Add("Table", "colsTable");
                da.TableMappings.Add("Table1", "dataTable");
                da.Fill(ds, "colsTable", cur_cols);
                da.Fill(ds, "dataTable", cur_results);
                da.Dispose();
                return ds;
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
                op_costcode.Dispose();
                op_yymm.Dispose();
                op_cols.Dispose();
                op_results.Dispose();
            }
        }
    }
}