using Microsoft.EntityFrameworkCore;
using Oracle.ManagedDataAccess.Client;
using RapReportingApi.RAPEntityModels;
using RapReportingApi.Repositories.Interfaces.Rpt;
using System;
using System.Data;

namespace RapReportingApi.Repositories.Rpt
{
    public class MasterRepository : IMasterRepository
    {
        public MasterRepository(RAPDbContext paramDBContext)
        {
            _dbContext = paramDBContext;
        }

        private RAPDbContext _dbContext;

        public object LISTACT(string CostCode)
        {
            OracleConnection conn = (OracleConnection)_dbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
                conn.Open();
            OracleCommand cmd = conn.CreateCommand() as OracleCommand;
            string ora_sql = string.Empty;
            DataTable dt = new DataTable();
            OracleParameter op_CostCode = new OracleParameter("p_CostCode", OracleDbType.Varchar2, CostCode.ToString(), ParameterDirection.Input);
            cmd.Parameters.Add(op_CostCode);
            ora_sql = @"  SELECT
                    Costmast.Costcode, Costmast.Name,
                    Act_Mast.Activity, Act_Mast.Name Act_Mast_name, Act_Mast.Tlpcode, Act_Mast.Active
                FROM
                    Costmast Costmast,
                     Act_Mast Act_Mast
                WHERE
                    Costmast.Costcode = Act_Mast.Costcode
                    and Act_Mast.Costcode = :p_CostCode
                ORDER BY
                    Costmast.Costcode ASC ";
            cmd.CommandText = ora_sql;
            cmd.CommandType = CommandType.Text;
            try
            {
                dt.Load(cmd.ExecuteReader());
                return dt;
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
                _dbContext.Dispose();
            }
        }

        public object ListActProj(string Projno)
        {
            OracleConnection conn = (OracleConnection)_dbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
                conn.Open();
            OracleCommand cmd = conn.CreateCommand() as OracleCommand;
            string ora_sql = string.Empty;
            DataTable dt = new DataTable();
            OracleParameter op_Projno = new OracleParameter("p_Projno", OracleDbType.Varchar2, Projno.ToString(), ParameterDirection.Input);
            cmd.Parameters.Add(op_Projno);

            ora_sql = @" SELECT
                    Projmast.PROJNO, Projmast.NAME ProjName, Projmast.SDATE, Projmast.ABBR, Projmast.ACTIVE, Projmast.TCM_JOBS, Projmast.TCMNO, Projmast.CO,
                    Clntmast.NAME,
                    Projmast_1.REVCDATE
                FROM
                    PROJMAST Projmast,      CLNTMAST Clntmast,     PROJMAST Projmast_1
                WHERE
                    Projmast.CLIENT = Clntmast.CLIENT AND
                    Projmast.PROJNO = Projmast_1.PROJNO AND
                    Projmast.ACTIVE = 1
                    and  SUBSTR(Projmast.PROJNO,0,5) = SUBSTR(:p_Projno,0,5)

                ORDER BY
                    Projmast.CO ASC,
                    Projmast.PROJNO ASC  ";
            cmd.CommandText = ora_sql;
            cmd.CommandType = CommandType.Text;
            try
            {
                dt.Load(cmd.ExecuteReader());
                return dt;
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
                _dbContext.Dispose();
            }
        }

        public object LISTEMP(string CostCode)
        {
            OracleConnection conn = (OracleConnection)_dbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
                conn.Open();
            OracleCommand cmd = conn.CreateCommand() as OracleCommand;
            string ora_sql = string.Empty;
            DataTable dt = new DataTable();
            OracleParameter op_CostCode = new OracleParameter("p_CostCode", OracleDbType.Varchar2, CostCode.ToString(), ParameterDirection.Input);
            cmd.Parameters.Add(op_CostCode);
            ora_sql = @" SELECT
                    Costmast.Costcode, Costmast.Name CostName,
                    Emplmast.Empno, Emplmast.Name EmpName,
                    Emplmast1.Empno EmpHODNo, Emplmast1.Name EmpHODName
                FROM
                    Emplmast Emplmast,  Costmast Costmast,      Emplmast Emplmast1
                WHERE
                    Emplmast.Assign = Costmast.Costcode AND      Costmast.Costcode = Emplmast.Assign AND
                    Costmast.Hod = Emplmast1.Empno AND      Emplmast.Status > 0
                    and Costmast.Costcode = :p_CostCode
                ORDER BY
                    Costmast.Costcode ASC,
                    Emplmast1.Empno ASC,
                    Emplmast.Empno ASC ";
            cmd.CommandText = ora_sql;
            cmd.CommandType = CommandType.Text;
            try
            {
                dt.Load(cmd.ExecuteReader());
                return dt;
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
                _dbContext.Dispose();
            }
        }

