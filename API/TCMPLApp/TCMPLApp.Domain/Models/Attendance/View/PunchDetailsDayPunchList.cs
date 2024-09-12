using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;


namespace TCMPLApp.Domain.Models.Attendance
{
    [Serializable]
    public class PunchDetailsDayPunchList
    {

        [Display(Name = "Empno")]
        public string Empno { get; set; }
        
        [Display(Name = "Punch date")]
        public DateTime PunchDate { get; set; }
        
        [Display(Name = "Punch time")]
        public string PunchTime { get; set; }


        [Display(Name = "Office")]
        public string Office { get; set; }

    }
}
