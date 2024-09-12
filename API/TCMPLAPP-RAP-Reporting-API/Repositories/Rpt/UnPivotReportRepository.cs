using Microsoft.EntityFrameworkCore;
using Oracle.ManagedDataAccess.Client;
using RapReportingApi.Exceptions;
using RapReportingApi.RAPEntityModels;
using RapReportingApi.Repositories.Interfaces.Rpt;
using System;
using System.Data;

namespace RapReportingApi.Repositories.Rpt
{
    public class UnPivotReportRepository : IUnPivotReportRepository
    {
        public UnPivotReportRepository(RAPDbContext paramDBContext)
        {
            _dbContext = paramDBContext;
        }

        private RAPDbContext _dbContext;

        public string ProcessData(string yymm, string RepFor)
        {
            if (RepFor.Trim().Length == 5)
            {
                return ProcessDataForProject(yymm, RepFor);
            }
            if (RepFor.Trim().Length == 4)
            {
                return ProcessDataForCostCenter(yymm, RepFor);
            }
            return null;
        }

        private string ProcessDataForProject(string yymm, string RepFor)
        {
            OracleConnection conn = (OracleConnection)_dbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
                conn.Open();
            var cmd = conn.CreateCommand();
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.CommandText = "rap_unpivot_tmdaily.populate_data_for_project";

            cmd.Parameters.Add("param_yyyymm", OracleDbType.Varchar2).Value = yymm.ToString();
            cmd.Parameters.Add("param_projno", OracleDbType.Varchar2).Value = RepFor.ToString();
            cmd.Parameters.Add("param_success", OracleDbType.Varchar2, 10).Direction = ParameterDirection.Output;
            cmd.Parameters.Add("param_message", OracleDbType.Varchar2, 1000).Direction = ParameterDirection.Output;
            cmd.BindByName = true;

            try
            {
                cmd.ExecuteNonQuery();

                string strSuccess = cmd.Parameters["param_success"].Value.ToString();
                string strMessage = cmd.Parameters["param_message"].Value.ToString();
                if (strSuccess == "OK")
                    return strMessage;
                else
                    throw new RAPDBException(strMessage);
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
                _dbContext.Dispose();
            }
        }

        private string ProcessDataForCostCenter(string yymm, string RepFor)
        {
            DataSet ds = new DataSet();
            OracleConnection conn = (OracleConnection)_dbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
                conn.Open();
            var cmd = conn.CreateCommand();
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.CommandText = "rap_unpivot_tmdaily.populate_data_for_costcenter";

            cmd.Parameters.Add("param_yyyymm", OracleDbType.Varchar2).Value = yymm.ToString();
            cmd.Parameters.Add("param_costcenter", OracleDbType.Varchar2).Value = RepFor.ToString();
            cmd.Parameters.Add("param_success", OracleDbType.Varchar2, 10).Direction = ParameterDirection.Output;
            cmd.Parameters.Add("param_message", OracleDbType.Varchar2, 1000).Direction = ParameterDirection.Output;
            cmd.BindByName = true;

            try
            {
                cmd.ExecuteNonQuery();

                string strSuccess = cmd.Parameters["param_success"].Value.ToString();
                string strMessage = cmd.Parameters["param_message"].Value.ToString();
                if (strSuccess == "OK")
                    return strMessage;
                else
                    throw new RAPDBException(strMessage);
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
                _dbContext.Dispose();
            }
        }

        public object WkJob(string FromDate, string ToDate, string Assign)
        {
            OracleConnection conn = (OracleConnection)_dbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
                conn.Open();
            OracleCommand cmd = conn.CreateCommand() as OracleCommand;
            string ora_sql = string.Empty;
            OracleParameter op_Assign = new OracleParameter("P_Assign", OracleDbType.Varchar2, Assign.ToString(), ParameterDirection.Input);
            OracleParameter op_FromDate = new OracleParameter("P_FromDate", OracleDbType.Varchar2, FromDate, ParameterDirection.Input);
            OracleParameter op_ToDate = new OracleParameter("P_ToDate", OracleDbType.Varchar2, ToDate, ParameterDirection.Input);

            cmd.Parameters.Add(op_Assign);
            cmd.Parameters.Add(op_FromDate);
            cmd.Parameters.Add(op_ToDate);

