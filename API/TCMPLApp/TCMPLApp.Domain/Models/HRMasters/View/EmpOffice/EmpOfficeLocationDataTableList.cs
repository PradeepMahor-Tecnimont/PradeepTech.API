using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class EmpOfficeLocationDataTableList
    {
        public decimal RowNumber { get; set; }
        public decimal? TotalRow { get; set; }

        [Display(Name = "Employee no")]
        public string Empno { get; set; }

        [Display(Name = "Employee name")]
        public string Name { get; set; }

        [Display(Name = "Grade")]
        public string Grade { get; set; }

        [Display(Name = "Parent")]
        public string Parent { get; set; }

        [Display(Name = "Assign")]
        public string Assign { get; set; }

        [Display(Name = "Employee type")]
        public string Emptype { get; set; }

        [Display(Name = "Office Location")]
        public string EmpOfficeLocation { get; set; }

        [Display(Name = "Modified On")]
        public DateTime? ModifiedOn { get; set; }


    }

    public class EmpOfficeLocationXLDataTableList
    {

        [Display(Name = "Employee no")]
        public string Empno { get; set; }

        [Display(Name = "Employee name")]
        public string Name { get; set; }

        [Display(Name = "Grade")]
        public string Grade { get; set; }

        [Display(Name = "Parent")]
        public string Parent { get; set; }

        [Display(Name = "Assign")]
        public string Assign { get; set; }

        [Display(Name = "Employee type")]
        public string Emptype { get; set; }

        [Display(Name = "Email")]
        public string Email { get; set; }

        [Display(Name = "PersonId")]
        public string Personid { get; set; }

        [Display(Name = "Metaid")]
        public string Metaid { get; set; }

        [Display(Name = "Office Location")]
        public string EmpOfficeLocation { get; set; }

        [Display(Name = "From date")]
        public DateTime? FromDate { get; set; }

        [Display(Name = "Modified On")]
        public DateTime? ModifiedOn { get; set; }


    }

}


