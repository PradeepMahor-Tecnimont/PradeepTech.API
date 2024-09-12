using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;
using System.Collections;

namespace TCMPLApp.Domain.Models.SWP
{
    public class EmployeeProjectMappingDataTableList
    {
        [Display(Name = "Id")]
        public string Keyid { get; set; }

        [Display(Name = "Empno")]
        public string Empno { get; set; }

        [Display(Name = "Employee name")]
        public string Empname { get; set; }


        [Display(Name = "Project no")]
        public string Projno { get; set; }

        [Display(Name = "Project name")]
        public string Projname { get; set; }

        public decimal? TotalRow { get; set; }

        public decimal RowNumber { get; set; }
    }
}