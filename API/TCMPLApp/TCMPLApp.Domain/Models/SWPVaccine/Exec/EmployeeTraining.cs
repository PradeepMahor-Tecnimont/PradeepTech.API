using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.SWPVaccine
{
    public class EmployeeTraining
    {
        [Display(Name ="Empno")]
        public string Empno { get; set; }

        [Display(Name ="Employee Name")]
        public string EmployeeName { get; set; }
        
        [Display(Name ="Parent")]
        public string Parent { get; set; }
        
        [Display(Name ="Department Desc")]
        public string DeptDesc { get; set; }
        
        [Display(Name ="Grade")]
        public string Grade { get; set; }
        
        [Display(Name ="EmpType")]
        public string Emptype { get; set; }
        
        [Display(Name ="Security")]
        public Int32 Security { get; set; }
        
        [Display(Name ="SharePoint")]
        public Int32 Sharepoint16 { get; set; }
        
        [Display(Name ="OneDrive")]
        public Int32 Onedrive365 { get; set; }
        
        [Display(Name ="Teams")]
        public Int32 Teams { get; set; }
        
        [Display(Name ="Planner")]
        public Int32 Planner { get; set; }


    }
}
