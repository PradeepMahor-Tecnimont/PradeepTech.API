using System;
using System.ComponentModel.DataAnnotations;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models
{
    public class NavratriRSVPDetail : DBProcMessageOutput
    {   
        public string PEmpno { get; set; }
        public decimal? PAttend { get; set; }       
        public decimal? PBus { get; set; }      
        public decimal? PDinner { get; set; }
    }
}