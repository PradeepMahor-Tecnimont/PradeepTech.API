using Microsoft.EntityFrameworkCore;
using Oracle.ManagedDataAccess.Client;
using RapReportingApi.RAPEntityModels;
using RapReportingApi.Repositories.Interfaces.User;
using System;
using System.Data;

namespace RapReportingApi.Repositories.User
{
    public class UserRepository : IUserRepository
    {
        public UserRepository(RAPDbContext paramDBContext)
        {
            _dbContext = paramDBContext;
        }

        private RAPDbContext _dbContext;

        public object getProcessingMonth()
        {
            OracleConnection conn = (OracleConnection)_dbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
                conn.Open();
            OracleCommand cmd = conn.CreateCommand() as OracleCommand;
            string ora_sql = string.Empty;
            System.Data.DataTable dt = new System.Data.DataTable();
            ora_sql = @"
                    Select
                        pros_month
                    From
                        tsconfig";

            cmd.CommandText = ora_sql;
            cmd.CommandType = CommandType.Text;
            try
            {
                dt.Load(cmd.ExecuteReader());
                return dt.Rows[0][0].ToString();
            }
            catch (Exception)
            {
                throw;
            }
            finally
            {
                dt.Dispose();
                cmd.Dispose();
                if ((conn != null))
                {
                    if (conn.State == ConnectionState.Open)
                        conn.Close();
                }
            }
        }

        public object getStartMonth(string yearmode)
        {
            try
            {
                string startMonth = string.Empty;
                string processingMonth = getProcessingMonth().ToString();
                Int32 yyyy = Convert.ToInt32(processingMonth.Substring(0, 4));
                Int32 mm = Convert.ToInt32(processingMonth.Substring(4, 2));
                if (yearmode == "J")
                {
                    startMonth = yyyy.ToString() + "01";
                }
                else
                {
                    if (mm >= 1 && mm <= 3)
                    {
                        startMonth = Convert.ToString(yyyy - 1) + "04";
                    }
                    else
                    {
                        startMonth = yyyy.ToString() + "04";
                    }
                }
                return startMonth;
            }
            catch (Exception ex)
            {
                return new { Result = "ERROR", Message = ex.Message };
            }
        }

    }
}