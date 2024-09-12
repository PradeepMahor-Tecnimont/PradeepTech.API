using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class ProspectiveEmployeesDataTableList
    {
        public decimal RowNumber { get; set; }
        public decimal? TotalRow { get; set; }

        public string KeyId { get; set; }

        [Display(Name = "Dept")]
        public string Dept { get; set; }
        
        [Display(Name = "Employee Name")]
        public string EmpName { get; set; }

        [Display(Name = "Office location")]
        public string OfficeLocation{ get; set; }

        [Display(Name = "Proposed Date")]
        public DateTime? ProposedDoj { get; set; }

        [Display(Name = "Revised Date")]
        public DateTime? RevisedDoj { get; set; }

        [Display(Name = "Joining Status")]
        public string JoinStatus{ get; set; }

        [Display(Name = "Tcmpl employee")]
        public string TcmplEmp{ get; set; }
        public decimal? DeleteAllowed { get; set; }

    }


    public class ProspectiveEmployeesXLDataTableList
    {
        public string EmployeeName { get; set; }
        public string Dept { get; set; }
        public string DeptName { get; set; }
        public DateTime? ProposedDoj { get; set; }
        public string JoiningOffice { get; set; }
        public string JoiningStatus { get; set; }
        public string JoinedAs { get; set; }
        public DateTime? Doj { get; set; }
        public string Grade { get; set; }
        public string Emptype { get; set; }
        public string Desgination { get; set; }

    }

}
