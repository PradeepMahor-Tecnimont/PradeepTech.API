using Microsoft.EntityFrameworkCore;
using Oracle.ManagedDataAccess.Client;
using Oracle.ManagedDataAccess.Types;
using RapReportingApi.RAPEntityModels;
using RapReportingApi.Repositories.Interfaces.Rpt;
using RapReportingApi.Repositories.Interfaces.User;
using System;
using System.Data;

namespace RapReportingApi.Repositories.Rpt
{
    public class AfterPostProjRepository : IAfterPostProjRepository

    {
        private readonly RAPDbContext rapDbContext;
        private readonly IUserRepository userRepository;
        private readonly string processingMonth = string.Empty;

        public AfterPostProjRepository(RAPDbContext _rapDbContext, IUserRepository _userRepository)
        {
            rapDbContext = _rapDbContext;
            userRepository = _userRepository;
            processingMonth = userRepository.getProcessingMonth().ToString().Trim();
        }

        public object PRJ_CC_ACT_BUDG(string projno)
        {
            OracleConnection conn = (OracleConnection)rapDbContext.Database.GetDbConnection();

            if (conn == null || conn.State == ConnectionState.Closed)
            {
                conn.Open();
            }

            OracleCommand cmd = conn.CreateCommand();
            DataTable dt = new();
            OracleParameter op_projno = new("p_projno", OracleDbType.Varchar2, projno.ToString(), ParameterDirection.Input);
            OracleParameter op_yymm = new("p_yymm", OracleDbType.Int32, int.Parse(processingMonth), ParameterDirection.Input);

            _ = cmd.Parameters.Add(op_projno);

            string ora_sql = $@"
                 select a.projno,
                    a.name projname,
                    a.costcode,
                    a.costname,
                    nvl(a.revised,0) as revised,
                    nvl(a.tothrs,0) as tothrs,
                    nvl((a.revised - a.tothrs),0) budgetbalance,
                    (
                        select nvl(sum(b.hours),0)
                        from prjcmast b
                        where b.costcode = a.costcode
                            and substr(a.projno, 0, 5) = substr(b.projno, 0, 5)
                            and to_number(b.yymm) >= {processingMonth}
                    ) As estimate_hrs,
                    (
                        nvl(a.tothrs,0) + (
                            select nvl(sum(b.hours),0)
                            from prjcmast b
                            where b.costcode = a.costcode
                                and substr(a.projno, 0, 5) = substr(b.projno, 0, 5)
                                and to_number(b.yymm) >= {processingMonth}
                        )
                    ) As curr_estimate_hrs
                from  (
                            Select
                                a.""PROJNO"", a.""COSTCODE"", a.""TOTHRS"", nvl(b.revised, 0) As ""REVISED"", c.name costname, d.name
                            From
                                proj_costcode a, budgmast b, costmast c, projmast d
                            Where
                                a.costcode     = c.costcode
                                And a.projno   = d.projno
                                And a.projno   = b.projno(+)
                                And a.costcode = b.costcode(+)
                        ) a
                where substr(a.projno, 0, 5) = substr(:p_projno, 0, 5)
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
                if (conn != null)
                {
                    if (conn.State == ConnectionState.Open)
                    {
                        conn.Close();
                    }
                }

                op_projno.Dispose();
            }
        }

        public object Proj_ACC_ACT_BUDG(string projno)
        {
            OracleConnection conn = (OracleConnection)rapDbContext.Database.GetDbConnection();
            //TIMECURR.
            //using (var rapDbContext = new RAPDbContext())
            //{
            //    OracleConnection conn = (OracleConnection)rapDbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
            {
                conn.Open();
            }

            OracleCommand cmd = conn.CreateCommand();
            DataTable dt = new();
            OracleParameter op_projno = new("p_projno", OracleDbType.Varchar2, projno.ToString(), ParameterDirection.Input);
            // OracleParameter op_yymm = new OracleParameter("p_yymm", OracleDbType.Varchar2,
            // yymm.ToString(), ParameterDirection.Input);
            _ = cmd.Parameters.Add(op_projno);
            // cmd.Parameters.Add(op_yymm);

