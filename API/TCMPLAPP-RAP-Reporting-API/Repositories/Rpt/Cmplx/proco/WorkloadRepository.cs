using Microsoft.EntityFrameworkCore;
using Oracle.ManagedDataAccess.Client;
using Oracle.ManagedDataAccess.Types;
using RapReportingApi.RAPEntityModels;
using RapReportingApi.Repositories.Interfaces.Rpt.Cmplx.proco;
using System;
using System.Data;

namespace RapReportingApi.Repositories.Rpt.Cmplx.proco
{
    public class WorkloadRepository : IWorkloadRepository
    {
        private RAPDbContext _dbContext;

        public WorkloadRepository(RAPDbContext paramDBContext)
        {
            _dbContext = paramDBContext;
        }

        public object GetCostcodeList(string sheetname)
        {
            OracleConnection conn = (OracleConnection)_dbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
                conn.Open();
            DataSet ds = new DataSet();

            string sql = string.Empty;
            DataTable dt = new DataTable();
            OracleCommand cmd = conn.CreateCommand() as OracleCommand;
            switch (sheetname.ToUpper())
            {
                case "ENGG":
                    sql = " select costcode, name, abbr, activity, case sum(nvl(changed_nemps,0)) " +
                          " when 0 then sum(nvl(noofemps,0)) else sum(nvl(changed_nemps, 0)) end as intNoEmps " +
                          " from costmast " +
                          " where tma_grp = 'E' and costcode like '02%' and activity > 0 and group_chart > 0 " +
                          " group by costcode, name, abbr, activity order by costcode";
                    break;

                case "PROJCONST":
                    sql = " select costcode, name, abbr, activity, case sum(nvl(changed_nemps,0)) " +
                          " when 0 then sum(nvl(noofemps,0)) else sum(nvl(changed_nemps, 0)) end as intNoEmps " +
                          " from costmast " +
                          " where costcode in ('0210','0212','0213','0214','0215','0217','0251','0252','0256','0279','0283','0297')  " +
                          " group by costcode, name, abbr, activity order by costcode";
                    break;

                case "PROCURE":
                    sql = " select costcode, name, abbr, activity, case sum(nvl(changed_nemps,0)) " +
                          " when 0 then sum(nvl(noofemps,0)) else sum(nvl(changed_nemps, 0)) end as intNoEmps " +
                          " from costmast " +
                          " where tma_grp in ('C','P') and (costcode like '026%' Or costcode = '0280') and activity > 0 and group_chart > 0  " +
                          " group by costcode, name, abbr, activity order by costcode";
                    break;

                case "CONSTRUCTION":
                    sql = " select costcode, name, abbr, activity, case sum(nvl(changed_nemps,0)) " +
                          " when 0 then sum(nvl(noofemps,0)) else sum(nvl(changed_nemps, 0)) end as intNoEmps " +
                          " from costmast " +
                          " where costcode in ('0231','0234','0235','0255','0259','0271','0272','0276','0278','0286','0298','0299')  " +
                          " group by costcode, name, abbr, activity order by costcode";
                    break;

                case "MUMBAI":
                    sql = " select costcode, name, abbr, activity, case sum(nvl(changed_nemps,0)) " +
                          " when 0 then sum(nvl(noofemps,0)) else sum(nvl(changed_nemps, 0)) end as intNoEmps " +
                          " from costmast " +
                          " where " +
                          " ( tma_grp = 'E' and costcode like '02%' and activity > 0 and group_chart > 0 ) Or" +
                          " ( costcode in ('0210','0212','0213','0214','0215','0217','0251','0252','0256','0279','0283','0297')  ) Or  " +
                          " ( tma_grp in ('C','P') and (costcode like '026%' Or costcode = '0280') and activity > 0 and group_chart > 0 ) Or " +
                          " ( costcode in ('0231','0234','0235','0255','0259','0271','0272','0276','0278','0286','0298','0299') ) " +
                          " group by costcode, name, abbr, activity order by costcode";
                    break;

                case "DELHI":
                    sql = " select costcode, name, abbr, activity, case sum(nvl(changed_nemps,0)) " +
                          " when 0 then sum(nvl(noofemps,0)) else sum(nvl(changed_nemps, 0)) end as intNoEmps " +
                          " from costmast " +
                          " where " +
                          " ( tma_grp = 'E' and costcode like '0D%' and activity > 0 and group_chart > 0 ) Or" +
                          " ( costcode in ('0D10','0D12','0D13','0D14','0D15','0D17','0D51','0D52','0D56','0D79','0D83','0D97')  ) Or  " +
                          " ( tma_grp in ('C','P') and (costcode like '0D6%' Or costcode = '0D80') and activity > 0 and group_chart > 0 ) Or " +
                          " ( costcode in ('0D31','0D34','0D35','0D55','0D59','0D71','0D72','0D76','0D78','0D86','0D98','0D99') ) " +
                          " group by costcode, name, abbr, activity order by costcode";
                    break;

                default:
                    sql = string.Empty;
                    break;
            }
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

        public object GetExptProjList()
        {
            OracleConnection conn = (OracleConnection)_dbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
                conn.Open();
            DataSet ds = new DataSet();

            string sql = string.Empty;
            DataTable dt = new DataTable();
            OracleCommand cmd = conn.CreateCommand() as OracleCommand;

            sql = " select projno, name, active, activefuture, proj_type " +
                  " from exptjobs where active <= 0 and activefuture > 0 " +
                  " order by projno";
            cmd.CommandText = sql;
            cmd.CommandType = CommandType.Text;

            try
            {
                OracleDataAdapter da = new OracleDataAdapter(cmd);
                da.Fill(ds, "projTable");
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

        public object GetWorkloadData(string costcode, string yymm, string simul, string yearmode, string activeYear, string reportMode)
        {
            OracleConnection conn = (OracleConnection)_dbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
                conn.Open();

            DataSet ds = new DataSet();

            OracleParameter op_yyyy = new OracleParameter("p_yyyy", OracleDbType.Varchar2, activeYear.ToString(), ParameterDirection.Input);
            OracleParameter op_costcode = new OracleParameter("p_costcode", OracleDbType.Varchar2, costcode.ToString(), ParameterDirection.Input);
            OracleParameter op_yymm = new OracleParameter("p_yymm", OracleDbType.Varchar2, yymm.ToString(), ParameterDirection.Input);
            OracleParameter op_simul = new OracleParameter("p_simul", OracleDbType.Varchar2, simul, ParameterDirection.Input);
            OracleParameter op_yearmode = new OracleParameter("p_yearmode", OracleDbType.Varchar2, yearmode, ParameterDirection.Input);
            OracleParameter op_reportMode = new OracleParameter("p_reportmode", OracleDbType.Varchar2, reportMode, ParameterDirection.Input);
            OracleParameter op_cols = new OracleParameter("p_cols", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_results = new OracleParameter("p_results", OracleDbType.RefCursor, ParameterDirection.Output);

            var sql = "BEGIN rap_workload_combine.rpt_workload_new(:p_yyyy, :p_costcode, :p_yymm, :p_simul, :p_yearmode, :p_reportmode, :p_cols, :p_results); END;";
            object[] ora_param = new object[] { op_yyyy, op_costcode, op_yymm, op_simul, op_yearmode, op_reportMode, op_cols, op_results };
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
            }
        }
    }
}