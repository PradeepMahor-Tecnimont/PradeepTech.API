using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.DMS
{
    public class EmpDeskInMoreThanPlacesDataTableList
    {
        [Display(Name = "Emp no")]
        public string Empno { get; set; }

        [Display(Name = "Employee")]
        public string EmpName { get; set; }

        [Display(Name = "Desk id")]
        public string Deskid { get; set; }

        [Display(Name = "User in")]
        public string UserIn { get; set; }

        public decimal? RowNumber { get; set; }
        public decimal? TotalRow { get; set; }
    }
}