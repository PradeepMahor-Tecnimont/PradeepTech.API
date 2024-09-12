using Microsoft.EntityFrameworkCore;
using Oracle.ManagedDataAccess.Client;
using RapReportingApi.RAPEntityModels;
using RapReportingApi.Repositories.Interfaces.Rpt;
using System;
using System.Data;

namespace RapReportingApi.Repositories.Rpt
{
    public class BeforePostProjRepository : IBeforePostProjRepository
    {
        private RAPDbContext rapDbContext;

        //public SimpleRepository(IConfiguration _configuration, IHostingEnvironment env, IOptions<AppSettings> _settings)
        public BeforePostProjRepository(RAPDbContext _rapDbContext)
        {
            rapDbContext = _rapDbContext;
        }

        public object YY_PRJ_CC(string projno, string yymm)
        {
            //projno = "0938402";
            //yymm = "201205";
            OracleConnection conn = (OracleConnection)rapDbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
                conn.Open();
            OracleCommand cmd = conn.CreateCommand() as OracleCommand;
            string ora_sql = string.Empty;
            DataTable dt = new DataTable();
            OracleParameter op_projno = new OracleParameter("p_projno", OracleDbType.Varchar2, projno.ToString(), ParameterDirection.Input);
            OracleParameter op_yymm = new OracleParameter("p_yymm", OracleDbType.Varchar2, yymm.ToString(), ParameterDirection.Input);
            cmd.Parameters.Add(op_projno);
            cmd.Parameters.Add(op_yymm);

            ora_sql = @"
                                SELECT

                                JOBWISE.YYMM, JOBWISE.ASSIGN, JOBWISE.PROJNO,
                                    COSTMAST.NAME CostCode_Name,
                                      PROJMAST.NAME Proj_Name , JOBWISE.NHRS, JOBWISE.OHRS
                                FROM
                                    PROJMAST PROJMAST,      JOBWISE JOBWISE,    COSTMAST COSTMAST
                                WHERE
                                    JOBWISE.ASSIGN = COSTMAST.COSTCODE AND
                                    JOBWISE.PROJNO = PROJMAST.PROJNO
                              and PROJMAST.PROJNO = :p_projno
                                and JOBWISE.YYMM = :p_yymm
                                ORDER BY
                                    JOBWISE.YYMM ASC,
                                    JOBWISE.ASSIGN ASC,
                                    JOBWISE.PROJNO ASC
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
                if ((conn != null))
                {
                    if (conn.State == ConnectionState.Open)
                        conn.Close();
                }
                op_yymm.Dispose();
                op_projno.Dispose();
            }
        }

        public object YY_PRJ_CC_ACT(string projno, string yymm)
        {
            //projno = "0967109";
            //yymm = "201204";
            OracleConnection conn = (OracleConnection)rapDbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
                conn.Open();
            OracleCommand cmd = conn.CreateCommand() as OracleCommand;
            string ora_sql = string.Empty;
            DataTable dt = new DataTable();
            OracleParameter op_projno = new OracleParameter("p_projno", OracleDbType.Varchar2, projno.ToString(), ParameterDirection.Input);
            OracleParameter op_yymm = new OracleParameter("p_yymm", OracleDbType.Varchar2, yymm.ToString(), ParameterDirection.Input);
            cmd.Parameters.Add(op_projno);
            cmd.Parameters.Add(op_yymm);

