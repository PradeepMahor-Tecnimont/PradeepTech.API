using Microsoft.EntityFrameworkCore;
using Oracle.ManagedDataAccess.Client;
using Oracle.ManagedDataAccess.Types;
using RapReportingApi.RAPEntityModels;
using RapReportingApi.Repositories.Interfaces.Rpt.Cmplx.Mgmt;
using System;
using System.Data;

namespace RapReportingApi.Repositories.Rpt.Cmplx.Mgmt
{
    public class CHA1EGRPRepository : ICHA1EGRPRepository
    {
        private RAPDbContext _dbContext;

        public CHA1EGRPRepository(RAPDbContext paramDBContext)
        {
            _dbContext = paramDBContext;
        }

        public object GetCostcodeList(string costgrp)
        {
            OracleConnection conn = (OracleConnection)_dbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
                conn.Open();
            DataSet ds = new DataSet();

            string sql = string.Empty;
            DataTable dt = new DataTable();
            OracleCommand cmd = conn.CreateCommand() as OracleCommand;

            switch (costgrp)
            {
                case "E":
                    sql = " select costcode, name, abbr, activity, group_chart from costmast " +
                          " where tma_grp = 'E' and activity = 1 and group_chart = 1 " +
                          " and costcode In (Select costcode From deptphase Where IsPrimary = 1) " +
                          " order by costcode ";
                    break;

                case "EM":
                    sql = " select costcode, name, abbr, activity, group_chart from costmast " +
                          " where tma_grp = 'E' and activity = 1 and group_chart = 1 " +  
                          " and costcode In (Select costcode From deptphase Where costcode like '02%' And IsPrimary = 1) " +
                          " order by costcode ";
                    break;

                case "ED":
                    sql = " select costcode, name, abbr, activity, group_chart from costmast " +
                          " where tma_grp = 'E' and activity = 1 and group_chart = 1 " +  
                          " and costcode In (Select costcode From deptphase Where costcode like '0D%' And IsPrimary = 1) " +
                          " order by costcode ";
                    break;

                case "N":
                    sql = " select costcode,name,abbr,activity,group_chart from costmast " +
                          " where tma_grp in ('P','M','C')  and activity = 1 and group_chart = 1 " +
                          " and costcode In (Select costcode From deptphase Where IsPrimary = 1) " +
                          " order by costcode";                          
                    break;

                case "NM":
                    sql = " select costcode,name,abbr,activity,group_chart from costmast " +
                          " where tma_grp in ('P','M','C')  and activity = 1 and group_chart = 1 " +
                          " and costcode In (Select costcode From deptphase Where costcode like '02%' And IsPrimary = 1) " +
                          " order by costcode";
                    break;

                case "ND":
                    sql = " select costcode,name,abbr,activity,group_chart from costmast " +
                          " where tma_grp in ('P','M','C')  and activity = 1 and group_chart = 1 " +
                          " and costcode In (Select costcode From deptphase Where costcode like '0D%' And IsPrimary = 1) " +
                          " order by costcode";
                    break;

                case "B":
                    sql = " select costcode,name,abbr,activity,group_chart from costmast  " +
                          " where (tma_grp = 'E' or tma_grp = 'P' or tma_grp = 'C' or tma_grp = 'M') " +
                          " and costcode In (Select costcode From deptphase Where IsPrimary = 1) " +
                          " and activity = 1 and group_chart = 1 order by costcode";                          
                    break;

                case "BM":
                    sql = " select costcode,name,abbr,activity,group_chart from costmast  " +
                          " where (tma_grp = 'E' or tma_grp = 'P' or tma_grp = 'C' or tma_grp = 'M') " +
                          " and costcode In (Select costcode From deptphase Where costcode like '02%' And IsPrimary = 1) " +
                          " and activity = 1 and group_chart = 1 order by costcode";
                    break;

                case "BD":
                    sql = " select costcode,name,abbr,activity,group_chart from costmast  " +
                          " where (tma_grp = 'E' or tma_grp = 'P' or tma_grp = 'C' or tma_grp = 'M') " +
                          " and costcode In (Select costcode From deptphase Where costcode like '0D%' And IsPrimary = 1) " +
                          " and activity = 1 and group_chart = 1 order by costcode";
                    break;

                case "PROCUREMENT":
                    sql = " Select c.costcode costcode, c.name name, c.abbr abbr, c.activity activity, c.group_chart group_chart " +
                          "	From costmast c, deptphase d, rap_costcode_group rcg, rap_costcode_group_costcodes rcgc   " +
                          " Where c.costcode = d.costcode And c.costcode = rcgc.costcode And rcg.group_id = rcgc.group_id " +
                          " And c.tma_grp = 'P' And d.IsPrimary = 1 And c.activity = 1 And c.group_chart = 1 And rcg.group_name = 'PROCUREMENT' " +
                          " Order By c.costcode";
                    break;

                case "PROCUREMENT_MUMBAI":
                    sql = " Select c.costcode costcode, c.name name, c.abbr abbr, c.activity activity, c.group_chart group_chart " +
                          "	From costmast c, deptphase d, rap_costcode_group rcg, rap_costcode_group_costcodes rcgc   " +
                          " Where c.costcode = d.costcode And c.costcode = rcgc.costcode And rcg.group_id = rcgc.group_id " +
                          " And c.tma_grp = 'P' And d.IsPrimary = 1 And c.activity = 1 And c.group_chart = 1 And rcg.group_name = 'PROCUREMENT' And rcgc.code Is Null " +
                          " Order By c.costcode";
                    break;

                case "PROCUREMENT_DELHI":
                    sql = " Select c.costcode costcode, c.name name, c.abbr abbr, c.activity activity, c.group_chart group_chart " +
                          "	From costmast c, deptphase d, rap_costcode_group rcg, rap_costcode_group_costcodes rcgc   " +
                          " Where c.costcode = d.costcode And c.costcode = rcgc.costcode And rcg.group_id = rcgc.group_id " +
                          " And c.tma_grp = 'P' And d.IsPrimary = 1 And c.activity = 1 And c.group_chart = 1 And rcg.group_name = 'PROCUREMENT' And rcgc.code = 'D' " +
                          " Order By c.costcode";
                    break;

                case "PROCO":
                    sql = " Select c.costcode costcode, c.name name, c.abbr abbr, c.activity activity, c.group_chart group_chart " +
                          "	From costmast c, deptphase d, rap_costcode_group rcg, rap_costcode_group_costcodes rcgc   " +
                          " Where c.costcode = d.costcode And c.costcode = rcgc.costcode And rcg.group_id = rcgc.group_id " +
                          " And c.tma_grp In ('M','C') And d.IsPrimary = 1 And c.activity = 1 And c.group_chart = 1 And rcg.group_name = 'PROCO' " +
                          " Order By c.costcode";
                    break;

                case "PROCO_MUMBAI":
                    sql = " Select c.costcode costcode, c.name name, c.abbr abbr, c.activity activity, c.group_chart group_chart " +
                          "	From costmast c, deptphase d, rap_costcode_group rcg, rap_costcode_group_costcodes rcgc   " +
                          " Where c.costcode = d.costcode And c.costcode = rcgc.costcode And rcg.group_id = rcgc.group_id " +
                          " And c.tma_grp In ('M','C') And d.IsPrimary = 1 And c.activity = 1 And c.group_chart = 1 And rcg.group_name = 'PROCO' And rcgc.code Is Null " +
                          " Order By c.costcode";
                    break;

                case "PROCO_DELHI":
                    sql = " Select c.costcode costcode, c.name name, c.abbr abbr, c.activity activity, c.group_chart group_chart " +
                          "	From costmast c, deptphase d, rap_costcode_group rcg, rap_costcode_group_costcodes rcgc   " +
                          " Where c.costcode = d.costcode And c.costcode = rcgc.costcode And rcg.group_id = rcgc.group_id " +
                          " And c.tma_grp In ('M','C') And d.IsPrimary = 1 And c.activity = 1 And c.group_chart = 1 And rcg.group_name = 'PROCO' And rcgc.code = 'D' " +
                          " Order By c.costcode";
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

        public object GetCha1ECostcodeData(string yymm, string costcode, string simul, string activeYear, string reportMode)
        {
            DataSet ds = new DataSet();
            OracleConnection conn = (OracleConnection)_dbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
                conn.Open();

            OracleParameter op_yyyy = new OracleParameter("p_yyyy", OracleDbType.Varchar2, activeYear.ToString(), ParameterDirection.Input);
            OracleParameter op_yymm = new OracleParameter("p_yymm", OracleDbType.Varchar2, yymm.ToString(), ParameterDirection.Input);
            OracleParameter op_costcode = new OracleParameter("p_costcode", OracleDbType.Varchar2, costcode.ToString(), ParameterDirection.Input);
            OracleParameter op_simul = new OracleParameter("p_simul", OracleDbType.Varchar2, simul, ParameterDirection.Input);
            OracleParameter op_report_mode = new OracleParameter("p_report_mode", OracleDbType.Varchar2, reportMode, ParameterDirection.Input);
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
                var sql = "BEGIN rap_reports_c.rpt_cha1e_cc(:p_yyyy, :p_yymm, :p_costcode, :p_simul, :p_report_mode, :p_cols, :p_gen, :p_gen_other, :p_alldata, :p_ot, :p_project, :p_future, :p_subcont); END;";
                object[] ora_param = new object[] { op_yyyy, op_yymm, op_costcode, op_simul, op_report_mode, op_cols, op_gen, op_gen_other, op_alldata, op_ot, op_project, op_future, op_subcont };
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
                da.TableMappings.Add("Table2", "alldataTable");
                da.TableMappings.Add("Table3", "otTable");
                da.TableMappings.Add("Table4", "projectTable");
                da.TableMappings.Add("Table5", "futureTable");
                da.TableMappings.Add("Table6", "subcontractTable");
                da.TableMappings.Add("Table7", "genOtherTable");

                da.Fill(ds, "colsTable", cur_cols);
                da.Fill(ds, "genTable", cur_gen);
                da.Fill(ds, "alldataTable", cur_alldata);
                da.Fill(ds, "otTable", cur_ot);
                da.Fill(ds, "projectTable", cur_project);
                da.Fill(ds, "futureTable", cur_future);
                da.Fill(ds, "subcontractTable", cur_subcontract);
                da.Fill(ds, "genOtherTable", cur_gen_other);

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
                op_simul.Dispose();
                op_cols.Dispose();
                op_gen.Dispose();
                op_gen_other.Dispose();
                op_alldata.Dispose();
                op_ot.Dispose();
                op_project.Dispose();
                op_future.Dispose();
                op_subcont.Dispose();
                //_dbContext.Dispose();
            }
        }

