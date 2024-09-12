using Microsoft.EntityFrameworkCore;
using Oracle.ManagedDataAccess.Client;
using Oracle.ManagedDataAccess.Types;
using RapReportingApi.RAPEntityModels;
using RapReportingApi.Repositories.Interfaces.Rpt.Cmplx.CC.proj;
using System;
using System.Data;

namespace RapReportingApi.Repositories.Rpt.Cmplx.CC.proj
{
    public class TM11TM01GRepository : ITM11TM01GRepository
    {
        private RAPDbContext _dbContext;

        public TM11TM01GRepository(RAPDbContext paramDBContext)
        {
            _dbContext = paramDBContext;
        }

        public object TM11AData(string projno, string yymm, string yearmode)
        {
            OracleConnection conn = (OracleConnection)_dbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
                conn.Open();
            DataSet ds = new DataSet();
            // Get view name
            OracleCommand cmd = conn.CreateCommand() as OracleCommand;
            string ora_sql = string.Empty;
            OracleParameter op_yymm = new OracleParameter("p_yymm", OracleDbType.Varchar2, yymm.ToString(), ParameterDirection.Input);
            cmd.Parameters.Add(op_yymm);
            ora_sql = " Select 'D' || to_char(postby, 'dd') from wrkhours where yymm = :p_yymm";
            cmd.CommandText = ora_sql;
            cmd.CommandType = CommandType.Text;
            string vuName = cmd.ExecuteScalar().ToString();
            // Get General data
            string sql_gen = string.Empty;
            DataTable dtgen = new DataTable();
            OracleCommand cmd_gen = conn.CreateCommand() as OracleCommand;
            OracleParameter op_projno = new OracleParameter("p_projno", OracleDbType.Varchar2, projno.ToString(), ParameterDirection.Input);
            cmd_gen.Parameters.Add(op_projno);
            sql_gen = " select distinct substr(a.projno, 1, 5) projno, a.name, a.active, a.cdate, a.Tcmno, " +
                      " b.name Prjdymngrname, c.name Prjmngrname, to_char(sysdate,'dd-Mon-yyyy') processdate " +
                      " from projmast a, emplmast b, emplmast c " +
                      " where a.prjmngr = b.empno and a.prjdymngr = c.empno(+) and substr(a.projno, 1, 5) = :p_projno ";
            cmd_gen.CommandText = sql_gen;
            cmd_gen.CommandType = CommandType.Text;

            // Get data
            string sql_TM11A = string.Empty;
            DataTable dtTM11A = new DataTable();
            OracleCommand cmd_TM11A = conn.CreateCommand() as OracleCommand;
            OracleParameter op_projno_1 = new OracleParameter("p_projno_1", OracleDbType.Varchar2, projno.ToString(), ParameterDirection.Input);
            OracleParameter op_yymm_1 = new OracleParameter("p_yymm_1", OracleDbType.Varchar2, yymm.ToString(), ParameterDirection.Input);
            cmd_TM11A.Parameters.Add(op_projno_1);
            cmd_TM11A.Parameters.Add(op_yymm_1);
            sql_TM11A = " select assign, empno, name, uptocutoff, estimates, adjustments " +
                        " from " + vuName.ToString() + " where projno like concat(:p_projno_1, '%') and yymm = :p_yymm_1 " +
                        " order by yymm, assign, empno ";
            cmd_TM11A.CommandText = sql_TM11A;
            cmd_TM11A.CommandType = CommandType.Text;
            try
            {
                OracleDataAdapter dagen = new OracleDataAdapter(cmd_gen);
                dagen.Fill(ds, "genTable");
                dagen.Dispose();
                OracleDataAdapter daTM11A = new OracleDataAdapter(cmd_TM11A);
                daTM11A.Fill(ds, "tm11aTable");
                daTM11A.Dispose();
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
                cmd.Dispose();
                dtTM11A.Dispose();
                cmd_TM11A.Dispose();
                op_projno.Dispose();
                op_yymm.Dispose();
                op_projno_1.Dispose();
                op_yymm_1.Dispose();
                //_dbContext.Dispose();
            }
        }