            ora_sql = @"
                               SELECT
                                JOBWISE.YYMM, JOBWISE.ASSIGN, JOBWISE.PROJNO, JOBWISE.ACTIVITY, JOBWISE.NHRS, JOBWISE.OHRS,
                               PROJMAST.NAME ProjName,	(JOBWISE.NHRS + JOBWISE.OHRS) TotalHRS ,
                               ACT_MAST.NAME ActName
                            FROM
                                JOBWISE JOBWISE,
                                PROJMAST PROJMAST,
                                ACT_MAST ACT_MAST
                            WHERE
                                JOBWISE.PROJNO = PROJMAST.PROJNO AND
                                JOBWISE.ASSIGN = ACT_MAST.COSTCODE AND
                                JOBWISE.ACTIVITY = ACT_MAST.ACTIVITY
                                and PROJMAST.PROJNO = :p_projno
                                and JOBWISE.YYMM = :p_yymm
                            ORDER BY
                                JOBWISE.YYMM ASC,
                                JOBWISE.ASSIGN ASC,
                                JOBWISE.PROJNO ASC,
                                JOBWISE.ACTIVITY ASC
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
                if ((conn != null))
                {
                    if (conn.State == ConnectionState.Open)
                        conn.Close();
                }
                op_yymm.Dispose();
                op_projno.Dispose();
            }
        }

        public object YY_PRJ_CC_EMP(string projno, string yymm)
        {
            //projno = "0967109";
            //yymm = "201204";
            OracleConnection conn = (OracleConnection)rapDbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
                conn.Open();
            OracleCommand cmd = conn.CreateCommand() as OracleCommand;
            string ora_sql = string.Empty;
            DataTable dt = new DataTable();
            OracleParameter op_projno = new OracleParameter("p_projno", OracleDbType.Varchar2, projno.ToString(), ParameterDirection.Input);
            OracleParameter op_yymm = new OracleParameter("p_yymm", OracleDbType.Varchar2, yymm.ToString(), ParameterDirection.Input);
            cmd.Parameters.Add(op_projno);
            cmd.Parameters.Add(op_yymm);

            ora_sql = @"
                              SELECT
                            JOBWISE.YYMM, JOBWISE.ASSIGN, JOBWISE.PROJNO, JOBWISE.EMPNO, JOBWISE.ACTIVITY, JOBWISE.NHRS, JOBWISE.OHRS,
                            EMPLMAST.NAME EmpName,	(JOBWISE.NHRS + JOBWISE.OHRS) TotalHRS ,
                            PROJMAST.PROJNO, PROJMAST.NAME ProjName
                        FROM
                            PROJMAST PROJMAST,    JOBWISE JOBWISE,      EMPLMAST EMPLMAST
                        WHERE
                            PROJMAST.PROJNO = JOBWISE.PROJNO AND      JOBWISE.EMPNO = EMPLMAST.EMPNO
                             and PROJMAST.PROJNO = :p_projno
                             and JOBWISE.YYMM = :p_yymm
                        ORDER BY
                            JOBWISE.YYMM ASC,
                            JOBWISE.ASSIGN ASC,
                            JOBWISE.PROJNO ASC,
                            JOBWISE.EMPNO ASC
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
                if ((conn != null))
                {
                    if (conn.State == ConnectionState.Open)
                        conn.Close();
                }
                op_yymm.Dispose();
                op_projno.Dispose();
            }
        }

        public object MJM_Proj_All_RptDownload(string yymm, string projno)
        {
            OracleConnection conn = (OracleConnection)rapDbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
                conn.Open();
            OracleCommand cmd = conn.CreateCommand() as OracleCommand;
            string ora_sql = string.Empty;
            DataTable dtMJEAM = new DataTable();
            OracleParameter op_yymm = new OracleParameter("p_yymm", OracleDbType.Varchar2, yymm.ToString(), ParameterDirection.Input);
            OracleParameter op_projno = new OracleParameter("p_Projno", OracleDbType.Varchar2, projno.ToString(), ParameterDirection.Input);
            cmd.Parameters.Add(op_yymm);
            cmd.Parameters.Add(op_projno);
            //            ora_sql = $@"
            //                        select b.yymm, b.assign ,c.name assign_name, b.assign ||' - '|| c.name assign_detail,
            //      b.projno ,a.name  project_name , b.projno ||' - '|| a.name  project_detail,
            //      b.EMPNO empno , e.name employee_name ,b.EMPNO ||' - '|| e.name employee_detail ,
            //      b.ACTIVITY ,
            //      (select distinct trim(act.name)
            //               from ACT_MAST act
            //               where act.activity = b.ACTIVITY
            //                  and act.COSTCODE= b.assign
            //                  ) ACTIVITY_name,
            //      (select distinct trim(act.activity) ||' - '||  trim(act.Name)
            //               from ACT_MAST act where act.activity = b.ACTIVITY
            //               and act.COSTCODE= b.assign ) ACTIVITY_Details,
            //         b.WPCODE
            //      , nvl(b.nhrs, 0) nhrs , nvl(b.ohrs, 0) ohrs
            //      , nvl(b.nhrs, 0) + nvl(b.ohrs, 0) totalhrs
            //  from projmast a, jobwise_wp b, costmast c , emplmast e
            //where a.projno = b.projno
            //   and b.empno = e.empno
            //   and b.assign = c.costcode
            //   and b.yymm = :p_yymm
            //   and substr(b.PROJNO,1,5) = substr(:p_Projno,1,5)
            //order by b.yymm asc, b.projno asc
            //                ";
            ora_sql = $@"
                        select b.yymm,
                   b.assign,
                   c.name assign_name,
                   b.assign || ' - ' || c.name assign_detail,
                   b.projno,
                   a.name project_name,
                   b.projno || ' - ' || a.name project_detail,
                   b.empno empno,
                   e.name employee_name,
                   b.empno || ' - ' || e.name employee_detail,
                   b.activity,
                   (
                       select distinct trim(act.name)
                         from act_mast act
                        where act.activity = b.activity
                          and act.costcode = b.assign
                   ) activity_name,
                   (
                       select distinct trim(act.activity) || ' - ' || trim(act.name)
                         from act_mast act
                        where act.activity = b.activity
                          and act.costcode = b.assign
                   ) activity_details,
                   b.wpcode,
                   nvl( b.nhrs, 0 ) nhrs,
                   nvl( b.ohrs, 0 ) ohrs,
                   nvl( b.nhrs, 0 ) + nvl( b.ohrs, 0 ) totalhrs
              from projmast a,
                   jobwise_wp b,
                   costmast c,
                   emplmast e
             where a.projno = b.projno
               and b.empno = e.empno
               and b.assign = c.costcode
               and b.yymm = :p_yymm
               and substr( b.projno, 1,5) = substr( :p_projno, 1,5)

             Union

                SELECT
                    ts_osc_mhrs_master.yymm          yymm,
                    ts_osc_mhrs_master.assign        assign,
                    c.name                           assign_name,
                    ts_osc_mhrs_master.assign || ' - ' || c.name                        assign_detail,
                    ts_osc_mhrs_detail.projno        projno,
                    a.name                           project_name,
                    ts_osc_mhrs_detail.projno || ' - ' || a.name                        project_detail,
                    ts_osc_mhrs_master.empno         empno,
                    e.name                           employee_name,
                    ts_osc_mhrs_master.empno || ' - ' || e.name                        employee_detail,
                    ts_osc_mhrs_detail.activity      activity,
                    ( SELECT DISTINCT TRIM(act.name) FROM act_mast act
                        WHERE act.activity = ts_osc_mhrs_detail.activity
                            AND act.costcode = ts_osc_mhrs_master.assign )             activity_name,
                    ( SELECT DISTINCT TRIM(act.activity) || ' - ' || TRIM(act.name)
                            FROM act_mast act
                            WHERE act.activity = ts_osc_mhrs_detail.activity
                            AND act.costcode = ts_osc_mhrs_master.assign )             activity_details,
                    ts_osc_mhrs_detail.wpcode        wpcode,
                    nvl(ts_osc_mhrs_detail.hours, 0) nhrs,
                    ( 0 )                            ohrs,
                    nvl(ts_osc_mhrs_detail.hours, 0) totalhrs
                FROM
                    ts_osc_mhrs_master ts_osc_mhrs_master,
                    projmast           a,
                    ts_osc_mhrs_detail ts_osc_mhrs_detail,
                    costmast           c,
                    emplmast           e
                WHERE
                     ts_osc_mhrs_detail.projno =     a.projno
                    AND ts_osc_mhrs_master.empno =   e.empno
                    AND ts_osc_mhrs_master.assign =  c.costcode
                    AND ts_osc_mhrs_master.oscm_id = ts_osc_mhrs_detail.oscm_id
                    AND ts_osc_mhrs_detail.projno =  a.projno
                    AND ts_osc_mhrs_master.yymm =   :p_yymm
                    --AND ts_osc_mhrs_detail.projno = :p_costcode
                    and substr( ts_osc_mhrs_detail.projno, 1,5) = substr( :p_projno, 1,5)
                  ORDER BY    yymm ASC,   projno ASC
                ";
            cmd.CommandText = ora_sql;
            cmd.CommandType = CommandType.Text;
            try
            {
                dtMJEAM.Load(cmd.ExecuteReader());
                return dtMJEAM;
            }
            catch (Exception)
            {
                throw;
            }
            finally
            {
                dtMJEAM.Dispose();
                cmd.Dispose();
                if ((conn != null))
                {
                    if (conn.State == ConnectionState.Open)
                        conn.Close();
                }
                op_yymm.Dispose();
                op_projno.Dispose();
                rapDbContext.Dispose();
            }
        }
    }
}