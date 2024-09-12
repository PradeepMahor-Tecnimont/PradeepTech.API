using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.HSE
{
    public class IncidentMailsendList
    {
        
        [Display(Name = "Role")]
        public string Role { get; set; }       

        [Display(Name = "Email")]
        public string Email { get; set; }       

    }


}