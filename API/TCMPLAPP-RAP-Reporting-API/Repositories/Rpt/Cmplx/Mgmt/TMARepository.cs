using Microsoft.EntityFrameworkCore;
using Oracle.ManagedDataAccess.Client;
using Oracle.ManagedDataAccess.Types;
using RapReportingApi.RAPEntityModels;
using RapReportingApi.Repositories.Interfaces;
using System;
using System.Data;

namespace RapReportingApi.Repositories
{
    public class TMARepository : ITMARepository
    {
        public TMARepository(RAPDbContext paramDBContext)
        {
            _dbContext = paramDBContext;
        }

        private RAPDbContext _dbContext;

        public object tma(string yymm, string yearmode, string reporttype, string activeyear)
        {
            OracleConnection conn = (OracleConnection)_dbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
                conn.Open();

            OracleDataAdapter da = new OracleDataAdapter();
            OracleCommand cmd = conn.CreateCommand() as OracleCommand;
            DataSet ds = new DataSet();
            DataTable dtJobHead = new DataTable("JobHead");
            DataTable dtTMA = new DataTable("TMA");
            DataTable dtTMA_T = new DataTable("TMA_T");
            DataTable dtTMA_E = new DataTable("TMA_E");
            DataTable dtTMA_D = new DataTable("TMA_D");
            DataTable dtTMA_N = new DataTable("TMA_N");
            DataTable dtTMA_O = new DataTable("TMA_O");
            DataTable dtTM13_Cols = new DataTable("TM13_Cols");
            DataTable dtTM13 = new DataTable("TM13");
            DataTable dtTM13_E = new DataTable("TM13_E");
            DataTable dtTM13_C = new DataTable("TM13_C");
            DataTable dtTM13_P = new DataTable("TM13_P");
            DataTable dtTM13_M = new DataTable("TM13_M");
            DataTable dtTM13_D = new DataTable("TM13_D");
            DataTable dtTM13_Z = new DataTable("TM13_Z");
            DataTable dtTMA_Summary = new DataTable("TMA_Summary");