            string ora_sql = @"
                  SELECT
                    PRJ_CC_ACT_BUDG.PROJNO, PRJ_CC_ACT_BUDG.COSTCODE, PRJ_CC_ACT_BUDG.TOTHRS,
                    PRJ_CC_ACT_BUDG.REVISED, PRJ_CC_ACT_BUDG.COSTNAME, PRJ_CC_ACT_BUDG.NAME Projname ,
                (  PRJ_CC_ACT_BUDG.REVISED - PRJ_CC_ACT_BUDG.TOTHRS     ) BudgetBalance
                FROM
                    PRJ_CC_ACT_BUDG PRJ_CC_ACT_BUDG
                where
                 SUBSTR(PRJ_CC_ACT_BUDG.PROJNO,0,5)= SUBSTR(:p_projno,0,5)
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
                if (conn != null)
                {
                    if (conn.State == ConnectionState.Open)
                    {
                        conn.Close();
                    }
                }
                // op_yymm.Dispose();
                op_projno.Dispose();
            }
            //}
        }

        public object Proj_CostOT_combine(string projno)
        {
            //using (var rapDbContext = new RAPDbContext())
            //{
            OracleConnection conn = (OracleConnection)rapDbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
            {
                conn.Open();
            }

            OracleCommand cmd = conn.CreateCommand();
            DataTable dt = new();
            OracleParameter op_projno = new("p_projno", OracleDbType.Varchar2, projno.ToString(), ParameterDirection.Input);
            // OracleParameter op_yymm = new OracleParameter("p_yymm", OracleDbType.Varchar2,
            // yymm.ToString(), ParameterDirection.Input);
            _ = cmd.Parameters.Add(op_projno);
            // cmd.Parameters.Add(op_yymm);

            string ora_sql = @"
                 SELECT
                    TIMETRAN_COMBINE.YYMM, TIMETRAN_COMBINE.COSTCODE, TIMETRAN_COMBINE.PROJNO, TIMETRAN_COMBINE.HOURS,
                    TIMETRAN_COMBINE.OTHOURS,
                    COSTMAST.ABBR ,  (TIMETRAN_COMBINE.hours +     TIMETRAN_COMBINE.othours) TOTALHOURS
                FROM
                    TIMETRAN_COMBINE TIMETRAN_COMBINE,
                    COSTMAST COSTMAST
                WHERE
                    TIMETRAN_COMBINE.COSTCODE = COSTMAST.COSTCODE
                    and
                    SUBSTR(TIMETRAN_COMBINE.PROJNO,0,5)= SUBSTR(:p_projno,0,5)
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
                if (conn != null)
                {
                    if (conn.State == ConnectionState.Open)
                    {
                        conn.Close();
                    }
                }
                // op_yymm.Dispose();
                op_projno.Dispose();
            }
            // }
        }

        public object Proj_Cost_combine(string projno)
        {
            //using (var rapDbContext = new RAPDbContext())
            //{
            OracleConnection conn = (OracleConnection)rapDbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
            {
                conn.Open();
            }

            OracleCommand cmd = conn.CreateCommand();
            DataTable dt = new();
            OracleParameter op_projno = new("p_projno", OracleDbType.Varchar2, projno.ToString(), ParameterDirection.Input);
            // OracleParameter op_yymm = new OracleParameter("p_yymm", OracleDbType.Varchar2,
            // yymm.ToString(), ParameterDirection.Input);
            _ = cmd.Parameters.Add(op_projno);
            // cmd.Parameters.Add(op_yymm);

            string ora_sql = @"
                 SELECT
                         TIMETRAN_COMBINE.YYMM, TIMETRAN_COMBINE.COSTCODE, TIMETRAN_COMBINE.PROJNO, TIMETRAN_COMBINE.HOURS, TIMETRAN_COMBINE.OTHOURS,
                        COSTMAST.ABBR ,    (timetran_combine.hours +     timetran_combine.othours) TOTALHOURS
                    FROM
                        TIMETRAN_COMBINE TIMETRAN_COMBINE,
                        COSTMAST COSTMAST
                    WHERE
                        TIMETRAN_COMBINE.COSTCODE = COSTMAST.COSTCODE

                        and
                        SUBSTR(TIMETRAN_COMBINE.PROJNO,0,5)= SUBSTR(:p_projno,0,5)
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
                if (conn != null)
                {
                    if (conn.State == ConnectionState.Open)
                    {
                        conn.Close();
                    }
                }
                // op_yymm.Dispose();
                op_projno.Dispose();
            }
            // }
        }

        public object Proj_GRADE(string projno, string yymm)
        {
            //using (var rapDbContext = new RAPDbContext())
            //{
            OracleConnection conn = (OracleConnection)rapDbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
            {
                conn.Open();
            }

            OracleCommand cmd = conn.CreateCommand();
            DataTable dt = new();
            OracleParameter op_projno = new("p_projno", OracleDbType.Varchar2, projno.ToString(), ParameterDirection.Input);
            OracleParameter op_yymm = new("p_yymm", OracleDbType.Varchar2, yymm.ToString(), ParameterDirection.Input);
            _ = cmd.Parameters.Add(op_projno);
            _ = cmd.Parameters.Add(op_yymm);

            string ora_sql = @"
                        SELECT
                            TIMETRAN.YYMM, TIMETRAN.EMPNO, TIMETRAN.COSTCODE, TIMETRAN.PROJNO, TIMETRAN.WPCODE,
                            TIMETRAN.ACTIVITY, TIMETRAN.GRP , TIMETRAN.HOURS, TIMETRAN.OTHOURS,
                            EMPLMAST.NAME EmpName , EMPLMAST.GRADE , (TIMETRAN.HOURS + TIMETRAN.OTHOURS) TotalHours
                        FROM
                            TIMETRAN TIMETRAN,      EMPLMAST EMPLMAST
                        WHERE
                            TIMETRAN.EMPNO = EMPLMAST.EMPNO
                            and SUBSTR(TIMETRAN.PROJNO,0,5) = SUBSTR(:p_projno,0,5)  and TIMETRAN.YYMM = :p_yymm
                        ORDER BY
                            emplmast.Grade  , TIMETRAN.empno ASC
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
                if (conn != null)
                {
                    if (conn.State == ConnectionState.Open)
                    {
                        conn.Close();
                    }
                }
                op_yymm.Dispose();
                op_projno.Dispose();
            }
            // }
        }

        public object Proj_hrs_OtBreak(string projno, string yymm)
        {
            //ProjNo 5 Digits
            //projno = "0900409";
            //yymm = "202001";
            //using (var rapDbContext = new RAPDbContext())
            //{
            OracleConnection conn = (OracleConnection)rapDbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
            {
                conn.Open();
            }

            OracleCommand cmd = conn.CreateCommand();
            DataTable dt = new();
            OracleParameter op_projno = new("p_projno", OracleDbType.Varchar2, projno.ToString(), ParameterDirection.Input);
            OracleParameter op_yymm = new("p_yymm", OracleDbType.Varchar2, yymm.ToString(), ParameterDirection.Input);
            _ = cmd.Parameters.Add(op_projno);
            _ = cmd.Parameters.Add(op_yymm);

            string ora_sql = @"
                       SELECT
                        PROJHRS_OTBREAKUP.PROJNO, PROJHRS_OTBREAKUP.YYMM, PROJHRS_OTBREAKUP.COSTCODE,
                        PROJHRS_OTBREAKUP.EMPNO, PROJHRS_OTBREAKUP.NAME Empname, PROJHRS_OTBREAKUP.HOURS, PROJHRS_OTBREAKUP.OTHOURS
                    FROM
                        PROJHRS_OTBREAKUP PROJHRS_OTBREAKUP
                        where
                         SUBSTR(PROJHRS_OTBREAKUP.PROJNO,0,5)=SUBSTR(:p_projno,0,5) and PROJHRS_OTBREAKUP.YYMM >= :p_yymm
                    ORDER BY
                        PROJHRS_OTBREAKUP.PROJNO ASC,
                        PROJHRS_OTBREAKUP.YYMM ASC,
                        PROJHRS_OTBREAKUP.COSTCODE ASC,
                        PROJHRS_OTBREAKUP.EMPNO ASC

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
                if (conn != null)
                {
                    if (conn.State == ConnectionState.Open)
                    {
                        conn.Close();
                    }
                }
                op_yymm.Dispose();
                op_projno.Dispose();
            }
            // }
        }

        public object Proj_hrs_OtCrossTab(string projno, string yymm)
        {
            OracleConnection conn = (OracleConnection)rapDbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
            {
                conn.Open();
            }

            OracleCommand cmd = conn.CreateCommand();
            DataTable dt = new();
            OracleParameter op_projno = new("p_projno", OracleDbType.Varchar2, projno.ToString(), ParameterDirection.Input);
            OracleParameter op_yymm = new("p_yymm", OracleDbType.Varchar2, yymm.ToString(), ParameterDirection.Input);
            _ = cmd.Parameters.Add(op_projno);
            _ = cmd.Parameters.Add(op_yymm);

            string ora_sql = @"
                SELECT
                    projhrs_otbreakup.projno,
                    projhrs_otbreakup.yymm,
                    projhrs_otbreakup.costcode,
                    projhrs_otbreakup.empno ||' '||
                    projhrs_otbreakup.name Emp,
                    projhrs_otbreakup.hours,
                    projhrs_otbreakup.othours ,
                   (  projhrs_otbreakup.hours +
                    projhrs_otbreakup.othours ) TOTALHOURS
                FROM
                    projhrs_otbreakup projhrs_otbreakup
                     where
                        SUBSTR(PROJHRS_OTBREAKUP.PROJNO,0,5)=SUBSTR(:p_projno,0,5) and PROJHRS_OTBREAKUP.YYMM >= :p_yymm

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
                if (conn != null)
                {
                    if (conn.State == ConnectionState.Open)
                    {
                        conn.Close();
                    }
                }
                op_yymm.Dispose();
                op_projno.Dispose();
            }
        }

        public object Proj_PlanRep1(string projno, string yymm)
        {
            //ProjNo 5 Digits
            //projno = "09050";
            //yymm = "201910";

            OracleConnection conn = (OracleConnection)rapDbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
            {
                conn.Open();
            }

            OracleCommand cmd = conn.CreateCommand();
            DataTable dt = new();
            OracleParameter op_projno = new("p_projno", OracleDbType.Varchar2, projno.ToString(), ParameterDirection.Input);
            OracleParameter op_yymm = new("p_yymm", OracleDbType.Varchar2, yymm.ToString(), ParameterDirection.Input);
            _ = cmd.Parameters.Add(op_projno);
            _ = cmd.Parameters.Add(op_yymm);

            string ora_sql = @"
                    SELECT
                            PROJACTDET.PROJNO, PROJACTDET.PROJNAME, PROJACTDET.YYMM, PROJACTDET.COSTCODE, PROJACTDET.COSTNAME, PROJACTDET.TLPCODE, PROJACTDET.TLPNAME, PROJACTDET.TOTHOURS TotalHours
                        FROM
                            PROJACTDET PROJACTDET
                        where
                            SUBSTR(PROJACTDET.PROJNO,0,5)=SUBSTR(:p_projno,0,5) and PROJACTDET.YYMM >= :p_yymm
                        ORDER BY
                            PROJACTDET.PROJNO ASC,
                            PROJACTDET.YYMM ASC,
                            PROJACTDET.COSTCODE ASC,
                            PROJACTDET.TLPCODE ASC
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
                if (conn != null)
                {
                    if (conn.State == ConnectionState.Open)
                    {
                        conn.Close();
                    }
                }
                op_yymm.Dispose();
                op_projno.Dispose();
            }
        }

        public object Proj_PlanRep2(string projno, string yymm)
        {
            OracleConnection conn = (OracleConnection)rapDbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
            {
                conn.Open();
            }

            OracleCommand cmd = conn.CreateCommand();
            DataTable dt = new();
            OracleParameter op_projno = new("p_projno", OracleDbType.Varchar2, projno.ToString(), ParameterDirection.Input);
            OracleParameter op_yymm = new("p_yymm", OracleDbType.Varchar2, yymm.ToString(), ParameterDirection.Input);
            _ = cmd.Parameters.Add(op_projno);
            _ = cmd.Parameters.Add(op_yymm);

            string ora_sql = @"
                   SELECT
                    TIMETRAN.YYMM, TIMETRAN.COSTCODE, TIMETRAN.PROJNO, TIMETRAN.ACTIVITY, TIMETRAN.HOURS, TIMETRAN.OTHOURS ,(TIMETRAN.HOURS + TIMETRAN.OTHOURS) TotalHours
                FROM
                    TIMETRAN TIMETRAN
                    where
                 SUBSTR(TIMETRAN.PROJNO,0,5)=SUBSTR(:p_projno,0,5) and TIMETRAN.YYMM >= :p_yymm
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
                if (conn != null)
                {
                    if (conn.State == ConnectionState.Open)
                    {
                        conn.Close();
                    }
                }
                op_yymm.Dispose();
                op_projno.Dispose();
            }
        }

        public object Proj_WorkPosition_Combine(string projno, string yymm)
        {//TIMECURR
            OracleConnection conn = (OracleConnection)rapDbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
            {
                conn.Open();
            }

            OracleCommand cmd = conn.CreateCommand();
            DataTable dt = new();
            OracleParameter op_projno = new("p_projno", OracleDbType.Varchar2, projno.ToString(), ParameterDirection.Input);
            //OracleParameter op_yymm = new OracleParameter("p_yymm", OracleDbType.Varchar2, yymm.ToString(), ParameterDirection.Input);
            _ = cmd.Parameters.Add(op_projno);
            //cmd.Parameters.Add(op_yymm);

            string ora_sql = @"
                 SELECT
                    TIMETRAN_COMBINE.YYMM, TIMETRAN_COMBINE.EMPNO, EMPLMAST.NAME EmpName, EMPLMAST.EMPTYPE EmpType, TIMETRAN_COMBINE.COSTCODE,
                TIMETRAN_COMBINE.PROJNO, TIMETRAN_COMBINE.WPCODE, TIMETRAN_COMBINE.ACTIVITY, TIMETRAN_COMBINE.GRP, TIMETRAN_COMBINE.HOURS, TIMETRAN_COMBINE.OTHOURS,
                     (TIMETRAN_COMBINE.HOURS + TIMETRAN_COMBINE.OTHOURS) Total
                FROM
                     TIMETRAN_COMBINE TIMETRAN_COMBINE,
                     EMPLMAST EMPLMAST
                WHERE
                    TIMETRAN_COMBINE.EMPNO = EMPLMAST.EMPNO and
            SUBSTR(TIMETRAN_COMBINE.PROJNO,0,5) = SUBSTR(:p_projno,0,5)

                ORDER BY
                    TIMETRAN_COMBINE.WPCODE ASC
                        ";
            //and  TIMETRAN_COMBINE.YYMM = :p_yymm
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
                if (conn != null)
                {
                    if (conn.State == ConnectionState.Open)
                    {
                        conn.Close();
                    }
                }
                //op_yymm.Dispose();
                op_projno.Dispose();
            }
        }
    }

    public class AfterPostCostRepository : IAfterPostCostRepository
    {
        private readonly RAPDbContext rapDbContext;

        public AfterPostCostRepository(RAPDbContext _rapDbContext)
        {
            rapDbContext = _rapDbContext;
        }

        public object CostCentre_CostOT_combine(string CoseCode)
        {
            OracleConnection conn = (OracleConnection)rapDbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
            {
                conn.Open();
            }

            OracleCommand cmd = conn.CreateCommand();
            DataTable dt = new();
            OracleParameter op_CoseCode = new("p_CoseCode", OracleDbType.Varchar2, CoseCode.ToString(), ParameterDirection.Input);

            _ = cmd.Parameters.Add(op_CoseCode);

            string ora_sql = @"
                 SELECT
                    TIMETRAN_COMBINE.YYMM, TIMETRAN_COMBINE.COSTCODE, TIMETRAN_COMBINE.PROJNO, TIMETRAN_COMBINE.HOURS,
                    TIMETRAN_COMBINE.OTHOURS,
                    COSTMAST.ABBR ,  (TIMETRAN_COMBINE.hours +     TIMETRAN_COMBINE.othours) TOTALHOURS
                FROM
                    TIMETRAN_COMBINE TIMETRAN_COMBINE,
                    COSTMAST COSTMAST
                WHERE
                    TIMETRAN_COMBINE.COSTCODE = COSTMAST.COSTCODE
                    and
                    TIMETRAN_COMBINE.COSTCODE = :p_CoseCode
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
                if (conn != null)
                {
                    if (conn.State == ConnectionState.Open)
                    {
                        conn.Close();
                    }
                }
                op_CoseCode.Dispose();
            }
        }

        public object CostCentre_Cost_combine(string CoseCode)
        {
            OracleConnection conn = (OracleConnection)rapDbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
            {
                conn.Open();
            }

            OracleCommand cmd = conn.CreateCommand();
            DataTable dt = new();
            OracleParameter op_CoseCode = new("p_CoseCode", OracleDbType.Varchar2, CoseCode.ToString(), ParameterDirection.Input);

            _ = cmd.Parameters.Add(op_CoseCode);

            string ora_sql = @"
                 SELECT
                         TIMETRAN_COMBINE.YYMM, TIMETRAN_COMBINE.COSTCODE, TIMETRAN_COMBINE.PROJNO, TIMETRAN_COMBINE.HOURS, TIMETRAN_COMBINE.OTHOURS,
                        COSTMAST.ABBR ,    (timetran_combine.hours +     timetran_combine.othours) TOTALHOURS
                    FROM
                        TIMETRAN_COMBINE TIMETRAN_COMBINE,
                        COSTMAST COSTMAST
                    WHERE
                        TIMETRAN_COMBINE.COSTCODE = COSTMAST.COSTCODE
                        and
                       TIMETRAN_COMBINE.COSTCODE = :p_CoseCode
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
                if (conn != null)
                {
                    if (conn.State == ConnectionState.Open)
                    {
                        conn.Close();
                    }
                }
                op_CoseCode.Dispose();
            }
        }

        public object CostCentre_hrs_OtBreak(string CoseCode, string yymm)
        {
            OracleConnection conn = (OracleConnection)rapDbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
            {
                conn.Open();
            }

            OracleCommand cmd = conn.CreateCommand();
            DataTable dt = new();
            OracleParameter op_CoseCode = new("p_CoseCode", OracleDbType.Varchar2, CoseCode.ToString(), ParameterDirection.Input);
            OracleParameter op_yymm = new("p_yymm", OracleDbType.Varchar2, yymm.ToString(), ParameterDirection.Input);
            _ = cmd.Parameters.Add(op_CoseCode);
            _ = cmd.Parameters.Add(op_yymm);

            string ora_sql = @"
                       SELECT
                        PROJHRS_OTBREAKUP.PROJNO, PROJHRS_OTBREAKUP.YYMM, PROJHRS_OTBREAKUP.COSTCODE,
                        PROJHRS_OTBREAKUP.EMPNO, PROJHRS_OTBREAKUP.NAME Empname, PROJHRS_OTBREAKUP.HOURS, PROJHRS_OTBREAKUP.OTHOURS
                    FROM
                        PROJHRS_OTBREAKUP PROJHRS_OTBREAKUP
                        where
                         PROJHRS_OTBREAKUP.COSTCODE = :p_CoseCode and PROJHRS_OTBREAKUP.YYMM = :p_yymm
                    ORDER BY
                        PROJHRS_OTBREAKUP.PROJNO ASC,
                        PROJHRS_OTBREAKUP.YYMM ASC,
                        PROJHRS_OTBREAKUP.COSTCODE ASC,
                        PROJHRS_OTBREAKUP.EMPNO ASC

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
                if (conn != null)
                {
                    if (conn.State == ConnectionState.Open)
                    {
                        conn.Close();
                    }
                }
                op_yymm.Dispose();
                op_CoseCode.Dispose();
            }
        }

        public object CostCentre_hrs_OtCrossTab(string CoseCode, string yymm)
        {
            OracleConnection conn = (OracleConnection)rapDbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
            {
                conn.Open();
            }

            OracleCommand cmd = conn.CreateCommand();
            DataTable dt = new();
            OracleParameter op_CoseCode = new("p_CoseCode", OracleDbType.Varchar2, CoseCode.ToString(), ParameterDirection.Input);
            OracleParameter op_yymm = new("p_yymm", OracleDbType.Varchar2, yymm.ToString(), ParameterDirection.Input);
            _ = cmd.Parameters.Add(op_CoseCode);
            _ = cmd.Parameters.Add(op_yymm);

            string ora_sql = @"
                SELECT
                    projhrs_otbreakup.projno,
                    projhrs_otbreakup.yymm,
                    projhrs_otbreakup.costcode,
                    projhrs_otbreakup.empno ||' '||
                    projhrs_otbreakup.name Emp,
                    projhrs_otbreakup.hours,
                    projhrs_otbreakup.othours ,
                   (  projhrs_otbreakup.hours +
                    projhrs_otbreakup.othours ) TOTALHOURS
                FROM
                    projhrs_otbreakup projhrs_otbreakup
                     where
                        projhrs_otbreakup.costcode = :p_CoseCode and PROJHRS_OTBREAKUP.YYMM = :p_yymm

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
                if (conn != null)
                {
                    if (conn.State == ConnectionState.Open)
                    {
                        conn.Close();
                    }
                }
                op_yymm.Dispose();
                op_CoseCode.Dispose();
            }
        }

        public object CostCentre_PlanRep1(string CoseCode, string yymm)
        {
            OracleConnection conn = (OracleConnection)rapDbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
            {
                conn.Open();
            }

            OracleCommand cmd = conn.CreateCommand();
            DataTable dt = new();
            OracleParameter op_CoseCode = new("p_CoseCode", OracleDbType.Varchar2, CoseCode.ToString(), ParameterDirection.Input);
            OracleParameter op_yymm = new("p_yymm", OracleDbType.Varchar2, yymm.ToString(), ParameterDirection.Input);
            _ = cmd.Parameters.Add(op_CoseCode);
            _ = cmd.Parameters.Add(op_yymm);

            string ora_sql = @"
                    SELECT
                            PROJACTDET.PROJNO, PROJACTDET.PROJNAME, PROJACTDET.YYMM, PROJACTDET.COSTCODE, PROJACTDET.COSTNAME, PROJACTDET.TLPCODE, PROJACTDET.TLPNAME, PROJACTDET.TOTHOURS TotalHours
                        FROM
                            PROJACTDET PROJACTDET
                        where
                          PROJACTDET.COSTCODE =:p_CoseCode and PROJACTDET.YYMM >= :p_yymm
                        ORDER BY
                            PROJACTDET.PROJNO ASC,
                            PROJACTDET.YYMM ASC,
                            PROJACTDET.COSTCODE ASC,
                            PROJACTDET.TLPCODE ASC
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
                if (conn != null)
                {
                    if (conn.State == ConnectionState.Open)
                    {
                        conn.Close();
                    }
                }
                op_yymm.Dispose();
                op_CoseCode.Dispose();
            }
        }

        public object CostCentre_PlanRep2(string CoseCode, string yymm)
        {
            OracleConnection conn = (OracleConnection)rapDbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
            {
                conn.Open();
            }

            OracleCommand cmd = conn.CreateCommand();
            DataTable dt = new();
            OracleParameter op_CoseCode = new("p_CoseCode", OracleDbType.Varchar2, CoseCode.ToString(), ParameterDirection.Input);
            OracleParameter op_yymm = new("p_yymm", OracleDbType.Varchar2, yymm.ToString(), ParameterDirection.Input);
            _ = cmd.Parameters.Add(op_CoseCode);
            _ = cmd.Parameters.Add(op_yymm);

            string ora_sql = @"
                   SELECT
                    TIMETRAN.YYMM, TIMETRAN.COSTCODE, TIMETRAN.PROJNO, TIMETRAN.ACTIVITY, TIMETRAN.HOURS, TIMETRAN.OTHOURS ,(TIMETRAN.HOURS + TIMETRAN.OTHOURS) TotalHours
                FROM
                    TIMETRAN TIMETRAN
                    where
                 TIMETRAN.COSTCODE = :p_CoseCode and TIMETRAN.YYMM = :p_yymm
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
                if (conn != null)
                {
                    if (conn.State == ConnectionState.Open)
                    {
                        conn.Close();
                    }
                }
                op_yymm.Dispose();
                op_CoseCode.Dispose();
            }
        }

        public object ProjectwiseManhoursList(string yymm, string projno, string costcode)
        {
            DataSet ds = new();
            OracleConnection conn = (OracleConnection)rapDbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
            {
                conn.Open();
            }

            OracleParameter op_yymm = new("p_yymm", OracleDbType.Varchar2, yymm.ToString(), ParameterDirection.Input);
            OracleParameter op_projno = new("p_projno", OracleDbType.Varchar2, projno.ToString(), ParameterDirection.Input);
            OracleParameter op_costcode = new("p_costcode", OracleDbType.Varchar2, costcode.ToString(), ParameterDirection.Input);
            OracleParameter op_rec = new("p_rec", OracleDbType.RefCursor, ParameterDirection.Output);

            try
            {
                string sql = "BEGIN RAP_REPORTS_PROJECT.rpt_proj_emp(:p_yymm, :p_projno, :p_costcode, :p_rec); END;";
                object[] ora_param = new object[] { op_yymm, op_projno, op_costcode, op_rec };
                int i_result = rapDbContext.Database.ExecuteSqlRaw(sql, ora_param);
                OracleRefCursor cur_subcontractor = (OracleRefCursor)op_rec.Value;
                OracleDataAdapter da = new();
                _ = da.TableMappings.Add("Table", "subcontractor");

                _ = da.Fill(ds, "subcontractor", cur_subcontractor);
                da.Dispose();
                return ds.Tables["subcontractor"];
            }
            catch (Exception e)
            {
                return new { Result = "ERROR", Message = e.Message.ToString() };
            }
            finally
            {
                if (conn != null)
                {
                    if (conn.State == ConnectionState.Open)
                    {
                        conn.Close();
                    }
                }
                op_yymm.Dispose();
                op_projno.Dispose();
                op_costcode.Dispose();
                op_rec.Dispose();
            }
        }
    }
}