            DataTable dt = new DataTable();
            ora_sql = @"
            SELECT
                Datewise_Ts.Yymm, Datewise_Ts.Assign, Datewise_Ts.Ts_Date, Datewise_Ts.Projno,
                Datewise_Ts.Hours, Datewise_Ts.Othours,
                (Datewise_Ts.Hours + Datewise_Ts.Othours) Totalhours
            FROM
                Datewise_Ts Datewise_Ts
            WHERE Datewise_Ts.Assign =:P_Assign AND
                Datewise_Ts.Ts_Date BETWEEN TO_DATE (:P_FromDate, 'dd-mm-yy')  AND TO_DATE( :P_ToDate , 'dd-mm-yy')
            ORDER BY
                Datewise_Ts.Assign ASC,
                Datewise_Ts.Projno ASC
                ";
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

        public object WkMJEAM(string FromDate, string ToDate, string Assign)
        {
            OracleConnection conn = (OracleConnection)_dbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
                conn.Open();
            OracleCommand cmd = conn.CreateCommand() as OracleCommand;
            string ora_sql = string.Empty;
            OracleParameter op_Assign = new OracleParameter("P_Assign", OracleDbType.Varchar2, Assign.ToString(), ParameterDirection.Input);

            OracleParameter op_FromDate = new OracleParameter("P_FromDate", OracleDbType.Varchar2, FromDate.ToString(), ParameterDirection.Input);
            OracleParameter op_ToDate = new OracleParameter("P_ToDate", OracleDbType.Varchar2, ToDate.ToString(), ParameterDirection.Input);

            cmd.Parameters.Add(op_Assign);
            cmd.Parameters.Add(op_FromDate);
            cmd.Parameters.Add(op_ToDate);

            DataTable dt = new DataTable();
            ora_sql = @"
            SELECT
                Emplmast.Name,
                Datewise_Ts.Empno, Datewise_Ts.Assign, Datewise_Ts.Projno, Datewise_Ts.Activity, Datewise_Ts.Hours,
                Datewise_Ts.Othours, (Datewise_Ts.Hours + Datewise_Ts.Othours) Totalhours
            FROM
                Emplmast Emplmast,    Datewise_Ts Datewise_Ts
            WHERE
                Emplmast.Empno = Datewise_Ts.Empno  and
                DATEWISE_TS.ASSIGN =:P_Assign AND
                Datewise_Ts.Ts_Date BETWEEN TO_DATE (:P_FromDate, 'dd-mm-yy')  AND TO_DATE( :P_ToDate , 'dd-mm-yy')
            ORDER BY
                Datewise_Ts.Projno ASC,
                Datewise_Ts.Empno ASC
                ";
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

        public object WKMJEM(string FromDate, string ToDate, string Assign)
        {
            OracleConnection conn = (OracleConnection)_dbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
                conn.Open();
            OracleCommand cmd = conn.CreateCommand() as OracleCommand;
            string ora_sql = string.Empty;

            OracleParameter op_Assign = new OracleParameter("P_Assign", OracleDbType.Varchar2, Assign.ToString(), ParameterDirection.Input);
            OracleParameter op_FromDate = new OracleParameter("P_FromDate", OracleDbType.Varchar2, FromDate.ToString(), ParameterDirection.Input);
            OracleParameter op_ToDate = new OracleParameter("P_ToDate", OracleDbType.Varchar2, ToDate.ToString(), ParameterDirection.Input);
            cmd.Parameters.Add(op_Assign);
            cmd.Parameters.Add(op_FromDate);
            cmd.Parameters.Add(op_ToDate);

            DataTable dt = new DataTable();
            ora_sql = @"
            SELECT
                Datewise_Ts.Yymm, Datewise_Ts.Assign, Datewise_Ts.Ts_Date, Datewise_Ts.Projno,
                Datewise_Ts.Hours, Datewise_Ts.Othours,
                (Datewise_Ts.Hours + Datewise_Ts.Othours) Totalhours
            FROM
                Datewise_Ts Datewise_Ts
            WHERE Datewise_Ts.Assign =:P_Assign AND
                Datewise_Ts.Ts_Date BETWEEN TO_DATE (:P_FromDate, 'dd-mm-yy')  AND TO_DATE( :P_ToDate , 'dd-mm-yy')
            ORDER BY
                Datewise_Ts.Assign ASC,
                Datewise_Ts.Projno ASC
                ";
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

        public object WKMJEMP(string FromDate, string ToDate, string ProjNo)
        {
            OracleConnection conn = (OracleConnection)_dbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
                conn.Open();
            OracleCommand cmd = conn.CreateCommand() as OracleCommand;
            string ora_sql = string.Empty;

