using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Data;

namespace TCMPLApp.WebApp.Models
{

    public class LoAAddendumAppointmentExcelViewModel
    {       

        public List<DataRows> Data { get; set; }

        public LoAAddendumAppointmentExcelViewModel()
        {
            this.Data = new List<DataRows>();
        }
    }

    public class DataRows
    {
        [Display(Name = "Employee")]
        public string Empno { get; set; }

        public string EmpName { get; set; }

        [Display(Name = "Parent")]
        public string Parent { get; set; }

        [Display(Name = "Assign")]
        public string Assign { get; set; }

        [Display(Name = "Employee Type")]
        public string Emptype { get; set; }
                
        [Display(Name = "Acceptance Status")]
        public string AcceptanceStatus { get; set; }

        public string EmailStatus { get; set; }

        [Display(Name = "Acceptance Date")]
        public DateTime? AcceptanceDate { get; set; }
    }
}
