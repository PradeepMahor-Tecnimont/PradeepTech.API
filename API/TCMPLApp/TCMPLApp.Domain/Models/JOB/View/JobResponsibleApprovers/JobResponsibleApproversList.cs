using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.JOB
{
    public class JobResponsibleApproversList
    {        
        [Display(Name = "Job No")]
        public string Projno { get; set; }

        [Display(Name = "Responsible")]
        public string ResponsibleName { get; set; }

        [Display(Name = "Employee")]
        public string Employee { get; set; }

        public string JobResponsibleRoleId { get; set; }
    }
}