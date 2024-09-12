using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class EmployeeDeleteDataTableList 
    {

        public decimal RowNumber { get; set; }

        public decimal? TotalRow { get; set; }

        [Display(Name = "Key id")]
        public string Keyid { get; set; }

        [Display(Name = "Employee no")]
        public string Empno { get; set; }

        [Display(Name = "Employee name")]
        public string Name { get; set; }
                
        public string Createdby { get; set; }

        [Display(Name = "Request by")]
        public string Createdbyname { get; set; }

        [Display(Name = "Request date")]
        public DateTime? Createdon { get; set; }

        public decimal? Isapproved { get; set; }

        [Display(Name = "Approved by")]
        public string Approvedby { get; set; }

        [Display(Name = "Approved on")]
        public DateTime? Approvedon { get; set; }
    }
}
