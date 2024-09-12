using Microsoft.EntityFrameworkCore;
using Oracle.ManagedDataAccess.Client;
using Oracle.ManagedDataAccess.Types;
using RapReportingApi.RAPEntityModels;
using RapReportingApi.Repositories.HRMasters;
using System;
using System.Data;

namespace RapReportingApi.Repositories.Rpt.Cmplx.CC
{
    public class HRMastersReportRepository : IHRMastersReportRepository
    {
        private RAPDbContext _dbContext;

        public HRMastersReportRepository(RAPDbContext paramDBContext)
        {
            _dbContext = paramDBContext;
        }

        public object MonthlyConsolidatedData(string yymm)
        {
            DataSet ds = new DataSet();
            OracleConnection conn = (OracleConnection)_dbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
                conn.Open();

            OracleParameter op_yymm = new OracleParameter("p_yymm", OracleDbType.Varchar2, yymm.ToString(), ParameterDirection.Input);
            OracleParameter op_final = new OracleParameter("p_final", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_final_all = new OracleParameter("p_final_all", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_left_all = new OracleParameter("p_left_all", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_mptotal = new OracleParameter("p_mptotal", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_mptotal_delhi = new OracleParameter("p_mptotal_delhi", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_mptotal187 = new OracleParameter("p_mptotal187", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_grade = new OracleParameter("p_grade", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_grade_delhi = new OracleParameter("p_grade_delhi", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_grade187 = new OracleParameter("p_grade187", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_age = new OracleParameter("p_age", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_age_delhi = new OracleParameter("p_age_delhi", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_age187 = new OracleParameter("p_age187", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_experience = new OracleParameter("p_experience", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_experience_delhi = new OracleParameter("p_experience_delhi", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_experience187 = new OracleParameter("p_experience187", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_sex = new OracleParameter("p_sex", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_sex_delhi = new OracleParameter("p_sex_delhi", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_sex187 = new OracleParameter("p_sex187", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_manpower = new OracleParameter("p_manpower", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_manpowerdelhi = new OracleParameter("p_manpowerdelhi", OracleDbType.RefCursor, ParameterDirection.Output);

            try
            {
                var sql = "BEGIN hr_pkg_emplmast_report.get_monthly_consolidated(:p_yymm, :p_final, :p_final_all, :p_left_all, :p_mptotal, :p_mptotal_delhi, :p_mptotal187, :p_grade, :p_grade_delhi, :p_grade187, :p_age, :p_age_delhi, :p_age187, :p_experience, :p_experience_delhi, :p_experience187, :p_sex, :p_sex_delhi, :p_sex187, :p_manpower, :p_manpowerdelhi); END;";
                object[] ora_param = new object[] { op_yymm, op_final, op_final_all, op_left_all, op_mptotal, op_mptotal_delhi, op_mptotal187, op_grade, op_grade_delhi, op_grade187, op_age, op_age_delhi, op_age187, op_experience, op_experience_delhi, op_experience187, op_sex, op_sex_delhi, op_sex187, op_manpower, op_manpowerdelhi };
                var i_result = _dbContext.Database.ExecuteSqlRaw(sql, ora_param);
                OracleRefCursor cur_final = (OracleRefCursor)op_final.Value;
                OracleRefCursor cur_final_all = (OracleRefCursor)op_final_all.Value;
                OracleRefCursor cur_left_all = (OracleRefCursor)op_left_all.Value;
                OracleRefCursor cur_mptotal = (OracleRefCursor)op_mptotal.Value;
                OracleRefCursor cur_mptotal_delhi = (OracleRefCursor)op_mptotal_delhi.Value;
                OracleRefCursor cur_mptotal187 = (OracleRefCursor)op_mptotal187.Value;
                OracleRefCursor cur_grade = (OracleRefCursor)op_grade.Value;
                OracleRefCursor cur_grade_delhi = (OracleRefCursor)op_grade_delhi.Value;
                OracleRefCursor cur_grade187 = (OracleRefCursor)op_grade187.Value;
                OracleRefCursor cur_age = (OracleRefCursor)op_age.Value;
                OracleRefCursor cur_age_delhi = (OracleRefCursor)op_age_delhi.Value;
                OracleRefCursor cur_age187 = (OracleRefCursor)op_age187.Value;
                OracleRefCursor cur_exp = (OracleRefCursor)op_experience.Value;
                OracleRefCursor cur_exp_delhi = (OracleRefCursor)op_experience_delhi.Value;
                OracleRefCursor cur_exp187 = (OracleRefCursor)op_experience187.Value;
                OracleRefCursor cur_sex = (OracleRefCursor)op_sex.Value;
                OracleRefCursor cur_sex_delhi = (OracleRefCursor)op_sex_delhi.Value;
                OracleRefCursor cur_sex187 = (OracleRefCursor)op_sex187.Value;
                OracleRefCursor cur_manpower = (OracleRefCursor)op_manpower.Value;
                OracleRefCursor cur_manpowerdelhi = (OracleRefCursor)op_manpowerdelhi.Value;

                OracleDataAdapter da = new OracleDataAdapter();
                da.TableMappings.Add("Table", "finalTable");
                da.TableMappings.Add("Table1", "finalallTable");
                da.TableMappings.Add("Table2", "leftallTable");
                da.TableMappings.Add("Table3", "mptotalTable");
                da.TableMappings.Add("Table4", "mptotalDelhiTable");
                da.TableMappings.Add("Table5", "mptotal187Table");
                da.TableMappings.Add("Table6", "gradeTable");
                da.TableMappings.Add("Table7", "gradeDelhiTable");
                da.TableMappings.Add("Table8", "grade187Table");
                da.TableMappings.Add("Table9", "ageTable");
                da.TableMappings.Add("Table10", "ageDelhiTable");
                da.TableMappings.Add("Table11", "age187Table");
                da.TableMappings.Add("Table12", "expTable");
                da.TableMappings.Add("Table13", "expDelhiTable");
                da.TableMappings.Add("Table14", "exp187Table");
                da.TableMappings.Add("Table15", "sexTable");
                da.TableMappings.Add("Table16", "sexDelhiTable");
                da.TableMappings.Add("Table17", "sex187Table");
                da.TableMappings.Add("Table18", "manpowerTable");
                da.TableMappings.Add("Table19", "manpowerDelhiTable");

                da.Fill(ds, "finalTable", cur_final);
                da.Fill(ds, "finalallTable", cur_final_all);
                da.Fill(ds, "leftallTable", cur_left_all);
                da.Fill(ds, "mptotalTable", cur_mptotal);
                da.Fill(ds, "mptotalDelhiTable", cur_mptotal_delhi);
                da.Fill(ds, "mptotal187Table", cur_mptotal187);
                da.Fill(ds, "gradeTable", cur_grade);
                da.Fill(ds, "gradeDelhiTable", cur_grade_delhi);
                da.Fill(ds, "grade187Table", cur_grade187);
                da.Fill(ds, "ageTable", cur_age);
                da.Fill(ds, "ageDelhiTable", cur_age_delhi);
                da.Fill(ds, "age187Table", cur_age187);
                da.Fill(ds, "expTable", cur_exp);
                da.Fill(ds, "expDelhiTable", cur_exp_delhi);
                da.Fill(ds, "exp187Table", cur_exp187);
                da.Fill(ds, "sexTable", cur_sex);
                da.Fill(ds, "sexDelhiTable", cur_sex_delhi);
                da.Fill(ds, "sex187Table", cur_sex187);
                da.Fill(ds, "manpowerTable", cur_manpower);
                da.Fill(ds, "manpowerDelhiTable", cur_manpowerdelhi);

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
                op_yymm.Dispose();
                op_final.Dispose();
                op_final_all.Dispose();
                op_left_all.Dispose();
                op_mptotal.Dispose();
                op_mptotal_delhi.Dispose();
                op_mptotal187.Dispose();
                op_grade.Dispose();
                op_grade_delhi.Dispose();
                op_grade187.Dispose();
                op_age.Dispose();
                op_age_delhi.Dispose();
                op_age187.Dispose();
                op_experience.Dispose();
                op_experience_delhi.Dispose();
                op_experience187.Dispose();
                op_sex.Dispose();
                op_sex_delhi.Dispose();
                op_sex187.Dispose();
                op_manpower.Dispose();
                op_manpowerdelhi.Dispose();
            }
        }

        public object MonthlyConsolidatedEnggData(string yymm)
        {
            DataSet ds = new DataSet();
            OracleConnection conn = (OracleConnection)_dbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
                conn.Open();

            OracleParameter op_yymm = new OracleParameter("p_yymm", OracleDbType.Varchar2, yymm.ToString(), ParameterDirection.Input);
            OracleParameter op_final = new OracleParameter("p_final", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_final_all = new OracleParameter("p_final_all", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_left_all = new OracleParameter("p_left_all", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_mptotal = new OracleParameter("p_mptotal", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_mptotal_delhi = new OracleParameter("p_mptotal_delhi", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_mptotal187 = new OracleParameter("p_mptotal187", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_grade = new OracleParameter("p_grade", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_grade_delhi = new OracleParameter("p_grade_delhi", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_grade187 = new OracleParameter("p_grade187", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_age = new OracleParameter("p_age", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_age_delhi = new OracleParameter("p_age_delhi", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_age187 = new OracleParameter("p_age187", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_experience = new OracleParameter("p_experience", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_experience_delhi = new OracleParameter("p_experience_delhi", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_experience187 = new OracleParameter("p_experience187", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_sex = new OracleParameter("p_sex", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_sex_delhi = new OracleParameter("p_sex_delhi", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_sex187 = new OracleParameter("p_sex187", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_manpower = new OracleParameter("p_manpower", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_manpowerdelhi = new OracleParameter("p_manpowerdelhi", OracleDbType.RefCursor, ParameterDirection.Output);

            try
            {
                var sql = "BEGIN hr_pkg_emplmast_report.get_monthly_consolidated_engg(:p_yymm, :p_final, :p_final_all, :p_left_all, :p_mptotal, :p_mptotal_delhi, :p_mptotal187, :p_grade, :p_grade_delhi, :p_grade187, :p_age, :p_age_delhi, :p_age187, :p_experience, :p_experience_delhi, :p_experience187, :p_sex, :p_sex_delhi, :p_sex187, :p_manpower, :p_manpowerdelhi); END;";
                object[] ora_param = new object[] { op_yymm, op_final, op_final_all, op_left_all, op_mptotal, op_mptotal_delhi, op_mptotal187, op_grade, op_grade_delhi, op_grade187, op_age, op_age_delhi, op_age187, op_experience, op_experience_delhi, op_experience187, op_sex, op_sex_delhi, op_sex187, op_manpower, op_manpowerdelhi };
                var i_result = _dbContext.Database.ExecuteSqlRaw(sql, ora_param);
                OracleRefCursor cur_final = (OracleRefCursor)op_final.Value;
                OracleRefCursor cur_final_all = (OracleRefCursor)op_final_all.Value;
                OracleRefCursor cur_left_all = (OracleRefCursor)op_left_all.Value;
                OracleRefCursor cur_mptotal = (OracleRefCursor)op_mptotal.Value;
                OracleRefCursor cur_mptotal_delhi = (OracleRefCursor)op_mptotal_delhi.Value;
                OracleRefCursor cur_mptotal187 = (OracleRefCursor)op_mptotal187.Value;
                OracleRefCursor cur_grade = (OracleRefCursor)op_grade.Value;
                OracleRefCursor cur_grade_delhi = (OracleRefCursor)op_grade_delhi.Value;
                OracleRefCursor cur_grade187 = (OracleRefCursor)op_grade187.Value;
                OracleRefCursor cur_age = (OracleRefCursor)op_age.Value;
                OracleRefCursor cur_age_delhi = (OracleRefCursor)op_age_delhi.Value;
                OracleRefCursor cur_age187 = (OracleRefCursor)op_age187.Value;
                OracleRefCursor cur_exp = (OracleRefCursor)op_experience.Value;
                OracleRefCursor cur_exp_delhi = (OracleRefCursor)op_experience_delhi.Value;
                OracleRefCursor cur_exp187 = (OracleRefCursor)op_experience187.Value;
                OracleRefCursor cur_sex = (OracleRefCursor)op_sex.Value;
                OracleRefCursor cur_sex_delhi = (OracleRefCursor)op_sex_delhi.Value;
                OracleRefCursor cur_sex187 = (OracleRefCursor)op_sex187.Value;
                OracleRefCursor cur_manpower = (OracleRefCursor)op_manpower.Value;
                OracleRefCursor cur_manpowerdelhi = (OracleRefCursor)op_manpowerdelhi.Value;

                OracleDataAdapter da = new OracleDataAdapter();
                da.TableMappings.Add("Table", "finalTable");
                da.TableMappings.Add("Table1", "finalallTable");
                da.TableMappings.Add("Table2", "leftallTable");
                da.TableMappings.Add("Table3", "mptotalTable");
                da.TableMappings.Add("Table4", "mptotalDelhiTable");
                da.TableMappings.Add("Table5", "mptotal187Table");
                da.TableMappings.Add("Table6", "gradeTable");
                da.TableMappings.Add("Table7", "gradeDelhiTable");
                da.TableMappings.Add("Table8", "grade187Table");
                da.TableMappings.Add("Table9", "ageTable");
                da.TableMappings.Add("Table10", "ageDelhiTable");
                da.TableMappings.Add("Table11", "age187Table");
                da.TableMappings.Add("Table12", "expTable");
                da.TableMappings.Add("Table13", "expDelhiTable");
                da.TableMappings.Add("Table14", "exp187Table");
                da.TableMappings.Add("Table15", "sexTable");
                da.TableMappings.Add("Table16", "sexDelhiTable");
                da.TableMappings.Add("Table17", "sex187Table");
                da.TableMappings.Add("Table18", "manpowerTable");
                da.TableMappings.Add("Table19", "manpowerDelhiTable");

                da.Fill(ds, "finalTable", cur_final);
                da.Fill(ds, "finalallTable", cur_final_all);
                da.Fill(ds, "leftallTable", cur_left_all);
                da.Fill(ds, "mptotalTable", cur_mptotal);
                da.Fill(ds, "mptotalDelhiTable", cur_mptotal_delhi);
                da.Fill(ds, "mptotal187Table", cur_mptotal187);
                da.Fill(ds, "gradeTable", cur_grade);
                da.Fill(ds, "gradeDelhiTable", cur_grade_delhi);
                da.Fill(ds, "grade187Table", cur_grade187);
                da.Fill(ds, "ageTable", cur_age);
                da.Fill(ds, "ageDelhiTable", cur_age_delhi);
                da.Fill(ds, "age187Table", cur_age187);
                da.Fill(ds, "expTable", cur_exp);
                da.Fill(ds, "expDelhiTable", cur_exp_delhi);
                da.Fill(ds, "exp187Table", cur_exp187);
                da.Fill(ds, "sexTable", cur_sex);
                da.Fill(ds, "sexDelhiTable", cur_sex_delhi);
                da.Fill(ds, "sex187Table", cur_sex187);
                da.Fill(ds, "manpowerTable", cur_manpower);
                da.Fill(ds, "manpowerDelhiTable", cur_manpowerdelhi);
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
                op_yymm.Dispose();
                op_final.Dispose();
                op_final_all.Dispose();
                op_left_all.Dispose();
                op_mptotal.Dispose();
                op_mptotal_delhi.Dispose();
                op_mptotal187.Dispose();
                op_grade.Dispose();
                op_grade_delhi.Dispose();
                op_grade187.Dispose();
                op_age.Dispose();
                op_age_delhi.Dispose();
                op_age187.Dispose();
                op_experience.Dispose(); 
                op_experience_delhi.Dispose();
                op_experience187.Dispose();
                op_sex.Dispose();
                op_sex_delhi.Dispose();
                op_sex187.Dispose();
                op_manpower.Dispose();
                op_manpowerdelhi.Dispose();
            }
        }

        public object OutsourceEmployeeData(string yymm)
        {
            DataSet ds = new DataSet();
            OracleConnection conn = (OracleConnection)_dbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
                conn.Open();

            OracleParameter op_yymm = new OracleParameter("p_yymm", OracleDbType.Varchar2, yymm.ToString(), ParameterDirection.Input);
            OracleParameter op_employee = new OracleParameter("p_employee", OracleDbType.RefCursor, ParameterDirection.Output);
            OracleParameter op_empnoyee_abstract = new OracleParameter("p_employee_abstract", OracleDbType.RefCursor, ParameterDirection.Output);

            try
            {
                var sql = "BEGIN hr_pkg_emplmast_report.get_monthly_outsource_employee(:p_yymm, :p_employee, :p_employee_abstract); END;";
                object[] ora_param = new object[] { op_yymm, op_employee, op_empnoyee_abstract };
                var i_result = _dbContext.Database.ExecuteSqlRaw(sql, ora_param);
                OracleRefCursor cur_employee = (OracleRefCursor)op_employee.Value;
                OracleRefCursor cur_empnoyee_abstract = (OracleRefCursor)op_empnoyee_abstract.Value;

                OracleDataAdapter da = new OracleDataAdapter();
                da.TableMappings.Add("Table", "employeeTable");
                da.TableMappings.Add("Table1", "employeeAbstractTable");

                da.Fill(ds, "employeeTable", cur_employee);
                da.Fill(ds, "employeeAbstractTable", cur_empnoyee_abstract);

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
                op_yymm.Dispose();
                op_employee.Dispose();
                op_empnoyee_abstract.Dispose();
            }
        }
    }
}