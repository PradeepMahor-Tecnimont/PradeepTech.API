using Microsoft.EntityFrameworkCore;
using Oracle.ManagedDataAccess.Client;
using Oracle.ManagedDataAccess.Types;
using RapReportingApi.RAPEntityModels;
using RapReportingApi.Repositories.Interfaces;
using System;
using System.Data;

namespace RapReportingApi.Repositories
{
    public class DuplTm02Repository : IDuplTm02Repository
    {
        public DuplTm02Repository(RAPDbContext paramDBContext)
        {
            _dbContext = paramDBContext;
        }

        private RAPDbContext _dbContext;

        //TM02
        public object tm02(string costCode, string yymm, string yearmode, string activeyear)
        {
            OracleConnection conn = (OracleConnection)_dbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
                conn.Open();

            OracleDataAdapter da = new OracleDataAdapter();
            OracleCommand cmd = conn.CreateCommand() as OracleCommand;
            DataSet ds = new DataSet();
            DataTable dtTM02_Heading = new DataTable("TM02_Heading");
            DataTable dtTM02_Data = new DataTable("TM02_Data");
            DataTable dtTM02_EmpType_Hrs_Data = new DataTable("TM02_EmpType_Hrs_Data");
            DataTable dtTM02_CostCode = new DataTable("TM02_CostCode");

            OracleParameter op_activeyear = new OracleParameter("p_activeyear", OracleDbType.Varchar2, activeyear.ToString(), ParameterDirection.Input);
            OracleParameter op_yymm = new OracleParameter("p_yymm", OracleDbType.Varchar2, yymm.ToString(), ParameterDirection.Input);
            OracleParameter op_yearmode = new OracleParameter("p_yearmode", OracleDbType.Varchar2, yearmode.ToString(), ParameterDirection.Input);
            OracleParameter op_costcode = new OracleParameter("p_costcode", OracleDbType.Varchar2, costCode.ToString(), ParameterDirection.Input);
            OracleParameter op_costCode = new OracleParameter("p_costcode", OracleDbType.Varchar2, costCode.ToString(), ParameterDirection.Input);
            OracleParameter op_cols = new OracleParameter("p_cols", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_tm02 = new OracleParameter("p_tm02", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_tm02_emptype_hrs = new OracleParameter("p_tm02_emptype_hrs", OracleDbType.RefCursor, ParameterDirection.Output);

            try
            {
                cmd.CommandText = "SELECT c.name ccName, e.name emplName FROM costmast c, emplmast e WHERE c.hod = e.empno AND c.costcode = :p_costcode";
                cmd.Parameters.Add(op_costcode);
                cmd.CommandType = CommandType.Text;
                dtTM02_CostCode.Load(cmd.ExecuteReader());
                ds.Tables.Add(dtTM02_CostCode);

                var ora_sql = "BEGIN rap_reports_b.rpt_dupl_tm02(:p_activeyear, " +
                                                                  " :p_yymm, " +
                                                                  " :p_yearmode, " +
                                                                  " :p_costcode, " +
                                                                  " :p_cols, " +
                                                                  " :p_tm02, " +
                                                                  " :p_tm02_emptype_hrs); END; ";

                object[] ora_param = new object[] { op_activeyear, op_yymm, op_yearmode, op_costCode, op_cols, op_tm02, op_tm02_emptype_hrs };
                var i_result = _dbContext.Database.ExecuteSqlRaw(ora_sql, ora_param);

                da.Fill(dtTM02_Heading, (OracleRefCursor)op_cols.Value);
                ds.Tables.Add(dtTM02_Heading);
                da.Fill(dtTM02_Data, (OracleRefCursor)op_tm02.Value);
                ds.Tables.Add(dtTM02_Data);
                da.Fill(dtTM02_EmpType_Hrs_Data, (OracleRefCursor)op_tm02_emptype_hrs.Value);
                ds.Tables.Add(dtTM02_EmpType_Hrs_Data);

                return ds;
            }
            catch (Exception)
            {
                throw;
            }
            finally
            {
                dtTM02_CostCode.Dispose();
                dtTM02_Heading.Dispose();
                dtTM02_Data.Dispose();
                dtTM02_EmpType_Hrs_Data.Dispose();
                ds.Dispose();
                da.Dispose();
                op_activeyear.Dispose();
                op_yymm.Dispose();
                op_yearmode.Dispose();
                op_costcode.Dispose();
                op_costCode.Dispose();
                op_cols.Dispose();
                op_tm02.Dispose();
                op_tm02_emptype_hrs.Dispose();

                if ((conn != null))
                {
                    if (conn.State == ConnectionState.Open)
                        conn.Close();
                }
            }
        }
    }
}