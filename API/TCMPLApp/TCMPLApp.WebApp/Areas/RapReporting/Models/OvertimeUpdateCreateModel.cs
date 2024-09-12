using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using TCMPLApp.WebApp.Models;

namespace TCMPLApp.WebApp.Models
{
    public class OvertimeUpdateCreateModel
    {        
        public string Costcode { get; set; }
        public List<OTMast> addOT { get; set; }
        public List<OTMast> editOT { get; set; }
        public List<OTMast> deleteOT { get; set; }
    }

    public class OTMast
    {
        public string Costcode { get; set; }
        public string Yymm { get; set; }
        public byte? OT { get; set; }
    }
}