        public object TM11TM01Data_Old(string projno, string yymm, string yearmode, string yyyy)
        {
            OracleConnection conn = (OracleConnection)_dbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
                conn.Open();
            DataSet ds = new DataSet();
            // Get General data
            string sql_gen = string.Empty;
            DataTable dtgen = new DataTable();
            OracleCommand cmd_gen = conn.CreateCommand() as OracleCommand;
            OracleParameter op_projno = new OracleParameter("p_projno", OracleDbType.Varchar2, projno.ToString(), ParameterDirection.Input);
            cmd_gen.Parameters.Add(op_projno);
            sql_gen = " select distinct substr(a.projno, 1, 5) projno, a.name, a.active, a.cdate, a.Tcmno, " +
                      " b.name Prjdymngrname, c.name Prjmngrname, to_char(sysdate,'dd-Mon-yyyy') processdate " +
                      " from projmast a, emplmast b, emplmast c " +
                      " where a.prjmngr = b.empno and a.prjdymngr = c.empno(+) and substr(a.projno, 1, 5) = :p_projno ";
            cmd_gen.CommandText = sql_gen;
            cmd_gen.CommandType = CommandType.Text;

            // Get TM11 Data - Sheet 1
            string sql_TM11 = string.Empty;
            DataTable dtTM11 = new DataTable();
            OracleCommand cmd_TM11 = conn.CreateCommand() as OracleCommand;
            OracleParameter op_projno_1 = new OracleParameter("p_projno_1", OracleDbType.Varchar2, projno.ToString(), ParameterDirection.Input);
            OracleParameter op_yymm_1 = new OracleParameter("p_yymm_1", OracleDbType.Varchar2, yymm.ToString(), ParameterDirection.Input);
            cmd_TM11.Parameters.Add(op_projno_1);
            cmd_TM11.Parameters.Add(op_yymm_1);
            sql_TM11 = " select wpcode, trim(a.activity) || ' ' || (select tlpcode from act_mast " +
                       " where costcode = a.costcode and trim(activity) = trim(a.activity)) Particol, a.projno, " +
                       " a.costcode, a.empno, b.name, sum(nvl(a.hours, 0)) as hours, sum(nvl(a.othours, 0)) as othours " +
                       " from timetran a, emplmast b " +
                       " where a.empno = b.empno and a.projno in (select projno from projmast " +
                       " where substr(proj_no, 1, 5) = :p_projno_1) and a.yymm = :p_yymm_1 " +
                       " group by a.yymm, a.empno, b.name, a.costcode, a.projno, a.wpcode, a.activity, a.projno " +
                       " order by a.yymm, a.empno, b.name, a.costcode, a.projno, a.wpcode, a.activity";
            cmd_TM11.CommandText = sql_TM11;
            cmd_TM11.CommandType = CommandType.Text;

            // Get TM01 Data  - Sheet 2
            //string sql_TM01 = string.Empty;
            //DataTable dtTM01 = new DataTable();
            //OracleCommand cmd_TM01 = conn.CreateCommand() as OracleCommand;
            //OracleParameter op_projno_2 = new OracleParameter("p_projno_2", OracleDbType.Varchar2, projno.ToString(), ParameterDirection.Input);
            //OracleParameter op_yymm_2 = new OracleParameter("p_yymm_2", OracleDbType.Varchar2, yymm.ToString(), ParameterDirection.Input);
            //cmd_TM01.Parameters.Add(op_projno_2);
            //cmd_TM01.Parameters.Add(op_yymm_2);
            //sql_TM01 = " select wpcode, trim(a.activity) || ' ' || (select tlpcode from act_mast " +
            //           " where costcode = a.costcode and trim(activity) = trim(a.activity)) Particol,  " +
            //           " a.costcode, a.empno, b.name, sum(nvl(a.hours, 0)) as hours, sum(nvl(a.othours, 0)) as othours " +
            //           " from timetran a, emplmast b " +
            //           " where a.empno = b.empno and a.projno in (select projno from projmast " +
            //           " where substr(proj_no, 1, 5) = :p_projno_1) and a.yymm = :p_yymm_1 " +
            //           " group by a.yymm, a.empno, b.name, a.costcode, a.projno, a.wpcode, a.activity " +
            //           " order by a.yymm, a.empno, b.name, a.costcode, a.projno, a.wpcode, a.activity";
            //cmd_TM01.CommandText = sql_TM01;
            //cmd_TM01.CommandType = CommandType.Text;

