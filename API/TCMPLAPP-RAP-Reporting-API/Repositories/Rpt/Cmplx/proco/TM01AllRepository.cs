using Microsoft.EntityFrameworkCore;
using Oracle.ManagedDataAccess.Client;
using Oracle.ManagedDataAccess.Types;
using RapReportingApi.RAPEntityModels;
using RapReportingApi.Repositories.Interfaces.Rpt.Cmplx.proco;
using System;
using System.Data;

namespace RapReportingApi.Repositories.Rpt.Cmplx.proco
{
    public class TM01AllRepository : ITM01AllRepository
    {
        private RAPDbContext _dbContext;

        public TM01AllRepository(RAPDbContext paramDBContext)
        {
            _dbContext = paramDBContext;
        }

        public object GetProjectList(string yymm, string simul, string reportMode, string code)
        {
            OracleConnection conn = (OracleConnection)_dbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
                conn.Open();
            DataSet ds = new DataSet();

            //string sql = string.Empty;
            DataTable dt = new DataTable();
            OracleCommand cmd = conn.CreateCommand() as OracleCommand;
            OracleParameter op_yymm = new OracleParameter("p_yymm", OracleDbType.Varchar2, yymm.ToString(), ParameterDirection.Input);
            OracleParameter op_simul = new OracleParameter("p_simul", OracleDbType.Varchar2, simul, ParameterDirection.Input);
            OracleParameter op_reportmode = new OracleParameter("p_reportmode", OracleDbType.Varchar2, reportMode.ToString(), ParameterDirection.Input);
            OracleParameter op_code = new OracleParameter("p_code", OracleDbType.Varchar2, code, ParameterDirection.Input);
            OracleParameter op_results = new OracleParameter("p_results", OracleDbType.RefCursor, ParameterDirection.Output);
            //cmd.Parameters.Add(op_yymm);
            //cmd.Parameters.Add(op_simul);

            //string strWhere = string.Empty;
            //switch (simul.ToUpper())
            //{
            //    case "A":
            //        sql = " select projno,tcmno,name,active,to_char(sdate,'dd-Mon-yy') sdate,to_char(cdate,'dd-Mon-yy') cdate " +
            //              " from projmast where active > 0 and projno in  " +
            //              " (select distinct projno from prjcmast where yymm >= :p_yymm and active > 0)  " +
            //              " union " +
            //              " select projno,tcmno,name,active, ' ' sdate, ' ' cdate from exptjobs " +
            //              " where(active > 0 or activefuture > 0) and proj_type in ('A','B','C') " +
            //              " and projno in (select distinct projno from exptprjc where yymm >= :p_yymm ) ";
            //        break;
            //    case "B":
            //        sql = " select projno,tcmno,name,active,to_char(sdate,'dd-Mon-yy') sdate,to_char(cdate,'dd-Mon-yy') cdate " +
            //             " from projmast where active > 0 and projno in  " +
            //             " (select distinct projno from prjcmast where yymm >= :p_yymm and active > 0)  " +
            //             " union " +
            //             " select projno,tcmno,name,active, ' ' sdate, ' ' cdate from exptjobs " +
            //             " where(active > 0 or activefuture > 0) and proj_type in ('B','C') " +
            //             " and projno in (select distinct projno from exptprjc where yymm >= :p_yymm ) ";
            //        break;
            //    case "C":
            //        sql = " select projno,tcmno,name,active,to_char(sdate,'dd-Mon-yy') sdate,to_char(cdate,'dd-Mon-yy') cdate " +
            //             " from projmast where active > 0 and projno in  " +
            //             " (select distinct projno from prjcmast where yymm >= :p_yymm and active > 0)  " +
            //             " union " +
            //             " select projno,tcmno,name,active, ' ' sdate, ' ' cdate from exptjobs " +
            //             " where(active > 0 or activefuture > 0) and proj_type in ('C') " +
            //             " and projno in (select distinct projno from exptprjc where yymm >= :p_yymm ) ";
            //        break;
            //    default:
            //        sql = " select projno,tcmno,name,active,to_char(sdate,'dd-Mon-yy') sdate,to_char(cdate,'dd-Mon-yy') cdate " +
            //             " from projmast where active > 0 and projno in  " +
            //             " (select distinct projno from prjcmast where yymm >= :p_yymm and active > 0)  " +
            //             " union " +
            //             " select projno,tcmno,name,active, ' ' sdate, ' ' cdate from exptjobs " +
            //             " where(active > 0 or activefuture > 0) " +
            //             " and projno in (select distinct projno from exptprjc where yymm >= :p_yymm ) ";
            //        break;
            //}

