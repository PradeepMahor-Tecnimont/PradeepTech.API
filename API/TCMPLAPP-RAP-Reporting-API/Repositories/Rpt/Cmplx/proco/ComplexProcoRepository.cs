using Microsoft.EntityFrameworkCore;
using Oracle.ManagedDataAccess.Client;
using Oracle.ManagedDataAccess.Types;
using RapReportingApi.RAPEntityModels;
using RapReportingApi.Repositories.Interfaces.Rpt.Cmplx.proco;
using System;
using System.Data;

namespace RapReportingApi.Repositories.Rpt.Cmplx.proco
{
    public class ComplexProcoRepository : IComplexProcoRepository
    {
        private RAPDbContext _dbContext;

        public ComplexProcoRepository(RAPDbContext paramDBContext)
        {
            _dbContext = paramDBContext;
        }

        public object PRJCCTCData(string yymm, string yearmode)
        {
            OracleConnection conn = (OracleConnection)_dbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
                conn.Open();
            DataSet ds = new DataSet();
            // Get General data
            string sql_gen = string.Empty;
            DataTable dtgen = new DataTable();
            OracleCommand cmd_gen = conn.CreateCommand() as OracleCommand;
            //OracleParameter op_projno = new OracleParameter("p_projno", OracleDbType.Varchar2, projno.ToString(), ParameterDirection.Input);
            //cmd_gen.Parameters.Add(op_projno);
            //sql_gen = " select distinct substr(a.projno, 1, 5) projno, a.name, a.active, a.cdate, a.Tcmno, " +
            //          " b.name Prjdymngrname, c.name Prjmngrname, to_char(sysdate,'dd-Mon-yyyy') processdate " +
            //          " from projmast a, emplmast b, emplmast c " +
            //          " where a.prjmngr = b.empno and a.prjdymngr = c.empno and substr(a.projno, 1, 5) = :p_projno ";
            sql_gen = " select to_char(sysdate,'dd-Mon-yyyy') processdate from dual";
            cmd_gen.CommandText = sql_gen;
            cmd_gen.CommandType = CommandType.Text;

            // Get PRJ_CC_TCM Data
            //OracleParameter op_projno_1 = new OracleParameter("p_projno_1", OracleDbType.Varchar2, projno.ToString(), ParameterDirection.Input);
            OracleParameter op_yymm = new OracleParameter("p_yymm", OracleDbType.Varchar2, yymm.ToString(), ParameterDirection.Input);
            OracleParameter op_yearmode = new OracleParameter("p_yearmode", OracleDbType.Varchar2, yearmode.ToString(), ParameterDirection.Input);
            OracleParameter op_cols = new OracleParameter("p_cols", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_results = new OracleParameter("p_results", OracleDbType.RefCursor, ParameterDirection.Output);

            //var sql = "BEGIN rap_reports.rpt_prj_cc_tcm(:p_projno_1, :p_yymm, :p_yearmode, :p_cols, :p_results); END;";
            //object[] ora_param = new object[] { op_projno_1, op_yymm, op_yearmode, op_cols, op_results };
            var sql = "BEGIN rap_reports.rpt_prj_cc_tcm(:p_yymm, :p_yearmode, :p_cols, :p_results); END;";
            object[] ora_param = new object[] { op_yymm, op_yearmode, op_cols, op_results };
            var i_result = _dbContext.Database.ExecuteSqlRaw(sql, ora_param);
            OracleRefCursor cur_cols = (OracleRefCursor)op_cols.Value;
            OracleRefCursor cur_results = (OracleRefCursor)op_results.Value;

            try
            {
                OracleDataAdapter dagen = new OracleDataAdapter(cmd_gen);
                dagen.Fill(ds, "genTable");
                dagen.Dispose();

                OracleDataAdapter daTCMCC = new OracleDataAdapter();
                daTCMCC.TableMappings.Add("Table", "colsTable");
                daTCMCC.TableMappings.Add("Table1", "prjcctcmTable");
                daTCMCC.Fill(ds, "colsTable", cur_cols);
                daTCMCC.Fill(ds, "prjcctcmTable", cur_results);
                daTCMCC.Dispose();
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

                //op_projno.Dispose();
                //op_projno_1.Dispose();
                op_yymm.Dispose();
                op_yearmode.Dispose();
                op_cols.Dispose();
                op_results.Dispose();
            }
        }

        public object ReimbPOData(string yymm)
        {
            OracleConnection conn = (OracleConnection)_dbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
                conn.Open();
            DataSet ds = new DataSet();

