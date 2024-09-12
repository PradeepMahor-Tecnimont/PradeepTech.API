using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;

namespace TCMPLApp.Domain.Models.RapReporting.Exec
{
    public class TSShiftProjectManhoursTimeOTDataTableList
    {
        public string Yymm { get; set; }

        public string Empno { get; set; }

        public string Name { get; set; }

        public string Parent { get; set; }

        public string Assign { get; set; }

        [Display(Name = "Project")]
        public string Projno { get; set; }

        [Display(Name = "Project name")]
        public string ProjnoName { get; set; }

        [Display(Name = "WP Code")]
        public string Wpcode { get; set; }

        public string Activity { get; set; }

        [Display(Name = "1")]
        public decimal? D1 { get; set; }

        [Display(Name = "2")]
        public decimal? D2 { get; set; }

        [Display(Name = "3")]
        public decimal? D3 { get; set; }

        [Display(Name = "4")]
        public decimal? D4 { get; set; }

        [Display(Name = "5")]
        public decimal? D5 { get; set; }

        //[Display(Name = "6")]
        //public decimal? D6 { get; set; }

        //[Display(Name = "7")]
        //public decimal? D7 { get; set; }

        //[Display(Name = "8")]
        //public decimal? D8 { get; set; }

        //[Display(Name = "9")]
        //public decimal? D9 { get; set; }

        //[Display(Name = "10")]
        //public decimal? D10 { get; set; }

        //[Display(Name = "11")]
        //public decimal? D11 { get; set; }

        //[Display(Name = "12")]
        //public decimal? D12 { get; set; }

        //[Display(Name = "13")]
        //public decimal? D13 { get; set; }

        //[Display(Name = "14")]
        //public decimal? D14 { get; set; }

        //[Display(Name = "15")]
        //public decimal? D15 { get; set; }

        //[Display(Name = "16")]
        //public decimal? D16 { get; set; }

        //[Display(Name = "17")]
        //public decimal? D17 { get; set; }

        //[Display(Name = "18")]
        //public decimal? D18 { get; set; }

        //[Display(Name = "19")]
        //public decimal? D19 { get; set; }

        //[Display(Name = "20")]
        //public decimal? D20 { get; set; }

        //[Display(Name = "21")]
        //public decimal? D21 { get; set; }

        //[Display(Name = "22")]
        //public decimal? D22 { get; set; }

        //[Display(Name = "23")]
        //public decimal? D23 { get; set; }

        //[Display(Name = "24")]
        //public decimal? D24 { get; set; }

        //[Display(Name = "25")]
        //public decimal? D25 { get; set; }

        //[Display(Name = "26")]
        //public decimal? D26 { get; set; }

        //[Display(Name = "27")]
        //public decimal? D27 { get; set; }

        //[Display(Name = "28")]
        //public decimal? D28 { get; set; }

        //[Display(Name = "29")]
        //public decimal? D29 { get; set; }

        //[Display(Name = "30")]
        //public decimal? D30 { get; set; }

        //[Display(Name = "31")]
        //public decimal? D31 { get; set; }

        [Display(Name = "Total")]
        public decimal? Total { get; set; }

        [Display(Name = "Group")]
        public string Grp { get; set; }

        public string Company { get; set; }

        [Display(Name = "Status")]
        public string Status { get; set; }

        [Display(Name = "Remarks")]
        public string Remarks { get; set; }


    }
}
