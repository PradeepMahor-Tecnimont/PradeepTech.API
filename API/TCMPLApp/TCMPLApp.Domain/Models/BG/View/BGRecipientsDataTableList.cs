using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.BG
{
    public class BGRecipientsDataTableList
    {       
        [Display(Name = "Group")]
        public string Grpname { get; set; }

        [Display(Name = "Employee no")]
        public string Empno { get; set; }

        [Display(Name = "Employee name")]
        public string Name { get; set; }

        [Display(Name = "Email")]
        public string Email { get; set; }

        public decimal? TotalRow { get; set; }

        public decimal RowNumber { get; set; }
    }
}