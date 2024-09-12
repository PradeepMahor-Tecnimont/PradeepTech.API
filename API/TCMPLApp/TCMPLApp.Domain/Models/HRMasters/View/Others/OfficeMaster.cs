using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class OfficeMaster
    {
        [Required]        
        public string Office { get; set; }
	
        [Required]        
        public string Name { get; set; }

        public int? Emps { get; set; }
    }
}