            //cmd.CommandText = sql;
            //cmd.CommandType = CommandType.Text;

            var sql = "BEGIN rap_tm01all_combine.rpt_tm01All_ProjectList(:p_yymm, :p_simul,:p_reportmode, :p_code, :p_results); END;";
            object[] ora_param = new object[] { op_yymm, op_simul, op_reportmode, op_code, op_results };
            var i_result = _dbContext.Database.ExecuteSqlRaw(sql, ora_param);
            OracleRefCursor cur_results = (OracleRefCursor)op_results.Value;

            try
            {
                //OracleDataAdapter da = new OracleDataAdapter(cmd);
                //da.Fill(ds, "projListTable");
                //da.Dispose();
                //return ds;
                OracleDataAdapter da = new OracleDataAdapter();
                da.TableMappings.Add("Table", "projListTable");
                da.Fill(ds, "projListTable", cur_results);
                da.Dispose();
                return ds;
            }
            catch (Exception)
            {
                throw;
            }
            finally
            {
                op_yymm.Dispose();
                op_simul.Dispose();
                if ((conn != null))
                {
                    if (conn.State == ConnectionState.Open)
                        conn.Close();
                }
            }
        }

        public object GetProjectData(string projno)
        {
            OracleConnection conn = (OracleConnection)_dbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
                conn.Open();
            DataSet ds = new DataSet();

            //string sql = string.Empty;
            DataTable dt = new DataTable();
            OracleCommand cmd = conn.CreateCommand() as OracleCommand;
            OracleParameter op_projno = new OracleParameter("p_projno", OracleDbType.Varchar2, projno.ToString(), ParameterDirection.Input);
            OracleParameter op_results = new OracleParameter("p_results", OracleDbType.RefCursor, ParameterDirection.Output);

            //cmd.Parameters.Add(op_projno);
            //sql = " select projno, tcmno, name, to_char(sdate, 'dd-Mon-yy') sdate, to_char(edate, 'dd-Mon-yy') edate, floor(months_between(edate, sdate)) mnths from " +
            //      " (select a.projno, a.tcmno, a.name, a.active, to_char(a.sdate, 'dd-Mon-yy') sdate, " +
            //      " case when length(b.myymm) > 0 then to_date('28-' || substr(b.myymm, 5, 2) || '-' || substr(b.myymm, 1, 4),'dd-mm-yy')  " +
            //      " else to_date('28-' || to_char(a.sdate, 'mm') || '-' || to_char(a.sdate, 'yy'),'dd-mm-yy') end edate from projmast a, " +
            //      " (select projno, max(yymm) myymm from prjcmast where projno = :p_projno group by projno) b " +
            //      " where a.projno = b.projno and a.active > 0) order by projno";
            //cmd.CommandText = sql;
            //cmd.CommandType = CommandType.Text;

            var sql = "BEGIN rap_reports.rpt_tm01All_Project(:p_projno, :p_results); END;";
            object[] ora_param = new object[] { op_projno, op_results };
            var i_result = _dbContext.Database.ExecuteSqlRaw(sql, ora_param);
            OracleRefCursor cur_results = (OracleRefCursor)op_results.Value;

            try
            {
                //OracleDataAdapter da = new OracleDataAdapter(cmd);
                //da.Fill(ds, "projTable");
                //da.Dispose();
                //return ds;
                OracleDataAdapter da = new OracleDataAdapter();
                da.TableMappings.Add("Table", "colsTable");
                da.Fill(ds, "projTable", cur_results);
                da.Dispose();
                return ds;
            }
            catch (Exception)
            {
                throw;
            }
            finally
            {
                op_projno.Dispose();
                op_results.Dispose();
                if ((conn != null))
                {
                    if (conn.State == ConnectionState.Open)
                        conn.Close();
                }
            }
        }

