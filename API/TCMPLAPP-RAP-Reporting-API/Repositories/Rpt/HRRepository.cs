using ClosedXML.Excel;
using ClosedXML.Report;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;
using Oracle.ManagedDataAccess.Client;
using Oracle.ManagedDataAccess.Types;
using RapReportingApi.Models;
using RapReportingApi.RAPEntityModels;
using RapReportingApi.Repositories.Interfaces.Rpt;
using System;
using System.Data;
using System.IO;

namespace RapReportingApi.Repositories.Rpt
{
    public class HRRepository : IHRRepository
    {
        private IOptions<AppSettings> appSettings;

        public HRRepository(RAPDbContext paramDBContext, IOptions<AppSettings> _settings)
        {
            _dbContext = paramDBContext;
            appSettings = _settings;
        }

        private RAPDbContext _dbContext;

        public object Employee_2011onwards(string EmpNo)
        {
            OracleConnection conn = (OracleConnection)_dbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
                conn.Open();
            OracleCommand cmd = conn.CreateCommand() as OracleCommand;
            string ora_sql = string.Empty;
            OracleParameter op_EmpNo = new OracleParameter("P_EmpNo", OracleDbType.Varchar2, EmpNo.ToString(), ParameterDirection.Input);
            cmd.Parameters.Add(op_EmpNo);
            DataTable dt = new DataTable();
            ora_sql = @"
            SELECT
                Timetran_Combine.Yymm, Timetran_Combine.Empno, Timetran_Combine.Costcode,
                Timetran_Combine.Projno, Timetran_Combine.Wpcode, Timetran_Combine.Activity,
                Timetran_Combine.Grp, Timetran_Combine.Hours, Timetran_Combine.Othours,
                Emplmast.Name , (Timetran_Combine.Hours + Timetran_Combine.Othours) TotalHours
            FROM
                Timetran_Combine Timetran_Combine,      Emplmast Emplmast
            WHERE
                Timetran_Combine.Empno = Emplmast.Empno AND
                Timetran_Combine.Empno = :P_EmpNo
            ORDER BY
                Yymm,Costcode,Projno ";
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

        public object SUBCONTRACTOR_TS(string yymm)
        {
            OracleConnection conn = (OracleConnection)_dbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
                conn.Open();
            OracleCommand cmd = conn.CreateCommand() as OracleCommand;
            string ora_sql = string.Empty;
            OracleParameter op_yymm = new OracleParameter("P_Yymm", OracleDbType.Varchar2, yymm.ToString(), ParameterDirection.Input);
            cmd.Parameters.Add(op_yymm);
            DataTable dt = new DataTable();
            ora_sql = @"
            SELECT
                Remarks ,Name ,Subcontract ,Description ,Yymm ,Empno ,Parent ,Assign ,
                Projno ,Wpcode ,Activity ,
                D1 ,D2 ,D3 ,D4 ,D5 ,D6 ,D7 ,D8 ,D9 ,D10 ,D11 ,D12 ,D13 ,D14 ,D15 ,D16 ,D17 ,
                D18 ,D19 ,D20 ,D21 ,D22 ,D23 ,D24 ,D25 ,D26 ,D27 ,D28 ,D29 ,D30 ,D31 ,
                Total ,Grp ,Company
            FROM
                Subcontract_Ts
            where Yymm = :P_Yymm ";
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

        public object TSPENDING(string Yymm, string ReportType)
        {
            OracleConnection conn = (OracleConnection)_dbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
                conn.Open();
            OracleCommand cmd = conn.CreateCommand() as OracleCommand;
            string ora_sql = string.Empty;
            OracleParameter op_yymm = new OracleParameter("P_Yymm", OracleDbType.Varchar2, Yymm.ToString(), ParameterDirection.Input);
            cmd.Parameters.Add(op_yymm);
            DataTable dt = new DataTable();
            ora_sql = string.Empty;
            if (ReportType == "Filled")
            {
                ora_sql = @"
                    select
                        yymm, emptype, assign, costname, hod, desc1,empno, name, doj,email, dol, parent
                    from
                        tsnotfilled
                    where
                        yymm = :P_Yymm and desc1 like '%Filled%'
                    order by
                        assign, empno";
            }
            if (ReportType == "Posted")
            {
                ora_sql = @"
                    select
                        yymm, emptype, assign, costname, hod, desc1,empno, name, doj,email, dol, parent
                    from
                        tsnotfilled
                    where
                        yymm = :P_Yymm and desc1 like '%Posted%'
                    order by
                        assign, empno";
            }

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
                op_yymm.Dispose();
                _dbContext.Dispose();
            }
        }

        public object LeaveHRReport(string yymm)
        {
            OracleConnection conn = (OracleConnection)_dbContext.Database.GetDbConnection();
            if (conn == null || conn.State == ConnectionState.Closed)
                conn.Open();
            