            OracleParameter op_activeyear = new OracleParameter("p_activeyear", OracleDbType.Varchar2, activeyear.ToString(), ParameterDirection.Input);
            OracleParameter op_yymm = new OracleParameter("p_yymm", OracleDbType.Varchar2, yymm.ToString(), ParameterDirection.Input);
            OracleParameter op_yearmode = new OracleParameter("p_yearmode", OracleDbType.Varchar2, yearmode.ToString(), ParameterDirection.Input);
            OracleParameter op_reporttype = new OracleParameter("p_report_type", OracleDbType.Varchar2, reporttype.ToString(), ParameterDirection.Input);
            OracleParameter op_tma = new OracleParameter("p_tma", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_tma_t = new OracleParameter("p_tma_t", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_tma_e = new OracleParameter("p_tma_e", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_tma_d = new OracleParameter("p_tma_d", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_tma_n = new OracleParameter("p_tma_n", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_tma_o = new OracleParameter("p_tma_o", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_cols = new OracleParameter("p_cols", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_tm13 = new OracleParameter("p_tm13", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_tm13_e = new OracleParameter("p_tm13_e", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_tm13_c = new OracleParameter("p_tm13_c", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_tm13_p = new OracleParameter("p_tm13_p", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_tm13_m = new OracleParameter("p_tm13_m", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_tm13_d = new OracleParameter("p_tm13_d", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_tm13_z = new OracleParameter("p_tm13_z", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_tma_summary = new OracleParameter("p_tma_summary", OracleDbType.RefCursor, ParameterDirection.Output);

            try
            {
                cmd.CommandText = "SELECT descr FROM rap_jobhead";
                cmd.CommandType = CommandType.Text;
                dtJobHead.Load(cmd.ExecuteReader());
                ds.Tables.Add(dtJobHead);

                var ora_sql = "BEGIN rap_reports_b.rpt_tma(:p_activeyear, " +
                                                            ":p_yymm, " +
                                                            ":p_yearmode, " +
                                                            ":p_report_type, " +
                                                            ":p_tma, " +
                                                            ":p_tma_t, " +
                                                            ":p_tma_e, " +
                                                            ":p_tma_d, " +
                                                            ":p_tma_n, " +
                                                            ":p_tma_o, " +
                                                            ":p_cols, " +
                                                            ":p_tm13, " +
                                                            ":p_tm13_e, " +
                                                            ":p_tm13_c, " +
                                                            ":p_tm13_p, " +
                                                            ":p_tm13_m, " +
                                                            ":p_tm13_d, " +
                                                            ":p_tm13_z, " +
                                                            ":p_tma_summary); END;";

                object[] ora_param = new object[] { op_activeyear, op_yymm, op_yearmode, op_reporttype, op_tma, op_tma_t, op_tma_e, op_tma_d, op_tma_n, op_tma_o,
                                                    op_cols, op_tm13, op_tm13_e, op_tm13_c, op_tm13_p, op_tm13_m, op_tm13_d, op_tm13_z, op_tma_summary };
                var i_result = _dbContext.Database.ExecuteSqlRaw(ora_sql, ora_param);

                da.Fill(dtTMA, (OracleRefCursor)op_tma.Value);
                ds.Tables.Add(dtTMA);
                da.Fill(dtTMA_T, (OracleRefCursor)op_tma_t.Value);
                ds.Tables.Add(dtTMA_T);
                da.Fill(dtTMA_E, (OracleRefCursor)op_tma_e.Value);
                ds.Tables.Add(dtTMA_E);
                da.Fill(dtTMA_D, (OracleRefCursor)op_tma_d.Value);
                ds.Tables.Add(dtTMA_D);
                da.Fill(dtTMA_N, (OracleRefCursor)op_tma_n.Value);
                ds.Tables.Add(dtTMA_N);
                da.Fill(dtTMA_O, (OracleRefCursor)op_tma_o.Value);
                ds.Tables.Add(dtTMA_O);
                da.Fill(dtTM13_Cols, (OracleRefCursor)op_cols.Value);
                ds.Tables.Add(dtTM13_Cols);
                da.Fill(dtTM13, (OracleRefCursor)op_tm13.Value);
                ds.Tables.Add(dtTM13);
                da.Fill(dtTM13_E, (OracleRefCursor)op_tm13_e.Value);
                ds.Tables.Add(dtTM13_E);
                da.Fill(dtTM13_C, (OracleRefCursor)op_tm13_c.Value);
                ds.Tables.Add(dtTM13_C);
                da.Fill(dtTM13_P, (OracleRefCursor)op_tm13_p.Value);
                ds.Tables.Add(dtTM13_P);
                da.Fill(dtTM13_M, (OracleRefCursor)op_tm13_m.Value);
                ds.Tables.Add(dtTM13_M);
                da.Fill(dtTM13_D, (OracleRefCursor)op_tm13_d.Value);
                ds.Tables.Add(dtTM13_D);
                da.Fill(dtTM13_Z, (OracleRefCursor)op_tm13_z.Value);
                ds.Tables.Add(dtTM13_Z);
                da.Fill(dtTMA_Summary, (OracleRefCursor)op_tma_summary.Value);
                ds.Tables.Add(dtTMA_Summary);

                return ds;
            }
            catch (Exception)
            {
                throw;
            }
            finally
            {
                dtJobHead.Dispose();
                dtTMA.Dispose();
                dtTMA_T.Dispose();
                dtTMA_E.Dispose();
                dtTMA_D.Dispose();
                dtTMA_N.Dispose();
                dtTMA_O.Dispose();
                dtTM13_Cols.Dispose();
                dtTM13.Dispose();
                dtTM13_E.Dispose();
                dtTM13_C.Dispose();
                dtTM13_P.Dispose();
                dtTM13_M.Dispose();
                dtTM13_D.Dispose();
                dtTM13_Z.Dispose();
                dtTMA_Summary.Dispose();
                ds.Dispose();
                cmd.Dispose();
                da.Dispose();
                op_activeyear.Dispose();
                op_yymm.Dispose();
                op_yearmode.Dispose();
                op_reporttype.Dispose();
                op_tma.Dispose();
                op_tma_t.Dispose();
                op_tma_e.Dispose();
                op_tma_d.Dispose();
                op_tma_n.Dispose();
                op_tma_o.Dispose();
                op_cols.Dispose();
                op_tm13.Dispose();
                op_tm13_e.Dispose();
                op_tm13_c.Dispose();
                op_tm13_p.Dispose();
                op_tm13_m.Dispose();
                op_tm13_d.Dispose();
                op_tm13_z.Dispose();
                op_tma_summary.Dispose();
                _dbContext.Dispose();

                if ((conn != null))
                {
                    if (conn.State == ConnectionState.Open)
                        conn.Close();
                }
            }
        }
    }
}