            OracleParameter op_yymm = new OracleParameter("p_yymm", OracleDbType.Varchar2, yymm.ToString(), ParameterDirection.Input);
            OracleParameter op_hrs = new OracleParameter("p_hrs", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_hrs_o = new OracleParameter("p_hrs_o", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_hrs_exo = new OracleParameter("p_hrs_exo", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_hrs_exo_mumbai = new OracleParameter("p_hrs_exo_mumbai", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_hrs_exo_delhi = new OracleParameter("p_hrs_exo_delhi", OracleDbType.RefCursor, ParameterDirection.Output);

            try
            {                
                var sql = "BEGIN rap_reimb_po_combine.rpt_reimbpo(:p_yymm, :p_hrs, :p_hrs_o, :p_hrs_exo, :p_hrs_exo_mumbai, :p_hrs_exo_delhi); END; ";
                object[] ora_param = new object[] { op_yymm, op_hrs, op_hrs_o, op_hrs_exo, op_hrs_exo_mumbai, op_hrs_exo_delhi };
                var i_result = _dbContext.Database.ExecuteSqlRaw(sql, ora_param);

                OracleRefCursor cur_hrs = (OracleRefCursor)op_hrs.Value;
                OracleRefCursor cur_hrs_o = (OracleRefCursor)op_hrs_o.Value;
                OracleRefCursor cur_hrs_exo = (OracleRefCursor)op_hrs_exo.Value;
                OracleRefCursor cur_hrs_exo_mumbai = (OracleRefCursor)op_hrs_exo_mumbai.Value;
                OracleRefCursor cur_hrs_exo_delhi = (OracleRefCursor)op_hrs_exo_delhi.Value;

                OracleDataAdapter da = new OracleDataAdapter();
                da.TableMappings.Add("Table", "hrs");
                da.TableMappings.Add("Table1", "hrs_o");
                da.TableMappings.Add("Table2", "hrs_exo");
                da.TableMappings.Add("Table3", "hrs_exo_mumbai");
                da.TableMappings.Add("Table4", "hrs_exo_delhi");

                da.Fill(ds, "hrsTable", cur_hrs);
                da.Fill(ds, "hrsOTable", cur_hrs_o);
                da.Fill(ds, "hrsEXOTable", cur_hrs_exo);
                da.Fill(ds, "hrsMumbaiEXOTable", cur_hrs_exo_mumbai);
                da.Fill(ds, "hrsDelhiEXOTable", cur_hrs_exo_delhi);

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
                op_yymm.Dispose();
                op_hrs.Dispose();
                op_hrs_o.Dispose();
                op_hrs_exo.Dispose();
                op_hrs_exo_mumbai.Dispose();
                op_hrs_exo_delhi.Dispose();
            }
        }

        public object OutsideSubcontractData(string yyyy, string yearmode, string yymm, string costcode)
        {
            OracleConnection conn = (OracleConnection)_dbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
                conn.Open();
            DataSet ds = new DataSet();

            // Get Outside subcontract Data            
            OracleParameter op_yearmode = new OracleParameter("p_yearmode", OracleDbType.Varchar2, yearmode.ToString(), ParameterDirection.Input);
            OracleParameter op_yyyy = new OracleParameter("p_yyyy", OracleDbType.Varchar2, yyyy.ToString(), ParameterDirection.Input);
            OracleParameter op_yymm = new OracleParameter("p_yymm", OracleDbType.Varchar2, yymm.ToString(), ParameterDirection.Input);
            OracleParameter op_costcode = new OracleParameter("p_costcode", OracleDbType.Varchar2, costcode?.ToString(), ParameterDirection.Input);           
            OracleParameter op_cols = new OracleParameter("p_cols", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_results = new OracleParameter("p_results", OracleDbType.RefCursor, ParameterDirection.Output);            

            var sql = "BEGIN pkg_rap_osc_report.sp_osc_monthly_report(:p_yearmode, :p_yyyy, :p_yymm, :p_costcode, :p_cols, :p_results); END;";
            object[] ora_param = new object[] { op_yearmode, op_yyyy, op_yymm, op_costcode, op_cols, op_results };
            var i_result = _dbContext.Database.ExecuteSqlRaw(sql, ora_param);
            OracleRefCursor cur_cols = (OracleRefCursor)op_cols.Value;
            OracleRefCursor cur_results = (OracleRefCursor)op_results.Value;           

            try
            {                
                OracleDataAdapter daTCMCC = new OracleDataAdapter();
                daTCMCC.TableMappings.Add("Table", "colsTable");
                daTCMCC.TableMappings.Add("Table1", "resultsTable");
                daTCMCC.TableMappings.Add("Table2", "results1Table");
                daTCMCC.Fill(ds, "colsTable", cur_cols);
                daTCMCC.Fill(ds, "resultsTable", cur_results);               
                daTCMCC.Dispose();
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

                op_yearmode.Dispose();
                op_yyyy.Dispose();
                op_yymm.Dispose();
                op_costcode.Dispose();
                op_cols.Dispose();
                op_results.Dispose();
            }
        }

    }
}