            // Get TM01 Data - Sheet 2
            OracleParameter op_projno_2 = new OracleParameter("p_projno_2", OracleDbType.Varchar2, projno.ToString(), ParameterDirection.Input);
            OracleParameter op_yymm_2 = new OracleParameter("p_yymm_2", OracleDbType.Varchar2, yymm.ToString(), ParameterDirection.Input);
            OracleParameter op_yearmode = new OracleParameter("p_yearmode", OracleDbType.Varchar2, yearmode.ToString(), ParameterDirection.Input);
            OracleParameter op_yyyy = new OracleParameter("p_yyyy", OracleDbType.Varchar2, yyyy.ToString(), ParameterDirection.Input);
            OracleParameter op_cols = new OracleParameter("p_cols", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_part1 = new OracleParameter("p_part1", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_part2 = new OracleParameter("p_part2", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_part3 = new OracleParameter("p_part3", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_part4 = new OracleParameter("p_part4", OracleDbType.RefCursor, ParameterDirection.Output);

            var sql = "BEGIN rap_reports.rpt_tm11_tm01(:p_projno_2, :p_yymm_2, :p_yearmode, :p_yyyy, :p_cols, :p_part1, :p_part2, :p_part3, :p_part4); END;";
            object[] ora_param = new object[] { op_projno_2, op_yymm_2, op_yearmode, op_yyyy, op_cols, op_part1, op_part2, op_part3, op_part4 };
            var i_result = _dbContext.Database.ExecuteSqlRaw(sql, ora_param);
            OracleRefCursor cur_cols = (OracleRefCursor)op_cols.Value;
            OracleRefCursor cur_part1 = (OracleRefCursor)op_part1.Value;
            OracleRefCursor cur_part2 = (OracleRefCursor)op_part2.Value;
            OracleRefCursor cur_part3 = (OracleRefCursor)op_part3.Value;
            OracleRefCursor cur_part4 = (OracleRefCursor)op_part4.Value;

            try
            {
                // TM11 - Sheet 1
                OracleDataAdapter dagen = new OracleDataAdapter(cmd_gen);
                dagen.Fill(ds, "genTable");
                dagen.Dispose();
                OracleDataAdapter daTM11 = new OracleDataAdapter(cmd_TM11);
                daTM11.Fill(ds, "tm11Table");
                daTM11.Dispose();

                // TM01 - Sheet 2
                //OracleDataAdapter daTM01 = new OracleDataAdapter(cmd_TM01);
                //daTM01.Fill(ds, "tm01Table");

                OracleDataAdapter daTM01 = new OracleDataAdapter();
                daTM01.TableMappings.Add("Table", "colsTable");
                daTM01.TableMappings.Add("Table1", "part1Table");
                daTM01.TableMappings.Add("Table2", "part2Table");
                daTM01.TableMappings.Add("Table3", "part3Table");
                daTM01.TableMappings.Add("Table4", "part4Table");
                daTM01.Fill(ds, "colsTable", cur_cols);
                daTM01.Fill(ds, "part1Table", cur_part1);
                daTM01.Fill(ds, "part2Table", cur_part2);
                daTM01.Fill(ds, "part3Table", cur_part3);
                daTM01.Fill(ds, "part4Table", cur_part4);
                daTM01.Dispose();
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
                cmd_TM11.Dispose();
                op_projno.Dispose();
                op_projno_1.Dispose();
                op_yymm_1.Dispose();
                op_projno_2.Dispose();
                op_yymm_2.Dispose();
                op_yearmode.Dispose();
                op_cols.Dispose();
                op_part1.Dispose();
                op_part2.Dispose();
                op_part3.Dispose();

                //_dbContext.Dispose();
            }
        }

        public object TM11TM01Data(string projno, string yymm, string yearmode, string yyyy)
        {
            OracleConnection conn = (OracleConnection)_dbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
                conn.Open();
            DataSet ds = new DataSet();

            OracleParameter op_projno = new OracleParameter("p_projno", OracleDbType.Varchar2, projno.ToString(), ParameterDirection.Input);
            OracleParameter op_yymm = new OracleParameter("p_yymm", OracleDbType.Varchar2, yymm.ToString(), ParameterDirection.Input);
            OracleParameter op_yearmode = new OracleParameter("p_yearmode", OracleDbType.Varchar2, yearmode.ToString(), ParameterDirection.Input);
            OracleParameter op_yyyy = new OracleParameter("p_yyyy", OracleDbType.Varchar2, yyyy.ToString(), ParameterDirection.Input);
            OracleParameter op_cols = new OracleParameter("p_cols", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_gen = new OracleParameter("p_gen", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_part1 = new OracleParameter("p_part1", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_part2 = new OracleParameter("p_part2", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_part3 = new OracleParameter("p_part3", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_part4 = new OracleParameter("p_part4", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_part5 = new OracleParameter("p_part5", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_part6 = new OracleParameter("p_part6", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_tm11data = new OracleParameter("p_tm11data", OracleDbType.RefCursor, ParameterDirection.Output);

            var sql = "BEGIN rap_reports.rpt_tm11_tm01(:p_projno, :p_yymm, :p_yearmode, :p_yyyy, :p_cols, :p_gen, :p_part1, :p_part2, :p_part3, :p_part4, :p_part5, :p_part6, :p_tm11data); END;";
            object[] ora_param = new object[] { op_projno, op_yymm, op_yearmode, op_yyyy, op_cols, op_gen, op_part1, op_part2, op_part3, op_part4, op_part5, op_part6, op_tm11data };
            
            var i_result = _dbContext.Database.ExecuteSqlRaw(sql, ora_param);
            OracleRefCursor cur_cols = (OracleRefCursor)op_cols.Value;
            OracleRefCursor cur_gen = (OracleRefCursor)op_gen.Value;
            OracleRefCursor cur_part1 = (OracleRefCursor)op_part1.Value;
            OracleRefCursor cur_part2 = (OracleRefCursor)op_part2.Value;
            OracleRefCursor cur_part3 = (OracleRefCursor)op_part3.Value;
            OracleRefCursor cur_part4 = (OracleRefCursor)op_part4.Value;
            OracleRefCursor cur_part5 = (OracleRefCursor)op_part5.Value;
            OracleRefCursor cur_part6 = (OracleRefCursor)op_part6.Value;
            OracleRefCursor cur_tm11data = (OracleRefCursor)op_tm11data.Value;

            try
            {
                OracleDataAdapter da = new OracleDataAdapter();
                da.TableMappings.Add("Table", "colsTable");
                da.TableMappings.Add("Table1", "genTable");
                da.TableMappings.Add("Table2", "part1Table");
                da.TableMappings.Add("Table3", "part2Table");
                da.TableMappings.Add("Table4", "part3Table");
                da.TableMappings.Add("Table5", "part4Table");
                da.TableMappings.Add("Table6", "part5Table");               
                da.TableMappings.Add("Table7", "part6Table");
                da.TableMappings.Add("Table8", "tm11Table");
                da.Fill(ds, "colsTable", cur_cols);
                da.Fill(ds, "genTable", cur_gen);
                da.Fill(ds, "part1Table", cur_part1);
                da.Fill(ds, "part2Table", cur_part2);
                //da.Fill(ds, "part3Table", cur_part3);
                da.Fill(ds, "part4Table", cur_part4);
                da.Fill(ds, "part5Table", cur_part5);
                da.Fill(ds, "part6Table", cur_part6);
                da.Fill(ds, "tm11Table", cur_tm11data);
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
                op_projno.Dispose();
                op_yymm.Dispose();
                op_yearmode.Dispose();
                op_yyyy.Dispose();
                op_cols.Dispose();
                op_gen.Dispose();
                op_part1.Dispose();
                op_part2.Dispose();
                op_part3.Dispose();
                op_part4.Dispose();
                op_part5.Dispose();
                op_part6.Dispose();
                op_tm11data.Dispose();
            }
        }

        public object TM11BData(string projno, string yymm, string yearmode, string yyyy)
        {
            DataSet ds = new DataSet();
            OracleConnection conn = (OracleConnection)_dbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
                conn.Open();

            OracleParameter op_activeyear = new OracleParameter("p_activeyear", OracleDbType.Varchar2, yyyy, ParameterDirection.Input);
            OracleParameter op_yymm = new OracleParameter("p_yymm", OracleDbType.Varchar2, yymm.ToString(), ParameterDirection.Input);
            OracleParameter op_projno5 = new OracleParameter("p_projno5", OracleDbType.Varchar2, projno.ToString(), ParameterDirection.Input);
            OracleParameter op_rec = new OracleParameter("p_rec", OracleDbType.RefCursor, ParameterDirection.Output);

            try
            {
                var sql = "BEGIN RAP_REPORTS_PROJECT.rpt_proj_emp_typ_upd_tm11b(:p_activeyear, :p_yymm, :p_projno5, :p_rec); END;";
                object[] ora_param = new object[] { op_activeyear, op_yymm, op_projno5, op_rec };
                var i_result = _dbContext.Database.ExecuteSqlRaw(sql, ora_param);
                OracleRefCursor cur_audit = (OracleRefCursor)op_rec.Value;
                OracleDataAdapter da = new OracleDataAdapter();
                da.TableMappings.Add("Table", "TM11B");

                da.Fill(ds, "TM11B", cur_audit);
                da.Dispose();

                // Get General data
                string sql_gen = string.Empty;
                DataTable dtgen = new DataTable();
                OracleCommand cmd_gen = conn.CreateCommand() as OracleCommand;
                OracleParameter op_projno = new OracleParameter("p_projno", OracleDbType.Varchar2, projno.ToString(), ParameterDirection.Input);
                cmd_gen.Parameters.Add(op_projno);
                sql_gen = " select distinct substr(a.projno, 1, 5) projno, a.name, a.active, a.cdate, a.Tcmno, " +
                          " b.name Prjdymngrname, c.name Prjmngrname, to_char(sysdate,'dd-Mon-yyyy') processdate " +
                          " from projmast a, emplmast b, emplmast c " +
                          " where a.prjmngr = b.empno and a.prjdymngr = c.empno(+) and substr(a.projno, 1, 5) = :p_projno ";
                cmd_gen.CommandText = sql_gen;
                cmd_gen.CommandType = CommandType.Text;
                OracleDataAdapter dagen = new OracleDataAdapter(cmd_gen);
                dagen.Fill(ds, "genTable");
                dagen.Dispose();

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
                op_projno5.Dispose();
                op_yymm.Dispose();
                op_rec.Dispose();
            }
        }

        public object getProjectsTCMJobsGrp(string yymm)
        {
            OracleConnection conn = (OracleConnection)_dbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
                conn.Open();

            OracleCommand cmd = null;
            DataSet ds = new DataSet();
            try
            {
                cmd = new OracleCommand("rap_reports.projects_TCMJobsGrp", conn);
                cmd.CommandType = System.Data.CommandType.StoredProcedure;
                cmd.Parameters.Clear();

                cmd.Parameters.Add("p_yymm", OracleDbType.Varchar2, yymm.ToString(), ParameterDirection.Input);
                cmd.Parameters.Add("p_results", OracleDbType.RefCursor, ParameterDirection.Output);
                OracleDataAdapter da = new OracleDataAdapter(cmd);
                cmd.ExecuteNonQuery();
                da.Fill(ds, "ProjnoTable");
                da.Dispose();
                return ds.Tables["ProjnoTable"];
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
    }
}