            string ora_sql = string.Empty;
            string yymmPreviousMonth = string.Empty;
            OracleCommand cmd = new OracleCommand();
            DataSet ds = new DataSet();
            DataTable dtCurrentMonth_Data = new DataTable("CurrentMonth_Data");
            DataTable dtPreviousMonth_Data = new DataTable("PreviousMonth_Data");
            OracleParameter op_yymm = new OracleParameter();
            OracleParameter op_yymmPreviousMonth = new OracleParameter();
            try
            {
                for (int i = 0; i < 2; i++)
                {
                    cmd = conn.CreateCommand();
                    op_yymm = new OracleParameter("p_yymm", OracleDbType.Varchar2, yymm.ToString(), ParameterDirection.Input);
                    cmd.Parameters.Add(op_yymm);

                    if (i == 1)
                    {
                        DateTime d = new DateTime(int.Parse(yymm.Substring(0,4)), int.Parse(yymm.Substring(4,2)), 1);
                        DateTime dd = d.AddMonths(-1);
                        yymmPreviousMonth = string.Concat(dd.Year, dd.Month.ToString().PadLeft(2,'0'));
                        op_yymmPreviousMonth = new OracleParameter("p_yymmPreviousMonth", OracleDbType.Varchar2, yymmPreviousMonth, ParameterDirection.Input);
                        cmd.Parameters.Add(op_yymmPreviousMonth);
                    }                                       

                    ora_sql = " Select t.empno, e.name, " +
                                " sum(nvl(t.d1,0)) d1, sum(nvl(t.d2,0)) d2, sum(nvl(t.d3,0)) d3, sum(nvl(t.d4,0)) d4, sum(nvl(t.d5,0)) d5, sum(nvl(t.d6,0)) d6, sum(nvl(t.d7,0)) d7, sum(nvl(t.d8,0)) d8, sum(nvl(t.d9,0)) d9, sum(nvl(t.d10,0)) d10,  " +
                                " sum(nvl(t.d11,0)) d11, sum(nvl(t.d12,0)) d12, sum(nvl(t.d13,0)) d13, sum(nvl(t.d14,0)) d14, sum(nvl(t.d15,0)) d15, sum(nvl(t.d16,0)) d16, sum(nvl(t.d17,0)) d17, sum(nvl(t.d18,0)) d18, sum(nvl(t.d19,0)) d19, sum(nvl(t.d20,0)) d20, " +
                                " sum(nvl(t.d21,0)) d21, sum(nvl(t.d22,0)) d22, sum(nvl(t.d23,0)) d23, sum(nvl(t.d24,0)) d24, sum(nvl(t.d25,0)) d25, sum(nvl(t.d26,0)) d26, sum(nvl(t.d27,0)) d27, sum(nvl(t.d28,0)) d28, sum(nvl(t.d29,0)) d29, sum(nvl(t.d30,0)) d30, sum(nvl(t.d31,0)) d31, " +
                                " t.wpcode, t.assign, e.parent , t.projno, t.yymm, " +
                                " sum(nvl(t.d1,0)) + sum(nvl(t.d2,0)) + sum(nvl(t.d3,0)) + sum(nvl(t.d4,0)) + sum(nvl(t.d5,0)) + sum(nvl(t.d6,0)) + sum(nvl(t.d7,0)) + sum(nvl(t.d8,0)) + sum(nvl(t.d9,0)) + sum(nvl(t.d10,0)) + " +
                                " sum(nvl(t.d11,0)) + sum(nvl(t.d12,0)) + sum(nvl(t.d13,0)) + sum(nvl(t.d14,0)) + sum(nvl(t.d15,0)) + sum(nvl(t.d16,0)) + sum(nvl(t.d17,0)) + sum(nvl(t.d18,0)) + sum(nvl(t.d19,0)) + sum(nvl(t.d20,0)) + " +
                                " sum(nvl(t.d21,0)) + sum(nvl(t.d22,0)) + sum(nvl(t.d23,0)) + sum(nvl(t.d24,0)) + sum(nvl(t.d25,0)) + sum(nvl(t.d26,0)) + sum(nvl(t.d27,0)) + sum(nvl(t.d28,0)) + sum(nvl(t.d29,0)) + sum(nvl(t.d30,0)) + sum(nvl(t.d31,0)) total " +
                                " From time_daily t, emplmast e " +
                                " Where t.yymm = :p_yymm " +
                                " And Substr(t.projno,1,5) In ('11114', '22224','22225', '33334', 'E1114', 'E2224', 'E3334') " +
                                " And t.empno = e.empno ";
                    
                    if (i == 1)
                        ora_sql = ora_sql + " And t.wpcode = 4 ";

                    ora_sql = ora_sql + " Group by t.empno, e.name, t.wpcode, t.assign, e.parent , t.projno, t.yymm ";

                    if (i == 1)
                    {
                        ora_sql = ora_sql + "  UNION ALL " + 
                                " Select t.empno, e.name, " +
                               " sum(nvl(t.d1,0)) d1, sum(nvl(t.d2,0)) d2, sum(nvl(t.d3,0)) d3, sum(nvl(t.d4,0)) d4, sum(nvl(t.d5,0)) d5, sum(nvl(t.d6,0)) d6, sum(nvl(t.d7,0)) d7, sum(nvl(t.d8,0)) d8, sum(nvl(t.d9,0)) d9, sum(nvl(t.d10,0)) d10,  " +
                                " sum(nvl(t.d11,0)) d11, sum(nvl(t.d12,0)) d12, sum(nvl(t.d13,0)) d13, sum(nvl(t.d14,0)) d14, sum(nvl(t.d15,0)) d15, sum(nvl(t.d16,0)) d16, sum(nvl(t.d17,0)) d17, sum(nvl(t.d18,0)) d18, sum(nvl(t.d19,0)) d19, sum(nvl(t.d20,0)) d20, " +
                                " sum(nvl(t.d21,0)) d21, sum(nvl(t.d22,0)) d22, sum(nvl(t.d23,0)) d23, sum(nvl(t.d24,0)) d24, sum(nvl(t.d25,0)) d25, sum(nvl(t.d26,0)) d26, sum(nvl(t.d27,0)) d27, sum(nvl(t.d28,0)) d28, sum(nvl(t.d29,0)) d29, sum(nvl(t.d30,0)) d30, sum(nvl(t.d31,0)) d31, " +
                                " t.wpcode, t.assign, e.parent , t.projno, t.yymm, " +
                                " sum(nvl(t.d1,0)) + sum(nvl(t.d2,0)) + sum(nvl(t.d3,0)) + sum(nvl(t.d4,0)) + sum(nvl(t.d5,0)) + sum(nvl(t.d6,0)) + sum(nvl(t.d7,0)) + sum(nvl(t.d8,0)) + sum(nvl(t.d9,0)) + sum(nvl(t.d10,0)) + " +
                                " sum(nvl(t.d11,0)) + sum(nvl(t.d12,0)) + sum(nvl(t.d13,0)) + sum(nvl(t.d14,0)) + sum(nvl(t.d15,0)) + sum(nvl(t.d16,0)) + sum(nvl(t.d17,0)) + sum(nvl(t.d18,0)) + sum(nvl(t.d19,0)) + sum(nvl(t.d20,0)) + " +
                                " sum(nvl(t.d21,0)) + sum(nvl(t.d22,0)) + sum(nvl(t.d23,0)) + sum(nvl(t.d24,0)) + sum(nvl(t.d25,0)) + sum(nvl(t.d26,0)) + sum(nvl(t.d27,0)) + sum(nvl(t.d28,0)) + sum(nvl(t.d29,0)) + sum(nvl(t.d30,0)) + sum(nvl(t.d31,0)) total " +
                                " From time_daily t, emplmast e " +
                                " Where t.yymm = :p_yymmPreviousMonth " +
                                " And Substr(t.projno,1,5) In ('11114', '22224','22225', '33334', 'E1114', 'E2224', 'E3334') " +
                                " And t.empno = e.empno And t.wpcode != 4 " +
                                " Group by t.empno, e.name, t.wpcode, t.assign, e.parent , t.projno, t.yymm ";
                    }

                    ora_sql = ora_sql + " Order By 1";

                    cmd.CommandText = ora_sql;
                    cmd.CommandType = CommandType.Text;

                    if (i == 0)
                    {
                        dtCurrentMonth_Data.Load(cmd.ExecuteReader());
                        ds.Tables.Add(dtCurrentMonth_Data);
                    }
                    else if (i == 1)
                    {
                        dtPreviousMonth_Data.Load(cmd.ExecuteReader());
                        ds.Tables.Add(dtPreviousMonth_Data);
                    }
                    op_yymm.Dispose();
                    cmd.Dispose();
                }
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
                cmd.Dispose();
                dtCurrentMonth_Data.Dispose();
                dtPreviousMonth_Data.Dispose();
                op_yymm.Dispose();
                ds.Dispose();
                _dbContext.Dispose();
            }            
        }