        public object GetCha1EGrpData(string yymm, string category, string simul, Int32 mnths, string activeYear)
        {
            OracleConnection conn = (OracleConnection)_dbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
                conn.Open();

            DataSet ds = new DataSet();

            OracleParameter op_yyyy = new OracleParameter("p_yyyy", OracleDbType.Varchar2, activeYear.ToString(), ParameterDirection.Input);
            OracleParameter op_yymm = new OracleParameter("p_yymm", OracleDbType.Varchar2, yymm.ToString(), ParameterDirection.Input);
            OracleParameter op_category = new OracleParameter("p_category", OracleDbType.Varchar2, category.ToString(), ParameterDirection.Input);
            OracleParameter op_simul = new OracleParameter("p_simul", OracleDbType.Varchar2, simul, ParameterDirection.Input);
            OracleParameter op_mnths = new OracleParameter("p_mnths", OracleDbType.Int32, mnths, ParameterDirection.Input);
            OracleParameter op_cols = new OracleParameter("p_cols", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_gen = new OracleParameter("p_gen", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_alldata = new OracleParameter("p_alldata", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_ot = new OracleParameter("p_ot", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_project = new OracleParameter("p_project", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_future = new OracleParameter("p_future", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_subcont = new OracleParameter("p_subcont", OracleDbType.RefCursor, ParameterDirection.Output);

            try
            {
                var sql = "BEGIN rap_reports_c.rpt_cha1e_category(:p_yyyy, :p_yymm,:p_category,:p_simul,:p_mnths,:p_cols,:p_gen,:p_alldata,:p_ot,:p_project,:p_future, :p_subcont); END; ";
                object[] ora_param = new object[] { op_yyyy, op_yymm, op_category, op_simul, op_mnths, op_cols, op_gen, op_alldata, op_ot, op_project, op_future, op_subcont };
                var i_result = _dbContext.Database.ExecuteSqlRaw(sql, ora_param);
                OracleRefCursor cur_cols = (OracleRefCursor)op_cols.Value;
                OracleRefCursor cur_gen = (OracleRefCursor)op_gen.Value;
                OracleRefCursor cur_alldata = (OracleRefCursor)op_alldata.Value;
                OracleRefCursor cur_ot = (OracleRefCursor)op_ot.Value;
                OracleRefCursor cur_project = (OracleRefCursor)op_project.Value;
                OracleRefCursor cur_future = (OracleRefCursor)op_future.Value;
                OracleRefCursor cur_subcontract = (OracleRefCursor)op_subcont.Value;

                OracleDataAdapter da = new OracleDataAdapter();
                da.TableMappings.Add("Table", "colsTable");
                da.TableMappings.Add("Table1", "genTable");
                da.TableMappings.Add("Table2", "alldataTable");
                da.TableMappings.Add("Table3", "otTable");
                da.TableMappings.Add("Table4", "projectTable");
                da.TableMappings.Add("Table5", "futureTable");
                da.TableMappings.Add("Table6", "subcontractTable");

                da.Fill(ds, "colsTable", cur_cols);
                da.Fill(ds, "genTable", cur_gen);
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
                op_category.Dispose();
                op_simul.Dispose();
                op_mnths.Dispose();
                op_cols.Dispose();
                op_gen.Dispose();
                op_alldata.Dispose();
                op_ot.Dispose();
                op_project.Dispose();
                op_future.Dispose();
                op_subcont.Dispose();
                //_dbContext.Dispose();
            }
        }
    }
}