            OracleParameter op_ProjNo = new OracleParameter("P_ProjNo", OracleDbType.Varchar2, ProjNo.ToString(), ParameterDirection.Input);
            OracleParameter op_FromDate = new OracleParameter("P_FromDate", OracleDbType.Varchar2, FromDate.ToString(), ParameterDirection.Input);
            OracleParameter op_ToDate = new OracleParameter("P_ToDate", OracleDbType.Varchar2, ToDate.ToString(), ParameterDirection.Input);

            cmd.Parameters.Add(op_ProjNo);
            cmd.Parameters.Add(op_FromDate);
            cmd.Parameters.Add(op_ToDate);

            DataTable dt = new DataTable();
            ora_sql = @"
            SELECT
                Datewise_Ts.Yymm, Datewise_Ts.Empno, Datewise_Ts.Assign, Datewise_Ts.Projno,   Emplmast.Name,
                Datewise_Ts.Hours, Datewise_Ts.Othours,(Datewise_Ts.Hours + Datewise_Ts.Othours) Totalhours
            FROM
                Datewise_Ts Datewise_Ts,     Emplmast Emplmast
            WHERE
                Datewise_Ts.Empno = Emplmast.Empno
                AND Datewise_Ts.Projno =:P_ProjNo AND
                Datewise_Ts.Ts_Date BETWEEN TO_DATE (:P_FromDate, 'dd-mm-yy')  AND TO_DATE( :P_ToDate , 'dd-mm-yy')
            ORDER BY
                Datewise_Ts.Projno ASC,
                Datewise_Ts.Assign ASC,
                Datewise_Ts.Empno ASC
                ";
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

        public object GetData4CostCenter(string pYYYYMM, string pAssign)
        {
            OracleConnection conn = (OracleConnection)_dbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
                conn.Open();
            OracleCommand cmd = conn.CreateCommand() as OracleCommand;
            string ora_sql = string.Empty;
            OracleParameter opAssign = new OracleParameter("param_costcenter", OracleDbType.Varchar2, pAssign.ToString(), ParameterDirection.Input);
            OracleParameter opYYYYMM = new OracleParameter("param_yyyymm", OracleDbType.Varchar2, pYYYYMM, ParameterDirection.Input);
            OracleDataAdapter oADP = new OracleDataAdapter();

            cmd.Parameters.Add(opAssign);
            cmd.Parameters.Add(opYYYYMM);

            DataTable dt = new DataTable();
            ora_sql = @"
                        With emp As (
                            Select empno, name, grade
                            From emplmast Where
                                empno In (
                                    Select
                                        empno From rap_tmdaily_unpivot
                                    Where
                                        process_keyid = rap_unpivot_tmdaily.get_latest_keyid4cc(:param_costcenter,:param_yyyymm )
                                )
                        )
                        Select
                            a.process_keyid, a.yymm, a.empno, a.parent,
                            a.assign, a.projno, a.wpcode, a.activity,
                            a.dd,a.hrs, a.hrs_type,  a.ts_date,
                            b.name, Case When a.dd Is Null Then Null Else b.grade End as grade, Case When a.dd Is Null Then Null Else 'Week_' || CEIL(dd/7) End as week
                        From
                            rap_tmdaily_unpivot    a,
                            emp                    b
                        Where
                            a.empno = b.empno
                            And process_keyid = rap_unpivot_tmdaily.get_latest_keyid4cc(:param_costcenter,:param_yyyymm )
                        ";
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

        public object GetData4Project(string pYYYYMM, string pProject)
        {
            OracleConnection conn = (OracleConnection)_dbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
                conn.Open();
            OracleCommand cmd = conn.CreateCommand() as OracleCommand;
            string ora_sql = string.Empty;
            OracleParameter opAssign = new OracleParameter("param_project", OracleDbType.Varchar2, pProject.ToString(), ParameterDirection.Input);
            OracleParameter opYYYYMM = new OracleParameter("param_yyyymm", OracleDbType.Varchar2, pYYYYMM, ParameterDirection.Input);

            cmd.Parameters.Add(opAssign);
            cmd.Parameters.Add(opYYYYMM);