        public byte[] getDownLoadTimesheet(string empno, string yymm)
        {
            OracleConnection oraConn = (OracleConnection)_dbContext.Database.GetDbConnection();
            if (oraConn == null || oraConn.State == ConnectionState.Closed)
                oraConn.Open();

            DataSet dsTimeSheet = null;
            DataSet dsEmp = null;
            DataSet dsHoliday = null;
            OracleCommand cmdTimeSheet = null;
            OracleCommand cmd = null;
            OracleCommand cmdEmp = null;
            OracleCommand cmdHoliday = null;
            DataTable dt = new DataTable();
            byte[] m_Bytes = null;

            var template = new XLTemplate(Common.CustomFunctions.GetRAPRepository(appSettings.Value) + @"\AfterPostHR\Timesheet.xlsx");
            var wb = template.Workbook;
            int x = 1;
            decimal normalHours = 0;
            decimal otHours = 0;

            try
            {
                cmd = new OracleCommand();
                cmd.Connection = oraConn;
                //cmd.CommandType = System.Data.CommandType.StoredProcedure;
                cmd.Parameters.Clear();
                OracleDataAdapter daCostcode = new OracleDataAdapter(cmd);
                OracleParameter op_empno = new OracleParameter("p_empno", OracleDbType.Varchar2, empno.ToString(), ParameterDirection.Input);
                OracleParameter op_yymm = new OracleParameter("p_yymm", OracleDbType.Varchar2, yymm.ToString(), ParameterDirection.Input);
                OracleParameter op_costcode = new OracleParameter("p_costcode", OracleDbType.RefCursor, ParameterDirection.Output);
                var ora_sql = "BEGIN rap_TimeSheet.get_costcode(:p_empno, :p_yymm, :p_costcode ); END;";

                object[] ora_param = new object[] { op_empno, op_yymm, op_costcode };
                var i_result = _dbContext.Database.ExecuteSqlRaw(ora_sql, ora_param);

                daCostcode.Fill(dt, (OracleRefCursor)op_costcode.Value);

                if (dt.Rows.Count == 0)
                    throw new Exception("No data found");

                foreach (DataRow dr in dt.Rows)
                {
                    // Timesheet Deatils
                    dsTimeSheet = new DataSet();
                    cmdTimeSheet = new OracleCommand();
                    cmdTimeSheet.Connection = oraConn;
                    cmdTimeSheet.CommandType = System.Data.CommandType.StoredProcedure;
                    cmdTimeSheet.Parameters.Clear();

                    cmdTimeSheet.CommandText = "rap_TimeSheet.get_timeSheet";
                    cmdTimeSheet.Parameters.Add("p_empno", OracleDbType.Varchar2).Value = empno.ToString();
                    cmdTimeSheet.Parameters.Add("p_costcode", OracleDbType.Varchar2).Value = dr["assign"].ToString();
                    cmdTimeSheet.Parameters.Add("p_yymm", OracleDbType.Varchar2).Value = yymm.ToString();
                    cmdTimeSheet.Parameters.Add("p_time_master", OracleDbType.RefCursor, ParameterDirection.Output);
                    cmdTimeSheet.Parameters.Add("p_time_daily", OracleDbType.RefCursor, ParameterDirection.Output);
                    cmdTimeSheet.Parameters.Add("p_time_ot", OracleDbType.RefCursor, ParameterDirection.Output);
                    cmdTimeSheet.Parameters.Add("p_total", OracleDbType.RefCursor, ParameterDirection.Output);

                    OracleDataAdapter daTimeSheet = new OracleDataAdapter(cmdTimeSheet);
                    daTimeSheet.TableMappings.Add("Table", "Master");
                    daTimeSheet.TableMappings.Add("Table1", "Normal_HH");
                    daTimeSheet.TableMappings.Add("Table2", "OT_HH");
                    daTimeSheet.TableMappings.Add("Table3", "TOT_HH");
                    cmdTimeSheet.ExecuteNonQuery();
                    daTimeSheet.Fill(dsTimeSheet);
                    daTimeSheet.Dispose();

                    // Employee Details
                    dsEmp = new DataSet();
                    cmdEmp = new OracleCommand("ngts_users.ngts_getempdetails", oraConn);
                    cmdEmp.CommandType = CommandType.StoredProcedure;
                    cmdEmp.Parameters.Clear();

                    cmdEmp.Parameters.Add("p_empno", OracleDbType.Varchar2).Value = empno.ToString();
                    cmdEmp.Parameters.Add("p_assign", OracleDbType.Varchar2).Value = dr["assign"].ToString();
                    cmdEmp.Parameters.Add("p_details", OracleDbType.RefCursor, ParameterDirection.Output);
                    OracleDataAdapter daEmp = new OracleDataAdapter(cmdEmp);
                    cmdEmp.ExecuteNonQuery();
                    daEmp.Fill(dsEmp, "EmpTable");
                    daEmp.Dispose();

                    // Holidays
                    dsHoliday = new DataSet();
                    cmdHoliday = new OracleCommand("rap_timesheet.get_holidays", oraConn);
                    cmdHoliday.CommandType = System.Data.CommandType.StoredProcedure;
                    cmdHoliday.Parameters.Clear();

                    cmdHoliday.Parameters.Add("p_yyyymm", OracleDbType.Varchar2).Value = yymm.ToString();
                    cmdHoliday.Parameters.Add("p_dayslist", OracleDbType.RefCursor, ParameterDirection.Output);
                    OracleDataAdapter daHoliday = new OracleDataAdapter(cmdHoliday);
                    cmdHoliday.ExecuteNonQuery();
                    daHoliday.Fill(dsHoliday, "HolidayTable");
                    daHoliday.Dispose();

                    //using (XLWorkbook wb = new XLWorkbook())
                    //{
                    x = dt.Rows.IndexOf(dr) + 1;
                    var ws = wb.Worksheet("Sheet" + x);
                    if (x < dt.Rows.Count)
                        ws.CopyTo("Sheet" + (x + 1));
                    //IXLWorksheet ws = wb.Worksheets.Add(dr["assign"].ToString());
                    //ws.Cell(1, 35).Value = "0190-015-03";           // AH1 - Form No
                    //ws.Cell(1, 35).DataType = XLDataType.Text;

                    string strDeptNo = string.Empty;
                    string strYYYYMM = string.Empty;
                    strDeptNo = dr["assign"].ToString();
                    strYYYYMM = yymm.ToString();

                    if (dsEmp.Tables["EmpTable"].Rows.Count > 0)
                    {
                        ws.Cell("Q2").Value = "'" + dsEmp.Tables["EmpTable"].Rows[0]["empno"].ToString().Substring(0, 1);                                  
                        ws.Cell("Q2").DataType = XLDataType.Text;
                        ws.Cell("R2").Value = "'" + dsEmp.Tables["EmpTable"].Rows[0]["empno"].ToString().Substring(1, 1);                                  
                        ws.Cell("R2").DataType = XLDataType.Text;
                        ws.Cell("S2").Value = "'" + dsEmp.Tables["EmpTable"].Rows[0]["empno"].ToString().Substring(2, 1);                                  
                        ws.Cell("S2").DataType = XLDataType.Text;
                        ws.Cell("T2").Value = "'" + dsEmp.Tables["EmpTable"].Rows[0]["empno"].ToString().Substring(3, 1);                                  
                        ws.Cell("T2").DataType = XLDataType.Text;
                        ws.Cell("U2").Value = "'" + dsEmp.Tables["EmpTable"].Rows[0]["empno"].ToString().Substring(4, 1);                                  
                        ws.Cell("U2").DataType = XLDataType.Text;

                        ws.Cell("V2").Value = dsEmp.Tables["EmpTable"].Rows[0]["name"].ToString();                                               

                        ws.Cell("AD3").Value = dsEmp.Tables["EmpTable"].Rows[0]["parent"].ToString().Substring(0, 1);                            
                        ws.Cell("AD3").DataType = XLDataType.Text;
                        ws.Cell("AE3").Value = dsEmp.Tables["EmpTable"].Rows[0]["parent"].ToString().Substring(1, 1);                            
                        ws.Cell("AE3").DataType = XLDataType.Text;
                        ws.Cell("AF3").Value = dsEmp.Tables["EmpTable"].Rows[0]["parent"].ToString().Substring(2, 1);                            
                        ws.Cell("AF3").DataType = XLDataType.Text;
                        ws.Cell("AG3").Value = dsEmp.Tables["EmpTable"].Rows[0]["parent"].ToString().Substring(3, 1);                            
                        ws.Cell("AG3").DataType = XLDataType.Text;

                        ws.Cell("AH3").Value = strDeptNo.ToString().Substring(0, 1);                          
                        ws.Cell("AH3").DataType = XLDataType.Text;
                        ws.Cell("AI3").Value = strDeptNo.ToString().Substring(1, 1);                          
                        ws.Cell("AI3").DataType = XLDataType.Text;
                        ws.Cell("AJ3").Value = strDeptNo.ToString().Substring(2, 1);                          
                        ws.Cell("AJ3").DataType = XLDataType.Text;
                        ws.Cell("AK3").Value = strDeptNo.ToString().Substring(3, 1);                          
                        ws.Cell("AK3").DataType = XLDataType.Text;                        

                        ws.Cell("AX3").Value = "'" + strYYYYMM.Substring(4, 1);
                        ws.Cell("AX3").DataType = XLDataType.Text;
                        ws.Cell("AY3").Value = "'" + strYYYYMM.Substring(5, 1);
                        ws.Cell("AY3").DataType = XLDataType.Text;
                        ws.Cell("AZ3").Value = "'" + strYYYYMM.Substring(2, 1);
                        ws.Cell("AZ3").DataType = XLDataType.Text;
                        ws.Cell("BA3").Value = "'" + strYYYYMM.Substring(3, 1);
                        ws.Cell("BA3").DataType = XLDataType.Text;
                    }

                    if (dsTimeSheet.Tables["Master"].Rows.Count > 0)
                    {
                        if (dsTimeSheet.Tables["Master"].Rows[0]["locked"].ToString() == "1")
                        {
                            ws.Cell("AQ1").Value = "X";
                            ws.Cell("AQ1").DataType = XLDataType.Text;
                        }

                        if (dsTimeSheet.Tables["Master"].Rows[0]["approved"].ToString() == "1")
                        {
                            ws.Cell("AQ2").Value = "X";
                            ws.Cell("AQ2").DataType = XLDataType.Text;
                        }

                        if (dsTimeSheet.Tables["Master"].Rows[0]["posted"].ToString() == "1")
                        {
                            ws.Cell("AQ3").Value = "X";
                            ws.Cell("AQ3").DataType = XLDataType.Text;
                        }

                        if (dsTimeSheet.Tables["Master"].Rows[0]["exceed"].ToString() == "1")
                        {
                            ws.Cell("AU1").Value = "X";
                            ws.Cell("AU1").DataType = XLDataType.Text;
                        }
                        ws.Cell("AA42").Value = dsTimeSheet.Tables["Master"].Rows[0]["remark"].ToString();                                   // G41 - Remarks
                        ws.Cell("AA42").DataType = XLDataType.Text;
                    }

                    if (dsTimeSheet.Tables["Normal_HH"].Rows.Count > 0)
                    {
                        Int32 rowNormal = 8;
                        foreach (DataRow drNormal in dsTimeSheet.Tables["Normal_HH"].Rows)
                        {
                            normalHours = 0;

                            ws.Cell(rowNormal, 1).Value = "'" + drNormal["projno"].ToString().Substring(0, 1);
                            ws.Cell(rowNormal, 1).DataType = XLDataType.Text;
                            ws.Cell(rowNormal, 2).Value = "'" + drNormal["projno"].ToString().Substring(1, 1);
                            ws.Cell(rowNormal, 2).DataType = XLDataType.Text;
                            ws.Cell(rowNormal, 3).Value = "'" + drNormal["projno"].ToString().Substring(2, 1);
                            ws.Cell(rowNormal, 3).DataType = XLDataType.Text;
                            ws.Cell(rowNormal, 4).Value = "'" + drNormal["projno"].ToString().Substring(3, 1);
                            ws.Cell(rowNormal, 4).DataType = XLDataType.Text;
                            ws.Cell(rowNormal, 5).Value = "'" + drNormal["projno"].ToString().Substring(4, 1);
                            ws.Cell(rowNormal, 5).DataType = XLDataType.Text;
                            ws.Cell(rowNormal, 6).Value = "'" + drNormal["projno"].ToString().Substring(5, 1);
                            ws.Cell(rowNormal, 6).DataType = XLDataType.Text;
                            ws.Cell(rowNormal, 7).Value = "'" + drNormal["projno"].ToString().Substring(6, 1);
                            ws.Cell(rowNormal, 7).DataType = XLDataType.Text;

                            ws.Cell(rowNormal, 8).Value = drNormal["wpcode"].ToString();
                            ws.Cell(rowNormal, 8).DataType = XLDataType.Text;

                            ws.Cell(rowNormal, 9).Value = drNormal["activity"].ToString().Substring(0, 1);
                            ws.Cell(rowNormal, 9).DataType = XLDataType.Text;
                            ws.Cell(rowNormal, 10).Value = drNormal["activity"].ToString().Substring(1, 1);
                            ws.Cell(rowNormal, 10).DataType = XLDataType.Text;
                            ws.Cell(rowNormal, 11).Value = drNormal["activity"].ToString().Substring(2, 1);
                            ws.Cell(rowNormal, 11).DataType = XLDataType.Text;
                            ws.Cell(rowNormal, 12).Value = drNormal["activity"].ToString().Substring(3, 1);
                            ws.Cell(rowNormal, 12).DataType = XLDataType.Text;
                            ws.Cell(rowNormal, 13).Value = drNormal["activity"].ToString().Substring(4, 1);
                            ws.Cell(rowNormal, 13).DataType = XLDataType.Text;
                            ws.Cell(rowNormal, 14).Value = drNormal["activity"].ToString().Substring(5, 1);
                            ws.Cell(rowNormal, 14).DataType = XLDataType.Text;
                            ws.Cell(rowNormal, 15).Value = drNormal["activity"].ToString().Substring(6, 1);
                            ws.Cell(rowNormal, 15).DataType = XLDataType.Text;

                            string arrNormal = drNormal["daily_hours"].ToString();
                            arrNormal = arrNormal.Replace("[", "");
                            arrNormal = arrNormal.Replace("]", "");
                            string[] decDailyHH = arrNormal.Split(',', StringSplitOptions.None);
                            for (int i = 0; i < decDailyHH.Length; i++)
                            {
                                if (decDailyHH[i].ToString() != "0")
                                {
                                    ws.Cell(rowNormal, i + 17).Value = Convert.ToDecimal(decDailyHH[i].ToString());
                                    normalHours = normalHours + Convert.ToDecimal(decDailyHH[i].ToString());
                                }
                                else
                                {
                                    ws.Cell(rowNormal, i + 17).Value = string.Empty;
                                }
                            }
                            ws.Cell(rowNormal, 48).Value = normalHours;
                            rowNormal += 1;
                        }
                    }

                    if (dsTimeSheet.Tables["OT_HH"].Rows.Count > 0)
                    {
                        Int32 rowOT = 30;
                        foreach (DataRow drOT in dsTimeSheet.Tables["OT_HH"].Rows)
                        {
                            otHours = 0;

                            ws.Cell(rowOT, 1).Value = "'" + drOT["projno"].ToString().Substring(0, 1);
                            ws.Cell(rowOT, 1).DataType = XLDataType.Text;
                            ws.Cell(rowOT, 2).Value = "'" + drOT["projno"].ToString().Substring(1, 1);
                            ws.Cell(rowOT, 2).DataType = XLDataType.Text;
                            ws.Cell(rowOT, 3).Value = "'" + drOT["projno"].ToString().Substring(2, 1);
                            ws.Cell(rowOT, 3).DataType = XLDataType.Text;
                            ws.Cell(rowOT, 4).Value = "'" + drOT["projno"].ToString().Substring(3, 1);
                            ws.Cell(rowOT, 4).DataType = XLDataType.Text;
                            ws.Cell(rowOT, 5).Value = "'" + drOT["projno"].ToString().Substring(4, 1);
                            ws.Cell(rowOT, 5).DataType = XLDataType.Text;
                            ws.Cell(rowOT, 6).Value = "'" + drOT["projno"].ToString().Substring(5, 1);
                            ws.Cell(rowOT, 6).DataType = XLDataType.Text;
                            ws.Cell(rowOT, 7).Value = "'" + drOT["projno"].ToString().Substring(6, 1);
                            ws.Cell(rowOT, 7).DataType = XLDataType.Text;

                            ws.Cell(rowOT, 8).Value = drOT["wpcode"].ToString();
                            ws.Cell(rowOT, 8).DataType = XLDataType.Text;

                            ws.Cell(rowOT, 9).Value = drOT["activity"].ToString().Substring(0, 1);
                            ws.Cell(rowOT, 9).DataType = XLDataType.Text;
                            ws.Cell(rowOT, 10).Value = drOT["activity"].ToString().Substring(1, 1);
                            ws.Cell(rowOT, 10).DataType = XLDataType.Text;
                            ws.Cell(rowOT, 11).Value = drOT["activity"].ToString().Substring(2, 1);
                            ws.Cell(rowOT, 11).DataType = XLDataType.Text;
                            ws.Cell(rowOT, 12).Value = drOT["activity"].ToString().Substring(3, 1);
                            ws.Cell(rowOT, 12).DataType = XLDataType.Text;
                            ws.Cell(rowOT, 13).Value = drOT["activity"].ToString().Substring(4, 1);
                            ws.Cell(rowOT, 13).DataType = XLDataType.Text;
                            ws.Cell(rowOT, 14).Value = drOT["activity"].ToString().Substring(5, 1);
                            ws.Cell(rowOT, 14).DataType = XLDataType.Text;
                            ws.Cell(rowOT, 15).Value = drOT["activity"].ToString().Substring(6, 1);
                            ws.Cell(rowOT, 15).DataType = XLDataType.Text;

                            string arrOT = drOT["ot_hours"].ToString();
                            arrOT = arrOT.Replace("[", "");
                            arrOT = arrOT.Replace("]", "");
                            string[] decOTHH = arrOT.Split(',', StringSplitOptions.None);
                            for (int j = 0; j < decOTHH.Length; j++)
                            {
                                if (decOTHH[j].ToString() != "0")
                                {
                                    ws.Cell(rowOT, j + 17).Value = Convert.ToDecimal(decOTHH[j].ToString());
                                    otHours = otHours + Convert.ToDecimal(decOTHH[j].ToString());
                                }
                                else
                                {
                                    ws.Cell(rowOT, j + 17).Value = string.Empty;
                                }
                            }
                            ws.Cell(rowOT, 48).Value = otHours;
                            rowOT += 1;
                        }
                    }

                    // Apply Holidays
                    string arrHoliday = dsHoliday.Tables["HolidayTable"].Rows[0]["days"].ToString();
                    arrHoliday = arrHoliday.Replace("[", "");
                    arrHoliday = arrHoliday.Replace("]", "");
                    string[] strHoliday = arrHoliday.Split(',', StringSplitOptions.None);
                    for (int h = 0; h < strHoliday.Length; h++)
                    {
                        for (int p = 17; p < 48; p++)
                        {
                            if (Convert.ToInt32(ws.Cell(6, p).Value) == Convert.ToInt32(strHoliday[h].ToString()))
                            {
                                ws.Cell(6, p).Style.Fill.BackgroundColor = XLColor.LightGray;
                                ws.Range(8, p, 28, p).Style.Fill.BackgroundColor = XLColor.LightGray;
                                ws.Range(30, p, 40, p).Style.Fill.BackgroundColor = XLColor.LightGray;
                            }
                        }
                    }
                }

                using (MemoryStream ms = new MemoryStream())
                {
                    wb.SaveAs(ms);
                    byte[] buffer = ms.GetBuffer();
                    long length = ms.Length;
                    m_Bytes = ms.ToArray();
                }
                //}
                return m_Bytes;
            }
            catch
            {
                return m_Bytes;
                //return new { Result = "ERROR", Message = ex.Message };
            }
            finally
            {
                if ((oraConn != null))
                {
                    if (oraConn.State == ConnectionState.Open)
                        oraConn.Close();
                }
                if (dsEmp != null)
                {
                    dsEmp.Dispose();
                    cmdEmp.Parameters.Clear();
                    cmdEmp.Dispose();
                }

                if (dsHoliday != null)
                {
                    dsHoliday.Dispose();
                    cmdHoliday.Parameters.Clear();
                    cmdHoliday.Dispose();
                }

                if (dsTimeSheet != null)
                {
                    dsTimeSheet.Dispose();
                    cmdTimeSheet.Parameters.Clear();
                    cmdTimeSheet.Dispose();
                }

                if (cmd != null)
                {
                    cmd.Parameters.Clear();
                    cmd.Dispose();
                    dt.Dispose();
                }
            }
        }

