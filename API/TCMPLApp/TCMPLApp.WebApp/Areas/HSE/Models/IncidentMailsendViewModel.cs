using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.WebApp.Models
{
    public class IncidentMailsendViewModel
    {

        [Required]
        [Display(Name = "Id")]
        public string Reportid { get; set; }

        [Required]
        [Display(Name = "Recipients")]
        public string Recipients { get; set; }       

    }


}