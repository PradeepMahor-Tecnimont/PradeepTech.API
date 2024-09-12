using Microsoft.EntityFrameworkCore;
using Oracle.ManagedDataAccess.Client;
using Oracle.ManagedDataAccess.Types;
using RapReportingApi.RAPEntityModels;
using RapReportingApi.Repositories.Interfaces.Rpt.Cmplx.proco;
using System;
using System.Data;

namespace RapReportingApi.Repositories.Rpt.Cmplx.proco
{
    public class ResourceRepository : IResourceRepository
    {
        private RAPDbContext _dbContext;

        public ResourceRepository(RAPDbContext paramDBContext)
        {
            _dbContext = paramDBContext;
        }

        public object GetCostcodeList()
        {
            OracleConnection conn = (OracleConnection)_dbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
                conn.Open();
            DataSet ds = new DataSet();

            string sql = string.Empty;
            DataTable dt = new DataTable();
            OracleCommand cmd = conn.CreateCommand() as OracleCommand;

            sql = " select costcode, name, abbr from costmast " +
                  " where active = 1 and costcode like '02%' and tma_grp <> 'D' and activity > 0 " +
                  " order by tma_grp, costcode";

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

        public object GetResourceData(string timesheet_yyyy, string costcode, string yymm, string yearmode)
        {
            OracleConnection conn = (OracleConnection)_dbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
                conn.Open();

            DataSet ds = new DataSet();

            OracleParameter op_timesheet_yyyy = new OracleParameter("p_timesheet_yyyy", OracleDbType.Varchar2, timesheet_yyyy.ToString(), ParameterDirection.Input);
            OracleParameter op_costcode = new OracleParameter("p_costcode", OracleDbType.Varchar2, costcode.ToString(), ParameterDirection.Input);
            OracleParameter op_yymm = new OracleParameter("p_yymm", OracleDbType.Varchar2, yymm.ToString(), ParameterDirection.Input);
            OracleParameter op_yearmode = new OracleParameter("p_yearmode", OracleDbType.Varchar2, yearmode, ParameterDirection.Input);
            OracleParameter op_cols = new OracleParameter("p_cols", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_results = new OracleParameter("p_results", OracleDbType.RefCursor, ParameterDirection.Output);

            var sql = "BEGIN rap_reports.rpt_resourceavlsch(:p_timesheet_yyyy, :p_costcode, :p_yymm, :p_yearmode, :p_cols, :p_results); END;";
            object[] ora_param = new object[] { op_timesheet_yyyy, op_costcode, op_yymm, op_yearmode, op_cols, op_results };
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
                op_timesheet_yyyy.Dispose();
                op_costcode.Dispose();
                op_yymm.Dispose();
                op_yearmode.Dispose();
                op_cols.Dispose();
                op_results.Dispose();
            }
        }
    }
}