        public byte[] getDownLoadTimesheetOld(string empno, string yymm)
        {
            OracleConnection oraConn = (OracleConnection)_dbContext.Database.GetDbConnection();
            if (oraConn == null || oraConn.State == ConnectionState.Closed)
                oraConn.Open();

            DataSet dsTimeSheet = null;
            DataSet dsEmp = null;
            DataSet dsHoliday = null;
            OracleCommand cmdTimeSheet = null;
            OracleCommand cmdEmp = null;
            OracleCommand cmdHoliday = null;
            byte[] m_Bytes = null;
            XLWorkbook wb = new XLWorkbook();
            try
            {
                OracleCommand cmd = oraConn.CreateCommand() as OracleCommand;
                string ora_sql = string.Empty;
                OracleParameter op_yymm = new OracleParameter("P_Yymm", OracleDbType.Varchar2, yymm.ToString(), ParameterDirection.Input);
                OracleParameter op_empno = new OracleParameter("P_Empno", OracleDbType.Varchar2, empno.ToString(), ParameterDirection.Input);
                cmd.Parameters.Add(op_yymm);
                cmd.Parameters.Add(op_empno);
                DataTable dt = new DataTable();
                ora_sql = string.Empty;

                ora_sql = @"
				select
					assign
				from
					time_mast
				where
					yymm = :P_Yymm and empno = :P_Empno
				order by
					assign";

                cmd.CommandText = ora_sql;
                cmd.CommandType = CommandType.Text;
                dt.Load(cmd.ExecuteReader());

                foreach (DataRow dr in dt.Rows)
                {
                    // Timesheet Deatils
                    dsTimeSheet = new DataSet();
                    cmdTimeSheet = new OracleCommand();
                    cmdTimeSheet.Connection = oraConn;
                    cmdTimeSheet.CommandType = System.Data.CommandType.StoredProcedure;
                    cmdTimeSheet.Parameters.Clear();

                    cmdTimeSheet.CommandText = "rap_TimeSheet.get_timeSheet";
                    cmdTimeSheet.Parameters.Add("p_empno", OracleDbType.Varchar2).Value = empno.ToString();
                    cmdTimeSheet.Parameters.Add("p_costcode", OracleDbType.Varchar2).Value = dr["assign"].ToString();
                    cmdTimeSheet.Parameters.Add("p_yymm", OracleDbType.Varchar2).Value = yymm.ToString();
                    cmdTimeSheet.Parameters.Add("p_time_master", OracleDbType.RefCursor, ParameterDirection.Output);
                    cmdTimeSheet.Parameters.Add("p_time_daily", OracleDbType.RefCursor, ParameterDirection.Output);
                    cmdTimeSheet.Parameters.Add("p_time_ot", OracleDbType.RefCursor, ParameterDirection.Output);
                    cmdTimeSheet.Parameters.Add("p_total", OracleDbType.RefCursor, ParameterDirection.Output);

                    OracleDataAdapter daTimeSheet = new OracleDataAdapter(cmdTimeSheet);
                    daTimeSheet.TableMappings.Add("Table", "Master");
                    daTimeSheet.TableMappings.Add("Table1", "Normal_HH");
                    daTimeSheet.TableMappings.Add("Table2", "OT_HH");
                    daTimeSheet.TableMappings.Add("Table3", "TOT_HH");
                    cmdTimeSheet.ExecuteNonQuery();
                    daTimeSheet.Fill(dsTimeSheet);
                    daTimeSheet.Dispose();

                    // Employee Details
                    dsEmp = new DataSet();
                    cmdEmp = new OracleCommand("ngts_users.ngts_getempdetails", oraConn);
                    cmdEmp.CommandType = CommandType.StoredProcedure;
                    cmdEmp.Parameters.Clear();

                    cmdEmp.Parameters.Add("p_empno", OracleDbType.Varchar2).Value = empno.ToString();
                    cmdEmp.Parameters.Add("p_assign", OracleDbType.Varchar2).Value = dr["assign"].ToString();
                    cmdEmp.Parameters.Add("p_details", OracleDbType.RefCursor, ParameterDirection.Output);
                    OracleDataAdapter daEmp = new OracleDataAdapter(cmdEmp);
                    cmdEmp.ExecuteNonQuery();
                    daEmp.Fill(dsEmp, "EmpTable");
                    daEmp.Dispose();

                    // Holidays
                    dsHoliday = new DataSet();
                    cmdHoliday = new OracleCommand("rap_timesheet.get_holidays", oraConn);
                    cmdHoliday.CommandType = System.Data.CommandType.StoredProcedure;
                    cmdHoliday.Parameters.Clear();

                    cmdHoliday.Parameters.Add("p_yyyymm", OracleDbType.Varchar2).Value = yymm.ToString();
                    cmdHoliday.Parameters.Add("p_dayslist", OracleDbType.RefCursor, ParameterDirection.Output);
                    OracleDataAdapter daHoliday = new OracleDataAdapter(cmdHoliday);
                    cmdHoliday.ExecuteNonQuery();
                    daHoliday.Fill(dsHoliday, "HolidayTable");
                    daHoliday.Dispose();

                    //var template = new XLTemplate(oAppSettings.Value.RAPAppSettings.ApplicationRepository + @"\Cmplx\Cc\CHA1STA6TM02.xlsx");

                    //string appPath = oAppSettings.Value.MyAppSettings.TimesheetXLTemplate;
                    //Directory.GetCurrentDirectory().ToString()  + "/Common/TimesheetTemplate.xlsx";
                    //var wb = template.Workbook;
                    //using (XLWorkbook wb = new XLWorkbook())
                    //{
                    IXLWorksheet ws = wb.Worksheets.Add(dr["assign"].ToString());
                    ws.Cell(1, 35).Value = "0190-015-03";           // AH1 - Form No
                    ws.Cell(1, 35).DataType = XLDataType.Text;

                    string strDeptNo = string.Empty;
                    string strYYYYMM = string.Empty;
                    strDeptNo = dr["assign"].ToString();
                    strYYYYMM = yymm.ToString();

                    if (dsEmp.Tables["EmpTable"].Rows.Count > 0)
                    {
                        ws.Cell(3, 15).Value = "'" + dsEmp.Tables["EmpTable"].Rows[0]["empno"].ToString();                                  // N3 - Employee No
                        ws.Cell(3, 15).DataType = XLDataType.Text;
                        ws.Cell(3, 18).Value = dsEmp.Tables["EmpTable"].Rows[0]["name"].ToString();                                         // Q3 - Employee Name
                        ws.Cell(3, 27).Value = dsEmp.Tables["EmpTable"].Rows[0]["parent"].ToString() + "-" + dsEmp.Tables["EmpTable"].Rows[0]["parentabbr"].ToString();           // Z3 - Parent - Abbr
                        ws.Cell(3, 27).DataType = XLDataType.Text;
                        ws.Cell(3, 31).Value = strDeptNo.ToString() + "-" + dsEmp.Tables["EmpTable"].Rows[0]["assignabbr"].ToString();         // AD3 - Assign - Abbr
                        ws.Cell(3, 31).DataType = XLDataType.Text;
                        ws.Cell(3, 36).Value = "'" + strYYYYMM.Substring(4, 2) + " / " + strYYYYMM.Substring(0, 4);                         // AI3 - Month / Year
                        ws.Cell(3, 36).DataType = XLDataType.Text;
                        ws.Cell(45, 8).Value = "printed on " + DateTime.Now.ToString("dd.MM.yyyy HH:mm:ss");                                // G45 - Remarks
                    }

                    if (dsTimeSheet.Tables["Master"].Rows.Count > 0)
                    {
                        ws.Cell(41, 8).Value = dsTimeSheet.Tables["Master"].Rows[0]["remark"].ToString();                                   // G41 - Remarks
                        ws.Cell(41, 8).DataType = XLDataType.Text;
                    }

                    if (dsTimeSheet.Tables["Normal_HH"].Rows.Count > 0)
                    {
                        Int32 rowNormal = 8;
                        foreach (DataRow drNormal in dsTimeSheet.Tables["Normal_HH"].Rows)
                        {
                            ws.Cell(rowNormal, 1).Value = "'" + drNormal["projno"].ToString();
                            ws.Cell(rowNormal, 1).DataType = XLDataType.Text;
                            ws.Cell(rowNormal, 2).Value = drNormal["wpcode"].ToString();
                            ws.Cell(rowNormal, 2).DataType = XLDataType.Text;
                            ws.Cell(rowNormal, 3).Value = drNormal["activity"].ToString();
                            ws.Cell(rowNormal, 3).DataType = XLDataType.Text;

                            string arrNormal = drNormal["daily_hours"].ToString();
                            arrNormal = arrNormal.Replace("[", "");
                            arrNormal = arrNormal.Replace("]", "");
                            string[] decDailyHH = arrNormal.Split(',', StringSplitOptions.None);
                            for (int i = 0; i < decDailyHH.Length; i++)
                            {
                                if (decDailyHH[i].ToString() != "0")
                                {
                                    ws.Cell(rowNormal, i + 4).Value = Convert.ToDecimal(decDailyHH[i].ToString());
                                }
                                else
                                {
                                    ws.Cell(rowNormal, i + 4).Value = string.Empty;
                                }
                            }
                            rowNormal += 1;
                        }
                    }

                    if (dsTimeSheet.Tables["OT_HH"].Rows.Count > 0)
                    {
                        Int32 rowOT = 30;
                        foreach (DataRow drOT in dsTimeSheet.Tables["OT_HH"].Rows)
                        {
                            ws.Cell(rowOT, 1).Value = "'" + drOT["projno"].ToString();
                            ws.Cell(rowOT, 1).DataType = XLDataType.Text;
                            ws.Cell(rowOT, 2).Value = drOT["wpcode"].ToString();
                            ws.Cell(rowOT, 2).DataType = XLDataType.Text;
                            ws.Cell(rowOT, 3).Value = drOT["activity"].ToString();
                            ws.Cell(rowOT, 3).DataType = XLDataType.Text;

                            string arrOT = drOT["ot_hours"].ToString();
                            arrOT = arrOT.Replace("[", "");
                            arrOT = arrOT.Replace("]", "");
                            string[] decOTHH = arrOT.Split(',', StringSplitOptions.None);
                            for (int j = 0; j < decOTHH.Length; j++)
                            {
                                if (decOTHH[j].ToString() != "0")
                                {
                                    ws.Cell(rowOT, j + 4).Value = Convert.ToDecimal(decOTHH[j].ToString());
                                }
                                else
                                {
                                    ws.Cell(rowOT, j + 4).Value = string.Empty;
                                }
                            }
                            rowOT += 1;
                        }
                    }

                    // Apply Holidays
                    string arrHoliday = dsHoliday.Tables["HolidayTable"].Rows[0]["days"].ToString();
                    arrHoliday = arrHoliday.Replace("[", "");
                    arrHoliday = arrHoliday.Replace("]", "");
                    string[] strHoliday = arrHoliday.Split(',', StringSplitOptions.None);
                    for (int h = 0; h < strHoliday.Length; h++)
                    {
                        for (int p = 4; p < 35; p++)
                        {
                            if (Convert.ToInt32(ws.Cell(5, p).Value) == Convert.ToInt32(strHoliday[h].ToString()))
                            {
                                ws.Cell(5, p).Style.Fill.BackgroundColor = XLColor.LightGray;
                                ws.Range(8, p, 28, p).Style.Fill.BackgroundColor = XLColor.LightGray;
                                ws.Range(30, p, 39, p).Style.Fill.BackgroundColor = XLColor.LightGray;
                            }
                        }
                    }
                }

                using (MemoryStream ms = new MemoryStream())
                {
                    wb.SaveAs(ms);
                    byte[] buffer = ms.GetBuffer();
                    long length = ms.Length;
                    m_Bytes = ms.ToArray();
                }
                //}
                return m_Bytes;
            }
            catch
            {
                return m_Bytes;
                //return new { Result = "ERROR", Message = ex.Message };
            }
            finally
            {
                if ((oraConn != null))
                {
                    if (oraConn.State == ConnectionState.Open)
                        oraConn.Close();
                }
                //dsEmp.Dispose();
                cmdEmp.Parameters.Clear();
                cmdEmp.Dispose();
                //dsHoliday.Dispose();
                cmdHoliday.Parameters.Clear();
                cmdHoliday.Dispose();
                //dsTimeSheet.Dispose();
                cmdTimeSheet.Parameters.Clear();
                cmdTimeSheet.Dispose();
            }
        }
    }
}