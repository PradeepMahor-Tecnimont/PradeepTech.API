using System;
using System.ComponentModel.DataAnnotations;
using System.Diagnostics.CodeAnalysis;

namespace RapReportingApi.Models.rpt
{
    public partial class Auditor
    {
        public string Company { get; set; }
        public string Tmagrp { get; set; }
        public string Emptype { get; set; }
        public string Location { get; set; }

        [Key]
        public string Yymm { get; set; }

        public string Costcode { get; set; }
        public string Projno { get; set; }
        public string Name { get; set; }
        public decimal Hours { get; set; }
        public decimal Othours { get; set; }
        public decimal Tothours { get; set; }
    }

    public class MJMReport
    {
        public string Yymm { get; set; }

        [Key]
        public string Assign { get; set; }

        public string Assignname { get; set; }
        public string Projno { get; set; }
        public string Projname { get; set; }
        public decimal Tothrs { get; set; }
    }

    public class MJAMReport
    {
        public string Yymm { get; set; }

        [Key]
        public string Assign { get; set; }

        public string Projno { get; set; }
        public string Projname { get; set; }
        public string Activity { get; set; }
        public string Actname { get; set; }
        public decimal Tothrs { get; set; }
    }

    public class DUPLSTA6Report
    {
        public string Yymm { get; set; }

        [Key]
        public string Assign { get; set; }

        public string Empno { get; set; }
        public string Empname { get; set; }
        public string Projno { get; set; }
        public string Activity { get; set; }
        public decimal Nhrs { get; set; }
        public decimal Ohrs { get; set; }
    }

    public class CCPOSTDETReport
    {
        public string Emptype { get; set; }

        [Key]
        public string Assign { get; set; }

        public string Costname { get; set; }
        public string Hod { get; set; }
        public string Desc1 { get; set; }
        public string Empno { get; set; }
        public string Empname { get; set; }

        [AllowNull]
        public DateTime? Dol { get; set; }
    }

    public partial class MJEAMReport
    {
        public string yymm { get; set; }

        [Key]
        public string assign { get; set; }

        public string projno { get; set; }
        public string projname { get; set; }
        public string empno { get; set; }
        public string empname { get; set; }
        public string activity { get; set; }
        public decimal nhrs { get; set; }
        public decimal ohrs { get; set; }
    }

    public partial class MHrsExceedReport
    {
        public string Yymm { get; set; }
        public string Empno { get; set; }
        public string Name { get; set; }

        [Key]
        public string Assign { get; set; }

        public string Projno { get; set; }
        public decimal Actual { get; set; }
        public decimal OtHours { get; set; }
        public decimal Tot { get; set; }
    }

    public partial class LeaveReport
    {
        public string Yymm { get; set; }
        public string Empno { get; set; }
        public string Name { get; set; }

        [Key]
        public string Assign { get; set; }

        public string Projno { get; set; }
        public Single? D1 { get; set; }
        public Single? D2 { get; set; }
        public Single? D3 { get; set; }
        public Single? D4 { get; set; }
        public Single? D5 { get; set; }
        public Single? D6 { get; set; }
        public Single? D7 { get; set; }
        public Single? D8 { get; set; }
        public Single? D9 { get; set; }
        public Single? D10 { get; set; }
        public Single? D11 { get; set; }
        public Single? D12 { get; set; }
        public Single? D13 { get; set; }
        public Single? D14 { get; set; }
        public Single? D15 { get; set; }
        public Single? D16 { get; set; }
        public Single? D17 { get; set; }
        public Single? D18 { get; set; }
        public Single? D19 { get; set; }
        public Single? D20 { get; set; }
        public Single? D21 { get; set; }
        public Single? D22 { get; set; }
        public Single? D23 { get; set; }
        public Single? D24 { get; set; }
        public Single? D25 { get; set; }
        public Single? D26 { get; set; }
        public Single? D27 { get; set; }
        public Single? D28 { get; set; }
        public Single? D29 { get; set; }
        public Single? D30 { get; set; }
        public Single? D31 { get; set; }
    }

    public partial class OddTimesheetReport
    {
        public string Parent { get; set; }
        public string Yymm { get; set; }
        public string Empno { get; set; }
        public string Name { get; set; }

        [Key]
        public string Assign { get; set; }

        public string Projno { get; set; }
        public string Wpcode { get; set; }
        public string Activity { get; set; }
        public Single? Total { get; set; }
    }

    public partial class NotPostedTimesheetReport
    {
        public string Yymm { get; set; }
        public string Empno { get; set; }
        public string Name { get; set; }
        public string Parent { get; set; }

        [Key]
        public string Assign { get; set; }

        public string Locked { get; set; }
        public string Posted { get; set; }
        public string Company { get; set; }
        public string Remarks { get; set; }
        public Single Hrs { get; set; }
        public Single OTHrs { get; set; }
    }
}