        public object LISTEMP_Parent(string CostCode)
        {
            OracleConnection conn = (OracleConnection)_dbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
                conn.Open();
            OracleCommand cmd = conn.CreateCommand() as OracleCommand;
            string ora_sql = string.Empty;
            DataTable dt = new DataTable();
            OracleParameter op_CostCode = new OracleParameter("p_CostCode", OracleDbType.Varchar2, CostCode.ToString(), ParameterDirection.Input);
            cmd.Parameters.Add(op_CostCode);
            ora_sql = @" select Emplmast.Empno,
                       Emplmast.Name EmpName,
                       Emplmast.Parent,
                       (select distinct Name from Costmast where Costcode = Emplmast.Parent) Parent_name,
                       Emplmast.ASSIGN,
                       (
                          select distinct Name
                            from Costmast
                           where Costcode = Emplmast.ASSIGN
                             and Emplmast.Parent != Emplmast.ASSIGN
                       ) ASSIGN_name,
                       Emplmast1.Empno EmpHODNo,
                       Emplmast1.Name EmpHODName
                  from Emplmast Emplmast, Costmast Costmast, Emplmast Emplmast1
                 where Costmast.Hod = Emplmast1.Empno
                   and Emplmast.Status > 0
                   and Costmast.Costcode = :p_CostCode
                   and Emplmast.Parent = Costmast.Costcode
                 order by Costmast.Costcode asc,
                       Emplmast1.Empno asc,
                       Emplmast.Empno asc";
            cmd.CommandText = ora_sql;
            cmd.CommandType = CommandType.Text;
            try
            {
                dt.Load(cmd.ExecuteReader());
                return dt;
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
                _dbContext.Dispose();
            }
        }

        public object PROJACT(string CostCode)
        {
            OracleConnection conn = (OracleConnection)_dbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
                conn.Open();
            OracleCommand cmd = conn.CreateCommand() as OracleCommand;
            string ora_sql = string.Empty;
            DataTable dt = new DataTable();
            OracleParameter op_CostCode = new OracleParameter("p_CostCode", OracleDbType.Varchar2, CostCode.ToString(), ParameterDirection.Input);
            cmd.Parameters.Add(op_CostCode);
            ora_sql = @"  SELECT
                    Projact_Mast.Projno, Projact_Mast.Costcode, Projact_Mast.Activity, Projact_Mast.Budghrs,
                    Projact_Mast.Noofdocs
                FROM
                    Projact_Mast Projact_Mast
                    where  Projact_Mast.Costcode = :p_CostCode
                ORDER BY
                    Projact_Mast.Projno ASC ";
            cmd.CommandText = ora_sql;
            cmd.CommandType = CommandType.Text;
            try
            {
                dt.Load(cmd.ExecuteReader());
                return dt;
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
                _dbContext.Dispose();
            }
        }

        public object TLP_Codes_Master()
        {
            OracleConnection conn = (OracleConnection)_dbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
                conn.Open();
            OracleCommand cmd = conn.CreateCommand() as OracleCommand;
            string ora_sql = string.Empty;
            DataTable dt = new DataTable();

            ora_sql = @"  SELECT
                        Tlp_Mast.Costcode, Tlp_Mast.Tlpcode, Tlp_Mast.Name,
                          Costmast.Name CostName
                    FROM
                        Tlp_Mast,       Costmast
                    WHERE
                        Tlp_Mast.Costcode = Costmast.Costcode
                    ORDER BY
                        Costmast.Costcode ASC,
                        Costmast.Name ASC";
            cmd.CommandText = ora_sql;
            cmd.CommandType = CommandType.Text;
            try
            {
                dt.Load(cmd.ExecuteReader());
                return dt;
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
                _dbContext.Dispose();
            }
        }
    }
}