            DataTable dt = new DataTable();
            ora_sql = @"
                        With emp As (
                            Select empno, name, grade
                            From emplmast Where
                                empno In (
                                    Select
                                        empno From rap_tmdaily_unpivot
                                    Where
                                        process_keyid = rap_unpivot_tmdaily.get_latest_keyid4proj(:param_project,:param_yyyymm )
                                )
                        )
                        Select
                            a.process_keyid, a.yymm, a.empno, a.parent,
                            a.assign, a.projno, a.wpcode, a.activity,
                            a.dd, a.hrs, a.hrs_type, a.ts_date,
                            b.name, Case When a.dd Is Null Then Null Else b.grade End as grade, Case When a.dd Is Null Then Null Else 'Week_' || CEIL(dd/7) End as week
                        From
                            rap_tmdaily_unpivot   a,
                            emp                    b
                        Where
                            a.empno = b.empno
                            And process_keyid = rap_unpivot_tmdaily.get_latest_keyid4proj(:param_project,:param_yyyymm )
                        ";
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

        public object GetUnpivot()
        {
            throw new NotImplementedException();
        }

        public object GetProcessStatusForCostCenter(string pYYYYMM, string pCostCenter)
        {
            OracleConnection conn = (OracleConnection)_dbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
                conn.Open();
            var cmd = conn.CreateCommand();
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.CommandText = "rap_unpivot_tmdaily.get_process_status_4_cc";

            cmd.Parameters.Add("param_yyyymm", OracleDbType.Varchar2).Value = pYYYYMM.ToString();
            cmd.Parameters.Add("param_costcenter", OracleDbType.Varchar2).Value = pCostCenter.ToString();

            cmd.Parameters.Add("param_can_download", OracleDbType.Varchar2, 10).Direction = ParameterDirection.Output;
            cmd.Parameters.Add("param_can_init_process", OracleDbType.Varchar2, 10).Direction = ParameterDirection.Output;
            cmd.Parameters.Add("param_success", OracleDbType.Varchar2, 10).Direction = ParameterDirection.Output;
            cmd.Parameters.Add("param_message", OracleDbType.Varchar2, 1000).Direction = ParameterDirection.Output;
            cmd.BindByName = true;

            try
            {
                cmd.ExecuteNonQuery();

                string strSuccess = cmd.Parameters["param_success"].Value.ToString();
                string strCanDownload = cmd.Parameters["param_can_download"].Value.ToString();
                string strCanInitiateProcess = cmd.Parameters["param_can_init_process"].Value.ToString();
                string strMessage = cmd.Parameters["param_message"].Value.ToString();
                if (strSuccess == "OK")
                    return new { CanDownload = strCanDownload, CanInitiateProcess = strCanInitiateProcess, Message = strMessage };
                else
                    throw new RAPDBException(strMessage);
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
                _dbContext.Dispose();
            }
        }

        public object GetProcessStatusForProject(string pYYYYMM, string pProject)
        {
            OracleConnection conn = (OracleConnection)_dbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
                conn.Open();
            var cmd = conn.CreateCommand();
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.CommandText = "rap_unpivot_tmdaily.get_process_status_4_proj";

            cmd.Parameters.Add("param_yyyymm", OracleDbType.Varchar2).Value = pYYYYMM.ToString();
            cmd.Parameters.Add("param_project", OracleDbType.Varchar2).Value = pProject.ToString();
            cmd.Parameters.Add("param_can_download", OracleDbType.Varchar2, 10).Direction = ParameterDirection.Output;
            cmd.Parameters.Add("param_can_init_process", OracleDbType.Varchar2, 10).Direction = ParameterDirection.Output;
            cmd.Parameters.Add("param_success", OracleDbType.Varchar2, 10).Direction = ParameterDirection.Output;
            cmd.Parameters.Add("param_message", OracleDbType.Varchar2, 1000).Direction = ParameterDirection.Output;
            cmd.BindByName = true;

            try
            {
                cmd.ExecuteNonQuery();

                string strSuccess = cmd.Parameters["param_success"].Value.ToString();
                string strCanDownload = cmd.Parameters["param_can_download"].Value.ToString();
                string strCanInitiateProcess = cmd.Parameters["param_can_init_process"].Value.ToString();
                string strMessage = cmd.Parameters["param_message"].Value.ToString();
                if (strSuccess == "OK")
                    return new { CanDownload = strCanDownload, CanInitiateProcess = strCanInitiateProcess, Message = strMessage };
                else
                    throw new RAPDBException(strMessage);
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
                _dbContext.Dispose();
            }
        }

        public object GetProcessStatus(string yymm, string RepFor)
        {
            if (RepFor.Trim().Length == 5)
            {
                return GetProcessStatusForProject(yymm, RepFor);
            }
            if (RepFor.Trim().Length == 4)
            {
                return GetProcessStatusForCostCenter(yymm, RepFor);
            }
            return null;
        }
    }
}