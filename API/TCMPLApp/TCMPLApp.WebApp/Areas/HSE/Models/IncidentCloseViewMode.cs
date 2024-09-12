using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.WebApp.Models
{
    public class IncidentCloseViewModel
    {
        public string Reportid { get; set; }
                
        [Display(Name = "Corrective actions")]
        public string CorrectiveActions { get; set; }

        [Display(Name = "Closer")]
        public string Closer { get; set; }

        [Display(Name = "Closer date")]
        [DisplayFormat(ApplyFormatInEditMode = true, DataFormatString = "{0:dd-MMM-yyyy}")]
        public DateTime? CloserDate { get; set; }

        [Display(Name = "Attchment link")]
        public string AttchmentLink { get; set; }


    }


}