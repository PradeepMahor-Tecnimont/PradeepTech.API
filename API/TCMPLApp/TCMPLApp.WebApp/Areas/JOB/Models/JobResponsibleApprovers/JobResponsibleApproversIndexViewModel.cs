using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models;
using TCMPLApp.WebApp.Models;

namespace TCMPLApp.WebApp.Models
{
    public class JobResponsibleApproversIndexViewModel : TCMPLApp.Domain.Models.JOB.JobResponsibleApproversList
    {        
        public IEnumerable<ProfileAction> ProjectActions { get; set; }    
                
    }
}