        public object GetTM011AllDataOld(string projno, string yymm, string simul, string yearmode)
        {
            OracleConnection conn = (OracleConnection)_dbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
                conn.Open();

            DataSet ds = new DataSet();

            OracleParameter op_projno = new OracleParameter("p_projno", OracleDbType.Varchar2, projno.ToString(), ParameterDirection.Input);
            OracleParameter op_yymm = new OracleParameter("p_yymm", OracleDbType.Varchar2, yymm.ToString(), ParameterDirection.Input);
            OracleParameter op_simul = new OracleParameter("p_simul", OracleDbType.Varchar2, simul, ParameterDirection.Input);
            OracleParameter op_yearmode = new OracleParameter("p_yearmode", OracleDbType.Varchar2, yearmode, ParameterDirection.Input);
            OracleParameter op_cols = new OracleParameter("p_cols", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_results = new OracleParameter("p_results", OracleDbType.RefCursor, ParameterDirection.Output);

            var sql = "BEGIN rap_reports.rpt_tm01all(:p_projno, :p_yymm, :p_simul, :p_yearmode, :p_cols, :p_results); END;";
            object[] ora_param = new object[] { op_projno, op_yymm, op_simul, op_yearmode, op_cols, op_results };
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
                op_projno.Dispose();
                op_yymm.Dispose();
                op_simul.Dispose();
                op_yearmode.Dispose();
                op_cols.Dispose();
                op_results.Dispose();

                if ((conn != null))
                {
                    if (conn.State == ConnectionState.Open)
                        conn.Close();
                }
            }
        }

        public object GetTM011AllData(string activeYear, string yymm, string simul, string yearmode, string projno, string reportMode, string code)
        {
            OracleConnection conn = (OracleConnection)_dbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
                conn.Open();

            DataSet ds = new DataSet();

            OracleParameter op_activeyear = new OracleParameter("p_activeyear", OracleDbType.Varchar2, activeYear.ToString(), ParameterDirection.Input);
            OracleParameter op_yymm = new OracleParameter("p_yymm", OracleDbType.Varchar2, yymm.ToString(), ParameterDirection.Input);
            OracleParameter op_simul = new OracleParameter("p_simul", OracleDbType.Varchar2, simul, ParameterDirection.Input);
            OracleParameter op_yearmode = new OracleParameter("p_yearmode", OracleDbType.Varchar2, yearmode, ParameterDirection.Input);
            OracleParameter op_projno = new OracleParameter("p_projno", OracleDbType.Varchar2, projno.ToString(), ParameterDirection.Input);
            OracleParameter op_reportmode = new OracleParameter("p_reportmode", OracleDbType.Varchar2, reportMode.ToString(), ParameterDirection.Input);
            OracleParameter op_code = new OracleParameter("p_code", OracleDbType.Varchar2, code, ParameterDirection.Input);
            OracleParameter op_cols = new OracleParameter("p_cols", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_results = new OracleParameter("p_results", OracleDbType.RefCursor, ParameterDirection.Output);

            var sql = "BEGIN rap_tm01all_combine.rpt_tm01all(:p_activeyear, :p_yymm, :p_simul, :p_yearmode, :p_projno, :p_reportmode, :p_code, :p_cols, :p_results); END;";
            object[] ora_param = new object[] { op_activeyear, op_yymm, op_simul, op_yearmode, op_projno, op_reportmode, op_code, op_cols, op_results };
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
                op_activeyear.Dispose();
                op_yymm.Dispose();
                op_simul.Dispose();
                op_yearmode.Dispose();
                op_projno.Dispose();
                op_reportmode.Dispose();
                op_code.Dispose();
                op_cols.Dispose();
                op_results.Dispose();

                if ((conn != null))
                {
                    if (conn.State == ConnectionState.Open)
                        conn.Close();
                }
            }
        }
    }
}